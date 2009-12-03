.include "constants.inc"
.include "macros.inc"
.include "structs.inc"

;zp variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5
.importzp nomolosScreenX, nomolosScreenY, nomolosState
.importzp nomolosHitboxX, nomolosHitboxY
.importzp soundAddr, soundOff
.importzp stateControl

.import entityPool

;main module
.import loadLevel

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
.import updateAnimation, drawAnimation, drawMetaSprite

;sound module
.import lowc, loadSound, finishSound

.export ROMDefinitionTable1

.segment "ROM1"

music:
.incbin "music1.bin"

;ROM definition table
ROMDefinitionTable1:
  .word NomolosWalk            ;0
  .word NomolosWalkOverlay     ;2 
  .word NomolosJump            ;4
  .word NomolosJumpOverlay     ;6
  .word NomolosFight           ;8
  .word NomolosFightOverlay    ;10
  .word Heart0                 ;12
  .word attackSound            ;14
  .word hitSound               ;16
  .word palette                ;18
  .word MetaTileTable          ;20
  .word MetaMetaTileTable      ;22
  .word Level                  ;24
  .word EntityDefinitionTable  ;26
  .word music                  ;28
  
palette:

;Image Palette
;Palette
  .byte $0d,$10,$00,$06,$0d,$10,$00,$02,$0d,$10,$00,$00,$0d,$10,$28,$08

;Sprite Palette
;Palette
  .byte $0d,$0d,$27,$10,$21,$27,$20,$0d,$21,$0d,$00,$04,$21,$04,$2a,$20

MetaTileTable:
MetaTile0:
  .byte $03,$00,$00,$7b,$7c,$82,$83,$00
MetaTile1:
  .byte $02,$00,$00,$00,$04,$02,$0a,$00
MetaTile2:
  .byte $00,$00,$00,$05,$06,$0b,$0c,$00
MetaTile3:
  .byte $00,$00,$00,$07,$08,$0d,$0e,$00
MetaTile4:
  .byte $02,$00,$00,$09,$01,$0f,$03,$00
MetaTile5:
  .byte $00,$00,$00,$10,$11,$1a,$1b,$00
MetaTile6:
  .byte $00,$00,$00,$12,$13,$1c,$1d,$00
MetaTile7:
  .byte $02,$00,$00,$14,$01,$02,$03,$00
MetaTile8:
  .byte $02,$00,$00,$15,$16,$1e,$1f,$00
MetaTile9:
  .byte $01,$00,$00,$17,$18,$20,$21,$00
MetaTile10:
  .byte $02,$00,$00,$19,$01,$22,$23,$00
MetaTile11:
  .byte $00,$00,$00,$24,$25,$2f,$30,$00
MetaTile12:
  .byte $00,$00,$00,$26,$27,$31,$32,$00
MetaTile13:
  .byte $01,$00,$00,$28,$29,$33,$34,$00
MetaTile14:
  .byte $01,$00,$00,$2a,$2b,$35,$36,$00
MetaTile15:
  .byte $01,$00,$00,$2c,$2d,$37,$38,$00
MetaTile16:
  .byte $02,$00,$00,$2e,$01,$39,$03,$00
MetaTile17:
  .byte $00,$00,$00,$3a,$3b,$47,$48,$00
MetaTile18:
  .byte $00,$00,$00,$3c,$3d,$49,$4a,$00
MetaTile19:
  .byte $02,$00,$00,$3e,$3f,$4b,$4c,$00
MetaTile20:
  .byte $01,$00,$00,$40,$41,$4d,$41,$00
MetaTile21:
  .byte $01,$00,$00,$42,$43,$4e,$4f,$00
MetaTile22:
  .byte $01,$00,$00,$44,$45,$44,$50,$00
MetaTile23:
  .byte $02,$00,$00,$46,$01,$51,$03,$00
MetaTile24:
  .byte $02,$00,$00,$00,$52,$02,$03,$00
MetaTile25:
  .byte $00,$00,$00,$53,$54,$5c,$5d,$00
MetaTile26:
  .byte $02,$00,$00,$00,$55,$02,$5e,$00
MetaTile27:
  .byte $01,$00,$00,$56,$57,$5f,$60,$00
MetaTile28:
  .byte $01,$00,$00,$58,$59,$61,$62,$00
MetaTile29:
  .byte $01,$00,$00,$44,$5a,$63,$64,$00
MetaTile30:
  .byte $02,$00,$00,$5b,$01,$39,$03,$00
MetaTile31:
  .byte $00,$00,$00,$65,$66,$47,$6f,$00
MetaTile32:
  .byte $02,$00,$00,$00,$67,$02,$70,$00
MetaTile33:
  .byte $02,$00,$01,$68,$69,$02,$71,$00
MetaTile34:
  .byte $02,$00,$01,$6a,$6b,$72,$70,$00
MetaTile35:
  .byte $02,$00,$01,$6c,$6d,$73,$74,$00
MetaTile36:
  .byte $02,$00,$00,$6e,$01,$75,$03,$00
MetaTile37:
  .byte $02,$00,$00,$76,$77,$7d,$7e,$00
MetaTile38:
  .byte $03,$00,$00,$78,$78,$7f,$7f,$00
MetaTile39:
  .byte $02,$00,$00,$79,$7a,$80,$81,$00
MetaTile40:
  .byte $02,$00,$00,$00,$01,$02,$03,$00
MetaTile41:
  .byte $02,$00,$00,$84,$85,$8c,$8d,$00
MetaTile42:
  .byte $02,$00,$00,$86,$87,$8e,$8f,$00
MetaTile43:
  .byte $02,$00,$00,$88,$89,$90,$91,$00
MetaTile44:
  .byte $03,$00,$00,$7b,$8a,$82,$92,$00
MetaTile45:
  .byte $03,$00,$00,$8b,$7c,$93,$94,$00
MetaTile46:
  .byte $03,$00,$01,$95,$96,$98,$99,$00
MetaTile47:
  .byte $03,$00,$01,$96,$96,$9a,$99,$00
MetaTile48:
  .byte $03,$00,$01,$96,$97,$9a,$9b,$00
MetaTile49:
  .byte $02,$00,$01,$9c,$9d,$9f,$a0,$00
MetaTile50:
  .byte $02,$00,$00,$9c,$9e,$9f,$a1,$00
MetaTile51:
  .byte $03,$00,$00,$7b,$7c,$82,$83,$01
MetaTile52:
  .byte $01,$00,$00,$58,$59,$61,$62,$01
MetaTile53:
  .byte $01,$00,$00,$44,$45,$44,$50,$04
MetaTile54:
  .byte $01,$00,$00,$58,$59,$61,$62,$03
MetaMetaTileTable:
MetaMetaTile0:
  .byte $25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$29,$31,$00
MetaMetaTile1:
  .byte $26,$26,$26,$26,$26,$26,$26,$26,$26,$26,$26,$26,$26,$2a,$31,$00
MetaMetaTile2:
  .byte $27,$27,$27,$27,$27,$27,$27,$27,$27,$27,$27,$27,$27,$2b,$31,$00
MetaMetaTile3:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$31,$00
MetaMetaTile4:
  .byte $00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$31,$00
MetaMetaTile5:
  .byte $00,$00,$00,$02,$05,$05,$0b,$11,$18,$00,$00,$00,$00,$00,$31,$00
MetaMetaTile6:
  .byte $00,$00,$00,$03,$06,$06,$0c,$12,$19,$1f,$00,$00,$00,$00,$31,$00
MetaMetaTile7:
  .byte $00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$31,$00
MetaMetaTile8:
  .byte $2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2e,$00,$00,$00,$31,$00
MetaMetaTile9:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2f,$00,$00,$00,$31,$00
MetaMetaTile10:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$2f,$00,$00,$00,$31,$00
MetaMetaTile11:
  .byte $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$30,$00,$00,$00,$31,$00
MetaMetaTile12:
  .byte $00,$00,$00,$00,$28,$13,$13,$13,$1a,$20,$00,$00,$00,$00,$31,$00
MetaMetaTile13:
  .byte $00,$00,$00,$00,$08,$0d,$14,$14,$1b,$21,$00,$00,$00,$00,$31,$00
MetaMetaTile14:
  .byte $00,$00,$00,$00,$09,$0e,$15,$15,$1c,$22,$00,$00,$00,$00,$31,$00
MetaMetaTile15:
  .byte $00,$00,$00,$00,$0a,$0f,$16,$16,$1d,$23,$00,$00,$00,$00,$31,$00
MetaMetaTile16:
  .byte $00,$00,$00,$00,$28,$28,$17,$1e,$1e,$24,$00,$00,$00,$00,$31,$00
MetaMetaTile17:
  .byte $2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2c,$2e,$00,$00,$31,$00
MetaMetaTile18:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2f,$00,$00,$31,$00
MetaMetaTile19:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$2f,$00,$00,$31,$00
MetaMetaTile20:
  .byte $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$30,$00,$00,$31,$00
MetaMetaTile21:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$31,$00
MetaMetaTile22:
  .byte $00,$00,$00,$00,$00,$08,$0d,$14,$14,$1b,$21,$00,$00,$00,$31,$00
MetaMetaTile23:
  .byte $00,$00,$00,$00,$00,$09,$0e,$15,$15,$36,$22,$00,$00,$00,$31,$00
MetaMetaTile24:
  .byte $00,$00,$00,$00,$00,$0a,$0f,$16,$16,$1d,$23,$00,$00,$00,$31,$00
MetaMetaTile25:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$24,$00,$00,$00,$31,$00
MetaMetaTile26:
  .byte $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$31,$00
MetaMetaTile27:
  .byte $00,$00,$00,$00,$02,$05,$05,$05,$0b,$11,$18,$00,$00,$00,$31,$00
MetaMetaTile28:
  .byte $00,$00,$00,$00,$03,$06,$06,$06,$0c,$12,$19,$1f,$00,$00,$31,$00
MetaMetaTile29:
  .byte $00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$31,$00
MetaMetaTile30:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$31,$00
MetaMetaTile31:
  .byte $00,$00,$00,$00,$00,$00,$08,$0d,$14,$14,$1b,$21,$00,$00,$31,$00
MetaMetaTile32:
  .byte $00,$00,$00,$00,$00,$00,$09,$0e,$15,$15,$34,$22,$00,$00,$31,$00
MetaMetaTile33:
  .byte $00,$00,$00,$00,$00,$00,$0a,$0f,$16,$16,$1d,$23,$00,$00,$31,$00
MetaMetaTile34:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$24,$00,$00,$31,$00
MetaMetaTile35:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$31,$00
MetaMetaTile36:
  .byte $00,$00,$00,$08,$0d,$14,$14,$14,$14,$14,$14,$14,$1b,$21,$31,$00
MetaMetaTile37:
  .byte $00,$00,$00,$09,$0e,$15,$15,$15,$15,$15,$15,$15,$34,$22,$31,$00
MetaMetaTile38:
  .byte $00,$00,$00,$0a,$0f,$16,$16,$16,$16,$16,$16,$16,$1d,$23,$31,$00
MetaMetaTile39:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$24,$31,$00
MetaMetaTile40:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$31,$00
MetaMetaTile41:
  .byte $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$31,$00
MetaMetaTile42:
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$31,$00
MetaMetaTile43:
  .byte $35,$35,$35,$35,$35,$35,$35,$35,$35,$35,$35,$35,$35,$35,$31,$00
Level:
  .byte $00,$01,$02,$03,$04,$05,$06,$07,$03,$08,$09,$09,$0a,$09,$09,$0b,$03,$03,$03,$0c,$0d,$0e,$0f,$10,$03,$03,$03,$03,$11,$12,$12,$13
  .byte $12,$12,$14,$03,$03,$03,$03,$15,$16,$17,$18,$19,$03,$15,$16,$17,$18,$19,$03,$15,$16,$17,$18,$19,$03,$1a,$1b,$1c,$1d,$03,$03,$03
  .byte $11,$12,$12,$13,$12,$12,$14,$03,$03,$03,$03,$08,$09,$09,$0a,$09,$09,$09,$0b,$03,$03,$03,$00,$01,$01,$01,$02,$03,$03,$03,$03,$03
  .byte $03,$1e,$1f,$20,$21,$22,$03,$03,$03,$23,$24,$25,$26,$27,$03,$28,$03,$00,$01,$02,$29,$2a,$2b,$00,$01,$02,$03,$03,$03,$03,$03,$03
  
;Meta Sprite Table
NomolosWalk0:
  .byte $08
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$19,$01,$00,$08
  .byte $08,$1a,$01,$08,$00
  .byte $10,$2e,$00,$00,$08
  .byte $10,$2f,$00,$08,$00
  .byte $18,$3c,$00,$00,$08
  .byte $18,$3d,$00,$08,$00
NomolosWalk1:
  .byte $08
  .byte $00,$02,$01,$00,$08
  .byte $00,$03,$01,$08,$00
  .byte $08,$1b,$02,$00,$08
  .byte $08,$1c,$01,$08,$00
  .byte $10,$30,$00,$00,$08
  .byte $10,$31,$00,$08,$00
  .byte $18,$3e,$00,$00,$08
  .byte $18,$3f,$00,$08,$00
NomolosWalk2:
  .byte $08
  .byte $00,$05,$01,$00,$08
  .byte $00,$06,$01,$08,$00
  .byte $08,$1d,$01,$00,$08
  .byte $08,$1e,$01,$08,$00
  .byte $10,$32,$00,$00,$08
  .byte $10,$33,$00,$08,$00
  .byte $18,$40,$00,$00,$08
  .byte $18,$41,$00,$08,$00
NomolosJump0:
  .byte $08
  .byte $00,$07,$01,$00,$08
  .byte $00,$08,$01,$08,$00
  .byte $08,$1f,$00,$00,$08
  .byte $08,$20,$00,$08,$00
  .byte $10,$34,$00,$00,$08
  .byte $10,$35,$00,$08,$00
  .byte $18,$42,$00,$00,$08
  .byte $18,$43,$00,$08,$00
NomolosFight0:
  .byte $08
  .byte $00,$09,$01,$00,$08
  .byte $00,$0a,$01,$08,$00
  .byte $08,$21,$00,$00,$08
  .byte $08,$22,$01,$08,$00
  .byte $10,$36,$00,$00,$08
  .byte $10,$37,$00,$08,$00
  .byte $18,$44,$00,$00,$08
  .byte $18,$45,$00,$08,$00
NomolosFight1:
  .byte $0c
  .byte $00,$0b,$01,$00,$08
  .byte $00,$0c,$01,$08,$00
  .byte $00,$0d,$01,$10,$f8
  .byte $08,$23,$00,$00,$08
  .byte $08,$24,$00,$08,$00
  .byte $08,$25,$01,$10,$f8
  .byte $10,$38,$00,$00,$08
  .byte $10,$39,$00,$08,$00
  .byte $10,$3a,$01,$10,$f8
  .byte $18,$46,$00,$00,$08
  .byte $18,$47,$00,$08,$00
  .byte $18,$48,$00,$10,$f8
NomolosWalkOverlay0:
  .byte $04
  .byte $01,$0f,$03,$00,$08
  .byte $01,$10,$03,$08,$00
  .byte $09,$26,$03,$00,$08
  .byte $09,$27,$03,$08,$00
NomolosWalkOverlay1:
  .byte $04
  .byte $01,$11,$03,$00,$08
  .byte $01,$12,$03,$08,$00
  .byte $09,$28,$03,$00,$08
  .byte $09,$29,$03,$08,$00
NomolosWalkOverlay2:
  .byte $04
  .byte $01,$11,$03,$00,$08
  .byte $01,$13,$03,$08,$00
  .byte $09,$28,$03,$00,$08
  .byte $09,$29,$03,$08,$00
NomolosJumpOverlay0:
  .byte $04
  .byte $01,$0f,$03,$00,$08
  .byte $01,$14,$03,$08,$00
  .byte $09,$26,$03,$00,$08
  .byte $09,$27,$03,$08,$00
NomolosFightOverlay0:
  .byte $04
  .byte $01,$15,$03,$00,$08
  .byte $01,$16,$03,$08,$00
  .byte $09,$2a,$03,$00,$08
  .byte $09,$2b,$03,$08,$00
NomolosFightOverlay1:
  .byte $04
  .byte $01,$17,$03,$00,$08
  .byte $01,$18,$03,$08,$00
  .byte $09,$2c,$03,$00,$08
  .byte $09,$2d,$03,$08,$00
Heart0:
  .byte $01
  .byte $00,$3b,$02,$00,$00
Deentle0:
  .byte $04
  .byte $00,$49,$00,$00,$08
  .byte $00,$4a,$00,$08,$00
  .byte $08,$55,$00,$00,$08
  .byte $08,$56,$00,$08,$00
Deentle1:
  .byte $04
  .byte $00,$4b,$00,$00,$08
  .byte $00,$4c,$00,$08,$00
  .byte $08,$57,$00,$00,$08
  .byte $08,$58,$00,$08,$00
Explosion0:
  .byte $04
  .byte $00,$4d,$01,$00,$08
  .byte $00,$4e,$01,$08,$00
  .byte $08,$59,$01,$00,$08
  .byte $08,$5a,$01,$08,$00
Explosion1:
  .byte $04
  .byte $00,$4f,$01,$00,$08
  .byte $00,$50,$01,$08,$00
  .byte $08,$5b,$01,$00,$08
  .byte $08,$5c,$01,$08,$00
Explosion2:
  .byte $04
  .byte $00,$51,$01,$00,$08
  .byte $00,$52,$01,$08,$00
  .byte $08,$5d,$01,$00,$08
  .byte $08,$5e,$01,$08,$00
Mouse0:
  .byte $02
  .byte $00,$53,$02,$00,$08
  .byte $00,$54,$02,$08,$00

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

NomolosFight:
  .byte $06
  .word NomolosFight0
  .word NomolosFight1
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

NomolosFightOverlay:
  .byte $0a
  .word NomolosFightOverlay0
  .word NomolosFightOverlay1
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
  
exitLevelUpdate:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta w1
  lda entityPool+entityRAM::positionY+1,x
  sta w1+1
  jsr cameraToScreenCoords
  bpl skipJmpExitDie
  jmp exitDie
skipJmpExitDie:
  
  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda w0
  sta w2
  lda w0+1
  sta w2+1
  lda w1
  sta w3
  lda w1+1
  sta w3+1
  lda #$10
  sta b2
  lda #$10
  sta b3
  
  ;transfer Nomolos rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolosScreenX
  sta w4
  lda nomolosScreenX+1
  sta w4+1
  lda nomolosScreenY
  sta w5
  lda nomolosScreenY+1
  sta w5+1
  lda #nomolosWidth
  sta b4
  lda #nomolosHeight
  sta b5
  
  jsr rectInRect16
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
  
  lda #<ROMDefinitionTable0
  sta stateControl+playLevelStateControl::romDefinitionTable
  lda #>ROMDefinitionTable0
  sta stateControl+playLevelStateControl::romDefinitionTable+1
  lda #0
  sta stateControl+playLevelStateControl::bgChrBank
  lda #1
  sta stateControl+playLevelStateControl::sprChrBank
  lda #0
  sta stateControl+playLevelStateControl::prgBank
  lda #PLAYLEVELSTATE_SWITCHLEVEL
  sta stateControl+playLevelStateControl::state
  
  jmp exitDie
  
notTouching:

  jmp returnFromEntityUpdate

exitDie:
  lda #0
  sta entityPool+entityRAM::alive,x
  jmp returnFromEntityUpdate
 
.include "mouse.inc"
.include "explosion.inc"
.include "deentle.inc"