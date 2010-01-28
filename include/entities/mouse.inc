.ifndef MOUSE_INC
MOUSE_INC = 1

MOUSE_INITSTATE = 0
MOUSE_SITTHERESTATE = 1

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

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta w1
  lda entityPool+entityRAM::positionY+1,x
  sta w1+1
  jsr cameraToScreenCoords

  ;save screen coordinates for use later
  lda w0
  pha
  lda w0+1
  pha
  lda w1
  pha
  lda w1+1
  pha
  
  ;test x coordinate for whether the item should die.
  sec
  lda #$f0
  sbc w0
  lda #$ff
  sbc w0+1
  bmi mouseOnScreen
  
  pla
  pla
  pla
  pla
  jmp mouseDie
  
mouseOnScreen:
  
  ;transfer Mouse rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda w0
  sta w2
  lda w0+1
  sta w2+1
  lda w1
  sta w3
  lda w1+1
  sta w3+1
  lda #$10
  sta b2
  lda #$10
  sta b3
  
  ;transfer Nomolos rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolosScreenX
  sta w4
  lda nomolosScreenX+1
  sta w4+1
  lda nomolosScreenY
  sta w5
  lda nomolosScreenY+1
  sta w5+1
  lda #nomolosWidth
  sta b4
  lda #nomolosHeight
  sta b5
  
  jsr rectInRect16
  
  bne @notTouching
  
  lda #1
  jsr addNomolosHealth
  
  ;playSound getHealthSound
  lda #<getHealthSound
  sta w0
  lda #>getHealthSound
  sta w0+1
  jsr loadSound
  
  ;restore stack from saving coordinates earlier
  pla
  pla
  pla
  pla
  
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
  
  ;restore and use screen coordinates
  pla
  sta w4+1
  pla
  sta w4
  pla 
  sta w3+1
  pla
  sta w3
  
  jsr drawAnimation16
  
mouseOffScreen:
  
  rts
  
mouseDie:

  lda #0
  sta entityPool+entityRAM::alive,x

  rts
  
.endif