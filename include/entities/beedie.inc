.ifndef BEEDIE_INC
BEEDIE_INC = 1

BEEDIE_INITSTATE = 0
BEEDIE_MOVERIGHTSTATE = 1
BEEDIE_MOVELEFTSTATE = 2

.export beedieUpdate
.proc beedieUpdate

  ;load current state
  lda entityPool+entityRAM::state,x
  ;figure out what state to jump to
  cmp #BEEDIE_INITSTATE
  beq beedie_initState
  cmp #BEEDIE_MOVERIGHTSTATE
  beq beedie_moveRightState
  cmp #BEEDIE_MOVELEFTSTATE
  beq beedie_moveLeftState

beedie_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  ;switch state to "run"
  lda #BEEDIE_MOVELEFTSTATE
  sta entityPool+entityRAM::state,x
  rts

beedie_moveRightState:

  ;add 1 to PositionX
  clc
  lda entityPool+entityRAM::positionX,x
  adc #1
  sta entityPool+entityRAM::positionX,x
  lda entityPool+entityRAM::positionX+1,x
  adc #0
  sta entityPool+entityRAM::positionX+1,x
  
  ;do PositionX - spawnPositionX
  sec
  lda entityPool+entityRAM::positionX,x
  sbc entityPool+entityRAM::spawnPositionX,x
  sta w0
  lda entityPool+entityRAM::positionX+1,x
  sbc entityPool+entityRAM::spawnPositionX+1,x
  sta w0+1
  
  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1
  bne dontSwitchToLeftState
  
  lda #BEEDIE_MOVELEFTSTATE
  sta entityPool+entityRAM::state,x
  
dontSwitchToLeftState:

  jsr beedie_draw

  rts

beedie_moveLeftState:

  ;sub 1 from PositionX
  sec
  lda entityPool+entityRAM::positionX,x
  sbc #1
  sta entityPool+entityRAM::positionX,x
  lda entityPool+entityRAM::positionX+1,x
  sbc #0
  sta entityPool+entityRAM::positionX+1,x
  
  ;do spawnPositionX - PositionX
  sec
  lda entityPool+entityRAM::spawnPositionX,x
  sbc entityPool+entityRAM::positionX,x 
  sta w0
  lda entityPool+entityRAM::spawnPositionX+1,x
  sbc entityPool+entityRAM::positionX+1,x 
  sta w0+1
  
  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1
  
  bne dontSwitchToRightState
  
  lda #BEEDIE_MOVERIGHTSTATE
  sta entityPool+entityRAM::state,x
  
dontSwitchToRightState:

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
