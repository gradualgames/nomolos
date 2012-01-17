.include "title_state.inc"
.include "level_in_state.inc"
.include "load_level_state.inc"
.include "continue_end_state.inc"
.include "play_level_state.inc"
.include "statemanager.inc"
.include "zp.inc"
.include "fixed_bank_data.inc"
.include "ppu.inc"
.include "map.inc"
.include "ram.inc"
.include "sprite.inc"
.include "flags.inc"
.include "soundengine.inc"

.segment "CODE"

;this routine waits for the nmi counter to reach zero.
.proc wait_vblank_flag

: lda nmi_counter
  bne :-

  rts

.endproc

;this routine takes the value in the accumulator and
;looks up a state in the state table and then changes the current
;update and ppu routines to the values found there.
;inputs: x is assumed to contain index of state
.proc switch_state

  ;load address of update routine
  lda state_table,x
  sta update
  lda state_table+1,x
  sta update+1

  ;load address of ppu update routine
  lda state_table+2,x
  sta update_ppu
  lda state_table+3,x
  sta update_ppu+1

  rts
.endproc

;state table
state_table:
  .word title_state_update
  .word title_state_update_ppu
  .word level_in_state_update
  .word level_in_state_update_ppu
  .word load_level_state_update
  .word load_level_state_update_ppu
  .word play_level_state_update
  .word play_level_state_update_ppu
  .word continue_end_state_update
  .word continue_end_state_update_ppu

;expects w0 to point to palette to fade in to
.proc fade_in_palette

  ;save current nmi routine
  lda update_ppu
  pha
  lda update_ppu+1
  pha

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta update_ppu
  lda #>ppu_upload_dynamic_palette_ppu
  sta update_ppu+1

  lda #1
  sta palette_step

fading_loop:

  ;load up the dynamic palette with brightness in b3
  lda palette_step
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  ;wait for vblank
  ldx #FADING_SPEED
: jsr wait_vblank_flag

  inc nmi_counter

  dex
  bne :-

  inc palette_step
  lda palette_step
  cmp #5
  bmi fading_loop

  ;restore previous nmi routine
  pla
  sta update_ppu+1
  pla
  sta update_ppu

  rts
.endproc

;expects w0 to point to the palette to fade out from
.proc fade_out_palette

  ;save current nmi routine
  lda update_ppu
  pha
  lda update_ppu+1
  pha

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta update_ppu
  lda #>ppu_upload_dynamic_palette_ppu
  sta update_ppu+1

  lda #4
  sta palette_step

fading_loop:

  ;load up the dynamic palette with brightness in b3
  lda palette_step
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  ;wait for vblank
  ldx #FADING_SPEED
: jsr wait_vblank_flag

  inc nmi_counter
  dex
  bne :-

  dec palette_step
  bpl fading_loop

  ;restore previous nmi routine
  pla
  sta update_ppu+1
  pla
  sta update_ppu

  rts
.endproc

;nmi routine for uploading the dynamic palette
.proc ppu_upload_dynamic_palette_ppu
  pha
  tya
  pha
  txa
  pha

  .ifdef MUSIC_ENABLE
  jsr sound_upload
  .endif

  lda nmi_counter
  beq nmi_counter_zero

  jsr sprite_update_all

  ;save current palette address
  lda w0
  pha
  lda w0+1
  pha

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  jsr ppu_load_palette

  ;restore previous palette address
  pla
  sta w0+1
  pla
  sta w0

  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  ;restore 2006 and 2005 to what we had written them to previously
  upload_ppu_2006
  upload_ppu_2005
  
  dec nmi_counter
nmi_counter_zero:
  
  .ifdef MUSIC_ENABLE
  jsr sound_update
  .endif

  pla
  tax
  pla
  tay
  pla

  rts
.endproc

