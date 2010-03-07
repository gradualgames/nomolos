.segment "ZEROPAGE"

.exportzp b0
b0:       .res 1

.exportzp b1
b1:       .res 1

.exportzp b2
b2:       .res 1

.exportzp b3
b3:       .res 1

.exportzp b4
b4:       .res 1

.exportzp b5
b5:       .res 1

.exportzp b6
b6:       .res 1

.exportzp b7
b7:       .res 1

.exportzp b8
b8:       .res 1

.exportzp b9
b9:       .res 1

.exportzp w0
w0:       .res 2

.exportzp w1
w1:       .res 2

.exportzp w2
w2:       .res 2

.exportzp w3
w3:       .res 2

.exportzp w4
w4:       .res 2

.exportzp w5
w5:       .res 2

.exportzp w6
w6:       .res 2

.exportzp w7
w7:       .res 2

.exportzp w8
w8:       .res 2

.exportzp w9
w9:       .res 2

.exportzp entity_screen_x
entity_screen_x: .res 2

.exportzp entity_screen_y
entity_screen_y: .res 2

.exportzp mapper_bank_current
mapper_bank_current: .res 1

.exportzp mapper_bank_next
mapper_bank_next: .res 1

.exportzp ppu_string_buffer
ppu_string_buffer: .res 8

.exportzp vblank_done
vblank_done:  .res 1

.exportzp update
update:     .res 2

.exportzp update_ppu
update_ppu:  .res 2

.exportzp state_control_params
state_control_params: .res 16

.exportzp nomolos_map_x
nomolos_map_x: .res 3  ;24 bit x (16 bit coord + 8 bit fine movement)

.exportzp nomolos_map_y
nomolos_map_y: .res 3  ;24 bit y (16 bit coord + 8 bit fine movement)

.exportzp nomolos_x_velocity
nomolos_x_velocity: .res 2

.exportzp nomolos_y_velocity
nomolos_y_velocity: .res 2

.exportzp nomolos_screen_x
nomolos_screen_x: .res 2

.exportzp nomolos_screen_y
nomolos_screen_y: .res 2

.exportzp nomolos_attack_rect_x
nomolos_attack_rect_x: .res 2

.exportzp nomolos_attack_rect_y
nomolos_attack_rect_y: .res 2

.exportzp nomolos_attack_rect_width
nomolos_attack_rect_width: .res 1

.exportzp nomolos_attack_rect_height
nomolos_attack_rect_height: .res 1

.exportzp nomolos_out_of_armor_screen_x
nomolos_out_of_armor_screen_x: .res 2

.exportzp nomolos_out_of_armor_screen_y
nomolos_out_of_armor_screen_y: .res 2

.exportzp nomolos_below_ejection_distance
nomolos_below_ejection_distance: .res 1

.exportzp nomolos_above_ejection_distance
nomolos_above_ejection_distance: .res 1

.exportzp nomolos_animation
nomolos_animation: .res 2

.exportzp nomolos_weapon_animation
nomolos_weapon_animation: .res 2

.exportzp nomolos_counter_temp_invincibility_blink
nomolos_counter_temp_invincibility_blink: .res 1

.exportzp nomolos_counter_attack_rect
nomolos_counter_attack_rect: .res 1

.exportzp nomolos_state_primary
nomolos_state_primary: .res 1

.exportzp nomolos_state_secondary
nomolos_state_secondary: .res 1

.exportzp nomolos_status_health
nomolos_status_health: .res 1

.exportzp nomolos_status_lives
nomolos_status_lives: .res 1

.exportzp camera_scroll_x
camera_scroll_x:                           .res 2

.exportzp camera_scroll_next_x
camera_scroll_next_x:                       .res 2

.exportzp base_address_level
base_address_level:                  .res 2

.exportzp base_address_meta_meta_tile_table
base_address_meta_meta_tile_table:      .res 2

.exportzp base_address_meta_tile_table
base_address_meta_tile_table:          .res 2

.exportzp base_address_entity_definition_table
base_address_entity_definition_table:  .res 2

.exportzp base_address_rom_definition_table
base_address_rom_definition_table: .res 2

.exportzp level_current
level_current:                      .res 1

.exportzp buffer_attribute
buffer_attribute: .res 8

.exportzp attribute_column_to_update
attribute_column_to_update: .res 1

.exportzp buffer_column
buffer_column:  .res 60

.exportzp buffer_meta_tile
buffer_meta_tile:    .res 4

.exportzp column_to_update
column_to_update:    .res 1

.exportzp name_table_to_update
name_table_to_update: .res 1

.exportzp next_sprite_address
next_sprite_address: .res 1

.exportzp buffer_controller
buffer_controller: .res 8

.exportzp sound_address
sound_address: .res 2

.exportzp sound_offset
sound_offset: .res 1

.exportzp ft_music_addr
ft_music_addr: .res 2

;variables specific to level out state
.exportzp palette_step
palette_step: .res 1

.exportzp frame_counter
frame_counter: .res 1
