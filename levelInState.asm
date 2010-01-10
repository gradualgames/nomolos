.include "structs.inc"
.include "constants.inc"
.include "macros.inc"

;main module imports
.import displayString, createDecimalString
.import loadPalette, clearNametable
.import font1, powerTable

;sprite module imports
.import clearSprites, updateSprites

;zeropage labels
.importzp b0, b1, b2, b3, w0, w1, w2
.importzp stateControl
.importzp stringBuffer

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
  
  lda #26
  sta b0
  lda #0
  sta b1
  jsr clearNametable  
  
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
  
;Creates a decimal string based on a digit table and a power table
;and an input 8 bit value.
;Input:
; b0 - Value to create decimal string from
; w0 - Address of digit table
; w1 - Address of power table
; w2 - Address of destination buffer
;Output:
; w2 - Contains a string displayable by displayString
;Temporary:
; b1 - current power
; b2 - current digit
; b3 - index in dest buffer

  lda #27
  sta b0
  lda #<(font1+font::digitTable)
  sta w0
  lda #>(font1+font::digitTable)
  sta w0+1
  lda #<powerTable
  sta w1
  lda #>powerTable
  sta w1+1
  lda #<stringBuffer
  sta w2
  lda #>stringBuffer
  sta w2+1
  
  jsr createDecimalString
  
  ;now let's write a string!
  lda #$20
  ora #$0a
  sta $2006
  lda #$0c
  sta $2006
  lda #<stringBuffer
  sta w0
  lda #>stringBuffer
  sta w0+1
  jsr displayString
  
  lda #0
  sta $2005
  sta $2005
  
  ;turn sprite and background visibility on
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  
  ;wait for vblank so when we turn graphics back on we don't get ugly scrambling =)
  waitVBlank
  
  lda #( ( 1 << PPU1_SPRITE_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  lda #LEVELINSTATE_DONE
  sta stateControl+levelInStateControl::state
  
  jmp stateCommandComplete

levelInStateDone:
  
stateCommandComplete:

  jmp updateFinished

levelInPPUUpdate:

  ;lda #0
  ;sta $2005
  ;sta $2005

  jmp updatePPUFinished