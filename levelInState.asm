.include "structs.inc"
.include "constants.inc"
.include "macros.inc"

;main module imports
.import displayString, createDecimalString
.import loadPalette, clearNametable
.import font1, powerTable, livesRemaining

;sprite module imports
.import clearSprites, updateSprites

;zeropage labels
.importzp b0, b1, b2, b3, w0, w1, w2
.importzp stateControl
.importzp stringBuffer
.importzp romDefinitionTableBaseAddress
.importzp nomolosLives

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
  
  ;now let's write a string!
  lda #$20
  ;at location 13, 10
  ora #%00000001
  sta $2006
  lda #%10101010
  sta $2006
  ldy #ROMDefinitionTableStruct::LevelTitle
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  jsr displayString
  
  ;display lives remaining string
  lda #$20
  ;at location 14, 10
  ora #%00000001
  sta $2006
  lda #%11001010
  sta $2006
  lda #<livesRemaining
  sta w0
  lda #>livesRemaining
  sta w0+1
  jsr displayString
  
  ;create decimal string for nomolosLives variable
  lda nomolosLives
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
  
  ;now display the string right where we are in VRAM (at the end of "Lives...")
  lda #<stringBuffer
  sta w0
  lda #>stringBuffer
  sta w0+1
  
  jsr displayString

  ;wait for vblank so when we turn graphics back on we don't get ugly scrambling =)
  waitVBlank
  
  ;reset scroll
  lda #0
  sta $2005
  sta $2005
  
  ;turn on NMI
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  ;turn sprite and background visibility on
  lda #( ( 1 << PPU1_SPRITE_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  lda #LEVELINSTATE_DONE
  sta stateControl+levelInStateControl::state
  
  jmp stateCommandComplete

levelInStateDone:
  
stateCommandComplete:

  jmp updateFinished

levelInPPUUpdate:

  jmp updatePPUFinished