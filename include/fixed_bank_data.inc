.ifndef FIXEDBANKDATA_INC
FIXEDBANKDATA_INC = 1

.ifndef DEMO_BUILD
num_levels                 = 17
.else
num_levels = 8
.endif

level_1_index   = 0
level_1_2_index = 1
level_2_index   = 2
level_2_2_index = 3
boss_2_index    = 4
level_3_index   = 5
level_3_2_index = 6
boss_1_index    = 7
level_4_index   = 8
level_4_2_index = 9
boss_3_index    = 10
level_5_1_index = 11
level_5_2_index = 12
boss_4_index    = 13
level_6_1_index = 14
level_6_2_index = 15
boss_5_index    = 16

;state table
index_title_state          = 0 * 4
index_level_in_state       = 1 * 4
index_load_level_state     = 2 * 4
index_play_level_state     = 3 * 4
index_continue_end_state   = 4 * 4

.global entity_definition_table
.global entity_chr_definition_table
.global level_definition_table
.global banktable
.global haltmusic
.global victory_music
.global title_music
.global intro_cut_scene_music
.global font1
.global power_table
.global press_start_string
.global gradual_games_string
.global copyright_c_2012_string
.global level_string
.global lives_string
.global game_over_string
.global continue_string
.global end_string
.global spaces_string
.global title_definition
.global title_palette
.global title_name_table
.global slide1
.global slide2
.global slide3
.global slide4
.global slide5
.global solomon_snow_watching_birds_caption
.global portal_appears_caption
.global arm_snatches_snow_caption
.global leapt_through_portal_caption
.global became_nomolos_caption
.global nomolos_sets_out_caption

.struct title
  palette_address .word
  name_table_address .word
  chr_address .word
  chr_prg_rom_bank .byte
  nametable_bank .byte
.endstruct

.struct level
  level_data_table .word
.endstruct

.struct font
  chr_address .word
  chr_prg_rom_bank .byte
  digit_table .byte 10
  palette .byte 32
.endstruct

.struct level_data_struct
  nomolos_entity_bank .byte
  level_music_bank .byte
  level_patterns_bank .byte
  level_patterns_address .word
  sprite_patterns_bank .byte
  sprite_patterns_address .word
  cycling_palette_address .word
  cycling_palette_speed .byte
  
  palette .word

  nomolos_start_x .byte
  nomolos_start_y .byte
  starting_screen .byte
  
  intro_string .word
  columns_to_load .byte
  camera_scroll_enabled .byte  
  map .word
  map_column_table .word
  attribute_column_table .word
  meta_tile_column_table .word
  meta_tile_table .word
  
  entity_definition_table .word
  music .word
  next_level .byte

.endstruct

.endif
