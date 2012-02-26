.ifndef FIXEDBANKDATA_INC
FIXEDBANKDATA_INC = 1

.ifndef DEMO_BUILD
num_levels                 = 17
.else
num_levels = 2
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

.global entity_definition_table
.global entity_chr_definition_table
.global level_definition_table
.global banktable
.global gradual_games_logo_music
.global victory_music
.global title_music
.global intro_cut_scene_music
.global mysterious_barricades
.global soler_presto
.global font1
.global power_table
.global press_start_string
.global difficulty_string
.global easy_string
.global normal_string
.global hard_string
.global unfair_string
.global gradual_games_string
.global copyright_c_2012_string
.global level_string
.global lives_string
.global game_over_string
.global continue_string
.global heart
.global end_string
.global the_string
.global spaces_string
.global title_slide
.global gradual_games_logo_slide
.global slide1
.global slide2
.global slide3
.global slide4
.global slide5
.ifndef DEMO_BUILD
.global ending_slide1
.global ending_slide2
.global ending_slide3
.endif
.global solomon_snow_watching_birds_slide
.global portal_appears_slide
.global arm_snatches_snow_slide
.global leapt_through_portal_slide
.global became_nomolos_slide
.global nomolos_sets_out_slide
.ifdef DEMO_BUILD
.global thanks_for_playing_demo_slide
.endif
.global nomolos_and_snow_reunited_slide
.global portal_appears_above_scepter_slide
.global leapt_through_ending_portal_slide
.global arriving_at_other_side_slide
.ifndef DEMO_BUILD
.global thanks_for_playing_slide
.global by_gradual_games_slide
.global derek_andrews_slide
.global laurie_andrews_slide
.global daniel_hwozdek_slide
.global music_by_slide
.global beta_testers_slide
.global production_slide
.global joseph_morgan_slide
.global special_thanks_slide
.global nesdev_slide
.global nintendoage_slide
.global secret_message_slide
.endif
.global difficulty_table

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
