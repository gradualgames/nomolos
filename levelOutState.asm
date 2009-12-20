.include "structs.inc"
.include "constants.inc"

;zeropage variables
.importzp w0, scrollX, nametableToUpdate
.importzp paletteStep, frameCounter
.importzp stateControl
.importzp romDefinitionTableBaseAddress

;state return labels
.import updatePPUFinished, updateFinished

.export levelOutUpdate, levelOutPPUUpdate

.segment "CODE"

levelOutUpdate:

  jmp updateFinished
  
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
  
  ;cmp #4
  ;beq dropOutAllButOneColorToBlack
  ;cmp #5
  ;beq dropOutAllColorsToBlack
  
;dropOutAllButOneColorToBlack:
;  
;  ;drop out all but one color (in each 4 color palette) to black
;  ldy #ROMDefinitionTableStruct::palette
;  lda (romDefinitionTableBaseAddress),y
;  sta w0
;  iny
;  lda (romDefinitionTableBaseAddress),y
;  sta w0+1
;  ldy #0
;  lda #$3F
;  sta $2006
;  lda #$00
;  sta $2006  
;  ldx #$00
;: 
;  txa
;  and #$03
;  beq writeNormalColor
;  lda #$3f
;  sta $2007
;  jmp skipWriteNormalColor
;writeNormalColor:
;  lda $2007
;skipWriteNormalColor:  
;  inx
;  iny
;  cpx #$20
;  bne :-
;  
;  jmp stateCommandComplete
  
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

  jmp updatePPUFinished