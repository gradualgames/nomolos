.include "constants.inc"
.include "macros.inc"
.include "structs.inc"
.include "flags.inc"

;zp variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5
.importzp nomolosScreenX, nomolosScreenY, nomolosState, nomolosSubState
.importzp nomolosHitboxX, nomolosHitboxY
.importzp nomolosLives
.importzp soundAddr, soundOff
.importzp stateControl
.importzp romDefinitionTableBaseAddress
.importzp currentLevel

;famitracker
.importzp ft_music_addr
.import ft_music_init
.import ft_music_play
.import ft_disable_channel

.import entityPool

;ROM1
.import ROMDefinitionTable1

;main module
.import haltmusic

;load level state labels
.import loadLevelUpdate, loadLevelUpdatePPU

;geotests module
.import rectInRect, rectInRect16

;nomolosLogic module
.import initNomolos, hurtNomolos, nomolosDeadly, addNomolosHealth
.import addNomolosLife

;entity module
.import initEntities, returnFromEntityUpdate, spawnEntity

;camera module
.import resetCamera, cameraToScreenCoords

;sprite module
.import clearSprites, updateAnimation, drawAnimation, drawAnimation16, drawMetaSprite
.import drawMetaSprite16

;sound module
.import initsound, lowc, loadSound, finishSound

.export level1palette, level1MetaTileTable, level1MetaMetaTileTable, level1Level, level1music

.segment "ROM0"

level1music:
.incbin "data/music.bin"

level1palette:

;Image Palette
;Palette
  .byte $21,$28,$18,$08,$00,$19,$2a,$0b,$00,$0d,$07,$28,$00,$00,$00,$00

;Sprite Palette
;Palette
  .byte $21,$0d,$20,$27,$21,$04,$2a,$0d,$21,$0d,$27,$10,$21,$21,$21,$21

level1MetaTileTable:
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
MetaTile14:
  .byte $02,$00,$00,$00,$00,$00,$00,$05
MetaTile15:
  .byte $02,$00,$00,$00,$00,$00,$00,$06
level1MetaMetaTileTable:
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
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0e,$03,$00
MetaMetaTile6:
  .byte $00,$02,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile7:
  .byte $00,$03,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile8:
  .byte $00,$04,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile9:
  .byte $00,$00,$00,$00,$00,$00,$08,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile10:
  .byte $00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile11:
  .byte $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile12:
  .byte $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile13:
  .byte $03,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile14:
  .byte $03,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile15:
  .byte $03,$00,$00,$00,$00,$00,$00,$03,$00,$00,$02,$00,$00,$09,$03,$00
MetaMetaTile16:
  .byte $03,$00,$00,$00,$00,$00,$00,$04,$00,$08,$03,$00,$00,$00,$03,$00
MetaMetaTile17:
  .byte $04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile18:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$03,$00
MetaMetaTile19:
  .byte $00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile20:
  .byte $00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile21:
  .byte $00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile22:
  .byte $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile23:
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,$03,$00
MetaMetaTile24:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0f,$03,$00
MetaMetaTile25:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile26:
  .byte $00,$00,$00,$00,$00,$00,$00,$08,$01,$00,$03,$00,$03,$00,$03,$00
MetaMetaTile27:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$03,$00,$03,$00,$03,$00
MetaMetaTile28:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$04,$00,$03,$00
MetaMetaTile29:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$03,$00
MetaMetaTile30:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$09,$03,$00
MetaMetaTile31:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$03,$00
MetaMetaTile32:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$03,$00
MetaMetaTile33:
  .byte $00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile34:
  .byte $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile35:
  .byte $00,$00,$00,$00,$00,$08,$01,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile36:
  .byte $00,$00,$00,$00,$01,$00,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile37:
  .byte $00,$00,$03,$03,$03,$03,$03,$03,$03,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile38:
  .byte $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$0d,$03,$00
MetaMetaTile39:
  .byte $00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$0d,$03,$00
MetaMetaTile40:
  .byte $00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile41:
  .byte $00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile42:
  .byte $00,$00,$00,$00,$00,$09,$04,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile43:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile44:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile45:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$03,$00
MetaMetaTile46:
  .byte $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile47:
  .byte $00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$08,$03,$00
MetaMetaTile48:
  .byte $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile49:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$03,$00
MetaMetaTile50:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$01,$01,$01,$01,$03,$00
MetaMetaTile51:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00
MetaMetaTile52:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$03,$00
MetaMetaTile53:
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0a,$0b,$03,$00
level1Level:
  .byte $00,$00,$00,$00,$00,$00,$00,$01,$02,$02,$03,$02,$04,$05,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$00,$00,$13,$14
  .byte $15,$16,$00,$00,$17,$00,$18,$19,$1a,$1b,$1c,$00,$00,$1d,$1e,$1f,$20,$00,$00,$00,$21,$22,$23,$22,$21,$00,$00,$00,$24,$00,$00,$25
  .byte $00,$00,$00,$00,$26,$27,$28,$29,$28,$2a,$00,$00,$2b,$2c,$2c,$2d,$2c,$2c,$12,$00,$2e,$28,$28,$2f,$28,$28,$30,$00,$00,$31,$31,$31
  .byte $32,$31,$31,$00,$00,$00,$33,$00,$00,$00,$00,$33,$00,$00,$00,$00,$00,$34,$00,$00,$00,$00,$00,$00,$35,$00,$00,$00,$00,$00,$00,$00
  
