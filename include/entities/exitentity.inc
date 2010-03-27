.ifndef EXITENTITY_INC
EXITENTITY_INC = 1

EXITENTITY_WIDTH = $10
EXITENTITY_HEIGHT = $ff

.export exit_level_update
exit_level_update:

  jsr entity_compute_screen_coordinates
 
  jsr entity_test_death_zone
  beq exitDie
  
  ;load entity width and height
  lda #EXITENTITY_WIDTH
  sta b2
  lda #EXITENTITY_HEIGHT
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
  lda (base_address_rom_definition_table),y
  sta level_current
  lda #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  sta state_control_params+playLevelStateControl::state
    
  jmp exitDie
  
notTouching:

  rts

exitDie:
  lda #0
  sta entity_instances+entityRAM::alive,x
  rts

.endif
