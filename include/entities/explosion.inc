.ifndef EXPLOSION_INC
EXPLOSION_INC = 1

EXPLOSION_WIDTH = $10
EXPLOSION_HEIGHT = $10

EXPLOSION_INITSTATE = 0
EXPLOSION_EXPLODESTATE = 1

.export explosion_update
explosion_update:

  lda entity_instances+entityRAM::state,x
  cmp #EXPLOSION_INITSTATE
  beq explosionInit
  cmp #EXPLOSION_EXPLODESTATE
  beq explosionExplode
  
explosionInit:

  ;reset the explosion animation object
  jsr entity_reset_anim
  
  ;set state to explode
  lda #EXPLOSION_EXPLODESTATE
  sta entity_instances+entityRAM::state,x
  
  rts
  
explosionExplode:

  jsr entity_compute_screen_coordinates

  ldy #ROMDefinitionTableStruct::ExplosionOffset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset
  
  ldy #ROMDefinitionTableStruct::Explosion
  jsr entity_draw_anim
  
  lda entity_instances+entityRAM::animationObject+1,x
  cmp #2
  bne @skipFrameCounterTest
  lda entity_instances+entityRAM::animationObject,x
  cmp #1
  beq explosionDie
@skipFrameCounterTest:

  rts
  
explosionDie:

  jsr entity_kill

  rts
  
.endif