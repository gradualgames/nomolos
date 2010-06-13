.ifndef PLAYLEVELSTATE_INC
PLAYLEVELSTATE_INC = 1

.global play_level_state_update
.global play_level_state_update_ppu

PLAYLEVELSTATE_KEEPPLAYING =           %00000000
PLAYLEVELSTATE_SWITCHLEVEL =           %00000001
PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE = %00000010
  
.struct playLevelStateControl
  state .byte                ;flags for whether to switch to a different level
  levelNum .byte             ;index of level to load
.endstruct

.endif
