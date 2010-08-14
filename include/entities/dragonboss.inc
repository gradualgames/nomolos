.ifndef DRAGON_BOSS_INC
DRAGON_BOSS_INC = 1

DRAGON_BOSS_WIDTH = $10
DRAGON_BOSS_HEIGHT = $10

DRAGON_BOSS_INITSTATE = 0

dragonboss_update:

  lda entity_instances+entity_instance::state,x
  cmp #DRAGON_BOSS_INITSTATE
  beq dragon_boss_init

dragon_boss_init:

  ;reset the dragon_boss animation object
  jsr entity_reset_anim

  rts

.endif