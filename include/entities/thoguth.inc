.ifndef THOGUTH_INC
THOGUTH_INC = 1

.struct thoguth_locals
  direction .byte
  move_stop .byte
  distance  .byte
.endstruct

THOGUTH_WIDTH = $18
THOGUTH_HEIGHT = $20
THOGUTH_HALFHEIGHT = $10

THOGUTH_DISTANCE_TIL_ABOUT_FACE = 120
THOGUTH_DISTANCE_TIL_SWITCH_STATE = 100
THOGUTH_SPEED = 255

THOGUTH_INITSTATE = 0
THOGUTH_MOVESTATE = 1
THOGUTH_STOPSTATE = 2

.proc thoguth_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #THOGUTH_INITSTATE
  beq thoguth_initState
  cmp #THOGUTH_MOVESTATE
  beq thoguth_moveState
  cmp #THOGUTH_STOPSTATE
  beq thoguth_stopState

thoguth_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #32
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  
  lda #0
  sta entity_locals+thoguth_locals::direction,x
  lda #THOGUTH_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+thoguth_locals::move_stop,x
  lda #THOGUTH_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+thoguth_locals::distance,x

  lda #THOGUTH_MOVESTATE
  sta entity_instances+entity_instance::state,x

  rts

thoguth_stopState:

  jsr entity_reset_anim

  .scope
  dec entity_locals+thoguth_locals::move_stop,x
  bne do_not_switch_state

  lda #THOGUTH_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+thoguth_locals::move_stop,x

  lda #THOGUTH_MOVESTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_state:
  .endscope

  jsr thoguth_draw

  rts
  
thoguth_moveState:

  .scope
  dec entity_locals+thoguth_locals::move_stop,x
  bne do_not_switch_state

  lda #THOGUTH_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+thoguth_locals::move_stop,x

  lda #THOGUTH_STOPSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_state:
  .endscope

  dec entity_locals+thoguth_locals::distance,x
  bne do_not_flip_direction

  lda entity_locals+thoguth_locals::direction,x
  eor #$ff
  sta entity_locals+thoguth_locals::direction,x

  lda #THOGUTH_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+thoguth_locals::distance,x

do_not_flip_direction:

  lda entity_locals+thoguth_locals::direction,x
  bne move_right

move_left:

  sec
  lda entity_instances+entity_instance::position_x_fine,x
  sbc #THOGUTH_SPEED
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  sbc #0
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  jmp direction_test_done
move_right:

  clc
  lda entity_instances+entity_instance::position_x_fine,x
  adc #THOGUTH_SPEED
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  adc #0
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x

direction_test_done:

  jsr thoguth_draw

  rts

killThoguth:

  ;make it dead
  jsr entity_kill

  ; ;spawn an explosion entity
  ; lda #entity_index_explosion
  ; sta b0

  ; ;get out low byte of position_x
  ; lda entity_instances+entity_instance::position_x,x
  ; sta w0
  ; ;get out high byte of position_x
  ; lda entity_instances+entity_instance::position_x+1,x
  ; sta w0+1

  ; ;get out position_y
  ; lda entity_instances+entity_instance::position_y,x
  ; sta b1

  ; jsr entity_spawn

  rts

thoguth_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killThoguth

  ;load thoguth width and height
  lda #THOGUTH_WIDTH
  sta b2
  lda #THOGUTH_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

  jsr entity_reset_anim

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load thoguth width and height
  lda #THOGUTH_WIDTH
  sta b2
  lda #THOGUTH_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox

  bne nomolosNotAttacking

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

  jmp killThoguth

nomolosNotAttacking:

  ldy #level_data_struct::thoguth_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda #<spritesheet1_ThoguthMarch
  sta w2
  lda #>spritesheet1_ThoguthMarch
  sta w2+1
  lda entity_locals+thoguth_locals::direction,x
  cmp #0
  bne thoguth_moving_right
  lda #%01000000
  sta b2
  jmp thoguth_direction_test_done
thoguth_moving_right:
  lda #%00000000
  sta b2
thoguth_direction_test_done:
  jsr entity_draw_anim

thoguthOffscreen:
  rts

.endproc

.endif
