.ifndef BEEDIE_INC
BEEDIE_INC = 1

.struct beedieLocals
  y_velocity .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
.endstruct

BEEDIE_INITSTATE = 0
BEEDIE_RUNSTATE = 1

.export beedieUpdate
.proc beedieUpdate

  ;load current state
  lda entityPool+entityRAM::state,x
  ;figure out what state to jump to
  cmp #BEEDIE_INITSTATE
  beq beedie_initState
  cmp #BEEDIE_RUNSTATE
  beq beedie_runState

beedie_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  ;set vertical velocity to zero
  lda #0
  sta entityLocals+beedieLocals::y_velocity,x
  
  ;switch state to "run"
  lda #BEEDIE_RUNSTATE
  sta entityPool+entityRAM::state,x
  rts

beedie_runState:

  ;increment the vertical velocity
  lda entityLocals+beedieLocals::y_velocity+1,x
  cmp #10
  bpl stopAccelerating
  clc
  lda entityLocals+beedieLocals::y_velocity,x
  adc #$20
  sta entityLocals+beedieLocals::y_velocity,x
  lda entityLocals+beedieLocals::y_velocity+1,x
  adc #0
  sta entityLocals+beedieLocals::y_velocity+1,x
stopAccelerating:
  
  ;add vertical velocity to 24 bit Y coordinate
  clc
  lda entityLocals+beedieLocals::y_velocity,x
  adc entityPool+entityRAM::positionYFine,x
  sta entityPool+entityRAM::positionYFine,x
  lda entityLocals+beedieLocals::y_velocity+1,x
  adc entityPool+entityRAM::positionY,x
  sta entityPool+entityRAM::positionY,x
  lda #0
  adc entityPool+entityRAM::positionY+1,x
  sta entityPool+entityRAM::positionY+1,x
  
  ;perform collision detection and eject if necessary
  ;load the entity's X coordinate + 8
  clc
  lda entityPool+entityRAM::positionX,x
  adc #8
  sta entityLocals+beedieLocals::x_collisionPointBottom,x
  sta w0
  lda entityPool+entityRAM::positionX+1,x
  adc #0
  sta entityLocals+beedieLocals::x_collisionPointBottom+1,x
  sta w0+1
  ;load the entity's Y coordinate + 16
  clc
  lda entityPool+entityRAM::positionY,x
  adc #16
  sta entityLocals+beedieLocals::y_collisionPointBottom,x
  sta w1
  lda entityPool+entityRAM::positionY+1,x
  adc #0
  sta entityLocals+beedieLocals::y_collisionPointBottom+1,x
  sta w1+1
  
  jsr testMapCollision
  lda b1
  bne noBottomCollision
  
  lda #0
  sta entityLocals+beedieLocals::y_velocity,x
  sta entityLocals+beedieLocals::y_velocity+1,x
  
  ;there was a collision beneath the beedie. calculate penetration distance and eject.
  lda entityLocals+beedieLocals::y_collisionPointBottom,x
  and #penetrationCalculationMask
  sta entityLocals+beedieLocals::y_belowPenetration,x
  sec
  lda entityPool+entityRAM::positionY,x
  sbc entityLocals+beedieLocals::y_belowPenetration,x
  sta entityPool+entityRAM::positionY,x
  lda entityPool+entityRAM::positionY+1,x
  sbc #0
  sta entityPool+entityRAM::positionY+1,x
  
noBottomCollision:  
  
  jsr beedie_draw

  rts
  
beedie_draw:

  jsr getEntityScreenCoordinates

  ;test the x coordinate for whether it is a certain distance off screen. compare it
  ;to -32.
  ;-32 - -40 = 8. positive = offscreen, die. negative = onscreen, do not die.
  sec
  lda #$e0
  sbc entityScreenX
  lda #$ff
  sbc entityScreenX+1
  bmi beedieOnScreen
  
  jmp killBeedie
  
beedieOnScreen:  
  
  ;load beedie width and height
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
  
  ;load beedie width and height
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
  
  jmp killBeedie
  
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
  
  ;load address of beedie animation definition into w2
  lda #<BeedieBlob
  sta w2
  lda #>BeedieBlob
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
beedieOffscreen:
  rts
  
killBeedie:

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
