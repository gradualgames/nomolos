.include "structs.inc"
.include "constants.inc"

;main module imports
.import displayString
.import loadPalette
.import font1

;sprite module imports
.import clearSprites, updateSprites

;zeropage labels
.importzp w0
.importzp stateControl

;state return labels
.import updatePPUFinished, updateFinished

.export levelInUpdate, levelInPPUUpdate

.segment "CODE"

;GAME OVER
GameOver:
  .byte $09,$21,$1b,$27,$1f,$1a,$29,$30,$1f,$2c

levelInUpdate:

  lda stateControl+levelInStateControl::state
  cmp #LEVELINSTATE_INIT
  bne :+
  jmp levelInStateInit
:
  cmp #LEVELINSTATE_RUN
  bne :+
  jmp levelInStateRun
:
  cmp #LEVELINSTATE_DONE
  bne :+
  jmp levelInStateDone
:
  
levelInStateInit:

  ;turn sprite and background visibility off
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  lda #( ( 0 << PPU1_SPRITE_VISIBILITY ) | ( 0 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001

  lda #LEVELINSTATE_RUN
  sta stateControl+levelInStateControl::state
  
  jmp stateCommandComplete

levelInStateRun:

  ;rendering should be off so we can do what we want with the PPU

  ;clear the sprites
  jsr clearSprites
  ;update sprites
  jsr updateSprites

  ;clear the nametable
  lda #$20
  sta $2006
  lda #$00
  sta $2006
  
  ;clear nametable. First we write three groups of 256 tiles, then one group of 192,
  ;adding up to 960 total tiles in the nametable.
  ldy #3  
  lda #26   ;26 is a black tile in font1.
:
  ldx #0
: sta $2007
  dex
  bne :-
  dey 
  bne :--
  
  ;clear last 192 tiles of nametable.
  ldx #192
: sta $2007
  dex
  bne :-
  
  ;next write will be to attribute table, where there are 64 bytes.
  ;clear them all to 0.
  ldx #64
  lda #0
: sta $2007
  dex
  bne :-

  ;now that nametable is clear, load the new palette.
  lda #<(font1+font::palette)
  sta w0
  lda #>(font1+font::palette)
  sta w0+1
  jsr loadPalette
  
  ;now switch to the chr bank of fontset 1.
  lda font1+font::chrRomBank
  sta $A000
  lsr
  sta $A000
  lsr
  sta $A000
  lsr
  sta $A000
  lsr
  sta $A000
  
  ;now let's write a string!
  lda #$20
  ora #$0a
  sta $2006
  lda #$0c
  sta $2006
  lda #<GameOver
  sta w0
  lda #>GameOver
  sta w0+1
  jsr displayString
  
  ;turn sprite and background visibility on
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  lda #( ( 1 << PPU1_SPRITE_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  lda #LEVELINSTATE_DONE
  sta stateControl+levelInStateControl::state
  
  jmp stateCommandComplete

levelInStateDone:
  
stateCommandComplete:

  jmp updateFinished

levelInPPUUpdate:

  lda #0
  sta $2005
  sta $2005

  jmp updatePPUFinished