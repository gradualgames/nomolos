.include "macros.inc"
.include "flags.inc"
.include "zp.inc"
.include "camera.inc"
.include "nomolosLogic.inc"
.include "loadLevelState.inc"
.include "levelInState.inc"
.include "gameOverState.inc"
.include "titleState.inc"
.include "entity.inc"
.include "soundengine.inc"
.include "level1.inc"
.include "level2.inc"
.include "ppu.inc"

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

.segment "CODE"

reset:
  ;set interrupt disable flag
  sei
  
  ;clear binary encoded decimal flag
  cld
  
  ;initialize stack
  ldx #$FF  
  txs
  
  ;turn off all graphics
  inx
  stx $2001

  ;clear 2K RAM
  lda #$00
:
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne :-
  
  ;wait for PPU to be ready
  waitVBlank
  waitVBlank

  jsr sound_initialize
  
  ;lda #GAMEOVERSTATE_INIT
  ;sta state_control_params+gameOverStateControl::state
  ;switchState game_over_state_update, game_over_state_update_ppu
  
  ;lda #TITLESTATE_INIT
  ;sta state_control_params+titleStateControl::state
  ;switchState title_state_update, title_state_update_ppu
  
  ;load current level
  lda #2
  sta state_control_params+loadLevelStateControl::levelToLoad
  lda #LOADLEVELSTATE_INIT
  sta state_control_params+loadLevelStateControl::state  
  switchState load_level_state_update, load_level_state_update_ppu
  
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