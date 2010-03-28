.include "constants.inc"
.include "level1.inc"
.include "level2.inc"
.include "entities.inc"

.segment "ROM4_4K0"  

.include "font0_patterns_source.inc"

.segment "ROM4_4K2"  

.include "title_patterns_source.inc"

.segment "CODE"

;level definitions
.export level_definition_table
level_definition_table:
Level1:
  .word level1_patterns  ;location of chr data
  .byte $03              ;prg bank where data resides
  .byte $00              ;prg bank where code/additional data resides
  .word ROMDefinitionTable0
  .byte $00, $00  ;pad to 8 bytes. this may be used eventually anyway (music track for example)
Level2:
  .word level2_patterns
  .byte $03       
  .byte $01
  .word ROMDefinitionTable1
  .byte $00, $00

;ROM definition table
ROMDefinitionTable0:
  .byte sprite_sheet_1_bank
  .byte level_1_bank
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

;ROM definition table
ROMDefinitionTable1:
  .byte sprite_sheet_1_bank
  .byte level_2_bank
  .word spritesheet2_NomolosWalk            
  .word spritesheet2_NomolosWalkOverlay     
  .word spritesheet2_NomolosJump            
  .word spritesheet2_NomolosJumpOverlay     
  .word spritesheet2_NomolosFight           
  .word spritesheet2_NomolosFightOverlay    
  .word spritesheet2_NomolosUseFlail
  .word spritesheet2_NomolosFlailOverlay
  .word spritesheet2_NomolosUseSpear
  .word spritesheet2_NomolosFightOverlay
  .word spritesheet2_FlailBall
  .word spritesheet2_Spear0
  .word spritesheet2_SlumpedArmor0           
  .word spritesheet2_SlumpedArmorOverlay0
  .word spritesheet2_ScardyCat0
  .word spritesheet2_ScardyCatOverlay0
  
  .word spritesheet2_Heart0                   
  .word spritesheet2_Spear0
  .word spritesheet2_GrankFly
  .word spritesheet2_BeedieBlob
  .word spritesheet2_FlailItem0
  .word spritesheet2_DeentleWalk
  .word spritesheet2_Explosion
  .word spritesheet2_Mouse
  .word spritesheet2_OneUp0
  .word spritesheet2_SkelekinWalk
  .word spritesheet2_BatFly
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
  .byte $0E
  .byte $07
  .byte $0F
  .byte $f8
  .byte $0C
  .byte %00110000
  .byte $0C
  .byte %00110010
  .byte $0C
  .byte %00110100
  .byte $0C
  .byte %00110110
  .byte $0C
  .byte %00111000
  .byte $0C
  .byte %00111010
  .byte $0C
  .byte %00111100
  .byte $0C
  .byte %00111110
  .byte $0C
  .byte %00110000
  .byte $ff
 
.export hitSound
hitSound:
  .byte $0E
  .byte $0a
  .byte $0F
  .byte $f8  
  .byte $0C
  .byte %00111110
  .byte $0C
  .byte %00111100
  .byte $0C
  .byte %00111010
  .byte $0C
  .byte %00111000
  .byte $0C
  .byte %00110110
  .byte $0C
  .byte %00110100
  .byte $0C
  .byte %00110010
  .byte $0C
  .byte %00110000
  .byte $0C
  .byte %00110000
  .byte $ff

.export getHealthSound
getHealthSound:
  .byte DISABLE_FAMITRACKER_CHANNEL
  .byte $01 
  .byte $04
  .byte $84
  .byte $05
  .byte %00000000
  .byte $07
  .byte %00001000
  .byte $06
  .byte %11111111
  .byte $06
  .byte %10111111
  .byte $06
  .byte %01111111
  .byte $06
  .byte %00111111  
  .byte ENABLE_FAMITRACKER_CHANNEL
  .byte $01
  .byte $ff
  
.export getItemSound
getItemSound:
  .byte DISABLE_FAMITRACKER_CHANNEL
  .byte $01 
  .byte $04
  .byte $84
  .byte $05
  .byte %00000000
  .byte $07
  .byte %00001000
  .byte $06
  .byte %11111111
  .byte $06
  .byte %10111111
  .byte $06
  .byte %01111111
  .byte $06
  .byte %00111111  
  .byte $06
  .byte %11111111
  .byte $06
  .byte %10111111
  .byte $06
  .byte %01111111
  .byte $06
  .byte %00111111  
  .byte ENABLE_FAMITRACKER_CHANNEL
  .byte $01
  .byte $ff
