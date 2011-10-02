.include "spritesheet_common.inc"
.include "spritesheet1.inc"
.include "spritesheet2.inc"
.include "level1.inc"
.include "level1_2.inc"
.include "level2.inc"
.include "level2_2.inc"
.include "boss2.inc"
.include "level3.inc"
.include "level3_2.inc"
.include "level4.inc"
.include "level4_2.inc"
.include "level5.inc"
.include "level5_2.inc"
.include "level6.inc"
.include "level6_2.inc"
.include "boss3.inc"
.include "boss1.inc"
.include "boss4.inc"
.include "entities.inc"
.include "soundengine.inc"
.include "fixed_bank_data.inc"
.include "title_state.inc"
.include "level_in_state.inc"
.include "load_level_state.inc"
.include "play_level_state.inc"
.include "zp.inc"
.include "sound_effects.inc"
.include "slides.inc"

;output the size of the level data struct to the console
.out .sprintf(".sizezof(level_data_struct) is %i", .sizeof(level_data_struct))

.segment "ROM14"

.include "font0_patterns_source.inc"
.include "title_patterns_source.inc"

.segment "CODE"

;level definitions

level_definition_table:
  .word level_1_1_data
  .word level_1_2_data
  .word level_2_1_data
  .word level_2_2_data
  .word boss_2_data
  .word level_3_1_data
  .word level_3_2_data
  .word boss_1_data
  .word level_4_1_data
  .word level_4_2_data
  .word boss_3_data
  .word level_5_1_data
  .word level_5_2_data
  .word boss_4_data
  .word level_6_1_data
  .word level_6_2_data

;level intro strings
level1_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$1c
level1_2_intro_string:
  .byte $09,$0b,$04,$15,$04,$0b,$1a,$1c,$2b,$1d
level2_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$1d
level2_2intro_string:
  .byte $09,$0b,$04,$15,$04,$0b,$1a,$1d,$2b,$1d
boss2_intro_string:
  .byte $07,$13,$07,$0e,$06,$14,$13,$07
boss3_intro_string:
  .byte $0d,$06,$11,$14,$01,$12,$04,$0b,$08,$0c,$1a,$01,$0e,$09
level3_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$1e
level3_2_intro_string:
  .byte $09,$0b,$04,$15,$04,$0b,$1a,$1e,$2b,$1d
level4_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$1f
level_4_2_intro_string:
  .byte $09,$0b,$04,$15,$04,$0b,$1a,$1f,$2b,$1d
boss1_intro_string:
  .byte $06,$0d,$0e,$06,$00,$11,$03
level5_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$20
level_5_2_intro_string:
  .byte $09,$0b,$04,$15,$04,$0b,$1a,$20,$2b,$1d
level6_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$21
level_6_2_intro_string:
  .byte $09,$0b,$04,$15,$04,$0b,$1a,$21,$2b,$1d
boss4_intro_string:
  .byte $05,$12,$0d,$04,$04,$0f

;ROM definition table
level_1_1_data:
  .byte spritesheet_1_bank
  .byte level_1_bank
  .byte level_1_patterns_bank
  .word level1_patterns
  .byte spritesheet_1_patterns_bank
  .word level1_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 0 ;cycling_palette_speed

  .word level1_palette

  .byte 120 ;nomolos_start_x
  .byte 191 ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level1_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level1_map
  .word level1_map_column_table
  .word level1_attribute_column_table
  .word level1_meta_tile_column_table
  .word level1_meta_tile_table

  .word entity_definition_table

  .word level1_music

  .byte level_1_2_index

;ROM definition table
level_1_2_data:
  .byte spritesheet_1_bank
  .byte level_1_2bank
  .byte level_1_2patterns_bank
  .word level1_patterns
  .byte spritesheet_1_patterns_bank
  .word level1_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 0 ;cycling_palette_speed

  .word level1_2palette

  .byte 120 ;nomolos_start_x
  .byte 159 ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level1_2_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level1_2map
  .word level1_2map_column_table
  .word level1_2attribute_column_table
  .word level1_2meta_tile_column_table
  .word level1_2meta_tile_table

  .word entity_definition_table

  .word level1_music

  .byte level_2_index

;ROM definition table
level_2_1_data:
  .byte spritesheet_1_bank
  .byte level_2_bank
  .byte level_2_patterns_bank
  .word level2_patterns
  .byte spritesheet_1_patterns_bank
  .word level2_sprite_groups
  .word level2_cycling_palettes ;cycling_palette_address
  .byte 5 ;cycling_palette_speed

  .word level2_palette

  .byte 120 ;nomolos_start_x
  .byte 90  ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level2_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level2_map
  .word level2_map_column_table
  .word level2_attribute_column_table
  .word level2_meta_tile_column_table
  .word level2_meta_tile_table

  .word entity_definition_table
  .word level2_music
  .byte level_2_2_index

;ROM definition table
level_2_2_data:
  .byte spritesheet_1_bank
  .byte level2_2bank
  .byte level_2_patterns_bank
  .word level2_patterns
  .byte spritesheet_1_patterns_bank
  .word level2_sprite_groups
  .word level2_2cycling_palettes ;cycling_palette_address
  .byte 5 ;cycling_palette_speed

  .word level2_2palette

  .byte 104 ;nomolos_start_x
  .byte 0   ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level2_2intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level2_2map
  .word level2_2map_column_table
  .word level2_2attribute_column_table
  .word level2_2meta_tile_column_table
  .word level2_2meta_tile_table

  .word entity_definition_table
  .word level2_2music
  .byte boss_2_index

;ROM definition table
boss_2_data:
  .byte spritesheet_2_bank
  .byte boss2_bank
  .byte level_2_patterns_bank
  .word level2_patterns
  .byte spritesheet_2_patterns_bank
  .word boss2_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 5 ;cycling_palette_speed

  .word boss2_palette

  .byte 0   ;nomolos_start_x
  .byte 191 ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word boss2_intro_string
  .byte 32 ;columns_to_load
  .byte 0  ;camera_scroll_enabled  
  .word boss2_map
  .word boss2_map_column_table
  .word boss2_attribute_column_table
  .word boss2_meta_tile_column_table
  .word boss2_meta_tile_table

  .word entity_definition_table
  .word boss2_music
  .byte level_3_index

;ROM definition table
level_3_1_data:
  .byte spritesheet_1_bank
  .byte level_3_bank
  .byte level_3_patterns_bank
  .word level3_patterns
  .byte spritesheet_1_patterns_bank
  .word level3_sprite_groups
  .word level3_cycling_palettes ;cycling_palette_address
  .byte 10 ;cycling_palette_speed

  .word level3_palette

  .byte 104 ;nomolos_start_x
  .byte 0   ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level3_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level3_map
  .word level3_map_column_table
  .word level3_attribute_column_table
  .word level3_meta_tile_column_table
  .word level3_meta_tile_table

  .word entity_definition_table
  .word level3_music
  .byte level_3_2_index

;ROM definition table
level_3_2_data:
  .byte spritesheet_1_bank
  .byte level_3_bank
  .byte level_3_patterns_bank
  .word level3_patterns
  .byte spritesheet_1_patterns_bank
  .word level3_sprite_groups
  .word level3_cycling_palettes ;cycling_palette_address
  .byte 10 ;cycling_palette_speed

  .word level3_palette

  .byte 0   ;nomolos_start_x
  .byte 191 ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level3_2_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level3_2_map
  .word level3_2_map_column_table
  .word level3_2_attribute_column_table
  .word level3_2_meta_tile_column_table
  .word level3_2_meta_tile_table

  .word entity_definition_table
  .word level3_music
  .byte boss_1_index

;ROM definition table
boss_1_data:
  .byte spritesheet_1_bank
  .byte boss_1_bank
  .byte boss_1_patterns_bank
  .word boss1_patterns
  .byte spritesheet_1_patterns_bank
  .word boss1_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 0 ;cycling_palette_speed

  .word boss1_palette

  .byte 40  ;nomolos_start_x
  .byte 159 ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word boss1_intro_string
  .byte 32 ;columns_to_load
  .byte 0  ;camera_scroll_enabled  
  .word boss1_map
  .word boss1_map_column_table
  .word boss1_attribute_column_table
  .word boss1_meta_tile_column_table
  .word boss1_meta_tile_table

  .word entity_definition_table
  .word boss1_music
  .byte level_4_index

;ROM definition table
level_4_1_data:
  .byte spritesheet_2_bank
  .byte level_4_bank
  .byte level_4_patterns_bank
  .word level4_patterns
  .byte spritesheet_2_patterns_bank
  .word level4_sprite_groups
  .word level4_cycling_palettes ;cycling_palette_address
  .byte 5  ;cycling_palette_speed

  .word level4_palette

  .byte 30  ;nomolos_start_x
  .byte 100 ;nomolos_start_y
  .byte 0 ;starting_screen
  
  .word level4_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level4_map
  .word level4_map_column_table
  .word level4_attribute_column_table
  .word level4_meta_tile_column_table
  .word level4_meta_tile_table

  .word entity_definition_table
  .word level4_music
  .byte level_4_2_index

;ROM definition table
level_4_2_data:
  .byte spritesheet_2_bank
  .byte level_4_bank
  .byte level_4_patterns_bank
  .word level4_patterns
  .byte spritesheet_2_patterns_bank
  .word level4_sprite_groups
  .word level4_cycling_palettes ;cycling_palette_address
  .byte 5  ;cycling_palette_speed

  .word level4_palette

  .byte 30  ;nomolos_start_x
  .byte 100 ;nomolos_start_y
  .byte 0 ;starting_screen
  
  .word level_4_2_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level_4_2_map
  .word level_4_2_map_column_table
  .word level_4_2_attribute_column_table
  .word level_4_2_meta_tile_column_table
  .word level_4_2_meta_tile_table

  .word entity_definition_table
  .word level4_music
  .byte boss_3_index

;ROM definition table
boss_3_data:
  .byte spritesheet_1_bank
  .byte boss3_bank
  .byte level_4_patterns_bank
  .word level4_patterns
  .byte spritesheet_1_patterns_bank
  .word boss3_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 5 ;cycling_palette_speed

  .word boss3_palette

  .byte 20 ;nomolos_start_x
  .byte 50 ;nomolos_start_y
  .byte 0  ;starting_screen
  
  .word boss3_intro_string
  .byte 32 ;columns_to_load
  .byte 0  ;camera_scroll_enabled  
  .word boss3_map
  .word boss3_map_column_table
  .word boss3_attribute_column_table
  .word boss3_meta_tile_column_table
  .word boss3_meta_tile_table

  .word entity_definition_table
  .word boss3_music
  .byte level_5_1_index

;ROM definition table
level_5_1_data:
  .byte spritesheet_2_bank
  .byte level_5_bank
  .byte level_5_patterns_bank
  .word level5_patterns
  .byte spritesheet_2_patterns_bank
  .word level5_sprite_groups
  .word 0  ;level5_cycling_palettes ;cycling_palette_address
  .byte 0  ;cycling_palette_speed

  .word level5_palette

  .byte 30  ;nomolos_start_x
  .byte 50 ;nomolos_start_y
  .byte 0 ;starting_screen
  
  .word level5_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level5_map
  .word level5_map_column_table
  .word level5_attribute_column_table
  .word level5_meta_tile_column_table
  .word level5_meta_tile_table

  .word entity_definition_table
  .word level5_music
  .byte level_5_2_index

level_5_2_data:
  .byte spritesheet_2_bank
  .byte level_5_2_bank
  .byte level_5_patterns_bank
  .word level5_patterns
  .byte spritesheet_2_patterns_bank
  .word level5_sprite_groups
  .word 0  ;level4_cycling_palettes ;cycling_palette_address
  .byte 0  ;cycling_palette_speed

  .word level_5_2_palette

  .byte 30  ;nomolos_start_x
  .byte 100 ;nomolos_start_y
  .byte 0 ;starting_screen
  
  .word level_5_2_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level_5_2_map
  .word level_5_2_map_column_table
  .word level_5_2_attribute_column_table
  .word level_5_2_meta_tile_column_table
  .word level_5_2_meta_tile_table

  .word entity_definition_table
  .word level5_music
  .byte boss_4_index

boss_4_data:
  .byte spritesheet_2_bank
  .byte level_5_2_bank
  .byte level_5_patterns_bank
  .word level5_patterns
  .byte spritesheet_2_patterns_bank
  .word boss4_sprite_groups
  .word 0  ;level4_cycling_palettes ;cycling_palette_address
  .byte 0  ;cycling_palette_speed

  .word boss4_palette

  .byte 30  ;nomolos_start_x
  .byte 100 ;nomolos_start_y
  .byte 0 ;starting_screen
  
  .word boss4_intro_string
  .byte 16 ;columns_to_load
  .byte 0  ;camera_scroll_enabled  
  .word boss4_map
  .word boss4_map_column_table
  .word boss4_attribute_column_table
  .word boss4_meta_tile_column_table
  .word boss4_meta_tile_table

  .word entity_definition_table
  .word boss4_music
  .byte level_6_1_index

;ROM definition table
level_6_1_data:
  .byte spritesheet_2_bank
  .byte level_6_bank
  .byte level_6_patterns_bank
  .word level6_patterns
  .byte spritesheet_2_patterns_bank
  .word level6_sprite_groups
  .word level6_cycling_palettes ;cycling_palette_address
  .byte 6 ;cycling_palette_speed

  .word level6_palette

  .byte 30  ;nomolos_start_x
  .byte 50 ;nomolos_start_y
  .byte 0 ;starting_screen
  
  .word level6_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level6_map
  .word level6_map_column_table
  .word level6_attribute_column_table
  .word level6_meta_tile_column_table
  .word level6_meta_tile_table

  .word entity_definition_table
  .word level6_music
  .byte level_6_2_index

;ROM definition table
level_6_2_data:
  .byte spritesheet_2_bank
  .byte level_6_2_bank
  .byte level_6_patterns_bank
  .word level6_patterns
  .byte spritesheet_2_patterns_bank
  .word level6_sprite_groups
  .word 0  ;level4_cycling_palettes ;cycling_palette_address
  .byte 0  ;cycling_palette_speed

  .word level6_palette

  .byte 30  ;nomolos_start_x
  .byte 100 ;nomolos_start_y
  .byte 0 ;starting_screen
  
  .word level_6_2_intro_string
  .byte 16 ;columns_to_load
  .byte 1  ;camera_scroll_enabled  
  .word level_6_2_map
  .word level_6_2_map_column_table
  .word level_6_2_attribute_column_table
  .word level_6_2_meta_tile_column_table
  .word level_6_2_meta_tile_table

  .word entity_definition_table
  .word level6_music
  .byte level_1_index

;Entities
entity_definition_table:
  .word $00  ;blank entry for Nomolos, the only hard coded entity
  .byte $00
  .byte $00
  .word deentle_update
  .byte $05
  .byte $00
  .word explosion_update
  .byte $0A
  .byte $00
  .word mouse_update
  .byte $0A
  .byte $00
  .word exit_level_update
  .byte $02
  .byte $00
  .word oneup_update
  .byte $0A
  .byte $00
  .word flail_item_update
  .byte $0A
  .byte $00
  .word beedie_update
  .byte $05
  .byte $00
  .word grank_update
  .byte $05
  .byte $00
  .word spear_item_update
  .byte $0A
  .byte $00
  .word skelekin_update
  .byte $05
  .byte $00
  .word bat_update
  .byte $0A
  .byte $00
  .word batree_update
  .byte $01
  .byte $00
  .word owl_update
  .byte $01
  .byte $00
  .word snuffer_update
  .byte $01
  .byte $00
  .word snail_update
  .byte $01
  .byte $00
  .word dragon_update
  .byte $01
  .byte $00
  .word iceball_update
  .byte $0a
  .byte $00
  .word shark_update
  .byte $05
  .byte $00
  .word stalactite_update
  .byte $05
  .byte $00
  .word dragonboss_update
  .byte $05
  .byte $00
  .word restart_update
  .byte $02
  .byte $00
  .word phoenix_update
  .byte $01
  .byte $00
  .word fireball_update
  .byte $0a
  .byte $00
  .word snake_update
  .byte $02
  .byte $00
  .word fireguy_update
  .byte $02
  .byte $00
  .word thoguth_update
  .byte $01
  .byte $00
  .word fireballspawner_update
  .byte $03
  .byte $00
  .word lightningbolt_update
  .byte $0a
  .byte $00
  .word grubselimboj_update
  .byte $01
  .byte $00
  .word bigfireball_update
  .byte $0a
  .byte $00
  .word statue_update
  .byte $03
  .byte $00
  .word raven_update
  .byte $01
  .byte $00
  .word sheep_update
  .byte $01
  .byte $00
  .word bee_update
  .byte $05
  .byte $00
  .word explosionspawner_update
  .byte $0a
  .byte $00
  .word setrightmostx_update
  .byte $01
  .byte $00
  .word gort_update
  .byte $02
  .byte $00
  .word hippocritter_update
  .byte $02
  .byte $00
  .word armoredskelekin_update
  .byte $02
  .byte $00
  .word attacknid_update
  .byte $03
  .byte $00
  .word laser_update
  .byte $05
  .byte $00
  .word sneep_update
  .byte $01
  .byte $00
  .word feather_update
  .byte $05
  .byte $00
  
entity_chr_definition_table:
  .word spritesheet_common_Nomolos_chr
  .word spritesheet1_Deentle_chr
  .word spritesheet_common_Explosion_chr
  .word entity_index_nomolos ;mouse uses Nomolos chr data
  .word 0                      ;exit entity has no chr data
  .word entity_index_nomolos ;oneup uses Nomolos chr data
  .word entity_index_nomolos ;flail uses Nomolos chr data
  .word spritesheet1_Beedie_chr
  .word spritesheet1_Grank_chr
  .word entity_index_nomolos ;spear uses Nomolos chr data
  .word spritesheet1_Skelekin_chr
  .word spritesheet_common_Bat_chr
  .word spritesheet1_Batree_chr
  .word spritesheet1_Owl_chr
  .word spritesheet1_Snuffer_chr
  .word spritesheet1_Snail_chr
  .word spritesheet1_Dragon_chr
  .word spritesheet1_IceBall_chr
  .word spritesheet1_Shark_chr
  .word spritesheet1_Stalactite_chr
  .word spritesheet1_DragonFace_chr
  .word 0 ;restart entity has no chr data
  .word spritesheet2_Phoenix_chr
  .word spritesheet2_Fireball_chr
  .word spritesheet2_Snake_chr
  .word spritesheet2_FireGuy_chr
  .word spritesheet2_Thoguth_chr
  .word 0 ;fireball spawner has no chr data
  .word entity_index_thoguth ;lightning bolt shares Thoguth's chr data
  .word spritesheet1_GrubselimBoj_chr
  .word spritesheet1_bigfireball_chr
  .word spritesheet2_statue_chr
  .word spritesheet2_raven_chr
  .word spritesheet2_sheep_chr
  .word spritesheet2_bee_chr
  .word 0 ;explosion spawner has no chr data
  .word 0 ;setrightmostx has no chr data
  .word spritesheet2_Gort_chr
  .word spritesheet2_Hippocritter_chr
  .word spritesheet2_ArmoredSkelekin_chr
  .word spritesheet2_Attacknid_chr
  .word spritesheet2_Laser_chr
  .word spritesheet2_Sneep_chr
  .word entity_index_sneep  ;feather uses sneep chr data

;miscellaneous data
banktable:
  .byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f

.export victory_music
victory_music: 
.scope
  .word Square1
  .word Square2
  .word Triangle
  .word Noise
  .word volume_envelopes
  .word pitch_envelopes
  .word duty_envelopes

volume_envelopes:
  .word volume_envelope_0
  .word volume_envelope_1
  .word volume_envelope_2
  .word 0
  .word 0
  
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  
  sound_effect_volume_addresses

pitch_envelopes:
  .word pitch_envelope_0
  .word 0
  .word 0
  .word 0
  .word 0
  
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  
  sound_effect_pitch_addresses

duty_envelopes:
  .word duty_envelope_0

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 13,12,11,10,9,8,8,6,5,4,2,2,2,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,24,A1,STL,8,A1,E2,E1,STL,16,A1,STL,8,E3,A1,E2,E1,STL
  .byte 16,A1,STL,8,CS3,A1,E2,E1,STL,16,A1,STL,8,CS3,A1,E2,E1,STL,16,A1,STL,8,E3,A1
  .byte E2,E1,STL,16,A1,D2,GS1,A1,B1,CS2,D2,E2,E1,STL,48,A1
  .byte GOT
  .word Square1

Square2:
  .byte STV,0,STL,8,A0,STV,2,STP,0,SDU,0,E3,STL,24,CS4,STL,8,B3,A3,E3,STL,24,CS4,STL
  .byte 8,B3,A3,E3,STL,24,E3,STL,8,D3,CS3,E2,STL,24,E3,STL,8,D3,CS3,E2,STL,24,CS4,STL
  .byte 8,B3,A3,E3,FS3,D3,E3,B2,CS3,A2,B2,GS2,A2,E2,FS2,D2,E2,CS2,D2,B1,STL,4,D2,CS2
  .byte D2,CS2,STL,8,B1,CS2,STL,16,A1
  .byte GOT
  .word Square2

Triangle:
  .byte STV,0,STL,255,A0,STL,177,A0
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,255,A0,STL,177,A0
  .byte GOT
  .word Noise
.endscope
  
title_music:
.scope
  .word Square1
  .word Square2
  .word Triangle
  .word Noise
  .word volume_envelopes
  .word pitch_envelopes
  .word duty_envelopes

volume_envelopes:
  .word volume_envelope_0
  .word volume_envelope_1
  .word volume_envelope_2
  .word 0
  .word 0

  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

  sound_effect_volume_addresses

pitch_envelopes:
  .word pitch_envelope_0
  .word 0
  .word 0
  .word 0
  .word 0

  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

  sound_effect_pitch_addresses
  
duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 14,12,11,9,7,6,4,2,1,0,0,2,3,5,8,6,3,1,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte -128,-128,-128,-128,-128,-128,-128,-128,ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,20,G4,D4,STL,5,C4,B3,C4,B3,STL,10,A3,G3,FS3,E3,D3,C3
  .byte B2,C3,STL,50,D3,STL,10,G3,FS3,B3,A3,E4,D4,G4,FS4,C5,B4,A4,G4,FS4,STL,20,G4,G3
  .byte STL,10,FS3,B3,A3,E4,D4,G4,FS4,C5,B4,A4,G4,FS4,STL,20,G4,D4,STL,10,E4,E3,E3,E3
  .byte E3,E3,E3,G3,STL,20,E3,E4,STL,5,FS4,E4,FS4,E4,STL,10,D4,C4,D4,D3,D3,D3,D3,D3
  .byte D3,FS3,STL,20,D3,D4,STL,5,E4,D4,E4,D4,STL,10,C4,B3,C4,D3,D3,D3,D3,D3,D3,FS3
  .byte STL,20,D3,C4,STL,5,D4,C4,D4,C4,STL,10,B3,A3,B3,G2,G2,G2,G2,G2,G2,B2,STL,20
  .byte G2,B3,STL,5,C4,B3,C4,B3,STL,10,A3,G3,D4,A3,FS3,D3,B3,D3,B2,G2,D4,A3,FS3,D3
  .byte B3,D3,B2,G2
  .byte GOT
  .word Square1

Square2:
  .byte STV,0,STL,120,A0,STV,2,STP,0,SDU,0,STL,20,G2,D2,STL,5,C2,B1,C2,B1,STL,10,A1
  .byte G1,STL,40,D2,D1,STL,20,G1,G2,STL,5,C2,B1,C2,B1,STL,10,A1,G1,STL,40,D2,D1,STL
  .byte 20,G1,G2,STL,5,C2,B1,C2,B1,STL,10,A1,G1,STL,40,C2,STL,10,C4,C4,C4,E4,STL,20
  .byte C4,C4,STL,5,D4,C4,D4,C4,STL,10,B3,A3,STL,40,B3,STL,10,B3,B3,B3,D4,STL,20,B3
  .byte B2,STL,5,C3,B2,C3,B2,STL,10,A2,G2,STL,40,D2,STL,10,A3,A3,A3,C4,STL,20,A3,D2
  .byte STL,5,B2,A2,B2,A2,STL,10,G2,FS2,STL,40,G1,STL,10,B3,B3,B3,D4,STL,20,B3,G2,STL
  .byte 5,A2,G2,A2,G2,STL,10,FS2,E2,STL,20,D1,D2,D1,D2,D1,D2,D1,D2
  .byte GOT
  .word Square2

Triangle:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,45,A0
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,45,A0
  .byte GOT
  .word Noise
.endscope
  
font1:
  .word font0_patterns
  .byte $0E
  .byte $1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24
  .byte $0d,$20,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d
  .byte $0d,$20,$0d,$0d,$0d,$04,$2a,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d

;table of decimal powers for creating decimal strings from 8 bit numbers
power_table:
  .byte 100, 10, 1

spaces_string:
  .byte $03,$1a,$1a,$1a
  
press_start_string:
  .byte $0b,$0f,$11,$04,$12,$12,$1a,$12,$13,$00,$11,$13

gradual_games_string:
  .byte $0d,$06,$11,$00,$03,$14,$00,$0b,$1a,$06,$00,$0c,$04,$12

copyright_c_2010_string:
  .byte $08,$2c,$02,$2d,$1a,$1d,$1b,$1c,$1b

level_string:
  .byte $06,$0b,$04,$15,$04,$0b,$1a

lives_string:
  .byte $06,$0b,$08,$15,$04,$12,$1a

game_over_string:
  .byte $09,$06,$00,$0c,$04,$1a,$0e,$15,$04,$11

continue_string:
  .byte $08,$02,$0e,$0d,$13,$08,$0d,$14,$04

end_string:
  .byte $03,$04,$0d,$03
  
title_definition:
  .word title_palette
  .word title_nametable
  .word title_patterns
  .byte 14
  .byte 10

title_palette:
  .byte $0d,$20,$0d,$0d,$0d,$16,$20,$10,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d
  .byte $0d,$20,$0d,$0d,$0d,$16,$20,$10,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d

slide1:
  .word slide1_palette
  .word slide1_nametable
  .word slide1_chr
  .byte 255
  .byte 10

slide2:
  .word slide2_palette
  .word slide2_nametable
  .word slide2_chr
  .byte 255
  .byte 10
