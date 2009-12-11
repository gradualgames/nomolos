.ifndef STRUCTS_INC
STRUCTS_INC = 1

PLAYLEVELSTATE_KEEPPLAYING = %00000000
PLAYLEVELSTATE_SWITCHLEVEL = %00000001
  
.struct spriteStruct
  ycoord .byte
  tile .byte
  attribute .byte
  xcoord .byte
.endstruct
  
.struct playLevelStateControl
  state .byte                ;flags for whether to switch to a different level
  romDefinitionTable .word   ;location of rom definition table for next level
  bgChrBank .byte            ;location of background chr rom bank
  sprChrBank .byte           ;location of sprite chr rom bank
  prgBank .byte              ;location of prg rom bank at $8000
.endstruct

.struct animation
  frameCountDown .byte
  currentFrame .byte
.endstruct

.struct entityRAM
  alive .byte
  index .byte
  spawnPositionX .word
  spawnPositionY .byte
  positionXFine .byte
  positionX .word
  positionYFine .byte
  positionY .word
  state .byte
  animationObject .word
  extra .byte 2
.endstruct

.struct ROMDefinitionTableStruct
  NomolosWalk .word
  NomolosWalkOverlay .word
  NomolosJump .word
  NomolosJumpOverlay .word
  NomolosFight .word
  NomolosFightOverlay .word
  Heart0 .word
  attackSound .word
  hitSound .word
  palette .word
  MetaTileTable .word
  MetaMetaTileTable .word
  Level .word
  EntityDefinitionTable .word
  music .word
.endstruct

.endif