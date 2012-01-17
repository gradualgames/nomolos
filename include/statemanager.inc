.ifndef STATEMANAGER_INC
STATEMANAGER_INC = 1

.global switch_state
.global state_table
.global wait_vblank_flag

;state table
index_title_state          = 0 * 4
index_level_in_state       = 1 * 4
index_load_level_state     = 2 * 4
index_play_level_state     = 3 * 4
index_continue_end_state   = 4 * 4
index_ending_state         = 5 * 4

.endif