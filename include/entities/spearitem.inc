.ifndef SPEARITEM_INC
SPEARITEM_INC = 1

SPEARITEM_WIDTH = $18
SPEARITEM_HEIGHT = $08

.export spear_item_update
.proc spear_item_update

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq spearItemDie
  
  ;load entity width and height
  lda #SPEARITEM_WIDTH
  sta b2
  lda #SPEARITEM_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
      
  lda nomolos_state_secondary
  and #nomolosAttackSetMask
  ora #nomolosAttackSpear
  sta nomolos_state_secondary
      
  ;play a get item sound
  txa
  pha
  
  lda #<getItemSound
  sta sound_param_word_0
  lda #>getItemSound
  sta sound_param_word_0+1
  
  lda #0
  sta sound_param_byte_0
  
  ldx #soundeffect_two
  jsr stream_initialize
  
  pla
  tax
    
  jmp spearItemDie
  
notTouching:

  ldy #ROMDefinitionTableStruct::NomolosOffset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

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

  jsr entity_kill
  rts
  
.endproc

.endif
