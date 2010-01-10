.ifndef MACROS_INC
MACROS_INC = 1

.include "structs.inc"

.macro waitVBlank

:
  bit $2002
  bpl :-

.endmacro
  
;Switches state so the main loop and vblank indirectly jump to different places.
;Assumes availability of zp variables update and updatePPU.
.macro switchState updateAddr, updatePPUAddr
  lda #<updateAddr
  sta update
  lda #>updateAddr
  sta update+1
  lda #<updatePPUAddr
  sta updatePPU
  lda #>updatePPUAddr
  sta updatePPU+1
.endmacro

.macro resetAnim animAddr

  lda #$01
  sta animAddr
  lda #$ff
  sta animAddr+1

.endmacro

.endif
