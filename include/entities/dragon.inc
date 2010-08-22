.ifndef DRAGON_INC
DRAGON_INC = 1

DRAGON_WIDTH = $20
DRAGON_HALFWIDTH = $10
DRAGON_HEIGHT = $18
DRAGON_HALFHEIGHT = $0C

.struct dragon_locals
  x_velocity .word
  y_velocity .word
  anim_index .byte
  fly_hover  .byte
  shoot_iceball .byte
.endstruct

DRAGON_INITSTATE = 0
DRAGON_FLYSTATE = 1
DRAGON_HOVERSTATE = 2

DRAGON_TIME_TIL_STATE_SWITCH = 40
DRAGON_TIME_TIL_SHOOT_ICEBALL = 50

DRAGON_VERTSPEED = 20
DRAGON_MAXVERTSPEED = 1
DRAGON_HORIZSPEED = 20
DRAGON_MAXHORIZSPEED = 4

.proc dragon_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #DRAGON_INITSTATE
  beq dragon_initState
  cmp #DRAGON_FLYSTATE
  beq dragon_flyState
  cmp #DRAGON_HOVERSTATE
  beq dragon_hoverState

dragon_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set x velocity to 0
  lda #0
  sta entity_locals+dragon_locals::x_velocity,x
  sta entity_locals+dragon_locals::x_velocity+1,x

  ;set y velocity to 0
  sta entity_locals+dragon_locals::y_velocity,x
  sta entity_locals+dragon_locals::y_velocity+1,x

  ;switch state to "fly"
  lda #DRAGON_FLYSTATE
  sta entity_instances+entity_instance::state,x

  ;set fly_hover counter
  lda #DRAGON_TIME_TIL_STATE_SWITCH
  sta entity_locals+dragon_locals::fly_hover,x

  lda #DRAGON_TIME_TIL_SHOOT_ICEBALL
  sta entity_locals+dragon_locals::shoot_iceball,x

  rts

dragon_hoverState:

  .scope
  dec entity_locals+dragon_locals::shoot_iceball,x
  bne do_not_shoot_iceball

  ;spawn an iceball entity
  lda #entity_index_iceball
  sta b0

  ;get out low byte of position_x
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #DRAGON_HALFWIDTH
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sta b1

  jsr entity_spawn

  lda #DRAGON_TIME_TIL_SHOOT_ICEBALL
  sta entity_locals+dragon_locals::shoot_iceball,x

do_not_shoot_iceball:
  .endscope

  .scope
  dec entity_locals+dragon_locals::fly_hover,x
  bne do_not_switch_state

  lda #DRAGON_FLYSTATE
  sta entity_instances+entity_instance::state,x

  lda #DRAGON_TIME_TIL_STATE_SWITCH
  sta entity_locals+dragon_locals::fly_hover,x

  lda #0
  sta entity_locals+dragon_locals::x_velocity,x
  sta entity_locals+dragon_locals::x_velocity+1,x
  sta entity_locals+dragon_locals::y_velocity,x
  sta entity_locals+dragon_locals::y_velocity+1,x

do_not_switch_state:
  .endscope

  jsr entity_compute_screen_coordinates

  jsr dragon_draw

  rts

dragon_flyState:

  .scope
  dec entity_locals+dragon_locals::fly_hover,x
  bne do_not_switch_state

  lda #DRAGON_HOVERSTATE
  sta entity_instances+entity_instance::state,x

  lda #DRAGON_TIME_TIL_STATE_SWITCH
  sta entity_locals+dragon_locals::fly_hover,x

do_not_switch_state:
  .endscope

  jsr entity_compute_screen_coordinates

  ;add x velocity to 24 bit X coordinate with sign extension
.scope addXVelocity
  clc
  lda entity_locals+dragon_locals::x_velocity,x
  adc entity_instances+entity_instance::position_x_fine,x
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_locals+dragon_locals::x_velocity+1,x
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

  ;add y velocity to 24 bit Y coordinate with sign extension
.scope addYVelocity
  clc
  lda entity_locals+dragon_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+dragon_locals::y_velocity+1,x
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

  lda entity_screen_y
  sec
  sbc nomolos_screen_y
  lda entity_screen_y+1
  sbc nomolos_screen_y+1

  bmi followDown
followUp:

  ;subtract from y velocity
  lda entity_locals+dragon_locals::y_velocity,x
  sec
  sbc #DRAGON_VERTSPEED
  sta entity_locals+dragon_locals::y_velocity,x
  lda entity_locals+dragon_locals::y_velocity+1,x
  sbc #0
  sta entity_locals+dragon_locals::y_velocity+1,x

  jmp followVertTestDone
followDown:

  ;add to y velocity
  lda entity_locals+dragon_locals::y_velocity,x
  clc
  adc #DRAGON_VERTSPEED
  sta entity_locals+dragon_locals::y_velocity,x
  lda entity_locals+dragon_locals::y_velocity+1,x
  adc #0
  sta entity_locals+dragon_locals::y_velocity+1,x

followVertTestDone:

  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:

  ;subtract from x velocity
  lda entity_locals+dragon_locals::x_velocity,x
  sec
  sbc #DRAGON_HORIZSPEED
  sta entity_locals+dragon_locals::x_velocity,x
  lda entity_locals+dragon_locals::x_velocity+1,x
  sbc #0
  sta entity_locals+dragon_locals::x_velocity+1,x

  jmp followTestDone
followToRight:

  ;add to x velocity
  lda entity_locals+dragon_locals::x_velocity,x
  clc
  adc #DRAGON_HORIZSPEED
  sta entity_locals+dragon_locals::x_velocity,x
  lda entity_locals+dragon_locals::x_velocity+1,x
  adc #0
  sta entity_locals+dragon_locals::x_velocity+1,x

followTestDone:

  ;keep x and y velocity under control
  lda entity_locals+dragon_locals::x_velocity+1,x  ;high byte is "pixel speed"
  bpl xVelocityPositive
xVelocityNegative:
.scope

  cmp #(-DRAGON_MAXHORIZSPEED)
  bpl notMaxHoriz

  lda #(-DRAGON_MAXHORIZSPEED)
  sta entity_locals+dragon_locals::x_velocity+1,x

notMaxHoriz:
.endscope

  jmp xVelocityTestDone
xVelocityPositive:
.scope
  cmp #(DRAGON_MAXHORIZSPEED)
  bmi notMaxHoriz

  lda #(DRAGON_MAXHORIZSPEED)
  sta entity_locals+dragon_locals::x_velocity+1,x

notMaxHoriz:
.endscope

xVelocityTestDone:

  ;keep x and y velocity under control
  lda entity_locals+dragon_locals::y_velocity+1,x  ;high byte is "pixel speed"
  bpl yVelocityPositive
yVelocityNegative:
.scope

  cmp #(-DRAGON_MAXVERTSPEED)
  bpl notMaxVert

  lda #(-DRAGON_MAXVERTSPEED)
  sta entity_locals+dragon_locals::y_velocity+1,x

notMaxVert:
.endscope

  jmp yVelocityTestDone
yVelocityPositive:
.scope
  cmp #(DRAGON_MAXVERTSPEED)
  bmi notMaxVert

  lda #(DRAGON_MAXVERTSPEED)
  sta entity_locals+dragon_locals::y_velocity+1,x

notMaxVert:
.endscope

yVelocityTestDone:

  jsr dragon_draw

  rts

killDragon:

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

dragon_draw:

  jsr entity_test_death_zone
  beq killDragon

  lda #level_data_struct::dragon_fly
  sta entity_locals+dragon_locals::anim_index,x
  ;load dragon width and height
  lda #DRAGON_WIDTH
  sta b2
  lda #DRAGON_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt
  lda #level_data_struct::dragon_fly
  sta entity_locals+dragon_locals::anim_index,x

  jsr entity_reset_anim

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load dragon width and height
  lda #DRAGON_WIDTH
  sta b2
  lda #DRAGON_HEIGHT
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

  jmp killDragon

nomolosNotAttacking:

  ldy #level_data_struct::dragon_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy entity_locals+dragon_locals::anim_index,x
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:
  lda #%00000000
  sta b2
  jmp entity_facing_test_done
entity_facing_right:
  lda #%01000000
  sta b2
entity_facing_test_done:
  jsr entity_draw_anim

dragonOffscreen:
  rts

.endproc

.endif
