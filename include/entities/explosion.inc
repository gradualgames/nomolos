.ifndef EXPLOSION_WIDTH
EXPLOSION_WIDTH = $10
.endif

.ifndef EXPLOSION_HEIGHT
EXPLOSION_HEIGHT = $10
.endif

.ifndef EXPLOSION_INITSTATE
EXPLOSION_INITSTATE = 0
.endif

.ifndef EXPLOSION_EXPLODESTATE
EXPLOSION_EXPLODESTATE = 1
.endif

.ifndef explosion_update
explosion_update:
.endif
.scope

  lda entity_instances+entity_instance::state,x
  cmp #EXPLOSION_INITSTATE
  beq explosionInit
  cmp #EXPLOSION_EXPLODESTATE
  beq explosionExplode

explosionInit:

  ;reset the explosion animation object
  jsr entity_reset_anim

  ;set state to explode
  lda #EXPLOSION_EXPLODESTATE
  sta entity_instances+entity_instance::state,x

  rts

explosionExplode:

  jsr entity_compute_screen_coordinates

  lda entity_chr_offsets+(entity_index_explosion-1)
  sta sprite_group_offset

  lda #0
  sta b2
  
  lda #<spritesheet_common_Explosion
  sta w2
  lda #>spritesheet_common_Explosion
  sta w2+1
  jsr entity_draw_anim

  lda entity_instances+entity_instance::animation_object+1,x
  cmp #2
  bne @skipFrameCounterTest
  lda entity_instances+entity_instance::animation_object,x
  cmp #1
  beq explosionDie
@skipFrameCounterTest:

  rts

explosionDie:

  jsr entity_kill

  rts

.endscope
