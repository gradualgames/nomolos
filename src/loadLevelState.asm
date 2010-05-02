.include "macros.inc"
.include "constants.inc"
.include "structs.inc"
.include "flags.inc"
.include "famitracker.inc"
.include "sound.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "levelDataIndex.inc"
.include "camera.inc"
.include "nomolosLogic.inc"
.include "playLevelState.inc"
.include "map.inc"
.include "sprite.inc"
.include "entity.inc"
.include "zp.inc"

.segment "CODE"

.export load_level_state_update
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

  lda state_control_params+loadLevelStateControl::levelToLoad
  ;multiply accumulator by 8
  asl
  asl
  asl
  ;transfer to x for indexing
  tax
  
  ;wait for vblank so we can turn off graphics, switch chr banks without graphical glitches
  waitVBlank
  
  ;turn off NMI, inc32 (for loading palette)
  lda #( ( 0 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  
  ;turn off sprites and bg
  lda #( ( 0 << PPU1_SPRITE_VISIBILITY ) | ( 0 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  ;load CHR bank into $0000
  
  ;first bank switch to the PRG rom bank containing the level's chr data
  lda level_definition_table+level::chrPrgRomBank,x
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;now load the address of the chr data from the level definition table
  lda level_definition_table+level::chrAddress,x
  sta w0
  inx
  lda level_definition_table+level::chrAddress,x
  dex
  sta w0+1
  
  ;load the chr data into vram
  jsr ppu_load_chr
  
  ;load PRG bank into $8000
  lda level_definition_table+level::prgRomBank,x
  sta mapper_bank_next
  jsr mapper_switch_bank

  lda level_definition_table+level::romDefinitionTable,x
  sta base_address_rom_definition_table
  lda level_definition_table+level::romDefinitionTable+1,x
  sta base_address_rom_definition_table+1

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
  
  ;.ifdef MUSIC_ENABLE
  ; ldy #ROMDefinitionTableStruct::music
  ; lda (base_address_rom_definition_table),y
  ; sta ft_music_addr
  ; iny
  ; lda (base_address_rom_definition_table),y
  ; sta ft_music_addr+1
  ; .endif
  
  ;jsr sound_init
  
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

  ;turn on inc32
  lda #( ( 0 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  
  ; ;initialize music driver as NTSC and track #0.
; .ifdef MUSIC_ENABLE
  ; lda #0
  ; ldx #0
  ; jsr ft_music_init
; .endif
  
  lda #0
  sta camera_scroll_x
  sta camera_scroll_x+1
  
  lda #LOADLEVELSTATE_LOAD
  sta state_control_params+loadLevelStateControl::state
    
  jmp stateSwitchComplete
  
loadLevelStateLoad:

  ;decode a column at the current scrollX.
meta_tile_column_index = w0
  
  ;compute meta tile column index from camera_scroll_x by dividing by 16, or shifting right by 4.
  lda camera_scroll_x
  sta meta_tile_column_index
  lda camera_scroll_x+1
  sta meta_tile_column_index+1
  
  lda meta_tile_column_index
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  sta meta_tile_column_index
  
  ;now meta_tile_column_index is the correct value for the map column decoder
  lda meta_tile_column_index
  sta w1
  lda meta_tile_column_index+1
  sta w1+1
  
  lda #$20
  sta name_table_to_update
  lda #$20
  sta name_table_to_view
  
  ;compute attribute column to update based on the meta tile column index
  lda meta_tile_column_index
  lsr
  and #%00000111
  sta attribute_column_to_update
  
  ;compute column to update based on meta_tile_column_index
  lda meta_tile_column_index
  asl
  and #%00011111
  sta column_to_update
  
  ;we say we are scrolling to the left so entities spawn in place with the columns
  lda #$ff
  sta camera_scroll_direction
  
  jsr map_decode_column
  
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
  
  beq load_state_not_done
  
  lda #LOADLEVELSTATE_DONE
  sta state_control_params+loadLevelStateControl::state

load_state_not_done:
  
  jmp stateSwitchComplete


loadLevelStateDone:

  lda #0
  sta camera_scroll_x
  sta camera_scroll_x+1

  ;switch to play level state.  
  ;keep any new entities positioned where they need to be
  ;switch to the actor and entity bank
  ldy #ROMDefinitionTableStruct::NomolosAndEntityBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  jsr entity_update_all
  
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  lda #PLAYLEVELSTATE_KEEPPLAYING
  sta state_control_params+playLevelStateControl::state
  
  switchState play_level_state_update, play_level_state_update_ppu
      
  waitVBlank

  ;reset scroll
  lda #0
  sta $2005
  sta $2005

  ;turn rendering on
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
   
  lda #( ( 1 << PPU1_SPRITE_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001

  jmp stateSwitchComplete
  
stateSwitchComplete:

  rts
.endproc

.export load_level_state_update_ppu
.proc load_level_state_update_ppu

  ;lda #$20
  ;sta $2006
  ;lda #0
  ;sta $2006
  ;lda #0
  ;sta $2005
  ;sta $2005

  rts  
.endproc
