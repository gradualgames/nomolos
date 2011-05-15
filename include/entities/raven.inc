.ifndef RAVEN_INC
RAVEN_INC = 1

RAVEN_WIDTH = $20
RAVEN_HEIGHT = $18

.struct raven_locals
  x_velocity .word
  y_velocity .word
  anim_address .word
.endstruct

RAVEN_INITSTATE = 0
RAVEN_FLYSTATE = 1

RAVEN_VERTSPEED = 20
RAVEN_MAXVERTSPEED = 1
RAVEN_HORIZSPEED = 20
RAVEN_MAXHORIZSPEED = 4

.proc raven_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #RAVEN_INITSTATE
  beq raven_initState
  cmp #RAVEN_FLYSTATE
  beq raven_flyState

raven_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set x velocity to 0
  lda #0
  sta entity_locals+raven_locals::x_velocity,x
  sta entity_locals+raven_locals::x_velocity+1,x

  ;set y velocity to 0
  sta entity_locals+raven_locals::y_velocity,x
  sta entity_locals+raven_locals::y_velocity+1,x

  ;switch state to "fly"
  lda #RAVEN_FLYSTATE
  sta entity_instances+entity_instance::state,x
  rts

raven_flyState:

  jsr entity_compute_screen_coordinates

  ;add x velocity to 24 bit X coordinate with sign extension
.scope addXVelocity
  clc
  lda entity_locals+raven_locals::x_velocity,x
  adc entity_instances+entity_instance::position_x_fine,x
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_locals+raven_locals::x_velocity+1,x
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
  lda entity_locals+raven_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+raven_locals::y_velocity+1,x
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
  lda entity_locals+raven_locals::y_velocity,x
  sec
  sbc #RAVEN_VERTSPEED
  sta entity_locals+raven_locals::y_velocity,x
  lda entity_locals+raven_locals::y_velocity+1,x
  sbc #0
  sta entity_locals+raven_locals::y_velocity+1,x

  jmp followVertTestDone
followDown:

  ;add to y velocity
  lda entity_locals+raven_locals::y_velocity,x
  clc
  adc #RAVEN_VERTSPEED
  sta entity_locals+raven_locals::y_velocity,x
  lda entity_locals+raven_locals::y_velocity+1,x
  adc #0
  sta entity_locals+raven_locals::y_velocity+1,x

followVertTestDone:

  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:

  ;subtract from x velocity
  lda entity_locals+raven_locals::x_velocity,x
  sec
  sbc #RAVEN_HORIZSPEED
  sta entity_locals+raven_locals::x_velocity,x
  lda entity_locals+raven_locals::x_velocity+1,x
  sbc #0
  sta entity_locals+raven_locals::x_velocity+1,x

  jmp followTestDone
followToRight:

  ;add to x velocity
  lda entity_locals+raven_locals::x_velocity,x
  clc
  adc #RAVEN_HORIZSPEED
  sta entity_locals+raven_locals::x_velocity,x
  lda entity_locals+raven_locals::x_velocity+1,x
  adc #0
  sta entity_locals+raven_locals::x_velocity+1,x

followTestDone:

  ;keep x and y velocity under control
  lda entity_locals+raven_locals::x_velocity+1,x  ;high byte is "pixel speed"
  bpl xVelocityPositive
xVelocityNegative:
.scope

  cmp #(-RAVEN_MAXHORIZSPEED)
  bpl notMaxHoriz

  lda #(-RAVEN_MAXHORIZSPEED)
  sta entity_locals+raven_locals::x_velocity+1,x

notMaxHoriz:
.endscope

  jmp xVelocityTestDone
xVelocityPositive:
.scope
  cmp #(RAVEN_MAXHORIZSPEED)
  bmi notMaxHoriz

  lda #(RAVEN_MAXHORIZSPEED)
  sta entity_locals+raven_locals::x_velocity+1,x

notMaxHoriz:
.endscope

xVelocityTestDone:

  ;keep x and y velocity under control
  lda entity_locals+raven_locals::y_velocity+1,x  ;high byte is "pixel speed"
  bpl yVelocityPositive
yVelocityNegative:
.scope

  cmp #(-RAVEN_MAXVERTSPEED)
  bpl notMaxVert

  lda #(-RAVEN_MAXVERTSPEED)
  sta entity_locals+raven_locals::y_velocity+1,x

notMaxVert:
.endscope

  jmp yVelocityTestDone
yVelocityPositive:
.scope
  cmp #(RAVEN_MAXVERTSPEED)
  bmi notMaxVert

  lda #(RAVEN_MAXVERTSPEED)
  sta entity_locals+raven_locals::y_velocity+1,x

notMaxVert:
.endscope

yVelocityTestDone:

  jsr raven_draw

  rts

killRaven:

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

raven_draw:

  jsr entity_test_death_zone
  beq killRaven

  lda #<spritesheet1_raven_fly
  sta entity_locals+raven_locals::anim_address,x
  lda #>spritesheet1_raven_fly
  sta entity_locals+raven_locals::anim_address+1,x
  ;load raven width and height
  lda #RAVEN_WIDTH
  sta b2
  lda #RAVEN_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt
  lda #<spritesheet1_raven_fly
  sta entity_locals+raven_locals::anim_address,x
  lda #>spritesheet1_raven_fly
  sta entity_locals+raven_locals::anim_address+1,x

  jsr entity_reset_anim

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load raven width and height
  lda #RAVEN_WIDTH
  sta b2
  lda #RAVEN_HEIGHT
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

  jmp killRaven

nomolosNotAttacking:

  ldy #level_data_struct::raven_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda entity_locals+raven_locals::anim_address,x
  sta w2
  lda entity_locals+raven_locals::anim_address+1,x
  sta w2+1
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:
  lda #%01000000
  sta b2
  jmp entity_facing_test_done
entity_facing_right:
  lda #%00000000
  sta b2
entity_facing_test_done:
  jsr entity_draw_anim

ravenOffscreen:
  rts

.endproc

.endif
