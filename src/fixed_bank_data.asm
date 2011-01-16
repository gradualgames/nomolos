.include "level1.inc"
.include "level1_2.inc"
.include "level2.inc"
.include "level2_2.inc"
.include "level3.inc"
.include "level4.inc"
.include "boss1.inc"
.include "entities.inc"
.include "soundengine.inc"
.include "fixed_bank_data.inc"
.include "title_state.inc"
.include "level_in_state.inc"
.include "load_level_state.inc"
.include "game_over_state.inc"
.include "play_level_state.inc"
.include "zp.inc"
.include "sound_effects.inc"

;output the size of the level data struct to the console
.out .sprintf(".sizezof(level_data_struct) is %i", .sizeof(level_data_struct))

.segment "ROM14"

.include "font0_patterns_source.inc"
.include "title_patterns_source.inc"

.segment "CODE"

;level definitions

level_definition_table:
  .word level1_data
  .word level1_2data
  .word level2_data
  .word level2_2data
  .word level3_data
  .word boss1_data
  .word level4_data

;level intro strings
level1_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$1c
level1_2_intro_string:
  .byte $09,$0b,$04,$15,$04,$0b,$1a,$1c,$2b,$1d
level2_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$1d
level2_2intro_string:
  .byte $09,$0b,$04,$15,$04,$0b,$1a,$1d,$2b,$1d
level3_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$1e
level4_intro_string:
  .byte $07,$0b,$04,$15,$04,$0b,$1a,$1f
boss1_intro_string:
  .byte $06,$0d,$0e,$06,$00,$11,$03
  
;ROM definition table
level1_data:
  .byte spritesheet_1_bank
  .byte level_1_bank
  .byte level_1_patterns_bank
  .word level1_patterns
  .byte spritesheet_1_patterns_bank
  .word level1_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 0 ;cycling_palette_speed

  .word spritesheet1_NomolosWalk
  .word spritesheet1_nomolos_walk_overlay
  .word spritesheet1_nomolos_jump
  .word spritesheet1_nomolos_jump_overlay
  .word spritesheet1_nomolos_fight
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_nomolos_flail_overlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_FlailBall
  .word spritesheet1_Spear0
  .word spritesheet1_SlumpedArmor0
  .word spritesheet1_SlumpedArmorOverlay0
  .word spritesheet1_ScardyCat0
  .word spritesheet1_ScardyCatOverlay0
  .word spritesheet1_Heart0

  .word spritesheet1_Spear0
  .word spritesheet1_GrankFly
  .word spritesheet1_BeedieBlob
  .word spritesheet1_FlailItem0
  .word spritesheet1_DeentleWalk
  .word spritesheet1_Explosion
  .word spritesheet1_Mouse
  .word spritesheet1_OneUp0
  .word 0 ;Skelekin
  .word spritesheet1_BatFly
  .word spritesheet1_Batree
  .word spritesheet1_OwlFly
  .word spritesheet1_OwlAttack
  .word spritesheet1_SnufferRun
  .word spritesheet1_SnufferBite
  .word 0 ;spritesheet1_SnailCrawl
  .word 0 ;spritesheet1_DragonFly
  .word 0 ;spritesheet1_IceBallFly
  .word 0 ;spritesheet1_SharkLeap
  .word 0 ;spritesheet1_Stalactite0
  .word 0 ;dragonboss_face_mouthshut
  .word 0 ;dragonboss_face_mouthopen
  .word 0 ;spritesheet1_PhoenixFly
  .word 0 ;spritesheet1_FireballFly
  .word 0 ;spritesheet1_SnakeSlither
  .word 0 ;spritesheet1_FireGuy0
  .word 0 ;spritesheet1_FireGuy1

  .word attack_sound
  .word hit_sound
  .word level1_palette

  .byte 120 ;nomolos_start_x
  .byte 191 ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level1_intro_string
  .byte 1 ;camera_scroll_enabled  
  .word level1_map
  .word level1_map_column_table
  .word level1_attribute_column_table
  .word level1_meta_tile_column_table
  .word level1_meta_tile_table

  .word entity_definition_table

  .word level1_music

  .byte level_1_2_index

  .byte level1_sprites_Nomolos_chr_index
  .byte level1_sprites_Deentle_chr_index
  .byte level1_sprites_Explosion_chr_index
  .byte level1_sprites_Beedie_chr_index
  .byte level1_sprites_Grank_chr_index
  .byte level1_sprites_Bat_chr_index
  .byte 0 ;level1_sprites_Skelekin_chr_index
  .byte level1_sprites_Batree_chr_index
  .byte level1_sprites_Owl_chr_index
  .byte level1_sprites_Snuffer_chr_index
  .byte 0 ;level1_sprites_Snail_chr_index
  .byte 0 ;level1_sprites_Dragon_chr_index
  .byte 0 ;level1_sprites_IceBall_chr_index
  .byte 0 ;level1_sprites_Shark_chr_index
  .byte 0 ;level1_sprites_Stalactite_chr_index
  .byte 0 ;dragonboss_offset
  .byte 0 ;level1_sprites_Phoenix_chr_index
  .byte 0 ;level1_sprites_Fireball_chr_index
  .byte 0 ;level1_sprites_Snake_chr_index
  .byte 0 ;level1_sprites_FireGuy_chr_index

;ROM definition table
level1_2data:
  .byte spritesheet_1_bank
  .byte level_1_2bank
  .byte level_1_2patterns_bank
  .word level1_patterns
  .byte spritesheet_1_patterns_bank
  .word level1_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 0 ;cycling_palette_speed

  .word spritesheet1_NomolosWalk
  .word spritesheet1_nomolos_walk_overlay
  .word spritesheet1_nomolos_jump
  .word spritesheet1_nomolos_jump_overlay
  .word spritesheet1_nomolos_fight
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_nomolos_flail_overlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_FlailBall
  .word spritesheet1_Spear0
  .word spritesheet1_SlumpedArmor0
  .word spritesheet1_SlumpedArmorOverlay0
  .word spritesheet1_ScardyCat0
  .word spritesheet1_ScardyCatOverlay0
  .word spritesheet1_Heart0

  .word spritesheet1_Spear0
  .word spritesheet1_GrankFly
  .word spritesheet1_BeedieBlob
  .word spritesheet1_FlailItem0
  .word spritesheet1_DeentleWalk
  .word spritesheet1_Explosion
  .word spritesheet1_Mouse
  .word spritesheet1_OneUp0
  .word 0 ;Skelekin
  .word spritesheet1_BatFly
  .word spritesheet1_Batree
  .word spritesheet1_OwlFly
  .word spritesheet1_OwlAttack
  .word spritesheet1_SnufferRun
  .word spritesheet1_SnufferBite
  .word 0 ;spritesheet1_SnailCrawl
  .word 0 ;spritesheet1_DragonFly
  .word 0 ;spritesheet1_IceBallFly
  .word 0 ;spritesheet1_SharkLeap
  .word 0 ;spritesheet1_Stalactite0
  .word 0 ;dragonboss_face_mouthshut
  .word 0 ;dragonboss_face_mouthopen
  .word 0 ;spritesheet1_PhoenixFly
  .word 0 ;spritesheet1_FireballFly
  .word 0 ;spritesheet1_SnakeSlither
  .word 0 ;spritesheet1_FireGuy0
  .word 0 ;spritesheet1_FireGuy1

  .word attack_sound
  .word hit_sound
  .word level1_2palette

  .byte 120 ;nomolos_start_x
  .byte 159 ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level1_2_intro_string
  .byte 1 ;camera_scroll_enabled  
  .word level1_2map
  .word level1_2map_column_table
  .word level1_2attribute_column_table
  .word level1_2meta_tile_column_table
  .word level1_2meta_tile_table

  .word entity_definition_table

  .word level1_music

  .byte level_2_index

  .byte level1_sprites_Nomolos_chr_index
  .byte level1_sprites_Deentle_chr_index
  .byte level1_sprites_Explosion_chr_index
  .byte level1_sprites_Beedie_chr_index
  .byte level1_sprites_Grank_chr_index
  .byte level1_sprites_Bat_chr_index
  .byte 0 ;level1_sprites_Skelekin_chr_index
  .byte level1_sprites_Batree_chr_index
  .byte level1_sprites_Owl_chr_index
  .byte level1_sprites_Snuffer_chr_index
  .byte 0 ;level1_sprites_Snail_chr_index
  .byte 0 ;level1_sprites_Dragon_chr_index
  .byte 0 ;level1_sprites_IceBall_chr_index
  .byte 0 ;level1_sprites_Shark_chr_index
  .byte 0 ;level1_sprites_Stalactite_chr_index
  .byte 0 ;dragonboss_offset
  .byte 0 ;level1_sprites_Phoenix_chr_index
  .byte 0 ;level1_sprites_Fireball_chr_index
  .byte 0 ;level1_sprites_Snake_chr_index
  .byte 0 ;level1_sprites_FireGuy_chr_index
  
;ROM definition table
level2_data:
  .byte spritesheet_1_bank
  .byte level_2_bank
  .byte level_2_patterns_bank
  .word level2_patterns
  .byte spritesheet_1_patterns_bank
  .word level2_sprite_groups
  .word level2_cycling_palettes ;cycling_palette_address
  .byte 5 ;cycling_palette_speed

  .word spritesheet1_NomolosWalk
  .word spritesheet1_nomolos_walk_overlay
  .word spritesheet1_nomolos_jump
  .word spritesheet1_nomolos_jump_overlay
  .word spritesheet1_nomolos_fight
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_nomolos_flail_overlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_FlailBall
  .word spritesheet1_Spear0
  .word spritesheet1_SlumpedArmor0
  .word spritesheet1_SlumpedArmorOverlay0
  .word spritesheet1_ScardyCat0
  .word spritesheet1_ScardyCatOverlay0

  .word spritesheet1_Heart0
  .word spritesheet1_Spear0
  .word spritesheet1_GrankFly
  .word spritesheet1_BeedieBlob
  .word spritesheet1_FlailItem0
  .word spritesheet1_DeentleWalk
  .word spritesheet1_Explosion
  .word spritesheet1_Mouse
  .word spritesheet1_OneUp0
  .word spritesheet1_SkelekinWalk
  .word spritesheet1_BatFly
  .word $0000 ;batree
  .word $0000 ;spritesheet1_OwlFly
  .word $0000 ;spritesheet1_OwlAttack
  .word $0000 ;spritesheet1_SnufferRun
  .word $0000 ;spritesheet1_SnufferBite
  .word $0000 ;spritesheet1_SnailCrawl
  .word $0000 ;spritesheet1_DragonFly
  .word $0000 ;spritesheet1_IceBallFly
  .word $0000 ;spritesheet1_SharkLeap
  .word $0000 ;spritesheet1_Stalactite0
  .word 0 ;dragonboss_face_mouthshut
  .word 0 ;dragonboss_face_mouthopen
  .word 0 ;spritesheet1_PhoenixFly
  .word 0 ;spritesheet1_FireballFly
  .word 0 ;spritesheet1_SnakeSlither
  .word 0 ;spritesheet1_FireGuy0
  .word 0 ;spritesheet1_FireGuy1
  
  .word attack_sound
  .word hit_sound
  .word level2_palette

  .byte 120 ;nomolos_start_x
  .byte 90  ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level2_intro_string
  .byte 1 ;camera_scroll_enabled  
  .word level2_map
  .word level2_map_column_table
  .word level2_attribute_column_table
  .word level2_meta_tile_column_table
  .word level2_meta_tile_table

  .word entity_definition_table
  .word level2_music
  .byte level_2_2_index

  .byte level2_sprites_Nomolos_chr_index
  .byte level2_sprites_Deentle_chr_index
  .byte level2_sprites_Explosion_chr_index
  .byte level2_sprites_Beedie_chr_index
  .byte level2_sprites_Grank_chr_index
  .byte level2_sprites_Bat_chr_index
  .byte level2_sprites_Skelekin_chr_index
  .byte 0 ;level2_sprites_Batree_chr_index
  .byte 0 ;level2_sprites_Owl_chr_index
  .byte 0 ;level2_sprites_Snuffer_chr_index
  .byte 0 ;level2_sprites_Snail_chr_index
  .byte 0 ;level2_sprites_Dragon_chr_index
  .byte 0 ;level2_sprites_IceBall_chr_index
  .byte 0 ;level2_sprites_Shark_chr_index
  .byte 0 ;level2_sprites_Stalactite_chr_index
  .byte 0 ;dragonboss_offset
  .byte 0 ;level2_sprites_Phoenix_chr_index
  .byte 0 ;level2_sprites_Fireball_chr_index
  .byte 0 ;level2_sprites_Snake_chr_index
  .byte 0 ;level2_sprites_FireGuy_chr_index

;ROM definition table
level2_2data:
  .byte spritesheet_1_bank
  .byte level2_2bank
  .byte level_2_patterns_bank
  .word level2_patterns
  .byte spritesheet_1_patterns_bank
  .word level2_sprite_groups
  .word level2_2cycling_palettes ;cycling_palette_address
  .byte 5 ;cycling_palette_speed

  .word spritesheet1_NomolosWalk
  .word spritesheet1_nomolos_walk_overlay
  .word spritesheet1_nomolos_jump
  .word spritesheet1_nomolos_jump_overlay
  .word spritesheet1_nomolos_fight
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_nomolos_flail_overlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_FlailBall
  .word spritesheet1_Spear0
  .word spritesheet1_SlumpedArmor0
  .word spritesheet1_SlumpedArmorOverlay0
  .word spritesheet1_ScardyCat0
  .word spritesheet1_ScardyCatOverlay0

  .word spritesheet1_Heart0
  .word spritesheet1_Spear0
  .word spritesheet1_GrankFly
  .word spritesheet1_BeedieBlob
  .word spritesheet1_FlailItem0
  .word spritesheet1_DeentleWalk
  .word spritesheet1_Explosion
  .word spritesheet1_Mouse
  .word spritesheet1_OneUp0
  .word spritesheet1_SkelekinWalk
  .word spritesheet1_BatFly
  .word $0000 ;batree
  .word $0000 ;spritesheet1_OwlFly
  .word $0000 ;spritesheet1_OwlAttack
  .word $0000 ;spritesheet1_SnufferRun
  .word $0000 ;spritesheet1_SnufferBite
  .word $0000 ;spritesheet1_SnailCrawl
  .word $0000 ;spritesheet1_DragonFly
  .word $0000 ;spritesheet1_IceBallFly
  .word $0000 ;spritesheet1_SharkLeap
  .word $0000 ;spritesheet1_Stalactite0
  .word 0 ;dragonboss_face_mouthshut
  .word 0 ;dragonboss_face_mouthopen
  .word 0 ;spritesheet1_PhoenixFly
  .word 0 ;spritesheet1_FireballFly
  .word 0 ;spritesheet1_SnakeSlither
  .word 0 ;spritesheet1_FireGuy0
  .word 0 ;spritesheet1_FireGuy1
  
  .word attack_sound
  .word hit_sound
  .word level2_2palette

  .byte 104 ;nomolos_start_x
  .byte 0   ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level2_2intro_string
  .byte 1 ;camera_scroll_enabled  
  .word level2_2map
  .word level2_2map_column_table
  .word level2_2attribute_column_table
  .word level2_2meta_tile_column_table
  .word level2_2meta_tile_table

  .word entity_definition_table
  .word level2_2music
  .byte level_3_index

  .byte level2_2sprites_Nomolos_chr_index
  .byte level2_2sprites_Deentle_chr_index
  .byte level2_2sprites_Explosion_chr_index
  .byte level2_2sprites_Beedie_chr_index
  .byte level2_2sprites_Grank_chr_index
  .byte level2_2sprites_Bat_chr_index
  .byte level2_2sprites_Skelekin_chr_index
  .byte 0 ;level2_sprites_Batree_chr_index
  .byte 0 ;level2_sprites_Owl_chr_index
  .byte 0 ;level2_sprites_Snuffer_chr_index
  .byte 0 ;level2_sprites_Snail_chr_index
  .byte 0 ;level2_sprites_Dragon_chr_index
  .byte 0 ;level2_sprites_IceBall_chr_index
  .byte 0 ;level2_sprites_Shark_chr_index
  .byte 0 ;level2_sprites_Stalactite_chr_index
  .byte 0 ;dragonboss_offset
  .byte 0 ;level2_sprites_Phoenix_chr_index
  .byte 0 ;level2_sprites_Fireball_chr_index
  .byte 0 ;level2_sprites_Snake_chr_index
  .byte 0 ;level2_sprites_FireGuy_chr_index
  
;ROM definition table
level3_data:
  .byte spritesheet_1_bank
  .byte level_3_bank
  .byte level_3_patterns_bank
  .word level3_patterns
  .byte spritesheet_1_patterns_bank
  .word level3_sprite_groups
  .word level3_cycling_palettes ;cycling_palette_address
  .byte 10 ;cycling_palette_speed

  .word spritesheet1_NomolosWalk
  .word spritesheet1_nomolos_walk_overlay
  .word spritesheet1_nomolos_jump
  .word spritesheet1_nomolos_jump_overlay
  .word spritesheet1_nomolos_fight
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_nomolos_flail_overlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_FlailBall
  .word spritesheet1_Spear0
  .word spritesheet1_SlumpedArmor0
  .word spritesheet1_SlumpedArmorOverlay0
  .word spritesheet1_ScardyCat0
  .word spritesheet1_ScardyCatOverlay0

  .word spritesheet1_Heart0
  .word spritesheet1_Spear0
  .word spritesheet1_GrankFly
  .word spritesheet1_BeedieBlob
  .word spritesheet1_FlailItem0
  .word spritesheet1_DeentleWalk
  .word spritesheet1_Explosion
  .word spritesheet1_Mouse
  .word spritesheet1_OneUp0
  .word spritesheet1_SkelekinWalk
  .word spritesheet1_BatFly
  .word $0000 ;batree
  .word $0000 ;owl_fly
  .word $0000 ;owl_attack
  .word $0000 ;snuffer_run
  .word $0000 ;snuffer_bite
  .word spritesheet1_SnailCrawl
  .word spritesheet1_DragonFly
  .word spritesheet1_IceBallFly
  .word spritesheet1_SharkLeap
  .word $0000 ;spritesheet1_Stalactite0
  .word $0000 ;dragonboss_face_mouthshut
  .word $0000 ;dragonboss_face_mouthopen
  .word $0000 ;spritesheet1_PhoenixFly
  .word $0000 ;spritesheet1_FireballFly
  .word $0000 ;spritesheet1_SnakeSlither
  .word $0000 ;spritesheet1_FireGuy0
  .word $0000 ;spritesheet1_FireGuy1

  .word attack_sound
  .word hit_sound
  .word level3_palette

  .byte 104 ;nomolos_start_x
  .byte 0   ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word level3_intro_string
  .byte 1 ;camera_scroll_enabled  
  .word level3_map
  .word level3_map_column_table
  .word level3_attribute_column_table
  .word level3_meta_tile_column_table
  .word level3_meta_tile_table

  .word entity_definition_table
  .word level3_music
  .byte boss_1_index

  .byte level3_sprites_Nomolos_chr_index
  .byte 0 ;level3_sprites_Deentle_chr_index
  .byte level3_sprites_Explosion_chr_index
  .byte level3_sprites_Beedie_chr_index
  .byte 0 ;level3_sprites_Grank_chr_index
  .byte level3_sprites_Bat_chr_index
  .byte 0 ;level3_sprites_Skelekin_chr_index
  .byte 0 ;level3_sprites_Batree_chr_index
  .byte 0 ;level3_sprites_Owl_chr_index
  .byte 0 ;level3_sprites_Snuffer_chr_index
  .byte level3_sprites_Snail_chr_index
  .byte level3_sprites_Dragon_chr_index
  .byte level3_sprites_IceBall_chr_index
  .byte level3_sprites_Shark_chr_index
  .byte 0 ;level3_sprites_Stalactite_chr_index
  .byte 0 ;dragonboss_offset
  .byte 0 ;level3_sprites_Phoenix_chr_index
  .byte 0 ;level3_sprites_Fireball_chr_index
  .byte 0 ;level3_sprites_Snake_chr_index
  .byte 0 ;level3_sprites_FireGuy_chr_index

;ROM definition table
boss1_data:
  .byte spritesheet_1_bank
  .byte boss_1_bank
  .byte boss_1_patterns_bank
  .word boss1_patterns
  .byte spritesheet_1_patterns_bank
  .word boss1_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 0 ;cycling_palette_speed

  .word spritesheet1_NomolosWalk
  .word spritesheet1_nomolos_walk_overlay
  .word spritesheet1_nomolos_jump
  .word spritesheet1_nomolos_jump_overlay
  .word spritesheet1_nomolos_fight
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_nomolos_flail_overlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_FlailBall
  .word spritesheet1_Spear0
  .word spritesheet1_SlumpedArmor0
  .word spritesheet1_SlumpedArmorOverlay0
  .word spritesheet1_ScardyCat0
  .word spritesheet1_ScardyCatOverlay0

  .word spritesheet1_Heart0
  .word spritesheet1_Spear0
  .word 0 ;spritesheet1_GrankFly
  .word 0 ;spritesheet1_BeedieBlob
  .word 0 ;spritesheet1_FlailItem0
  .word 0 ;spritesheet1_DeentleWalk
  .word spritesheet1_Explosion
  .word 0 ;spritesheet1_Mouse
  .word 0 ;spritesheet1_OneUp0
  .word 0 ;spritesheet1_SkelekinWalk
  .word 0 ;spritesheet1_BatFly
  .word 0 ;batree
  .word 0 ;owl_fly
  .word 0 ;owl_attack
  .word 0 ;snuffer_run
  .word 0 ;snuffer_bite
  .word 0 ;spritesheet1_SnailCrawl
  .word 0 ;spritesheet1_DragonFly
  .word spritesheet1_IceBallFly
  .word 0 ;spritesheet1_SharkLeap
  .word spritesheet1_Stalactite0
  .word spritesheet1_DragonFace0
  .word spritesheet1_DragonFace1
  .word 0 ;spritesheet1_PhoenixFly
  .word 0 ;spritesheet1_FireballFly
  .word 0 ;spritesheet1_SnakeSlither
  .word 0 ;spritesheet1_FireGuy0
  .word 0 ;spritesheet1_FireGuy1

  .word attack_sound
  .word hit_sound
  .word boss1_palette

  .byte 40  ;nomolos_start_x
  .byte 159 ;nomolos_start_y
  .byte 0   ;starting_screen
  
  .word boss1_intro_string
  .byte 0 ;camera_scroll_enabled  
  .word boss1_map
  .word boss1_map_column_table
  .word boss1_attribute_column_table
  .word boss1_meta_tile_column_table
  .word boss1_meta_tile_table

  .word entity_definition_table
  .word boss1_music
  .byte level_4_index

  .byte boss1_sprites_Nomolos_chr_index
  .byte 0 ;boss1_sprites_Deentle_chr_index
  .byte boss1_sprites_Explosion_chr_index
  .byte 0 ;boss1_sprites_Beedie_chr_index
  .byte 0 ;boss1_sprites_Grank_chr_index
  .byte 0 ;boss1_sprites_Bat_chr_index
  .byte 0 ;boss1_sprites_Skelekin_chr_index
  .byte 0 ;boss1_sprites_Batree_chr_index
  .byte 0 ;boss1_sprites_Owl_chr_index
  .byte 0 ;boss1_sprites_Snuffer_chr_index
  .byte 0 ;boss1_sprites_Snail_chr_index
  .byte 0 ;boss1_sprites_Dragon_chr_index
  .byte boss1_sprites_IceBall_chr_index
  .byte 0 ;boss1_sprites_Shark_chr_index
  .byte boss1_sprites_Stalactite_chr_index
  .byte boss1_sprites_DragonFace_chr_index
  .byte 0 ;boss1_sprites_Phoenix_chr_index
  .byte 0 ;boss1_sprites_Fireball_chr_index
  .byte 0 ;boss1_sprites_Snake_chr_index
  .byte 0 ;boss1_sprites_FireGuy_chr_index

;ROM definition table
level4_data:
  .byte spritesheet_1_bank
  .byte level_4_bank
  .byte level_4_patterns_bank
  .word level4_patterns
  .byte spritesheet_1_patterns_bank
  .word level4_sprite_groups
  .word 0 ;cycling_palette_address
  .byte 0 ;cycling_palette_speed

  .word spritesheet1_NomolosWalk
  .word spritesheet1_nomolos_walk_overlay
  .word spritesheet1_nomolos_jump
  .word spritesheet1_nomolos_jump_overlay
  .word spritesheet1_nomolos_fight
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_nomolos_flail_overlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_nomolos_fight_overlay
  .word spritesheet1_FlailBall
  .word spritesheet1_Spear0
  .word spritesheet1_SlumpedArmor0
  .word spritesheet1_SlumpedArmorOverlay0
  .word spritesheet1_ScardyCat0
  .word spritesheet1_ScardyCatOverlay0

  .word spritesheet1_Heart0
  .word spritesheet1_Spear0
  .word spritesheet1_GrankFly
  .word spritesheet1_BeedieBlob
  .word spritesheet1_FlailItem0
  .word spritesheet1_DeentleWalk
  .word spritesheet1_Explosion
  .word spritesheet1_Mouse
  .word spritesheet1_OneUp0
  .word spritesheet1_SkelekinWalk
  .word spritesheet1_BatFly
  .word $0000 ;batree
  .word $0000 ;owl_fly
  .word $0000 ;owl_attack
  .word $0000 ;snuffer_run
  .word $0000 ;snuffer_bite
  .word spritesheet1_SnailCrawl
  .word spritesheet1_DragonFly
  .word spritesheet1_IceBallFly
  .word spritesheet1_SharkLeap
  .word $0000 ;spritesheet1_Stalactite0
  .word $0000 ;dragonboss_face_mouthshut
  .word $0000 ;dragonboss_face_mouthopen
  .word spritesheet1_PhoenixFly
  .word spritesheet1_FireballFly
  .word spritesheet1_SnakeSlither
  .word spritesheet1_FireGuy1
  .word spritesheet1_FireGuy0

  .word attack_sound
  .word hit_sound
  .word level4_palette

  .byte 30  ;nomolos_start_x
  .byte 100 ;nomolos_start_y
  .byte 0 ;starting_screen
  
  .word level4_intro_string
  .byte 1 ;camera_scroll_enabled  
  .word level4_map
  .word level4_map_column_table
  .word level4_attribute_column_table
  .word level4_meta_tile_column_table
  .word level4_meta_tile_table

  .word entity_definition_table
  .word level4_music
  .byte level_1_index

  .byte level4_sprites_Nomolos_chr_index
  .byte 0 ;level4_sprites_Deentle_chr_index
  .byte level4_sprites_Explosion_chr_index
  .byte 0 ;level4_sprites_Beedie_chr_index
  .byte 0 ;level4_sprites_Grank_chr_index
  .byte 0 ;level4_sprites_Bat_chr_index
  .byte 0 ;level4_sprites_Skelekin_chr_index
  .byte 0 ;level4_sprites_Batree_chr_index
  .byte 0 ;level4_sprites_Owl_chr_index
  .byte 0 ;level4_sprites_Snuffer_chr_index
  .byte 0 ;level4_sprites_Snail_chr_index
  .byte 0 ;level4_sprites_Dragon_chr_index
  .byte 0 ;level4_sprites_IceBall_chr_index
  .byte 0 ;level4_sprites_Shark_chr_index
  .byte 0 ;level4_sprites_Stalactite_chr_index
  .byte 0 ;dragonboss_offset
  .byte level4_sprites_Phoenix_chr_index
  .byte level4_sprites_Fireball_chr_index
  .byte level4_sprites_Snake_chr_index
  .byte level4_sprites_FireGuy_chr_index
  
;Entities
entity_definition_table:
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
  .byte $0E

title_palette:
  .byte $0d,$20,$0d,$0d,$0d,$16,$20,$10,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d
  .byte $0d,$20,$0d,$0d,$0d,$16,$20,$10,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d

.include "title_nametable_source.inc"
