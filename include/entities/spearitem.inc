.ifndef SPEARITEM_INC
SPEARITEM_INC = 1

.export spearItemUpdate
.proc spearItemUpdate

  jsr entity_compute_screen_coordinates
  bpl skipJmpspearItemDie
  jmp spearItemDie
skipJmpspearItemDie:
  
  ;load entity width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_nomolos
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
      
  lda nomolosSubState
  and #nomolosAttackSetMask
  ora #nomolosAttackSpear
  sta nomolosSubState
      
  lda #<getItemSound
  sta w0
  lda #>getItemSound
  sta w0+1
  jsr loadSound
    
  jmp spearItemDie
  
notTouching:

  lda #<Spear0
  sta w0
  lda #>Spear0
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

spearItemDie:

  lda #0
  sta entityPool+entityRAM::alive,x
  rts
  
.endproc

.endif
