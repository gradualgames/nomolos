.ifndef SPIRALICEBALL_SYMBOLS
SPIRALICEBALL_SYMBOLS = 1
SPIRALICEBALL_WIDTH = $10
SPIRALICEBALL_HEIGHT = $08

.struct spiraliceball_locals
  y_velocity .word
  x_velocity .word
  counter .byte
  sub_state .byte
  acceleration .byte
.endstruct

SPIRALICEBALL_INITSTATE = 0
SPIRALICEBALL_DESCENT_STATE = 1
SPIRALICEBALL_TROUGH_STATE = 2
SPIRALICEBALL_ASCENT_STATE = 3
SPIRALICEBALL_CREST_STATE = 4

SPIRALICEBALL_SINUSOIDAL_ACCELERATION = 20
SPIRALICEBALL_MAX_ASCENT_VELOCITY = $fe
SPIRALICEBALL_MAX_DESCENT_VELOCITY = $02
.endif

.ifndef spiraliceball_update
spiraliceball_update:
.endif
.scope

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #SPIRALICEBALL_INITSTATE
  beq spiraliceball_initState
  cmp #SPIRALICEBALL_DESCENT_STATE
  beq spiraliceball_descent_state
  cmp #SPIRALICEBALL_TROUGH_STATE
  beq spiraliceball_trough_state
  cmp #SPIRALICEBALL_ASCENT_STATE
  beq spiraliceball_ascent_state
  cmp #SPIRALICEBALL_CREST_STATE
  beq spiraliceball_crest_state

spiraliceball_initState:

  jsr spiraliceball_init

  rts

spiraliceball_crest_state:

  jmp spiraliceball_crest_state_handler

spiraliceball_descent_state:

  ;increase vertical velocity until certain value is reached, then switch to trough state.
  clc
  lda entity_locals+spiraliceball_locals::y_velocity,x
  adc entity_locals+spiraliceball_locals::acceleration,x
  sta entity_locals+spiraliceball_locals::y_velocity,x
  lda entity_locals+spiraliceball_locals::y_velocity+1,x
  adc #0
  sta entity_locals+spiraliceball_locals::y_velocity+1,x
  cmp #SPIRALICEBALL_MAX_DESCENT_VELOCITY
  bmi do_not_switch_to_trough_state

  lda #SPIRALICEBALL_TROUGH_STATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_trough_state:

  jsr spiraliceball_substate_handler

  jsr spiraliceball_move

  jsr spiraliceball_draw

  rts

spiraliceball_trough_state:

  ;decrease vertical velocity until zero, then switch to ascent state.
  sec
  lda entity_locals+spiraliceball_locals::y_velocity,x
  sbc entity_locals+spiraliceball_locals::acceleration,x
  sta entity_locals+spiraliceball_locals::y_velocity,x
  lda entity_locals+spiraliceball_locals::y_velocity+1,x
  sbc #0
  sta entity_locals+spiraliceball_locals::y_velocity+1,x
  cmp #0
  bne do_not_switch_to_ascent_state

  lda #SPIRALICEBALL_ASCENT_STATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_ascent_state:

  jsr spiraliceball_substate_handler

  jsr spiraliceball_move

  jsr spiraliceball_draw

  rts

spiraliceball_ascent_state:

  ;decrease vertical velocity until certain value, then switch to crest state.
  sec
  lda entity_locals+spiraliceball_locals::y_velocity,x
  sbc entity_locals+spiraliceball_locals::acceleration,x
  sta entity_locals+spiraliceball_locals::y_velocity,x
  lda entity_locals+spiraliceball_locals::y_velocity+1,x
  sbc #0
  sta entity_locals+spiraliceball_locals::y_velocity+1,x
  cmp #SPIRALICEBALL_MAX_ASCENT_VELOCITY
  bpl do_not_switch_to_crest_state

  lda #SPIRALICEBALL_CREST_STATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_crest_state:

  jsr spiraliceball_substate_handler

  jsr spiraliceball_move

  jsr spiraliceball_draw

  rts

spiraliceball_crest_state_handler:

  ;increase vertical velocity until zero, then switch to descent state.
  clc
  lda entity_locals+spiraliceball_locals::y_velocity,x
  adc entity_locals+spiraliceball_locals::acceleration,x
  sta entity_locals+spiraliceball_locals::y_velocity,x
  lda entity_locals+spiraliceball_locals::y_velocity+1,x
  adc #0
  sta entity_locals+spiraliceball_locals::y_velocity+1,x
  cmp #0
  bne do_not_switch_to_descent_state

  lda #SPIRALICEBALL_DESCENT_STATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_descent_state:

  jsr spiraliceball_substate_handler

  jsr spiraliceball_move

  jsr spiraliceball_draw

  rts

spiraliceball_init:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set initial vertical velocity
  lda #0
  sta entity_locals+spiraliceball_locals::y_velocity,x
  lda #SPIRALICEBALL_MAX_DESCENT_VELOCITY
  sta entity_locals+spiraliceball_locals::y_velocity+1,x

  ;set initial horizontal velocity
  lda #0
  sta entity_locals+spiraliceball_locals::x_velocity,x
  lda #SPIRALICEBALL_MAX_DESCENT_VELOCITY
  sta entity_locals+spiraliceball_locals::x_velocity+1,x

  ;set counter (delays when sub state handler begins executing)
  lda #20
  sta entity_locals+spiraliceball_locals::counter,x

  ;set initial sinusoidal acceleration
  lda #SPIRALICEBALL_SINUSOIDAL_ACCELERATION
  sta entity_locals+spiraliceball_locals::acceleration,x

  ;switch state to "trough"
  lda #SPIRALICEBALL_TROUGH_STATE
  sta entity_instances+entity_instance::state,x
  sta entity_locals+spiraliceball_locals::sub_state,x

  rts

spiraliceball_move:

  ;add y velocity to 24 bit Y coordinate with sign extension
.scope addYVelocity
  clc
  lda entity_locals+spiraliceball_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+spiraliceball_locals::y_velocity+1,x
  bmi signExtend
  adc entity_instances+entity_instance::position_y,x
  sta entity_instances+entity_instance::position_y,x
  lda #0
  adc entity_instances+entity_instance::position_y+1,x
  sta entity_instances+entity_instance::position_y+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entity_instance::position_y,x
  sta entity_instances+entity_instance::position_y,x
  lda #$ff
  adc entity_instances+entity_instance::position_y+1,x
  sta entity_instances+entity_instance::position_y+1,x
signExtendAddDone:
.endscope

  ;add x velocity to 24 bit X coordinate with sign extension
.scope addXVelocity
  clc
  lda entity_locals+spiraliceball_locals::x_velocity,x
  adc entity_instances+entity_instance::position_x_fine,x
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_locals+spiraliceball_locals::x_velocity+1,x
  bmi signExtend
  adc entity_instances+entity_instance::position_x,x
  sta entity_instances+entity_instance::position_x,x
  lda #0
  adc entity_instances+entity_instance::position_x+1,x
  sta entity_instances+entity_instance::position_x+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entity_instance::position_x,x
  sta entity_instances+entity_instance::position_x,x
  lda #$ff
  adc entity_instances+entity_instance::position_x+1,x
  sta entity_instances+entity_instance::position_x+1,x
signExtendAddDone:
.endscope

  rts

spiraliceball_substate_handler:

  lda entity_locals+spiraliceball_locals::counter,x
  bne do_not_execute_substate_yet

  ;load current sub state
  lda entity_locals+spiraliceball_locals::sub_state,x
  ;figure out what state to jump to
  cmp #SPIRALICEBALL_DESCENT_STATE
  beq spiraliceball_horizontal_descent_state
  cmp #SPIRALICEBALL_TROUGH_STATE
  beq spiraliceball_horizontal_trough_state
  cmp #SPIRALICEBALL_ASCENT_STATE
  beq spiraliceball_horizontal_ascent_state
  cmp #SPIRALICEBALL_CREST_STATE
  beq spiraliceball_horizontal_crest_state

  rts

do_not_execute_substate_yet:

  dec entity_locals+spiraliceball_locals::counter,x

  rts

spiraliceball_horizontal_crest_state:

  jmp spiraliceball_horizontal_crest_state_handler

spiraliceball_horizontal_descent_state:

  ;increase horizontal velocity until certain value is reached, then switch to trough state.
  clc
  lda entity_locals+spiraliceball_locals::x_velocity,x
  adc entity_locals+spiraliceball_locals::acceleration,x
  sta entity_locals+spiraliceball_locals::x_velocity,x
  lda entity_locals+spiraliceball_locals::x_velocity+1,x
  adc #0
  sta entity_locals+spiraliceball_locals::x_velocity+1,x
  cmp #SPIRALICEBALL_MAX_DESCENT_VELOCITY
  .scope
  bmi do_not_switch_to_trough_state

  lda #SPIRALICEBALL_TROUGH_STATE
  sta entity_locals+spiraliceball_locals::sub_state,x

  dec entity_locals+spiraliceball_locals::acceleration,x

do_not_switch_to_trough_state:
  .endscope

  rts

spiraliceball_horizontal_trough_state:

  ;decrease horizontal velocity until zero, then switch to ascent state.
  sec
  lda entity_locals+spiraliceball_locals::x_velocity,x
  sbc entity_locals+spiraliceball_locals::acceleration,x
  sta entity_locals+spiraliceball_locals::x_velocity,x
  lda entity_locals+spiraliceball_locals::x_velocity+1,x
  sbc #0
  sta entity_locals+spiraliceball_locals::x_velocity+1,x
  cmp #0
  .scope
  bne do_not_switch_to_ascent_state

  lda #SPIRALICEBALL_ASCENT_STATE
  sta entity_locals+spiraliceball_locals::sub_state,x

  dec entity_locals+spiraliceball_locals::acceleration,x

do_not_switch_to_ascent_state:
  .endscope

  rts

spiraliceball_horizontal_ascent_state:

  ;decrease horizontal velocity until certain value, then switch to crest state.
  sec
  lda entity_locals+spiraliceball_locals::x_velocity,x
  sbc entity_locals+spiraliceball_locals::acceleration,x
  sta entity_locals+spiraliceball_locals::x_velocity,x
  lda entity_locals+spiraliceball_locals::x_velocity+1,x
  sbc #0
  sta entity_locals+spiraliceball_locals::x_velocity+1,x
  cmp #SPIRALICEBALL_MAX_ASCENT_VELOCITY
  .scope
  bpl do_not_switch_to_crest_state

  lda #SPIRALICEBALL_CREST_STATE
  sta entity_locals+spiraliceball_locals::sub_state,x

  dec entity_locals+spiraliceball_locals::acceleration,x

do_not_switch_to_crest_state:
  .endscope

  rts

spiraliceball_horizontal_crest_state_handler:

  ;increase horizontal velocity until zero, then switch to descent state.
  clc
  lda entity_locals+spiraliceball_locals::x_velocity,x
  adc entity_locals+spiraliceball_locals::acceleration,x
  sta entity_locals+spiraliceball_locals::x_velocity,x
  lda entity_locals+spiraliceball_locals::x_velocity+1,x
  adc #0
  sta entity_locals+spiraliceball_locals::x_velocity+1,x
  cmp #0
  .scope
  bne do_not_switch_to_descent_state

  lda #SPIRALICEBALL_DESCENT_STATE
  sta entity_locals+spiraliceball_locals::sub_state,x

  dec entity_locals+spiraliceball_locals::acceleration,x

do_not_switch_to_descent_state:
  .endscope

  rts

spiraliceball_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killSpiralIceball

  ;load spiraliceball width and height
  lda #SPIRALICEBALL_WIDTH
  sta b2
  lda #SPIRALICEBALL_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load spiraliceball width and height
  lda #$10
  sta b2
  lda #$10
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

  jmp killSpiralIceball

nomolosNotAttacking:

  lda entity_chr_offsets+(entity_index_spiraliceball-1)
  sta sprite_group_offset

  lda #<spritesheet1_IceBallFly
  sta w2
  lda #>spritesheet1_IceBallFly
  sta w2+1
  jsr entity_draw_anim

spiraliceballOffscreen:
  rts

killSpiralIceball:

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
  lda entity_instances+entity_instance::position_y+1,x
  sta b2

  jsr entity_spawn

  rts

.endscope
