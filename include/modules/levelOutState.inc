.ifndef LEVELOUTSTATE_INC
LEVELOUTSTATE_INC = 1

.global level_out_state_update
.global level_out_state_update_ppu

LEVELOUTSTATE_INIT =    %00000000
LEVELOUTSTATE_FADEOUT = %00000001

.struct levelOutStateControl
  state .byte
.endstruct

.endif
