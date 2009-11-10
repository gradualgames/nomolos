.include "constants.inc"
.include "macros.inc"
.include "structs.inc"

;zp variables
.importzp b0, b1, b2, w0, w1, w2, w3
.importzp nomolosScreenX, nomolosScreenY, nomolosState
.importzp nomolosHitboxXOffset, nomolosHitboxYOffset
.importzp soundAddr, soundOff

.import entityPool

;geotests module
.import rectInRect

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
.incbin "music.bin"

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
  .byte $03,$00,$7b,$7c,$82,$83,$00,$00
MetaTile1:
  .byte $02,$00,$00,$04,$02,$0a,$00,$00
MetaTile2:
  .byte $00,$00,$05,$06,$0b,$0c,$00,$00
MetaTile3:
  .byte $00,$00,$07,$08,$0d,$0e,$00,$00
MetaTile4:
  .byte $02,$00,$09,$01,$0f,$03,$00,$00
MetaTile5:
  .byte $00,$00,$10,$11,$1a,$1b,$00,$00
MetaTile6:
  .byte $00,$00,$12,$13,$1c,$1d,$00,$00
MetaTile7:
  .byte $02,$00,$14,$01,$02,$03,$00,$00
MetaTile8:
  .byte $02,$00,$15,$16,$1e,$1f,$00,$00
MetaTile9:
  .byte $01,$00,$17,$18,$20,$21,$00,$00
MetaTile10:
  .byte $02,$00,$19,$01,$22,$23,$00,$00
MetaTile11:
  .byte $00,$00,$24,$25,$2f,$30,$00,$00
MetaTile12:
  .byte $00,$00,$26,$27,$31,$32,$00,$00
MetaTile13:
  .byte $01,$00,$28,$29,$33,$34,$00,$00
MetaTile14:
  .byte $01,$00,$2a,$2b,$35,$36,$00,$00
MetaTile15:
  .byte $01,$00,$2c,$2d,$37,$38,$00,$00
MetaTile16:
  .byte $02,$00,$2e,$01,$39,$03,$00,$00
MetaTile17:
  .byte $00,$00,$3a,$3b,$47,$48,$00,$00
MetaTile18:
  .byte $00,$00,$3c,$3d,$49,$4a,$00,$00
MetaTile19:
  .byte $02,$00,$3e,$3f,$4b,$4c,$00,$00
MetaTile20:
  .byte $01,$00,$40,$41,$4d,$41,$00,$00
MetaTile21:
  .byte $01,$00,$42,$43,$4e,$4f,$00,$00
MetaTile22:
  .byte $01,$00,$44,$45,$44,$50,$00,$00
MetaTile23:
  .byte $02,$00,$46,$01,$51,$03,$00,$00
MetaTile24:
  .byte $02,$00,$00,$52,$02,$03,$00,$00
MetaTile25:
  .byte $00,$00,$53,$54,$5c,$5d,$00,$00
MetaTile26:
  .byte $02,$00,$00,$55,$02,$5e,$00,$00
MetaTile27:
  .byte $01,$00,$56,$57,$5f,$60,$00,$00
MetaTile28:
  .byte $01,$00,$58,$59,$61,$62,$00,$00
MetaTile29:
  .byte $01,$00,$44,$5a,$63,$64,$00,$00
MetaTile30:
  .byte $02,$00,$5b,$01,$39,$03,$00,$00
MetaTile31:
  .byte $00,$00,$65,$66,$47,$6f,$00,$00
MetaTile32:
  .byte $02,$00,$00,$67,$02,$70,$00,$00
MetaTile33:
  .byte $02,$01,$68,$69,$02,$71,$00,$00
MetaTile34:
  .byte $02,$01,$6a,$6b,$72,$70,$00,$00
MetaTile35:
  .byte $02,$01,$6c,$6d,$73,$74,$00,$00
MetaTile36:
  .byte $02,$00,$6e,$01,$75,$03,$00,$00
MetaTile37:
  .byte $02,$00,$76,$77,$7d,$7e,$00,$00
MetaTile38:
  .byte $03,$00,$78,$78,$7f,$7f,$00,$00
MetaTile39:
  .byte $02,$00,$79,$7a,$80,$81,$00,$00
MetaTile40:
  .byte $02,$00,$00,$01,$02,$03,$00,$00
MetaTile41:
  .byte $02,$00,$84,$85,$8c,$8d,$00,$00
MetaTile42:
  .byte $02,$00,$86,$87,$8e,$8f,$00,$00
MetaTile43:
  .byte $02,$00,$88,$89,$90,$91,$00,$00
MetaTile44:
  .byte $03,$00,$7b,$8a,$82,$92,$00,$00
MetaTile45:
  .byte $03,$00,$8b,$7c,$93,$94,$00,$00
MetaTile46:
  .byte $03,$01,$95,$96,$98,$99,$00,$00
MetaTile47:
  .byte $03,$01,$96,$96,$9a,$99,$00,$00
MetaTile48:
  .byte $03,$01,$96,$97,$9a,$9b,$00,$00
MetaTile49:
  .byte $02,$01,$9c,$9d,$9f,$a0,$00,$00
MetaTile50:
  .byte $02,$00,$9c,$9e,$9f,$a1,$00,$00
MetaTile51:
  .byte $03,$00,$7b,$7c,$82,$83,$01,$00
MetaTile52:
  .byte $01,$00,$58,$59,$61,$62,$01,$00
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
  .byte $00,$00,$00,$00,$00,$09,$0e,$15,$15,$1c,$22,$00,$00,$00,$31,$00
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
Level:
  .byte $00,$01,$02,$03,$04,$05,$06,$07,$03,$08,$09,$09,$0a,$09,$09,$0b,$03,$03,$03,$0c,$0d,$0e,$0f,$10,$03,$03,$03,$03,$11,$12,$12,$13
  .byte $12,$12,$14,$03,$03,$03,$03,$15,$16,$17,$18,$19,$03,$15,$16,$17,$18,$19,$03,$15,$16,$17,$18,$19,$03,$1a,$1b,$1c,$1d,$03,$03,$03
  .byte $11,$12,$12,$13,$12,$12,$14,$03,$03,$03,$03,$08,$09,$09,$0a,$09,$09,$09,$0b,$03,$03,$03,$00,$01,$01,$01,$02,$03,$03,$03,$03,$03
  .byte $03,$1e,$1f,$20,$21,$22,$03,$03,$03,$23,$24,$25,$26,$27,$03,$28,$03,$00,$01,$02,$03,$03,$03,$00,$01,$02,$03,$03,$03,$03,$03,$03
  
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
  .byte $00

NomolosJump:
  .byte $0a
  .word NomolosJump0
  .byte $00

NomolosFight:
  .byte $06
  .word NomolosFight0
  .word NomolosFight1
  .byte $00

NomolosWalkOverlay:
  .byte $0a
  .word NomolosWalkOverlay0
  .word NomolosWalkOverlay1
  .word NomolosWalkOverlay0
  .word NomolosWalkOverlay2
  .byte $00

NomolosJumpOverlay:
  .byte $0a
  .word NomolosJumpOverlay0
  .byte $00

NomolosFightOverlay:
  .byte $0a
  .word NomolosFightOverlay0
  .word NomolosFightOverlay1
  .byte $00

Heart:
  .byte $0a
  .word Heart0
  .byte $00

DeentleWalk:
  .byte $0a
  .word Deentle0
  .word Deentle1
  .byte $00

Explosion:
  .byte $02
  .word Explosion0
  .word Explosion1
  .word Explosion2
  .byte $00

Mouse:
  .byte $0a
  .word Mouse0
  .byte $00

 
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

  lda #0
  sta entityPool+entityRAM::alive,x
  jmp returnFromEntityUpdate
 
;all entity routines expect that entityPool,x points to
;the RAM entry for this particular update call.
;entity schema:
;0  .dsb alive = 1
;1  .dsb index = definition index (this is a parameter)
;2  .dsw spawnPositionX = initialXOffset + x
;4  .dsb spawnPositionY = initialYOffset + y
;5  .dsb positionXFine  = unknown, this is expected to be used (or not used) by the entity
;6  .dsw positionX      = x (this is a parameter)
;8  .dsb positionYFine  = unknown, this is expected to be used (or not used) by the entity
;9  .dsb positionY      = y (this is a parameter)
;10 .dsb state          = initialState
;11 .dsw animationObject  = unknown, this expected to be set by the entity
;13 .dsb 3 ;padding to 16 bytes

MOUSE_INITSTATE = 0
MOUSE_SITTHERESTATE = 1

mouseUpdate:

  lda entityPool+entityRAM::state,x
  cmp #MOUSE_INITSTATE
  beq mouseInit
  cmp #MOUSE_SITTHERESTATE
  beq mouseSitThere

mouseInit:

  ;reset the explosion animation object
  lda #$01
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  lda #MOUSE_SITTHERESTATE
  sta entityPool+entityRAM::state,x

  jmp returnFromEntityUpdate
  
mouseSitThere:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  jsr cameraToScreenCoords
  bne mouseDie
  
  ;transfer Mouse rectangle to w0 = top left and w1 = bot right
  lda b0
  sta w0
  clc
  adc #$10
  sta w1
  lda b1
  sta w0+1
  clc
  adc #$10
  sta w1+1
  
  ;transfer Nomolos rectangle to w2 = top left and w3 = bot right
  lda nomolosScreenX
  sta w2
  clc
  adc #nomolosWidth
  sta w3
  lda nomolosScreenY
  sta w2+1
  clc
  adc #nomolosHeight
  sta w3+1
  
  jsr rectInRect
  
  bne @notTouching
  
  lda #1
  jsr addNomolosHealth
  
  ;playSound getHealthSound
  lda #<getHealthSound
  sta w0
  lda #>getHealthSound
  sta w0+1
  jsr loadSound
  
  jmp mouseDie
  
@notTouching:
  
  ;load address of animation object into w1
  lda #<(entityPool+entityRAM::animationObject)
  sta w1
  lda #>(entityPool+entityRAM::animationObject)
  sta w1+1
  
  ;get the index into a
  txa
  clc
  ;do a 16 bit add onto the address with this index
  adc w1
  sta w1
  lda w1+1
  adc #0
  sta w1+1 
  
  lda #<Mouse
  sta w2
  lda #>Mouse
  sta w2+1
  jsr updateAnimation  
  
  jsr drawAnimation
  
  jmp returnFromEntityUpdate
  
mouseDie:

  lda #0
  sta entityPool+entityRAM::alive,x

  jmp returnFromEntityUpdate

EXPLOSION_INITSTATE = 0
EXPLOSION_EXPLODESTATE = 1

explosionUpdate:

  lda entityPool+entityRAM::state,x
  cmp #EXPLOSION_INITSTATE
  beq explosionInit
  cmp #EXPLOSION_EXPLODESTATE
  beq explosionExplode
  
explosionInit:

  ;reset the explosion animation object
  lda #$01
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  ;set state to explode
  lda #EXPLOSION_EXPLODESTATE
  sta entityPool+entityRAM::state,x
  
  jmp returnFromEntityUpdate
  
explosionExplode:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  jsr cameraToScreenCoords
  bne explosionDie
  
  ;load address of animation object into w1
  lda #<(entityPool+entityRAM::animationObject)
  sta w1
  lda #>(entityPool+entityRAM::animationObject)
  sta w1+1
  
  ;get the index into a
  txa
  clc
  ;do a 16 bit add onto the address with this index
  adc w1
  sta w1
  lda w1+1
  adc #0
  sta w1+1 
  
  lda #<Explosion
  sta w2
  lda #>Explosion
  sta w2+1
  jsr updateAnimation  
  
  jsr drawAnimation
  
  lda entityPool+entityRAM::animationObject+1,x
  cmp #2
  bne @skipFrameCounterTest
  lda entityPool+entityRAM::animationObject,x
  cmp #1
  beq explosionDie
@skipFrameCounterTest:

  jmp returnFromEntityUpdate
  
explosionDie:

  lda #0
  sta entityPool+entityRAM::alive,x

  jmp returnFromEntityUpdate

DEENTLE_INITSTATE = 0
DEENTLE_MOVERIGHTSTATE = 1
DEENTLE_MOVELEFTSTATE = 2

deentleUpdate:

  ;load current state
  lda entityPool+entityRAM::state,x
  ;figure out what state to jump to
  cmp #DEENTLE_INITSTATE
  beq deentle_initState
  cmp #DEENTLE_MOVERIGHTSTATE
  beq deentle_moveRightState
  cmp #DEENTLE_MOVELEFTSTATE
  beq deentle_moveLeftState

deentle_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entityPool+entityRAM::animationObject,x
  lda #0
  sta entityPool+entityRAM::animationObject+1,x
  
  ;switch state to "run"
  lda #DEENTLE_MOVELEFTSTATE
  sta entityPool+entityRAM::state,x
  jmp returnFromEntityUpdate

deentle_moveRightState:

  ;add 1 to PositionX
  clc
  lda entityPool+entityRAM::positionX,x
  adc #1
  sta entityPool+entityRAM::positionX,x
  lda entityPool+entityRAM::positionX+1,x
  adc #0
  sta entityPool+entityRAM::positionX+1,x
  
  ;do PositionX - spawnPositionX
  sec
  lda entityPool+entityRAM::positionX,x
  sbc entityPool+entityRAM::spawnPositionX,x
  sta w0
  lda entityPool+entityRAM::positionX+1,x
  sbc entityPool+entityRAM::spawnPositionX+1,x
  sta w0+1
  
  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1
  bne dontSwitchToLeftState
  
  lda #DEENTLE_MOVELEFTSTATE
  sta entityPool+entityRAM::state,x
  
dontSwitchToLeftState:

  jsr deentle_draw

  jmp returnFromEntityUpdate

deentle_moveLeftState:

  ;sub 1 from PositionX
  sec
  lda entityPool+entityRAM::positionX,x
  sbc #1
  sta entityPool+entityRAM::positionX,x
  lda entityPool+entityRAM::positionX+1,x
  sbc #0
  sta entityPool+entityRAM::positionX+1,x
  
  ;do spawnPositionX - PositionX
  sec
  lda entityPool+entityRAM::spawnPositionX,x
  sbc entityPool+entityRAM::positionX,x 
  sta w0
  lda entityPool+entityRAM::spawnPositionX+1,x
  sbc entityPool+entityRAM::positionX+1,x 
  sta w0+1
  
  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1
  
  bne dontSwitchToRightState
  
  lda #DEENTLE_MOVERIGHTSTATE
  sta entityPool+entityRAM::state,x
  
dontSwitchToRightState:
  

  jsr deentle_draw

  jmp returnFromEntityUpdate
  
  rts
  
deentle_draw:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  ;add 16 to positionX to get the right side of the Deentle
  clc
  lda w0
  adc #$10
  sta w0
  lda w0+1
  adc #$00
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  jsr cameraToScreenCoords
  bpl dontKillDeentle 
  jmp killDeentle
dontKillDeentle:
  beq deentleNotOffscreen1
  jmp deentleOffscreen
deentleNotOffscreen1:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  ;get positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  jsr cameraToScreenCoords
  beq deentleNotOffscreen2
  jmp deentleOffscreen
deentleNotOffscreen2:
  
  ;transfer Deentle rectangle to w0 = top left and w1 = bot right
  lda b0
  sta w0
  clc
  adc #$10
  sta w1
  lda b1
  sta w0+1
  clc
  adc #$10
  sta w1+1
  
  ;transfer Nomolos rectangle to w2 = top left and w3 = bot right
  lda nomolosScreenX
  sta w2
  clc
  adc #nomolosWidth
  sta w3
  lda nomolosScreenY
  sta w2+1
  clc
  adc #nomolosHeight
  sta w3+1
  
  jsr rectInRect
  
  bne :+
  
  jsr hurtNomolos
  
:
  jsr nomolosDeadly
  beq nomolosNotAttacking
  
  ;transfer Deentle rectangle to w0 = top left and w1 = bot right
  lda b0
  sta w0
  clc
  adc #$10
  sta w1
  lda b1
  sta w0+1
  clc
  adc #$10
  sta w1+1
  
  ;transfer Nomolos rectangle to w2 = top left and w3 = bot right
  lda nomolosScreenX
  clc
  adc nomolosHitboxXOffset ;slide rectangle over for hit box
  sta w2
  ;clc
  adc #nomolosHitboxWidth
  sta w3
  lda nomolosScreenY
  sta w2+1
  clc
  adc #nomolosHitboxHeight
  sta w3+1
  
  jsr rectInRect
  
  bne nomolosNotAttacking
  
  ;play an explode sound
  lda #<hitSound
  sta w0
  lda #>hitSound
  sta w0+1
  jsr loadSound
  
  jmp killDeentle
  
nomolosNotAttacking:

  ;load address of animation object into w1
  lda #<(entityPool+entityRAM::animationObject)
  sta w1
  lda #>(entityPool+entityRAM::animationObject)
  sta w1+1
  
  ;get the index into a
  txa
  clc
  ;do a 16 bit add onto the address with this index
  adc w1
  sta w1
  lda w1+1
  adc #0
  sta w1+1 
  
  ;load address of deentle animation definition into w2
  lda #<DeentleWalk
  sta w2
  lda #>DeentleWalk
  sta w2+1
  lda #0
  sta b2
  jsr updateAnimation  
  jsr drawAnimation
deentleOffscreen:
  rts
  
killDeentle:

  ;make it dead
  lda #0
  sta entityPool+entityRAM::alive,x
  
  ;spawn an explosion entity
  lda #ExplosionIndex
  sta b0

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  
  jsr spawnEntity

  rts
  