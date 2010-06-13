.ifndef LEVELDATAINDEX_INC
LEVELDATAINDEX_INC = 1

.import level_definition_table
.import banktable
.import attackSound
.import hitSound
.import getHealthSound
.import getItemSound
.import getHurtSound
.import dieSound
.import haltmusic
.import title_music
.import font1
.import powerTable
.import levelString
.import livesString
.import gameOverString
.import titleDef
.import titlePalette
.import titleNametable

.struct title
  paletteAddress .word
  nametableAddress .word
  chrAddress .word
  chrPrgRomBank .byte
.endstruct

.struct level
  romDefinitionTable .word
.endstruct

.struct font
  chrAddress .word
  chrPrgRomBank .byte
  digitTable .byte 10
  palette .byte 32
.endstruct

.struct ROMDefinitionTableStruct
  NomolosAndEntityBank .byte
  LevelAndMusicBank .byte
  LevelPatternsBank .byte
  LevelPatternsAddress .word
  SpritePatternsBank .byte
  SpritePatternsAddress .word
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
  SnailCrawl .word
  DragonFly .word
  IceBallFly .word
  
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
  
  NomolosOffset .byte
  DeentleOffset .byte
  ExplosionOffset .byte
  BeedieOffset .byte
  GrankOffset .byte
  BatOffset .byte
  SkelekinOffset .byte
  BatreeOffset .byte
  OwlOffset .byte
  SnufferOffset .byte
  SnailOffset .byte
  DragonOffset .byte
  IceBallOffset .byte

.endstruct

.endif
