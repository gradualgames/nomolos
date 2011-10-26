.ifndef BOULDER_INC
BOULDER_INC = 1

.struct boulder_locals
  state_switch_counter .byte
.endstruct

BOULDER_WIDTH = $10
BOULDER_HEIGHT = $08
BOULDER_INITSTATE = $00
BOULDER_INITBOSSMODESTATE = $01
BOULDER_LIFTLEFTFOOTSTATE = $02
BOULDER_SLAMLEFTFOOTSTATE = $03

boulder_left_foot_up_tiles:
  .byte $04,$02,$da,$db,$dc,$dd,$e0,$e1,$e2,$e3

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

boulder_lift_left_foot:

  jmp boulder_lift_left_foot_handler

boulder_slam_left_foot:

  jmp boulder_slam_left_foot_handler

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

  lda #40
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

  lda #BOULDER_SLAMLEFTFOOTSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_states:
  .endscope

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

boulder_slam_left_foot_handler:

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
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  rts

.endproc

.endif

