.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "soundengine.inc"
.include "load_level_state.inc"
.include "level_in_state.inc"
.include "continue_end_state.inc"
.include "controller.inc"
.include "map.inc"
.include "sprite.inc"
.include "entity.inc"
.include "camera.inc"
.include "nomolos_logic.inc"
.include "zp.inc"
.include "ram.inc"
.include "play_level_state.inc"
.include "fixed_bank_data.inc"
.include "statemanager.inc"

.segment "CODE"

;initializes boss mode by swapping out usual nmi routine with boss nmi routine
;and changes the current play state to PLAYLEVELSTATE_BOSSMODE.
.proc play_level_state_init_boss_mode

  ;switch to boss nmi routine
  lda #<play_level_state_update_boss_ppu
  sta update_ppu
  lda #>play_level_state_update_boss_ppu
  sta update_ppu+1
  
  ;make sure the boss ppu routine doesn't start uploading bogus rectangles
  lda #0
  sta buffer_rectangle_width
  sta buffer_rectangle_height
  
  ;make sure the boss ppu routine doesn't upload dynamic palette right away
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  ;switch to boss mode
  lda #PLAYLEVELSTATE_BOSSMODE
  sta state_control_params+play_level_state_control::state

  rts
.endproc

;initializes victory mode by changing the state param of
;the play level state and starts playing victory music located
;in the fixed bank
.proc play_level_state_init_victory_mode

  lda #PLAYLEVELSTATE_VICTORYMODE
  sta state_control_params+play_level_state_control::state

  ;load victory music
.ifdef MUSIC_ENABLE
  lda #<victory_music
  sta sound_param_word_1
  lda #>victory_music
  sta sound_param_word_1+1
  jsr song_initialize
.endif

  ;clear buttons we don't want to respond to during victory mode.
  lda #%00000010
  sta buffer_controller+buttons::_a
  sta buffer_controller+buttons::_b
  sta buffer_controller+buttons::_left
  sta buffer_controller+buttons::_right

  ;load a frame count
  lda #90
  sta state_control_params+play_level_state_control::frame_counter
  lda #4
  sta state_control_params+play_level_state_control::frame_counter+1
  
  rts
.endproc

.proc play_level_state_update

  lda state_control_params+play_level_state_control::state
  cmp #PLAYLEVELSTATE_INIT
  beq play_level_state_init
  cmp #PLAYLEVELSTATE_KEEPPLAYING
  beq keep_playing
  cmp #PLAYLEVELSTATE_BOSSMODE
  beq playBoss
  cmp #PLAYLEVELSTATE_PAUSE
  beq pause
  cmp #PLAYLEVELSTATE_SWITCHTOLEVELINSTATE
  beq switch_to_level_in_state
  cmp #PLAYLEVELSTATE_VICTORYMODE
  beq victory_mode

play_level_state_init:

  ;****************************************************************
  ;Fade in the palette, then switch to the play level state.
  ;****************************************************************

  lda #0
  sta nmi_counter
  
  ;perform one iteration of the gameplay loop to get sprites onto the screen
  ;before fade-in
  jsr keep_playing_state

  ;fade in the palette
  ldy #level_data_struct::palette
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  jsr fade_in_palette

  ;switch to the play state
  lda #PLAYLEVELSTATE_KEEPPLAYING
  sta state_control_params+play_level_state_control::state

  jmp state_switch_complete

keep_playing:

  ;****************************************************************
  ;Call the play level state handler
  ;****************************************************************

  jsr keep_playing_state

  jmp state_switch_complete

playBoss:

  ;****************************************************************
  ;Call the play boss state handler
  ;****************************************************************

  jsr boss_state
  
  jmp state_switch_complete
  
victory_mode:

  ;****************************************************************
  ;Call the victory mode state handler
  ;****************************************************************

  jsr victory_state
  
  jmp state_switch_complete
  
pause:

: lda nmi_counter
  beq :-
 
  jsr controller_read_start

  .scope
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #1
  bne skip_start_button_test

  lda #PLAYLEVELSTATE_KEEPPLAYING
  sta state_control_params+play_level_state_control::state

skip_start_button_test:
  .endscope

  inc nmi_counter
  
  jmp state_switch_complete

switch_to_level_in_state:

  ;****************************************************************
  ;Fade out the palette then switch to game over or level intro
  ;****************************************************************

  ;stop all sound
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif
  
  ldy #level_data_struct::palette
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  jsr fade_out_palette

  lda nomolos_status_lives

  bmi lives_negative_means_game_over

  lda state_control_params+play_level_state_control::use_restart_point
  sta state_control_params+level_in_state_control::use_restart_point
  lda #LEVELINSTATE_INIT
  sta state_control_params+level_in_state_control::state
  ldx #index_level_in_state
  jsr switch_state
  jmp state_switch_complete

lives_negative_means_game_over:

  lda #CONTINUEENDSTATE_INIT
  sta state_control_params+continue_end_state_control::state
  ldx #index_continue_end_state
  jsr switch_state

state_switch_complete:

  rts

.endproc

;****************************************************************
;The play level state handler
;****************************************************************
.proc keep_playing_state

  ;wait til ppu data has been consumed
: lda nmi_counter
  bne :-

  ;turn monochrome bit on
  .ifdef DISPLAY_FRAME_CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  ;camera has not scrolled yet
  lda #0
  sta camera_scroll_direction

  jsr controller_read

  jsr sprite_clear_all

  jsr nomolos_update
  jsr nomolos_draw
  jsr nomolos_draw_hearts
  jsr entity_update_all
  jsr map_decode

  ;switch to the level and music bank
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  .ifdef MUSIC_ENABLE
  jsr sound_update
  .endif

  .scope
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #1
  bne skip_start_button_test

  lda #PLAYLEVELSTATE_PAUSE
  sta state_control_params+play_level_state_control::state

skip_start_button_test:
  .endscope

  ;indicate to the nmi that data must be consumed now
  inc nmi_counter
  
  ;turn monochrome bit off
  .ifdef DISPLAY_FRAME_CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif
  
  rts

.endproc

;****************************************************************
;The victory mode state handler
;****************************************************************
.proc victory_state

  ;wait for nmi to reset counter
: lda nmi_counter
  bne :-

  ;turn monochrome bit on
  .ifdef DISPLAY_FRAME_CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif
  
  sec
  lda state_control_params+play_level_state_control::frame_counter
  sbc #1
  sta state_control_params+play_level_state_control::frame_counter
  lda state_control_params+play_level_state_control::frame_counter+1
  sbc #0
  sta state_control_params+play_level_state_control::frame_counter+1
  bne do_not_switch_to_level_in_state
  
  lda #0
  sta state_control_params+play_level_state_control::use_restart_point
  ldy #level_data_struct::next_level
  lda (base_address_rom_definition_table),y
  sta level_current
  lda #PLAYLEVELSTATE_SWITCHTOLEVELINSTATE
  sta state_control_params+play_level_state_control::state
  
do_not_switch_to_level_in_state:

  ;camera has not scrolled yet
  lda #0
  sta camera_scroll_direction

  jsr sprite_clear_all

  jsr nomolos_update
  jsr nomolos_draw
  jsr nomolos_draw_hearts
  jsr entity_update_all

  .ifdef MUSIC_ENABLE
  ;switch to the level and music bank
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  jsr sound_update
  .endif

  .scope
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #1
  bne skip_start_button_test

  lda #PLAYLEVELSTATE_PAUSE
  sta state_control_params+play_level_state_control::state

skip_start_button_test:
  .endscope

  ;indicate to nmi that data has been prepared
  inc nmi_counter
  
  ;turn monochrome bit off
  .ifdef DISPLAY_FRAME_CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif
  
  rts

.endproc

;****************************************************************
;The play boss state handler
;****************************************************************
.proc boss_state

  ;wait for nmi to reset counter
: lda nmi_counter
  bne :-

  ;turn monochrome bit on
  .ifdef DISPLAY_FRAME_CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  ;camera has not scrolled yet
  lda #0
  sta camera_scroll_direction

  jsr controller_read

  jsr sprite_clear_all

  jsr nomolos_update
  jsr nomolos_draw
  jsr nomolos_draw_hearts
  jsr entity_update_all

  .ifdef MUSIC_ENABLE
  ;switch to the level and music bank
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  jsr sound_update
  .endif

  .scope
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #1
  bne skip_start_button_test

  lda #PLAYLEVELSTATE_PAUSE
  sta state_control_params+play_level_state_control::state

skip_start_button_test:
  .endscope

  inc nmi_counter
  
  ;turn monochrome bit off
  .ifdef DISPLAY_FRAME_CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif
  
  rts
 
.endproc

;****************************************************************
;The play level state ppu routine
;****************************************************************
.proc play_level_state_update_ppu

  pha
  tya
  pha
  txa
  pha

  lda nmi_counter
  beq nmi_counter_zero
  
  jsr palette_handler
  jsr sprite_update_all
  jsr map_update_column_ppu
  jsr map_update_attribute_ppu
  jsr map_update_scroll_ppu

  .ifdef MUSIC_ENABLE
  jsr sound_upload
  .endif
  
  dec nmi_counter
nmi_counter_zero:

  pla
  tax
  pla
  tay
  pla

  rts
.endproc

;****************************************************************
;Special routine for handling palette cycling if it is present
;in current level
;****************************************************************
.proc palette_handler

  .scope palette_cycling_block
cycling_palette_address = state_control_params+play_level_state_control::cycling_palette_address
cycling_palette_speed = state_control_params+play_level_state_control::cycling_palette_speed
palette_cycle_index = state_control_params+play_level_state_control::palette_cycle_index
palette_cycle_counter = state_control_params+play_level_state_control::palette_cycle_counter

  ;if upper byte of cycling palette address is zero, this level does not do palette cycling
  lda cycling_palette_address+1
  beq palette_cycling_off

  ;get cycling palette address
  lda cycling_palette_address
  sta w0
  lda cycling_palette_address+1
  sta w0+1

  ;get number of palettes in this cycling palette
  ldy #0
  lda (w0),y

  ;compare to palette_cycle_index, reset to zero if it is equal
  cmp palette_cycle_index
  bne do_not_reset_palette_cycle_index

  lda #0
  sta palette_cycle_index

do_not_reset_palette_cycle_index:

  ;now calculate offset of palette to read
  lda palette_cycle_index
  asl
  asl
  asl
  asl

  ;add this offset to w0
  clc
  adc w0
  sta w0
  lda w0+1
  adc #0
  sta w0+1

  ;add 1 to w0
  clc
  lda w0
  adc #1
  sta w0
  lda w0+1
  adc #0
  sta w0+1

  ;w0 should now point to correct palette, I hope
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  jsr ppu_load_palette_bg

  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  dec palette_cycle_counter
  bne do_not_increment_cycle_index

  inc palette_cycle_index

  lda cycling_palette_speed
  sta palette_cycle_counter

do_not_increment_cycle_index:

palette_cycling_off:

  .endscope
  rts

.endproc

;****************************************************************
;The play level state boss ppu routine
;****************************************************************
.proc play_level_state_update_boss_ppu

  pha
  tya
  pha
  txa
  pha

  lda nmi_counter
  beq nmi_counter_zero

  jsr sprite_update_all
  
  ;turn off inc32
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000
  
  lda state_control_params+play_level_state_control::upload_ppu_data
  cmp #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  beq upload_dynamic_palette
  cmp #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  beq upload_rectangular_region

upload_dynamic_palette:
  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1
  
  jsr ppu_load_palette
  
  ;turn on inc32
  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000
  
  jmp upload_ppu_data_switch_complete
  
upload_rectangular_region:

  jsr ppu_upload_rectangular_region

upload_ppu_data_switch_complete:
  
  jsr map_update_scroll_ppu

  .ifdef MUSIC_ENABLE
  jsr sound_upload
  .endif

  dec nmi_counter
  
nmi_counter_zero:

  pla
  tax
  pla
  tay
  pla

  rts
.endproc
