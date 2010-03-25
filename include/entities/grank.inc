.ifndef GRANK_INC
GRANK_INC = 1

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

.export grank_update
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
  lda #1
  sta entity_instances+entityRAM::animationObject,x
  lda #$ff
  sta entity_instances+entityRAM::animationObject+1,x
  
  ;set x velocity to 0
  lda #0
  sta entityLocals+grankLocals::x_velocity,x
  sta entityLocals+grankLocals::x_velocity+1,x
  
  ;set y velocity to 0
  sta entityLocals+grankLocals::y_velocity,x
  sta entityLocals+grankLocals::y_velocity+1,x
  
  ;switch state to "fly"
  lda #GRANK_FLYSTATE
  sta entity_instances+entityRAM::state,x
  rts

grank_flyState:

  jsr entity_compute_screen_coordinates
  
  ;add x velocity to 24 bit X coordinate with sign extension
.scope addXVelocity
  clc
  lda entityLocals+grankLocals::x_velocity,x
  adc entity_instances+entityRAM::positionXFine,x
  sta entity_instances+entityRAM::positionXFine,x
  lda entityLocals+grankLocals::x_velocity+1,x
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
  lda entityLocals+grankLocals::y_velocity,x
  adc entity_instances+entityRAM::positionYFine,x
  sta entity_instances+entityRAM::positionYFine,x
  lda entityLocals+grankLocals::y_velocity+1,x
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
  lda entityLocals+grankLocals::y_velocity,x
  sec
  sbc #GRANK_VERTSPEED
  sta entityLocals+grankLocals::y_velocity,x
  lda entityLocals+grankLocals::y_velocity+1,x
  sbc #0
  sta entityLocals+grankLocals::y_velocity+1,x

  jmp followVertTestDone
followDown:
  
  ;add to y velocity
  lda entityLocals+grankLocals::y_velocity,x
  clc
  adc #GRANK_VERTSPEED
  sta entityLocals+grankLocals::y_velocity,x
  lda entityLocals+grankLocals::y_velocity+1,x
  adc #0
  sta entityLocals+grankLocals::y_velocity+1,x

followVertTestDone:

  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:
  
  ;subtract from x velocity
  lda entityLocals+grankLocals::x_velocity,x
  sec
  sbc #GRANK_HORIZSPEED
  sta entityLocals+grankLocals::x_velocity,x
  lda entityLocals+grankLocals::x_velocity+1,x
  sbc #0
  sta entityLocals+grankLocals::x_velocity+1,x
  
  jmp followTestDone
followToRight:
  
  ;add to x velocity
  lda entityLocals+grankLocals::x_velocity,x
  clc
  adc #GRANK_HORIZSPEED
  sta entityLocals+grankLocals::x_velocity,x
  lda entityLocals+grankLocals::x_velocity+1,x
  adc #0
  sta entityLocals+grankLocals::x_velocity+1,x
  
followTestDone:

  ;keep x and y velocity under control
  lda entityLocals+grankLocals::x_velocity+1,x  ;high byte is "pixel speed"
  bpl xVelocityPositive
xVelocityNegative:
.scope 
  
  cmp #(-GRANK_MAXHORIZSPEED)
  bpl notMaxHoriz
  
  lda #(-GRANK_MAXHORIZSPEED)
  sta entityLocals+grankLocals::x_velocity+1,x
  
notMaxHoriz:
.endscope
  
  jmp xVelocityTestDone
xVelocityPositive:
.scope
  cmp #(GRANK_MAXHORIZSPEED)
  bmi notMaxHoriz
  
  lda #(GRANK_MAXHORIZSPEED)
  sta entityLocals+grankLocals::x_velocity+1,x
  
notMaxHoriz:
.endscope

xVelocityTestDone:
  
  ;keep x and y velocity under control
  lda entityLocals+grankLocals::y_velocity+1,x  ;high byte is "pixel speed"
  bpl yVelocityPositive
yVelocityNegative:
.scope 
  
  cmp #(-GRANK_MAXVERTSPEED)
  bpl notMaxVert
  
  lda #(-GRANK_MAXVERTSPEED)
  sta entityLocals+grankLocals::y_velocity+1,x
  
notMaxVert:
.endscope
  
  jmp yVelocityTestDone
yVelocityPositive:
.scope
  cmp #(GRANK_MAXVERTSPEED)
  bmi notMaxVert
  
  lda #(GRANK_MAXVERTSPEED)
  sta entityLocals+grankLocals::y_velocity+1,x
  
notMaxVert:
.endscope

yVelocityTestDone:
  
  jsr grank_draw

  rts

grank_draw:

  jsr entity_test_death_zone
  beq killGrank
  
  ;load grank width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking
  
  ;load grank width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_hitbox
  
  bne nomolosNotAttacking
  
  ;play an explode sound
  lda #<hitSound
  sta w0
  lda #>hitSound
  sta w0+1
  jsr sound_load
  
  jmp killGrank
  
nomolosNotAttacking:

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
  
  ;load address of grank animation definition into w2
  ldy #ROMDefinitionTableStruct::GrankFly
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1
  lda #0
  sta b2
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
grankOffscreen:
  rts
  
killGrank:

  ;make it dead
  lda #0
  sta entity_instances+entityRAM::alive,x
  
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
