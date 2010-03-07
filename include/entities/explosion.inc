.ifndef EXPLOSION_INC
EXPLOSION_INC = 1

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
  lda #$01
  sta entity_instances+entityRAM::animationObject,x
  lda #$ff
  sta entity_instances+entityRAM::animationObject+1,x
  
  ;set state to explode
  lda #EXPLOSION_EXPLODESTATE
  sta entity_instances+entityRAM::state,x
  
  rts
  
explosionExplode:

  jsr entity_compute_screen_coordinates

  ;store screen coordinates
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  ;load address of animation object into w1
  lda #<(entity_instances+entityRAM::animationObject)
  sta w1
  lda #>(entity_instances+entityRAM::animationObject)
  sta w1+1
  
  ;get the index into a
  txa
  clc
  ;do a 16 bit add onto the address with this index
  adc w1
  sta w1
  lda w1+1
  adc #0
  sta w1+1 
  
  lda #<Explosion
  sta w2
  lda #>Explosion
  sta w2+1
  jsr sprite_update_animation  
  
  jsr sprite_draw_animation_16bit
  
  lda entity_instances+entityRAM::animationObject+1,x
  cmp #2
  bne @skipFrameCounterTest
  lda entity_instances+entityRAM::animationObject,x
  cmp #1
  beq explosionDie
@skipFrameCounterTest:

  rts
  
explosionDie:

  lda #0
  sta entity_instances+entityRAM::alive,x

  rts
  
.endif