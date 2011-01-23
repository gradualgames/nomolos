.ifndef LOADLEVELSTATE_INC
LOADLEVELSTATE_INC = 1

.global load_level_state_update
.global load_level_state_update_ppu

LOADLEVELSTATE_INIT = %00000000
LOADLEVELSTATE_LOAD = %00000001
LOADLEVELSTATE_DONE = %00000010

.struct load_level_stateControl
  state .byte
  level_to_load .byte
  use_restart_point .byte
  column_counter .byte
.endstruct

.endif
