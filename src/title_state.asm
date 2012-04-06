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

.proc display_difficulty_string
  set_ppu_2006 $20, 20, 10
  lda #<difficulty_string
  sta w0
  lda #>difficulty_string
  sta w0+1
  
  jsr ppu_display_string

  ldx state_control_params+title_stateControl::difficulty_index
  lda difficulty_table,x
  cmp #EASY_DIFFICULTY
  bne :+
  lda #<easy_string
  sta w0
  lda #>easy_string
  sta w0+1

  jsr ppu_display_string
:
  cmp #NORMAL_DIFFICULTY
  bne :+
  lda #<normal_string
  sta w0
  lda #>normal_string
  sta w0+1

  jsr ppu_display_string
:
  cmp #UNFAIR_DIFFICULTY
  bne :+
  lda #<unfair_string
  sta w0
  lda #>unfair_string
  sta w0+1

  jsr ppu_display_string
:

  rts
.endproc

.proc title_state_update

  lda state_control_params+title_stateControl::state
  cmp #TITLESTATE_LOGO
  bne :+
  jmp  title_state_logo
:
  cmp #TITLESTATE_TITLE
  bne :+
  jmp title_state_title
:
  cmp #TITLESTATE_MENU
  bne :+
  jmp title_state_menu
:

title_state_logo:

  ;****************************************************************
  ;Load the Logo graphic, play the logo music, wait a few frames
  ;****************************************************************

  ;load dynamic palette faded out so that fade in doesn't cause funkiness
  wait_vblank
  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  jsr ppu_load_palette

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta update_ppu
  lda #>ppu_upload_dynamic_palette_ppu
  sta update_ppu+1

  ;load Gradual Games logo
  lda #<gradual_games_logo_slide
  sta w2
  lda #>gradual_games_logo_slide
  sta w2+1

  jsr ppu_load_slide

  ;fade in the slide
  jsr fade_in_palette

  ;play the logo music
.ifdef MUSIC_ENABLE
  lda #<gradual_games_logo_music
  sta sound_param_word_1
  lda #>gradual_games_logo_music
  sta sound_param_word_1+1
  jsr song_initialize
.endif

  ;wait for a few frames
  ldx #120
: lda nmi_counter
  bne :-

  inc nmi_counter
  dex
  bne :-

  ;fade out the palette
  jsr fade_out_palette

  lda #TITLESTATE_TITLE
  sta state_control_params+title_stateControl::state

  rts

title_state_title:

  ;****************************************************************
  ;Initialize variables used by the menu
  ;****************************************************************

  ;reset the level selector counter
  lda #0
  sta state_control_params+title_stateControl::starting_level
  jsr create_selected_level_string
  
  ;reset the difficulty index selector to normal
  lda #NORMAL_DIFFICULTY_INDEX
  sta state_control_params+title_stateControl::difficulty_index

  ;****************************************************************
  ;Load the title screen slide, draw strings, then fade in.
  ;****************************************************************

  lda #<title_slide
  sta w2
  lda #>title_slide
  sta w2+1

  jsr ppu_load_slide

  lda #<ppu_blank_nmi
  sta update_ppu
  lda #>ppu_blank_nmi
  sta update_ppu+1

  wait_vblank
  wait_vblank
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

  set_ppu_2006 $20, 24, 10

  lda #<revision_string
  sta w0
  lda #>revision_string
  sta w0+1

  jsr ppu_display_string

  jsr display_difficulty_string

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

  lda #<title_slide
  sta w2
  lda #>title_slide
  sta w2+1
  ldy #ppu_slide::palette_address
  lda (w2),y
  sta w0
  iny
  lda (w2),y
  sta w0+1

  jsr fade_in_palette

  lda #<title_state_update_ppu
  sta update_ppu
  lda #>title_state_update_ppu
  sta update_ppu+1

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

  lda #TITLESTATE_MENU
  sta state_control_params+title_stateControl::state

  rts

title_state_menu:

: lda nmi_counter
  bne :-

  jsr controller_read
  
  .ifdef MUSIC_ENABLE
  jsr sound_update
  .endif
  
  .scope
  lda buffer_controller+buttons::_up
  and #%00000011
  cmp #%00000001
  bne button_combo_incorrect
  lda buffer_controller+buttons::_a
  beq button_combo_incorrect
  lda buffer_controller+buttons::_b
  beq button_combo_incorrect
  lda buffer_controller+buttons::_select
  beq button_combo_incorrect
  
  ;increment the starting level counter
  inc state_control_params+title_stateControl::starting_level
  
  ;make sure the level number is always valid
  lda state_control_params+title_stateControl::starting_level
  cmp #num_levels
  bne do_not_reset_starting_level
  lda #0
  sta state_control_params+title_stateControl::starting_level
do_not_reset_starting_level:
  
button_combo_incorrect:
  .endscope

  .scope
  lda buffer_controller+buttons::_down
  and #%00000011
  cmp #%00000001
  bne button_combo_incorrect
  lda buffer_controller+buttons::_a
  beq button_combo_incorrect
  lda buffer_controller+buttons::_b
  beq button_combo_incorrect
  lda buffer_controller+buttons::_select
  beq button_combo_incorrect
  
  ;increment the starting level counter
  dec state_control_params+title_stateControl::starting_level
  
  ;make sure the level number is always valid
  lda state_control_params+title_stateControl::starting_level
  cmp #$ff
  bne do_not_reset_starting_level
  lda #(num_levels-1)
  sta state_control_params+title_stateControl::starting_level
do_not_reset_starting_level:
  
button_combo_incorrect:
  .endscope
  
  jsr create_selected_level_string

  ;test left and right buttons if menu selection is "difficulty"
  ;and then increment or decrement the global difficulty value.

  .scope
  lda buffer_controller+buttons::_left
  and #%00000011
  cmp #%00000001
  bne left_button_not_hit

  ;increment the difficulty level but cap at 2
  lda state_control_params+title_stateControl::difficulty_index
  cmp #DIFFICULTY_TABLE_INDEX_MAX
  beq skip_increment_difficulty
  inc state_control_params+title_stateControl::difficulty_index

skip_increment_difficulty:

left_button_not_hit:
  .endscope

  .scope
  lda buffer_controller+buttons::_right
  and #%00000011
  cmp #%00000001
  bne right_button_not_hit

  ;decrement the difficulty level but cap at 0
  lda state_control_params+title_stateControl::difficulty_index
  cmp #DIFFICULTY_TABLE_INDEX_MIN
  beq skip_decrement_difficulty
  dec state_control_params+title_stateControl::difficulty_index

skip_decrement_difficulty:

right_button_not_hit:
  .endscope

  lda buffer_controller+buttons::_start
  and #1
  beq start_button_not_hit

  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif

  jsr show_intro_cut_scene

  ;****************************************************************
  ;Set initial game state, such as what level to start on and
  ;how many lives Nomolos has. Switch to the level in state.
  ;****************************************************************

  ;start was pressed, now we want to switch to level in state
  ;set current level and switch to "level in" state

  ;initialize difficulty based on difficulty table
  ldx state_control_params+title_stateControl::difficulty_index
  lda difficulty_table,x
  sta difficulty

  ;start out Nomolos with 3 lives.
  lda #nomolos_starting_lives
  sta nomolos_status_lives
  lda state_control_params+title_stateControl::starting_level
  sta level_current
  lda #0
  sta state_control_params+level_in_state_control::use_restart_point
  lda #LEVELINSTATE_INIT
  sta state_control_params+level_in_state_control::state
  ldx #index_level_in_state
  jsr switch_state

start_button_not_hit:

  inc nmi_counter

  rts
.endproc

.proc show_intro_cut_scene

  lda #<title_slide
  sta w2
  lda #>title_slide
  sta w2+1
  ldy #ppu_slide::palette_address
  lda (w2),y
  sta w0
  iny
  lda (w2),y
  sta w0+1

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta update_ppu
  lda #>ppu_upload_dynamic_palette_ppu
  sta update_ppu+1

.ifdef MUSIC_ENABLE
  lda #<intro_cut_scene_music
  sta sound_param_word_1
  lda #>intro_cut_scene_music
  sta sound_param_word_1+1
  jsr song_initialize
.endif

  start_escapable_slide_sequence

  ;show some intro cut-scene slides
  show_text_slide_with_escape solomon_snow_watching_birds_slide, skip_intro_cut_scene
  show_graphics_slide_with_escape slide1, skip_intro_cut_scene
  show_text_slide_with_escape portal_appears_slide, skip_intro_cut_scene
  show_graphics_slide_with_escape slide2, skip_intro_cut_scene
  show_text_slide_with_escape arm_snatches_snow_slide, skip_intro_cut_scene
  show_graphics_slide_with_escape slide3, skip_intro_cut_scene
  show_text_slide_with_escape leapt_through_portal_slide, skip_intro_cut_scene
  show_graphics_slide_with_escape slide4, skip_intro_cut_scene
  show_text_slide_with_escape became_nomolos_slide, skip_intro_cut_scene
  show_graphics_slide_with_escape slide5, skip_intro_cut_scene
  show_text_slide_with_escape nomolos_sets_out_slide, skip_intro_cut_scene

skip_intro_cut_scene:

.ifdef MUSIC_ENABLE
  jsr sound_stop
.endif

  jsr fade_out_palette

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
  .endif
  
  jsr display_difficulty_string

  lda #0
  sta $2005
  sta $2005

  dec nmi_counter
  
nmi_counter_zero:
  
  rts
.endproc
