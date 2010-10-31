.ifndef FLAILITEM_INC
FLAILITEM_INC = 1

FLAILITEM_WIDTH = $10
FLAILITEM_HEIGHT = $08

FLAILITEM_INITSTATE = $00
FLAILITEM_SITTHERESTATE = $01

.proc flail_item_update

  lda entity_instances+entity_instance::state,x
  cmp #FLAILITEM_INITSTATE
  beq flail_item_init
  cmp #FLAILITEM_SITTHERESTATE
  beq flail_item_sit_there

flail_item_init:

  jsr entity_kill_if_already_seen

  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #8
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_instances+entity_instance::position_y+1,x
  
  lda #FLAILITEM_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  rts

flail_item_sit_there:

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
  and #nomolos_attack_set_mask
  ora #nomolos_attack_state_flail
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

  jmp flailItemDie

notTouching:

  ldy #level_data_struct::nomolos_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::flail_0
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
