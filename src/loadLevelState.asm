.include "macros.inc"
.include "flags.inc"
.include "soundengine.inc"
.include "sound.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixedBankData.inc"
.include "camera.inc"
.include "nomolosLogic.inc"
.include "playLevelState.inc"
.include "map.inc"
.include "sprite.inc"
.include "entity.inc"
.include "zp.inc"
.include "loadLevelState.inc"

.segment "CODE"

.proc load_level_state_update
  lda state_control_params+loadLevelStateControl::state
  cmp #LOADLEVELSTATE_INIT
  beq loadLevelStateInit
  cmp #LOADLEVELSTATE_LOAD
  bne :+
  jmp loadLevelStateLoad
:
  cmp #LOADLEVELSTATE_DONE
  bne :+
  jmp loadLevelStateDone
:
  
loadLevelStateInit:

  ;wait for vblank so we can turn off graphics, switch chr banks without graphical glitches
  waitVBlank
  
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

  lda state_control_params+loadLevelStateControl::levelToLoad
  ;multiply accumulator by 2
  asl
  ;transfer to x for indexing
  tax
  
  ;Load location of the rom definition table for this level
  lda level_definition_table+level::romDefinitionTable,x
  sta base_address_rom_definition_table
  lda level_definition_table+level::romDefinitionTable+1,x
  sta base_address_rom_definition_table+1
  
  ;first bank switch to the PRG rom bank containing the level's chr data
  ldy #ROMDefinitionTableStruct::LevelPatternsBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;now load the address of the chr data from the level definition table
  ldy #ROMDefinitionTableStruct::LevelPatternsAddress
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
  ldy #ROMDefinitionTableStruct::SpritePatternsBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;now load the address of the chr data from the level definition table
  ldy #ROMDefinitionTableStruct::SpritePatternsAddress
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
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  ldy #ROMDefinitionTableStruct::map
  lda (base_address_rom_definition_table),y
  sta base_address_map
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_map+1
  
  ldy #ROMDefinitionTableStruct::map_column_table
  lda (base_address_rom_definition_table),y
  sta base_address_map_column_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_map_column_table+1
  
  ldy #ROMDefinitionTableStruct::attribute_column_table
  lda (base_address_rom_definition_table),y
  sta base_address_attribute_column_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_attribute_column_table+1
  
  ldy #ROMDefinitionTableStruct::meta_tile_column_table
  lda (base_address_rom_definition_table),y
  sta base_address_meta_tile_column_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_meta_tile_column_table+1
  
  ldy #ROMDefinitionTableStruct::meta_tile_table
  lda (base_address_rom_definition_table),y
  sta base_address_meta_tile_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_meta_tile_table+1
  
  ldy #ROMDefinitionTableStruct::EntityDefinitionTable
  lda (base_address_rom_definition_table),y
  sta base_address_entity_definition_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_entity_definition_table+1
  
  .ifdef MUSIC_ENABLE
  ldy #ROMDefinitionTableStruct::music
  lda (base_address_rom_definition_table),y
  sta sound_param_word_1
  iny
  lda (base_address_rom_definition_table),y
  sta sound_param_word_1+1
  jsr song_initialize
  .endif
  
  ldy #ROMDefinitionTableStruct::palette
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  waitVBlank
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
  ldy #ROMDefinitionTableStruct::starting_screen
  lda (base_address_rom_definition_table),y
  sta camera_scroll_x+1
  
  ;we say we are scrolling to the left so entities spawn in place with the columns
  lda #$ff
  sta camera_scroll_direction
  
  lda #LOADLEVELSTATE_LOAD
  sta state_control_params+loadLevelStateControl::state
    
  jmp stateSwitchComplete
  
loadLevelStateLoad:
  
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
  sta state_control_params+loadLevelStateControl::state

load_state_not_done:
  
  jmp stateSwitchComplete

loadLevelStateDone:

  ;set camera scroll at starting screen
  lda #0
  sta camera_scroll_x
  ldy #ROMDefinitionTableStruct::starting_screen
  lda (base_address_rom_definition_table),y
  sta camera_scroll_x+1

  ;switch to play level state.  
  ;keep any new entities positioned where they need to be
  ;switch to the actor and entity bank
  ldy #ROMDefinitionTableStruct::NomolosAndEntityBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;jsr entity_update_all
  
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ldy #ROMDefinitionTableStruct::CyclingPaletteAddress
  lda (base_address_rom_definition_table),y
  sta state_control_params+playLevelStateControl::cycling_palette_address
  iny
  lda (base_address_rom_definition_table),y
  sta state_control_params+playLevelStateControl::cycling_palette_address+1
  
  lda #0
  sta state_control_params+playLevelStateControl::palette_cycle_index
  
  ldy #ROMDefinitionTableStruct::CyclingPaletteSpeed
  lda (base_address_rom_definition_table),y
  sta state_control_params+playLevelStateControl::cycling_palette_speed
  sta state_control_params+playLevelStateControl::palette_cycle_counter
  
  lda #PLAYLEVELSTATE_KEEPPLAYING
  sta state_control_params+playLevelStateControl::state
  
  switchState play_level_state_update, play_level_state_update_ppu
      
  waitVBlank
  
  jsr map_update_scroll_ppu

  set_ppu_2000_bit PPU0_EXECUTE_NMI
  upload_ppu_2000
     
  ;turn on sprites and background
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  jmp stateSwitchComplete
  
stateSwitchComplete:

  rts
.endproc

.proc load_level_state_update_ppu

  rts  
.endproc
