.ifndef ONEUP_INC
ONEUP_INC = 1

.export oneUpUpdate
.proc oneUpUpdate

  jsr getEntityScreenCoordinates
  
  ;test x coordinate for whether the item should die.
  sec
  lda #$f0
  sbc entityScreenX
  lda #$ff
  sbc entityScreenX+1
  bmi skipJmpOneUpDie

  jmp oneUpDie
skipJmpOneUpDie:
  
  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entityScreenX
  sta w2
  lda entityScreenX+1
  sta w2+1
  lda entityScreenY
  sta w3
  lda entityScreenY+1
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
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
  
  lda #1
  jsr addNomolosLife
    
  lda #<getOneUpSound
  sta w0
  lda #>getOneUpSound
  sta w0+1
  jsr loadSound
    
  jmp oneUpDie
  
notTouching:

  lda #<OneUp0
  sta w0
  lda #>OneUp0
  sta w0+1
  
  lda entityScreenX
  sta w3
  lda entityScreenX+1
  sta w3+1
  lda entityScreenY
  sta w4
  lda entityScreenY+1
  sta w4+1
  
  jsr drawMetaSprite16
  
  rts

oneUpDie:

  lda #0
  sta entityPool+entityRAM::alive,x
  rts
  
.endproc

.endif
