.ifndef BOULDER_INC
BOULDER_INC = 1

.struct boulder_locals
  state_switch_counter .byte
.endstruct

BOULDER_WIDTH =               $10
BOULDER_HEIGHT =              $08

BOULDER_INITSTATE =           $00
BOULDER_INITBOSSMODESTATE  =  $01
BOULDER_LIFTLEFTFOOTSTATE  =  $02
BOULDER_SLAMLEFTFOOTSTATE  =  $03
BOULDER_LIFTRIGHTFOOTSTATE =  $04
BOULDER_SLAMRIGHTFOOTSTATE =  $05
BOULDER_GLOWINGSCEPTERSTATE = $06

LIFT_LEFT_FOOT_STATE_DURATION = 20
SLAM_LEFT_FOOT_STATE_DURATION = 35
LIFT_RIGHT_FOOT_STATE_DURATION = 20
SLAM_RIGHT_FOOT_STATE_DURATION = 35
GLOWING_SCEPTER_STATE_DURATION = 110
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

boulder_init:

  lda #1
  sta entity_locals+boulder_locals::state_switch_counter,x

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
  
  lda #LIFT_LEFT_FOOT_STATE_DURATION
  sta entity_locals+boulder_locals::state_switch_counter,x

  lda #BOULDER_LIFTLEFTFOOTSTATE
  sta entity_instances+entity_instance::state,x

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

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

