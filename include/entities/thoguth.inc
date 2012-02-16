.ifndef THOGUTH_INC
THOGUTH_INC = 1

.struct thoguth_locals
  y_velocity .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
  direction .byte
  move_stop .byte
  jump_slam .byte
  dying_counter .byte
  health .byte
  damaged_counter .byte
.endstruct

.struct thoguth_victorystate_locals
  victory_counter .word
  open_exit_counter .byte
  open_exit_row .byte
.endstruct

THOGUTH_WIDTH = $18
THOGUTH_HALFWIDTH = $0C
THOGUTH_HEIGHT = $30
THOGUTH_HALFHEIGHT = $10

LIGHTNINGBOLT_HORIZ_SPACING = 45
LIGHTNINGBOLT_VERT_SPACING  = 32

JUMP_SLAM_INTERVAL = 50

THOGUTH_LEFT_BOUNDARY = 32
THOGUTH_RIGHT_BOUNDARY = (256 - (16 * 3) - THOGUTH_WIDTH)
MOVE_STOP_INTERVAL = 80
THOGUTH_SPEED_LO = 128
THOGUTH_SPEED_HI = 1

THOGUTH_INITSTATE  = 0
THOGUTH_MOVESTATE  = 1
THOGUTH_STOPSTATE  = 2
THOGUTH_JUMPSTATE  = 3
THOGUTH_SLAMSTATE  = 4
THOGUTH_DYINGSTATE = 5
THOGUTH_VICTORYSTATE = 6
THOGUTH_OPENEXITSTATE = 7
THOGUTH_KILLSTATE = 8

;nametable region for opening the door at the back of Thoguth's arena
;row by row
row_of_black_tiles:
.byte $04, $01, $0a, $0a, $0a, $0a

;a patch of red brick tiles to cover up garbage tiles uploaded to the ppu
;when we revert to play level state
patch_tiles:
.byte $01,$04,$0d,$19,$0d,$19

.proc thoguth_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #THOGUTH_INITSTATE
  beq thoguth_initState
  cmp #THOGUTH_MOVESTATE
  beq thoguth_moveState
  cmp #THOGUTH_STOPSTATE
  beq thoguth_stopState
  cmp #THOGUTH_JUMPSTATE
  beq thoguth_jumpState
  cmp #THOGUTH_SLAMSTATE
  beq thoguth_slamState
  cmp #THOGUTH_DYINGSTATE
  beq thoguth_dyingState
  cmp #THOGUTH_VICTORYSTATE
  beq thoguth_victoryState
  cmp #THOGUTH_OPENEXITSTATE
  beq thoguth_openExitState
  cmp #THOGUTH_KILLSTATE
  beq thoguth_killState

thoguth_initState:

  jmp thoguth_initState_handler
  
thoguth_moveState:

  jmp thoguth_moveState_handler
  
thoguth_stopState:

  jmp thoguth_stopState_handler
  
thoguth_jumpState:

  jmp thoguth_jumpState_handler
  
thoguth_slamState:

  jmp thoguth_slamState_handler
  
thoguth_dyingState:

  jmp thoguth_dyingState_handler
  
thoguth_victoryState:

  jmp thoguth_victoryState_handler
  
thoguth_openExitState:

  jmp thoguth_openExitState_handler
  
thoguth_killState:

  jmp thoguth_killState_handler
  
thoguth_initState_handler:

  ;clear out special weapon bit (this is done for balance, some bosses are
  ;rendered too easy with the spear or flail)
  lda nomolos_state_secondary
  and #nomolos_attack_set_mask
  sta nomolos_state_secondary

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;disable camera scroll
  lda #0
  sta camera_scroll_enabled
  
  ;set health based on difficulty
  lda difficulty
  cmp #EASY_DIFFICULTY
  bne :+
  lda #15
  jmp :++
:
  lda #20
:
  sta entity_locals+thoguth_locals::health,x
  
  ;initial damaged counter
  lda #0
  sta entity_locals+thoguth_locals::damaged_counter,x
  
  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #32
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  
  lda #0
  sta entity_locals+thoguth_locals::direction,x
  lda #JUMP_SLAM_INTERVAL
  sta entity_locals+thoguth_locals::jump_slam,x
  lda #MOVE_STOP_INTERVAL
  sta entity_locals+thoguth_locals::move_stop,x

  lda #THOGUTH_MOVESTATE
  sta entity_instances+entity_instance::state,x

  rts

thoguth_stopState_handler:

  jsr entity_reset_anim

  .scope
  dec entity_locals+thoguth_locals::move_stop,x
  bne do_not_switch_state

  lda #MOVE_STOP_INTERVAL
  sta entity_locals+thoguth_locals::move_stop,x

  lda #THOGUTH_MOVESTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_state:
  .endscope

  jsr thoguth_draw
  jsr thoguth_hurt_nomolos
  
  rts
  
thoguth_jumpState_handler:

  ;increment the vertical velocity
  lda entity_locals+thoguth_locals::y_velocity+1,x
  cmp #10
  bpl stopAccelerating
  clc
  lda entity_locals+thoguth_locals::y_velocity,x
  adc #$20
  sta entity_locals+thoguth_locals::y_velocity,x
  lda entity_locals+thoguth_locals::y_velocity+1,x
  adc #0
  sta entity_locals+thoguth_locals::y_velocity+1,x
stopAccelerating:

  ;add vertical velocity to 24 bit Y coordinate with sign extension
  clc
  lda entity_locals+thoguth_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+thoguth_locals::y_velocity+1,x
  bmi signExtend
  adc entity_instances+entity_instance::position_y,x
  sta entity_instances+entity_instance::position_y,x
  lda #0
  adc entity_instances+entity_instance::position_y+1,x
  sta entity_instances+entity_instance::position_y+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entity_instance::position_y,x
  sta entity_instances+entity_instance::position_y,x
  lda #$ff
  adc entity_instances+entity_instance::position_y+1,x
  sta entity_instances+entity_instance::position_y+1,x
signExtendAddDone:

  ;perform collision detection and eject if necessary
  ;load the entity's X coordinate + 8
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #THOGUTH_HALFWIDTH
  sta entity_locals+thoguth_locals::x_collisionPointBottom,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_locals+thoguth_locals::x_collisionPointBottom+1,x
  sta w0+1
  ;load the entity's Y coordinate + height
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #THOGUTH_HEIGHT
  sta entity_locals+thoguth_locals::y_collisionPointBottom,x
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_locals+thoguth_locals::y_collisionPointBottom+1,x
  sta w1+1

  jsr map_test_collision
  lda b1
  beq noBottomCollision

  lda #0
  sta entity_locals+thoguth_locals::y_velocity,x
  sta entity_locals+thoguth_locals::y_velocity+1,x

  ;there was a collision beneath the entity. calculate penetration distance and eject.
  lda entity_locals+thoguth_locals::y_collisionPointBottom,x
  and #penetration_calculation_mask
  sta entity_locals+thoguth_locals::y_belowPenetration,x
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc entity_locals+thoguth_locals::y_belowPenetration,x
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  ;initialize slam state.
  lda #THOGUTH_SLAMSTATE
  sta entity_instances+entity_instance::state,x
  lda #JUMP_SLAM_INTERVAL
  sta entity_locals+thoguth_locals::jump_slam,x
  
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
  
  jsr spawn_lightningbolts
  
noBottomCollision:

  jsr thoguth_draw
  jsr thoguth_hurt_nomolos
  
  rts
  
thoguth_slamState_handler:

  .scope
  dec entity_locals+thoguth_locals::jump_slam,x
  bne do_not_switch_state
  
  ;initialize the move state
  jsr entity_reset_anim
  
  lda #MOVE_STOP_INTERVAL
  sta entity_locals+thoguth_locals::move_stop,x
  
  lda #JUMP_SLAM_INTERVAL
  sta entity_locals+thoguth_locals::jump_slam,x
  
  lda #THOGUTH_MOVESTATE
  sta entity_instances+entity_instance::state,x
  
  jsr thoguth_draw
  jsr thoguth_hurt_nomolos
  
  rts
  
do_not_switch_state:
  .endscope

  ;hold animation at the "hammer slam" frame
  lda #0
  sta entity_instances+entity_instance::animation_object+animation::frameCountDown,x
  lda #2
  sta entity_instances+entity_instance::animation_object+animation::currentFrame,x

  jsr thoguth_draw
  jsr thoguth_hurt_nomolos

  ;shake the screen during slam state
  lda entity_locals+thoguth_locals::jump_slam,x
  and #%00000010
  sta camera_scroll_y
  
  rts
  
thoguth_moveState_handler:

  .scope
  dec entity_locals+thoguth_locals::jump_slam,x
  bne do_not_switch_state
  
  ;initialize the jump state
  lda #$0a
  sta entity_locals+thoguth_locals::y_velocity,x
  lda #$fd
  sta entity_locals+thoguth_locals::y_velocity+1,x
  
  jsr entity_reset_anim
  
  lda #THOGUTH_JUMPSTATE
  sta entity_instances+entity_instance::state,x
  
  jsr thoguth_draw
  jsr thoguth_hurt_nomolos
  
  rts
  
do_not_switch_state:
  .endscope

  .scope
  dec entity_locals+thoguth_locals::move_stop,x
  bne do_not_switch_state

  lda #MOVE_STOP_INTERVAL
  sta entity_locals+thoguth_locals::move_stop,x

  lda #THOGUTH_STOPSTATE
  sta entity_instances+entity_instance::state,x
  
  jsr thoguth_draw
  jsr thoguth_hurt_nomolos
  
  rts

do_not_switch_state:
  .endscope

  lda entity_locals+thoguth_locals::direction,x
  bne move_right

move_left:

  ;test left boundary and flip direction if past it
  lda entity_instances+entity_instance::position_x,x
  sec
  sbc #THOGUTH_LEFT_BOUNDARY
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  bmi flip_direction

  sec
  lda entity_instances+entity_instance::position_x_fine,x
  sbc #THOGUTH_SPEED_LO
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  sbc #THOGUTH_SPEED_HI
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  jmp direction_test_done
move_right:

  ;test right boundary and flip direction if past it
  lda entity_instances+entity_instance::position_x,x
  sec
  sbc #THOGUTH_RIGHT_BOUNDARY
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  bpl flip_direction

  clc
  lda entity_instances+entity_instance::position_x_fine,x
  adc #THOGUTH_SPEED_LO
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  adc #THOGUTH_SPEED_HI
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x

direction_test_done:

  jsr thoguth_draw
  jsr thoguth_hurt_nomolos
  
  rts

flip_direction:

  lda entity_locals+thoguth_locals::direction,x
  eor #$ff
  sta entity_locals+thoguth_locals::direction,x

  jsr thoguth_draw
  jsr thoguth_hurt_nomolos

  rts

thoguth_dyingState_handler:

  dec entity_locals+thoguth_locals::dying_counter,x
  bne dying_counter_not_zero
  
  ;load victory music
.ifdef MUSIC_ENABLE
  lda #<victory_music
  sta sound_param_word_1
  lda #>victory_music
  sta sound_param_word_1+1
  jsr song_initialize
.endif
  
  ;load up victory state counter
  lda #$af
  sta entity_locals+thoguth_victorystate_locals::victory_counter,x
  lda #$02
  sta entity_locals+thoguth_victorystate_locals::victory_counter+1,x
  
  lda #THOGUTH_VICTORYSTATE
  sta entity_instances+entity_instance::state,x
  
dying_counter_not_zero:

  lda entity_locals+thoguth_locals::dying_counter,x
  and #%00000010
  ;asl
  sta camera_scroll_x
do_not_vibrate:

  lda entity_locals+thoguth_locals::dying_counter,x
  and #%00000011
  bne skip_spawn_explosion
  
  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ldy #10
  jsr entity_get_next_prn
  
  and #%00000111
  sta b3
  
  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  clc
  adc b3
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ldy #10
  jsr entity_get_next_prn
  
  and #%00011111
  sta b3
  
  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  clc
  adc b3
  sta b1
  lda entity_instances+entity_instance::position_y+1,x
  sta b2

  jsr entity_spawn
  
  ;play a hit sound
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
skip_spawn_explosion:

  jmp thoguth_draw

  rts
  
thoguth_victoryState_handler:

  ;victory music should be playing

  ;initialize the boss mode nmi handler so we can upload
  ;nametable regions to open the door after defeating Thoguth
  jsr play_level_state_init_boss_mode
  
  ;decrement victory state counter
  sec
  lda entity_locals+thoguth_victorystate_locals::victory_counter,x
  sbc #1
  sta entity_locals+thoguth_victorystate_locals::victory_counter,x
  lda entity_locals+thoguth_victorystate_locals::victory_counter+1,x
  sbc #0
  sta entity_locals+thoguth_victorystate_locals::victory_counter+1,x
  bne victory_state_counter_not_zero
  
  ;stop all sound
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif
  
  ;set the current row for opening the exit
  lda #17
  sta entity_locals+thoguth_victorystate_locals::open_exit_row,x
  
  lda #0
  sta entity_locals+thoguth_victorystate_locals::open_exit_counter,x
  
  lda #THOGUTH_OPENEXITSTATE
  sta entity_instances+entity_instance::state,x
  
victory_state_counter_not_zero:
  
  rts
  
thoguth_openExitState_handler:

  ;draw the exit tiles somehow
  
  ;decrement the open exit counter
  ;dec entity_locals+thoguth_victorystate_locals::open_exit_counter,x
  
  ;load the open exit counter
  ;lda entity_locals+thoguth_victorystate_locals::open_exit_counter,x
  
  ;and #%00000011
  ;bne do_not_draw_next_row
  
  ;draw the row
  lda #28
  sta b0
  lda entity_locals+thoguth_victorystate_locals::open_exit_row,x
  sta b1
  lda #<row_of_black_tiles
  sta w0
  lda #>row_of_black_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  ;decrement row itself
  dec entity_locals+thoguth_victorystate_locals::open_exit_row,x
  
  lda entity_locals+thoguth_victorystate_locals::open_exit_row,x
  cmp #9
  bne do_not_kill_thoguth
  lda #THOGUTH_KILLSTATE
  sta entity_instances+entity_instance::state,x
do_not_kill_thoguth:
  
do_not_draw_next_row:

  rts
  
thoguth_killState_handler:

  ;restore play level nmi routine
  jsr play_level_state_init_play_mode

  ;draw patch tiles into column buffer to cover up
  ;garbage tiles left over from erasing the exit door.
  ;we do not have any logic to prevent the ppu from uploading
  ;potentially bad column data, but this is the only situation
  ;where that has been a problem so we'll leave it here for now.
  lda #0
  sta b0
  sta b1
  lda #<patch_tiles
  sta w0
  lda #>patch_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  clc
  lda base_address_map
  adc #$10
  sta base_address_map
  lda base_address_map+1
  adc #$00
  sta base_address_map+1
  
  ;restore camera scroll
  lda #1
  sta camera_scroll_enabled

  ;make it dead
  jsr entity_kill
  
  rts

thoguth_hurt_nomolos:

  ;load thoguth width and height
  lda #THOGUTH_WIDTH
  sta b2
  lda #THOGUTH_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:
  rts
  
thoguth_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  bne do_not_switch_to_kill_state
  lda #THOGUTH_KILLSTATE
  sta entity_instances+entity_instance::state,x
do_not_switch_to_kill_state:
  
  ;only check for a hit if the damaged counter is all the way down
  lda entity_locals+thoguth_locals::damaged_counter,x
  bne damaged_counter_not_zero
  
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load thoguth width and height
  lda #THOGUTH_WIDTH
  sta b2
  lda #THOGUTH_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox

  bne nomolosNotAttacking

  ;set damaged counter
  lda #20
  sta entity_locals+thoguth_locals::damaged_counter,x
  
  ;play a hit sound
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
  
  dec entity_locals+thoguth_locals::health,x
  bne health_not_zero

  ;switch to dying state
  lda #255
  sta entity_locals+thoguth_locals::dying_counter,x
  
  ;stop sound
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif
  
  ;workaround to ensure Nomolos cannot be dying when he has delivered the final blow
  jsr nomolos_ensure_not_dying

  ;make Nomolos invincible the instant we transition Thoguth into dying state
  lda nomolos_state_primary
  ora #nomolos_invincibility_on_set
  sta nomolos_state_primary
  lda #0
  ;ensure that the invincibility blinking counter is already zero so it does not
  ;reset invincibility to "off" after Thoguth has already started dying
  sta nomolos_counter_temp_invincibility_blink
  
  lda #THOGUTH_DYINGSTATE
  sta entity_instances+entity_instance::state,x

health_not_zero:
damaged_counter_not_zero:
nomolosNotAttacking:

  lda entity_locals+thoguth_locals::damaged_counter,x
  beq entity_not_flashing
  
  dec entity_locals+thoguth_locals::damaged_counter,x
  
entity_not_flashing:

  lda entity_chr_offsets+(entity_index_thoguth-1)
  sta sprite_group_offset

  lda entity_instances+entity_instance::state,x
  cmp #THOGUTH_MOVESTATE
  beq set_march_animation
  cmp #THOGUTH_JUMPSTATE
  beq set_jump_animation
  cmp #THOGUTH_SLAMSTATE
  beq set_jump_animation
set_march_animation:
  lda #<spritesheet1_ThoguthMarch
  sta w2
  lda #>spritesheet1_ThoguthMarch
  sta w2+1
  jmp state_test_done
set_jump_animation:
  lda #<spritesheet1_ThoguthHammerfall
  sta w2
  lda #>spritesheet1_ThoguthHammerfall
  sta w2+1
state_test_done:
  lda entity_locals+thoguth_locals::direction,x
  cmp #0
  bne thoguth_moving_right
  
  lda entity_locals+thoguth_locals::damaged_counter,x
  and #%00000011
  
  
  ora #%01000000
  sta b2
  jmp thoguth_direction_test_done
thoguth_moving_right:
  
  lda entity_locals+thoguth_locals::damaged_counter,x
  and #%00000011
  
  ora #%00000000
  sta b2
thoguth_direction_test_done:
  jsr entity_draw_anim

thoguthOffscreen:
  rts

spawn_lightningbolts:
  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda entity_instances+entity_instance::position_x,x
  sec
  sbc #(LIGHTNINGBOLT_HORIZ_SPACING*2)
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta w0+1
  
  lda #0
  sta b1
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the lightningbolt we just spawned
  lda #$01
  sta entity_locals+lightningbolt_locals::flash_mask,y

  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda entity_instances+entity_instance::position_x,x
  sec
  sbc #(LIGHTNINGBOLT_HORIZ_SPACING)
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta w0+1
  
  lda #(LIGHTNINGBOLT_VERT_SPACING)
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the lightningbolt we just spawned
  lda #$01
  sta entity_locals+lightningbolt_locals::flash_mask,y

  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda entity_instances+entity_instance::position_x,x
  sta w0
  lda #0
  sta w0+1
  
  lda #(LIGHTNINGBOLT_VERT_SPACING*2)
  sta b1
  lda #0
  sta b2

  jsr entity_spawn
  
  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the lightningbolt we just spawned
  lda #$01
  sta entity_locals+lightningbolt_locals::flash_mask,y

  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda entity_instances+entity_instance::position_x,x
  clc
  adc #(LIGHTNINGBOLT_HORIZ_SPACING)
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #00
  sta w0+1
  
  lda #(LIGHTNINGBOLT_VERT_SPACING)
  sta b1
  lda #0
  sta b2
  
  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the lightningbolt we just spawned
  lda #$01
  sta entity_locals+lightningbolt_locals::flash_mask,y

  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda entity_instances+entity_instance::position_x,x
  clc
  adc #(LIGHTNINGBOLT_HORIZ_SPACING*2)
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #00
  sta w0+1
  
  lda #0
  sta b1
  sta b2
  
  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the lightningbolt we just spawned
  lda #$01
  sta entity_locals+lightningbolt_locals::flash_mask,y

  rts
  
.endproc

.endif
