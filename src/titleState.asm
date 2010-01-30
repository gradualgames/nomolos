.include "structs.inc"
.include "constants.inc"
.include "macros.inc"
.include "controller.inc"
.include "misc.inc"
.include "miscdata.inc"
.include "sprite.inc"
.include "levelInState.inc"
.include "zp.inc"

.segment "CODE"

.export titleStateUpdate
.proc titleStateUpdate

  lda stateControl+titleStateControl::state
  cmp #TITLESTATE_INIT
  beq titleStateInit
  cmp #TITLESTATE_RUN
  beq titleStateRun
  cmp #TITLESTATE_DONE
  beq titleStateDone
  
titleStateInit:

  ;this init state should be similar to the level in state, only we won't be
  ;clearing the nametable, we'll be loading it from a particular location.

  ;turn sprite and background visibility off
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  lda #( ( 0 << PPU1_SPRITE_VISIBILITY ) | ( 0 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  lda #TITLESTATE_RUN
  sta stateControl+titleStateControl::state

  jmp stateCommandComplete
  
titleStateRun:

  ;clear the sprites
  jsr clearSprites
  ;update sprites
  jsr updateSprites

  ;load the title nametable and attribute table.
  lda #$20
  sta $2006
  lda #$00
  sta $2006
  lda titleDef+title::nametableAddress
  sta w0
  lda titleDef+title::nametableAddress+1
  sta w0+1
  jsr loadNametable
  
  ;now switch to the prg bank containing the chr data of the title screen.
  lda titleDef+title::chrPrgRomBank
  sta b0
  jsr bankswitch
  
  ;now load the chr data
  lda titleDef+title::chrAddress
  sta w0
  lda titleDef+title::chrAddress+1
  sta w0+1
  jsr loadChr
  
  ;now that nametable loaded, load the new palette.
  lda titleDef+title::paletteAddress
  sta w0
  lda titleDef+title::paletteAddress+1
  sta w0+1
  jsr loadPalette
  
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
  
  lda #TITLESTATE_DONE
  sta stateControl+titleStateControl::state
  
  jmp stateCommandComplete
  
titleStateDone:

  jsr readController
  lda controllerBuffer+buttons::_start
  and #1
  beq :+
  
  ;start was pressed, now we want to switch to level in state
  ;set current level and switch to "level in" state
  ;start out Nomolos with 3 lives.
  lda #nomolosStartingLives
  sta nomolosLives
  lda #startingLevel
  sta currentLevel
  lda #LEVELINSTATE_INIT
  sta stateControl+levelOutStateControl::state
  switchState levelInUpdate, levelInPPUUpdate
  
:

  jmp stateCommandComplete
  
stateCommandComplete:

  rts
.endproc
  
.export titleStateUpdatePPU
.proc titleStateUpdatePPU

  rts
.endproc
  