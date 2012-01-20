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

.segment "CODE"

.proc ending_state_update

.ifdef MUSIC_ENABLE
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

  ;load blank start button mask (we do not want to escape from these)
  lda #0
  sta b7

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta update_ppu
  lda #>ppu_upload_dynamic_palette_ppu
  sta update_ppu+1

  lda #<nomolos_and_snow_reunited_slide
  sta w2
  lda #>nomolos_and_snow_reunited_slide
  sta w2+1
  jsr ppu_show_text_slide

  lda #<ending_slide1
  sta w2
  lda #>ending_slide1
  sta w2+1
  jsr ppu_show_slide

  lda #<portal_appears_above_scepter_slide
  sta w2
  lda #>portal_appears_above_scepter_slide
  sta w2+1
  jsr ppu_show_text_slide

  lda #<ending_slide2
  sta w2
  lda #>ending_slide2
  sta w2+1
  jsr ppu_show_slide

  lda #<leapt_through_ending_portal_slide
  sta w2
  lda #>leapt_through_ending_portal_slide
  sta w2+1
  jsr ppu_show_text_slide

  lda #<ending_slide3
  sta w2
  lda #>ending_slide3
  sta w2+1
  jsr ppu_show_slide

  lda #<arriving_at_other_side_slide
  sta w2
  lda #>arriving_at_other_side_slide
  sta w2+1
  jsr ppu_show_text_slide

  lda #<slide1
  sta w2
  lda #>slide1
  sta w2+1
  jsr ppu_show_slide

.ifdef MUSIC_ENABLE
  lda #<soler_presto
  sta sound_param_word_1
  lda #>soler_presto
  sta sound_param_word_1+1
  jsr song_initialize
.endif

: jmp :-

  rts
.endproc

.proc ending_state_update_ppu
  
  jsr sprite_update_all

  rts
.endproc
