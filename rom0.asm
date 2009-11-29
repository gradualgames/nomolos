.include "constants.inc"
.include "macros.inc"
.include "structs.inc"

;zp variables
.importzp b0, b1, b2, w0, w1, w2, w3, w4, w5
.importzp nomolosScreenX, nomolosScreenY, nomolosState
.importzp nomolosHitboxXOffset, nomolosHitboxYOffset
.importzp soundAddr, soundOff
.importzp stateControl

;famitracker
.importzp ft_music_addr
.import ft_music_init
.import ft_music_play
.import ft_disable_channel

.import entityPool

;ROM1
.import ROMDefinitionTable1

;load level state labels
.import loadLevelUpdate, loadLevelUpdatePPU

;geotests module
.import rectInRect

;nomolosLogic module
.import initNomolos, hurtNomolos, nomolosDeadly, addNomolosHealth

;entity module
.import initEntities, returnFromEntityUpdate, spawnEntity

;camera module
.import resetCamera, cameraToScreenCoords

;sprite module
.import clearSprites, updateAnimation, drawAnimation, drawMetaSprite

;sound module
.import initsound, lowc, loadSound, finishSound


.export ROMDefinitionTable0

.segment "ROM0"

music:
.incbin "music.bin"

;ROM definition table
ROMDefinitionTable0:
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
  .byte $21,$28,$18,$08,$21,$19,$2a,$0b,$21,$0d,$07,$28,$21,$00,$00,$00

;Sprite Palette
;Palette
  .byte $21,$0d,$27,$10,$21,$27,$20,$0d,$21,$0d,$00,$04,$21,$04,$2a,$20

MetaTileTable:
MetaTile0:
  .byte $02,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $00,$00,$01,$01,$01,$02,$02,$00
MetaTile2:
  .byte $01,$00,$01,$03,$01,$02,$02,$00
MetaTile3:
  .byte $01,$00,$01,$01,$01,$02,$02,$00
MetaTile4:
  .byte $01,$00,$01,$01,$04,$02,$02,$00
MetaTile5:
  .byte $01,$00,$00,$03,$01,$02,$02,$00
MetaTile6:
  .byte $01,$00,$00,$01,$01,$02,$02,$00
MetaTile7:
  .byte $01,$00,$00,$01,$04,$02,$02,$00
MetaTile8:
  .byte $02,$00,$00,$00,$00,$00,$00,$01
MetaTile9:
  .byte $02,$00,$00,$00,$00,$00,$00,$03
MetaTile10:
  .byte $02,$00,$00,$05,$06,$07,$08,$04
MetaTile11:
  .byte $02,$00,$00,$09,$0a,$09,$0b,$04
MetaTile12:
  .byte $02,$00,$00,$00,$00,$00,$00,$04
MetaTile13:
  .byte $00,$01,$01,$01,$01,$02,$02,$00
MetaMetaTileTable:
MetaMetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile1:
  .byte $00,$00,$00,$00,$02,$00,$00,$00,$00,$02,$00,$00,$00,$00,$03,$00
MetaMetaTile2:
  .byte $00,$00,$00,$00,$03,$00,$00,$00,$00,$03,$00,$00,$00,$00,$03,$00
MetaMetaTile3:
  .byte $00,$00,$00,$08,$03,$00,$00,$00,$08,$03,$00,$00,$00,$00,$03,$00
MetaMetaTile4:
  .byte $00,$00,$00,$00,$04,$00,$00,$00,$00,$04,$00,$00,$00,$00,$03,$00
MetaMetaTile5:
  .byte $00,$02,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile6:
  .byte $00,$03,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile7:
  .byte $00,$04,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile8:
  .byte $00,$00,$00,$00,$00,$00,$08,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile9:
  .byte $00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile10:
  .byte $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile11:
  .byte $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile12:
  .byte $03,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile13:
  .byte $03,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile14:
  .byte $03,$00,$00,$00,$00,$00,$00,$03,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile15:
  .byte $03,$00,$00,$00,$00,$00,$00,$04,$00,$08,$03,$00,$00,$00,$03,$00
MetaMetaTile16:
  .byte $04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile17:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$03,$00
MetaMetaTile18:
  .byte $00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile19:
  .byte $00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile20:
  .byte $00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile21:
  .byte $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile22:
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,$03,$00
MetaMetaTile23:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile24:
  .byte $00,$00,$00,$00,$00,$00,$00,$08,$01,$00,$03,$00,$03,$00,$03,$00
MetaMetaTile25:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$03,$00,$03,$00,$03,$00
MetaMetaTile26:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$04,$00,$03,$00
MetaMetaTile27:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$03,$00
MetaMetaTile28:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$09,$03,$00
MetaMetaTile29:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$03,$00
MetaMetaTile30:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$03,$00
MetaMetaTile31:
  .byte $00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile32:
  .byte $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile33:
  .byte $00,$00,$00,$00,$00,$08,$01,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile34:
  .byte $00,$00,$00,$00,$01,$00,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile35:
  .byte $00,$00,$03,$03,$03,$03,$03,$03,$03,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile36:
  .byte $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$0d,$03,$00
MetaMetaTile37:
  .byte $00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$0d,$03,$00
MetaMetaTile38:
  .byte $00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile39:
  .byte $00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile40:
  .byte $00,$00,$00,$00,$00,$09,$04,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile41:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile42:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile43:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$03,$00
MetaMetaTile44:
  .byte $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile45:
  .byte $00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$08,$03,$00
MetaMetaTile46:
  .byte $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile47:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$03,$00
MetaMetaTile48:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$01,$01,$01,$01,$03,$00
MetaMetaTile49:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00
MetaMetaTile50:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$03,$00
MetaMetaTile51:
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0a,$0b,$03,$00
Level:
  .byte $00,$00,$00,$00,$00,$00,$00,$01,$02,$02,$03,$02,$04,$00,$00,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$00,$00,$12,$13
  .byte $14,$15,$00,$00,$16,$00,$00,$17,$18,$19,$1a,$00,$00,$1b,$1c,$1d,$1e,$00,$00,$00,$1f,$20,$21,$20,$1f,$00,$00,$00,$22,$00,$00,$23
  .byte $00,$00,$00,$00,$24,$25,$26,$27,$26,$28,$00,$00,$29,$2a,$2a,$2b,$2a,$2a,$11,$00,$2c,$26,$26,$2d,$26,$26,$2e,$00,$00,$2f,$2f,$2f
  .byte $30,$2f,$2f,$00,$00,$00,$31,$00,$00,$00,$00,$31,$00,$00,$00,$00,$00,$32,$00,$00,$00,$00,$00,$00,$33,$00,$00,$00,$00,$00,$00,$00
  
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
  beq skipJmpExitDie
  jmp exitDie
skipJmpExitDie:
  
  ;transfer entity rectangle to w2 = top left and w3 = bot right
  lda w0
  sta w2
  clc
  adc #$10
  sta w3
  lda w1
  sta w2+1
  clc
  adc #$10
  sta w3+1
  
  ;transfer Nomolos rectangle to w4 = top left and w5 = bot right
  lda nomolosScreenX
  sta w4
  clc
  adc #nomolosWidth
  sta w5
  lda nomolosScreenY
  sta w4+1
  clc
  adc #nomolosHeight
  sta w5+1
  
  jsr rectInRect
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
  
  lda #<ROMDefinitionTable1
  sta stateControl+playLevelStateControl::romDefinitionTable
  lda #>ROMDefinitionTable1
  sta stateControl+playLevelStateControl::romDefinitionTable+1
  lda #2
  sta stateControl+playLevelStateControl::bgChrBank
  lda #3
  sta stateControl+playLevelStateControl::sprChrBank
  lda #1
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
  