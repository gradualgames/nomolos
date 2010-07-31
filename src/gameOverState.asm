.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixedBankData.inc"
.include "sprite.inc"
.include "levelInState.inc"
.include "zp.inc"
.include "titleState.inc"
.include "gameOverState.inc"

.segment "CODE"

.proc game_over_state_update

  lda state_control_params+gameOverStateControl::state
  cmp #GAMEOVERSTATE_INIT
  beq gameOverStateInit
  cmp #GAMEOVERSTATE_RUN
  beq gameOverStateRun
  cmp #GAMEOVERSTATE_DONE
  bne :+
  jmp gameOverStateDone
:
  
gameOverStateInit:

  waitVBlank
  
  ;turn sprite and background visibility off
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001
  
  lda #GAMEOVERSTATE_RUN
  sta state_control_params+gameOverStateControl::state

  jmp stateCommandComplete
  
gameOverStateRun:

  ;clear the sprites
  jsr sprite_clear_all
  ;update sprites
  jsr sprite_update_all

  ;clear the nametable
  lda #$20
  sta $2006
  lda #$00
  sta $2006
  
  lda #26
  sta b0
  lda #0
  sta b1
  jsr ppu_clear_name_table  
  
  ;now that nametable is clear, load the new palette.
  lda #<(font1+font::palette)
  sta w0
  lda #>(font1+font::palette)
  sta w0+1
  waitVBlank
  jsr ppu_load_palette
  
  ;switch to PRG block containing font1
  lda font1+font::chrPrgRomBank
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;load chr data
  lda font1+font::chrAddress
  sta w0
  lda font1+font::chrAddress+1
  sta w0+1
  
  lda #$00
  sta $2006
  sta $2006
  
  jsr ppu_load_chr_amount

  ;display GAME OVER string
  set_ppu_2006 $20, 14, 11
  lda #<gameOverString
  sta w0
  lda #>gameOverString
  sta w0+1
  jsr ppu_display_string

  ;wait for vblank so when we turn graphics back on we don't get ugly scrambling =)
  waitVBlank
  
  ;reset scroll
  lda #0
  sta $2005
  sta $2005
  
  ;turn on sprite and background visibility
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001
  
  lda #GAMEOVERSTATE_DONE
  sta state_control_params+gameOverStateControl::state

  lda #200
  sta frame_counter
  
  jmp stateCommandComplete
  
gameOverStateDone:

  lda frame_counter
  bne stateCommandComplete

  ;switch to title state
  lda #TITLESTATE_INIT
  sta state_control_params+titleStateControl::state
  ldx #index_title_state
  jsr switch_state
  
  jmp stateCommandComplete
  
stateCommandComplete:

  rts
.endproc

.proc game_over_state_update_ppu

  dec frame_counter

  rts
.endproc
  