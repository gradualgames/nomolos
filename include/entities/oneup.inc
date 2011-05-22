.ifndef ONEUP_INC
ONEUP_INC = 1

ONEUP_WIDTH = $10
ONEUP_HEIGHT = $08

ONEUP_INITSTATE = $00
ONEUP_SITTHERESTATE = $01

.proc oneup_update

  lda entity_instances+entity_instance::state,x
  cmp #ONEUP_INITSTATE
  beq oneup_init
  cmp #ONEUP_SITTHERESTATE
  beq oneup_sit_there

oneup_init:

  jsr entity_kill_if_already_seen

  lda #ONEUP_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  rts

oneup_sit_there:

  jsr entity_compute_screen_coordinates

  jsr entity_item_test_death_zone
  beq oneUpDie

  ;load entity width and height
  lda #ONEUP_WIDTH
  sta b2
  lda #ONEUP_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:

  lda #1
  jsr nomolos_add_life

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

  jmp oneUpDie

notTouching:

  ldy #level_data_struct::nomolos_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda #<spritesheet_common_OneUp0
  sta w0
  lda #>spritesheet_common_OneUp0
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

oneUpDie:

  jsr entity_kill
  rts

.endproc

.endif
