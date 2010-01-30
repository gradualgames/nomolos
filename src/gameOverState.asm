.include "structs.inc"
.include "constants.inc"
.include "macros.inc"
.include "flags.inc"
.include "famitracker.inc"
.include "misc.inc"
.include "miscdata.inc"
.include "sprite.inc"
.include "levelInState.inc"
.include "zp.inc"
.include "titleState.inc"

.segment "CODE"

.export gameOverUpdate
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

  rts

.export gameOverUpdatePPU
gameOverUpdatePPU:

  dec frameCounter

  rts
  