.include "constants.inc"
.include "macros.inc"
.include "flags.inc"
.include "structs.inc"
.include "zp.inc"
.include "camera.inc"
.include "nomolosLogic.inc"
.include "loadLevelState.inc"
.include "levelInState.inc"
.include "titleState.inc"
.include "entity.inc"
.include "sound.inc"
.include "level1.inc"
.include "level2.inc"

.segment "HEADER"
.byte "NES",$1a        ;iNES header
.byte $08 ;            ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $00 ;            ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
.byte $21 ;            ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #2 (UnROM)
.byte $00 ;            ;Rest of Mapper #2 bits (all 0)
.byte 0,0,0,0,0,0,0,0  ; pad header to 16 bytes

.segment "STACK"
.export stack
stack:  .res 256
  
.segment "BSS"
.export sprite
sprite: .res 256

.export entityPool
entityPool: .res 256

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

  lda #TITLESTATE_INIT
  sta stateControl+titleStateControl::state
  switchState titleStateUpdate, titleStateUpdatePPU
  
loop:

  jsr indirectJsrUpdate
  
  jmp loop
  
.proc indirectJsrUpdate
  jmp (update)
.endproc

vblank:

  pha
  txa
  pha
  tya
  pha
  php
  
  jsr indirectJsrUpdatePPU

  plp
  pla
  tay
  pla
  tax
  pla

irq:
  rti
  
.proc indirectJsrUpdatePPU
  jmp (updatePPU)
.endproc
  
.segment "VECTORS"
  .word vblank
  .word reset
  .word irq