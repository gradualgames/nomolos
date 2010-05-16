.ifndef FLAILITEM_INC
FLAILITEM_INC = 1

FLAILITEM_WIDTH = $10
FLAILITEM_HEIGHT = $08

.export flail_item_update
.proc flail_item_update

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq flailItemDie
  
  ;load entity width and height
  lda #FLAILITEM_WIDTH
  sta b2
  lda #FLAILITEM_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
      
  lda nomolos_state_secondary
  and #nomolosAttackSetMask
  ora #nomolosAttackFlail
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
    
  jmp flailItemDie
  
notTouching:

  ldy #ROMDefinitionTableStruct::NomolosOffset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #ROMDefinitionTableStruct::FlailItem0
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

flailItemDie:

  jsr entity_kill
  rts
  
.endproc

.endif
