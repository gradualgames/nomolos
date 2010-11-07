.ifndef CONTINUEENDSTATE_INC
CONTINUEENDSTATE_INC = 1

.global continue_end_state_update
.global continue_end_state_update_ppu

CONTINUEENDSTATE_INIT =   %00000000
CONTINUEENDSTATE_RUN  =   %00000001
CONTINUEENDSTATE_SELECT = %00000010
CONTINUEENDSTATE_DONE =   %00000011

CONTINUE_CURSOR_X = 78
CONTINUE_CURSOR_Y = 112
END_CURSOR_X = 78
END_CURSOR_Y = 128

CONTINUE_SELECTED = 0
END_SELECTED = 1

.struct continue_end_state_control
  state .byte
  selected_cursor .byte
.endstruct

.endif
