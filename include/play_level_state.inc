.ifndef PLAYLEVELSTATE_INC
PLAYLEVELSTATE_INC = 1

.global play_level_state_init_play_mode
.global play_level_state_init_boss_mode
.global play_level_state_init_victory_mode
.global play_level_state_init_hands_off_victory_mode
.global play_level_state_update

PLAYLEVELSTATE_INIT        =           0
PLAYLEVELSTATE_KEEPPLAYING =           1
PLAYLEVELSTATE_PAUSE       =           3
PLAYLEVELSTATE_SWITCHTOLEVELINSTATE =  4
PLAYLEVELSTATE_SWITCHTOENDINGSTATE  =  5
PLAYLEVELSTATE_VICTORYMODE =           6
PLAYLEVELSTATE_HANDSOFFVICTORYMODE =   7

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
  frame_counter .word           ;16 bit frame counter for victory mode
  use_restart_point .byte       ;this parameter gets forwarded a lot...kind of unfortunate.
.endstruct

.endif
