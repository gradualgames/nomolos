.ifndef LEVELINSTATE_INC
LEVELINSTATE_INC = 1

.global level_in_state_update
.global level_in_state_update_ppu

LEVELINSTATE_INIT = %00000000
LEVELINSTATE_RUN =  %00000001
LEVELINSTATE_DONE = %00000010

.struct level_in_state_control
  state .byte
  use_restart_point .byte
.endstruct

.endif
