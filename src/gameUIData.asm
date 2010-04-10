.include "spritesheet1.inc"
.include "constants.inc"
.include "level1.inc"
.include "level2.inc"
.include "title_patterns_imports.inc"
.include "font0_patterns_imports.inc"

.segment "CODE"
  
;miscellaneous data
.export banktable
banktable:
  .byte $00, $01, $02, $03, $04, $05, $06, $07

.export haltmusic
haltmusic:
.incbin "data/haltmusic.bin"

.export title_music
title_music:
.incbin "data/title_music.bin"

.export font1
font1:
  .word font0_patterns
  .byte $04
  .byte $35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e
.include "font0_palette_source.inc"

;table of decimal powers for creating decimal strings from 8 bit numbers
.export powerTable
powerTable:
  .byte 100, 10, 1
  
.export levelString
levelString:
  .byte $06,$26,$04,$15,$04,$0b,$1a

.export livesString
livesString:
  .byte $06,$26,$08,$15,$04,$12,$1a
  
.export gameOverString
gameOverString:
  .byte $09,$21,$1b,$27,$1f,$1a,$29,$30,$1f,$2c
  
.export titleDef
titleDef:
  .word title_palette
  .word title_nametable
  .word title_patterns
  .byte $04
  
.include "title_palette_source.inc"
.include "title_nametable_source.inc"
.include "title_attributetable_source.inc"
