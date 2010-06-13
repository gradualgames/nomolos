.ifndef TITLESTATE_INC
TITLESTATE_INC = 1

.global title_state_update
.global title_state_update_ppu

TITLESTATE_INIT = %00000000
TITLESTATE_RUN =  %00000001
TITLESTATE_DONE = %00000010

.struct titleStateControl
  state .byte
.endstruct

.endif
