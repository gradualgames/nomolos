.include "flags.inc"
.include "ram.inc"
.include "zp.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "camera.inc"
.include "geotests.inc"
.include "fixed_bank_data.inc"
.include "entity.inc"

.include "sprite.inc"

.segment "CODE"

;loads in a set of groups of chr data (usually used as a sprite sheet)
;expects w2 to contain the address of the list of entity def indices.
;the group set consists of a count for the number of groups (up to 255)
;and then word addresses thereafter.
.proc entity_load_chr_groups
entity_set_address = w2
group_address = w0
group_chr_count = w3
previous_entity_chr_offset_index = b3
current_entity_chr_offset_index = b4
counter = b0
current_chr_offset = b1

  ;clear the current chr offset
  lda #0
  sta current_chr_offset

  ;load the count
  ldy #0
  lda (entity_set_address),y
  sta counter
  iny

load_next_entity:
  ;load the next entity index and save it in x for indexing soon
  lda (entity_set_address),y
  tax
  dex ;entity indices count from 1, correct for this
  stx current_entity_chr_offset_index

  ;save y
  tya
  pha

  ;store the current_chr_offset in the corresponding entity_chr_offsets
  ;entry
  lda current_chr_offset
  sta entity_chr_offsets,x

  ;multiply the entity index by 2 to get the correct offset
  lda current_entity_chr_offset_index
  asl
  ;look up the address of the chr data in the entity_chr_definition_table
  tax
  ;transfer the address of the chr data so we can load the data
  lda entity_chr_definition_table,x
  sta group_address
  sta previous_entity_chr_offset_index
  lda entity_chr_definition_table+1,x
  sta group_address+1

  ;if high byte of group address is zero, we can assume that
  ;we can interpret this information as "use the chr offset calculated
  ;into entity_chr_offsets at this index". This is for entities that
  ;share chr data chunks.
  bne is_chr_address

  ;high byte of group address was zero. use the low byte as an index
  ;into entity_chr_offsets and then copy it to the current location

  ldx previous_entity_chr_offset_index
  dex ;entity indices count from 1, correct for this
  lda entity_chr_offsets,x

  ldx current_entity_chr_offset_index
  sta entity_chr_offsets,x

  jmp entity_opcode_test_done

is_chr_address:
  ;save off chr count to use later
  ldy #0
  lda (group_address),y
  sta group_chr_count
  iny
  lda (group_address),y
  sta group_chr_count+1

  ;do a 16 bit right shift 4 times to divide by 16,
  ;then low byte is true nametable count.

  clc
  lsr group_chr_count+1
  ror group_chr_count
  lsr group_chr_count+1
  ror group_chr_count
  lsr group_chr_count+1
  ror group_chr_count
  lsr group_chr_count+1
  ror group_chr_count

  ;load the chr data
  jsr ppu_load_chr_amount

  ;if the count was not destroyed (located at group_address)
  ;use it to add to the current_chr_offset
  clc
  lda current_chr_offset
  adc group_chr_count
  sta current_chr_offset

entity_opcode_test_done:

  ;restore y and increment it
  pla
  tay
  iny

  dec counter
  bne load_next_entity


;loads a specified amount of chr data into VRAM starting at the current VRAM location.
;expects w0 to contain the address of the chr data.
;uses w1 to contain the number of bytes to copy from this location.
;.proc ppu_load_chr_amount

  rts
.endproc

;expects y to say how many times to permute the random
;number
.proc entity_get_next_prn

: lda entity_prng_seed
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor #$1d
noEor:
  sta entity_prng_seed
  dey
  bne :-

  rts
.endproc

;compares entity's X coordinate to min and max explored camera x
;coordinates. Kills entity if it is within this range. This can
;be used for powerups that should only ever show up when first
;found.
.proc entity_kill_if_already_seen

  ;compare to max explored x. if result is negative, entity should not be
  ;killed because it is outside the range
  sec
  lda camera_max_scroll_x
  sbc entity_instances+entity_instance::position_x,x
  lda camera_max_scroll_x+1
  sbc entity_instances+entity_instance::position_x+1,x
  bmi do_not_kill_entity

  ;compare to min explored x. if result is positive, entity should not be
  ;killed because it is outside the range
  sec
  lda camera_min_scroll_x
  sbc entity_instances+entity_instance::position_x,x
  lda camera_min_scroll_x+1
  sbc entity_instances+entity_instance::position_x+1,x
  bpl do_not_kill_entity

kill_entity:

  lda #0
  sta entity_instances+entity_instance::alive,x

  rts

do_not_kill_entity:

  rts

.endproc

;draws entity's animation.
;expects w2 to contain address of animation to draw
;expects b2 to contain flags for whether to flip the sprite. e.g. #%01000000 to flip
.proc entity_draw_anim
  ;load address of animation object into w1
  lda #<(entity_instances+entity_instance::animation_object)
  sta w1
  lda #>(entity_instances+entity_instance::animation_object)
  sta w1+1

  ;get the index into a
  txa
  clc
  ;do a 16 bit add onto the address with this index
  adc w1
  sta w1
  lda w1+1
  adc #0
  sta w1+1

  jsr sprite_update_animation

  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_animation_16bit
  rts
.endproc

.proc entity_reset_anim
  lda #1
  sta entity_instances+entity_instance::animation_object,x
  lda #$ff
  sta entity_instances+entity_instance::animation_object+1,x
  rts
.endproc

;kills current entity located at entity_instances,x.
;also decrements entity count at entity_counters + value at entity_instances+entity_instance::index,x
.proc entity_kill

  lda #0
  sta entity_instances+entity_instance::alive,x

  ;save x
  txa
  pha

  ;get zero based index of entity
  lda entity_instances+entity_instance::index,x

  ;decrement counter for this entity
  tax
  dec entity_counters,x

  ;restore x
  pla
  tax

  rts
.endproc

;returns positive if entity must turn right to face nomolos,
;negative if entity must turn left.
.proc entity_test_face_nomolos

  ;compare entity x position to nomolos x position to decide direction
  sec
  lda nomolos_map_x+1
  sbc entity_instances+entity_instance::position_x,x
  lda nomolos_map_x+2
  sbc entity_instances+entity_instance::position_x+1,x
  bpl entity_will_go_right
entity_will_go_left:
  ;set negative flag
  lda #$ff
  rts
entity_will_go_right:
  ;clear negative flag
  lda #$01
  rts

.endproc

;tests whether an entity is a certain distance offscreen
;uses b5
;a set zero flag indicates the entity was in a death zone.
.proc entity_test_death_zone

  ;if upper byte is zero, the entity is not in the death zone (it is on screen)
  lda entity_screen_x+1
  beq entity_not_in_death_zone

  ;otherwise, do test the lower byte
  lda entity_screen_x
  and #%11000000

  cmp #%00000000
  beq entity_not_in_death_zone

  cmp #%11000000
  beq entity_not_in_death_zone

entity_is_in_death_zone:

  ;set zero flag so beq will take a branch in following code
  lda #0

  rts

entity_not_in_death_zone:

  ;clear zero flag so beq will not take a branch in following code
  lda #1

  rts
  
.endproc

;tests whether an entity is a certain distance offscreen
;uses b5
;a set zero flag indicates the entity was in a death zone.
.proc entity_item_test_death_zone

  ;if upper byte is -1, 0, or 1, the entity is not in the death zone. Anything outside of this means death.
  lda entity_screen_x+1
  beq entity_not_in_death_zone
  cmp #$01
  beq entity_not_in_death_zone
  cmp #$ff
  beq entity_not_in_death_zone

entity_is_in_death_zone:

  ;set zero flag so beq will take a branch in following code
  lda #0

  rts

entity_not_in_death_zone:

  ;clear zero flag so beq will not take a branch in following code
  lda #1

  rts
.endproc

;assumes b2 and b3 represent the width and height of the calling entity
.proc entity_test_collision_hitbox

  .ifdef _16BIT_COLLISIONS
  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_screen_x
  sta w2
  lda entity_screen_x+1
  sta w2+1
  lda entity_screen_y
  sta w3
  lda entity_screen_y+1
  sta w3+1

  ;transfer Hitbox rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolos_attack_rect_x
  sta w4
  lda nomolos_attack_rect_x+1
  sta w4+1
  lda nomolos_attack_rect_y
  sta w5
  lda nomolos_attack_rect_y+1
  sta w5+1
  lda nomolos_attack_rect_width
  sta b4
  lda nomolos_attack_rect_height
  sta b5

  jsr geotests_rect_in_rect_16bit
  .else

  ;transfer entity rectangle to w2 = top left x, y and w3 = bot right x, y

  ;left
  lda entity_screen_x
  sta w2

  ;right
  clc
  adc b2
  sta w3

  ;top
  lda entity_screen_y
  sta w2+1

  ;bottom
  clc
  adc b3
  sta w3+1

  ;transfer Hitbox rectangle to w4 = top left x, y and w5 = bot right x, y

  ;left
  lda nomolos_attack_rect_x
  sta w4

  ;right
  clc
  adc nomolos_attack_rect_width
  sta w5

  ;top
  lda nomolos_attack_rect_y
  sta w4+1

  ;bottom
  clc
  adc nomolos_attack_rect_height
  sta w5+1

  jsr geotests_rect_in_rect

  .endif

  rts
.endproc

;assumes b2 and b3 represent the width and height of the current entity
.proc entity_test_collision_nomolos

  .ifdef _16BIT_COLLISIONS
  ;transfer Deentle rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_screen_x
  sta w2
  lda entity_screen_x+1
  sta w2+1
  lda entity_screen_y
  sta w3
  lda entity_screen_y+1
  sta w3+1

  ;transfer Nomolos rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolos_screen_x
  sta w4
  lda nomolos_screen_x+1
  sta w4+1
  lda nomolos_screen_y
  sta w5
  lda nomolos_screen_y+1
  sta w5+1
  lda #nomolos_width
  sta b4
  lda #nomolos_height
  sta b5

  jsr geotests_rect_in_rect_16bit
  .else

  ;transfer entity rectangle to w2 = top left x, y and w3 = bot right x, y

  ;left
  lda entity_screen_x
  sta w2

  ;right
  clc
  adc b2
  sta w3

  ;top
  lda entity_screen_y
  sta w2+1

  ;bottom
  clc
  adc b3
  sta w3+1

  ;transfer nomolos rectangle to w4 = top left x, y and w5 = bot right x, y

  ;left
  lda nomolos_screen_x
  sta w4

  ;right
  clc
  adc #nomolos_width
  sta w5

  ;top
  lda nomolos_screen_y
  sta w4+1

  ;bottom
  clc
  adc #nomolos_height
  sta w5+1

  jsr geotests_rect_in_rect

  .endif

  rts
.endproc

.proc entity_compute_screen_coordinates
  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  sta w1+1
  jsr camera_to_screen_coords

  ;save screen coordinates for use later
  lda w0
  sta entity_screen_x
  lda w0+1
  sta entity_screen_x+1
  lda w1
  sta entity_screen_y
  lda w1+1
  sta entity_screen_y+1
  rts
.endproc

;This routine indirectly jumps to every update routine for every live entity.
;The entities are expected to jump back to returnFromEntityUpdate when they
;are finished.
.proc entity_update_all

  ;switch to the actor and entity bank
  ldy #level_data_struct::nomolos_entity_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;start at last entity
  ldy #last_entity
nextEntity:
  ;save y
  tya
  pha

  ;multiply by 4 to get the entity RAM object offset
  asl
  asl
  asl
  asl
  tax
  lda entity_instances+entity_instance::alive,x
  beq skipUpdate
  ;if we arrive here, x points to a live entity

  ;load the entity index
  lda entity_instances+entity_instance::index,x
  ;multiply the entity index by 4
  asl
  asl
  tay
  ;now y points to the entity definition

  ;load low byte of update routine
  lda (base_address_entity_definition_table),y
  ;might as well use w0..
  sta w0
  ;point to high byte of update routine
  iny
  ;load high byte of update routine
  lda (base_address_entity_definition_table),y
  ;put the high byte into w0
  sta w0+1

  ;jump to the entity update routine indirectly
  jsr indirectJsrW0

  ;entities are expected to return here.
skipUpdate:
  ;restore y
  pla
  tay
  ;iterate to next entity
  dey
  bpl nextEntity

  rts

.endproc

.proc indirectJsrW0
  jmp (w0)
.endproc

;This routine initializes the entity pool. All this
;entails is filling the first byte of every 16 byte chunk with zero.
.proc entity_init_all

  ldx #$1F
  lda #$00
:
  sta entity_counters,x
  dex
  bpl :-

  ldx #$0f
:
  ;multiply the index by 16
  txa
  asl
  asl
  asl
  asl
  tay
  lda #$00
  sta entity_instances+entity_instance::alive, y
  dex
  bpl :-
  rts
.endproc

;This routine spawns a single entity. It works by first searching
;for the first "dead" entity in the entity_instances. When it finds this
;dead entity, it fills it according to the entity_instance struct.

;the following parameters are expected:
;b0 = index of entity definition to spawn
;w0 = position_x
;b1 = position_y

;the following outputs can be retrieved after calling this function:
;b3 - index of entity instance just spawned

do_not_spawn:

  ;restore regs
  pla
  tay
  pla
  tax
  pla

  rts

.proc entity_spawn

  ;save regs
  pha
  txa
  pha
  tya
  pha

  ;if 0 is passed in, we are not to spawn an entity.
  lda b0
  beq do_not_spawn

  ;subtract from entity index to get zero based entity index
  dec b0

  ;if entity counter for specified entity is greater than max allowed, do not spawn.
  lda b0
  tax
  ;multiply by 4 to get offset from entity definition table
  asl
  asl
  tay
  ;point y at the max allowed entities entry
  iny
  iny
  lda (base_address_entity_definition_table),y
  cmp entity_counters,x
  beq do_not_spawn

  ;start at the last entity
  ldy #last_entity
:
  tya
  asl
  asl
  asl
  asl
  tax
  lda entity_instances+entity_instance::alive,x
  beq :+  ;found a dead entity, jump out with current value of x
  dey
  bpl :-
:
  ;when we get here we are pointing at a dead entity with x
  tya
  bmi do_not_spawn

  ;save x
  txa
  pha

  ;get entity index into x
  lda b0
  tax

  ;increment the entity count
  inc entity_counters,x

  ;restore x
  pla
  tax
  
  ;store the index of the spawned entity instance for whomever needs it after
  sta b3

  ;make the entity alive. ALIVE! MUA HUAH HAH HAH
  lda #$01
  sta entity_instances+entity_instance::alive,x

  ;store the kind of entity this is
  lda b0
  sta entity_instances+entity_instance::index,x

  ;now that we know the kind of entity this is, we must look up
  ;the entity and pull out its initialXOffset and initialYOffset,
  ;add these to the input parameters, and store them in position_x and position_y.

  ;;a holds the entity index, so multiply it by 4 to get an entity offset
  ;asl
  ;asl
  ;put the entity offset into y
  ;tay

  ;;skip the UpdateRoutine, we're not interested in it here
  ;iny
  ;iny

  ; ;store the initial X offset in b2 for now
  ; lda (base_address_entity_definition_table),y
  ; sta b2

  ; ;load the low byte of the x parameter, and do a 16 bit subtract from this
  ; sec
  ; lda w0
  ; sbc b2
  ; sta w0
  ; lda w0+1
  ; sbc #0
  ; sta w0+1

  ;now w0 should have the spawn_position_x value
  lda w0
  sta entity_instances+entity_instance::spawn_position_x,x
  lda w0+1
  sta entity_instances+entity_instance::spawn_position_x+1,x

  ; ;load initial y offset
  ; iny
  ; ;load the initial y offset and store it in b2 for now
  ; lda (base_address_entity_definition_table),y
  ; sta b2

  ; ;subtract this from the y parameter
  ; sec
  ; lda b1
  ; sbc b2
  ; sta b1  ;store result in y parameter

  ;now b1 should have the spawn_position_y value
  lda b1
  sta entity_instances+entity_instance::spawn_position_y,x

  ;load position_x_fine
  lda #$00
  sta entity_instances+entity_instance::position_x_fine,x
  ;load position_x
  lda w0
  sta entity_instances+entity_instance::position_x,x
  lda w0+1
  sta entity_instances+entity_instance::position_x+1,x

  ;load position_y_fine
  lda #$00
  sta entity_instances+entity_instance::position_y_fine,x
  ;load position_y
  lda b1
  sta entity_instances+entity_instance::position_y,x
  lda #0
  sta entity_instances+entity_instance::position_y+1,x

  ;load initial state (always zero)
  lda #0
  ;point to state variable in entity entry
  ;store the initial state there
  sta entity_instances+entity_instance::state,x

  ;at this point the entity should be fully spawned and ready
  ;to have its update routine called.

  ;restore regs
  pla
  tay
  pla
  tax
  pla

  rts
.endproc
