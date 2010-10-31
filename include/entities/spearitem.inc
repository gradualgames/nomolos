.ifndef SPEARITEM_INC
SPEARITEM_INC = 1

SPEARITEM_WIDTH = $18
SPEARITEM_HEIGHT = $08

SPEARITEM_INITSTATE = $00
SPEARITEM_SITTHERESTATE = $01

.proc spear_item_update

  lda entity_instances+entity_instance::state,x
  cmp #SPEARITEM_INITSTATE
  beq spearitem_init
  cmp #SPEARITEM_SITTHERESTATE
  beq spearitem_sit_there

spearitem_init:

  jsr entity_kill_if_already_seen

  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #8
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_instances+entity_instance::position_y+1,x
  
  lda #SPEARITEM_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  rts

spearitem_sit_there:

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
  and #nomolos_attack_set_mask
  ora #nomolos_attack_state_spear
  sta nomolos_state_secondary

  ;play a get item sound
  txa
  pha

  lda #<get_item_sound
  sta sound_param_word_0
  lda #>get_item_sound
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax

  jmp spearItemDie

notTouching:

  ldy #level_data_struct::nomolos_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::spear_0
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
