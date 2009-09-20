;zp variables
.importzp b0, b1, w0, w1, w2

.import entityPool

;entity module
.import returnFromEntityUpdate

;camera module
.import cameraToScreenCoords

;sprite module
.import updateAnimation, drawAnimation, drawMetaSprite

.export palette, MetaTileTable, MetaMetaTileTable, NomolosWalkRight, NomolosWalkLeft
.export Level, EntityDefinitionTable

.segment "RODATA"
palette:

;Image Palette
  .byte $21,$15,$12,$03,$11,$19,$1a,$07,$00,$00,$00,$00,$00,$00,$00,$00

;Sprite Palette
;Palette
  .byte $21,$0d,$27,$14,$20,$0d,$27,$10,$00,$00,$00,$00,$00,$00,$00,$00

MetaTileTable:
MetaTile0:
  .byte $01,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $00,$01,$01,$01,$02,$02,$00,$00
MetaTile2:
  .byte $01,$01,$03,$01,$02,$02,$00,$00
MetaTile3:
  .byte $01,$01,$01,$01,$02,$02,$00,$00
MetaTile4:
  .byte $01,$01,$01,$04,$02,$02,$00,$00
MetaTile5:
  .byte $01,$00,$03,$01,$02,$02,$00,$00
MetaTile6:
  .byte $01,$00,$01,$01,$02,$02,$00,$00
MetaTile7:
  .byte $01,$00,$01,$04,$02,$02,$00,$00
MetaTile8:
  .byte $01,$00,$00,$00,$00,$00,$01,$00
MetaMetaTileTable:
MetaMetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile1:
  .byte $00,$00,$00,$00,$05,$00,$00,$00,$00,$02,$00,$00,$00,$00,$03,$00
MetaMetaTile2:
  .byte $00,$00,$00,$00,$06,$00,$00,$00,$00,$03,$00,$00,$00,$00,$03,$00
MetaMetaTile3:
  .byte $00,$00,$00,$08,$06,$00,$00,$00,$08,$03,$00,$00,$00,$00,$03,$00
MetaMetaTile4:
  .byte $00,$00,$00,$00,$07,$00,$00,$00,$00,$04,$00,$00,$00,$00,$03,$00
MetaMetaTile5:
  .byte $00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile6:
  .byte $00,$00,$00,$00,$00,$00,$08,$01,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile7:
  .byte $00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile8:
  .byte $00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile9:
  .byte $00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile10:
  .byte $00,$00,$00,$00,$00,$00,$00,$04,$00,$08,$03,$00,$00,$00,$03,$00
MetaMetaTile11:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile12:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$03,$00
MetaMetaTile13:
  .byte $00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile14:
  .byte $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile15:
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,$03,$00
MetaMetaTile16:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile17:
  .byte $00,$00,$00,$00,$00,$00,$00,$08,$01,$00,$03,$00,$03,$00,$03,$00
MetaMetaTile18:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$03,$00,$03,$00,$03,$00
MetaMetaTile19:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$04,$00,$03,$00
MetaMetaTile20:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$03,$00
MetaMetaTile21:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$03,$00
MetaMetaTile22:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$03,$00
MetaMetaTile23:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$03,$00
MetaMetaTile24:
  .byte $00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile25:
  .byte $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile26:
  .byte $00,$00,$00,$00,$00,$08,$01,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile27:
  .byte $00,$00,$00,$00,$01,$00,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile28:
  .byte $00,$00,$03,$03,$03,$03,$03,$03,$03,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile29:
  .byte $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile30:
  .byte $00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile31:
  .byte $00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile32:
  .byte $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile33:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile34:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$03,$00
MetaMetaTile35:
  .byte $00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$08,$03,$00
MetaMetaTile36:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$03,$00
MetaMetaTile37:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$01,$01,$01,$01,$03,$00
MetaMetaTile38:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00
MetaMetaTile39:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$08,$01,$00,$00,$00,$00,$03,$00
MetaMetaTile40:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$03,$00
MetaMetaTile41:
  .byte $00,$00,$00,$00,$00,$08,$01,$00,$00,$00,$00,$01,$00,$00,$03,$00
MetaMetaTile42:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$01,$00,$00,$03,$00
MetaMetaTile43:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$03,$00
Level:
  .byte $00,$00,$00,$00,$00,$00,$00,$01,$02,$02,$03,$02,$04,$00,$00,$05,$05,$05,$06,$05,$00,$00,$07,$08,$09,$0a,$0b,$0c,$00,$00,$07,$08
  .byte $0d,$0e,$00,$00,$0f,$00,$00,$10,$11,$12,$13,$00,$00,$14,$15,$16,$17,$00,$00,$00,$18,$19,$1a,$19,$18,$00,$00,$00,$1b,$00,$00,$1c
  .byte $00,$00,$00,$00,$1d,$1e,$1e,$1f,$1e,$20,$00,$00,$21,$0b,$0b,$22,$0b,$0b,$0c,$00,$1d,$1e,$1e,$23,$1e,$1e,$20,$00,$00,$24,$24,$24
  .byte $25,$24,$24,$00,$00,$00,$26,$00,$00,$00,$00,$26,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$27,$28,$29,$2a,$2b,$29,$28,$27,$00,$00
 
;Meta Sprite Table
NomolosWalkRight0:
  .byte $08
  .byte $00,$00,$00,$00
  .byte $00,$01,$01,$08
  .byte $08,$11,$00,$00
  .byte $08,$12,$01,$08
  .byte $10,$21,$01,$00
  .byte $10,$22,$01,$08
  .byte $18,$2d,$01,$00
  .byte $18,$2e,$01,$08
NomolosWalkRight1:
  .byte $08
  .byte $00,$02,$00,$00
  .byte $00,$03,$01,$08
  .byte $08,$13,$00,$00
  .byte $08,$14,$01,$08
  .byte $10,$23,$01,$00
  .byte $10,$24,$01,$08
  .byte $18,$2f,$01,$00
  .byte $18,$30,$01,$08
NomolosWalkRight2:
  .byte $08
  .byte $00,$04,$00,$00
  .byte $00,$05,$01,$08
  .byte $08,$15,$00,$00
  .byte $08,$16,$01,$08
  .byte $10,$25,$01,$00
  .byte $10,$26,$01,$08
  .byte $18,$31,$01,$00
  .byte $18,$32,$01,$08
NomolosWalkLeft0:
  .byte $08
  .byte $00,$06,$01,$00
  .byte $00,$07,$00,$08
  .byte $08,$17,$01,$00
  .byte $08,$18,$00,$08
  .byte $10,$27,$01,$00
  .byte $10,$28,$01,$08
  .byte $18,$33,$01,$00
  .byte $18,$34,$01,$08
NomolosWalkLeft1:
  .byte $08
  .byte $00,$08,$01,$00
  .byte $00,$09,$00,$08
  .byte $08,$19,$01,$00
  .byte $08,$1a,$00,$08
  .byte $10,$29,$01,$00
  .byte $10,$2a,$01,$08
  .byte $18,$35,$01,$00
  .byte $18,$36,$01,$08
NomolosWalkLeft2:
  .byte $08
  .byte $00,$0a,$01,$00
  .byte $00,$0b,$00,$08
  .byte $08,$1b,$01,$00
  .byte $08,$1c,$00,$08
  .byte $10,$2b,$01,$00
  .byte $10,$2c,$01,$08
  .byte $18,$37,$01,$00
  .byte $18,$38,$01,$08
Deentle0:
  .byte $04
  .byte $00,$0c,$01,$00
  .byte $00,$0d,$01,$08
  .byte $08,$1d,$01,$00
  .byte $08,$1e,$01,$08
Deentle1:
  .byte $04
  .byte $00,$0e,$01,$00
  .byte $00,$0f,$01,$08
  .byte $08,$1f,$01,$00
  .byte $08,$20,$01,$08

;Animations
NomolosWalkRight:
  .byte $0a
  .word NomolosWalkRight0
  .word NomolosWalkRight1
  .word NomolosWalkRight0
  .word NomolosWalkRight2
  .byte $00

NomolosWalkLeft:
  .byte $0a
  .word NomolosWalkLeft2
  .word NomolosWalkLeft1
  .word NomolosWalkLeft2
  .word NomolosWalkLeft0
  .byte $00

DeentleWalk:
  .byte $20
  .word Deentle0
  .word Deentle1
  .byte $00
  
;Entities
EntityDefinitionTable:
DeentleEntity:
  .word deentleUpdate
  .byte $00  ;0  (this will be subtracted from spawnX)
  .byte $00  ;16 (this will be subtracted from spawnY)
  .byte %00000000
  .byte $00  
  .byte $00
  .byte $00
 

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

DEENTLE_INITSTATE = 0
DEENTLE_MOVERIGHTSTATE = 1
DEENTLE_MOVELEFTSTATE = 2

deentleUpdate:

  ;load current state
  lda entityPool+10,x
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
  sta entityPool+11,x
  lda #0
  sta entityPool+12,x
  
  ;switch state to "run"
  lda #DEENTLE_MOVELEFTSTATE
  sta entityPool+10,x
  jmp returnFromEntityUpdate

deentle_moveRightState:

  ;add 1 to PositionX
  clc
  lda entityPool+6,x
  adc #1
  sta entityPool+6,x
  lda entityPool+7,x
  adc #0
  sta entityPool+7,x
  
  ;do PositionX - spawnPositionX
  sec
  lda entityPool+6,x
  sbc entityPool+2,x
  sta w0
  lda entityPool+7,x
  sbc entityPool+3,x
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
  sta entityPool+10,x
  
dontSwitchToLeftState:

  jsr deentle_draw

  jmp returnFromEntityUpdate

deentle_moveLeftState:

  ;sub 1 from PositionX
  sec
  lda entityPool+6,x
  sbc #1
  sta entityPool+6,x
  lda entityPool+7,x
  sbc #0
  sta entityPool+7,x
  
  ;do spawnPositionX - PositionX
  sec
  lda entityPool+2,x
  sbc entityPool+6,x 
  sta w0
  lda entityPool+3,x
  sbc entityPool+7,x 
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
  sta entityPool+10,x
  
dontSwitchToRightState:
  

  jsr deentle_draw

  jmp returnFromEntityUpdate
  
deentle_draw:

  ;get out low byte of positionX
  lda entityPool+6,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+7,x
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
  lda entityPool+9,x
  sta b0
  jsr cameraToScreenCoords
  bmi killOffscreenDeentle
  bne :+

  ;get out low byte of positionX
  lda entityPool+6,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+7,x
  sta w0+1
  lda entityPool+9,x
  sta b0
  jsr cameraToScreenCoords
  bne :+
  
  ;b1 is screen X, b0 is screen Y, draw meta sprite needs b0 = x, b1 = y so swap them.
  lda b0
  pha
  lda b1
  sta b0
  pla
  sta b1

  ;load address of animation object into w1
  lda #<(entityPool+11)
  sta w1
  lda #>(entityPool+11)
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
  jsr updateAnimation  
  jsr drawAnimation
:
  rts
  
killOffscreenDeentle:

  lda #0
  sta entityPool,x

  rts
  