.ifndef MACROS_INC
MACROS_INC = 1

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

.endif
