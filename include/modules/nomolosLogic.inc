.ifndef NOMOLOSLOGIC_INC
NOMOLOSLOGIC_INC = 1

.global nomolos_module_init
.global nomolos_init
.global nomolos_update
.global nomolos_draw
.global nomolos_draw_hearts
.global nomolos_hurt
.global nomolos_is_deadly
.global nomolos_add_health
.global nomolos_add_life

;Nomolos state constants
nomolos_walking_right_clear           = %11111110
nomolos_walking_left_set              = %00000001
nomolos_walking_left_test             = %00000001
                                      
nomolos_moving_off_clear              = %11111101
nomolos_moving_on_set                 = %00000010
nomolos_moving_test                   = %00000010
                                      
nomolos_blinking_on_set               = %00000100
nomolos_blinking_off_clear            = %11111011
nomolos_blinking_test                 = %00000100
                                      
nomolos_below_collision_on_set        = %00001000
nomolos_below_collision_off_clear     = %11110111
nomolos_below_collision_test          = %00001000
                                      
nomolos_above_collision_on_set        = %00010000
nomolos_above_collision_off_clear     = %11101111
nomolos_above_collision_test          = %00010000
                                      
nomolos_attack_on_set                 = %00100000
nomolos_attack_off_clear              = %11011111
nomolos_attack_test                   = %00100000
                                      
nomolos_hurt_by_map_on_set            = %01000000
nomolos_hurt_by_map_off_clear         = %10111111
nomolos_hurt_by_map_test              = %01000000
                                      
nomolos_dying_on_set                  = %10000000
nomolos_dying_off_clear               = %01111111
nomolos_dying_test                    = %10000000
                                      
;nomolos sub-state constants          
nomolos_attacked_dying_set            = %00000001
nomolos_attacked_dying_test           = %00000001
nomolos_fell_dying_clear              = %11111110
                                      
nomolos_attack_test_mask              = %00000110
nomolos_attack_set_mask               = %11111001
nomolos_attack_state_sword            = %00000000
nomolos_attack_state_flail            = %00000010
nomolos_attack_state_spear            = %00000100
                                      
nomolos_attack_flail_length           = 18
nomolos_attack_flail_deadly_length    = 12

nomolos_time_til_level_out_transition = 100

nomolos_attack_direction_right_set    =  %00001000
nomolos_attack_direction_left_clear   = %11110111
nomolos_attack_direction_test         = %00001000

nomolos_starting_lives                = $03
nomolos_hurt_bounce_lo                = $0a
nomolos_hurt_bounce_hi                = $fd
nomolos_start_jump_lo                 = $00
nomolos_start_jump_hi                 = $f8
nomolos_start_jump_hi_pos             = $07
nomolos_vertical_acceleration_lo      = $5a
nomolos_vertical_acceleration_hi      = $00
nomolos_vertical_speed_max            = $0a
nomolos_width                         = $10
nomolos_height                        = $20

starting_level                        = $00
max_health                            = 3
max_lives                             = 20
last_entity                           = 15

;keeps the lowest 4 bits to get penetration distance from a y coordinate
penetration_calculation_mask          = %00001111

.endif
