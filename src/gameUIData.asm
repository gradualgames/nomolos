.include "spritesheet1.inc"
.include "constants.inc"
.include "level1.inc"
.include "level2.inc"
.include "title_patterns_imports.inc"
.include "font0_patterns_imports.inc"
.include "soundengine.inc"

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
  .word k13_square1
  .word k13_square2
  .word $0000
  .word $0000
  
k13_square1:
  .byte STL, _16TH
  .byte STV, 2
  .byte STP, 1
  .byte G4, D4
  .byte STL, _64TH, C4, B3, C4, B3
  .byte STL, _32ND, A3, G3, FS3, E3, D3, C3, B2, C3
  .byte STL, _8TH+_32ND, D3
  .byte STL, _32ND, G3, FS3, B3, A3, E4, D4, G4, FS4, C5, B4, A4, G4, FS4
  .byte STL, _16TH, G4, G3
  .byte STL, _32ND, FS3, B3, A3, E4, D4, G4, FS4, C5, B4, A4, G4, FS4
  .byte STL, _16TH, G4, D4
  .byte STL, _32ND, E4, E3, E3, E3, E3, E3, E3, G3
  .byte STL, _16TH, E3, E4
  .byte STL, _64TH, FS4, E4, FS4, E4
  .byte STL, _32ND, D4, C4, D4, D3, D3, D3, D3, D3, D3, FS3
  .byte STL, _16TH, D3, D4
  .byte STL, _64TH, E4, D4, E4, D4
  .byte STL, _32ND, C4, B3, C4, D3, D3, D3, D3, D3, D3, FS3
  .byte STL, _16TH, D3, C4
  .byte STL, _64TH, D4, C4, D4, C4
  .byte STL, _32ND, B3, A3, B3, G2, G2, G2, G2, G2, G2, B2
  .byte STL, _16TH, G2, B3
  .byte STL, _64TH, C4, B3, C4, B3
  .byte STL, _32ND, A3, G3, D4, A3, FS3, D3, B3, D3, B2, G2, D4, A3, FS3, D3, B3, D3, B2, G2
  .byte GOT
  .word k13_square1

k13_square2:
  .byte STL, _16TH*6
  .byte STV, 0
  .byte STP, 1
  .byte A1
  .byte STV, 2
  .byte STL, _16TH, G2, D2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, D2, D1
  .byte STL, _16TH, G1, G2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, D2, D1
  .byte STL, _16TH, G1, G2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, C2
  .byte STL, _32ND, C4, C4, C4, E4
  .byte STL, _16TH, C4, C4
  .byte STL, _64TH, D4, C4, D4, C4
  .byte STL, _32ND, B3, A3
  .byte STL, _8TH, B3
  .byte STL, _32ND, B3, B3, B3, D4
  .byte STL, _16TH, B3, B2
  .byte STL, _64TH, C3, B2, C3, B2
  .byte STL, _32ND, A2, G2
  .byte STL, _8TH, D2
  .byte STL, _32ND, A3, A3, A3, C4
  .byte STL, _16TH, A3, D2
  .byte STL, _64TH, B2, A2, B2, A2
  .byte STL, _32ND, G2, FS2
  .byte STL, _8TH, G1
  .byte STL, _32ND, B3, B3, B3, D4
  .byte STL, _16TH, B3, G2
  .byte STL, _64TH, A2, G2, A2, G2
  .byte STL, _32ND, FS2, E2
  .byte STL, _16TH, D1, D2, D1, D2, D1, D2, D1, D2
  .byte GOT
  .word k13_square2

; .incbin "data/title_music.bin"

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
