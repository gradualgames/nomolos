.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixed_bank_data.inc"
.include "sprite.inc"
.include "zp.inc"
.include "ram.inc"
.include "ending_state.inc"
.include "statemanager.inc"
.include "soundengine.inc"
.include "controller.inc"
.include "nomolos_logic.inc"
.include "entities.inc"
.include "slides.inc"
.include "title_state.inc"

.segment "CODE"

.proc ending_state_update

.ifdef MUSIC_ENABLE
  lda #EXTRA_MUSIC_BANK
  sta music_bank
  sta mapper_bank_next
  jsr mapper_switch_bank

  lda #<mysterious_barricades
  sta sound_param_word_1
  lda #>mysterious_barricades
  sta sound_param_word_1+1
  jsr song_initialize
.endif

  ;use whatever was last loaded as the palette for the palette
  ;fade routines (they use w0)
  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  start_slide_sequence

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta update_ppu
  lda #>ppu_upload_dynamic_palette_ppu
  sta update_ppu+1

  show_text_slide nomolos_and_snow_reunited_slide
  show_graphics_slide ending_slide1
  show_text_slide portal_appears_above_scepter_slide
  show_graphics_slide ending_slide2
  show_text_slide leapt_through_ending_portal_slide
  show_graphics_slide ending_slide3

.ifdef MUSIC_ENABLE
  lda mapper_bank_current
  pha
  lda #EXTRA_MUSIC_BANK
  sta music_bank
  sta mapper_bank_next
  jsr mapper_switch_bank

  lda #<soler_presto
  sta sound_param_word_1
  lda #>soler_presto
  sta sound_param_word_1+1
  jsr song_initialize
  pla
  sta mapper_bank_next
  jsr mapper_switch_bank
.endif

  show_text_slide thanks_for_playing_slide
  show_text_slide by_gradual_games_slide
  show_text_slide derek_andrews_slide
  show_text_slide laurie_andrews_slide
  show_text_slide daniel_hwozdek_slide
  show_text_slide music_by_slide
  show_text_slide beta_testers_slide
  show_text_slide production_slide
  show_text_slide printed_materials_slide
  show_text_slide promotion_social_media_slide
  show_text_slide special_thanks_slide
  show_text_slide nesdev_slide
  show_text_slide nintendoage_slide

  lda difficulty
  cmp #UNFAIR_DIFFICULTY
  bne :+
  show_text_slide secret_message_slide
:

  jsr fade_out_palette

  lda #<slide1_ending
  sta w2
  lda #>slide1_ending
  sta w2+1

  jsr ppu_load_slide

  lda #<slide1
  sta w2
  lda #>slide1
  sta w2+1
  ldy #ppu_slide::palette_address
  lda (w2),y
  sta w0
  iny
  lda (w2),y
  sta w0+1

  jsr fade_in_palette

: jmp :-

  rts
.endproc

.proc ending_state_update_ppu
  
  jsr sprite_update_all

  rts
.endproc
