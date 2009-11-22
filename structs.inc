.ifndef STRUCTS_INC
STRUCTS_INC = 1

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
  positionY .byte
  state .byte
  animationObject .word
  extra .byte 3
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