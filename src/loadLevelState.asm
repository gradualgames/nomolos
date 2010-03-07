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

  ldy #ROMDefinitionTableStruct::Level
  lda (base_address_rom_definition_table),y
  sta base_address_level
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_level+1

  ldy #ROMDefinitionTableStruct::MetaMetaTileTable
  lda (base_address_rom_definition_table),y
  sta base_address_meta_meta_tile_table
  iny
  lda (base_address_rom_definition_table),y
  sta base_address_meta_meta_tile_table+1

  ldy #ROMDefinitionTableStruct::MetaTileTable
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
  sta ft_music_addr
  iny
  lda (base_address_rom_definition_table),y
  sta ft_music_addr+1
  .endif
  
  jsr sound_init
  
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
  
  ;initialize music driver as NTSC and track #0.
.ifdef MUSIC_ENABLE
  lda #0
  ldx #0
  jsr ft_music_init
.endif
  
  lda #LOADLEVELSTATE_LOAD
  sta state_control_params+loadLevelStateControl::state
  
  jmp stateSwitchComplete
  
loadLevelStateLoad:

  lda #$20
  sta name_table_to_update

  lda column_to_update
  lsr
  tay
  lda (base_address_level),y

  ;store the meta meta tile index as a 16 bit number
  sta w1
  lda #0
  sta w1+1

  ;shift left this number by 4
  ldx #4
:
  asl w1
  rol w1+1
  dex
  bne :-

  ;now add MetaMetaTileTable to this number
  clc
  lda w1
  adc base_address_meta_meta_tile_table
  sta w1
  lda w1+1
  adc base_address_meta_meta_tile_table+1
  sta w1+1

  ;calculate spawnX
  lda column_to_update
  asl
  asl
  asl
  sta w3 ;spawnX
  lda #0
  sta w3+1 ;spawnX+1
  
  lda column_to_update
  jsr map_update_column

  ;rendering is off in this state, so we update the PPU
  jsr sprite_update_all
  jsr map_update_column_ppu
  jsr map_update_attribute_ppu
  jsr map_update_scroll_ppu

  ;move on to next column.
  inc column_to_update
  inc column_to_update
  
  lda column_to_update
  ;have we updated all the columns on the screen yet?
  cmp #32
  bne :+
  
  lda #LOADLEVELSTATE_DONE
  sta state_control_params+playLevelStateControl::state
  
:
  
  jmp stateSwitchComplete

loadLevelStateDone:

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
  
  lda #$24
  sta name_table_to_update  

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
  rts  
.endproc
