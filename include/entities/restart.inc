.include "soundengine.inc"

.ifndef RESTARTENTITY_INC
RESTARTENTITY_INC = 1

RESTARTENTITY_WIDTH = $10
RESTARTENTITY_HEIGHT = $ff

restart_update:

  ;use the restart entity's location to fill the restart point variables
  lda entity_instances+entity_instance::position_x,x
  clc
  adc #120
  sta restart_x
  lda entity_instances+entity_instance::position_y,x
  sta restart_y
  lda entity_instances+entity_instance::position_x+1,x
  sta restart_screen

  ;kill the entity
  lda #0
  sta entity_instances+entity_instance::alive,x

  rts

.endif
