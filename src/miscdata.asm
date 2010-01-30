.include "spritesheet1.inc"
.include "constants.inc"
.include "level1.inc"
.include "level2.inc"
.include "titledata.inc"
.include "fontdata.inc"

;ROM definition table
ROMDefinitionTable0:
  .byte $02
  .byte $00
  .word NomolosWalk            
  .word NomolosWalkOverlay     
  .word NomolosJump            
  .word NomolosJumpOverlay     
  .word NomolosFight           
  .word NomolosFightOverlay    
  .word NomolosUseFlail
  .word NomolosFlailOverlay
  .word FlailBall
  .word SlumpedArmor0           
  .word SlumpedArmorOverlay0
  .word ScardyCat0
  .word ScardyCatOverlay0
  .word Heart0                 
  .word attackSound            
  .word hitSound               
  .word level1palette                
  .word level1MetaTileTable          
  .word level1MetaMetaTileTable      
  .word level1Level                  
  .word EntityDefinitionTable  
  .word level1music                  
  .byte $01

;ROM definition table
ROMDefinitionTable1:
  .byte $02
  .byte $01
  .word NomolosWalk           
  .word NomolosWalkOverlay    
  .word NomolosJump           
  .word NomolosJumpOverlay    
  .word NomolosFight          
  .word NomolosFightOverlay   
  .word NomolosUseFlail
  .word NomolosFlailOverlay
  .word FlailBall
  .word SlumpedArmor0         
  .word SlumpedArmorOverlay0
  .word ScardyCat0
  .word ScardyCatOverlay0
  .word Heart0                
  .word attackSound           
  .word hitSound              
  .word level2palette               
  .word level2MetaTileTable         
  .word level2MetaMetaTileTable     
  .word level2Level                 
  .word EntityDefinitionTable 
  .word level2music                 
  .byte $00
  
;Entities
EntityDefinitionTable:
DeentleEntity:
  .word deentleUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
ExplosionEntity:
  .word explosionUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
MouseEntity:
  .word mouseUpdate
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
ExitLevelEntity:
  .word exitLevelUpdate
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
OneUpEntity:
  .word oneUpUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
FlailItemEntity:
  .word flailItemUpdate
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
  
.export attackSound
attackSound:
  .byte $0E
  .byte $07
  .byte $0F
  .byte $f8
  .byte $0C
  .byte %00110000
  .byte $0C
  .byte %00110010
  .byte $0C
  .byte %00110100
  .byte $0C
  .byte %00110110
  .byte $0C
  .byte %00111000
  .byte $0C
  .byte %00111010
  .byte $0C
  .byte %00111100
  .byte $0C
  .byte %00111110
  .byte $0C
  .byte %00110000
  .byte $ff
 
.export hitSound
hitSound:
  .byte $0E
  .byte $0a
  .byte $0F
  .byte $f8  
  .byte $0C
  .byte %00111110
  .byte $0C
  .byte %00111100
  .byte $0C
  .byte %00111010
  .byte $0C
  .byte %00111000
  .byte $0C
  .byte %00110110
  .byte $0C
  .byte %00110100
  .byte $0C
  .byte %00110010
  .byte $0C
  .byte %00110000
  .byte $0C
  .byte %00110000
  .byte $ff

.export getHealthSound
getHealthSound:
  .byte DISABLE_FAMITRACKER_CHANNEL
  .byte $01 
  .byte $04
  .byte $84
  .byte $05
  .byte %00000000
  .byte $07
  .byte %00001000
  .byte $06
  .byte %11111111
  .byte $06
  .byte %10111111
  .byte $06
  .byte %01111111
  .byte $06
  .byte %00111111  
  .byte ENABLE_FAMITRACKER_CHANNEL
  .byte $01
  .byte $ff
  
.export getOneUpSound
getOneUpSound:
  .byte DISABLE_FAMITRACKER_CHANNEL
  .byte $01 
  .byte $04
  .byte $84
  .byte $05
  .byte %00000000
  .byte $07
  .byte %00001000
  .byte $06
  .byte %11111111
  .byte $06
  .byte %10111111
  .byte $06
  .byte %01111111
  .byte $06
  .byte %00111111  
  .byte $06
  .byte %11111111
  .byte $06
  .byte %10111111
  .byte $06
  .byte %01111111
  .byte $06
  .byte %00111111  
  .byte ENABLE_FAMITRACKER_CHANNEL
  .byte $01
  .byte $ff
  
.export getFlailItemSound
getFlailItemSound:
  .byte DISABLE_FAMITRACKER_CHANNEL
  .byte $01 
  .byte $04
  .byte $84
  .byte $05
  .byte %00000000
  .byte $07
  .byte %00001000
  .byte $06
  .byte %11111111
  .byte $06
  .byte %10111111
  .byte $06
  .byte %01111111
  .byte $06
  .byte %00111111  
  .byte $06
  .byte %11111111
  .byte $06
  .byte %10111111
  .byte $06
  .byte %01111111
  .byte $06
  .byte %00111111  
  .byte ENABLE_FAMITRACKER_CHANNEL
  .byte $01
  .byte $ff
  
;level definitions
.export LevelDefinitionTable
LevelDefinitionTable:
Level1:
  .word Level1Chr  ;location of chr data
  .byte $03        ;prg bank where data resides
  .byte $00        ;prg bank where code/additional data resides
  .word ROMDefinitionTable0
  .byte $00, $00  ;pad to 8 bytes. this may be used eventually anyway (music track for example)
Level2:
  .word Level2Chr
  .byte $03       
  .byte $01
  .word ROMDefinitionTable1
  .byte $00, $00
  
;miscellaneous data
.export banktable
banktable:
  .byte $00, $01, $02, $03, $04, $05, $06, $07

.export haltmusic
haltmusic:
.incbin "data/haltmusic.bin"

.export font1
font1:
  .word Font0Chr
  .byte $04
  .byte $35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e
  .byte $0d,$20,$0d,$0d,$0d,$00,$00,$00,$0d,$00,$00,$00,$0d,$00,$00,$00
  .byte $0d,$20,$0d,$0d,$0d,$00,$00,$00,$0d,$00,$00,$00,$0d,$00,$00,$00

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
  .word titlePalette
  .word titleNametable
  .word TitleChr
  .byte $04
  
.export titlePalette
titlePalette:
;Palette
  .byte $01,$0d,$27,$2a,$01,$27,$0d,$04,$01,$0d,$04,$10,$01,$0d,$10,$27
  .byte $01,$0d,$27,$2a,$01,$27,$0d,$04,$01,$0d,$04,$10,$01,$0d,$10,$27
  
.export titleNametable
titleNametable:
;Name Table
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$01,$02,$03,$04,$00,$00,$00,$00,$00,$05,$06,$07,$08,$09,$0a,$07,$0b,$0c,$0d,$0e,$0f,$10,$0d,$00,$11,$12,$13,$14,$15,$16
  .byte $00,$00,$17,$18,$19,$1a,$1b,$1b,$1b,$1c,$00,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$00,$2b,$2c,$2d,$2e,$2f,$30
  .byte $00,$31,$32,$33,$34,$35,$36,$36,$36,$37,$38,$1d,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c
  .byte $4d,$4e,$4f,$50,$36,$36,$36,$36,$36,$36,$36,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5e,$5f,$60,$61,$62,$5e,$63
  .byte $64,$65,$66,$36,$36,$67,$68,$69,$6a,$6b,$6c,$6d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $6e,$6f,$36,$36,$36,$70,$6f,$71,$72,$73,$74,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $6e,$6f,$36,$36,$36,$75,$6f,$6f,$6f,$6f,$75,$76,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $77,$78,$36,$36,$36,$75,$75,$75,$79,$7a,$75,$75,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $7b,$7c,$36,$36,$36,$7d,$7d,$7e,$7f,$80,$81,$82,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $83,$84,$85,$86,$36,$36,$36,$36,$87,$87,$87,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $88,$89,$8a,$7b,$36,$36,$36,$36,$8b,$8c,$8d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $8e,$8e,$8f,$90,$91,$92,$93,$91,$94,$95,$96,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$7c,$6f,$33,$7c,$75,$98,$99,$00,$00,$00,$00,$00,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$7c,$6f,$33,$7c,$6f,$6f,$a5,$00,$00,$00,$00,$00,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$7c,$6f,$33,$7c,$6f,$6f,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$b1,$b2,$50,$7c,$6f,$6f,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$b3,$6c,$b4,$7c,$6f,$6f,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$b5,$94,$b6,$19,$b7,$b8,$b9,$ba,$bb,$bc,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $4d,$bd,$75,$be,$bf,$c0,$36,$36,$36,$c1,$c2,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $7b,$19,$79,$c3,$c4,$68,$68,$68,$c5,$c6,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $c7,$c8,$c9,$ca,$cb,$6f,$6f,$6f,$cc,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $cd,$75,$cc,$00,$cb,$6f,$6f,$6f,$ce,$cf,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $d0,$d1,$8a,$00,$cb,$6f,$6f,$6f,$d2,$d3,$d4,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $d5,$8e,$00,$00,$cb,$d6,$d6,$d6,$d6,$d7,$d8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$d9,$8e,$8e,$8e,$8e,$8e,$da,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;Attribute Table
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ab,$3f,$cf,$ff,$ff,$ff,$ff,$ff
  .byte $ee,$f3,$fc,$ff,$ff,$ff,$ff,$ff
  .byte $fe,$ff,$a5,$ff,$0f,$0f,$0f,$ff
  .byte $ff,$ff,$ff,$ff,$f0,$f0,$f0,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
