.include "flags.inc"
.include "load_level_state.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixed_bank_data.inc"
.include "sprite.inc"
.include "zp.inc"
.include "ram.inc"
.include "level_in_state.inc"
.include "statemanager.inc"

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

  lda #LEVELINSTATE_RUN
  sta state_control_params+levelInStateControl::state

  jmp stateCommandComplete

levelInStateRun:


  ;****************************************************************
  ;Clear sprites and nametable, then load font graphics and write
  ;some strings to the screen introducing the level.
  ;****************************************************************

  ;rendering should be off so we can do what we want with the PPU

  ;clear the sprites
  jsr sprite_clear_all
  ;update sprites
  jsr sprite_update_all

  ;clear the nametable
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

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
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

  jsr ppu_load_chr_amount

  ;create decimal string for level_current variable
  lda level_current
  ;add one to level so level 0 is displayed as level 1, etc.
  clc
  adc #1
  sta b0
  lda #<(font1+font::digit_table)
  sta w0
  lda #>(font1+font::digit_table)
  sta w0+1
  lda #<power_table
  sta w1
  lda #>power_table
  sta w1+1
  lda #<ppu_string_buffer
  sta w2
  lda #>ppu_string_buffer
  sta w2+1

  jsr ppu_create_decimal_string

  lda level_current
  ;multiply accumulator by 2
  asl
  ;transfer to x for indexing
  tax

  ;Load location of the rom definition table for this level
  lda level_definition_table+level::level_data_table,x
  sta base_address_rom_definition_table
  lda level_definition_table+level::level_data_table+1,x
  sta base_address_rom_definition_table+1
  
  ;now let's write a string!
  set_ppu_2006 $20, 13, 11

  ldy #level_data_struct::intro_string
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  jsr ppu_display_string

  ;display lives remaining string
  set_ppu_2006 $20, 14, 11
  lda #<lives_string
  sta w0
  lda #>lives_string
  sta w0+1
  jsr ppu_display_string

  ;create decimal string for nomolos_status_lives variable
  lda nomolos_status_lives
  sta b0
  lda #<(font1+font::digit_table)
  sta w0
  lda #>(font1+font::digit_table)
  sta w0+1
  lda #<power_table
  sta w1
  lda #>power_table
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

  ;turn on nmi
  set_ppu_2000_bit PPU0_EXECUTE_NMI
  upload_ppu_2000

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

  lda #64
  sta frame_counter

  lda #LEVELINSTATE_DONE
  sta state_control_params+levelInStateControl::state

  jmp stateCommandComplete

levelInStateDone:

  lda frame_counter
  bne stateCommandComplete

  ;fade out the palette
  lda #<(font1+font::palette)
  sta w0
  lda #>(font1+font::palette)
  sta w0+1
  jsr fade_out_palette

  ;load current level
  lda level_current
  sta state_control_params+load_level_stateControl::levelToLoad
  lda #LOADLEVELSTATE_INIT
  sta state_control_params+load_level_stateControl::state

  ldx #index_load_level_state
  jsr switch_state

stateCommandComplete:

  rts
.endproc

.proc level_in_state_update_ppu

  dec frame_counter

  rts
.endproc
