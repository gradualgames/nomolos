.ifndef FLAILITEM_INC
FLAILITEM_INC = 1

.export flail_item_update
.proc flail_item_update

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
      
  lda nomolos_state_secondary
  and #nomolosAttackSetMask
  ora #nomolosAttackFlail
  sta nomolos_state_secondary
      
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
  
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  jsr sprite_draw_metasprite_16bit
  
  rts

flailItemDie:

  lda #0
  sta entity_instances+entityRAM::alive,x
  rts
  
.endproc

.endif
