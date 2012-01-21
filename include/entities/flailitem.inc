.ifndef FLAILITEM_WIDTH
FLAILITEM_WIDTH = $10
.endif

.ifndef FLAILITEM_HEIGHT
FLAILITEM_HEIGHT = $08
.endif

.ifndef FLAILITEM_INITSTATE
FLAILITEM_INITSTATE = $00
.endif

.ifndef FLAILITEM_SITTHERESTATE
FLAILITEM_SITTHERESTATE = $01
.endif

.ifndef flail_item_update
flail_item_update:
.endif
.scope

  lda entity_instances+entity_instance::state,x
  cmp #FLAILITEM_INITSTATE
  beq flail_item_init
  cmp #FLAILITEM_SITTHERESTATE
  beq flail_item_sit_there

flail_item_init:

  lda entity_instances+entity_instance::index,x
  sta b0
  lda entity_instances+entity_instance::spawn_position_x,x
  sta w0
  lda entity_instances+entity_instance::spawn_position_x+1,x
  sta w0+1
  lda entity_instances+entity_instance::spawn_position_y,x
  sta b1
  jsr entity_kill_if_redundant_entity

  jsr entity_test_picked_up_state

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

  ;if Nomolos' state is dying, exit
  lda nomolos_state_primary
  and #nomolos_dying_test
  bne notTouching

  jsr entity_item_test_death_zone
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

  ;Nomolos must not be attacking anymore when this is picked up
  lda nomolos_state_primary
  and #nomolos_attack_off_clear
  sta nomolos_state_primary
  lda #0
  sta nomolos_counter_attack_rect

  ;Nomolos has the flail
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

  jsr entity_set_picked_up

  jmp flailItemDie

notTouching:

  lda entity_chr_offsets+(entity_index_nomolos-1)
  sta sprite_group_offset

  lda #0
  sta b2

  lda #<spritesheet_common_FlailItem0
  sta w0
  lda #>spritesheet_common_FlailItem0
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

.endscope
