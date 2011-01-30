.ifndef FIREGUY_INC
FIREGUY_INC = 1

.struct fireguy_locals
  direction .byte
  move_stop .byte
  distance  .byte
.endstruct

FIREGUY_WIDTH = $18
FIREGUY_HEIGHT = $10
FIREGUY_HALFHEIGHT = $08

FIREGUY_SPEED_FINE = 0
FIREGUY_SPEED_LO   = 2

FIREGUY_DISTANCE_TIL_ABOUT_FACE = 64
FIREGUY_DISTANCE_TIL_SWITCH_TO_STOP_STATE = 150
FIREGUY_DISTANCE_TIL_SWITCH_TO_MOVE_STATE = 50

FIREGUY_INITSTATE = 0
FIREGUY_MOVESTATE = 1
FIREGUY_STOPSTATE = 2

.proc fireguy_init
  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #8
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x
  
  lda #0
  sta entity_locals+fireguy_locals::direction,x
  lda #FIREGUY_DISTANCE_TIL_SWITCH_TO_MOVE_STATE
  sta entity_locals+fireguy_locals::move_stop,x
  lda #FIREGUY_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+fireguy_locals::distance,x

  lda #FIREGUY_STOPSTATE
  sta entity_instances+entity_instance::state,x
  rts
.endproc

.proc fireguy_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #FIREGUY_INITSTATE
  beq fireguy_initState
  cmp #FIREGUY_MOVESTATE
  beq fireguy_moveState
  cmp #FIREGUY_STOPSTATE
  beq fireguy_stopState

fireguy_initState:

  jsr fireguy_init

  rts

fireguy_moveState:

  .scope
  dec entity_locals+fireguy_locals::move_stop,x
  bne do_not_switch_state

  lda #FIREGUY_DISTANCE_TIL_SWITCH_TO_STOP_STATE
  sta entity_locals+fireguy_locals::move_stop,x

  lda #FIREGUY_STOPSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_state:
  .endscope

  dec entity_locals+fireguy_locals::distance,x
  bne do_not_flip_direction

  lda entity_locals+fireguy_locals::direction,x
  eor #$ff
  sta entity_locals+fireguy_locals::direction,x

  lda #FIREGUY_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+fireguy_locals::distance,x

do_not_flip_direction:

  lda entity_locals+fireguy_locals::direction,x
  bne move_right

move_left:

  sec
  lda entity_instances+entity_instance::position_x_fine,x
  sbc #FIREGUY_SPEED_FINE
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  sbc #FIREGUY_SPEED_LO
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  jmp direction_test_done
move_right:

  clc
  lda entity_instances+entity_instance::position_x_fine,x
  adc #FIREGUY_SPEED_FINE
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  adc #FIREGUY_SPEED_LO
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x

direction_test_done:

  jsr fireguy_draw

  rts

fireguy_stopState:

  .scope
  dec entity_locals+fireguy_locals::move_stop,x
  bne do_not_switch_state

  lda #FIREGUY_DISTANCE_TIL_SWITCH_TO_MOVE_STATE
  sta entity_locals+fireguy_locals::move_stop,x

  lda #FIREGUY_MOVESTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_state:
  .endscope

  jsr fireguy_draw

  rts

killFireGuy:

  ;make it dead
  jsr entity_kill

  ;spawn an explosion entity
  lda #entity_index_explosion
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

fireguy_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killFireGuy

  ;load fireguy width and height
  lda #FIREGUY_WIDTH
  sta b2
  lda #FIREGUY_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

  jsr entity_reset_anim

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load fireguy width and height
  lda #FIREGUY_WIDTH
  sta b2
  lda #FIREGUY_HEIGHT
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

  jmp killFireGuy

nomolosNotAttacking:

  ldy #level_data_struct::fireguy_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda entity_locals+fireguy_locals::direction,x
  cmp #0
  bne fireguy_moving_right
  lda #%01000000
  sta b2
  jmp fireguy_direction_test_done
fireguy_moving_right:
  lda #%00000000
  sta b2
fireguy_direction_test_done:

  lda entity_instances+entity_instance::state,x
  cmp #FIREGUY_STOPSTATE
  beq not_stop_state
move_state:
  lda #<spritesheet1_FireGuy0
  sta w0
  lda #>spritesheet1_FireGuy0
  sta w0+1
  jmp fireguy_state_test_done
not_stop_state:
  lda #<spritesheet1_FireGuy1
  sta w0
  lda #>spritesheet1_FireGuy1
  sta w0+1
fireguy_state_test_done:
  
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_metasprite_16bit

fireguyOffscreen:
  rts

.endproc

.endif
