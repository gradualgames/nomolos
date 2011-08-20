.include "zp.inc"

.segment "ZEROPAGE"

b0:       .res 1

b1:       .res 1

b2:       .res 1

b3:       .res 1

b4:       .res 1

b5:       .res 1

b6:       .res 1

b7:       .res 1

b8:       .res 1

b9:       .res 1

w0:       .res 2

w1:       .res 2

w2:       .res 2

w3:       .res 2

w4:       .res 2

w5:       .res 2

w6:       .res 2

w7:       .res 2

w8:       .res 2

w9:       .res 2

ppu_2000: .res 1

ppu_2001: .res 1

ppu_2005: .res 2

ppu_2006: .res 2

sprite_group_offset: .res 1

entity_screen_x: .res 2

entity_screen_y: .res 2

entity_prng_seed: .res 1

mapper_bank_current: .res 1

mapper_bank_next: .res 1

ppu_string_buffer: .res 8

nmi_counter: .res 1

update:     .res 2

update_ppu:  .res 2

state_control_params: .res 16

nomolos_map_x: .res 3  ;24 bit x (16 bit coord + 8 bit fine movement)

nomolos_map_y: .res 3  ;24 bit y (16 bit coord + 8 bit fine movement)

nomolos_x_velocity: .res 2

nomolos_y_velocity: .res 2

nomolos_screen_x: .res 2

nomolos_screen_y: .res 2

nomolos_attack_rect_x: .res 2

nomolos_attack_rect_y: .res 2

nomolos_attack_rect_width: .res 1

nomolos_attack_rect_height: .res 1

nomolos_out_of_armor_screen_x: .res 2

nomolos_out_of_armor_screen_y: .res 2

nomolos_below_ejection_distance: .res 1

nomolos_above_ejection_distance: .res 1

nomolos_animation: .res 2

nomolos_weapon_animation: .res 2

nomolos_counter_temp_invincibility_blink: .res 1

nomolos_counter_attack_rect: .res 1

nomolos_state_primary: .res 1

nomolos_state_secondary: .res 1

nomolos_status_health: .res 1

nomolos_status_lives: .res 1

camera_scroll_x: .res 2

camera_scroll_y: .res 1

camera_max_scroll_x: .res 2

camera_min_scroll_x: .res 2

camera_rightmost_x: .res 2

camera_scroll_direction: .res 1

camera_scroll_enabled: .res 1

base_address_entity_definition_table:  .res 2

base_address_rom_definition_table: .res 2

base_address_map: .res 2

base_address_map_column_table: .res 2

base_address_attribute_column_table: .res 2

base_address_meta_tile_column_table: .res 2

base_address_meta_tile_table: .res 2

level_current:                      .res 1

buffer_attribute: .res 8

attribute_column_to_update: .res 1

buffer_column:  .res 60

;the following variable is only used during boss play.
;thus it can occupy the same address as the map column buffer.

buffer_rectangle = buffer_column

buffer_meta_tile:    .res 4

;the following four variables are only used during boss play.
;thus they can occupy some of zp that was being used by the map.

buffer_rectangle_x = buffer_meta_tile

buffer_rectangle_y = buffer_meta_tile+1

buffer_rectangle_width = buffer_meta_tile+2

buffer_rectangle_height = buffer_meta_tile+3

column_to_update:    .res 1

name_table_to_update: .res 1

name_table_to_view: .res 1

next_sprite_address: .res 1

buffer_controller: .res 8

;variables specific to level out state
;TODO: these should be moved to the state control params perhaps

palette_step: .res 1

frame_counter: .res 1

;variables to store where to restart upon losing a life

restart_x: .res 1

restart_y: .res 1

restart_screen: .res 1
