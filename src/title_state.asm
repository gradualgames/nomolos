.include "flags.inc"
.include "soundengine.inc"
.include "controller.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixed_bank_data.inc"
.include "sprite.inc"
.include "level_in_state.inc"
.include "zp.inc"
.include "ram.inc"
.include "nomolos_logic.inc"
.include "title_state.inc"
.include "statemanager.inc"
.include "slides.inc"

.segment "CODE"

.ifdef LEVEL_SELECTOR_ENABLED
.proc create_selected_level_string
  ;add one to level so level 0 is displayed as level 1, etc.
  lda state_control_params+title_stateControl::starting_level
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
  rts
.endproc

.proc display_selected_level_string
  set_ppu_2006 $20, 24, 10
  lda #<spaces_string
  sta w0
  lda #>spaces_string
  sta w0+1
  
  jsr ppu_display_string

  set_ppu_2006 $20, 24, 10
  lda #<ppu_string_buffer
  sta w0
  lda #>ppu_string_buffer
  sta w0+1

  jsr ppu_display_string
  rts
.endproc
.endif

.proc title_state_update

  lda state_control_params+title_stateControl::state
  cmp #TITLESTATE_INIT
  bne :+
  jmp  title_stateInit
:
  cmp #TITLESTATE_RUN
  bne :+
  jmp title_stateRun
:
  cmp #TITLESTATE_DONE
  bne :+
  jmp title_stateDone
:

title_stateInit:

  ;****************************************************************
  ;Wait for vblank, then turn off nmi and all graphics.
  ;****************************************************************

  ;this init state should be similar to the level in state, only we won't be
  ;clearing the nametable, we'll be loading it from a particular location.
  wait_vblank

  ;turn off nmi
  clear_ppu_2000_bit PPU0_EXECUTE_NMI
  ;turn off inc32, we're just loading a nametable in this state
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  ;load sprite pattern table from $1000
  set_ppu_2000_bit PPU0_SPRITE_PATTERN_TABLE_ADDRESS
  upload_ppu_2000

  ;turn off sprite visibility
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  ;turn off background visibility
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  ;reset the level selector counter
  .ifdef LEVEL_SELECTOR_ENABLED
  lda #0
  sta state_control_params+title_stateControl::starting_level
  jsr create_selected_level_string
  .endif
  
  lda #TITLESTATE_RUN
  sta state_control_params+title_stateControl::state

  jmp stateCommandComplete

title_stateRun:

  ;****************************************************************
  ;Clear sprite memory, load title graphics, load faded out palette
  ;****************************************************************

  ;clear the sprites
  jsr sprite_clear_all
  ;update sprites
  jsr sprite_update_all

  ;switch to the prg bank containing the title screen
  lda title_definition+title::nametable_bank
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;load the title nametable and attribute table.
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006
  lda title_definition+title::name_table_address
  sta w0
  lda title_definition+title::name_table_address+1
  sta w0+1
  jsr ppu_load_name_table

  ;now switch to the prg bank containing the chr data of the title screen.
  lda title_definition+title::chr_prg_rom_bank
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;now load the chr data
  lda title_definition+title::chr_address
  sta w0
  lda title_definition+title::chr_address+1
  sta w0+1

  lda #$00
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

  jsr ppu_load_chr_amount

  ;write some important strings onto the title screen!
  set_ppu_2006 $20, 19, 10
  lda #<press_start_string
  sta w0
  lda #>press_start_string
  sta w0+1

  jsr ppu_display_string

  set_ppu_2006 $20, 22, 10
  lda #<gradual_games_string
  sta w0
  lda #>gradual_games_string
  sta w0+1

  jsr ppu_display_string

  set_ppu_2006 $20, 23, 10

  lda #<copyright_c_2012_string
  sta w0
  lda #>copyright_c_2012_string
  sta w0+1

  jsr ppu_display_string

  ;now that nametable loaded, load the new palette faded out
  lda title_definition+title::palette_address
  sta w0
  lda title_definition+title::palette_address+1
  sta w0+1

  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  wait_vblank
  jsr ppu_load_palette

  ;****************************************************************
  ;Set VRAM and scroll registers to point to first nametable and
  ;scroll to 0, 0. Then switch on nmi and all graphics and fade in
  ;the palette using the dynamic palette upload nmi routine in
  ;the state manager module.
  ;Start title music playing.
  ;****************************************************************

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

  ;turn sprite and background visibility on
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  lda title_definition+title::palette_address
  sta w0
  lda title_definition+title::palette_address+1
  sta w0+1

  jsr fade_in_palette

  ;load title screen music
.ifdef MUSIC_ENABLE
  lda #<title_music
  sta sound_param_word_1
  lda #>title_music
  sta sound_param_word_1+1
  jsr song_initialize
.endif

  ;turn off inc32
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  lda #TITLESTATE_DONE
  sta state_control_params+title_stateControl::state

  jmp stateCommandComplete

title_stateDone:
  
: lda nmi_counter
  bne :-

  jsr controller_read
  
  .ifdef MUSIC_ENABLE
  jsr sound_update
  .endif
  
  .ifdef LEVEL_SELECTOR_ENABLED
  lda buffer_controller+buttons::_select
  and #%00000011
  cmp #%00000001
  bne select_button_not_hit
  
  ;increment the starting level counter
  inc state_control_params+title_stateControl::starting_level
  
  ;make sure the level number is always valid
  lda state_control_params+title_stateControl::starting_level
  cmp #num_levels
  bne do_not_reset_starting_level
  lda #0
  sta state_control_params+title_stateControl::starting_level
do_not_reset_starting_level:
  
  jsr create_selected_level_string
  
select_button_not_hit:
  .endif
  
  lda buffer_controller+buttons::_start
  and #1
  beq start_button_not_hit

  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif

  ;create dynamic palette from rom palette
  lda title_definition+title::palette_address
  sta w0
  lda title_definition+title::palette_address+1
  sta w0+1

  ; lda #<slide1
  ; sta w2
  ; lda #>slide1
  ; sta w2+1

  ; jsr ppu_show_slide

  ; lda #<slide2
  ; sta w2
  ; lda #>slide2
  ; sta w2+1

  ; jsr ppu_show_slide

  jsr fade_out_palette

  ;****************************************************************
  ;Set initial game state, such as what level to start on and
  ;how many lives Nomolos has. Switch to the level in state.
  ;****************************************************************

  ;start was pressed, now we want to switch to level in state
  ;set current level and switch to "level in" state
  ;start out Nomolos with 3 lives.
  lda #nomolos_starting_lives
  sta nomolos_status_lives
  .ifdef LEVEL_SELECTOR_ENABLED
  lda state_control_params+title_stateControl::starting_level
  .else
  lda #starting_level
  .endif
  sta level_current
  lda #0
  sta state_control_params+level_in_state_control::use_restart_point
  lda #LEVELINSTATE_INIT
  sta state_control_params+level_in_state_control::state
  ldx #index_level_in_state
  jsr switch_state

start_button_not_hit:

  inc nmi_counter

  jmp stateCommandComplete

stateCommandComplete:

  rts
.endproc

.proc title_state_update_ppu

  lda nmi_counter
  beq nmi_counter_zero

  .ifdef MUSIC_ENABLE
  jsr sound_upload
  .endif
  
  .ifdef LEVEL_SELECTOR_ENABLED
  jsr display_selected_level_string
  
  lda #0
  sta $2005
  sta $2005
  .endif
  
  dec nmi_counter
  
nmi_counter_zero:
  
  rts
.endproc
