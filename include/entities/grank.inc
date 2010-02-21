.ifndef GRANK_INC
GRANK_INC = 1

.struct grankLocals
  x_velocity .word
  y_velocity .word
.endstruct

GRANK_INITSTATE = 0
GRANK_FLYSTATE = 1

GRANK_VERTSPEED = 20
GRANK_HORIZSPEED = 20

.export grankUpdate
.proc grankUpdate

  ;load current state
  lda entityPool+entityRAM::state,x
  ;figure out what state to jump to
  cmp #GRANK_INITSTATE
  beq grank_initState
  cmp #GRANK_FLYSTATE
  beq grank_flyState

grank_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  ;set x velocity to 0
  lda #0
  sta entityLocals+grankLocals::x_velocity,x
  sta entityLocals+grankLocals::x_velocity+1,x
  
  ;set y velocity to 0
  sta entityLocals+grankLocals::y_velocity,x
  sta entityLocals+grankLocals::y_velocity+1,x
  
  ;switch state to "fly"
  lda #GRANK_FLYSTATE
  sta entityPool+entityRAM::state,x
  rts

grank_flyState:

  jsr getEntityScreenCoordinates
  
  ;add x velocity to 24 bit X coordinate with sign extension
.scope addXVelocity
  clc
  lda entityLocals+grankLocals::x_velocity,x
  adc entityPool+entityRAM::positionXFine,x
  sta entityPool+entityRAM::positionXFine,x
  lda entityLocals+grankLocals::x_velocity+1,x
  bmi signExtend
  adc entityPool+entityRAM::positionX,x
  sta entityPool+entityRAM::positionX,x
  lda #0
  adc entityPool+entityRAM::positionX+1,x
  sta entityPool+entityRAM::positionX+1,x
  jmp signExtendAddDone
signExtend:
  adc entityPool+entityRAM::positionX,x
  sta entityPool+entityRAM::positionX,x
  lda #$ff
  adc entityPool+entityRAM::positionX+1,x
  sta entityPool+entityRAM::positionX+1,x
signExtendAddDone:
.endscope

  ;add y velocity to 24 bit Y coordinate with sign extension
.scope addYVelocity
  clc
  lda entityLocals+grankLocals::y_velocity,x
  adc entityPool+entityRAM::positionYFine,x
  sta entityPool+entityRAM::positionYFine,x
  lda entityLocals+grankLocals::y_velocity+1,x
  bmi signExtend
  adc entityPool+entityRAM::positionY,x
  sta entityPool+entityRAM::positionY,x
  lda #0
  adc entityPool+entityRAM::positionY+1,x
  sta entityPool+entityRAM::positionY+1,x
  jmp signExtendAddDone
signExtend:
  adc entityPool+entityRAM::positionY,x
  sta entityPool+entityRAM::positionY,x
  lda #$ff
  adc entityPool+entityRAM::positionY+1,x
  sta entityPool+entityRAM::positionY+1,x
signExtendAddDone:
.endscope

  lda entityScreenY
  sec
  sbc nomolosScreenY
  lda entityScreenY+1
  sbc nomolosScreenY+1
  
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

  lda entityScreenX
  sec
  sbc nomolosScreenX
  lda entityScreenX+1
  sbc nomolosScreenX+1
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
  
  jsr grank_draw

  rts

grank_draw:

  ;test the x coordinate for whether it is a certain distance off screen. compare it
  ;to -32.
  ;-32 - -40 = 8. positive = offscreen, die. negative = onscreen, do not die.
  sec
  lda #$e0
  sbc entityScreenX
  lda #$ff
  sbc entityScreenX+1
  bmi grankOnScreen
  
  ;jmp killGrank
  
grankOnScreen:  
  
  ;load grank width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr compareEntityRectToNomolosRect
  
  bne :+
  
  jsr hurtNomolos
  
:
  jsr nomolosDeadly
  beq nomolosNotAttacking
  
  ;load grank width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr compareEntityRectToHitboxRect
  
  bne nomolosNotAttacking
  
  ;play an explode sound
  lda #<hitSound
  sta w0
  lda #>hitSound
  sta w0+1
  jsr loadSound
  
  jmp killGrank
  
nomolosNotAttacking:

  ;load address of animation object into w1
  lda #<(entityPool+entityRAM::animationObject)
  sta w1
  lda #>(entityPool+entityRAM::animationObject)
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
  lda #<GrankFly
  sta w2
  lda #>GrankFly
  sta w2+1
  lda #0
  sta b2
  jsr updateAnimation  
  
  lda entityScreenX
  sta w3
  lda entityScreenX+1
  sta w3+1
  lda entityScreenY
  sta w4
  lda entityScreenY+1
  sta w4+1
  
  jsr drawAnimation16
grankOffscreen:
  rts
  
killGrank:

  ;make it dead
  lda #0
  sta entityPool+entityRAM::alive,x
  
  ;spawn an explosion entity
  lda #ExplosionIndex
  sta b0

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  
  jsr spawnEntity

  rts
.endproc
  
.endif
