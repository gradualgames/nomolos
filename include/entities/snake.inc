.ifndef SNAKE_INC
SNAKE_INC = 1

.struct snake_locals
  direction .byte
  move_stop .byte
  distance  .byte
.endstruct

SNAKE_WIDTH = $18
SNAKE_HEIGHT = $10
SNAKE_HALFHEIGHT = $08

SNAKE_DISTANCE_TIL_ABOUT_FACE = 160
SNAKE_DISTANCE_TIL_SWITCH_STATE = 20
SNAKE_SPEED = 160

SNAKE_INITSTATE = 0
SNAKE_MOVESTATE = 1
SNAKE_STOPSTATE = 2

.proc snake_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #SNAKE_INITSTATE
  beq snake_initState
  cmp #SNAKE_MOVESTATE
  beq snake_moveState
  cmp #SNAKE_STOPSTATE
  beq snake_stopState

snake_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  lda #0
  sta entity_locals+snake_locals::direction,x
  lda #SNAKE_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+snake_locals::move_stop,x
  lda #SNAKE_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+snake_locals::distance,x

  lda #SNAKE_STOPSTATE
  sta entity_instances+entity_instance::state,x

  rts

snake_moveState:

  .scope
  dec entity_locals+snake_locals::move_stop,x
  bne do_not_switch_state

  lda #SNAKE_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+snake_locals::move_stop,x

  lda #SNAKE_STOPSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_state:
  .endscope

  dec entity_locals+snake_locals::distance,x
  bne do_not_flip_direction

  lda entity_locals+snake_locals::direction,x
  eor #$ff
  sta entity_locals+snake_locals::direction,x

  lda #SNAKE_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+snake_locals::distance,x

do_not_flip_direction:

  lda entity_locals+snake_locals::direction,x
  bne move_right

move_left:

  sec
  lda entity_instances+entity_instance::position_x_fine,x
  sbc #SNAKE_SPEED
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
  adc #SNAKE_SPEED
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  adc #0
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x

direction_test_done:

  jsr snake_draw

  rts

snake_stopState:

  .scope
  dec entity_locals+snake_locals::move_stop,x
  bne do_not_switch_state

  lda #SNAKE_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+snake_locals::move_stop,x

  lda #SNAKE_MOVESTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_state:
  .endscope

  jsr snake_draw

  rts

killSnake:

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

snake_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killSnake

  ;load snake width and height
  lda #SNAKE_WIDTH
  sta b2
  lda #SNAKE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

  jsr entity_reset_anim

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load snake width and height
  lda #SNAKE_WIDTH
  sta b2
  lda #SNAKE_HEIGHT
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

  jmp killSnake

nomolosNotAttacking:

  ldy #level_data_struct::snake_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda #<spritesheet1_SnakeSlither
  sta w2
  lda #>spritesheet1_SnakeSlither
  sta w2+1
  lda entity_locals+snake_locals::direction,x
  cmp #0
  bne snake_moving_right
  lda #%01000000
  sta b2
  jmp snake_direction_test_done
snake_moving_right:
  lda #%00000000
  sta b2
snake_direction_test_done:
  jsr entity_draw_anim

snakeOffscreen:
  rts

.endproc

.endif
