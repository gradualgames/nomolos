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

  ;use whatever was last loaded as the palette for the palette
  ;fade routines (they use w0)
  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta update_ppu
  lda #>ppu_upload_dynamic_palette_ppu
  sta update_ppu+1

  lda #<ending_slide1
  sta w2
  lda #>ending_slide1
  sta w2+1
  jsr ppu_show_slide

  lda #<ending_slide2
  sta w2
  lda #>ending_slide2
  sta w2+1
  jsr ppu_show_slide

  lda #<ending_slide3
  sta w2
  lda #>ending_slide3
  sta w2+1
  jsr ppu_show_slide

  lda #<slide1
  sta w2
  lda #>slide1
  sta w2+1
  jsr ppu_show_slide

  rts
.endproc

.proc ending_state_update_ppu
  
  jsr sprite_update_all

  rts
.endproc
