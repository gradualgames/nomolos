.ifndef BOULDER_INC
BOULDER_INC = 1

.include "controller.inc"

.struct boulder_locals
  brightness_counter .byte
  state_switch_counter .byte
  substate_switch_counter .byte
  health .byte
  substate .byte
  snow_state .byte
  erase_row .byte
.endstruct

BOULDER_WIDTH =               $30
BOULDER_HEIGHT =              $10

BOULDER_INITSTATE                = $00
BOULDER_INITBOSSMODESTATE        = $01
BOULDER_LIFTLEFTFOOTSTATE        = $02
BOULDER_SLAMLEFTFOOTSTATE        = $03
BOULDER_LIFTRIGHTFOOTSTATE       = $04
BOULDER_SLAMRIGHTFOOTSTATE       = $05
BOULDER_GLOWINGSCEPTERSTATE      = $06
BOULDER_SPAWNSPIRALICEBALLSSTATE = $07
BOULDER_DYINGSTATE               = $08
BOULDER_ERASESTATE               = $09
BOULDER_SNOWAPPEARSSTATE         = $0a

BOULDER_SUBSTATE_NOT_ATTACKED = 0
BOULDER_SUBSTATE_ATTACKED = 1
BOULDER_SUBSTATE_DYING = 2
BOULDER_SUBSTATE_ERASE = 3

SNOW_INIT                    = 0
SNOW_WALK_ONTO_SCREEN        = 1
SNOW_ALIGN_NOMOLOS_WITH_SNOW = 2
SNOW_ALIGNED_WITH_NOMOLOS    = 3

LIFT_LEFT_FOOT_STATE_DURATION = 20
SLAM_LEFT_FOOT_STATE_DURATION = 35
LIFT_RIGHT_FOOT_STATE_DURATION = 20
SLAM_RIGHT_FOOT_STATE_DURATION = 35
GLOWING_SCEPTER_STATE_DURATION = 110
SPAWN_SPIRALICEBALLS_STATE_DURATION = 150
DRAW_LEFT_FOOT_DOWN_TIME = 20
DRAW_RIGHT_FOOT_DOWN_TIME = 20
LIGHTNINGBOLT_FLASHMASK = 2

boulder_left_foot_up_tiles:
  .byte $04,$02,$e2,$e3,$e4,$e5,$ea,$eb,$ec,$ed

boulder_left_foot_down_tiles:
  .byte $04,$02,$d6,$4d,$4d,$d7,$dc,$dd,$de,$df

boulder_right_foot_up_tiles:
  .byte $04,$06,$00,$e0,$e1,$52,$e6,$e7,$e8,$e9,$ee,$4d,$ef,$f0,$f1,$4d,$4d,$f2,$f3,$f4,$f5,$f6,$00,$00,$00,$00

boulder_right_foot_down_tiles:
  .byte $04,$06,$a1,$a2,$a3,$52,$ad,$ae,$af,$b0,$4d,$4d,$bb,$bc,$c8,$4d,$4d,$c9,$d4,$4d,$4d,$d5,$d8,$d9,$da,$db

boulder_glowing_scepter_color_sequence:
  .byte $06, $16, $26, $36, $26, $16, $06, $06

boulder_attacked_color_sequence:
  .byte $24, $24, $34, $24, $24, $14, $14, $24

boulder_erase_row_tiles:
  .byte $13,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;this palette gets uploaded in the background before we show Princess Snow
boss5_sprite_palette_after_boulder_dies:
  .byte $3f,$07,$06,$20,$3f,$04,$24,$20,$3f,$04,$14,$24,$3f,$07,$06,$04
  .byte $3f,$3f,$27,$20,$3f,$3f,$04,$2a,$3f,$06,$28,$21,$3f,$0d,$15,$20

.proc boulder_update

  lda entity_instances+entity_instance::state,x
  cmp #BOULDER_INITSTATE
  beq boulder_init
  cmp #BOULDER_INITBOSSMODESTATE
  beq boulder_init_boss_mode
  cmp #BOULDER_LIFTLEFTFOOTSTATE
  beq boulder_lift_left_foot
  cmp #BOULDER_SLAMLEFTFOOTSTATE
  beq boulder_slam_left_foot
  cmp #BOULDER_LIFTRIGHTFOOTSTATE
  beq boulder_lift_right_foot
  cmp #BOULDER_SLAMRIGHTFOOTSTATE
  beq boulder_slam_right_foot
  cmp #BOULDER_GLOWINGSCEPTERSTATE
  beq boulder_glowing_scepter
  cmp #BOULDER_SPAWNSPIRALICEBALLSSTATE
  beq boulder_spawn_spiraliceballs
  cmp #BOULDER_DYINGSTATE
  beq boulder_dying
  cmp #BOULDER_ERASESTATE
  beq boulder_erase
  cmp #BOULDER_SNOWAPPEARSSTATE
  beq boulder_snow_appears

  rts

boulder_lift_left_foot:

  jsr boulder_substate_handler

  jmp boulder_lift_left_foot_handler

boulder_slam_left_foot:

  jsr boulder_substate_handler

  jmp boulder_slam_left_foot_handler

boulder_lift_right_foot:

  jsr boulder_substate_handler

  jmp boulder_lift_right_foot_handler

boulder_slam_right_foot:

  jsr boulder_substate_handler

  jmp boulder_slam_right_foot_handler

boulder_glowing_scepter:

  jsr boulder_substate_handler

  jmp boulder_glowing_scepter_handler

boulder_spawn_spiraliceballs:

  jsr boulder_substate_handler

  jmp boulder_spawn_spiraliceballs_handler

boulder_dying:

  jsr boulder_substate_handler

  jmp boulder_dying_handler

boulder_erase:

  jsr boulder_substate_handler

  jmp boulder_erase_handler

boulder_snow_appears:

  ;no substate, boulder herself is erased and the battle is over

  jmp boulder_snow_appears_handler

boulder_init:

  ;clear out special weapon bit (this is done for balance, some bosses are
  ;rendered too easy with the spear or flail)
  lda nomolos_state_secondary
  and #nomolos_attack_set_mask
  sta nomolos_state_secondary

  lda #1
  sta entity_locals+boulder_locals::state_switch_counter,x

  ;set health based on difficulty
  lda difficulty
  cmp #EASY_DIFFICULTY
  bne :+
  lda #20
  jmp :++
:
  lda #30
:
  sta entity_locals+boulder_locals::health,x

  lda #BOULDER_INITBOSSMODESTATE
  sta entity_instances+entity_instance::state,x

  lda #BOULDER_SUBSTATE_NOT_ATTACKED
  sta entity_locals+boulder_locals::substate,x

  rts

boulder_init_boss_mode:

  dec entity_locals+boulder_locals::state_switch_counter,x
  bne do_not_switch_states

  jsr play_level_state_init_boss_mode

  lda #LIFT_LEFT_FOOT_STATE_DURATION
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #BOULDER_LIFTLEFTFOOTSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_states:

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

boulder_lift_left_foot_handler:

  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

  dec entity_locals+boulder_locals::state_switch_counter,x
  .scope
  bne do_not_switch_states

  lda #24
  sta b0
  lda #24
  sta b1
  lda #<boulder_left_foot_up_tiles
  sta w0
  lda #>boulder_left_foot_up_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region

  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data

  lda #SLAM_LEFT_FOOT_STATE_DURATION
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #BOULDER_SLAMLEFTFOOTSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_states:
  .endscope

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

exit_slam_left_foot_state:

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  lda #LIFT_RIGHT_FOOT_STATE_DURATION
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #BOULDER_LIFTRIGHTFOOTSTATE
  sta entity_instances+entity_instance::state,x

  rts

boulder_slam_left_foot_handler:

  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

  dec entity_locals+boulder_locals::state_switch_counter,x
  beq exit_slam_left_foot_state

  lda entity_locals+boulder_locals::state_switch_counter,x
  cmp #DRAW_LEFT_FOOT_DOWN_TIME
  bne only_draw_left_foot_down_once

  jsr boulder_spawn_lightningbolts

  ;play a boom sound
  txa
  pha

  lda #<boss_boom_sound
  sta sound_param_word_0
  lda #>boss_boom_sound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax

  lda #24
  sta b0
  lda #24
  sta b1
  lda #<boulder_left_foot_down_tiles
  sta w0
  lda #>boulder_left_foot_down_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region

  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data

only_draw_left_foot_down_once:
  bpl do_not_shake_screen_yet

  ;shake the screen during slam state
  and #%00000010
  sta camera_scroll_y

do_not_shake_screen_yet:

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

boulder_lift_right_foot_handler:

  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

  dec entity_locals+boulder_locals::state_switch_counter,x
  .scope
  bne do_not_switch_states

  lda #16
  sta b0
  lda #20
  sta b1
  lda #<boulder_right_foot_up_tiles
  sta w0
  lda #>boulder_right_foot_up_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region

  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data

  lda #SLAM_RIGHT_FOOT_STATE_DURATION
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #BOULDER_SLAMRIGHTFOOTSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_states:
  .endscope

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

boulder_slam_right_foot_handler:

  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

  dec entity_locals+boulder_locals::state_switch_counter,x
  beq exit_slam_right_foot_state

  lda entity_locals+boulder_locals::state_switch_counter,x
  cmp #DRAW_RIGHT_FOOT_DOWN_TIME
  bne only_draw_right_foot_down_once

  jsr boulder_spawn_lightningbolts

  ;play a boom sound
  txa
  pha

  lda #<boss_boom_sound
  sta sound_param_word_0
  lda #>boss_boom_sound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax

  lda #16
  sta b0
  lda #20
  sta b1
  lda #<boulder_right_foot_down_tiles
  sta w0
  lda #>boulder_right_foot_down_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region

  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data

only_draw_right_foot_down_once:
  .scope
  bpl do_not_shake_screen_yet

  ;shake the screen during slam state
  and #%00000010
  sta camera_scroll_y

do_not_shake_screen_yet:
  .endscope

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

exit_slam_right_foot_state:

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  lda #GLOWING_SCEPTER_STATE_DURATION
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #BOULDER_GLOWINGSCEPTERSTATE
  sta entity_instances+entity_instance::state,x

  rts

boulder_glowing_scepter_handler:

  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

  .scope
  
  dec entity_locals+boulder_locals::state_switch_counter,x

  lda entity_locals+boulder_locals::state_switch_counter,x
  cmp #64
  bpl pause_before_glow
  cmp #32
  beq switch_state
  and #%00011100
  lsr
  lsr

  ;get the current color the scepter should be
  tay
  lda boulder_glowing_scepter_color_sequence,y
  
  sta dynamic_palette + $19
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data
  
pause_before_glow:
  .endscope
  
  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

switch_state:
  
  lda #SPAWN_SPIRALICEBALLS_STATE_DURATION
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #BOULDER_SPAWNSPIRALICEBALLSSTATE
  sta entity_instances+entity_instance::state,x

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

boulder_spawn_spiraliceballs_handler:

  dec entity_locals+boulder_locals::state_switch_counter,x

  lda entity_locals+boulder_locals::state_switch_counter,x
  beq exit_spawn_spiraliceballs_handler
  and #%00001111
  cmp #$0f
  bne do_not_spawn_spiral_iceball

  lda #entity_index_spiraliceball
  sta b0

  lda #150
  sta w0
  lda #0
  sta w0+1
  
  lda #120
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

do_not_spawn_spiral_iceball:

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

exit_spawn_spiraliceballs_handler:

  lda #LIFT_LEFT_FOOT_STATE_DURATION
  sta entity_locals+boulder_locals::state_switch_counter,x
  
  lda #BOULDER_LIFTLEFTFOOTSTATE
  sta entity_instances+entity_instance::state,x

  rts

boulder_dying_handler:

  dec entity_locals+boulder_locals::state_switch_counter,x
  
  ;the following code can modify how frequently explosions appear
  ;lda entity_locals+boulder_locals::state_switch_counter,x
  ;and #%00000100
  ;beq do_not_spawn_explosion

  ;generate random coordinates for explosion entity
  ldy #10
  jsr entity_get_next_prn
  lsr
  clc
  adc #100
  sta w0
  lda #0
  sta w0+1
  
  ldy #10
  jsr entity_get_next_prn
  sta w1
  lda #0
  sta w1+1
  
  ;only spawn explosion if these coordinates are on the dragon (hurt tile)
  jsr map_test_collision
  
  lda b0
  
  beq do_not_spawn_explosion
  
  lda #entity_index_explosion
  sta b0

  lda w1
   
  sta b1

  lda #0
  sta b2

  jsr entity_spawn
  
  txa
  pha

  lda #<hit_sound
  sta sound_param_word_0
  lda #>hit_sound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax
  
do_not_spawn_explosion:

  ;make the screen shake
  lda entity_locals+boulder_locals::state_switch_counter,x
  and #%00000010
  asl
  sta camera_scroll_y

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

boulder_erase_handler:

  ;make sure to clean up mess from vibrating the screen
  lda #0
  sta camera_scroll_x

  dec entity_locals+boulder_locals::state_switch_counter,x

  lda entity_locals+boulder_locals::state_switch_counter,x
  and #%00000111
  bne do_not_increment_erase_row
  
  ;draw an erase row
  lda #13
  sta b0
  lda entity_locals+boulder_locals::erase_row,x
  sta b1
  lda #<boulder_erase_row_tiles
  sta w0
  lda #>boulder_erase_row_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  inc entity_locals+boulder_locals::erase_row,x
  
do_not_increment_erase_row:

  lda entity_locals+boulder_locals::state_switch_counter,x
  bne do_not_switch_to_snow_appears_state
  
  ;set coordinates of this entity to be off screen to the right but at
  ;the same level as Nomolos.
  lda #175
  sta entity_instances+entity_instance::position_y,x
  lda #0
  sta entity_instances+entity_instance::position_y+1,x
  lda #0
  sta entity_instances+entity_instance::position_x,x
  lda #1
  sta entity_instances+entity_instance::position_x+1,x

  ;set initial state for the mini Snow state machine
  lda #SNOW_INIT
  sta entity_locals+boulder_locals::snow_state,x

  ;transition to pre-ending scene (Snow walks up to Nomolos)
  lda #BOULDER_SNOWAPPEARSSTATE
  sta entity_instances+entity_instance::state,x
  
do_not_switch_to_snow_appears_state:

  rts

boulder_snow_appears_handler:

  lda entity_locals+boulder_locals::snow_state,x
  cmp #SNOW_INIT
  beq snow_init
  cmp #SNOW_WALK_ONTO_SCREEN
  beq snow_walk_onto_screen
  cmp #SNOW_ALIGN_NOMOLOS_WITH_SNOW
  beq align_nomolos_with_snow
  cmp #SNOW_ALIGNED_WITH_NOMOLOS
  beq snow_aligned_with_nomolos

snow_init:

  jsr play_level_state_init_hands_off_victory_mode

  ;make certain Nomolos isn't moving until we tell him to
  lda #nomolos_invincibility_on_set
  ora #nomolos_below_collision_on_set
  sta nomolos_state_primary

  ;make certain Nomolos' X coordinate is even or the logic
  ;which aligns him with Snow will fail and he will walk
  ;at her permanently. The game is designed to always add or
  ;subtract 2 from Nomolos' coordinate; nevertheless, I am
  ;putting in this safeguard in case there's some odd way to
  ;get his coordinate to be odd that I don't know about
  ;(besides using a hex editor)
  lda nomolos_map_x+1
  and #%11111110   ;make sure last bit is 0 (even)
  sta nomolos_map_x+1
  ;ensure x velocity is correct
  lda #0
  sta nomolos_x_velocity
  lda #2
  sta nomolos_x_velocity+1
  
  reset_anim nomolos_animation

  jsr entity_reset_anim

  lda #<boss5_sprite_palette_after_boulder_dies
  sta w0
  lda #>boss5_sprite_palette_after_boulder_dies
  sta w0+1
  lda #3
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

  lda #SNOW_WALK_ONTO_SCREEN
  sta entity_locals+boulder_locals::snow_state,x

  rts

snow_walk_onto_screen:

  jmp snow_walk_onto_screen_handler
  
snow_aligned_with_nomolos:

  dec entity_locals+boulder_locals::state_switch_counter,x
  bne skip_switch_to_ending_state

  lda #PLAYLEVELSTATE_SWITCHTOENDINGSTATE
  sta state_control_params+play_level_state_control::state

skip_switch_to_ending_state:

  jsr draw_snow

  rts

align_nomolos_with_snow:

  ;compare Nomolos' coordinate with Snow's coordinate. If greater than 16 less
  ;than Snow's X coordinate, walk left.
  ;If less than 16 less than Snow's X coordinate, walk right.
  ;If equal to 16 less than Snow's X coordinate, ensure facing right.

  ;calculate 16 less than Snow's coordinates
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #$10
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sbc #$00
  sta w0+1

  ;compare this value to Nomolos's map coordinate
  sec
  lda w0
  sbc nomolos_map_x+1
  beq nomolos_and_snow_aligned
  lda w0+1
  sbc nomolos_map_x+2

  ;if this is positive, we're to the left of Snow
  bpl walk_right

  ;if this is negative, we're to the right of Snow
  bmi walk_left

  jmp walk_test_done

walk_right:

  lda #%11111111
  sta buffer_controller+buttons::_right

  jmp walk_test_done

walk_left:

  lda #%11111111
  sta buffer_controller+buttons::_left

walk_test_done:

  jsr draw_snow

  rts

snow_walk_onto_screen_handler:

  ;compute address of animation object based on current entity index and animation_object
  ;offset
  txa
  sta w1
  clc
  adc #<(entity_instances+entity_instance::animation_object)
  sta w1
  lda #0
  adc #>(entity_instances+entity_instance::animation_object)
  sta w1+1

  lda #<spritesheet1_SnowWalk
  sta w2
  lda #>spritesheet1_SnowWalk
  sta w2+1

  jsr sprite_update_animation

  jsr draw_snow

  ;now move snow left
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #1
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  ;compare coordinates to a certain value. Once we're there,
  ;transition to the align nomolos with snow state.

  lda entity_instances+entity_instance::position_x,x
  cmp #150
  bne do_not_switch_to_align_state

  ;lda #nomolos_moving_on_set
  ;sta nomolos_state_primary
  ;sta nomolos_counter_temp_invincibility_blink

  lda #SNOW_ALIGN_NOMOLOS_WITH_SNOW
  sta entity_locals+boulder_locals::snow_state,x

do_not_switch_to_align_state:

  rts

nomolos_and_snow_aligned:

  lda #SNOW_ALIGNED_WITH_NOMOLOS
  sta entity_locals+boulder_locals::snow_state,x

  lda #10
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #$00
  sta buffer_controller+buttons::_right
  sta buffer_controller+buttons::_left

  lda #nomolos_below_collision_on_set
  sta nomolos_state_primary

  reset_anim nomolos_animation

  jsr draw_snow

  rts

draw_snow:

  jsr entity_compute_screen_coordinates

  lda entity_chr_offsets+(entity_index_boulder-1)
  sta sprite_group_offset

  lda #0
  sta b2

  txa
  sta w1
  clc
  adc #<(entity_instances+entity_instance::animation_object)
  sta w1
  lda #0
  adc #>(entity_instances+entity_instance::animation_object)
  sta w1+1

  lda #<spritesheet1_SnowWalk
  sta w2
  lda #>spritesheet1_SnowWalk
  sta w2+1
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_animation_16bit

  txa
  sta w1
  clc
  adc #<(entity_instances+entity_instance::animation_object)
  sta w1
  lda #0
  adc #>(entity_instances+entity_instance::animation_object)
  sta w1+1

  lda #<spritesheet1_SnowWalkOverlay
  sta w2
  lda #>spritesheet1_SnowWalkOverlay
  sta w2+1
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_animation_16bit

  rts

boulder_substate_handler:
 
  lda entity_locals+boulder_locals::substate,x
  cmp #BOULDER_SUBSTATE_NOT_ATTACKED
  beq boulder_substate_not_attacked
  cmp #BOULDER_SUBSTATE_ATTACKED
  beq boulder_substate_attacked
  cmp #BOULDER_SUBSTATE_DYING
  beq boulder_substate_dying
  cmp #BOULDER_SUBSTATE_ERASE
  beq boulder_substate_erase

boulder_substate_not_attacked:

  jsr boulder_substate_not_attacked_handler

  jmp boulder_substate_switch_complete
  
boulder_substate_attacked:
  
  jsr boulder_substate_attacked_handler
 
  jmp boulder_substate_switch_complete
  
boulder_substate_dying:

  jsr boulder_substate_dying_handler

  jmp boulder_substate_switch_complete

boulder_substate_erase:

  jsr boulder_substate_erase_handler

boulder_substate_switch_complete:
  
  rts

.proc boulder_substate_dying_handler

  dec entity_locals+boulder_locals::substate_switch_counter,x
  dec entity_locals+boulder_locals::substate_switch_counter,x
  bne do_not_decrement_brightness_counter
  
  dec entity_locals+boulder_locals::brightness_counter,x
  
do_not_decrement_brightness_counter:
  
  ;darken the background palette
  .scope
  ldy #15
darken_boulder_palette_loop:
  lda dynamic_palette,y
  sta b0
  
  lda entity_locals+boulder_locals::brightness_counter,x
  sta b3
  
  jsr ppu_adjust_color_brightness
  
  lda b0
  sta dynamic_palette,y
  
  dey
  bpl darken_boulder_palette_loop
  .endscope

  ;darken just Boulder's sprite palette
  .scope
  ldy #4
darken_boulder_palette_loop:
  lda dynamic_palette+8,y
  sta b0
  
  lda entity_locals+boulder_locals::brightness_counter,x
  sta b3
  
  jsr ppu_adjust_color_brightness
  
  lda b0
  sta dynamic_palette+8,y
  
  dey
  bpl darken_boulder_palette_loop
  .endscope

  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  ;if the dragon has faded all the way out, switch to "erase" state
  lda entity_locals+boulder_locals::brightness_counter,x
  beq boulder_erase
  
  rts
  
boulder_erase:

  lda #160
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #6
  sta entity_locals+boulder_locals::erase_row,x
  
  lda #BOULDER_ERASESTATE
  sta entity_instances+entity_instance::state,x
  
  lda #BOULDER_SUBSTATE_ERASE
  sta entity_locals+boulder_locals::substate,x
  
  rts

.endproc

;****************************************************************
;Boulder's substate not attacked handler
;****************************************************************
.proc boulder_substate_not_attacked_handler

  jsr nomolos_is_deadly
  beq nomolos_not_attacking

  lda #128
  sta entity_screen_x
  lda #88
  sta entity_screen_y
  lda #0
  sta entity_screen_x+1
  sta entity_screen_y+1
  
  lda #BOULDER_WIDTH
  sta b2
  lda #BOULDER_HEIGHT
  sta b3

  jsr entity_test_collision_hitbox

  bne boulder_not_hit
boulder_hit:
  
  txa
  pha

  lda #<boss_hurt_sound
  sta sound_param_word_0
  lda #>boss_hurt_sound
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax
  
  ;decrease health
  dec entity_locals+boulder_locals::health,x
  
  ;the attacked state should live for a few frames while palette flickers
  lda #24
  sta entity_locals+boulder_locals::substate_switch_counter,x
  
  ;set substate to attacked
  lda #BOULDER_SUBSTATE_ATTACKED
  sta entity_locals+boulder_locals::substate,x
  
boulder_not_hit:
  
nomolos_not_attacking:

  rts
.endproc
  
;****************************************************************
;Boulder's substate attacked handler
;****************************************************************
.proc boulder_substate_attacked_handler

  ;while we are in the attacked state, we want to be flickering
  ;the Dragon's palette somehow
  
  .scope
  
  lda entity_locals+boulder_locals::substate_switch_counter,x
  and #%00000111

  ;get the current color the eyes should be
  tay
  lda boulder_attacked_color_sequence,y
  
  sta dynamic_palette + $06

  sta dynamic_palette + $0b
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  .endscope
  
  dec entity_locals+boulder_locals::substate_switch_counter,x
  bne do_not_switch_to_not_attacked_state
  
  lda #BOULDER_SUBSTATE_NOT_ATTACKED
  sta entity_locals+boulder_locals::substate,x
  
do_not_switch_to_not_attacked_state:
  
  ;find out if boulder should die now
  lda entity_locals+boulder_locals::health,x
  bne do_not_switch_to_dying_state
  
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif
  
  ;workaround to ensure Nomolos cannot be dying when he has delivered the final blow
  jsr nomolos_ensure_not_dying

  ;make Nomolos invincible the instant we transition Boulder into dying state
  lda nomolos_state_primary
  ora #nomolos_invincibility_on_set
  sta nomolos_state_primary
  lda #0
  ;ensure that the invincibility blinking counter is already zero so it does not
  ;reset invincibility to "off" after the Boulder has already started dying
  sta nomolos_counter_temp_invincibility_blink
  
  ;kill all entities (Boulder usually has too much going on screen that will
  ;still be alive after she is defeated, so we just kill it all off now)
  txa
  pha

  jsr entity_init_all

  pla
  tax

  ;except the current one, which needs to live a little longer to perform the
  ;death animation and switch to the ending scene.
  lda #1
  sta entity_instances+entity_instance::alive,x

  lda #BOULDER_DYINGSTATE
  sta entity_instances+entity_instance::state,x
  
  lda #$fe
  sta entity_locals+boulder_locals::state_switch_counter,x
  sta entity_locals+boulder_locals::substate_switch_counter,x
  
  lda #4
  sta entity_locals+boulder_locals::brightness_counter,x
  
  lda #BOULDER_SUBSTATE_DYING
  sta entity_locals+boulder_locals::substate,x
do_not_switch_to_dying_state:
  
  rts

.endproc

.proc boulder_substate_erase_handler

  rts

.endproc

boulder_draw:

  lda entity_chr_offsets+(entity_index_boulder-1)
  sta sprite_group_offset

  lda #<spritesheet1_BoulderEye0
  sta w0
  lda #>spritesheet1_BoulderEye0
  sta w0+1

  lda #%00000000
  sta b2

  lda #141
  sta w3
  lda #0
  sta w3+1
  lda #92
  sec
  sbc camera_scroll_y
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet1_BoulderEye1
  sta w0
  lda #>spritesheet1_BoulderEye1
  sta w0+1

  lda #%00000000
  sta b2

  lda #164
  sta w3
  lda #0
  sta w3+1
  lda #94
  sec
  sbc camera_scroll_y
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet1_BoulderCrown0
  sta w0
  lda #>spritesheet1_BoulderCrown0
  sta w0+1

  lda #%00000000
  sta b2

  lda #152
  sta w3
  lda #0
  sta w3+1
  lda #64
  sec
  sbc camera_scroll_y
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet1_BoulderScepter0
  sta w0
  lda #>spritesheet1_BoulderScepter0
  sta w0+1

  lda #%00000000
  sta b2

  lda #160
  sta w3
  lda #0
  sta w3+1
  lda #127
  sec
  sbc camera_scroll_y
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet1_BoulderScepter1
  sta w0
  lda #>spritesheet1_BoulderScepter1
  sta w0+1

  lda #%00000000
  sta b2

  lda #184
  sta w3
  lda #0
  sta w3+1
  lda #159
  sec
  sbc camera_scroll_y
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  rts

boulder_spawn_lightningbolts:

  ;spawn some lightning entities

  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda nomolos_screen_x
  sta w0
  lda #0
  sta w0+1
  
  lda #0
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the lightningbolt we just spawned
  lda #LIGHTNINGBOLT_FLASHMASK
  sta entity_locals+lightningbolt_locals::flash_mask,y

  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda nomolos_screen_x
  sta w0
  lda #0
  sta w0+1
  
  lda #32
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the lightningbolt we just spawned
  lda #LIGHTNINGBOLT_FLASHMASK
  sta entity_locals+lightningbolt_locals::flash_mask,y

  rts

.endproc

.endif

