.ifndef STRUCTS_INC
STRUCTS_INC = 1

.struct title
  paletteAddress .word
  nametableAddress .word
  chrAddress .word
  chrPrgRomBank .byte
.endstruct

.struct level
  chrAddress .word
  chrPrgRomBank .byte
  prgRomBank .byte
  romDefinitionTable .word
.endstruct

.struct font
  chrAddress .word
  chrPrgRomBank .byte
  digitTable .byte 10
  palette .byte 32
.endstruct

.struct buttons
  _a       .byte
  _b       .byte
  _select  .byte
  _start   .byte
  _up      .byte
  _down    .byte
  _left    .byte
  _right   .byte
.endstruct
  
.struct spriteStruct
  ycoord .byte
  tile .byte
  attribute .byte
  xcoord .byte
.endstruct
  
LOADLEVELSTATE_INIT = %00000000
LOADLEVELSTATE_LOAD = %00000001
LOADLEVELSTATE_DONE = %00000010
  
.struct loadLevelStateControl
  state .byte
  levelToLoad .byte
.endstruct
  
PLAYLEVELSTATE_KEEPPLAYING =           %00000000
PLAYLEVELSTATE_SWITCHLEVEL =           %00000001
PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE = %00000010
  
.struct playLevelStateControl
  state .byte                ;flags for whether to switch to a different level
  levelNum .byte             ;index of level to load
.endstruct

LEVELOUTSTATE_INIT =    %00000000
LEVELOUTSTATE_FADEOUT = %00000001

.struct levelOutStateControl
  state .byte
.endstruct

LEVELINSTATE_INIT = %00000000
LEVELINSTATE_RUN =  %00000001
LEVELINSTATE_DONE = %00000010

.struct levelInStateControl
  state .byte
.endstruct

GAMEOVERSTATE_INIT = %00000000
GAMEOVERSTATE_RUN  = %00000001
GAMEOVERSTATE_DONE = %00000010

.struct gameOverStateControl
  state .byte
.endstruct

TITLESTATE_INIT = %00000000
TITLESTATE_RUN =  %00000001
TITLESTATE_DONE = %00000010

.struct titleStateControl
  state .byte
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
  NomolosAndEntityBank .byte
  LevelAndMusicBank .byte
  NomolosWalk .word
  NomolosWalkOverlay .word
  NomolosJump .word
  NomolosJumpOverlay .word
  NomolosFight .word
  NomolosFightOverlay .word
  NomolosFlail .word
  NomolosFlailOverlay .word
  NomolosSpear .word
  NomolosSpearOverlay .word
  FlailBall .word
  SpearFly .word
  SlumpedArmor .word
  SlumpedArmorOverlay .word
  ScaredyCat .word
  ScaredyCatOverlay .word
  
  Heart0 .word
  Spear0 .word
  GrankFly .word
  BeedieBlob .word
  FlailItem0 .word
  DeentleWalk .word
  Explosion .word
  Mouse .word
  OneUp0 .word
  SkelekinWalk .word
  BatFly .word
  Batree .word
  OwlFly .word
  OwlAttack .word
  SnufferRun .word
  SnufferBite .word
  
  attackSound .word
  hitSound .word
  palette .word

  map .word
  map_column_table .word
  attribute_column_table .word
  meta_tile_column_table .word
  meta_tile_table .word
  
  EntityDefinitionTable .word
  music .word
  NextLevel .byte
.endstruct

.endif