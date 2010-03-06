.ifndef BEEDIE_INC
BEEDIE_INC = 1

.struct beedieLocals
  y_velocity .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
  restCounter .byte
  directionFlag .byte
.endstruct

BEEDIE_RESTCOUNTER_RESTLENGTH = 25

BEEDIE_DIRECTIONFLAG_LEFT =  %00000000
BEEDIE_DIRECTIONFLAG_RIGHT = %00000001

BEEDIE_INITSTATE = 0
BEEDIE_RESTSTATE = 1
BEEDIE_JUMPSTATE = 2

.export beedieUpdate
.proc beedieUpdate

  ;load current state
  lda entityPool+entityRAM::state,x
  ;figure out what state to jump to
  cmp #BEEDIE_INITSTATE
  beq beedie_initState
  cmp #BEEDIE_RESTSTATE
  beq beedie_restState
  cmp #BEEDIE_JUMPSTATE
  beq beedie_jumpState

beedie_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  ;set vertical velocity to zero
  lda #0
  sta entityLocals+beedieLocals::y_velocity,x
  
  ;set rest counter
  lda #BEEDIE_RESTCOUNTER_RESTLENGTH
  sta entityLocals+beedieLocals::restCounter,x
  
  ;set direction flag
  lda #BEEDIE_DIRECTIONFLAG_LEFT
  sta entityLocals+beedieLocals::directionFlag,x
  
  ;switch state to "jump"
  lda #BEEDIE_JUMPSTATE
  sta entityPool+entityRAM::state,x
  rts

beedie_restState:

  ;decrement rest counter
  dec entityLocals+beedieLocals::restCounter,x
  bne stillResting
  
  ;on rest counter = 0, jump to jump state init and set vertical velocity
  lda #$0a
  sta entityLocals+beedieLocals::y_velocity,x
  lda #$fd
  sta entityLocals+beedieLocals::y_velocity+1,x
  lda #BEEDIE_JUMPSTATE
  sta entityPool+entityRAM::state,x
  
stillResting:

  jsr getEntityScreenCoordinates
  jsr beedie_draw

  rts
  
beedie_jumpState:

  jsr getEntityScreenCoordinates

  ;slide beedie in the direction he is facing
  lda entityLocals+beedieLocals::directionFlag,x
  bne beedieGoingRight
beedieGoingLeft:

  ;test for collision on left side of beedie. reverse direction if true
  lda entityPool+entityRAM::positionX,x
  sta w0
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  lda entityPool+entityRAM::positionY,x
  clc
  adc #8
  sta w1
  lda entityPool+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr testMapCollision
  lda b1
  beq noLeftCollision
  lda #BEEDIE_DIRECTIONFLAG_RIGHT
  sta entityLocals+beedieLocals::directionFlag,x
noLeftCollision:

  lda entityPool+entityRAM::positionX,x
  sec
  sbc #1
  sta entityPool+entityRAM::positionX,x
  lda entityPool+entityRAM::positionX+1,x
  sbc #0
  sta entityPool+entityRAM::positionX+1,x
  
  jmp beedieDirectionTestDone
beedieGoingRight:

  ;test for collision on right side of beedie. reverse direction if true
  lda entityPool+entityRAM::positionX,x
  clc
  adc #$10
  sta w0
  lda entityPool+entityRAM::positionX+1,x
  adc #0
  sta w0+1
  lda entityPool+entityRAM::positionY,x
  clc
  adc #8
  sta w1
  lda entityPool+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr testMapCollision
  lda b1
  beq noRightCollision
  lda #BEEDIE_DIRECTIONFLAG_LEFT
  sta entityLocals+beedieLocals::directionFlag,x
noRightCollision:

  lda entityPool+entityRAM::positionX,x
  clc
  adc #1
  sta entityPool+entityRAM::positionX,x
  lda entityPool+entityRAM::positionX+1,x
  adc #0
  sta entityPool+entityRAM::positionX+1,x
beedieDirectionTestDone:

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
  
  ;add vertical velocity to 24 bit Y coordinate with sign extension
  clc
  lda entityLocals+beedieLocals::y_velocity,x
  adc entityPool+entityRAM::positionYFine,x
  sta entityPool+entityRAM::positionYFine,x
  lda entityLocals+beedieLocals::y_velocity+1,x
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
  beq noBottomCollision
  
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
  
  ;set rest counter and transition to rest state. set direction bit based on Nomolos' location.
  lda #BEEDIE_RESTCOUNTER_RESTLENGTH
  sta entityLocals+beedieLocals::restCounter,x
  lda #BEEDIE_RESTSTATE
  sta entityPool+entityRAM::state,x
  
  lda entityScreenX
  sec
  sbc nomolosScreenX
  lda entityScreenX+1
  sbc nomolosScreenX+1
  bmi followToRight
followToLeft:
  lda #BEEDIE_DIRECTIONFLAG_LEFT
  sta entityLocals+beedieLocals::directionFlag,x
  jmp followTestDone
followToRight:
  lda #BEEDIE_DIRECTIONFLAG_RIGHT
  sta entityLocals+beedieLocals::directionFlag,x
followTestDone:
  
noBottomCollision:  
  
  jsr beedie_draw

  rts
  
beedie_draw:

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
  
  jsr nomolos_hurt
  
:
  jsr nomolos_is_deadly
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
