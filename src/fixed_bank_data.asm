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
.include "boss5.inc"
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

.segment "ROM14"

.include "font0_patterns_source.inc"
.include "title_patterns_source.inc"

.segment "CODE"

;level definitions

.ifndef DEMO_BUILD
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
  .word boss_5_data
.else
level_definition_table:
  .word level_1_1_data
  .word level_1_2_data
.endif

;level intro strings
.ifndef DEMO_BUILD
level1_intro_string:
;GRAVEYARD:1
  .byte $0b,$06,$11,$00,$15,$04,$18,$00,$11,$03,$2b,$1c
level1_2_intro_string:
;GRAVEYARD:2
  .byte $0b,$06,$11,$00,$15,$04,$18,$00,$11,$03,$2b,$1d
level2_intro_string:
;STRONGHOLD:1
  .byte $0c,$12,$13,$11,$0e,$0d,$06,$07,$0e,$0b,$03,$2b,$1c
level2_2intro_string:
;STRONGHOLD:2
  .byte $0c,$12,$13,$11,$0e,$0d,$06,$07,$0e,$0b,$03,$2b,$1d
boss2_intro_string:
  .byte $07,$13,$07,$0e,$06,$14,$13,$07
boss3_intro_string:
  .byte $0d,$06,$11,$14,$01,$12,$04,$0b,$08,$0c,$1a,$01,$0e,$09
level3_intro_string:
;CAVE:1
  .byte $06,$02,$00,$15,$04,$2b,$1c
level3_2_intro_string:
;CAVE:2
  .byte $06,$02,$00,$15,$04,$2b,$1d
level4_intro_string:
;VOLCANO:1
  .byte $09,$15,$0e,$0b,$02,$00,$0d,$0e,$2b,$1c
level_4_2_intro_string:
;VOLCANO:2
  .byte $09,$15,$0e,$0b,$02,$00,$0d,$0e,$2b,$1d
boss1_intro_string:
  .byte $06,$0d,$0e,$06,$00,$11,$03
level5_intro_string:
;RUINS:1
  .byte $07,$11,$14,$08,$0d,$12,$2b,$1c
level_5_2_intro_string:
;RUINS:2
  .byte $07,$11,$14,$08,$0d,$12,$2b,$1d
level6_intro_string:
;CATSLE:1
  .byte $08,$02,$00,$13,$12,$0b,$04,$2b,$1c
level_6_2_intro_string:
;CATSLE:2
  .byte $08,$02,$00,$13,$12,$0b,$04,$2b,$1d
boss4_intro_string:
  .byte $05,$12,$0d,$04,$04,$0f
boss5_intro_string:
  .byte $07,$01,$0e,$14,$0b,$03,$04,$11
.else
level1_intro_string:
;GRAVEYARD:1
  .byte $0b,$06,$11,$00,$15,$04,$18,$00,$11,$03,$2b,$1c
level1_2_intro_string:
;GRAVEYARD:2
  .byte $0b,$06,$11,$00,$15,$04,$18,$00,$11,$03,$2b,$1d
.endif

;ROM definition table
.ifndef DEMO_BUILD
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

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((9*16)+3)  ;nomolos_start_y
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

  .word level1_2music

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

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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
  .byte spritesheet_1_bank
  .byte boss2_bank
  .byte level_2_patterns_bank
  .word level2_patterns
  .byte spritesheet_1_patterns_bank
  .word boss2_sprite_groups
  .word boss2_cycling_palettes ;cycling_palette_address
  .byte 5 ;cycling_palette_speed

  .word boss2_palette

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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
  .word level3_2_music
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

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((7*16)+3)  ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((8*16)+3)  ;nomolos_start_y
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
  .word level_4_2_music
  .byte boss_3_index

;ROM definition table
boss_3_data:
  .byte spritesheet_1_bank
  .byte boss3_bank
  .byte level_4_patterns_bank
  .word level4_patterns
  .byte spritesheet_1_patterns_bank
  .word boss3_sprite_groups
  .word boss3_cycling_palettes ;cycling_palette_address
  .byte 5 ;cycling_palette_speed

  .word boss3_palette

  .byte 16          ;nomolos_start_x
  .byte ((6*16)+3)  ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((4*16)+3)  ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((7*16)+3)  ;nomolos_start_y
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
  .word level_5_2_music
  .byte boss_4_index

boss_4_data:
  .byte spritesheet_2_bank
  .byte boss4_bank
  .byte level_5_patterns_bank
  .word level5_patterns
  .byte spritesheet_2_patterns_bank
  .word boss4_sprite_groups
  .word 0  ;level4_cycling_palettes ;cycling_palette_address
  .byte 0  ;cycling_palette_speed

  .word boss4_palette

  .byte (16+2)      ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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
  .word level_6_2_music
  .byte boss_5_index

;ROM definition table
boss_5_data:
  .byte spritesheet_1_bank
  .byte boss_5_bank
  .byte boss_5_patterns_bank
  .word boss5_patterns
  .byte spritesheet_1_patterns_bank
  .word boss5_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 0 ;cycling_palette_speed

  .word boss5_palette

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word boss5_intro_string
  .byte 16 ;columns_to_load
  .byte 0  ;camera_scroll_enabled  
  .word boss5_map
  .word boss5_map_column_table
  .word boss5_attribute_column_table
  .word boss5_meta_tile_column_table
  .word boss5_meta_tile_table

  .word entity_definition_table
  .word boss5_music
  .byte level_1_index

.else

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

  .byte 16          ;nomolos_start_x
  .byte ((11*16)+3) ;nomolos_start_y
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

  .byte 16          ;nomolos_start_x
  .byte ((9*16)+3)  ;nomolos_start_y
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

  .word level1_2music

  .byte level_1_index
.endif

;Entities
entity_definition_table:
  .word $00  ;blank entry for Nomolos, the only hard coded entity
  .byte $00
  .byte $00
  .word deentle_update
  .byte $05
  .byte 4
  .word explosion_update
  .byte $0A
  .byte 4
  .word mouse_update
  .byte $0A
  .byte 2
  .word exit_level_update
  .byte $02
  .byte $00
  .word oneup_update
  .byte $0A
  .byte 2
  .word flail_item_update
  .byte $0A
  .byte 2
  .word beedie_update
  .byte $03
  .byte 4
  .word grank_update
  .byte $05
  .byte 4
  .word spear_item_update
  .byte $0A
  .byte 2
  .word skelekin_update
  .byte $02
  .byte 10
  .word bat_update
  .byte $0A
  .byte 2
  .word batree_update
  .byte $01
  .byte 15
  .word owl_update
  .byte $01
  .byte 12
  .word snuffer_update
  .byte $01
  .byte 12
  .word snail_update
  .byte $01
  .byte 6
  .word dragon_update
  .byte $01
  .byte 12
  .word iceball_update
  .byte $0a
  .byte 4
  .word shark_update
  .byte $02
  .byte 6
  .word stalactite_update
  .byte $05
  .byte 4
  .word dragonboss_update
  .byte $05
  .byte $00
  .word restart_update
  .byte $02
  .byte $00
  .word phoenix_update
  .byte $01
  .byte 15
  .word fireball_update
  .byte $0a
  .byte 4
  .word snake_update
  .byte $02
  .byte 6
  .word fireguy_update
  .byte $02
  .byte 6
  .word thoguth_update
  .byte $01
  .byte 22
  .word fireballspawner_update
  .byte $03
  .byte $00
  .word lightningbolt_update
  .byte $0a
  .byte 10
  .word grubselimboj_update
  .byte $01
  .byte 12
  .word bigfireball_update
  .byte $0a
  .byte $00
  .word statue_update
  .byte $03
  .byte $0a
  .word raven_update
  .byte $01
  .byte $10
  .word sheep_update
  .byte $02
  .byte $0c
  .word bee_update
  .byte $03
  .byte $04
  .word explosionspawner_update
  .byte $0a
  .byte $00
  .word setrightmostx_update
  .byte $01
  .byte $00
  .word gort_update
  .byte $02
  .byte 12
  .word hippocritter_update
  .byte $02
  .byte 12
  .word armoredskelekin_update
  .byte $02
  .byte 10
  .word attacknid_update
  .byte $03
  .byte 16
  .word laser_update
  .byte $05
  .byte 4
  .word sneep_update
  .byte $01
  .byte $00
  .word feather_update
  .byte $05
  .byte $00
  .word boulder_update
  .byte $01
  .byte $00
  .word spiraliceball_update
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
  .word spritesheet1_Thoguth_chr
  .word 0 ;fireball spawner has no chr data
  .word spritesheet1_LightningBolt_chr
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
  .word spritesheet1_Boulder_chr
  .word spritesheet1_IceBall_chr ;spiral iceball re-uses iceball graphics

;miscellaneous data
banktable:
  .byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f

gradual_games_logo_music:
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
  .word volume_envelope_3
  .word volume_envelope_4

pitch_envelopes:
  .word pitch_envelope_0

duty_envelopes:
  .word duty_envelope_0

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 10,9,7,5,4,3,3,5,6,6,6,5,3,2,1,ENV_STOP
volume_envelope_3:
  .byte 7,7,6,3,2,0,ENV_STOP
volume_envelope_4:
  .byte 9,8,7,7,6,5,4,3,2,2,5,5,5,5,4,3,2,1,0,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,28,G1,F1,STL,7,E1,F1,STL,42,G1,STV,4,STL,255,C1,STL,81
  .byte C1
  .byte TRM

Square2:
  .byte STV,2,STP,0,SDU,0,STL,28,G2,F2,STL,7,E2,F2,STL,42,G2,STV,4,STL,255,C2,STL,81
  .byte C2
  .byte TRM

Triangle:
  .byte STV,0,STL,255,A0,STL,193,A0
  .byte TRM

Noise:
  .byte STV,0,STL,255,A0,STL,193,A0
  .byte TRM
.endscope

.export intro_cut_scene_music
intro_cut_scene_music:
.scope

Song1: 
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
  .word volume_envelope_3

pitch_envelopes:
  .word pitch_envelope_0

duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 12,10,9,7,5,3,2,ENV_STOP
volume_envelope_3:
  .byte 10,8,6,4,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte 64,ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,1,STL,48,E1,STL,8,A3,E3,CS3,A2,E2,A1,STL,48,B0,STL,32,E1,STL
  .byte 8,B2,GS2,STL,48,E2,STL,8,A3,E3,CS3,A2,E2,A1,STL,48,B0,STL,96,E1,STL,8,E3,B2
  .byte FS3,GS3,B2,A3,STL,48,B3,STL,8,B3,FS3,CS4,DS4,FS3,E4,STL,48,FS4,STL,8,FS4,A3,GS3,A3
  .byte GS3,A3,FS4,A3,GS3,A3,GS3,A3,FS4,A3,GS3,A3,GS3,A3,FS4,C5,B4,A4,G4,FS4,E4,G3,FS3,G3
  .byte FS3,G3,E4,G3,FS3,G3,FS3,G3,E4,G3,FS3,G3,FS3,G3,E4,G4,FS4,E4,D4,CS4,B3,D3,CS3,D3
  .byte CS3,D3,B3,D3,CS3,D3,CS3,D3,B3,D3,CS3,D3,CS3,D3,B3,D4,CS4,B3,AS3,B3,FS4,CS4,AS3,FS3
  .byte CS3,AS2,FS2,CS2,AS1,FS1,AS1,CS2,STL,48,FS2,STL,24,E2,CS2,D2,B1,E2,G2,STL,96,FS1,STL,8
  .byte FS4,CS4,AS3,FS3,AS3,FS4,G4,G3,AS3,AS4,AS3,CS4,B4,B3,D4,FS4,E4,D4,CS4,D4,E4,D4,E4,CS4
  .byte STL,24,CS4,STL,72,B3,STL,8,D4,B3,E4,D4,B3,E4,D4,B3,E4,D4,B3,E4,D4,B3,E4,D4
  .byte B3,E4,D4,B3,FS4,D4,B3,D4,CS4,D4,E4,B3,CS4,AS3,B3,B4,FS4,GS4,E4,CS4,DS4,E4,FS4,B3
  .byte CS4,AS3,B3,B3,FS3,GS3,E3,CS3,DS3,E3,FS3,B2,CS3,AS2,STL,24,AS2,STL,72,B2
  .byte TRM

Square2:
  .byte STV,2,STP,0,SDU,1,STL,8,B4,GS4,E4,B3,GS3,B3,STL,24,CS4,STL,32,A4,STL,8,A4,STL
  .byte 4,FS4,GS4,STL,8,FS4,E4,DS4,E4,B3,GS3,STL,24,E3,STL,8,B4,GS4,E4,B3,GS3,B3,STL,24
  .byte CS4,STL,32,A4,STL,8,A4,STL,4,FS4,GS4,STL,8,FS4,E4,DS4,E4,B3,GS3,E3,B2,GS2,E2,B1
  .byte GS1,E1,GS1,B1,STL,48,E2,STL,8,E2,B1,FS2,GS2,B1,A2,STL,48,B2,STL,8,B2,FS2,CS3,DS3
  .byte FS2,E3,STL,24,FS3,E3,DS3,CS3,STL,48,B2,STL,24,B2,B1,STL,8,C3,C2,C1,C2,C3,C2,B2
  .byte B1,B0,B1,B2,B1,AS2,AS1,AS0,AS1,AS2,AS1,FS2,FS1,FS2,FS1,FS2,FS1,G2,G1,G2,G3,G2,G1,FS2
  .byte FS1,FS2,FS3,FS2,FS1,F2,F1,F2,F3,F2,F1,CS2,CS1,CS2,CS1,CS2,CS1,STL,96,FS1,STL,8,FS4,CS4
  .byte AS3,FS3,AS3,FS4,G4,G3,AS3,AS4,AS3,CS4,B4,B3,D4,FS4,E4,D4,CS4,D4,E4,D4,CS4,B3,FS4,CS4
  .byte AS3,FS3,CS3,AS2,FS2,CS2,AS1,FS1,AS1,CS2,STL,48,FS2,STL,24,E2,CS2,D2,B1,E2,FS2,STL,96,G1
  .byte STL,48,G2,G2,STL,24,G2,G2,STL,48,FS2,FS1,STL,24,B1,E2,FS2,FS1,B1,E2,FS2,FS1,STL,96
  .byte B0
  .byte TRM

Triangle:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL
  .byte 255,A0,STL,255,A0,STL,105,A0
  .byte TRM

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL
  .byte 255,A0,STL,255,A0,STL,105,A0
  .byte TRM
.endscope

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

pitch_envelopes:
  .word pitch_envelope_0
  
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
  
mysterious_barricades:
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

pitch_envelopes:
  .word pitch_envelope_0

duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 5,15,13,10,9,8,8,7,6,6,5,4,4,4,3,3,3,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,4,4,3,3,3,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1,1,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte 64,ENV_LOOP

Square1:
  .byte STV,0,STL,20,A0,STV,2,STP,0,SDU,1,AS2,D3,STL,120,AS2,STL,20,AS2,D3,STL,120,AS2,STL
  .byte 20,A2,AS2,STL,100,G2,STL,60,G2,STL,20,G2,STL,100,A2,STL,20,AS2,D3,STL,120,AS2,STL,20
  .byte AS2,D3,STL,120,AS2,STL,20,A2,AS2,STL,60,G2,STL,20,AS2,STL,80,A2,STL,100,F2,STL,80,D2

  .byte TRM

Square2:
  .byte STV,0,STL,100,A0,STV,2,STP,0,SDU,1,STL,20,C3,F3,STL,120,A2,STL,20,C3,F3,STL,120
  .byte A2,STL,20,F2,AS2,STL,40,A2,STL,20,AS2,STL,60,DS3,STL,20,DS3,STL,5,DS3,D3,DS3,D3,STL
  .byte 20,C3,STL,100,D3,STL,20,C3,F3,STL,120,A2,STL,20,C3,F3,STL,120,A2,STL,60,F2,STL,20
  .byte G2,A2,STL,60,AS2,STL,20,F2,AS2,A2,STL,10,AS2,A2,STL,60,AS2
  .byte TRM

Triangle:
  .byte STV,0,STL,40,A0,STV,2,STP,0,SDU,1,AS2,F3,F2,AS2,F3,F2,DS3,G2,D3,D2,D3,DS2,C3
  .byte F2,F3,AS2,F3,F2,F3,AS2,F3,F2,DS3,G2,D3,D2,D3,DS2,C3,F2,C3,STL,80,AS2
  .byte TRM

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,85,A0
  .byte TRM
.endscope

soler_presto:
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
  .word volume_envelope_3
  .word volume_envelope_4

pitch_envelopes:
  .word pitch_envelope_0

duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 10,10,9,8,7,7,6,5,4,3,3,3,2,2,2,2,1,1,0,ENV_STOP
volume_envelope_3:
  .byte 9,9,9,8,8,8,8,7,7,7,6,6,6,5,5,5,4,4,4,3,3,3,2,2,2,2,2,2,ENV_STOP
volume_envelope_4:
  .byte 4,2,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte 64,ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,1,STL,4,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,STL,48,CS3,STL
  .byte 4,G3,FS3,G3,FS3,G3,FS3,G3,FS3,G3,FS3,G3,FS3,STL,32,E3,STL,16,A3,G3,E3,CS3,D3,A2
  .byte FS2,G2,GS2,GS2,STL,32,A2,STL,16,A3,G3,E3,CS3,D3,A2,FS2,G2,A2,A2
Square1_loop:
  .byte STL,8,D1,D3,D2
  .byte D3,D2,D3,C4,D3,D2,D3,D2,D3,B3,D3,D2,D3,D2,D3,CS4,D3,D2,D3,D2,D3,D4,D3,D2
  .byte D3,D2,D3,CS4,D3,D4,D3,E4,D3,D4,D3,E4,D3,FS4,D3,FS4,G3,E4,G3,D4,G3,A3,A3,A2
  .byte A3,A2,A3,C4,D3,D2,D3,D2,D3,B3,D3,D2,D3,D2,D3,CS4,D3,D2,D3,D2,D3,D4,D3,D2
  .byte D3,D2,D3,CS4,D3,D4,D3,E4,D3,D4,D3,E4,D3,FS4,D3,FS4,G3,E4,G3,D4,G3,A3,A3,A2
  .byte A3,A2,A3,STL,16,D3,E3,FS3,STL,32,G3,STL,16,E3,D2,E2,D2,STL,32,CS2,STL,16,D2,D4
  .byte E4,FS4,STL,32,G4,STL,16,E4,FS4,G4,A4,STL,48,GS4,A4
  .byte GOT
  .word Square1_loop

Square2:
  .byte STV,3,STP,0,SDU,1,STL,4,E2,D2,E2,D2,E2,D2,E2,D2,E2,D2,E2,D2,STL,48,CS2,STL
  .byte 4,G2,FS2,G2,FS2,G2,FS2,G2,FS2,G2,FS2,G2,FS2,STL,32,E2,STL,16,A2,G2,E2,CS2,D2,A1
  .byte FS1,G1,GS1,GS1,STL,32,A1,STL,16,A2,G2,E2,CS2,D2,A1,FS1,G1,A1,A1
Square2_loop:
  .byte STL,8,D2,D2,D1
  .byte D2,D1,D2,A3,D2,D1,D2,D1,D2,G3,D2,D1,D2,D1,D2,G3,D2,D1,D2,D1,D2,FS3,D2,D1
  .byte D2,D1,D2,E4,D2,FS4,D2,G4,D2,FS4,D2,G4,D2,A4,D2,A4,G2,G4,G2,FS4,G2,E4,A2,A1
  .byte A2,A1,A2,A3,D2,D1,D2,D1,D2,G3,D2,D1,D2,D1,D2,G3,D2,D1,D2,D1,D2,FS3,D2,D1
  .byte D2,D1,D2,E4,D2,FS4,D2,G4,D2,FS4,D2,G4,D2,A4,D2,A4,G2,G4,G2,FS4,G2,E4,A2,A1
  .byte A2,A1,A2,STL,16,FS3,G3,A3,A3,B3,CS4,D4,E4,FS4,A4,G4,FS4,FS3,G3,A3,A3,B3,CS4,D4
  .byte E4,FS4,FS4,E4,D4,STL,32,D4,STL,16,CS4
  .byte GOT
  .word Square2_loop

Triangle:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,18,A0
Triangle_loop:
  .byte STV,2,STP,0,SDU,1,STL,8,D2,D3,D2,D3,D2
  .byte D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2
  .byte D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,G2,G3,G2,G3,G2,G3,A2,A3,A2,A3,A2
  .byte A3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2
  .byte D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,D2,D3,G2,G3,G2,G3,G2,G3,A2,A3,A2,A3,A2
  .byte A3,STL,255,D2,STV,0,STL,81,D2,STV,2,STL,48,E3,A2
  .byte GOT
  .word Triangle_loop

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,18,A0
Noise_loop:
  .byte STV,4,STP,0,SDU,0,STL,8,8,6,8,6,8
  .byte 6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8
  .byte 6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8
  .byte 6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8
  .byte 6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8,6,8
  .byte 6,STV,0,STL,255,8,STL,177,8
  .byte GOT
  .word Noise_loop
.endscope

font1:
  .word font0_patterns
  .byte $0E
  .byte $1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24
  .byte $3f,$20,$3f,$3f,$3f,$04,$14,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
  .byte $3f,$20,$3f,$3f,$3f,$04,$14,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f

;table of decimal powers for creating decimal strings from 8 bit numbers
power_table:
  .byte 100, 10, 1

spaces_string:
  .byte $03,$1a,$1a,$1a
  
press_start_string:
  .byte $0b,$0f,$11,$04,$12,$12,$1a,$12,$13,$00,$11,$13

difficulty_string:
  .byte $0c,$03,$08,$05,$05,$08,$02,$14,$0b,$13,$18,$2b,$1a

easy_string:
  .byte $06,$04,$00,$12,$18,$1a,$1a

normal_string:
  .byte $06,$0d,$0e,$11,$0c,$00,$0b

hard_string:
  .byte $06,$07,$00,$11,$03,$1a,$1a

unfair_string:
  .byte $06,$14,$0d,$05,$00,$08,$11

gradual_games_string:
  .byte $0d,$06,$11,$00,$03,$14,$00,$0b,$1a,$06,$00,$0c,$04,$12

copyright_c_2012_string:
  .byte $10,$02,$0e,$0f,$18,$11,$08,$06,$07,$13,$1a,$2e,$1a,$1d,$1b,$1c,$1d

revision_string:
  .byte $05,$11,$1c,$1c,$1b,$22

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

the_string:
  .byte $03,$13,$07,$04

;heart sprite for menu selections
heart:
  .byte $01
  .byte $00,$2a,$01,$00,$00

solomon_snow_watching_birds_slide:
  .word solomon_snow_watching_birds_caption
  .byte 150
  .byte 5
  .byte 3

portal_appears_slide:
  .word portal_appears_caption
  .byte 150
  .byte 5
  .byte 6

arm_snatches_snow_slide:
  .word arm_snatches_snow_caption
  .byte 150
  .byte 5
  .byte 5

leapt_through_portal_slide:
  .word leapt_through_portal_caption
  .byte 150
  .byte 5
  .byte 4

became_nomolos_slide:
  .word became_nomolos_caption
  .byte 150
  .byte 5
  .byte 3

nomolos_sets_out_slide:
  .word nomolos_sets_out_caption
  .byte 250
  .byte 5
  .byte 4

.ifdef DEMO_BUILD
thanks_for_playing_demo_slide:
  .word thanks_for_playing_demo_caption
  .byte 250
  .byte 5
  .byte 5

.endif

.ifndef DEMO_BUILD
nomolos_and_snow_reunited_slide:
  .word nomolos_and_snow_reunited_caption
  .byte 150
  .byte 5
  .byte 5

portal_appears_above_scepter_slide:
  .word portal_appears_above_scepter_caption
  .byte 150
  .byte 5
  .byte 5

leapt_through_ending_portal_slide:
  .word leapt_through_ending_portal_caption
  .byte 150
  .byte 5
  .byte 5

thanks_for_playing_slide:
  .word thanks_for_playing_caption
  .byte 150
  .byte 5
  .byte 5

by_gradual_games_slide:
  .word by_gradual_games_caption
  .byte 150
  .byte 5
  .byte 8

derek_andrews_slide:
  .word derek_andrews_caption
  .byte 150
  .byte 5
  .byte 9

laurie_andrews_slide:
  .word laurie_andrews_caption
  .byte 150
  .byte 5
  .byte 8

daniel_hwozdek_slide:
  .word daniel_hwozdek_caption
  .byte 150
  .byte 5
  .byte 6

music_by_slide:
  .word music_by_caption
  .byte 150
  .byte 5
  .byte 11

beta_testers_slide:
  .word beta_testers_caption
  .byte 150
  .byte 5
  .byte 8

production_slide:
  .word production_caption
  .byte 150
  .byte 5
  .byte 8

printed_materials_slide:
  .word printed_materials_caption
  .byte 150
  .byte 5
  .byte 7

promotion_social_media_slide:
  .word promotion_social_media_caption
  .byte 150
  .byte 5
  .byte 9

special_thanks_slide:
  .word special_thanks_caption
  .byte 150
  .byte 5
  .byte 7

nesdev_slide:
  .word nesdev_caption
  .byte 150
  .byte 5
  .byte 7

nintendoage_slide:
  .word nintendoage_caption
  .byte 150
  .byte 5
  .byte 4

secret_message_slide:
  .word secret_message_caption
  .byte 250
  .byte 5
  .byte 4

.endif

title_slide:
  .word title_palette
  .word title_nametable
  .word title_patterns
  .byte 1
  .byte 14
  .byte 10

gradual_games_logo_slide:
  .word gradual_games_logo_palette
  .word gradual_games_logo_nametable
  .word gradual_games_logo_chr
  .byte 150
  .byte 11
  .byte 11

slide1:
  .word slide1_palette
  .word slide1_nametable
  .word slide1_chr
  .byte 150
  .byte 10
  .byte 10

slide2:
  .word slide2_palette
  .word slide2_nametable
  .word slide2_chr
  .byte 150
  .byte 10
  .byte 10

slide3:
  .word slide3_palette
  .word slide3_nametable
  .word slide3_chr
  .byte 150
  .byte 10
  .byte 10

slide4:
  .word slide4_palette
  .word slide4_nametable
  .word slide4_chr
  .byte 150
  .byte 7
  .byte 7

slide5:
  .word slide5_palette
  .word slide5_nametable
  .word slide5_chr
  .byte 250
  .byte 7
  .byte 7

.ifndef DEMO_BUILD
ending_slide1:
  .word ending_slide1_palette
  .word ending_slide1_nametable
  .word ending_slide1_chr
  .byte 250
  .byte 7
  .byte 7

ending_slide2:
  .word ending_slide2_palette
  .word ending_slide2_nametable
  .word ending_slide2_chr
  .byte 250
  .byte 12
  .byte 12

ending_slide3:
  .word ending_slide3_palette
  .word ending_slide3_nametable
  .word ending_slide3_chr
  .byte 250
  .byte 12
  .byte 6
.endif

difficulty_table:
  .byte 1  ;unfair
  .byte 3  ;normal
  .byte 5  ;easy
