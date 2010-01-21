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

;entity module
.import initEntities, returnFromEntityUpdate, spawnEntity

;camera module
.import resetCamera, cameraToScreenCoords

;sprite module
.import clearSprites, updateAnimation, drawAnimation, drawAnimation16, drawMetaSprite

;sound module
.import initsound, lowc, loadSound, finishSound


.export ROMDefinitionTable0

;temporary
.export NomolosWalk0

.segment "ROM0"

music:
.incbin "music.bin"

;ROM definition table
ROMDefinitionTable0:
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
  .byte $01

palette:

;Image Palette
;Palette
  .byte $21,$28,$18,$08,$00,$19,$2a,$0b,$00,$0d,$07,$28,$00,$00,$00,$00

;Sprite Palette
;Palette
  .byte $21,$0d,$20,$27,$21,$04,$29,$0d,$21,$0d,$27,$10,$21,$21,$21,$21

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
  .byte $03,$00,$00,$00,$00,$00,$00,$03,$00,$00,$02,$00,$00,$09,$03,$00
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
  .byte $00,$6a,$00,$00,$08
  .byte $00,$6b,$00,$08,$00
  .byte $08,$77,$02,$00,$08
  .byte $08,$78,$02,$08,$00
  .byte $10,$83,$02,$00,$08
  .byte $10,$84,$02,$08,$00
SlumpedArmorOverlay0:
  .byte $02
  .byte $00,$69,$01,$00,$00
  .byte $08,$76,$01,$00,$00
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
  