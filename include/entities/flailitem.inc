.ifndef FLAILITEM_INC
FLAILITEM_INC = 1

.export flailItemUpdate
.proc flailItemUpdate

  jsr getEntityScreenCoordinates
  bpl skipJmpflailItemDie
  jmp flailItemDie
skipJmpflailItemDie:
  
  ;load entity width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr compareEntityRectToNomolosRect
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
      
  lda nomolosSubState
  and #nomolosAttackSetMask
  ora #nomolosAttackFlail
  sta nomolosSubState
      
  lda #<getFlailItemSound
  sta w0
  lda #>getFlailItemSound
  sta w0+1
  jsr loadSound
    
  jmp flailItemDie
  
notTouching:

  lda #<FlailItem0
  sta w0
  lda #>FlailItem0
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

flailItemDie:

  lda #0
  sta entityPool+entityRAM::alive,x
  rts
  
.endproc

.endif
