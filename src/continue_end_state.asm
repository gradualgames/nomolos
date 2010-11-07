.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixed_bank_data.inc"
.include "sprite.inc"
.include "level_in_state.inc"
.include "zp.inc"
.include "ram.inc"
.include "title_state.inc"
.include "continue_end_state.inc"
.include "statemanager.inc"
.include "soundengine.inc"
.include "controller.inc"
.include "nomolos_logic.inc"

.segment "CODE"

heart:
  .byte $01
  .byte $00,$2a,$01,$00,$00

.proc continue_end_state_update

  lda state_control_params+continue_end_state_control::state
  cmp #CONTINUEENDSTATE_INIT
  beq continue_end_state_init
  cmp #CONTINUEENDSTATE_RUN
  beq continue_end_state_run
  cmp #CONTINUEENDSTATE_SELECT
  beq continue_end_state_select
  cmp #CONTINUEENDSTATE_DONE
  bne :+
  jmp continue_end_state_done
:

continue_end_state_init:

  ;continue is selected
  lda #CONTINUE_SELECTED
  sta state_control_params+continue_end_state_control::selected_cursor

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

  lda #CONTINUEENDSTATE_RUN
  sta state_control_params+continue_end_state_control::state

  jmp stateCommandComplete

continue_end_state_run:

  jsr continue_end_state_run_handler

  jmp stateCommandComplete

 
  ;****************************************************************
  ;Check the select and start buttons for transition from off to
  ;on. Change the location of the cursor; make a decision when the
  ;start button is pressed.
  ;****************************************************************
continue_end_state_select:

  jsr continue_end_state_select_handler

  jmp stateCommandComplete
  
continue_end_state_done:
 
  lda frame_counter
  bne stateCommandComplete
 
  jsr continue_end_state_done_handler

  jmp stateCommandComplete

stateCommandComplete:

  rts
.endproc

.proc continue_end_state_run_handler

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

  ;display CONTINUE string
  set_ppu_2006 $20, 14, 11
  lda #<continue_string
  sta w0
  lda #>continue_string
  sta w0+1
  jsr ppu_display_string
  
  ;display END string
  set_ppu_2006 $20, 16, 11
  lda #<end_string
  sta w0
  lda #>end_string
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

  lda #CONTINUEENDSTATE_SELECT
  sta state_control_params+continue_end_state_control::state

  lda #64
  sta frame_counter

  rts

.endproc

.proc continue_end_state_done_handler

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
  
  rts

.endproc

.proc continue_end_state_select_handler

  ;wait for vblank to complete
  lda #0
  sta vblank_done
: lda vblank_done
  beq :-

  jsr sprite_clear_all
  jsr controller_read

  ;check for off to on transition on the select button
  lda buffer_controller+buttons::_select
  and #%00000011
  cmp #%00000001
  bne select_not_pressed
  
  ;flip the state of the selected cursor
  lda state_control_params+continue_end_state_control::selected_cursor
  eor #%00000001
  sta state_control_params+continue_end_state_control::selected_cursor
  
select_not_pressed:
  
  lda state_control_params+continue_end_state_control::selected_cursor
  bne display_end_cursor
  
  lda #CONTINUE_CURSOR_X
  sta b0
  lda #CONTINUE_CURSOR_Y
  sta b1
  
  jmp selected_cursor_test_done
  
display_end_cursor:
  lda #END_CURSOR_X
  sta b0
  lda #END_CURSOR_Y
  sta b1
  
selected_cursor_test_done:
  
  lda #0
  sta b2
  lda #<heart
  sta w0
  iny
  lda #>heart
  sta w0+1
  jsr sprite_draw_metasprite_8bit

  ;check for off to on transition on the start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  bne start_not_pressed
  
  ;fade out the palette
  lda #<(font1+font::palette)
  sta w0
  lda #>(font1+font::palette)
  sta w0+1
  jsr fade_out_palette
  
  ;now make a decision based on which cursor was selected
  .scope
  lda state_control_params+continue_end_state_control::selected_cursor
  bne end_selected
continue_selected:

  ;switch to load level state.
  lda #nomolos_starting_lives
  sta nomolos_status_lives
  lda #0
  sta state_control_params+level_in_state_control::use_restart_point
  lda #LEVELINSTATE_INIT
  sta state_control_params+level_in_state_control::state
  ldx #index_level_in_state
  jsr switch_state
  jmp selected_cursor_test_done
end_selected:
  
  ;switch to title state
  lda #TITLESTATE_INIT
  sta state_control_params+title_stateControl::state
  ldx #index_title_state
  jsr switch_state
  
selected_cursor_test_done:
  
  .endscope
  
start_not_pressed:
  
  rts
  
.endproc

.proc continue_end_state_update_ppu

  dec frame_counter
  
  jsr sprite_update_all
  
  lda #1
  sta vblank_done

  rts
.endproc
