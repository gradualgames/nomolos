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
.macro loadLevel romDefinitionTableAddr


  lda #<romDefinitionTableAddr
  sta romDefinitionTableBaseAddress
  lda #>romDefinitionTableAddr
  sta romDefinitionTableBaseAddress+1

;  lda #<levelAddr
;  sta levelBaseAddress
;  lda #>levelAddr
;  sta levelBaseAddress+1
  ldy #24
  lda (romDefinitionTableBaseAddress),y
  sta levelBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta levelBaseAddress+1

;  lda #<metaMetaTileTableAddr
;  sta metametaTileTableBaseAddress
;  lda #>metaMetaTileTableAddr
;  sta metametaTileTableBaseAddress+1
  ldy #22
  lda (romDefinitionTableBaseAddress),y
  sta metametaTileTableBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta metametaTileTableBaseAddress+1

;  lda #<metaTileTableAddr
;  sta metaTileTableBaseAddress
;  lda #>metaTileTableAddr
;  sta metaTileTableBaseAddress+1
  ldy #20
  lda (romDefinitionTableBaseAddress),y
  sta metaTileTableBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta metaTileTableBaseAddress+1

;  lda #<entityDefinitionTableAddr
;  sta entityDefinitionTableBaseAddress
;  lda #>entityDefinitionTableAddr
;  sta entityDefinitionTableBaseAddress+1
  ldy #26
  lda (romDefinitionTableBaseAddress),y
  sta entityDefinitionTableBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta entityDefinitionTableBaseAddress+1


  ldy #26
  lda (romDefinitionTableBaseAddress),y
  sta entityDefinitionTableBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta entityDefinitionTableBaseAddress+1

.endmacro

.macro resetAnim animAddr

  lda #$01
  sta animAddr
  lda #$ff
  sta animAddr+1

.endmacro

