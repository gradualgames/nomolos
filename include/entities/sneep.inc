.ifndef SNEEP_INC
SNEEP_INC = 1

.struct sneep_locals
  counter .byte
  time_til_jump_counter .byte
  jump_counter .byte
  velocity_x .word
  velocity_y .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
  health .byte
  damaged_counter .byte
  animation .word
.endstruct

SNEEP_GOINGRIGHT = $0100
SNEEP_GOINGLEFT  = $FE00

SNEEP_TIMETILJUMP = 10

SNEEP_WIDTH = $20
SNEEP_HALFWIDTH = $10
SNEEP_HEIGHT = $28

SNEEP_INITSTATE = 0
SNEEP_RUNSTATE = 1
SNEEP_JUMPSTATE = 2
SNEEP_FLAPSTATE = 3

.proc sneep_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #SNEEP_INITSTATE
  beq sneep_init_state
  cmp #SNEEP_RUNSTATE
  beq sneep_run_state
  cmp #SNEEP_JUMPSTATE
  beq sneep_jump_state
  cmp #SNEEP_FLAPSTATE
  beq sneep_flap_state

sneep_jump_state:

  jmp sneep_jump_state_handler

sneep_flap_state:

  jmp sneep_flap_state_handler

sneep_init_state:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #24
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  ;set counter
  lda #0
  sta entity_locals+sneep_locals::counter,x

  ;reset jump counter
  lda #5
  sta entity_locals+sneep_locals::jump_counter,x

  ;set jump interval counter
  lda #SNEEP_TIMETILJUMP
  sta entity_locals+sneep_locals::time_til_jump_counter,x

  ;initial health
  lda #20
  sta entity_locals+sneep_locals::health,x
  
  ;initial damaged counter
  lda #0
  sta entity_locals+sneep_locals::damaged_counter,x

  ;set direction
  lda #<SNEEP_GOINGLEFT
  sta entity_locals+sneep_locals::velocity_x,x
  lda #>SNEEP_GOINGLEFT
  sta entity_locals+sneep_locals::velocity_x+1,x

  ;switch state
  lda #SNEEP_RUNSTATE
  sta entity_instances+entity_instance::state,x
  rts

sneep_run_state:

  jsr sneep_move_horizontally

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

  dec entity_locals+sneep_locals::time_til_jump_counter,x
  bne do_not_switch_to_jump_state
  
  lda #$0a
  sta entity_locals+sneep_locals::velocity_y,x
  lda #$fd
  sta entity_locals+sneep_locals::velocity_y+1,x

  lda #SNEEP_JUMPSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_jump_state:

  rts

killSneep:

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
  lda entity_instances+entity_instance::position_y+1,x
  sta b2

  jsr entity_spawn

  rts

sneep_draw:

  jsr entity_test_death_zone
  beq killSneep

  ;load sneep width and height
  lda #SNEEP_WIDTH
  sta b2
  lda #SNEEP_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  ;only check for a hit if the damaged counter is all the way down
  lda entity_locals+sneep_locals::damaged_counter,x
  bne damaged_counter_not_zero

  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load sneep width and height
  lda #SNEEP_WIDTH
  sta b2
  lda #SNEEP_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox

  bne nomolosNotAttacking

  ;set damaged counter
  lda #20
  sta entity_locals+sneep_locals::damaged_counter,x

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

  dec entity_locals+sneep_locals::health,x
  bne health_not_zero

  jmp killSneep

damaged_counter_not_zero:
health_not_zero:
nomolosNotAttacking:

  lda entity_locals+sneep_locals::damaged_counter,x
  beq entity_not_flashing
  
  dec entity_locals+sneep_locals::damaged_counter,x
  
entity_not_flashing:

  lda entity_chr_offsets+(entity_index_sneep-1)
  sta sprite_group_offset

  lda entity_locals+sneep_locals::velocity_x+1,x
  bmi sneep_going_left
sneep_going_right:

  lda entity_locals+sneep_locals::damaged_counter,x
  and #%00000011
  ora #%01000000
  sta b2

  jmp sneep_direction_test_done
sneep_going_left:

  lda entity_locals+sneep_locals::damaged_counter,x
  and #%00000011
  ora #%00000000
  sta b2

sneep_direction_test_done:

  ;compute address of animation object based on current entity index and animation_object
  ;offset
  txa
  sta w1
  clc
  adc #<(entity_instances+entity_instance::animation_object)
  sta w1
  lda w1+1
  adc #>(entity_instances+entity_instance::animation_object)
  sta w1+1

  lda entity_instances+entity_instance::state,x
  cmp #SNEEP_RUNSTATE
  beq draw_runstate
  cmp #SNEEP_JUMPSTATE
  beq draw_runstate
  cmp #SNEEP_FLAPSTATE
  beq draw_flapstate
draw_runstate:
  jsr sneep_draw_running
  jmp state_test_done
draw_flapstate:
  jsr sneep_draw_flapping
state_test_done:

sneepOffscreen:
  rts

sneep_draw_running:

  lda #<spritesheet2_SneepRun
  sta w2
  lda #>spritesheet2_SneepRun
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

  lda #<spritesheet2_SneepEyeRun
  sta w2
  lda #>spritesheet2_SneepEyeRun
  sta w2+1

  jsr sprite_draw_animation_16bit

  jsr sprite_update_animation

  rts

sneep_draw_flapping:

  lda #<spritesheet2_SneepFlap
  sta w2
  lda #>spritesheet2_SneepFlap
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

  lda #<spritesheet2_SneepEyeFlap
  sta w2
  lda #>spritesheet2_SneepEyeFlap
  sta w2+1

  jsr sprite_draw_animation_16bit

  jsr sprite_update_animation

  rts

sneep_flap_state_handler:

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

  dec entity_locals+sneep_locals::counter,x
  bne do_not_switch_to_run_state

  lda #20
  sta entity_locals+sneep_locals::time_til_jump_counter,x

  lda #5
  sta entity_locals+sneep_locals::jump_counter,x

  jsr entity_reset_anim

  lda #SNEEP_RUNSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_run_state:

  rts

sneep_jump_state_handler:

  ;increment the vertical velocity
  lda entity_locals+sneep_locals::velocity_y+1,x
  cmp #10
  bpl stopAccelerating
  clc
  lda entity_locals+sneep_locals::velocity_y,x
  adc #$20
  sta entity_locals+sneep_locals::velocity_y,x
  lda entity_locals+sneep_locals::velocity_y+1,x
  adc #0
  sta entity_locals+sneep_locals::velocity_y+1,x
stopAccelerating:

  ;add vertical velocity to 24 bit Y coordinate with sign extension
  clc
  lda entity_locals+sneep_locals::velocity_y,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+sneep_locals::velocity_y+1,x
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
  adc #SNEEP_HALFWIDTH
  sta entity_locals+sneep_locals::x_collisionPointBottom,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_locals+sneep_locals::x_collisionPointBottom+1,x
  sta w0+1
  ;load the entity's Y coordinate + height
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #SNEEP_HEIGHT
  sta entity_locals+sneep_locals::y_collisionPointBottom,x
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_locals+sneep_locals::y_collisionPointBottom+1,x
  sta w1+1

  jsr map_test_collision
  lda b1
  beq noBottomCollision

  lda #0
  sta entity_locals+sneep_locals::velocity_y,x
  sta entity_locals+sneep_locals::velocity_y+1,x

  ;there was a collision beneath the entity. calculate penetration distance and eject.
  lda entity_locals+sneep_locals::y_collisionPointBottom,x
  and #penetration_calculation_mask
  sta entity_locals+sneep_locals::y_belowPenetration,x
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc entity_locals+sneep_locals::y_belowPenetration,x
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  ;switch back to run state and reset time til jump counter and count the jump
  dec entity_locals+sneep_locals::jump_counter,x
  beq switch_to_other_state

  lda #SNEEP_TIMETILJUMP
  sta entity_locals+sneep_locals::time_til_jump_counter,x

  jsr entity_reset_anim

  lda #SNEEP_RUNSTATE
  sta entity_instances+entity_instance::state,x

noBottomCollision:

  jsr sneep_move_horizontally

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

  rts

switch_to_other_state:

  jsr entity_reset_anim

  ;spawn a feather
  lda #entity_index_feather
  sta b0

  ;get out low byte of position_x
  lda #128
  sta w0
  ;get out high byte of position_x
  lda #0
  sta w0+1

  ;get out position_y
  lda $20
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize the laser to go left
  lda #$fc
  sta entity_locals+feather_locals::x_velocity,y
  lda #$ff
  sta entity_locals+feather_locals::x_velocity+1,y

  lda #$04
  sta entity_locals+feather_locals::y_velocity,y
  lda #$00
  sta entity_locals+feather_locals::y_velocity+1,y


  lda #SNEEP_FLAPSTATE
  sta entity_instances+entity_instance::state,x

  lda #100
  sta entity_locals+sneep_locals::counter,x

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

  rts

sneep_move_horizontally:

  lda entity_instances+entity_instance::position_x,x
  cmp #20
  .scope
  bpl do_not_switch_direction
  cmp #220
  bmi do_not_switch_direction
  ;negate direction
  clc
  lda entity_locals+sneep_locals::velocity_x,x
  eor #$ff
  adc #1
  sta entity_locals+sneep_locals::velocity_x,x
  lda entity_locals+sneep_locals::velocity_x+1,x
  eor #$ff
  adc #0
  sta entity_locals+sneep_locals::velocity_x+1,x

  ;reset counter
  lda #0
  sta entity_locals+sneep_locals::counter,x

do_not_switch_direction:
  .endscope

  clc
  lda entity_instances+entity_instance::position_x_fine,x
  adc entity_locals+sneep_locals::velocity_x,x
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  adc entity_locals+sneep_locals::velocity_x+1,x
  sta entity_instances+entity_instance::position_x,x

  rts

.endproc

.endif
