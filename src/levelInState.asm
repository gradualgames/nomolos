.include "macros.inc"
.include "flags.inc"
.include "loadLevelState.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixedBankData.inc"
.include "sprite.inc"
.include "zp.inc"
.include "levelInState.inc"

.segment "CODE"

.proc level_in_state_update
  lda state_control_params+levelInStateControl::state
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

  waitVBlank
  
  ;turn sprite and background visibility off
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001
  
  lda #LEVELINSTATE_RUN
  sta state_control_params+levelInStateControl::state
  
  jmp stateCommandComplete

levelInStateRun:

  ;rendering should be off so we can do what we want with the PPU

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
  jsr ppu_load_palette_bg
  
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
  
  ;create decimal string for level_current variable
  lda level_current
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
  lda #<ppu_string_buffer
  sta w2
  lda #>ppu_string_buffer
  sta w2+1
  
  jsr ppu_create_decimal_string
  
  ;now let's write a string!
  set_ppu_2006 $20, 13, 11
  
  lda #<levelString
  sta w0
  lda #>levelString
  sta w0+1
  
  jsr ppu_display_string
  
  lda #<ppu_string_buffer
  sta w0
  lda #>ppu_string_buffer
  sta w0+1
  
  jsr ppu_display_string
  
  ;display lives remaining string
  set_ppu_2006 $20, 14, 11
  lda #<livesString
  sta w0
  lda #>livesString
  sta w0+1
  jsr ppu_display_string
  
  ;create decimal string for nomolos_status_lives variable
  lda nomolos_status_lives
  sta b0
  lda #<(font1+font::digitTable)
  sta w0
  lda #>(font1+font::digitTable)
  sta w0+1
  lda #<powerTable
  sta w1
  lda #>powerTable
  sta w1+1
  lda #<ppu_string_buffer
  sta w2
  lda #>ppu_string_buffer
  sta w2+1
  
  jsr ppu_create_decimal_string
  
  ;now display the string right where we are in VRAM (at the end of "Lives...")
  lda #<ppu_string_buffer
  sta w0
  lda #>ppu_string_buffer
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
  
  lda #200
  sta frame_counter
  
  lda #LEVELINSTATE_DONE
  sta state_control_params+levelInStateControl::state
  
  jmp stateCommandComplete

levelInStateDone:
  
  lda frame_counter
  bne stateCommandComplete
  
  ;load current level
  lda level_current
  sta state_control_params+loadLevelStateControl::levelToLoad
  lda #LOADLEVELSTATE_INIT
  sta state_control_params+loadLevelStateControl::state
  
  switchState load_level_state_update, load_level_state_update_ppu
  
stateCommandComplete:

  rts
.endproc

.proc level_in_state_update_ppu

  dec frame_counter

  rts
.endproc
  