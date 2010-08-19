.global flail_item_update
.global oneup_update
.global mouse_update
.global explosion_update
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

;entity indices
entity_index_deentle = 1
entity_index_explosion = 2
entity_index_mouse = 3
entity_index_exit = 4
entity_index_one_up = 5
entity_index_flail = 6
entity_index_beedie = 7
entity_index_grank = 8
entity_index_spear = 9
entity_index_skelekin = 10
entity_index_bat = 11
entity_index_batree = 12
entity_index_owl = 13
entity_index_snuffer = 14
entity_index_snail = 15
entity_index_dragon = 16
entity_index_iceball = 17
entity_index_shark = 18
entity_index_stalactite = 19
entity_index_dragonboss = 20

;entity structs. Only parameterizable entities have structs here.
.struct iceball_locals
  x_velocity .word
  y_velocity .word
.endstruct

ICEBALL_WIDTH = $10
ICEBALL_HEIGHT = $10

ICEBALL_INITSTATE = 0
ICEBALL_FLYSTATE = 1
