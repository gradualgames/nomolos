.ifndef SPEARITEM_INC
SPEARITEM_INC = 1

.export spear_item_update
.proc spear_item_update

  jsr entity_test_death_zone
  beq spearItemDie
  
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
  ora #nomolosAttackSpear
  sta nomolos_state_secondary
      
  lda #<getItemSound
  sta w0
  lda #>getItemSound
  sta w0+1
  jsr sound_load
    
  jmp spearItemDie
  
notTouching:

  ldy #ROMDefinitionTableStruct::Spear0
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
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

spearItemDie:

  lda #0
  sta entity_instances+entityRAM::alive,x
  rts
  
.endproc

.endif
