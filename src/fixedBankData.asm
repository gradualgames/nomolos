.include "constants.inc"
.include "level1.inc"
.include "level2.inc"
.include "entities.inc"
.include "soundengine.inc"

.segment "ROM4"

.include "font0_patterns_source.inc"
.include "title_patterns_source.inc"

.segment "CODE"

;level definitions
.export level_definition_table
level_definition_table:
Level1:
  .word ROMDefinitionTable0
Level2:
  .word ROMDefinitionTable1

;ROM definition table
ROMDefinitionTable0:
  .byte sprite_sheet_1_bank
  .byte level_1_bank
  .byte level_1_patterns_bank
  
  .word level1_patterns
  .word spritesheet1_groups
  
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

  .word attackSound
  .word hitSound
  .word level1_palette

  .word level1_map
  .word level1_map_column_table
  .word level1_attribute_column_table
  .word level1_meta_tile_column_table
  .word level1_meta_tile_table

  .word EntityDefinitionTable
  
  .word level1_music
  
  .byte level_2_index

;Nomolos
  .byte 0
;Deentle
  .byte 131
;Explosion
  .byte 139
;Beedie
  .byte 151
;Grank
  .byte 159
;Bat
  .byte 167
;Skelekin
  .byte 0
;Batree
  .byte 171
;Owl
  .byte 189
;Snuffer
  .byte 223

  
;ROM definition table
ROMDefinitionTable1:
  .byte sprite_sheet_1_bank
  .byte level_2_bank
  .byte level_2_patterns_bank
  
  .word level2_patterns
  .word spritesheet2_groups
  
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

  .word attackSound
  .word hitSound
  .word level2_palette

  .word level2_map
  .word level2_map_column_table
  .word level2_attribute_column_table
  .word level2_meta_tile_column_table
  .word level2_meta_tile_table

  .word EntityDefinitionTable
  .word level2_music
  .byte level_1_index

;Nomolos
  .byte 0
;Deentle
  .byte 131
;Explosion
  .byte 139
;Beedie
  .byte 151
;Grank
  .byte 159
;Bat
  .byte 179
;Skelekin
  .byte 167
;Batree
  .byte 171
;Owl
  .byte 189
;Snuffer
  .byte 223

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
  .byte $01
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

.export attackSound
attackSound:
  .byte STL, 10
  .byte STV, $05
  .byte STP, $01
  .byte A0
  .byte STV, $00
  .byte A0
  .byte TRM

.export hitSound
hitSound:
  .byte STL, 10
  .byte STV, $03
  .byte STP, $01
  .byte G2
  .byte STV, $00
  .byte A0
  .byte TRM

.export getHurtSound
getHurtSound:
  .byte STL, 1
  .byte STV, $01
  .byte STP, $01
  .byte C5, B4, A4, G4, F4, E4, D4, C4
  .byte STV, $00
  .byte A0
  .byte TRM

.export dieSound
dieSound:
  .byte STL, 1
  .byte STV, $01
  .byte STP, $01
  .byte C6, B5, A5, G5, F5, E5, D5, CS5
  .byte C5, B4, A4, G4, F4, E4, D4, C4
  .byte STV, $00
  .byte A0
  .byte TRM

.export getHealthSound
getHealthSound:
  .byte STL, 1
  .byte STV, $01
  .byte STP, $01
  .byte A4,C5,E4,A3,C6,E7
  .byte A4,C5,E4,A3,C6,E7
  .byte TRM

.export getItemSound
getItemSound:
  .byte STL, 1
  .byte STV, $01
  .byte STP, $01
  .byte A4, AS4, B4, C5, CS5, D5, DS5, E5
  .byte A4, AS4, B4, C5, CS5, D5, DS5, E5
  .byte TRM

;miscellaneous data
.export banktable
banktable:
  .byte $00, $01, $02, $03, $04, $05, $06, $07

.export title_music
title_music:
  .word k13_square1
  .word k13_square2
  .word $0000
  .word $0000

k13_square1:
  .byte STL, _16TH
  .byte STV, 2
  .byte STP, 1
  .byte G4, D4
  .byte STL, _64TH, C4, B3, C4, B3
  .byte STL, _32ND, A3, G3, FS3, E3, D3, C3, B2, C3
  .byte STL, _8TH+_32ND, D3
  .byte STL, _32ND, G3, FS3, B3, A3, E4, D4, G4, FS4, C5, B4, A4, G4, FS4
  .byte STL, _16TH, G4, G3
  .byte STL, _32ND, FS3, B3, A3, E4, D4, G4, FS4, C5, B4, A4, G4, FS4
  .byte STL, _16TH, G4, D4
  .byte STL, _32ND, E4, E3, E3, E3, E3, E3, E3, G3
  .byte STL, _16TH, E3, E4
  .byte STL, _64TH, FS4, E4, FS4, E4
  .byte STL, _32ND, D4, C4, D4, D3, D3, D3, D3, D3, D3, FS3
  .byte STL, _16TH, D3, D4
  .byte STL, _64TH, E4, D4, E4, D4
  .byte STL, _32ND, C4, B3, C4, D3, D3, D3, D3, D3, D3, FS3
  .byte STL, _16TH, D3, C4
  .byte STL, _64TH, D4, C4, D4, C4
  .byte STL, _32ND, B3, A3, B3, G2, G2, G2, G2, G2, G2, B2
  .byte STL, _16TH, G2, B3
  .byte STL, _64TH, C4, B3, C4, B3
  .byte STL, _32ND, A3, G3, D4, A3, FS3, D3, B3, D3, B2, G2, D4, A3, FS3, D3, B3, D3, B2, G2
  .byte GOT
  .word k13_square1

k13_square2:
  .byte STL, _16TH*6
  .byte STV, 0
  .byte STP, 1
  .byte A1
  .byte STV, 2
  .byte STL, _16TH, G2, D2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, D2, D1
  .byte STL, _16TH, G1, G2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, D2, D1
  .byte STL, _16TH, G1, G2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, C2
  .byte STL, _32ND, C4, C4, C4, E4
  .byte STL, _16TH, C4, C4
  .byte STL, _64TH, D4, C4, D4, C4
  .byte STL, _32ND, B3, A3
  .byte STL, _8TH, B3
  .byte STL, _32ND, B3, B3, B3, D4
  .byte STL, _16TH, B3, B2
  .byte STL, _64TH, C3, B2, C3, B2
  .byte STL, _32ND, A2, G2
  .byte STL, _8TH, D2
  .byte STL, _32ND, A3, A3, A3, C4
  .byte STL, _16TH, A3, D2
  .byte STL, _64TH, B2, A2, B2, A2
  .byte STL, _32ND, G2, FS2
  .byte STL, _8TH, G1
  .byte STL, _32ND, B3, B3, B3, D4
  .byte STL, _16TH, B3, G2
  .byte STL, _64TH, A2, G2, A2, G2
  .byte STL, _32ND, FS2, E2
  .byte STL, _16TH, D1, D2, D1, D2, D1, D2, D1, D2
  .byte GOT
  .word k13_square2

.export font1
font1:
  .word font0_patterns
  .byte $04
  .byte $35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e
.include "font0_palette_source.inc"

;table of decimal powers for creating decimal strings from 8 bit numbers
.export powerTable
powerTable:
  .byte 100, 10, 1

.export levelString
levelString:
  .byte $06,$26,$04,$15,$04,$0b,$1a

.export livesString
livesString:
  .byte $06,$26,$08,$15,$04,$12,$1a

.export gameOverString
gameOverString:
  .byte $09,$21,$1b,$27,$1f,$1a,$29,$30,$1f,$2c

.export titleDef
titleDef:
  .word title_palette
  .word title_nametable
  .word title_patterns
  .byte $04

.include "title_palette_source.inc"
.include "title_nametable_source.inc"
.include "title_attributetable_source.inc"
