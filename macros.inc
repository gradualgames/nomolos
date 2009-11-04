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
.macro loadLevel levelAddr, metaTileTableAddr, metaMetaTileTableAddr, entityDefinitionTableAddr, nomolosDefinitionTableAddr
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
  lda #<nomolosDefinitionTableAddr
  sta nomolosDefinitionTableBaseAddress
  lda #>nomolosDefinitionTableAddr
  sta nomolosDefinitionTableBaseAddress+1
.endmacro

.macro resetAnim animAddr

  lda #$01
  sta animAddr
  lda #$ff
  sta animAddr+1

.endmacro

