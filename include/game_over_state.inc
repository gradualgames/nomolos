.ifndef GAMEOVERSTATE_INC
GAMEOVERSTATE_INC = 1

.global game_over_state_update
.global game_over_state_update_ppu

GAMEOVERSTATE_INIT = %00000000
GAMEOVERSTATE_RUN  = %00000001
GAMEOVERSTATE_DONE = %00000010

.struct gameOverStateControl
  state .byte
.endstruct

.endif
