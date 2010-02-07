.ifndef MOUSE_INC
MOUSE_INC = 1

MOUSE_INITSTATE = 0
MOUSE_SITTHERESTATE = 1

.export mouseUpdate
mouseUpdate:

  lda entityPool+entityRAM::state,x
  cmp #MOUSE_INITSTATE
  beq mouseInit
  cmp #MOUSE_SITTHERESTATE
  beq mouseSitThere

mouseInit:

  ;reset the explosion animation object
  lda #$01
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  lda #MOUSE_SITTHERESTATE
  sta entityPool+entityRAM::state,x

  rts
  
mouseSitThere:

  jsr getEntityScreenCoordinates

  ;test x coordinate for whether the item should die.
  sec
  lda #$f0
  sbc w0
  lda #$ff
  sbc w0+1
  bmi mouseOnScreen
  
  jmp mouseDie
  
mouseOnScreen:
  
  ;load entity width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr compareEntityRectToNomolosRect
  
  bne @notTouching
  
  lda #1
  jsr addNomolosHealth
  
  ;playSound getHealthSound
  lda #<getHealthSound
  sta w0
  lda #>getHealthSound
  sta w0+1
  jsr loadSound
  
  jmp mouseDie
  
@notTouching:

  lda w0
  sta b0
  lda w1
  sta b1
  lda #0
  sta b2
  
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
  
  lda #<Mouse
  sta w2
  lda #>Mouse
  sta w2+1
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
  
mouseOffScreen:
  
  rts
  
mouseDie:

  lda #0
  sta entityPool+entityRAM::alive,x

  rts
  
.endif