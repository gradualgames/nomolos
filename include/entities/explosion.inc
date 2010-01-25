.ifndef EXPLOSION_INC
EXPLOSION_INC = 1

EXPLOSION_INITSTATE = 0
EXPLOSION_EXPLODESTATE = 1

explosionUpdate:

  lda entityPool+entityRAM::state,x
  cmp #EXPLOSION_INITSTATE
  beq explosionInit
  cmp #EXPLOSION_EXPLODESTATE
  beq explosionExplode
  
explosionInit:

  ;reset the explosion animation object
  lda #$01
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  ;set state to explode
  lda #EXPLOSION_EXPLODESTATE
  sta entityPool+entityRAM::state,x
  
  jmp returnFromEntityUpdate
  
explosionExplode:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta w1
  lda entityPool+entityRAM::positionY+1,x
  sta w1+1
  jsr cameraToScreenCoords

  ;store screen coordinates
  lda w0
  sta w3
  lda w0+1
  sta w3+1
  lda w1
  sta w4
  lda w1+1
  sta w4+1
  
  ;load address of animation object into w1
  lda #<(entityPool+entityRAM::animationObject)
  sta w1
  lda #>(entityPool+entityRAM::animationObject)
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
  jsr updateAnimation  
  
  jsr drawAnimation16
  
  lda entityPool+entityRAM::animationObject+1,x
  cmp #2
  bne @skipFrameCounterTest
  lda entityPool+entityRAM::animationObject,x
  cmp #1
  beq explosionDie
@skipFrameCounterTest:

  jmp returnFromEntityUpdate
  
explosionDie:

  lda #0
  sta entityPool+entityRAM::alive,x

  jmp returnFromEntityUpdate
  
.endif