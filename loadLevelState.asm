;state return labels
.import updatePPUFinished, updateFinished
;play level state
.import playLevelUpdatePPU, playLevelUpdate
;map update routines
.import updateScrollPPU, updateColumnPPU, updateAttributePPU
;sprite update routines
.import updateSprites, clearSprites, updateColumn
;global variables
.importzp update, updatePPU
.importzp w1, levelBaseAddress, columnToUpdate
.importzp metametaTileTableBaseAddress, nametableToUpdate

;load level state labels
.export loadLevelUpdate, loadLevelUpdatePPU

.segment "CODE"

loadLevelUpdate:

  lda #$20
  sta nametableToUpdate

  lda columnToUpdate
  lsr
  tay
  lda (levelBaseAddress),y

  ;store the meta meta tile index as a 16 bit number
  sta w1
  lda #0
  sta w1+1

  ;shift left this number by 4
  ldx #4
:
  asl w1
  rol w1+1
  dex
  bne :-

  ;now add MetaMetaTileTable to this number
  clc
  lda w1
  adc metametaTileTableBaseAddress
  sta w1
  lda w1+1
  adc metametaTileTableBaseAddress+1
  sta w1+1

  lda columnToUpdate
  jsr updateColumn

  ;rendering is off in this state, so we update the PPU
  jsr updateSprites
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU

  ;move on to next column.
  inc columnToUpdate
  inc columnToUpdate

  lda columnToUpdate
  ;have we updated all the columns on the screen yet?
  cmp #32
  bne :+
  ;switch to play level state.
  lda #$24
  sta nametableToUpdate  
  lda #<playLevelUpdate
  sta update
  lda #>playLevelUpdate
  sta update+1
  lda #<playLevelUpdatePPU
  sta updatePPU
  lda #>playLevelUpdatePPU
  sta updatePPU+1
  ;turn rendering on
  lda #%00011110
  sta $2001
:
  jmp updateFinished
  
loadLevelUpdatePPU:
  jmp updatePPUFinished  