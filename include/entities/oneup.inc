.ifndef ONEUP_WIDTH
ONEUP_WIDTH = $10
.endif
.ifndef ONEUP_HEIGHT
ONEUP_HEIGHT = $08
.endif

.ifndef ONEUP_INITSTATE
ONEUP_INITSTATE = $00
.endif

.ifndef ONEUP_SITTHERESTATE
ONEUP_SITTHERESTATE = $01
.endif

.ifndef oneup_update
oneup_update:
.endif

.scope

  lda entity_instances+entity_instance::state,x
  cmp #ONEUP_INITSTATE
  beq oneup_init
  cmp #ONEUP_SITTHERESTATE
  beq oneup_sit_there

oneup_init:

  jsr entity_kill_if_redundant_entity

  jsr entity_test_picked_up_state

  lda #ONEUP_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  rts

oneUpDie:

  jsr entity_kill
  rts

oneup_sit_there:

  jsr entity_compute_screen_coordinates

  ;if Nomolos' state is dying, exit
  lda nomolos_state_primary
  and #nomolos_dying_test
  bne notTouching

  jsr entity_item_test_death_zone
  beq oneUpDie

  ;load entity width and height
  lda #ONEUP_WIDTH
  sta b2
  lda #ONEUP_HEIGHT
  sta b3

  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_screen_x
  sta w2
  lda entity_screen_x+1
  sta w2+1
  clc
  lda entity_screen_y
  adc #$08
  sta w3
  lda entity_screen_y+1
  adc #$00
  sta w3+1

  ;transfer Nomolos rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolos_screen_x
  sta w4
  lda nomolos_screen_x+1
  sta w4+1
  lda nomolos_screen_y
  sta w5
  lda nomolos_screen_y+1
  sta w5+1
  lda #nomolos_width
  sta b4
  lda #nomolos_height
  sta b5

  jsr geotests_rect_in_rect_16bit

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

  jsr entity_set_picked_up

  jmp oneUpDie

notTouching:

  lda entity_chr_offsets+(entity_index_nomolos-1)
  sta sprite_group_offset

  lda #0
  sta b2

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

.endscope
