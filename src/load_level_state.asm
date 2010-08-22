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

.proc load_level_state_update
  lda state_control_params+load_level_stateControl::state
  cmp #LOADLEVELSTATE_INIT
  beq load_level_stateInit
  cmp #LOADLEVELSTATE_LOAD
  bne :+
  jmp load_level_stateLoad
:
  cmp #LOADLEVELSTATE_DONE
  bne :+
  jmp load_level_stateDone
:

load_level_stateInit:

  ;****************************************************************
  ;Wait for vblank, then turn off nmi and all graphics.
  ;****************************************************************

  ;wait for vblank so we can turn off graphics, switch chr banks without graphical glitches
  wait_vblank

  ;turn off nmi while loading level
  clear_ppu_2000_bit PPU0_EXECUTE_NMI
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

  lda state_control_params+load_level_stateControl::levelToLoad
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

  jsr ppu_load_chr_groups

  ;load PRG bank into $8000
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
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

  ;turn on inc32 for column drawing
  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  ;set camera scroll at starting screen
  lda #0
  sta camera_scroll_x
  ldy #level_data_struct::starting_screen
  lda (base_address_rom_definition_table),y
  sta camera_scroll_x+1

  ;load whether camera scroll is enabled for gameplay
  ldy #level_data_struct::camera_scroll_enabled
  lda (base_address_rom_definition_table),y
  sta camera_scroll_enabled

  ;we say we are scrolling to the left so entities spawn in place with the columns
  lda #$ff
  sta camera_scroll_direction

  lda #LOADLEVELSTATE_LOAD
  sta state_control_params+load_level_stateControl::state

  jmp stateSwitchComplete

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

  ;if carry is clear here, we haven't finished loading the whole starting screen
  bcc load_state_not_done

  lda #LOADLEVELSTATE_DONE
  sta state_control_params+load_level_stateControl::state

load_state_not_done:

  jmp stateSwitchComplete

load_level_stateDone:

  ;set camera scroll at starting screen
  lda #0
  sta camera_scroll_x
  ldy #level_data_struct::starting_screen
  lda (base_address_rom_definition_table),y
  sta camera_scroll_x+1

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
  ;Wait for vblank, reset VRAM and scroll registers, turn nmi and
  ;graphics back on, then fade in the current palette.
  ;****************************************************************
  wait_vblank

  jsr map_update_scroll_ppu

  ;turn nmi back on
  set_ppu_2000_bit PPU0_EXECUTE_NMI
  upload_ppu_2000

  ;turn on sprites and background
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  lda #PLAYLEVELSTATE_INIT
  sta state_control_params+play_level_state_control::state

  ldx #index_play_level_state
  jsr switch_state

  jmp stateSwitchComplete

stateSwitchComplete:

  rts
.endproc

.proc load_level_state_update_ppu

  rts
.endproc
