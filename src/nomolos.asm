.include "constants.inc"
.include "macros.inc"
.include "flags.inc"
.include "structs.inc"
.include "zp.inc"
.include "camera.inc"
.include "nomolosLogic.inc"
.include "loadLevelState.inc"
.include "levelInState.inc"
.include "gameOverState.inc"
.include "titleState.inc"
.include "entity.inc"
.include "sound.inc"
.include "level1.inc"
.include "level2.inc"

.segment "HEADER"
.byte "NES",$1a   ;iNES header
.byte $08         ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $00         ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
.byte $21         ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #2 (UnROM)
.byte $00         ;Rest of Mapper #2 bits (all 0)

.segment "STACK"
.export stack
stack:  .res 256
  
.segment "BSS"
.export sprite
sprite: .res 256

.export entity_instances
entity_instances: .res 256
.export entity_locals
entity_locals: .res 256
.export entity_counters
entity_counters: .res 32

;FamiTracker driver must be included here so its variables come after the sprite
;page and entity page. This avoids clobbering graphics/sound memory.
.ifdef MUSIC_ENABLE
.include "driver.s"
.export ft_enable_channel, ft_disable_channel
.export ft_music_init, ft_music_play
.endif

.segment "CODE"

reset:
  initNES
  clearRAM

  ;lda #GAMEOVERSTATE_INIT
  ;sta state_control_params+gameOverStateControl::state
  ;switchState game_over_state_update, game_over_state_update_ppu
  
  lda #TITLESTATE_INIT
  sta state_control_params+titleStateControl::state
  switchState title_state_update, title_state_update_ppu
  
  ;load current level
  ;lda #0
  ;sta state_control_params+loadLevelStateControl::levelToLoad
  ;lda #LOADLEVELSTATE_INIT
  ;sta state_control_params+loadLevelStateControl::state  
  ;switchState load_level_state_update, load_level_state_update_ppu
  
loop:

  jsr indirect_jsr_update
  
  jmp loop
  
.proc indirect_jsr_update
  jmp (update)
.endproc

vblank:

  pha
  txa
  pha
  tya
  pha
  php
  
  jsr indirect_jsr_update_ppu

  plp
  pla
  tay
  pla
  tax
  pla

irq:
  rti
  
.proc indirect_jsr_update_ppu
  jmp (update_ppu)
.endproc
  
.segment "VECTORS"
  .word vblank
  .word reset
  .word irq