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

;Loads the addresses of level data 
.macro loadLevel levelAddr, metaTileTableAddr, metaMetaTileTableAddr, entityDefinitionTableAddr
  lda #<levelAddr
  sta levelBaseAddress
  lda #>levelAddr
  sta levelBaseAddress+1
  lda #<metaMetaTileTableAddr
  sta metametaTileTableBaseAddress
  lda #>metaMetaTileTableAddr
  sta metametaTileTableBaseAddress+1
  lda #<metaTileTableAddr
  sta metaTileTableBaseAddress
  lda #>metaTileTableAddr
  sta metaTileTableBaseAddress+1
  lda #<entityDefinitionTableAddr
  sta entityDefinitionTableBaseAddress
  lda #>entityDefinitionTableAddr
  sta entityDefinitionTableBaseAddress+1
.endmacro