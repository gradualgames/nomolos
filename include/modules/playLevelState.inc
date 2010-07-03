.ifndef PLAYLEVELSTATE_INC
PLAYLEVELSTATE_INC = 1

.global play_level_state_update
.global play_level_state_update_ppu

PLAYLEVELSTATE_KEEPPLAYING =           %00000000
PLAYLEVELSTATE_PAUSE       =           %00000001
PLAYLEVELSTATE_SWITCHLEVEL =           %00000010
PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE = %00000011
  
.struct playLevelStateControl
  state .byte                   ;flags for whether to switch to a different level
  levelNum .byte                ;index of level to load
  cycling_palette_address .word ;address of cycling palette
  palette_cycle_counter .byte   ;frame counter for palette cycling
  palette_cycle_index .byte     ;index into array of cycled palettes
  cycling_palette_speed .byte   ;what the cycle counter gets reset to
.endstruct

.endif
