.ifndef ENTITY_INC
ENTITY_INC = 1

.global entity_kill_if_already_seen
.global entity_draw_anim
.global entity_reset_anim
.global entity_kill
.global entity_test_face_nomolos
.global entity_test_death_zone
.global entity_update_all
.global entity_init_all
.global entity_spawn
.global entity_compute_screen_coordinates
.global entity_test_collision_nomolos
.global entity_test_collision_hitbox

.struct entity_instance
  alive .byte
  index .byte
  spawnPositionX .word
  spawnPositionY .byte
  positionXFine .byte
  positionX .word
  positionYFine .byte
  positionY .word
  state .byte
  animationObject .word
  extra .byte 2
.endstruct

.endif
