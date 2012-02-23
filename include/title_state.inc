.ifndef TITLESTATE_INC
TITLESTATE_INC = 1

.include "flags.inc"

.global title_state_update
.global title_state_update_ppu

TITLESTATE_LOGO  = %00000000
TITLESTATE_TITLE =  %00000001
TITLESTATE_MENU  = %00000010

.struct title_stateControl
  state .byte
  starting_level .byte
  difficulty_index .byte
.endstruct

.endif
