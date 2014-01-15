.include "flags.inc"
.include "soundengine.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixed_bank_data.inc"
.include "camera.inc"
.include "nomolos_logic.inc"
.include "play_level_state.inc"
.include "map.inc"
.include "sprite.inc"
.include "entity.inc"
.include "zp.inc"
.include "ram.inc"
.include "load_level_state.inc"
.include "statemanager.inc"

.segment "CODE"

;returns start x coordinate for Nomolos in accumulator
.proc get_restart_x

  lda state_control_params+load_level_stateControl::use_restart_point
  bne use_restart_point
use_start_point:
  ldy #level_data_struct::nomolos_start_x
  lda (base_address_rom_definition_table),y
  sta restart_x
  
  rts
use_restart_point:
  lda restart_x

  rts
.endproc

;return start y coordinate for Nomolos in accumulator
.proc get_restart_y

  lda state_control_params+load_level_stateControl::use_restart_point
  bne use_restart_point
use_start_point:
  ldy #level_data_struct::nomolos_start_y
  lda (base_address_rom_definition_table),y
  sta restart_y
  
  rts
use_restart_point:
  lda restart_y
  rts
.endproc

;return restart screen in accmulator
.proc get_restart_screen

  lda state_control_params+load_level_stateControl::use_restart_point
  bne use_restart_point
use_start_point:
  ldy #level_data_struct::starting_screen
  lda (base_address_rom_definition_table),y
  sta restart_screen
  
  rts
use_restart_point:
  lda restart_screen
  rts
.endproc

.proc load_level_state_update
  lda state_control_params+load_level_stateControl::state
  cmp #LOADLEVELSTATE_INIT
  beq load_level_stateInit
  cmp #LOADLEVELSTATE_LOAD
  beq load_level_stateLoad
  cmp #LOADLEVELSTATE_DONE
  beq load_level_stateDone

load_level_stateInit:

  jmp load_level_stateInit_handler

load_level_stateLoad:

  ;left side is always right where the scroll is.
  jsr map_decode_left_side

  ;directly upload everything to ppu
  jsr map_update_column_ppu
  jsr map_update_attribute_ppu

  ;move camera_scroll_x along
  clc
  lda camera_scroll_x
  adc #$10
  sta camera_scroll_x
  lda camera_scroll_x+1
  adc #$00
  sta camera_scroll_x+1

  ;decrement the column counter until zero
  dec state_control_params+load_level_stateControl::column_counter
  bne load_state_not_done

  lda #LOADLEVELSTATE_DONE
  sta state_control_params+load_level_stateControl::state

load_state_not_done:

  rts

load_level_stateDone:

  ;set camera scroll at starting screen
  lda #0
  sta camera_scroll_x
  jsr get_restart_screen
  sta camera_scroll_x+1

  ;re-decode the left most column to ensure the correct nametable is being shown.
  
  ;left side is always right where the scroll is.
  jsr map_decode_left_side

  ;directly upload everything to ppu
  jsr map_update_column_ppu
  jsr map_update_attribute_ppu
  
  ;switch to play level state.
  ;keep any new entities positioned where they need to be
  ;switch to the actor and entity bank
  ldy #level_data_struct::nomolos_entity_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  jsr entity_update_all

  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta music_bank
  sta mapper_bank_next
  jsr mapper_switch_bank

  ldy #level_data_struct::cycling_palette_address
  lda (base_address_rom_definition_table),y
  sta state_control_params+play_level_state_control::cycling_palette_address
  iny
  lda (base_address_rom_definition_table),y
  sta state_control_params+play_level_state_control::cycling_palette_address+1

  lda #0
  sta state_control_params+play_level_state_control::palette_cycle_index

  ldy #level_data_struct::cycling_palette_speed
  lda (base_address_rom_definition_table),y
  sta state_control_params+play_level_state_control::cycling_palette_speed
  sta state_control_params+play_level_state_control::palette_cycle_counter

  ;****************************************************************
  ;Wait for vblank, reset VRAM and scroll registers, turn
  ;graphics back on, then fade in the current palette.
  ;****************************************************************
  wait_vblank

  jsr map_update_scroll_ppu

  ;turn on sprites and background
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  lda #PLAYLEVELSTATE_INIT
  sta state_control_params+play_level_state_control::state

  ldx #index_play_level_state
  jsr switch_state

  rts

load_level_stateInit_handler:

  ;****************************************************************
  ;Install nmi routine for this state
  ;****************************************************************
  lda #<ppu_blank_nmi
  sta update_ppu
  lda #>ppu_blank_nmi
  sta update_ppu+1

  ;****************************************************************
  ;Wait for vblank, then turn off all graphics.
  ;****************************************************************

  ;wait for vblank so we can turn off graphics, switch chr banks without graphical glitches
  wait_vblank

  ;turn off inc32 for loading palette
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  ;load background from vram $0000
  clear_ppu_2000_bit PPU0_BACKGROUND_PATTERN_TABLE_ADDRESS
  ;load sprites from vram $1000
  set_ppu_2000_bit PPU0_SPRITE_PATTERN_TABLE_ADDRESS

  ;turn off sprites and background while loading level
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  lda state_control_params+load_level_stateControl::level_to_load
  ;multiply accumulator by 2
  asl
  ;transfer to x for indexing
  tax

  ;Load location of the rom definition table for this level
  lda level_definition_table+level::level_data_table,x
  sta base_address_rom_definition_table
  lda level_definition_table+level::level_data_table+1,x
  sta base_address_rom_definition_table+1

  ;first bank switch to the PRG rom bank containing the level's chr data
  ldy #level_data_struct::level_patterns_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;now load the address of the chr data from the level definition table
  ldy #level_data_struct::level_patterns_address
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  ;load the chr data into vram
  lda #$00
  sta $2006
  sta $2006

  jsr ppu_load_chr_amount

  ;bank switch to the bank containing sprite chr data
  ldy #level_data_struct::sprite_patterns_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;now load the address of the chr data from the level definition table
  ldy #level_data_struct::sprite_patterns_address
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  ;load the chr data into sprite vram
  lda #$10
  sta $2006
  lda #$00
  sta $2006

  jsr entity_load_chr_groups

  ;load PRG bank into $8000
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta music_bank
  sta mapper_bank_next
  jsr mapper_switch_bank

  ldy #level_data_struct::map
  lda (base_address_rom_definition_table),y
  sta base_address_map
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_map+1

  ldy #level_data_struct::map_column_table
  lda (base_address_rom_definition_table),y
  sta base_address_map_column_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_map_column_table+1

  ldy #level_data_struct::attribute_column_table
  lda (base_address_rom_definition_table),y
  sta base_address_attribute_column_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_attribute_column_table+1

  ldy #level_data_struct::meta_tile_column_table
  lda (base_address_rom_definition_table),y
  sta base_address_meta_tile_column_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_meta_tile_column_table+1

  ldy #level_data_struct::meta_tile_table
  lda (base_address_rom_definition_table),y
  sta base_address_meta_tile_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_meta_tile_table+1

  ldy #level_data_struct::entity_definition_table
  lda (base_address_rom_definition_table),y
  sta base_address_entity_definition_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_entity_definition_table+1

  .ifdef MUSIC_ENABLE
  ldy #level_data_struct::music
  lda (base_address_rom_definition_table),y
  sta sound_param_word_1
  iny
  lda (base_address_rom_definition_table),y
  sta sound_param_word_1+1
  jsr song_initialize
  .endif

  ldy #level_data_struct::palette
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  ;load palette faded all the way out
  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  wait_vblank

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1
  jsr ppu_load_palette
  jsr sprite_clear_all
  jsr entity_init_all
  jsr nomolos_init
  jsr camera_reset
  
  ;Load start coordinates for Nomolos.
  jsr get_restart_x
  sta nomolos_map_x+1
  jsr get_restart_screen
  sta nomolos_map_x+2
  jsr get_restart_y
  sta nomolos_map_y+1

  ;turn on inc32 for column drawing
  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  ;set camera scroll at starting screen
  lda #0
  sta camera_scroll_x
  jsr get_restart_screen
  sta camera_scroll_x+1
  
  ;set counter for how many columns to load beyond the leftmost one
  ;we load two screens, primarily to ensure that boss arenas can shake
  ;and show correct tiles, and also to clean up garbage tiles from
  ;previous level
  ldy #level_data_struct::columns_to_load
  lda (base_address_rom_definition_table),y
  sta state_control_params+load_level_stateControl::column_counter

  ;load whether camera scroll is enabled for gameplay
  ldy #level_data_struct::camera_scroll_enabled
  lda (base_address_rom_definition_table),y
  sta camera_scroll_enabled

  ;we say we are scrolling to the left so entities spawn in place with the columns
  lda #$ff
  sta camera_scroll_direction

  lda #LOADLEVELSTATE_LOAD
  sta state_control_params+load_level_stateControl::state

  rts
.endproc
