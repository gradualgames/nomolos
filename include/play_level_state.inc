.ifndef PLAYLEVELSTATE_INC
PLAYLEVELSTATE_INC = 1

.global play_level_state_init_boss_mode
.global play_level_state_update
.global play_level_state_update_ppu

PLAYLEVELSTATE_INIT        =           %00000000
PLAYLEVELSTATE_KEEPPLAYING =           %00000001
PLAYLEVELSTATE_BOSSMODE    =           %00000010
PLAYLEVELSTATE_PAUSE       =           %00000011
PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE = %00000100

PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE =    %00000000
PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION = %00000001

.struct play_level_state_control
  state .byte                   ;flags for whether to switch to a different level
  levelNum .byte                ;index of level to load
  cycling_palette_address .word ;address of cycling palette
  palette_cycle_counter .byte   ;frame counter for palette cycling
  palette_cycle_index .byte     ;index into array of cycled palettes
  cycling_palette_speed .byte   ;what the cycle counter gets reset to
  upload_ppu_data .byte         ;flag to upload certain kinds of ppu data.
.endstruct

.endif
