.ifndef LEVELDATAINDEX_INC
LEVELDATAINDEX_INC = 1

;state table
index_title_state          = 0 * 4
index_level_in_state       = 1 * 4
index_load_level_state     = 2 * 4
index_game_over_state      = 3 * 4
index_play_level_state     = 4 * 4

.global switch_state
.global state_table
.global level_definition_table
.global banktable
.global attackSound
.global attackFlailSound
.global attackSpearSound
.global hitSound
.global getHealthSound
.global getItemSound
.global getHurtSound
.global dieSound
.global haltmusic
.global title_music
.global font1
.global powerTable
.global press_start_string
.global lda_games_string
.global copyright_c_2010_string
.global levelString
.global livesString
.global gameOverString
.global titleDef
.global titlePalette
.global titleNametable

SOUND_EFFECT_BASE = 10

.global sf_volume_envelope_silence
.global sf_volume_envelope_loud
.global sf_volume_envelope_1
.global sf_volume_envelope_decay
.global sf_volume_envelope_short_note
.global sf_volume_envelope_fade_in
.global sf_volume_envelope_fade_in_2
.global sf_pitch_envelope_0
.global sf_pitch_envelope_1

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
  CyclingPaletteAddress .word
  CyclingPaletteSpeed .byte
  
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
  SharkLeap .word
  
  attackSound .word
  hitSound .word
  palette .word

  nomolos_start_x .byte
  nomolos_start_y .byte
  
  camera_scroll_enabled .byte
  starting_screen .byte
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
  SharkOffset .byte

.endstruct

.endif
