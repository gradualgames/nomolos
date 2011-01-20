.ifndef THOGUTH_INC
THOGUTH_INC = 1

THOGUTH_WIDTH = $18
THOGUTH_HEIGHT = $20

THOGUTH_INITSTATE = $00
THOGUTH_SITTHERESTATE = $01

.proc thoguth_update

  lda entity_instances+entity_instance::state,x
  cmp #THOGUTH_INITSTATE
  beq thoguth_init
  cmp #THOGUTH_SITTHERESTATE
  beq thoguth_sit_there

thoguth_init:

  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #32
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x
  
  lda #THOGUTH_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  rts

thoguth_sit_there:

  jsr entity_compute_screen_coordinates

  lda #%01000000
  sta b2
  
  ldy #level_data_struct::thoguth_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::thoguth_stand
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
  
  ldy #level_data_struct::thoguth_overlay0
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  jsr sprite_draw_metasprite_16bit
  
  ldy #level_data_struct::thoguth_overlay1
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  jsr sprite_draw_metasprite_16bit
  
  ldy #level_data_struct::thoguth_overlay2
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  jsr sprite_draw_metasprite_16bit
  
  rts

.endproc

.endif
