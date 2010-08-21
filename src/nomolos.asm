.include "flags.inc"
.include "zp.inc"
.include "camera.inc"
.include "nomolos_logic.inc"
.include "load_level_state.inc"
.include "level_in_state.inc"
.include "game_over_state.inc"
.include "title_state.inc"
.include "entity.inc"
.include "soundengine.inc"
.include "level1.inc"
.include "level2.inc"
.include "ppu.inc"
.include "fixed_bank_data.inc"
.include "nomolos_logic.inc"
.include "sprite.inc"
.include "statemanager.inc"

.segment "HEADER"
.byte "NES",$1a   ;iNES header
.byte $08         ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $00         ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
.byte $21         ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #2 (UnROM)
.byte $00         ;Rest of Mapper #2 bits (all 0)

.segment "CODE"

reset:
  ;set interrupt disable flag
  sei

  ;clear binary encoded decimal flag
  cld

  ;initialize stack
  ldx #$FF
  txs

  ;turn off all graphics and clear our PPU registers
  lda #$00
  sta ppu_2000
  sta ppu_2001
  upload_ppu_2000
  upload_ppu_2001

  ;wait for PPU to be ready
  wait_vblank
  wait_vblank

  ;initialize ppu registers with settings we're never going to change
  set_ppu_2001_bit PPU1_SPRITE_CLIPPING
  set_ppu_2001_bit PPU1_BACKGROUND_CLIPPING

  ;initialize various modules which require a guaranteed initial state
  jsr sound_initialize
  jsr nomolos_module_init
  jsr sprite_module_init

  ;lda #TITLESTATE_INIT
  ;sta state_control_params+title_stateControl::state
  ;ldx #index_title_state
  ;jsr switch_state

  ;load a level with intro
  lda #3
  sta level_current
  lda #LEVELINSTATE_INIT
  sta state_control_params+levelInStateControl::state
  ldx #index_level_in_state
  jsr switch_state
  
  ;load a level directly
  ;lda #3
  ;sta state_control_params+load_level_stateControl::levelToLoad
  ;lda #LOADLEVELSTATE_INIT
  ;sta state_control_params+load_level_stateControl::state
  ;ldx #index_load_level_state
  ;jsr switch_state

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