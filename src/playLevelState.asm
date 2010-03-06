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

.export playLevelUpdate
.proc playLevelUpdate

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
  
  jsr clearSprites
  
  jsr nomolos_update
  jsr nomolos_draw
  jsr nomolos_draw_hearts
  jsr updateEntities
  
  jsr decodeMap
    
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
  
  switchState loadLevelUpdate, loadLevelUpdatePPU
  
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
  
.export playLevelUpdatePPU
.proc playLevelUpdatePPU

  jsr updateSprites
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU
  
  .ifdef MUSIC_ENABLE
  ;switch to the level and music bank
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (romDefinitionTableBaseAddress),y
  sta b0
  jsr bankswitch
  jsr ft_music_play
  .endif
  
  jsr playSound
  
  lda #1
  sta vblankDone
  rts
.endproc
  