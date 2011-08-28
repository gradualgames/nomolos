.ifndef ENTITIES_INC
ENTITIES_INC = 1

.global flail_item_update
.global oneup_update
.global mouse_update
.global explosion_update
.global explosionspawner_update
.global deentle_update
.global exit_level_update
.global beedie_update
.global grank_update
.global spear_item_update
.global bat_update
.global batree_update
.global skelekin_update
.global owl_update
.global snuffer_update
.global snail_update
.global dragon_update
.global iceball_update
.global shark_update
.global stalactite_update
.global dragonboss_update
.global restart_update
.global phoenix_update
.global fireball_update
.global snake_update
.global fireguy_update
.global thoguth_update
.global fireballspawner_update
.global lightningbolt_update
.global grubselimboj_update
.global bigfireball_update
.global statue_update
.global raven_update
.global sheep_update
.global bee_update
.global setrightmostx_update
.global gort_update
.global hippocritter_update

;entity indices
entity_index_nomolos = 1
entity_index_deentle = 2
entity_index_explosion = 3
entity_index_mouse = 4
entity_index_exit = 5
entity_index_one_up = 6
entity_index_flail = 7
entity_index_beedie = 8
entity_index_grank = 9
entity_index_spear = 10
entity_index_skelekin = 11
entity_index_bat = 12
entity_index_batree = 13
entity_index_owl = 14
entity_index_snuffer = 15
entity_index_snail = 16
entity_index_dragon = 17
entity_index_iceball = 18
entity_index_shark = 19
entity_index_stalactite = 20
entity_index_dragonboss = 21
entity_index_restart = 22
entity_index_phoenix = 23
entity_index_fireball = 24
entity_index_snake = 25
entity_index_fireguy = 26
entity_index_thoguth = 27
entity_index_fireballspawner = 28
entity_index_lightningbolt = 29
entity_index_grubselimboj = 30
entity_index_bigfireball = 31
entity_index_statue = 32
entity_index_raven = 33
entity_index_sheep = 34
entity_index_bee = 35
entity_index_explosionspawner = 36
entity_index_setrightmostx = 37
entity_index_gort = 38
entity_index_hippocritter = 39

;entity structs. Only parameterizable entities have structs here.
.struct iceball_locals
  x_velocity .word
  y_velocity .word
.endstruct

ICEBALL_WIDTH = $10
ICEBALL_HEIGHT = $10

ICEBALL_INITSTATE = 0
ICEBALL_FLYSTATE = 1

.struct bigfireball_locals
  x_velocity .word
  y_velocity .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
  restCounter .byte
.endstruct

BIGFIREBALL_WIDTH = $10
BIGFIREBALL_HALFWIDTH = $08
BIGFIREBALL_HEIGHT = $10
BIGFIREBALL_HALFHEIGHT = $08

BIGFIREBALL_INITSTATE = 0
BIGFIREBALL_JUMPSTATE = 1

.struct fireball_locals
  x_velocity .word
  y_velocity .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
  restCounter .byte
.endstruct

FIREBALL_WIDTH = $10
FIREBALL_HALFWIDTH = $08
FIREBALL_HEIGHT = $10
FIREBALL_HALFHEIGHT = $08

FIREBALL_INITSTATE = 0
FIREBALL_JUMPSTATE = 1

.struct lightningbolt_locals
  x_velocity .word
  y_velocity .word
  counter .byte
.endstruct

LIGHTNINGBOLT_WIDTH = $10
LIGHTNINGBOLT_HEIGHT = $28

LIGHTNINGBOLT_INITSTATE = 0
LIGHTNINGBOLT_FALLSTATE = 1

.endif
