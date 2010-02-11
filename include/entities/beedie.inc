.ifndef BEEDIE_INC
BEEDIE_INC = 1

BEEDIE_INITSTATE = 0
BEEDIE_RESTSTATE = 1

.export beedieUpdate
.proc beedieUpdate

  ;load current state
  lda entityPool+entityRAM::state,x
  ;figure out what state to jump to
  cmp #BEEDIE_INITSTATE
  beq beedie_initState
  cmp #BEEDIE_RESTSTATE
  beq beedie_restState

beedie_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  ;switch state to "rest"
  lda #BEEDIE_RESTSTATE
  sta entityPool+entityRAM::state,x
  rts

beedie_restState:

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
