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
  distance  .byte
  health .byte
  damaged_counter .byte
.endstruct

THOGUTH_WIDTH = $18
THOGUTH_HALFWIDTH = $0C
THOGUTH_HEIGHT = $30
THOGUTH_HALFHEIGHT = $10

JUMP_SLAM_INTERVAL = 50

THOGUTH_DISTANCE_TIL_ABOUT_FACE = 120
MOVE_STOP_INTERVAL = 100
THOGUTH_SPEED = 255

THOGUTH_INITSTATE = 0
THOGUTH_MOVESTATE = 1
THOGUTH_STOPSTATE = 2
THOGUTH_JUMPSTATE = 3
THOGUTH_SLAMSTATE = 4

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
  
thoguth_initState_handler:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;initial health
  lda #10
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
  lda #THOGUTH_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+thoguth_locals::distance,x

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
  
  rts
  
do_not_switch_state:
  .endscope

  ;hold animation at the "hammer slam" frame
  lda #0
  sta entity_instances+entity_instance::animation_object+animation::frameCountDown,x
  lda #2
  sta entity_instances+entity_instance::animation_object+animation::currentFrame,x

  jsr thoguth_draw

  ;shake the screen during slam state
  lda entity_locals+thoguth_locals::jump_slam,x
  and #%00000010
  sta camera_scroll_x
  
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
  
  rts

do_not_switch_state:
  .endscope

  dec entity_locals+thoguth_locals::distance,x
  bne do_not_flip_direction

  lda entity_locals+thoguth_locals::direction,x
  eor #$ff
  sta entity_locals+thoguth_locals::direction,x

  lda #THOGUTH_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+thoguth_locals::distance,x

do_not_flip_direction:

  lda entity_locals+thoguth_locals::direction,x
  bne move_right

move_left:

  sec
  lda entity_instances+entity_instance::position_x_fine,x
  sbc #THOGUTH_SPEED
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  sbc #0
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  jmp direction_test_done
move_right:

  clc
  lda entity_instances+entity_instance::position_x_fine,x
  adc #THOGUTH_SPEED
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  adc #0
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x

direction_test_done:

  jsr thoguth_draw

  rts

killThoguth:

  ;restore camera scroll
  lda #1
  sta camera_scroll_enabled

  ;make it dead
  jsr entity_kill

  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sta b1

  jsr entity_spawn

  rts

thoguth_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killThoguth

  ;load thoguth width and height
  lda #THOGUTH_WIDTH
  sta b2
  lda #THOGUTH_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

  jsr entity_reset_anim

:
  
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

  jmp killThoguth
health_not_zero:
damaged_counter_not_zero:
nomolosNotAttacking:

  lda entity_locals+thoguth_locals::damaged_counter,x
  beq entity_not_flashing
  
  dec entity_locals+thoguth_locals::damaged_counter,x
  
entity_not_flashing:

  ldy #level_data_struct::thoguth_offset
  lda (base_address_rom_definition_table),y
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
  sbc #50
  sta w0
  lda #0
  sta w0+1
  
  lda #0
  sta b1

  jsr entity_spawn

  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda entity_instances+entity_instance::position_x,x
  sta w0
  lda #0
  sta w0+1
  
  lda #0
  sta b1

  jsr entity_spawn
  
  ;****************************************************************
  ;Spawn and parameterize a lightning bolt
  ;****************************************************************
  lda #entity_index_lightningbolt
  sta b0

  lda entity_instances+entity_instance::position_x,x
  clc
  adc #50
  sta w0
  lda #0
  sta w0+1
  
  lda #0
  sta b1
  
  jsr entity_spawn
  
  rts
  
.endproc

.endif
