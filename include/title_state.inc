.ifndef TITLESTATE_INC
TITLESTATE_INC = 1

.include "flags.inc"

.global title_state_update
.global title_state_update_ppu

TITLESTATE_INIT = %00000000
TITLESTATE_RUN =  %00000001
TITLESTATE_DONE = %00000010

.struct title_stateControl
  state .byte
  starting_level .byte
.endstruct

.endif
