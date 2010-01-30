.include "structs.inc"
.include "constants.inc"
.include "macros.inc"
.include "flags.inc"
.include "famitracker.inc"
.include "loadLevelState.inc"
.include "misc.inc"
.include "miscdata.inc"
.include "sprite.inc"
.include "zp.inc"

.segment "CODE"

.export levelInUpdate
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
  
  ;switch to PRG block containing font1
  lda font1+font::chrPrgRomBank
  sta b0
  jsr bankswitch
  
  ;load chr data
  lda font1+font::chrAddress
  sta w0
  lda font1+font::chrAddress+1
  sta w0+1
  jsr loadChr
  
  ;create decimal string for currentLevel variable
  lda currentLevel
  ;add one to level so level 0 is displayed as level 1, etc.
  clc
  adc #1
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
  ;at location 13, 10
  ora #%00000001
  sta $2006
  lda #%10101010
  sta $2006
  
  lda #<levelString
  sta w0
  lda #>levelString
  sta w0+1
  
  jsr displayString
  
  lda #<stringBuffer
  sta w0
  lda #>stringBuffer
  sta w0+1
  
  jsr displayString
  
  ;display lives remaining string
  lda #$20
  ;at location 14, 10
  ora #%00000001
  sta $2006
  lda #%11001010
  sta $2006
  lda #<livesString
  sta w0
  lda #>livesString
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
  
  lda #200
  sta frameCounter
  
  lda #LEVELINSTATE_DONE
  sta stateControl+levelInStateControl::state
  
  jmp stateCommandComplete

levelInStateDone:
  
  lda frameCounter
  bne stateCommandComplete
  
  ;load current level
  lda currentLevel
  sta stateControl+loadLevelStateControl::levelToLoad
  lda #LOADLEVELSTATE_INIT
  sta stateControl+loadLevelStateControl::state
  
  switchState loadLevelUpdate, loadLevelUpdatePPU
  
stateCommandComplete:

  rts

.export levelInPPUUpdate
levelInPPUUpdate:

  dec frameCounter

  rts
  