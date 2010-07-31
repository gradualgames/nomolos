.include "level1.inc"
.include "level2.inc"
.include "level3.inc"
.include "boss1.inc"
.include "entities.inc"
.include "soundengine.inc"
.include "fixedBankData.inc"
.include "titleState.inc"
.include "levelInState.inc"
.include "levelOutState.inc"
.include "loadLevelState.inc"
.include "gameOverState.inc"
.include "playLevelState.inc"
.include "zp.inc"

.segment "ROM4"

.include "font0_patterns_source.inc"
.include "title_patterns_source.inc"

.segment "CODE"

;this routine takes the value in the accumulator and
;looks up a state in the state table and then changes the current
;update and ppu routines to the values found there.
;inputs: x is assumed to contain index of state
.proc switch_state

  ;load address of update routine
  lda state_table,x
  sta update
  lda state_table+1,x
  sta update+1
  
  ;load address of ppu update routine
  lda state_table+2,x
  sta update_ppu
  lda state_table+3,x
  sta update_ppu+1

  rts
.endproc

;state table
state_table:
  .word title_state_update
  .word title_state_update_ppu
  .word level_in_state_update
  .word level_in_state_update_ppu
  .word level_out_state_update
  .word level_out_state_update_ppu
  .word load_level_state_update
  .word load_level_state_update_ppu
  .word game_over_state_update
  .word game_over_state_update_ppu
  .word play_level_state_update
  .word play_level_state_update_ppu

;level definitions

level_definition_table:
Level1:
  .word ROMDefinitionTable0
Level2:
  .word ROMDefinitionTable1
Level3:
  .word ROMDefinitionTable2
Boss1:
  .word ROMDefinitionTable3

;ROM definition table
ROMDefinitionTable0:
  .byte spritesheet_1_bank
  .byte level_1_bank
  .byte level_1_patterns_bank  
  .word level1_patterns
  .byte spritesheet_1_patterns_bank
  .word level1_sprite_groups
  .word 0 ;CyclingPaletteAddress
  .byte 0 ;CyclingPaletteSpeed
  
  .word spritesheet1_NomolosWalk
  .word spritesheet1_NomolosWalkOverlay
  .word spritesheet1_NomolosJump
  .word spritesheet1_NomolosJumpOverlay
  .word spritesheet1_NomolosFight
  .word spritesheet1_NomolosFightOverlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_NomolosFlailOverlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_NomolosFightOverlay
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
  .word $0000 ;Skelekin
  .word spritesheet1_BatFly
  .word spritesheet1_Batree
  .word spritesheet1_OwlFly
  .word spritesheet1_OwlAttack
  .word spritesheet1_SnufferRun
  .word spritesheet1_SnufferBite
  .word $0000 ;spritesheet1_SnailCrawl
  .word $0000 ;spritesheet1_DragonFly
  .word $0000 ;spritesheet1_IceBallFly
  .word $0000 ;spritesheet1_SharkLeap

  .word attackSound
  .word hitSound
  .word level1_palette
 
  .byte 120 ;nomolos_start_x
  .byte 90  ;nomolos_start_y
 
  .byte 1 ;camera_scroll_enabled
  .byte 0 ;starting_screen
  .word level1_map
  .word level1_map_column_table
  .word level1_attribute_column_table
  .word level1_meta_tile_column_table
  .word level1_meta_tile_table

  .word EntityDefinitionTable
  
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

;ROM definition table
ROMDefinitionTable1:
  .byte spritesheet_1_bank
  .byte level_2_bank
  .byte level_2_patterns_bank  
  .word level2_patterns
  .byte spritesheet_1_patterns_bank
  .word level2_sprite_groups
  .word level2_cycling_palettes ;CyclingPaletteAddress
  .byte 5 ;CyclingPaletteSpeed
  
  .word spritesheet1_NomolosWalk
  .word spritesheet1_NomolosWalkOverlay
  .word spritesheet1_NomolosJump
  .word spritesheet1_NomolosJumpOverlay
  .word spritesheet1_NomolosFight
  .word spritesheet1_NomolosFightOverlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_NomolosFlailOverlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_NomolosFightOverlay
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
  .word $0000 ;Batree
  .word $0000 ;spritesheet1_OwlFly
  .word $0000 ;spritesheet1_OwlAttack
  .word $0000 ;spritesheet1_SnufferRun
  .word $0000 ;spritesheet1_SnufferBite
  .word $0000 ;spritesheet1_SnailCrawl
  .word $0000 ;spritesheet1_DragonFly
  .word $0000 ;spritesheet1_IceBallFly
  .word $0000 ;spritesheet1_SharkLeap

  .word attackSound
  .word hitSound
  .word level2_palette

  .byte 120 ;nomolos_start_x
  .byte 90  ;nomolos_start_y
  
  .byte 1 ;camera_scroll_enabled
  .byte 0 ;starting_screen
  .word level2_map
  .word level2_map_column_table
  .word level2_attribute_column_table
  .word level2_meta_tile_column_table
  .word level2_meta_tile_table

  .word EntityDefinitionTable
  .word level2_music
  .byte level_3_index

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

;ROM definition table
ROMDefinitionTable2:
  .byte spritesheet_1_bank
  .byte level_3_bank
  .byte level_3_patterns_bank  
  .word level3_patterns
  .byte spritesheet_1_patterns_bank
  .word level3_sprite_groups
  .word level3_cycling_palettes ;CyclingPaletteAddress
  .byte 10 ;CyclingPaletteSpeed
  
  .word spritesheet1_NomolosWalk
  .word spritesheet1_NomolosWalkOverlay
  .word spritesheet1_NomolosJump
  .word spritesheet1_NomolosJumpOverlay
  .word spritesheet1_NomolosFight
  .word spritesheet1_NomolosFightOverlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_NomolosFlailOverlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_NomolosFightOverlay
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
  .word $0000 ;Batree
  .word $0000 ;OwlFly
  .word $0000 ;OwlAttack
  .word $0000 ;SnufferRun
  .word $0000 ;SnufferBite
  .word spritesheet1_SnailCrawl
  .word spritesheet1_DragonFly
  .word spritesheet1_IceBallFly
  .word spritesheet1_SharkLeap

  .word attackSound
  .word hitSound
  .word level3_palette

  .byte 30  ;nomolos_start_x
  .byte 100 ;nomolos_start_y
  
  .byte 1 ;camera_scroll_enabled
  .byte 0 ;starting_screen
  .word level3_map
  .word level3_map_column_table
  .word level3_attribute_column_table
  .word level3_meta_tile_column_table
  .word level3_meta_tile_table

  .word EntityDefinitionTable
  .word level3_music
  .byte boss_1_index
  
  .byte level3_sprites_Nomolos_chr_index
  .byte 0 ;level3_sprites_Deentle_chr_index
  .byte level3_sprites_Explosion_chr_index
  .byte 0 ;level3_sprites_Beedie_chr_index
  .byte 0 ;level3_sprites_Grank_chr_index
  .byte 0 ;level3_sprites_Bat_chr_index
  .byte 0 ;level3_sprites_Skelekin_chr_index
  .byte 0 ;level3_sprites_Batree_chr_index
  .byte 0 ;level3_sprites_Owl_chr_index
  .byte 0 ;level3_sprites_Snuffer_chr_index
  .byte level3_sprites_Snail_chr_index  
  .byte level3_sprites_Dragon_chr_index
  .byte level3_sprites_IceBall_chr_index
  .byte level3_sprites_Shark_chr_index
  
;ROM definition table
ROMDefinitionTable3:
  .byte spritesheet_1_bank
  .byte boss_1_bank
  .byte boss_1_patterns_bank  
  .word boss1_patterns
  .byte spritesheet_1_patterns_bank
  .word boss1_sprite_groups
  .word 0 ;CyclingPaletteAddress
  .byte 0 ;CyclingPaletteSpeed
  
  .word spritesheet1_NomolosWalk
  .word spritesheet1_NomolosWalkOverlay
  .word spritesheet1_NomolosJump
  .word spritesheet1_NomolosJumpOverlay
  .word spritesheet1_NomolosFight
  .word spritesheet1_NomolosFightOverlay
  .word spritesheet1_NomolosUseFlail
  .word spritesheet1_NomolosFlailOverlay
  .word spritesheet1_NomolosUseSpear
  .word spritesheet1_NomolosFightOverlay
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
  .word 0 ;Batree
  .word 0 ;OwlFly
  .word 0 ;OwlAttack
  .word 0 ;SnufferRun
  .word 0 ;SnufferBite
  .word 0 ;spritesheet1_SnailCrawl
  .word 0 ;spritesheet1_DragonFly
  .word spritesheet1_IceBallFly
  .word 0 ;spritesheet1_SharkLeap

  .word attackSound
  .word hitSound
  .word boss1_palette

  .byte 20   ;nomolos_start_x
  .byte 160  ;nomolos_start_y
  
  .byte 0 ;camera_scroll_enabled
  .byte 0 ;starting_screen
  .word boss1_map
  .word boss1_map_column_table
  .word boss1_attribute_column_table
  .word boss1_meta_tile_column_table
  .word boss1_meta_tile_table

  .word EntityDefinitionTable
  .word boss1_music
  .byte level_1_index
  
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
  
;Entities
EntityDefinitionTable:
DeentleEntity:
  .word deentle_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $05
  .byte $00
  .byte $00
ExplosionEntity:
  .word explosion_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $0A
  .byte $00
  .byte $00
MouseEntity:
  .word mouse_update
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $0A
  .byte $00
  .byte $00
ExitLevelEntity:
  .word exit_level_update
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $02
  .byte $00
  .byte $00
OneUpEntity:
  .word oneup_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $0A
  .byte $00
  .byte $00
FlailItemEntity:
  .word flail_item_update
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $0A
  .byte $00
  .byte $00
BeedieEntity:
  .word beedie_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $05
  .byte $00
  .byte $00
GrankEntity:
  .word grank_update
  .byte $00
  .byte $e9
  .byte %00000000
  .byte $05
  .byte $00
  .byte $00
SpearItemEntity:
  .word spear_item_update
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $0A
  .byte $00
  .byte $00
SkelekinEntity:
  .word skelekin_update
  .byte $00
  .byte $10
  .byte %00000000
  .byte $05
  .byte $00
  .byte $00
BatEntity:
  .word bat_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $0A
  .byte $00
  .byte $00
Batree:
  .word batree_update
  .byte $00
  .byte $18
  .byte %00000000
  .byte $01
  .byte $00
  .byte $00
Owl:
  .word owl_update
  .byte $00
  .byte $10
  .byte %00000000
  .byte $01
  .byte $00
  .byte $00
Snuffer:
  .word snuffer_update
  .byte $00
  .byte $08
  .byte %00000000
  .byte $01
  .byte $00
  .byte $00
Snail:
  .word snail_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $01
  .byte $00
  .byte $00
Dragon:
  .word dragon_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $01
  .byte $00
  .byte $00
IceBall:
  .word iceball_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $0a
  .byte $00
  .byte $00
Shark:
  .word shark_update
  .byte $00
  .byte $00
  .byte %00000000
  .byte $05
  .byte $00
  .byte $00
  
attackSound:
  .byte STL, 10
  .byte STV, SOUND_EFFECT_BASE+5
  .byte STP, SOUND_EFFECT_BASE+1
  .byte 3
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM
  
attackFlailSound:
  .byte STL, 10
  .byte STV, SOUND_EFFECT_BASE+5
  .byte STP, SOUND_EFFECT_BASE+1
  .byte 12
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM
  
attackSpearSound:
  .byte STL, 20
  .byte STV, SOUND_EFFECT_BASE+6
  .byte STP, SOUND_EFFECT_BASE+1
  .byte 5
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

hitSound:
  .byte STL, 2
  .byte STV, SOUND_EFFECT_BASE+3
  .byte STP, SOUND_EFFECT_BASE+1
  .byte 11, 12, 13
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

getHurtSound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte C5, B4, A4, G4, F4, E4, D4, C4
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

dieSound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte C6, B5, A5, G5, F5, E5, D5, CS5
  .byte C5, B4, A4, G4, F4, E4, D4, C4
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

getHealthSound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte A4,C5,E4,A3,C6,E7
  .byte A4,C5,E4,A3,C6,E7
  .byte TRM

getItemSound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte A4, AS4, B4, C5, CS5, D5, DS5, E5
  .byte A4, AS4, B4, C5, CS5, D5, DS5, E5
  .byte TRM

;miscellaneous data
banktable:
  .byte $00, $01, $02, $03, $04, $05, $06, $07

title_music: 
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

  .word sf_volume_envelope_silence
  .word sf_volume_envelope_loud
  .word sf_volume_envelope_1
  .word sf_volume_envelope_decay
  .word sf_volume_envelope_short_note

  .word sf_volume_envelope_fade_in
  .word sf_volume_envelope_fade_in_2
  .word 0
  .word 0
  .word 0

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
  
  .word sf_pitch_envelope_0
  .word sf_pitch_envelope_1
  .word 0
  .word 0
  .word 0

  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

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
  
sf_volume_envelope_silence:
  .byte 0, ENV_STOP

sf_volume_envelope_loud:
  .byte 15, ENV_STOP

sf_volume_envelope_1:
  .byte 14, 12, 11, 9, 7, 6, 4, 2, 1, 0, 0, 2, 3, 5, 8, 6, 3, 1, ENV_STOP
  
sf_volume_envelope_decay:
  .byte 15, 14, 12, 8, 7, 6, 3, 1, 0, ENV_STOP
  
sf_volume_envelope_short_note:
  .byte 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, ENV_STOP
  
sf_volume_envelope_fade_in:
  .byte 0, 1, 3, 6, 7, 8, 12, 14, 15, ENV_STOP
  
sf_volume_envelope_fade_in_2:
  .byte 5, 8, 10, 10, 12, 12, 15, 15, 10, 10, 6, 6, 3, 3, 0, 0, 0, ENV_STOP
  
sf_pitch_envelope_0:
  .byte 0, ENV_LOOP
  
sf_pitch_envelope_1: 
  .byte 0, 1, 2, 3, 4, 5, 4, 3, 2, 1, -1, -2, -3, -4, -5, ENV_LOOP

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

font1:
  .word font0_patterns
  .byte $04
  .byte $1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24
.include "font0_palette_source.inc"

;table of decimal powers for creating decimal strings from 8 bit numbers
powerTable:
  .byte 100, 10, 1

press_start_string:
  .byte $0b,$0f,$11,$04,$12,$12,$1a,$12,$13,$00,$11,$13
  
lda_games_string:
  .byte $0c,$01,$18,$1a,$0b,$03,$00,$1a,$06,$00,$0c,$04,$12
 
copyright_c_2010_string:
  .byte $08,$2c,$02,$2d,$1a,$1d,$1b,$1c,$1b
  
levelString:
  .byte $06,$0b,$04,$15,$04,$0b,$1a

livesString:
  .byte $06,$0b,$08,$15,$04,$12,$1a

gameOverString:
  .byte $09,$06,$00,$0c,$04,$1a,$0e,$15,$04,$11


titleDef:
  .word title_palette
  .word title_nametable
  .word title_patterns
  .byte $04

.include "title_palette_source.inc"
.include "title_nametable_source.inc"
