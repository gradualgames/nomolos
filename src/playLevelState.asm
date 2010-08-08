.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "soundengine.inc"
.include "loadLevelState.inc"
.include "sound.inc"
.include "levelInState.inc"
.include "gameOverState.inc"
.include "controller.inc"
.include "map.inc"
.include "sprite.inc"
.include "entity.inc"
.include "camera.inc"
.include "nomolosLogic.inc"
.include "zp.inc"
.include "ram.inc"
.include "playLevelState.inc"
.include "fixedBankData.inc"
.include "statemanager.inc"

.segment "CODE"

.proc play_level_state_update

  lda state_control_params+playLevelStateControl::state
  cmp #PLAYLEVELSTATE_INIT
  beq playLevelStateInit
  cmp #PLAYLEVELSTATE_KEEPPLAYING
  beq keepPlaying
  cmp #PLAYLEVELSTATE_PAUSE
  beq pause
  cmp #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  beq switchToLevelOutState

playLevelStateInit:

  ;****************************************************************
  ;Fade in the palette, then switch to the play level state.
  ;****************************************************************
  
  ;perform one iteration of the gameplay loop to get sprites onto the screen
  ;before fade-in
  jsr keep_playing_state

  ;fade in the palette
  ldy #ROMDefinitionTableStruct::palette
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1
  
  jsr fade_in_palette

  ;switch to the play state
  lda #PLAYLEVELSTATE_KEEPPLAYING
  sta state_control_params+playLevelStateControl::state
  
  jmp stateCommandComplete
  
keepPlaying:

  ;****************************************************************
  ;Call the play level state handler
  ;****************************************************************

  jsr keep_playing_state

  jmp stateCommandComplete
  
pause:
 
  jsr controller_read_start
 
  .scope
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #1
  bne skipStartButtonTest
  
  lda #PLAYLEVELSTATE_KEEPPLAYING
  sta state_control_params+playLevelStateControl::state
  
skipStartButtonTest:
  .endscope
 
  jmp stateCommandComplete
  
switchToLevelOutState:

  ;****************************************************************
  ;Fade out the palette then switch to game over or level outro
  ;****************************************************************

  ldy #ROMDefinitionTableStruct::palette
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  jsr fade_out_palette

  lda nomolos_status_lives
  
  bmi livesNegativeMeansGameOver
  
  lda #LEVELINSTATE_INIT
  sta state_control_params+levelInStateControl::state
  ldx #index_level_in_state
  jsr switch_state
  jmp stateCommandComplete
  
livesNegativeMeansGameOver:

  lda #GAMEOVERSTATE_INIT
  sta state_control_params+gameOverStateControl::state
  ldx #index_game_over_state
  jsr switch_state
  
stateCommandComplete:
    
  ;turn monochrome bit off
  .ifdef DISPLAY_FRAME_CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif
    
  rts
  
.endproc

;****************************************************************
;The play level state handler
;****************************************************************
.proc keep_playing_state

  ;wait for vblank to complete
  lda #0
  sta vblank_done
: lda vblank_done
  beq :-

  ;turn monochrome bit on
  .ifdef DISPLAY_FRAME_CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif
  
  ;ppu data is not ready
  lda #0
  sta ppu_data_ready
  
  ;camera has not scrolled yet
  sta camera_scroll_direction
  
  jsr controller_read
  
  jsr sprite_clear_all
  
  jsr nomolos_update
  jsr nomolos_draw
  jsr nomolos_draw_hearts
  jsr entity_update_all
  jsr map_decode

  ;ppu data is ready
  lda #1
  sta ppu_data_ready
  
  .ifdef MUSIC_ENABLE
  ;switch to the level and music bank
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  jsr sound_update
  .endif

  .scope
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #1
  bne skipStartButtonTest
  
  lda #PLAYLEVELSTATE_PAUSE
  sta state_control_params+playLevelStateControl::state
  
skipStartButtonTest:
  .endscope
  
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
  
  lda ppu_data_ready
  beq ppu_data_not_ready
  
  jsr palette_handler
  jsr sprite_update_all
  jsr map_update_column_ppu
  jsr map_update_attribute_ppu
  jsr map_update_scroll_ppu
  
  .ifdef MUSIC_ENABLE
  jsr sound_upload
  .endif
  
ppu_data_not_ready:
  
  lda #1
  sta vblank_done
  
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
cycling_palette_address = state_control_params+playLevelStateControl::cycling_palette_address
cycling_palette_speed = state_control_params+playLevelStateControl::cycling_palette_speed
palette_cycle_index = state_control_params+playLevelStateControl::palette_cycle_index
palette_cycle_counter = state_control_params+playLevelStateControl::palette_cycle_counter

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
