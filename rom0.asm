;zp variables
.importzp b0, b1, w0

.import entityPool

;entity module
.import returnFromEntityUpdate

;camera module
.import cameraToScreenCoords

;sprite module
.import drawMetaSprite

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
  .byte $00,$00,$00,$00,$06,$00,$00,$00,$08,$03,$00,$00,$00,$00,$03,$00
MetaMetaTile4:
  .byte $00,$00,$00,$08,$06,$00,$00,$00,$00,$03,$00,$00,$00,$00,$03,$00
MetaMetaTile5:
  .byte $00,$00,$00,$00,$07,$00,$00,$00,$00,$04,$00,$00,$00,$00,$03,$00
MetaMetaTile6:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$03,$00
MetaMetaTile7:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$01,$01,$01,$03,$00
MetaMetaTile8:
  .byte $00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile9:
  .byte $00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile10:
  .byte $00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile11:
  .byte $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile12:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$03,$00
MetaMetaTile13:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$03,$00
MetaMetaTile14:
  .byte $00,$00,$00,$00,$00,$00,$08,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile15:
  .byte $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile16:
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,$03,$00
MetaMetaTile17:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile18:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$03,$00,$03,$00,$03,$00
MetaMetaTile19:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$04,$00,$03,$00
MetaMetaTile20:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$03,$00
MetaMetaTile21:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$03,$00
MetaMetaTile22:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$03,$00
MetaMetaTile23:
  .byte $00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile24:
  .byte $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile25:
  .byte $00,$00,$00,$00,$01,$00,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile26:
  .byte $00,$00,$03,$03,$03,$03,$03,$03,$03,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile27:
  .byte $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile28:
  .byte $00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile29:
  .byte $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile30:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile31:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile32:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$03,$00
MetaMetaTile33:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$03,$00
MetaMetaTile34:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$03,$00
MetaMetaTile35:
  .byte $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$03,$00
MetaMetaTile36:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$03,$00
Level:
  .byte $00,$00,$00,$00,$00,$00,$00,$01,$02,$02,$03,$04,$05,$00,$00,$06,$06,$06,$06,$07,$00,$00,$08,$09,$0a,$0b,$0c,$0d,$00,$00,$08,$09
  .byte $0e,$0f,$00,$00,$10,$00,$00,$11,$12,$12,$13,$00,$00,$14,$15,$15,$16,$00,$00,$00,$17,$18,$18,$18,$17,$00,$00,$00,$19,$00,$00,$1a
  .byte $00,$00,$00,$00,$1b,$1c,$1c,$1c,$1c,$1d,$00,$00,$1e,$1f,$1f,$1f,$1f,$1f,$0d,$00,$1b,$1c,$1c,$1c,$1c,$1c,$1d,$00,$00,$20,$20,$20
  .byte $20,$20,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$22,$23,$24,$24,$23,$22,$21,$00,$00
 
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
  .byte $0a
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
;.dsb alive = 1
;.dsb index = definition index (this is a parameter)
;.dsw spawnPositionX = initialXOffset + x
;.dsb spawnPositionY = initialYOffset + y
;.dsb positionXFine  = unknown, this is expected to be used (or not used) by the entity
;.dsw positionX      = x (this is a parameter)
;.dsb positionYFine  = unknown, this is expected to be used (or not used) by the entity
;.dsb positionY      = y (this is a parameter)
;.dsb state          = initialState
;.dsw animationObject  = unknown, this expected to be set by the entity
;.dsb 3 ;padding to 16 bytes
deentleUpdate:

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

  lda #<Deentle0
  sta w0
  lda #>Deentle0
  sta w0+1
  ;lda #50
  ;sta b0  
  ;sta b1
  jsr drawMetaSprite
:

  jmp returnFromEntityUpdate