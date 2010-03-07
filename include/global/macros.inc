.ifndef MACROS_INC
MACROS_INC = 1

.include "structs.inc"

.macro initNES

  sei
  cld
  ldx #$FF
  txs
  inx
  stx $2001

  waitVBlank
  waitVBlank

.endmacro

.macro clearRAM

  lda #$00
:
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne :-

.endmacro

.macro waitVBlank

:
  bit $2002
  bpl :-

.endmacro
  
;Switches state so the main loop and vblank indirectly jump to different places.
;Assumes availability of zp variables update and updatePPU.
.macro switchState updateAddr, updatePPUAddr
  lda #<(updateAddr)
  sta update
  lda #>(updateAddr)
  sta update+1
  lda #<(updatePPUAddr)
  sta update_ppu
  lda #>(updatePPUAddr)
  sta update_ppu+1
.endmacro

.macro resetAnim animAddr

  lda #$01
  sta animAddr
  lda #$ff
  sta animAddr+1

.endmacro

.endif
