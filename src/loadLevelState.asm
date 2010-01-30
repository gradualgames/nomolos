.include "macros.inc"
.include "constants.inc"
.include "structs.inc"
.include "flags.inc"
.include "famitracker.inc"
.include "sound.inc"
.include "misc.inc"
.include "miscdata.inc"
.include "camera.inc"
.include "nomolosLogic.inc"
.include "playLevelState.inc"
.include "map.inc"
.include "sprite.inc"
.include "entity.inc"
.include "zp.inc"

.segment "CODE"

.export loadLevelUpdate
.proc loadLevelUpdate
  lda stateControl+loadLevelStateControl::state
  cmp #LOADLEVELSTATE_INIT
  beq loadLevelStateInit
  cmp #LOADLEVELSTATE_LOAD
  bne :+
  jmp loadLevelStateLoad
:
  cmp #LOADLEVELSTATE_DONE
  bne :+
  jmp loadLevelStateDone
:
  
loadLevelStateInit:

  lda stateControl+loadLevelStateControl::levelToLoad
  ;multiply accumulator by 8
  asl
  asl
  asl
  ;transfer to x for indexing
  tax
  
  ;wait for vblank so we can turn off graphics, switch chr banks without graphical glitches
  waitVBlank

  ;turn off NMI, inc32 (for loading palette)
  lda #( ( 0 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  
  ;turn off sprites and bg
  lda #( ( 0 << PPU1_SPRITE_VISIBILITY ) | ( 0 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  ;load CHR bank into $0000
  
  ;first bank switch to the PRG rom bank containing the level's chr data
  lda LevelDefinitionTable+level::chrPrgRomBank,x
  sta b0
  jsr bankswitch
  
  ;now load the address of the chr data from the level definition table
  lda LevelDefinitionTable+level::chrAddress,x
  sta w0
  inx
  lda LevelDefinitionTable+level::chrAddress,x
  dex
  sta w0+1
  
  ;load the chr data into vram
  jsr loadChr
  
  ;load PRG bank into $8000
  lda LevelDefinitionTable+level::prgRomBank,x
  sta b0
  jsr bankswitch

  lda LevelDefinitionTable+level::romDefinitionTable,x
  sta romDefinitionTableBaseAddress
  lda LevelDefinitionTable+level::romDefinitionTable+1,x
  sta romDefinitionTableBaseAddress+1

  ldy #ROMDefinitionTableStruct::Level
  lda (romDefinitionTableBaseAddress),y
  sta levelBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta levelBaseAddress+1

  ldy #ROMDefinitionTableStruct::MetaMetaTileTable
  lda (romDefinitionTableBaseAddress),y
  sta metametaTileTableBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta metametaTileTableBaseAddress+1

  ldy #ROMDefinitionTableStruct::MetaTileTable
  lda (romDefinitionTableBaseAddress),y
  sta metaTileTableBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta metaTileTableBaseAddress+1
  
  ldy #ROMDefinitionTableStruct::EntityDefinitionTable
  lda (romDefinitionTableBaseAddress),y
  sta entityDefinitionTableBaseAddress
  iny
  lda (romDefinitionTableBaseAddress),y
  sta entityDefinitionTableBaseAddress+1
  
  ldy #ROMDefinitionTableStruct::music
  lda (romDefinitionTableBaseAddress),y
  sta ft_music_addr
  iny
  lda (romDefinitionTableBaseAddress),y
  sta ft_music_addr+1
  
  jsr initsound
  
  ldy #ROMDefinitionTableStruct::palette
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1

  jsr loadPalette
  jsr clearSprites
  jsr initEntities
  jsr initNomolos  
  jsr resetCamera  

  ;turn on inc32
  lda #( ( 0 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  
  ;initialize music driver as NTSC and track #0.
.if .defined(MUSIC_ENABLE)
  lda #0
  ldx #0
  jsr ft_music_init
.endif
  
  lda #LOADLEVELSTATE_LOAD
  sta stateControl+loadLevelStateControl::state
  
  jmp stateSwitchComplete
  
loadLevelStateLoad:

  lda #$20
  sta nametableToUpdate

  lda columnToUpdate
  lsr
  tay
  lda (levelBaseAddress),y

  ;store the meta meta tile index as a 16 bit number
  sta w1
  lda #0
  sta w1+1

  ;shift left this number by 4
  ldx #4
:
  asl w1
  rol w1+1
  dex
  bne :-

  ;now add MetaMetaTileTable to this number
  clc
  lda w1
  adc metametaTileTableBaseAddress
  sta w1
  lda w1+1
  adc metametaTileTableBaseAddress+1
  sta w1+1

  ;calculate spawnX
  lda columnToUpdate
  asl
  asl
  asl
  sta w3 ;spawnX
  lda #0
  sta w3+1 ;spawnX+1
  
  lda columnToUpdate
  jsr updateColumn

  ;rendering is off in this state, so we update the PPU
  jsr updateSprites
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU

  ;move on to next column.
  inc columnToUpdate
  inc columnToUpdate
  
  lda columnToUpdate
  ;have we updated all the columns on the screen yet?
  cmp #32
  bne :+
  
  lda #LOADLEVELSTATE_DONE
  sta stateControl+playLevelStateControl::state
  
:
  
  jmp stateSwitchComplete

loadLevelStateDone:

  ;switch to play level state.  
  ;keep any new entities positioned where they need to be
  ;switch to the actor and entity bank
  ldy #ROMDefinitionTableStruct::NomolosAndEntityBank
  lda (romDefinitionTableBaseAddress),y
  sta b0
  jsr bankswitch
  
  jsr updateEntities
  
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (romDefinitionTableBaseAddress),y
  sta b0
  jsr bankswitch
  
  lda #$24
  sta nametableToUpdate  

  lda #PLAYLEVELSTATE_KEEPPLAYING
  sta stateControl+playLevelStateControl::state
  
  switchState playLevelUpdate, playLevelUpdatePPU
      
  waitVBlank
      
  ;turn rendering on
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
   
  lda #( ( 1 << PPU1_SPRITE_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001

  jmp stateSwitchComplete
  
stateSwitchComplete:

  rts
.endproc

.export loadLevelUpdatePPU
.proc loadLevelUpdatePPU
  rts  
.endproc
