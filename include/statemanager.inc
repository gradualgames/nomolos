.ifndef STATEMANAGER_INC
STATEMANAGER_INC = 1

.global switch_state
.global state_table
.global wait_vblank_flag

;state table
index_title_state          = 0 * 2
index_level_in_state       = 1 * 2
index_load_level_state     = 2 * 2
index_play_level_state     = 3 * 2
index_continue_end_state   = 4 * 2
index_ending_state         = 5 * 2

.endif