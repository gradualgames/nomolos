.include "structs.inc"
.include "constants.inc"
.include "macros.inc"
.include "flags.inc"

;famitracker module
.import ft_music_play

;zeropage variables
.importzp w0, scrollX, nametableToUpdate
.importzp paletteStep, frameCounter
.importzp stateControl
.importzp romDefinitionTableBaseAddress
.importzp update, updatePPU
.importzp nomolosLives

;game over state labels
.import gameOverUpdate, gameOverUpdatePPU

;level in state labels
.import levelInUpdate, levelInPPUUpdate

.export levelOutUpdate, levelOutPPUUpdate

.segment "CODE"

levelOutUpdate:

  rts
  
levelOutPPUUpdate:

  lda stateControl+levelOutStateControl::state
  cmp #LEVELOUTSTATE_INIT
  beq levelOutStateInit
  cmp #LEVELOUTSTATE_FADEOUT
  beq levelOutStateFadeOut
  jmp stateCommandComplete
    
  ;************************************************************
  ;init state
  ;************************************************************
levelOutStateInit:

  lda #5
  sta frameCounter
  lda #0
  sta paletteStep
  lda #LEVELOUTSTATE_FADEOUT
  sta stateControl+levelOutStateControl::state
  
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  
  jmp stateCommandComplete

  ;************************************************************
  ;fade out state
  ;************************************************************
levelOutStateFadeOut:

  dec frameCounter
  beq :+
  jmp skipIncPaletteStep
:
  
  lda #5
  sta frameCounter
  
  lda paletteStep
  cmp #6
  bmi :+ 
  
  ;this is the end condition of the fade out. Instead of skipping the step
  ;we want to actually switch to the level in state.
  
  lda nomolosLives
  
  bmi livesNegativeMeansGameOver
  
  lda #LEVELINSTATE_INIT
  sta stateControl+levelOutStateControl::state
  switchState levelInUpdate, levelInPPUUpdate
  jmp skipIncPaletteStep
  
livesNegativeMeansGameOver:

  lda #GAMEOVERSTATE_INIT
  sta stateControl+gameOverStateControl::state
  switchState gameOverUpdate, gameOverUpdatePPU
  jmp skipIncPaletteStep

:
  
  inc paletteStep

  ;************************************************************
  ;Load paletteStep, decide how to modify the current palette
  ;based on that step. 
  ;************************************************************
  lda paletteStep
  cmp #3
  bpl stepGreaterThanOrEqualToFour
stepLessThanFour:

  ;load the address of the current palette in ROM
  ldy #ROMDefinitionTableStruct::palette
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  ldy #0
  lda #$3F
  sta $2006
  lda #$00
  sta $2006  
  ldx #$00
: 

  ;save x
  txa
  pha

  ;load palette entry
  lda (w0),y
  
  ;load the current palette step
  ldx paletteStep
darkenPaletteLoop:
  cmp #$10
  bmi paletteEntryLessThan16

  ;subtract 16 from the palette entry
  sec
  sbc #$10
  
paletteEntryLessThan16:
  
  dex
  bne darkenPaletteLoop
  
  ;store new palette value 
  sta $2007
  
  ;restore x
  pla
  tax

  inx
  iny
  cpx #$20
  bne :-
  
  jmp stateCommandComplete
  
stepGreaterThanOrEqualToFour:
  
dropOutAllColorsToBlack:
  ;drop out all colors to black
  lda #$3F
  sta $2006
  lda #$00
  sta $2006  
  ldx #$00
: lda #$3f
  sta $2007
  inx
  cpx #$20
  bne :-
  
skipIncPaletteStep:
  
stateCommandComplete:

  lda nametableToUpdate
  eor #$04
  sta $2006
  lda #$00
  sta $2006

  lda scrollX
  sta $2005
  lda #0
  sta $2005
  
  .ifdef MUSIC_ENABLE
  jsr ft_music_play
  .endif

  rts
  