.include "structs.inc"
.include "constants.inc"
.include "macros.inc"
.include "flags.inc"

;famitracker module
.import ft_music_init

;main module
.import clearNametable, loadPalette, displayString

;main module misc data
.import font1, gameOverString, haltmusic

;sprite module
.import clearSprites, updateSprites

;state return labels
.import updatePPUFinished, updateFinished

;level in state labels
.import titleStateUpdate, titleStateUpdatePPU

;zeropage labels
.importzp b0, b1, w0
.importzp stateControl
.importzp frameCounter
.importzp update, updatePPU
.importzp currentLevel
.importzp nomolosLives
.importzp ft_music_addr

.export gameOverUpdate, gameOverUpdatePPU

.segment "CODE"

gameOverUpdate:

  lda stateControl+gameOverStateControl::state
  cmp #GAMEOVERSTATE_INIT
  beq gameOverStateInit
  cmp #GAMEOVERSTATE_RUN
  beq gameOverStateRun
  cmp #GAMEOVERSTATE_DONE
  bne :+
  jmp gameOverStateDone
:
  
gameOverStateInit:

  ;the init state should be similar to the level in init state.
  ;turn sprite and background visibility off
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  lda #( ( 0 << PPU1_SPRITE_VISIBILITY ) | ( 0 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  lda #GAMEOVERSTATE_RUN
  sta stateControl+gameOverStateControl::state

  jmp stateCommandComplete
  
gameOverStateRun:

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

  ;display GAME OVER string
  lda #$20
  ;at location 14, 10
  ora #%00000001
  sta $2006
  lda #%11001010
  sta $2006
  lda #<gameOverString
  sta w0
  lda #>gameOverString
  sta w0+1
  jsr displayString

  ;wait for vblank so when we turn graphics back on we don't get ugly scrambling =)
  waitVBlank
  
  ;turn off music by playing track #0 of haltmusic  
.if .defined(MUSIC_ENABLE)
  lda #<haltmusic
  sta ft_music_addr
  lda #>haltmusic
  sta ft_music_addr+1
  lda #0
  ldx #0
  jsr ft_music_init
.endif  
  
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
  
  lda #GAMEOVERSTATE_DONE
  sta stateControl+gameOverStateControl::state

  lda #200
  sta frameCounter
  
  jmp stateCommandComplete
  
gameOverStateDone:

  lda frameCounter
  bne stateCommandComplete

  ;switch to title state
  lda #TITLESTATE_INIT
  sta stateControl+titleStateControl::state
  switchState titleStateUpdate, titleStateUpdatePPU
  
  jmp stateCommandComplete
  
stateCommandComplete:

  jmp updateFinished

gameOverUpdatePPU:

  dec frameCounter

  jmp updatePPUFinished