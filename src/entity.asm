.include "macros.inc"
.include "ram.inc"
.include "zp.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "camera.inc"
.include "geotests.inc"
.include "fixedBankData.inc"
.include "entity.inc"

.include "sprite.inc"

.segment "CODE"

;draws entity's animation.
;expects y to contain offset into rom definition table where animation address can be found.
;expects b2 to contain flags for whether to flip the sprite. e.g. #%01000000 to flip
.proc entity_draw_anim
  ;load address of animation object into w1
  lda #<(entity_instances+entityRAM::animationObject)
  sta w1
  lda #>(entity_instances+entityRAM::animationObject)
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
  
  ;load address of deentle animation definition into w2
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1
  
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
  sta entity_instances+entityRAM::animationObject,x
  lda #$ff
  sta entity_instances+entityRAM::animationObject+1,x
  rts
.endproc

;kills current entity located at entity_instances,x.
;also decrements entity count at entity_counters + value at entity_instances+entityRAM::index,x
.proc entity_kill

  lda #0
  sta entity_instances+entityRAM::alive,x

  ;save x
  txa
  pha
  
  ;get zero based index of entity
  lda entity_instances+entityRAM::index,x

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
  sbc entity_instances+entityRAM::positionX,x
  lda nomolos_map_x+2
  sbc entity_instances+entityRAM::positionX+1,x
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

;assumes b2 and b3 represent the width and height of the calling entity
.proc entity_test_collision_hitbox
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
  rts
.endproc

;assumes b2 and b3 represent the width and height of the current entity
.proc entity_test_collision_nomolos
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
  lda #nomolosWidth
  sta b4
  lda #nomolosHeight
  sta b5

  jsr geotests_rect_in_rect_16bit
  rts
.endproc

.proc entity_compute_screen_coordinates
  ;get out low byte of positionX
  lda entity_instances+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entity_instances+entityRAM::positionY,x
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
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
  ldy #ROMDefinitionTableStruct::NomolosAndEntityBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;start at last entity
  ldy #lastEntity
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
  lda entity_instances+entityRAM::alive,x
  beq skipUpdate
  ;if we arrive here, x points to a live entity

  ;load the entity index
  lda entity_instances+entityRAM::index,x
  ;multiply the entity index by 8
  asl
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
  sta entity_instances+entityRAM::alive, y
  dex
  bpl :-
  rts
.endproc
  
;This routine spawns a single entity. It works by first searching
;for the first "dead" entity in the entity_instances. When it finds this
;dead entity, it fills it according to the entityRAM struct.

;the following parameters are expected:
;b0 = index of entity definition to spawn
;w0 = positionX
;b1 = positionY

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
  ;multiply by 8 to get offset from entity definition table
  asl
  asl
  asl
  tay
  ;point y at the max allowed entities entry
  iny
  iny
  iny
  iny
  iny
  lda (base_address_entity_definition_table),y
  cmp entity_counters,x
  beq do_not_spawn
  
  ;start at the last entity
  ldy #lastEntity
:
  tya
  asl
  asl
  asl
  asl
  tax
  lda entity_instances+entityRAM::alive,x
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
  
  ;make the entity alive. ALIVE! MUA HUAH HAH HAH
  lda #$01
  sta entity_instances+entityRAM::alive,x
  
  ;store the kind of entity this is
  lda b0
  sta entity_instances+entityRAM::index,x
  
  ;now that we know the kind of entity this is, we must look up
  ;the entity and pull out its initialXOffset and initialYOffset,
  ;add these to the input parameters, and store them in positionX and positionY.
  
  ;a holds the entity index, so multiply it by 8 to get an entity offset
  asl
  asl
  asl
  ;put the entity offset into y
  tay
  
  ;skip the UpdateRoutine, we're not interested in it here
  iny
  iny
  
  ;store the initial X offset in b2 for now
  lda (base_address_entity_definition_table),y
  sta b2
  
  ;load the low byte of the x parameter, and do a 16 bit subtract from this
  sec
  lda w0
  sbc b2
  sta w0
  lda w0+1
  sbc #0
  sta w0+1  

  ;now w0 should have the spawnPositionX value
  lda w0
  sta entity_instances+entityRAM::spawnPositionX,x
  lda w0+1
  sta entity_instances+entityRAM::spawnPositionX+1,x
  
  ;load initial y offset
  iny
  ;load the initial y offset and store it in b2 for now
  lda (base_address_entity_definition_table),y
  sta b2
  
  ;subtract this from the y parameter
  sec
  lda b1
  sbc b2
  sta b1  ;store result in y parameter
  
  ;now b1 should have the spawnPositionY value
  lda b1
  sta entity_instances+entityRAM::spawnPositionY,x
  
  ;load positionXFine
  lda #$00
  sta entity_instances+entityRAM::positionXFine,x
  ;load positionX
  lda w0
  sta entity_instances+entityRAM::positionX,x
  lda w0+1
  sta entity_instances+entityRAM::positionX+1,x
  
  ;load positionYFine
  lda #$00
  sta entity_instances+entityRAM::positionYFine,x
  ;load positionY
  lda b1
  sta entity_instances+entityRAM::positionY,x
  lda #0
  sta entity_instances+entityRAM::positionY+1,x
  
  ;point to the initial state
  iny
  ;load initial state
  lda (base_address_entity_definition_table),y  
  ;point to state variable in entity entry
  ;store the initial state there
  sta entity_instances+entityRAM::state,x
  
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
