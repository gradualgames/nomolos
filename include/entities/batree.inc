.ifndef BATREE_INC
BATREE_INC = 1

BATREE_WIDTH = $18
BATREE_HEIGHT = $28
BATREE_BATSPAWN_INTERVAL = 50

.struct batree_locals
  batspawn_counter .byte
  damaged_counter  .byte
  health           .byte
.endstruct

BATREE_INITSTATE = 0
BATREE_MOVERIGHTSTATE = 1
BATREE_MOVELEFTSTATE = 2

.proc batree_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #BATREE_INITSTATE
  beq batree_initState
  cmp #BATREE_MOVERIGHTSTATE
  beq batree_moveRightState
  cmp #BATREE_MOVELEFTSTATE
  beq batree_moveLeftState

batree_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set initial batspawn_counter
  lda #BATREE_BATSPAWN_INTERVAL
  sta entity_locals+batree_locals::batspawn_counter,x
  
  ;set damaged counter to 0
  lda #0
  sta entity_locals+batree_locals::damaged_counter,x

  ;set health to 3
  lda #3
  sta entity_locals+batree_locals::health,x
  
  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #24
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x
  
  ;switch state to "run"
  lda #BATREE_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x
  rts

batree_moveRightState:

  ;add 1 to position_x
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #1
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x

  ;do position_x - spawn_position_x
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc entity_instances+entity_instance::spawn_position_x,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sbc entity_instances+entity_instance::spawn_position_x+1,x
  sta w0+1

  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1
  bne dontSwitchToLeftState

  lda #BATREE_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x

dontSwitchToLeftState:

  jsr batree_draw

  jsr batree_update_batspawn_counter

  rts

batree_moveLeftState:

  ;sub 1 from position_x
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #1
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  ;do spawn_position_x - position_x
  sec
  lda entity_instances+entity_instance::spawn_position_x,x
  sbc entity_instances+entity_instance::position_x,x
  sta w0
  lda entity_instances+entity_instance::spawn_position_x+1,x
  sbc entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1

  bne dontSwitchToRightState

  lda #BATREE_MOVERIGHTSTATE
  sta entity_instances+entity_instance::state,x

dontSwitchToRightState:

  jsr batree_draw

  jsr batree_update_batspawn_counter

  rts

batree_update_batspawn_counter:

  dec entity_locals+batree_locals::batspawn_counter,x
  bne do_not_spawn_bat

  ;spawn bat at location of batree
;This routine spawns a single entity. It works by first searching
;for the first "dead" entity in the entity_instances. When it finds this
;dead entity, it fills it according to the entity_instance struct.

;the following parameters are expected:
;b0 = index of entity definition to spawn
;w0 = position_x
;b1 = position_y

  lda entity_instances+entity_instance::position_x,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #16
  sta b1
  lda #entity_index_bat
  sta b0
  jsr entity_spawn

  ;reset bat spawn counter
  lda #BATREE_BATSPAWN_INTERVAL
  sta entity_locals+batree_locals::batspawn_counter,x

do_not_spawn_bat:

  rts

batree_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq kill_batree

  ;load batree width and height
  lda #BATREE_WIDTH
  sta b2
  lda #BATREE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  lda entity_locals+batree_locals::damaged_counter,x
  bne nomolos_not_attacking
  jsr nomolos_is_deadly
  beq nomolos_not_attacking

  ;load batree width and height
  lda #BATREE_WIDTH
  sta b2
  lda #BATREE_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox

  bne nomolos_not_attacking

  ;set the damaged counter, this will make the entity flash
  lda #10
  sta entity_locals+batree_locals::damaged_counter,x
  
  ;play a hit sound
  txa
  pha

  lda #<hit_sound
  sta sound_param_word_0
  lda #>hit_sound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax

  ;decrement the entity's health
  dec entity_locals+batree_locals::health,x
  
  bne nomolos_not_attacking
  
  jmp kill_batree
  
nomolos_not_attacking:

  lda entity_locals+batree_locals::damaged_counter,x
  beq entity_not_flashing
  
  dec entity_locals+batree_locals::damaged_counter,x
  
entity_not_flashing:

  lda entity_chr_offsets+(entity_index_batree-1)
  sta sprite_group_offset

  lda #<spritesheet1_Batree
  sta w2
  lda #>spritesheet1_Batree
  sta w2+1
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:
  ;make the entity flash by cycling through color attributes
  lda entity_locals+batree_locals::damaged_counter,x
  and #%00000011
  ;flip the sprite
  ora #%01000000
  sta b2
  jmp entity_facing_test_done
entity_facing_right:
  ;make the entity flash by cycling through color attributes
  lda entity_locals+batree_locals::damaged_counter,x
  and #%00000011
  ;do not flip the sprite
  sta b2
entity_facing_test_done:

  jsr entity_draw_anim
batreeOffscreen:
  rts

kill_batree:

  ;make it dead
  jsr entity_kill

  ;spawn an explosion entity
  lda #entity_index_explosionspawner
  sta b0

  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sta b1

  jsr entity_spawn

  rts
.endproc

.endif
