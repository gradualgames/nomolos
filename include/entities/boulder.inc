.ifndef BOULDER_INC
BOULDER_INC = 1

.struct boulder_locals
  brightness_counter .byte
  state_switch_counter .byte
  substate_switch_counter .byte
  health .byte
  substate .byte
  erase_row .byte
.endstruct

BOULDER_WIDTH =               $30
BOULDER_HEIGHT =              $30

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

BOULDER_SUBSTATE_NOT_ATTACKED = 0
BOULDER_SUBSTATE_ATTACKED = 1
BOULDER_SUBSTATE_DYING = 2
BOULDER_SUBSTATE_ERASE = 3

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
  .byte $04,$02,$da,$db,$dc,$dd,$e2,$e3,$e4,$e5

boulder_left_foot_down_tiles:
  .byte $04,$02,$ce,$4d,$4d,$cf,$d4,$d5,$d6,$d7

boulder_right_foot_up_tiles:
  .byte $04,$06,$00,$d8,$d9,$52,$de,$df,$e0,$e1,$e6,$4d,$e7,$e8,$e9,$4d,$4d,$ea,$eb,$ec,$ed,$ee,$00,$00,$00,$00

boulder_right_foot_down_tiles:
  .byte $04,$06,$9f,$a0,$a1,$52,$aa,$ab,$ac,$ad,$4d,$4d,$b8,$b9,$c3,$4d,$4d,$c4,$cc,$4d,$4d,$cd,$d0,$d1,$d2,$d3

boulder_glowing_scepter_color_sequence:
  .byte $06, $16, $26, $36, $26, $16, $06, $06

boulder_attacked_color_sequence:
  .byte $24, $24, $34, $24, $24, $14, $14, $24

boulder_erase_row_tiles:
  .byte $12,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

.proc boulder_update

  jsr boulder_substate_handler

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

  rts

boulder_lift_left_foot:

  jmp boulder_lift_left_foot_handler

boulder_slam_left_foot:

  jmp boulder_slam_left_foot_handler

boulder_lift_right_foot:

  jmp boulder_lift_right_foot_handler

boulder_slam_right_foot:

  jmp boulder_slam_right_foot_handler

boulder_glowing_scepter:

  jmp boulder_glowing_scepter_handler

boulder_spawn_spiraliceballs:

  jmp boulder_spawn_spiraliceballs_handler

boulder_dying:

  jmp boulder_dying_handler

boulder_erase:

  jmp boulder_erase_handler

boulder_init:

  lda #1
  sta entity_locals+boulder_locals::state_switch_counter,x

  ;start Boulder out with a certain amount of health
  lda #15
  sta entity_locals+boulder_locals::health,x

  lda #BOULDER_INITBOSSMODESTATE
  sta entity_instances+entity_instance::state,x

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
  bne do_not_kill_boulder
  
  jsr entity_kill
  
do_not_kill_boulder:

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
  
  ldy #15
darken_boulder_palette_loop:
  lda dynamic_palette,y
  sta b0
  
  lda entity_locals+boulder_locals::brightness_counter,x
  sta b3
  
  jsr ppu_adjust_color_brightness
  
  lda b0
  sta dynamic_palette,y
  
  lda dynamic_palette+28,y
  sta b0
  
  lda entity_locals+boulder_locals::brightness_counter,x
  sta b3
  
  jsr ppu_adjust_color_brightness
  
  lda b0
  sta dynamic_palette+28,y
  
  dey
  bpl darken_boulder_palette_loop

  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  ;if the dragon has faded all the way out, switch to "erase" state
  lda entity_locals+boulder_locals::brightness_counter,x
  beq boulder_erase
  
  rts
  
boulder_erase:

  jsr play_level_state_init_victory_mode

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

  lda #112
  sta entity_screen_x
  lda #48
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
  
  ;make Nomolos invincible the instant we transition Boulder into dying state
  lda nomolos_state_primary
  ora #nomolos_invincibility_on_set
  sta nomolos_state_primary
  lda #0
  ;ensure that the invincibility blinking counter is already zero so it does not
  ;reset invincibility to "off" after the Boulder has already started dying
  sta nomolos_counter_temp_invincibility_blink
  
  lda #BOULDER_DYINGSTATE
  sta entity_instances+entity_instance::state,x
  
  lda #$fe
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
  
  lda #24
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
  
  lda #48
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

