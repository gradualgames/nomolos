.include "flags.inc"
.include "structs.inc"
.include "macros.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "soundengine.inc"
.include "loadLevelState.inc"
.include "sound.inc"
.include "levelOutState.inc"
.include "controller.inc"
.include "map.inc"
.include "sprite.inc"
.include "entity.inc"
.include "camera.inc"
.include "nomolosLogic.inc"
.include "zp.inc"

.segment "CODE"

.export play_level_state_update
.proc play_level_state_update

  ;wait for vblank to complete
  lda #0
  sta vblank_done
: lda vblank_done
  beq :-

  ;turn monochrome bit on
  .ifdef DISPLAY_FRAME_CPU_USAGE
  lda #%00011111
  sta $2001
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
    
  lda state_control_params+playLevelStateControl::state
  cmp #PLAYLEVELSTATE_SWITCHLEVEL
  beq switchLevel
  cmp #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  beq switchToLevelOutState
  
  jmp stateCommandComplete
  
switchLevel:
  lda state_control_params+playLevelStateControl::levelNum
  sta state_control_params+loadLevelStateControl::levelToLoad
  lda #LOADLEVELSTATE_INIT
  sta state_control_params+loadLevelStateControl::state
  
  switchState load_level_state_update, load_level_state_update_ppu
  
  jmp stateCommandComplete
  
switchToLevelOutState:

  lda #LEVELOUTSTATE_INIT
  sta state_control_params+levelOutStateControl::state
  switchState level_out_state_update, level_out_state_update_ppu
  
stateCommandComplete:
    
  ;turn monochrome bit off
  .ifdef DISPLAY_FRAME_CPU_USAGE
  lda #%00011110
  sta $2001
  .endif
    
  rts
.endproc
  
.export play_level_state_update_ppu
.proc play_level_state_update_ppu

  pha
  tya
  pha
  txa
  pha

  lda ppu_data_ready
  beq ppu_data_not_ready
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
  