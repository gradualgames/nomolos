.include "flags.inc"
.include "structs.inc"
.include "macros.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "famitracker.inc"
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
  sta vblankDone
: lda vblankDone
  beq :-

  ;turn monochrome bit on
  .ifdef DISPLAY_FRAME_CPU_USAGE
  lda #%00011111
  sta $2001
  .endif
  
  jsr readController
  
  jsr sprite_clear_all
  
  jsr nomolos_update
  jsr nomolos_draw
  jsr nomolos_draw_hearts
  jsr entity_update_all
  
  jsr map_decode
    
  lda stateControl+playLevelStateControl::state
  cmp #PLAYLEVELSTATE_SWITCHLEVEL
  beq switchLevel
  cmp #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  beq switchToLevelOutState
  
  jmp stateCommandComplete
  
switchLevel:
  lda stateControl+playLevelStateControl::levelNum
  sta stateControl+loadLevelStateControl::levelToLoad
  lda #LOADLEVELSTATE_INIT
  sta stateControl+loadLevelStateControl::state
  
  switchState load_level_state_update, load_level_state_update_ppu
  
  jmp stateCommandComplete
  
switchToLevelOutState:

  lda #LEVELOUTSTATE_INIT
  sta stateControl+levelOutStateControl::state
  switchState levelOutUpdate, levelOutPPUUpdate
  
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

  jsr sprite_update_all
  jsr map_update_column_ppu
  jsr map_update_attribute_ppu
  jsr map_update_scroll_ppu
  
  .ifdef MUSIC_ENABLE
  ;switch to the level and music bank
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (romDefinitionTableBaseAddress),y
  sta b0
  jsr mapper_switch_bank
  jsr ft_music_play
  .endif
  
  jsr playSound
  
  lda #1
  sta vblankDone
  rts
.endproc
  