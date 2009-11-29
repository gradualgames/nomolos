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

  jmp returnFromEntityUpdate
  
mouseSitThere:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;add 16 to positionX  
  clc
  lda w0
  adc #$10
  sta w0
  lda w0+1
  adc #0
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta w1
  lda entityPool+entityRAM::positionY+1,x
  sta w1+1
  jsr cameraToScreenCoords
  beq @skipMouseOffScreen
  jmp mouseOffScreen
@skipMouseOffScreen:

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
  
  beq @skipMouseDie
  jmp mouseDie
@skipMouseDie:
  
  ;transfer Mouse rectangle to w2 = top left and w3 = bot right
  lda w0
  sta w2
  clc
  adc #$10
  sta w3
  lda w1
  sta w2+1
  clc
  adc #$10
  sta w3+1
  
  ;transfer Nomolos rectangle to w4 = top left and w5 = bot right
  lda nomolosScreenX
  sta w4
  clc
  adc #nomolosWidth
  sta w5
  lda nomolosScreenY
  sta w4+1
  clc
  adc #nomolosHeight
  sta w5+1
  
  jsr rectInRect
  
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
  
  jsr drawAnimation
  
mouseOffScreen:
  
  jmp returnFromEntityUpdate
  
mouseDie:

  lda #0
  sta entityPool+entityRAM::alive,x

  jmp returnFromEntityUpdate
  
.endif