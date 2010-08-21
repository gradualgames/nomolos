.ifndef FIXEDBANKDATA_INC
FIXEDBANKDATA_INC = 1

;state table
index_title_state          = 0 * 4
index_level_in_state       = 1 * 4
index_load_level_state     = 2 * 4
index_game_over_state      = 3 * 4
index_play_level_state     = 4 * 4

.global level_definition_table
.global banktable
.global attack_sound
.global attackFlailSound
.global attackSpearSound
.global hit_sound
.global getHealthSound
.global getItemSound
.global getHurtSound
.global dieSound
.global haltmusic
.global title_music
.global font1
.global power_table
.global press_start_string
.global lda_games_string
.global copyright_c_2010_string
.global level_string
.global lives_string
.global game_over_string
.global title_definition
.global title_palette
.global title_name_table

SOUND_EFFECT_BASE = 10

.global sf_volume_envelope_silence
.global sf_volume_envelope_loud
.global sf_volume_envelope_1
.global sf_volume_envelope_decay
.global sf_volume_envelope_short_note
.global sf_volume_envelope_fade_in
.global sf_volume_envelope_fade_in_2
.global sf_pitch_envelope_0
.global sf_pitch_envelope_1

.struct title
  palette_address .word
  name_table_address .word
  chr_address .word
  chr_prg_rom_bank .byte
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
  
  nomolos_walk .word
  nomolos_walk_overlay .word
  nomolos_jump .word
  nomolos_jump_overlay .word
  nomolos_fight .word
  nomolos_fight_overlay .word
  nomolos_flail .word
  nomolos_flail_overlay .word
  nomolos_spear .word
  nomolos_spear_overlay .word
  nomolos_flail_ball .word
  nomolos_spear_fly .word
  nomolos_slumped_armor .word
  nomolos_slumped_armor_overlay .word
  nomolos_scaredy_cat .word
  nomolos_scaredy_cat_overlay .word
  
  heart_0 .word
  spear_0 .word
  grank_fly .word
  beedie_blob .word
  flail_0 .word
  deentle_walk .word
  explosion .word
  mouse .word
  one_up_0 .word
  skelekin_walk .word
  bat_fly .word
  batree .word
  owl_fly .word
  owl_attack .word
  snuffer_run .word
  snuffer_bite .word
  snail_crawl .word
  dragon_fly .word
  ice_ball_fly .word
  shark_leap .word
  stalactite_fall .word
  dragonboss_eyes .word
  dragonboss_nose .word
  
  attack_sound .word
  hit_sound .word
  palette .word

  nomolos_start_x .byte
  nomolos_start_y .byte
  
  intro_string .word
  camera_scroll_enabled .byte
  starting_screen .byte
  map .word
  map_column_table .word
  attribute_column_table .word
  meta_tile_column_table .word
  meta_tile_table .word
  
  entity_definition_table .word
  music .word
  next_level .byte
  
  nomolos_offset .byte
  deentle_offset .byte
  explosion_offset .byte
  beedie_offset .byte
  grank_offset .byte
  BatOffset .byte
  skelekin_offset .byte
  batree_offset .byte
  owl_offset .byte
  snuffer_offset .byte
  snail_offset .byte
  dragon_offset .byte
  ice_ball_offset .byte
  shark_offset .byte
  stalactite_offset .byte
  dragonboss_offset .byte

.endstruct

.endif
