.ifndef GRANK_INC
GRANK_INC = 1

GRANK_WIDTH = $10
GRANK_HEIGHT = $10

.struct grankLocals
  x_velocity .word
  y_velocity .word
.endstruct

GRANK_INITSTATE = 0
GRANK_FLYSTATE = 1

GRANK_VERTSPEED = 10
GRANK_MAXVERTSPEED = 2
GRANK_HORIZSPEED = 10
GRANK_MAXHORIZSPEED = 3

.proc grank_update

  ;load current state
  lda entity_instances+entityRAM::state,x
  ;figure out what state to jump to
  cmp #GRANK_INITSTATE
  beq grank_initState
  cmp #GRANK_FLYSTATE
  beq grank_flyState

grank_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set x velocity to 0
  lda #0
  sta entity_locals+grankLocals::x_velocity,x
  sta entity_locals+grankLocals::x_velocity+1,x

  ;set y velocity to 0
  sta entity_locals+grankLocals::y_velocity,x
  sta entity_locals+grankLocals::y_velocity+1,x

  ;switch state to "fly"
  lda #GRANK_FLYSTATE
  sta entity_instances+entityRAM::state,x
  rts

grank_flyState:

  jsr entity_compute_screen_coordinates

  ;add x velocity to 24 bit X coordinate with sign extension
.scope addXVelocity
  clc
  lda entity_locals+grankLocals::x_velocity,x
  adc entity_instances+entityRAM::positionXFine,x
  sta entity_instances+entityRAM::positionXFine,x
  lda entity_locals+grankLocals::x_velocity+1,x
  bmi signExtend
  adc entity_instances+entityRAM::positionX,x
  sta entity_instances+entityRAM::positionX,x
  lda #0
  adc entity_instances+entityRAM::positionX+1,x
  sta entity_instances+entityRAM::positionX+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entityRAM::positionX,x
  sta entity_instances+entityRAM::positionX,x
  lda #$ff
  adc entity_instances+entityRAM::positionX+1,x
  sta entity_instances+entityRAM::positionX+1,x
signExtendAddDone:
.endscope

  ;add y velocity to 24 bit Y coordinate with sign extension
.scope addYVelocity
  clc
  lda entity_locals+grankLocals::y_velocity,x
  adc entity_instances+entityRAM::positionYFine,x
  sta entity_instances+entityRAM::positionYFine,x
  lda entity_locals+grankLocals::y_velocity+1,x
  bmi signExtend
  adc entity_instances+entityRAM::positionY,x
  sta entity_instances+entityRAM::positionY,x
  lda #0
  adc entity_instances+entityRAM::positionY+1,x
  sta entity_instances+entityRAM::positionY+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entityRAM::positionY,x
  sta entity_instances+entityRAM::positionY,x
  lda #$ff
  adc entity_instances+entityRAM::positionY+1,x
  sta entity_instances+entityRAM::positionY+1,x
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
  lda entity_locals+grankLocals::y_velocity,x
  sec
  sbc #GRANK_VERTSPEED
  sta entity_locals+grankLocals::y_velocity,x
  lda entity_locals+grankLocals::y_velocity+1,x
  sbc #0
  sta entity_locals+grankLocals::y_velocity+1,x

  jmp followVertTestDone
followDown:

  ;add to y velocity
  lda entity_locals+grankLocals::y_velocity,x
  clc
  adc #GRANK_VERTSPEED
  sta entity_locals+grankLocals::y_velocity,x
  lda entity_locals+grankLocals::y_velocity+1,x
  adc #0
  sta entity_locals+grankLocals::y_velocity+1,x

followVertTestDone:

  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:

  ;subtract from x velocity
  lda entity_locals+grankLocals::x_velocity,x
  sec
  sbc #GRANK_HORIZSPEED
  sta entity_locals+grankLocals::x_velocity,x
  lda entity_locals+grankLocals::x_velocity+1,x
  sbc #0
  sta entity_locals+grankLocals::x_velocity+1,x

  jmp followTestDone
followToRight:

  ;add to x velocity
  lda entity_locals+grankLocals::x_velocity,x
  clc
  adc #GRANK_HORIZSPEED
  sta entity_locals+grankLocals::x_velocity,x
  lda entity_locals+grankLocals::x_velocity+1,x
  adc #0
  sta entity_locals+grankLocals::x_velocity+1,x

followTestDone:

  ;keep x and y velocity under control
  lda entity_locals+grankLocals::x_velocity+1,x  ;high byte is "pixel speed"
  bpl xVelocityPositive
xVelocityNegative:
.scope

  cmp #(-GRANK_MAXHORIZSPEED)
  bpl notMaxHoriz

  lda #(-GRANK_MAXHORIZSPEED)
  sta entity_locals+grankLocals::x_velocity+1,x

notMaxHoriz:
.endscope

  jmp xVelocityTestDone
xVelocityPositive:
.scope
  cmp #(GRANK_MAXHORIZSPEED)
  bmi notMaxHoriz

  lda #(GRANK_MAXHORIZSPEED)
  sta entity_locals+grankLocals::x_velocity+1,x

notMaxHoriz:
.endscope

xVelocityTestDone:

  ;keep x and y velocity under control
  lda entity_locals+grankLocals::y_velocity+1,x  ;high byte is "pixel speed"
  bpl yVelocityPositive
yVelocityNegative:
.scope

  cmp #(-GRANK_MAXVERTSPEED)
  bpl notMaxVert

  lda #(-GRANK_MAXVERTSPEED)
  sta entity_locals+grankLocals::y_velocity+1,x

notMaxVert:
.endscope

  jmp yVelocityTestDone
yVelocityPositive:
.scope
  cmp #(GRANK_MAXVERTSPEED)
  bmi notMaxVert

  lda #(GRANK_MAXVERTSPEED)
  sta entity_locals+grankLocals::y_velocity+1,x

notMaxVert:
.endscope

yVelocityTestDone:

  jsr grank_draw

  rts

grank_draw:

  jsr entity_test_death_zone
  beq killGrank

  ;load grank width and height
  lda #GRANK_WIDTH
  sta b2
  lda #GRANK_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load grank width and height
  lda #GRANK_WIDTH
  sta b2
  lda #GRANK_HEIGHT
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

  jmp killGrank

nomolosNotAttacking:

  ldy #level_data_struct::grank_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::grank_fly
  lda #0
  sta b2
  jsr entity_draw_anim

grankOffscreen:
  rts

killGrank:

  ;make it dead
  jsr entity_kill

  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ;get out low byte of positionX
  lda entity_instances+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1

  ;get out positionY
  lda entity_instances+entityRAM::positionY,x
  sta b1

  jsr entity_spawn

  rts
.endproc

.endif
