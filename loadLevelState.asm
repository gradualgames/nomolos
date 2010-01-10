.include "macros.inc"
.include "constants.inc"
.include "structs.inc"

;state return labels
.import updatePPUFinished, updateFinished
;play level state
.import playLevelUpdatePPU, playLevelUpdate
;map update routines
.import updateScrollPPU, updateColumnPPU, updateAttributePPU
;sprite update routines
.import updateSprites, clearSprites, updateColumn
;entity routines
.import initEntities, updateEntities
;global variables
.importzp update, updatePPU, stateControl
.importzp w1, w3, levelBaseAddress, columnToUpdate
.importzp metametaTileTableBaseAddress, nametableToUpdate

;load level state labels
.export loadLevelUpdate, loadLevelUpdatePPU

.segment "CODE"

loadLevelUpdate:

  lda columnToUpdate
  cmp #32
  bne :+
  jmp updateFinished
:

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

  ;calculate spawnX
  lda columnToUpdate
  asl
  asl
  asl
  sta w3 ;spawnX
  lda #0
  sta w3+1 ;spawnX+1
  
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
  ;keep any new entities positioned where they need to be
  jsr updateEntities
  lda #$24
  sta nametableToUpdate  

  lda #PLAYLEVELSTATE_KEEPPLAYING
  sta stateControl+playLevelStateControl::state
  
  switchState playLevelUpdate, playLevelUpdatePPU
    
  ;turn rendering on
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
   
  lda #( ( 1 << PPU1_SPRITE_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
:
  jmp updateFinished
  
loadLevelUpdatePPU:
  jmp updatePPUFinished  