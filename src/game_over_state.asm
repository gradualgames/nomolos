.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixed_bank_data.inc"
.include "sprite.inc"
.include "level_in_state.inc"
.include "zp.inc"
.include "ram.inc"
.include "title_state.inc"
.include "game_over_state.inc"
.include "statemanager.inc"

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

  ;****************************************************************
  ;Wait for vblank, then turn off nmi and all graphics.
  ;****************************************************************
  wait_vblank

  ;turn sprite and background visibility off
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  ;turn off nmi
  clear_ppu_2000_bit PPU0_EXECUTE_NMI
  ;turn off inc32 since we are manipulating palette in this state
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  lda #GAMEOVERSTATE_RUN
  sta state_control_params+gameOverStateControl::state

  jmp stateCommandComplete

gameOverStateRun:

  ;****************************************************************
  ;Clear sprites and nametable, then load font graphics and write
  ;some GAME OVER on the screen.
  ;****************************************************************

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

  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  wait_vblank

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1
  jsr ppu_load_palette

  ;switch to PRG block containing font1
  lda font1+font::chr_prg_rom_bank
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;load chr data
  lda font1+font::chr_address
  sta w0
  lda font1+font::chr_address+1
  sta w0+1

  lda #$00
  sta $2006
  sta $2006

  jsr ppu_load_chr_amount

  ;display GAME OVER string
  set_ppu_2006 $20, 14, 11
  lda #<game_over_string
  sta w0
  lda #>game_over_string
  sta w0+1
  jsr ppu_display_string

  ;****************************************************************
  ;Wait for vblank, reset VRAM and scroll registers, turn nmi and
  ;graphics back on, then fade in the current palette.
  ;****************************************************************

  ;wait for vblank so when we turn graphics back on we don't get ugly scrambling =)
  wait_vblank

  ;reset scroll
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

  ;turn on sprite and background visibility
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  ;fade in the palette
  lda #<(font1+font::palette)
  sta w0
  lda #>(font1+font::palette)
  sta w0+1
  jsr fade_in_palette

  lda #GAMEOVERSTATE_DONE
  sta state_control_params+gameOverStateControl::state

  lda #200
  sta frame_counter

  jmp stateCommandComplete

gameOverStateDone:

  lda frame_counter
  bne stateCommandComplete

  ;fade out the palette
  lda #<(font1+font::palette)
  sta w0
  lda #>(font1+font::palette)
  sta w0+1
  jsr fade_out_palette

  ;switch to title state
  lda #TITLESTATE_INIT
  sta state_control_params+title_stateControl::state
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
