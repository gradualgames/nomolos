.ifndef ENTITY_INC
ENTITY_INC = 1

.global entity_set_picked_up
.global entity_test_picked_up_state
.global entity_load_chr_groups
.global entity_get_next_prn
.global entity_kill_if_already_seen
.global entity_draw_anim
.global entity_reset_anim
.global entity_kill
.global entity_test_face_nomolos
.global entity_test_death_zone
.global entity_item_test_death_zone
.global entity_update_all
.global entity_init_all
.global entity_spawn
.global entity_compute_screen_coordinates
.global entity_test_collision_nomolos
.global entity_test_collision_hitbox

.struct entity_instance
  alive .byte
  index .byte
  spawn_position_x .word
  spawn_position_y .byte
  position_x_fine .byte
  position_x .word
  position_y_fine .byte
  position_y .word
  state .byte
  animation_object .word
  extra .byte 2
.endstruct

.endif
