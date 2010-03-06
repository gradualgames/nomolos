.ifndef FLAILITEM_INC
FLAILITEM_INC = 1

.export flailItemUpdate
.proc flailItemUpdate

  jsr entity_compute_screen_coordinates
  bpl skipJmpflailItemDie
  jmp flailItemDie
skipJmpflailItemDie:
  
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
  ora #nomolosAttackFlail
  sta nomolosSubState
      
  lda #<getItemSound
  sta w0
  lda #>getItemSound
  sta w0+1
  jsr sound_load
    
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
  
  jsr sprite_draw_metasprite_16bit
  
  rts

flailItemDie:

  lda #0
  sta entity_instances+entityRAM::alive,x
  rts
  
.endproc

.endif
