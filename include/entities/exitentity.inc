.ifndef EXITENTITY_INC
EXITENTITY_INC = 1

.export exit_level_update
exit_level_update:

  jsr entity_compute_screen_coordinates
  bpl skipJmpExitDie
  jmp exitDie
skipJmpExitDie:
  
  ;load entity width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_nomolos
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
  
  ;turn off music by playing track #0 of haltmusic  
.if .defined(MUSIC_ENABLE)
  lda #<haltmusic
  sta ft_music_addr
  lda #>haltmusic
  sta ft_music_addr+1
  lda #0
  ldx #0
  jsr ft_music_init
.endif  
  
  ldy #ROMDefinitionTableStruct::NextLevel
  lda (romDefinitionTableBaseAddress),y
  sta currentLevel
  lda #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  sta stateControl+playLevelStateControl::state
    
  jmp exitDie
  
notTouching:

  rts

exitDie:
  lda #0
  sta entity_instances+entityRAM::alive,x
  rts

.endif
