.ifndef BAT_INC
BAT_INC = 1

BAT_WIDTH = $10
BAT_HEIGHT = $08

.struct bat_locals
  y_velocity .word
  x_velocity .word
.endstruct

BAT_INITSTATE = 0
BAT_DESCENT_STATE = 1
BAT_TROUGH_STATE = 2
BAT_ASCENT_STATE = 3
BAT_CREST_STATE = 4

BAT_VERTICAL_ACCELERATION = 20
BAT_MAX_ASCENT_VELOCITY = $fe
BAT_MAX_DESCENT_VELOCITY = $02

.proc bat_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #BAT_INITSTATE
  beq bat_initState
  cmp #BAT_DESCENT_STATE
  beq bat_descent_state
  cmp #BAT_TROUGH_STATE
  beq bat_trough_state
  cmp #BAT_ASCENT_STATE
  beq bat_ascent_state
  cmp #BAT_CREST_STATE
  beq bat_crest_state

bat_initState:

  jsr bat_init

  rts

bat_descent_state:

  ;increase vertical velocity until certain value is reached, then switch to trough state.
  clc
  lda entity_locals+bat_locals::y_velocity,x
  adc #BAT_VERTICAL_ACCELERATION
  sta entity_locals+bat_locals::y_velocity,x
  lda entity_locals+bat_locals::y_velocity+1,x
  adc #0
  sta entity_locals+bat_locals::y_velocity+1,x
  cmp #BAT_MAX_DESCENT_VELOCITY
  bmi do_not_switch_to_trough_state

  lda #BAT_TROUGH_STATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_trough_state:

  jsr bat_move

  jsr bat_draw

  rts

bat_trough_state:

  ;decrease vertical velocity until zero, then switch to ascent state.
  sec
  lda entity_locals+bat_locals::y_velocity,x
  sbc #BAT_VERTICAL_ACCELERATION
  sta entity_locals+bat_locals::y_velocity,x
  lda entity_locals+bat_locals::y_velocity+1,x
  sbc #0
  sta entity_locals+bat_locals::y_velocity+1,x
  cmp #0
  bne do_not_switch_to_ascent_state

  lda #BAT_ASCENT_STATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_ascent_state:

  jsr bat_move

  jsr bat_draw

  rts

bat_ascent_state:

  ;decrease vertical velocity until certain value, then switch to crest state.
  sec
  lda entity_locals+bat_locals::y_velocity,x
  sbc #BAT_VERTICAL_ACCELERATION
  sta entity_locals+bat_locals::y_velocity,x
  lda entity_locals+bat_locals::y_velocity+1,x
  sbc #0
  sta entity_locals+bat_locals::y_velocity+1,x
  cmp #BAT_MAX_ASCENT_VELOCITY
  bpl do_not_switch_to_crest_state

  lda #BAT_CREST_STATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_crest_state:

  jsr bat_move

  jsr bat_draw

  rts

bat_crest_state:

  ;increase vertical velocity until zero, then switch to descent state.
  clc
  lda entity_locals+bat_locals::y_velocity,x
  adc #BAT_VERTICAL_ACCELERATION
  sta entity_locals+bat_locals::y_velocity,x
  lda entity_locals+bat_locals::y_velocity+1,x
  adc #0
  sta entity_locals+bat_locals::y_velocity+1,x
  cmp #0
  bne do_not_switch_to_descent_state

  lda #BAT_DESCENT_STATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_descent_state:

  jsr bat_move

  jsr bat_draw

  rts

bat_init:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set initial vertical velocity
  lda #0
  sta entity_locals+bat_locals::y_velocity,x
  lda #BAT_MAX_DESCENT_VELOCITY
  sta entity_locals+bat_locals::y_velocity+1,x

  ;compare entity x position to nomolos x position to decide direction
  sec
  lda nomolos_map_x+1
  sbc entity_instances+entity_instance::position_x,x
  lda nomolos_map_x+2
  sbc entity_instances+entity_instance::position_x+1,x
  bpl bat_will_go_right
bat_will_go_left:
  lda #$ff
  sta entity_locals+bat_locals::x_velocity,x
  sta entity_locals+bat_locals::x_velocity+1,x
  jmp bat_direction_test_done
bat_will_go_right:
  lda #$01
  sta entity_locals+bat_locals::x_velocity,x
  lda #$00
  sta entity_locals+bat_locals::x_velocity+1,x
bat_direction_test_done:

  ;switch state to "trough"
  lda #BAT_TROUGH_STATE
  sta entity_instances+entity_instance::state,x

  rts

bat_move:

  ;move bat horizontally
  clc
  lda entity_instances+entity_instance::position_x,x
  adc entity_locals+bat_locals::x_velocity,x
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc entity_locals+bat_locals::x_velocity+1,x
  sta entity_instances+entity_instance::position_x+1,x

  ;add y velocity to 24 bit Y coordinate with sign extension
.scope addYVelocity
  clc
  lda entity_locals+bat_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+bat_locals::y_velocity+1,x
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

  rts

bat_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killBat

  ;load bat width and height
  lda #BAT_WIDTH
  sta b2
  lda #BAT_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load bat width and height
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

  jmp killBat

nomolosNotAttacking:

  ldy #level_data_struct::BatOffset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda #<spritesheet1_BatFly
  sta w2
  lda #>spritesheet1_BatFly
  sta w2+1
  jsr entity_draw_anim

batOffscreen:
  rts

killBat:

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

.endproc

.endif
