.include "constants.inc"
.include "macros.inc"
.include "structs.inc"
.include "flags.inc"

;zp variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5
.importzp nomolosScreenX, nomolosScreenY, nomolosState
.importzp nomolosHitboxX, nomolosHitboxY
.importzp soundAddr, soundOff
.importzp stateControl
.importzp romDefinitionTableBaseAddress
.importzp currentLevel

.import entityPool

;famitracker
.importzp ft_music_addr
.import ft_music_init
.import ft_music_play
.import ft_disable_channel

;main module
.import loadLevel
.import haltmusic

;ROM labels
.import ROMDefinitionTable0

;geotests module
.import rectInRect, rectInRect16

;nomolosLogic module
.import hurtNomolos, nomolosDeadly, addNomolosHealth

;entity module
.import returnFromEntityUpdate, spawnEntity

;camera module
.import cameraToScreenCoords

;sprite module
.import updateAnimation, drawAnimation, drawAnimation16, drawMetaSprite

;sound module
.import lowc, loadSound, finishSound

.export ROMDefinitionTable1

.segment "ROM1"

music:
.incbin "data/music1.bin"

;ROM definition table
ROMDefinitionTable1:
  .word NomolosWalk           
  .word NomolosWalkOverlay    
  .word NomolosJump           
  .word NomolosJumpOverlay    
  .word NomolosFight          
  .word NomolosFightOverlay   
  .word SlumpedArmor0         
  .word SlumpedArmorOverlay0
  .word ScardyCat0
  .word ScardyCatOverlay0
  .word Heart0                
  .word attackSound           
  .word hitSound              
  .word palette               
  .word MetaTileTable         
  .word MetaMetaTileTable     
  .word Level                 
  .word EntityDefinitionTable 
  .word music                 
  .byte $00
  
palette:

;Image Palette
;Palette
  .byte $0d,$10,$00,$05,$3f,$10,$00,$02,$3f,$10,$28,$08,$3f,$07,$05,$20

;Sprite Palette
;Palette
  .byte $0d,$0d,$20,$27,$21,$04,$29,$0d,$21,$0d,$27,$10,$21,$21,$21,$21

MetaTileTable:
MetaTile0:
  .byte $02,$00,$00,$00,$01,$0f,$10,$00
MetaTile1:
  .byte $00,$00,$00,$02,$03,$11,$12,$00
MetaTile2:
  .byte $00,$00,$00,$04,$05,$13,$14,$00
MetaTile3:
  .byte $02,$00,$00,$06,$07,$0f,$10,$00
MetaTile4:
  .byte $03,$00,$00,$08,$09,$15,$16,$00
MetaTile5:
  .byte $03,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile6:
  .byte $01,$00,$00,$0b,$0c,$17,$18,$00
MetaTile7:
  .byte $01,$00,$01,$0d,$0e,$19,$1a,$00
MetaTile8:
  .byte $02,$00,$00,$00,$07,$0f,$10,$00
MetaTile9:
  .byte $00,$00,$00,$1b,$1c,$25,$26,$00
MetaTile10:
  .byte $00,$00,$00,$1d,$1e,$27,$28,$00
MetaTile11:
  .byte $02,$00,$00,$00,$07,$0f,$29,$00
MetaTile12:
  .byte $01,$00,$00,$1f,$20,$2a,$2b,$00
MetaTile13:
  .byte $01,$00,$00,$21,$22,$2c,$2d,$00
MetaTile14:
  .byte $01,$00,$00,$23,$24,$2e,$2f,$00
MetaTile15:
  .byte $02,$00,$00,$00,$07,$30,$10,$00
MetaTile16:
  .byte $00,$00,$00,$31,$32,$3d,$3e,$00
MetaTile17:
  .byte $00,$00,$00,$33,$34,$3f,$40,$00
MetaTile18:
  .byte $02,$00,$00,$00,$35,$0f,$41,$00
MetaTile19:
  .byte $01,$00,$00,$36,$37,$42,$43,$00
MetaTile20:
  .byte $01,$00,$00,$38,$39,$44,$45,$00
MetaTile21:
  .byte $01,$00,$00,$3a,$3b,$46,$47,$00
MetaTile22:
  .byte $02,$00,$00,$3c,$07,$48,$10,$00
MetaTile23:
  .byte $00,$00,$00,$49,$4a,$0f,$55,$00
MetaTile24:
  .byte $00,$00,$00,$4b,$4c,$56,$57,$00
MetaTile25:
  .byte $02,$00,$00,$00,$4d,$0f,$58,$00
MetaTile26:
  .byte $01,$00,$00,$4e,$4f,$59,$4f,$00
MetaTile27:
  .byte $01,$00,$00,$50,$51,$5a,$5b,$00
MetaTile28:
  .byte $01,$00,$00,$52,$53,$52,$5c,$00
MetaTile29:
  .byte $02,$00,$00,$0a,$54,$5d,$5e,$00
MetaTile30:
  .byte $02,$00,$00,$00,$5f,$0f,$10,$00
MetaTile31:
  .byte $00,$00,$00,$60,$61,$6a,$6b,$00
MetaTile32:
  .byte $02,$00,$00,$00,$62,$0f,$6c,$00
MetaTile33:
  .byte $01,$00,$00,$63,$64,$6d,$6e,$00
MetaTile34:
  .byte $01,$00,$00,$65,$66,$6f,$70,$00
MetaTile35:
  .byte $01,$00,$00,$52,$67,$71,$72,$00
MetaTile36:
  .byte $02,$00,$00,$68,$69,$73,$74,$00
MetaTile37:
  .byte $00,$00,$00,$00,$75,$0f,$10,$00
MetaTile38:
  .byte $01,$00,$00,$76,$77,$80,$81,$00
MetaTile39:
  .byte $01,$00,$01,$78,$79,$82,$83,$00
MetaTile40:
  .byte $01,$00,$01,$7a,$7b,$84,$85,$00
MetaTile41:
  .byte $01,$00,$01,$7c,$7d,$86,$87,$00
MetaTile42:
  .byte $01,$00,$00,$7e,$7f,$88,$89,$00
MetaTile43:
  .byte $01,$00,$00,$8a,$8b,$93,$94,$00
MetaTile44:
  .byte $02,$00,$00,$8c,$8c,$8c,$8c,$00
MetaTile45:
  .byte $01,$00,$00,$8d,$8e,$95,$8e,$00
MetaTile46:
  .byte $02,$01,$00,$8f,$90,$96,$97,$00
MetaTile47:
  .byte $02,$01,$00,$91,$92,$98,$99,$00
MetaTile48:
  .byte $01,$00,$00,$9a,$9b,$9a,$a5,$00
MetaTile49:
  .byte $01,$00,$00,$9c,$9d,$a6,$a7,$00
MetaTile50:
  .byte $01,$00,$00,$9e,$9f,$a8,$a9,$00
MetaTile51:
  .byte $02,$00,$00,$00,$a0,$0f,$aa,$00
MetaTile52:
  .byte $02,$00,$00,$a1,$07,$ab,$ac,$00
MetaTile53:
  .byte $01,$00,$00,$a2,$a3,$ad,$ae,$00
MetaTile54:
  .byte $01,$00,$00,$a4,$07,$af,$b0,$00
MetaTile55:
  .byte $02,$00,$01,$b1,$b2,$b8,$b9,$00
MetaTile56:
  .byte $02,$00,$01,$b2,$b2,$ba,$b9,$00
MetaTile57:
  .byte $02,$00,$01,$b2,$b3,$ba,$bb,$00
MetaTile58:
  .byte $01,$00,$00,$b4,$b5,$0f,$bc,$00
MetaTile59:
  .byte $01,$00,$00,$b6,$b7,$bd,$10,$00
MetaTile60:
  .byte $01,$00,$00,$a2,$be,$0f,$c0,$00
MetaTile61:
  .byte $01,$00,$00,$bf,$07,$c1,$10,$00
MetaTile62:
  .byte $01,$00,$01,$0d,$0e,$19,$1a,$00
MetaTile63:
  .byte $02,$00,$00,$00,$07,$0f,$10,$04
MetaTile64:
  .byte $02,$00,$00,$00,$07,$0f,$10,$01
MetaTile65:
  .byte $03,$00,$00,$08,$09,$15,$16,$01
MetaTile66:
  .byte $01,$00,$00,$7a,$7b,$84,$85,$00
MetaTile67:
  .byte $01,$00,$00,$65,$66,$6f,$70,$03
MetaTile68:
  .byte $01,$00,$00,$52,$53,$52,$5c,$04
MetaMetaTileTable:
MetaMetaTile0:
  .byte $2b,$2b,$2b,$2b,$2b,$2b,$2b,$2b,$2b,$2b,$2b,$2b,$2b,$30,$07,$00
MetaMetaTile1:
  .byte $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$32,$07,$00
MetaMetaTile2:
  .byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$07,$00
MetaMetaTile3:
  .byte $06,$06,$06,$06,$06,$06,$08,$08,$08,$2f,$08,$08,$08,$08,$07,$00
MetaMetaTile4:
  .byte $06,$06,$06,$06,$06,$08,$08,$35,$3a,$3c,$08,$08,$08,$08,$07,$00
MetaMetaTile5:
  .byte $06,$06,$06,$06,$08,$08,$08,$36,$3b,$3d,$08,$08,$08,$08,$07,$00
MetaMetaTile6:
  .byte $06,$06,$06,$06,$08,$08,$08,$08,$08,$2f,$08,$08,$08,$40,$07,$00
MetaMetaTile7:
  .byte $06,$06,$06,$08,$0b,$12,$19,$19,$19,$20,$26,$08,$08,$08,$07,$00
MetaMetaTile8:
  .byte $06,$06,$06,$08,$0c,$13,$1a,$1a,$1a,$21,$27,$08,$08,$08,$07,$00
MetaMetaTile9:
  .byte $06,$06,$06,$08,$0d,$14,$1b,$1b,$1b,$43,$28,$08,$08,$08,$07,$00
MetaMetaTile10:
  .byte $06,$06,$06,$08,$0e,$15,$1c,$1c,$1c,$23,$29,$08,$08,$08,$07,$00
MetaMetaTile11:
  .byte $06,$06,$06,$08,$08,$16,$1d,$1d,$1d,$24,$2a,$08,$08,$40,$07,$00
MetaMetaTile12:
  .byte $06,$06,$06,$06,$08,$08,$08,$08,$08,$2f,$08,$08,$08,$08,$07,$00
MetaMetaTile13:
  .byte $06,$06,$06,$06,$08,$08,$08,$35,$3a,$3c,$08,$08,$08,$08,$07,$00
MetaMetaTile14:
  .byte $06,$06,$06,$06,$06,$08,$08,$36,$3b,$3d,$08,$08,$08,$08,$07,$00
MetaMetaTile15:
  .byte $2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$31,$07,$00
MetaMetaTile16:
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile17:
  .byte $33,$33,$33,$33,$37,$08,$08,$08,$08,$0b,$12,$19,$20,$26,$07,$00
MetaMetaTile18:
  .byte $08,$08,$08,$2e,$38,$37,$08,$08,$08,$0c,$13,$1a,$21,$27,$07,$00
MetaMetaTile19:
  .byte $08,$08,$08,$08,$38,$38,$08,$08,$08,$0d,$14,$1b,$43,$28,$07,$00
MetaMetaTile20:
  .byte $08,$08,$08,$2e,$38,$39,$08,$08,$08,$0e,$15,$1c,$23,$29,$07,$00
MetaMetaTile21:
  .byte $34,$34,$34,$34,$39,$08,$08,$08,$08,$08,$16,$1d,$24,$2a,$07,$00
MetaMetaTile22:
  .byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$41,$07,$00
MetaMetaTile23:
  .byte $08,$00,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile24:
  .byte $08,$01,$09,$10,$17,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile25:
  .byte $08,$02,$0a,$11,$18,$1f,$25,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile26:
  .byte $08,$03,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile27:
  .byte $08,$00,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$40,$07,$00
MetaMetaTile28:
  .byte $08,$01,$09,$10,$17,$1e,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile29:
  .byte $08,$02,$0a,$11,$18,$1f,$25,$08,$08,$08,$08,$08,$08,$08,$08,$00
MetaMetaTile30:
  .byte $08,$03,$08,$08,$08,$08,$08,$08,$08,$08,$40,$08,$08,$08,$08,$00
MetaMetaTile31:
  .byte $08,$00,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$00
MetaMetaTile32:
  .byte $08,$03,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$40,$07,$00
MetaMetaTile33:
  .byte $07,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$40,$07,$00
MetaMetaTile34:
  .byte $07,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile35:
  .byte $07,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$2e,$07,$00
MetaMetaTile36:
  .byte $07,$08,$08,$08,$08,$08,$08,$08,$08,$08,$35,$3a,$3c,$08,$07,$00
MetaMetaTile37:
  .byte $07,$08,$08,$08,$00,$08,$08,$08,$08,$08,$36,$3b,$3d,$08,$07,$00
MetaMetaTile38:
  .byte $07,$08,$08,$08,$01,$09,$10,$17,$1e,$08,$08,$08,$08,$2e,$07,$00
MetaMetaTile39:
  .byte $07,$08,$08,$08,$02,$0a,$11,$18,$1f,$25,$35,$3a,$3c,$08,$07,$00
MetaMetaTile40:
  .byte $07,$08,$08,$08,$03,$08,$08,$08,$08,$08,$36,$3b,$3d,$08,$07,$00
MetaMetaTile41:
  .byte $07,$08,$08,$08,$08,$08,$08,$08,$08,$08,$36,$3b,$3d,$08,$07,$00
MetaMetaTile42:
  .byte $07,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$07,$00
MetaMetaTile43:
  .byte $33,$33,$33,$33,$33,$33,$33,$33,$33,$33,$33,$37,$08,$08,$07,$00
MetaMetaTile44:
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$38,$08,$08,$07,$00
MetaMetaTile45:
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$2e,$38,$08,$08,$07,$00
MetaMetaTile46:
  .byte $33,$33,$33,$37,$08,$08,$08,$35,$3a,$3c,$08,$38,$08,$40,$07,$00
MetaMetaTile47:
  .byte $08,$08,$08,$38,$08,$08,$08,$36,$3b,$3d,$2e,$38,$08,$08,$07,$00
MetaMetaTile48:
  .byte $08,$08,$2e,$38,$08,$08,$08,$08,$08,$08,$08,$38,$08,$08,$07,$00
MetaMetaTile49:
  .byte $08,$08,$08,$38,$08,$08,$08,$08,$08,$08,$2e,$38,$08,$08,$07,$00
MetaMetaTile50:
  .byte $08,$08,$08,$38,$34,$34,$34,$34,$34,$34,$34,$39,$08,$08,$07,$00
MetaMetaTile51:
  .byte $08,$08,$2e,$38,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile52:
  .byte $08,$08,$08,$38,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile53:
  .byte $34,$34,$34,$39,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$07,$00
MetaMetaTile54:
  .byte $19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$07,$00
MetaMetaTile55:
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$07,$00
MetaMetaTile56:
  .byte $1b,$1b,$1b,$1b,$1b,$1b,$1b,$1b,$1b,$1b,$1b,$1b,$1b,$1b,$07,$00
MetaMetaTile57:
  .byte $1c,$44,$1c,$44,$1c,$44,$1c,$44,$1c,$44,$1c,$44,$1c,$44,$07,$00
MetaMetaTile58:
  .byte $1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$07,$00
Level:
  .byte $00,$01,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$00,$01,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$03,$00,$0f,$0f,$01,$10
  .byte $10,$11,$12,$13,$14,$15,$10,$10,$00,$01,$02,$02,$02,$16,$02,$02,$02,$02,$16,$02,$02,$02,$02,$00,$01,$17,$18,$19,$1a,$1b,$1c,$1d
  .byte $1e,$1f,$18,$19,$20,$17,$18,$19,$1a,$00,$01,$21,$22,$23,$24,$25,$26,$27,$28,$23,$24,$29,$23,$22,$22,$22,$22,$22,$2a,$2a,$2a,$00
  .byte $01,$10,$10,$10,$2b,$2c,$2d,$2e,$2f,$30,$31,$30,$32,$33,$34,$35,$10,$10,$10,$36,$37,$38,$39,$3a,$10,$10,$10,$10,$10,$10,$10,$10

;Meta Sprite Table
NomolosWalk0:
  .byte $08
  .byte $00,$00,$00,$00,$08
  .byte $00,$01,$00,$08,$00
  .byte $08,$18,$00,$00,$08
  .byte $08,$19,$00,$08,$00
  .byte $10,$2b,$02,$00,$08
  .byte $10,$2c,$02,$08,$00
  .byte $18,$3d,$02,$00,$08
  .byte $18,$3e,$02,$08,$00
NomolosWalk1:
  .byte $08
  .byte $00,$02,$00,$00,$08
  .byte $00,$03,$00,$08,$00
  .byte $08,$1a,$00,$00,$08
  .byte $08,$1b,$00,$08,$00
  .byte $10,$2d,$02,$00,$08
  .byte $10,$2e,$02,$08,$00
  .byte $18,$3f,$02,$00,$08
  .byte $18,$40,$02,$08,$00
NomolosWalk2:
  .byte $08
  .byte $00,$05,$00,$00,$08
  .byte $00,$06,$00,$08,$00
  .byte $08,$1c,$00,$00,$08
  .byte $08,$1d,$00,$08,$00
  .byte $10,$2f,$02,$00,$08
  .byte $10,$30,$02,$08,$00
  .byte $18,$41,$02,$00,$08
  .byte $18,$42,$02,$08,$00
NomolosJump0:
  .byte $08
  .byte $00,$07,$00,$00,$08
  .byte $00,$08,$00,$08,$00
  .byte $08,$1e,$02,$00,$08
  .byte $08,$1f,$02,$08,$00
  .byte $10,$31,$02,$00,$08
  .byte $10,$32,$02,$08,$00
  .byte $18,$43,$02,$00,$08
  .byte $18,$44,$02,$08,$00
NomolosWalkOverlay0:
  .byte $04
  .byte $01,$0d,$01,$00,$08
  .byte $01,$0e,$01,$08,$00
  .byte $09,$24,$01,$00,$08
  .byte $09,$25,$01,$08,$00
NomolosWalkOverlay1:
  .byte $04
  .byte $01,$0f,$01,$00,$08
  .byte $01,$10,$01,$08,$00
  .byte $09,$26,$01,$00,$08
  .byte $09,$27,$01,$08,$00
NomolosWalkOverlay2:
  .byte $04
  .byte $01,$0f,$01,$00,$08
  .byte $01,$11,$01,$08,$00
  .byte $09,$26,$01,$00,$08
  .byte $09,$27,$01,$08,$00
NomolosJumpOverlay0:
  .byte $04
  .byte $01,$0d,$01,$00,$08
  .byte $01,$12,$01,$08,$00
  .byte $09,$24,$01,$00,$08
  .byte $09,$25,$01,$08,$00
Heart0:
  .byte $01
  .byte $00,$39,$01,$00,$00
Deentle0:
  .byte $04
  .byte $00,$4c,$02,$00,$08
  .byte $00,$4d,$02,$08,$00
  .byte $08,$5f,$02,$00,$08
  .byte $08,$60,$02,$08,$00
Deentle1:
  .byte $04
  .byte $00,$4e,$02,$00,$08
  .byte $00,$4f,$02,$08,$00
  .byte $08,$61,$02,$00,$08
  .byte $08,$62,$02,$08,$00
Explosion0:
  .byte $04
  .byte $00,$50,$00,$00,$08
  .byte $00,$51,$00,$08,$00
  .byte $08,$63,$00,$00,$08
  .byte $08,$64,$00,$08,$00
Explosion1:
  .byte $04
  .byte $00,$52,$00,$00,$08
  .byte $00,$53,$00,$08,$00
  .byte $08,$65,$00,$00,$08
  .byte $08,$66,$00,$08,$00
Explosion2:
  .byte $04
  .byte $00,$54,$00,$00,$08
  .byte $00,$55,$00,$08,$00
  .byte $08,$67,$00,$00,$08
  .byte $08,$68,$00,$08,$00
Mouse0:
  .byte $02
  .byte $00,$56,$02,$00,$08
  .byte $00,$57,$02,$08,$00
SlumpedArmor0:
  .byte $06
  .byte $08,$6a,$00,$00,$08
  .byte $08,$6b,$00,$08,$00
  .byte $10,$77,$02,$00,$08
  .byte $10,$78,$02,$08,$00
  .byte $18,$83,$02,$00,$08
  .byte $18,$84,$02,$08,$00
SlumpedArmorOverlay0:
  .byte $02
  .byte $08,$69,$01,$00,$00
  .byte $10,$76,$01,$00,$00
ScardyCat0:
  .byte $08
  .byte $00,$58,$00,$00,$08
  .byte $00,$59,$00,$08,$00
  .byte $08,$6c,$00,$00,$08
  .byte $08,$6d,$00,$08,$00
  .byte $10,$79,$00,$00,$08
  .byte $10,$7a,$00,$08,$00
  .byte $18,$85,$00,$00,$08
  .byte $18,$86,$00,$08,$00
ScardyCatOverlay0:
  .byte $04
  .byte $00,$6e,$01,$00,$08
  .byte $00,$6f,$01,$08,$00
  .byte $08,$7b,$01,$00,$08
  .byte $08,$7c,$01,$08,$00
NomolosFight0:
  .byte $0a
  .byte $f8,$4b,$00,$00,$08
  .byte $f8,$17,$00,$08,$00
  .byte $00,$5a,$00,$00,$08
  .byte $00,$5b,$00,$08,$00
  .byte $08,$70,$02,$00,$08
  .byte $08,$71,$00,$08,$00
  .byte $10,$7d,$02,$00,$08
  .byte $10,$7e,$02,$08,$00
  .byte $18,$87,$02,$00,$08
  .byte $18,$88,$02,$08,$00
NomolosFight1:
  .byte $10
  .byte $00,$5c,$00,$00,$08
  .byte $00,$5d,$00,$08,$00
  .byte $00,$5e,$00,$10,$f8
  .byte $00,$17,$00,$18,$f0
  .byte $08,$72,$02,$00,$08
  .byte $08,$73,$02,$08,$00
  .byte $08,$74,$00,$10,$f8
  .byte $08,$75,$00,$18,$f0
  .byte $10,$7f,$02,$00,$08
  .byte $10,$80,$02,$08,$00
  .byte $10,$81,$00,$10,$f8
  .byte $10,$82,$00,$18,$f0
  .byte $18,$89,$02,$00,$08
  .byte $18,$8a,$02,$08,$00
  .byte $18,$8b,$02,$10,$f8
  .byte $18,$17,$00,$18,$f0
NomolosFightOverlay0:
  .byte $04
  .byte $01,$13,$01,$00,$08
  .byte $01,$14,$01,$08,$00
  .byte $09,$17,$00,$00,$08
  .byte $09,$28,$01,$08,$00
NomolosFightOverlay1:
  .byte $04
  .byte $01,$15,$01,$00,$08
  .byte $01,$16,$01,$08,$00
  .byte $09,$29,$01,$00,$08
  .byte $09,$2a,$01,$08,$00

;Animations
NomolosWalk:
  .byte $0a
  .word NomolosWalk0
  .word NomolosWalk1
  .word NomolosWalk0
  .word NomolosWalk2
  .word $0000

NomolosJump:
  .byte $0a
  .word NomolosJump0
  .word $0000

NomolosWalkOverlay:
  .byte $0a
  .word NomolosWalkOverlay0
  .word NomolosWalkOverlay1
  .word NomolosWalkOverlay0
  .word NomolosWalkOverlay2
  .word $0000

NomolosJumpOverlay:
  .byte $0a
  .word NomolosJumpOverlay0
  .word $0000

Heart:
  .byte $0a
  .word Heart0
  .word $0000

DeentleWalk:
  .byte $0a
  .word Deentle0
  .word Deentle1
  .word $0000

Explosion:
  .byte $02
  .word Explosion0
  .word Explosion1
  .word Explosion2
  .word $0000

Mouse:
  .byte $0a
  .word Mouse0
  .word $0000

NomolosFight:
  .byte $06
  .word NomolosFight0
  .word NomolosFight1
  .word $0000

NomolosFightOverlay:
  .byte $06
  .word NomolosFightOverlay0
  .word NomolosFightOverlay1
  .word $0000

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
 
;Entities
EntityDefinitionTable:
DeentleIndex = 0
DeentleEntity:
  .word deentleUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
ExplosionIndex = 1
ExplosionEntity:
  .word explosionUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
MouseIndex = 2
MouseEntity:
  .word mouseUpdate
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
ExitLevelEntityIndex = 3
ExitLevelEntity:
  .word exitLevelUpdate
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
 
.include "exitentity.inc"
.include "mouse.inc"
.include "explosion.inc"
.include "deentle.inc"