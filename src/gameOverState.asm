.include "structs.inc"
.include "constants.inc"
.include "macros.inc"
.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixedBankData.inc"
.include "sprite.inc"
.include "levelInState.inc"
.include "zp.inc"
.include "titleState.inc"

.segment "CODE"

.export game_over_state_update
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
  
  ;the init state should be similar to the level in init state.
  ;turn sprite and background visibility off
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  lda #( ( 0 << PPU1_SPRITE_VISIBILITY ) | ( 0 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
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
  jsr ppu_load_chr

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
  jsr ppu_display_string

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
  switchState title_state_update, title_state_update_ppu
  
  jmp stateCommandComplete
  
stateCommandComplete:

  rts
.endproc

.export game_over_state_update_ppu
.proc game_over_state_update_ppu

  dec frame_counter

  rts
.endproc
  