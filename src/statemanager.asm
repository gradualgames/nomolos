.include "title_state.inc"
.include "level_in_state.inc"
.include "load_level_state.inc"
.include "continue_end_state.inc"
.include "play_level_state.inc"
.include "ending_state.inc"
.include "statemanager.inc"
.include "zp.inc"
.include "fixed_bank_data.inc"
.include "ppu.inc"
.include "map.inc"
.include "ram.inc"
.include "sprite.inc"
.include "flags.inc"
.include "soundengine.inc"

.segment "CODE"

;this routine waits for the nmi counter to reach zero.
.proc wait_vblank_flag

: lda nmi_counter
  bne :-

  rts

.endproc

;this routine takes the value in the accumulator and
;looks up a state in the state table and then changes the current
;update and ppu routines to the values found there.
;inputs: x is assumed to contain index of state
.proc switch_state

  ;load address of update routine
  lda state_table,x
  sta update
  lda state_table+1,x
  sta update+1

  rts
.endproc

;state table
state_table:
  .word title_state_update
  .word level_in_state_update
  .word load_level_state_update
  .word play_level_state_update
  .word continue_end_state_update
  .word ending_state_update
