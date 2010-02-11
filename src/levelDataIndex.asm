.include "spritesheet1.inc"
.include "constants.inc"
.include "level1.inc"
.include "level2.inc"

.segment "CODE"

;level definitions
.export LevelDefinitionTable
LevelDefinitionTable:
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
  .byte $02
  .byte $00
  .word NomolosWalk            
  .word NomolosWalkOverlay     
  .word NomolosJump            
  .word NomolosJumpOverlay     
  .word NomolosFight           
  .word NomolosFightOverlay    
  .word NomolosUseFlail
  .word NomolosFlailOverlay
  .word FlailBall
  .word SlumpedArmor0           
  .word SlumpedArmorOverlay0
  .word ScardyCat0
  .word ScardyCatOverlay0
  .word Heart0                 
  .word attackSound            
  .word hitSound               
  .word level1_palette                
  .word level1MetaTileTable          
  .word level1MetaMetaTileTable      
  .word level1Level                  
  .word EntityDefinitionTable  
  .word level1music                  
  .byte $01

;ROM definition table
ROMDefinitionTable1:
  .byte $02
  .byte $01
  .word NomolosWalk           
  .word NomolosWalkOverlay    
  .word NomolosJump           
  .word NomolosJumpOverlay    
  .word NomolosFight          
  .word NomolosFightOverlay   
  .word NomolosUseFlail
  .word NomolosFlailOverlay
  .word FlailBall
  .word SlumpedArmor0         
  .word SlumpedArmorOverlay0
  .word ScardyCat0
  .word ScardyCatOverlay0
  .word Heart0                
  .word attackSound           
  .word hitSound              
  .word level2_palette               
  .word level2MetaTileTable         
  .word level2MetaMetaTileTable     
  .word level2Level                 
  .word EntityDefinitionTable 
  .word level2music                 
  .byte $00
  
;Entities
EntityDefinitionTable:
DeentleEntity:
  .word deentleUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
ExplosionEntity:
  .word explosionUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
MouseEntity:
  .word mouseUpdate
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
ExitLevelEntity:
  .word exitLevelUpdate
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
OneUpEntity:
  .word oneUpUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
FlailItemEntity:
  .word flailItemUpdate
  .byte $00
  .byte $f9
  .byte %00000000
  .byte $00
  .byte $00
  .byte $00
BeedieEntity:
  .word beedieUpdate
  .byte $00
  .byte $00
  .byte %00000000
  .byte $00
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
  
.export getOneUpSound
getOneUpSound:
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
  
.export getFlailItemSound
getFlailItemSound:
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
