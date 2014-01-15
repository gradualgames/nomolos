.ifndef SNEEP_INC
SNEEP_INC = 1

.struct sneep_locals
  counter .byte
  time_til_jump_counter .byte
  jump_counter .byte
  velocity_x .word
  velocity_y .word
  health .byte
  damaged_counter .byte
  animation .word
  last_nomolos_x .word
.endstruct

SNEEP_GOINGRIGHT = $0002
SNEEP_GOINGLEFT  = $FFFE

SNEEP_TIMETILJUMP = 10

SNEEP_WIDTH = $20
SNEEP_HALFWIDTH = $10
SNEEP_HEIGHT = $28

SNEEP_INITSTATE = 0
SNEEP_RUNSTATE = 1
SNEEP_JUMPSTATE = 2
SNEEP_FLAPSTATE = 3
SNEEP_HIDESTATE = 4
SNEEP_DYINGSTATE = 5

SNEEP_FEATHER1_X_OFFSET = 75  ;used as a negative offset
SNEEP_FEATHER2_X_OFFSET = 25  ;used as a negative offset
SNEEP_FEATHER3_X_OFFSET = 25  ;used as a positive offset
SNEEP_FEATHER4_X_OFFSET = 75  ;used as a positive offset

SNEEP_FEATHER_Y_OFFSET = 75   ;used as a negative offset

.proc sneep_update
x_collisionPointBottom = b3 ;and b4, this is a .word
y_collisionPointBottom = b5 ;and b6, this is a .word
y_belowPenetration = b7     ;these were used because map collision used up all
                            ;of the word locals. also, we needed more space in
                            ;the sneep's locals. Kinda ugly, but oh well.

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
  cmp #SNEEP_HIDESTATE
  beq sneep_hide_state
  cmp #SNEEP_DYINGSTATE
  beq sneep_dying_state

sneep_jump_state:

  jmp sneep_jump_state_handler

sneep_flap_state:

  jmp sneep_flap_state_handler

sneep_hide_state:

  jmp sneep_hide_state_handler

sneep_dying_state:

  jmp sneep_dying_state_handler

sneep_init_state:

  ;clear out special weapon bit (this is done for balance, some bosses are
  ;rendered too easy with the spear or flail)
  lda nomolos_state_secondary
  and #nomolos_attack_set_mask
  sta nomolos_state_secondary

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

  ;set health based on difficulty
  lda difficulty
  cmp #EASY_DIFFICULTY
  bne :+
  lda #15
  jmp :++
:
  lda #20
:
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

  jsr play_level_state_init_victory_mode
  jsr play_level_state_play_victory_music

  rts

sneep_dying_state_handler:

  dec entity_locals+sneep_locals::counter,x
  bne counter_not_zero
  
  beq killSneep

counter_not_zero:

  lda entity_locals+sneep_locals::counter,x
  and #%00000010
  ;asl
  sta camera_scroll_x
do_not_vibrate:

  lda entity_locals+sneep_locals::counter,x
  and #%00000011
  bne skip_spawn_explosion
  
  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ldy #10
  jsr entity_get_next_prn
  
  and #%00001111
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

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

  rts

sneep_draw:

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

  ;stop all sound
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif

  ;workaround to ensure Nomolos cannot be dying when he has delivered the final blow
  jsr nomolos_ensure_not_dying

  ;make Nomolos invincible the instant we transition Sneep into dying state
  lda nomolos_state_primary
  ora #nomolos_invincibility_on_set
  sta nomolos_state_primary
  lda #0
  ;ensure that the invincibility blinking counter is already zero so it does not
  ;reset invincibility to "off" after Sneep has already started dying
  sta nomolos_counter_temp_invincibility_blink

  ;have the Sneep be in the dying state for 255 frames
  lda #255
  sta entity_locals+sneep_locals::counter,x

  lda #SNEEP_DYINGSTATE
  sta entity_instances+entity_instance::state,x

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
  cmp #SNEEP_DYINGSTATE
  beq draw_runstate
  cmp #SNEEP_JUMPSTATE
  beq draw_runstate
  cmp #SNEEP_FLAPSTATE
  beq draw_flapstate
  cmp #SNEEP_HIDESTATE
  beq draw_hidestate
draw_runstate:
  jsr sneep_draw_running
  jmp state_test_done
draw_flapstate:
  jsr sneep_draw_flapping
  jmp state_test_done
draw_hidestate:
  jsr sneep_draw_hiding
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

sneep_draw_hiding:

  lda entity_chr_offsets+(entity_index_sneep-1)
  sta sprite_group_offset

  lda #<spritesheet2_SneepHide0
  sta w0
  lda #>spritesheet2_SneepHide0
  sta w0+1

  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  clc
  adc #$0f
  sta w4
  lda entity_screen_y+1
  adc #$00
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet2_SneepHead0
  sta w0
  lda #>spritesheet2_SneepHead0
  sta w0+1

  lda entity_locals+sneep_locals::last_nomolos_x,x
  sta w3
  lda entity_locals+sneep_locals::last_nomolos_x+1,x
  sta w3+1
  lda entity_screen_y
  clc
  adc #$17
  sta w4
  lda entity_screen_y+1
  adc #$00
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet2_SneepEyeHead0
  sta w0
  lda #>spritesheet2_SneepEyeHead0
  sta w0+1

  lda entity_locals+sneep_locals::last_nomolos_x,x
  sta w3
  lda entity_locals+sneep_locals::last_nomolos_x+1,x
  sta w3+1
  lda entity_screen_y
  clc
  adc #$17
  sta w4
  lda entity_screen_y+1
  adc #$00
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  ;transfer head rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda #$10
  sta b2
  sta b3

  lda entity_locals+sneep_locals::last_nomolos_x,x
  sta w2
  lda entity_locals+sneep_locals::last_nomolos_x+1,x
  sta w2+1
  lda entity_screen_y
  clc
  adc #$17
  sta w3
  lda entity_screen_y+1
  adc #$00
  sta w3+1

  ;transfer Nomolos rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolos_screen_x
  sta w4
  lda nomolos_screen_x+1
  sta w4+1
  lda nomolos_screen_y
  sta w5
  lda nomolos_screen_y+1
  sta w5+1
  lda #nomolos_width
  sta b4
  lda #nomolos_height
  sta b5

  jsr geotests_rect_in_rect_16bit

  bne do_not_hurt_nomolos

  jsr nomolos_hurt

do_not_hurt_nomolos:

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

sneep_hide_state_handler:

  .scope
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
  .endscope

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

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
  sta x_collisionPointBottom
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta x_collisionPointBottom+1
  sta w0+1
  ;load the entity's Y coordinate + height
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #SNEEP_HEIGHT
  sta y_collisionPointBottom
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta y_collisionPointBottom+1
  sta w1+1

  jsr map_test_collision
  lda b1
  beq noBottomCollision

  lda #0
  sta entity_locals+sneep_locals::velocity_y,x
  sta entity_locals+sneep_locals::velocity_y+1,x

  ;there was a collision beneath the entity. calculate penetration distance and eject.
  lda y_collisionPointBottom
  and #penetration_calculation_mask
  sta y_belowPenetration
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc y_belowPenetration
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

  ;change velocity to face Nomolos
  .scope
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:
  lda #<SNEEP_GOINGLEFT
  sta entity_locals+sneep_locals::velocity_x,x
  lda #>SNEEP_GOINGLEFT
  sta entity_locals+sneep_locals::velocity_x+1,x
  jmp entity_facing_test_done
entity_facing_right:
  lda #<SNEEP_GOINGRIGHT
  sta entity_locals+sneep_locals::velocity_x,x
  lda #>SNEEP_GOINGRIGHT
  sta entity_locals+sneep_locals::velocity_x+1,x
entity_facing_test_done:
  .endscope

  lda entity_instances+entity_instance::position_x,x
  and #%00000101
  beq switch_to_flap_state
switch_to_hide_state:

  lda nomolos_screen_x
  sta entity_locals+sneep_locals::last_nomolos_x,x
  lda nomolos_screen_x+1
  sta entity_locals+sneep_locals::last_nomolos_x+1,x

  lda #SNEEP_HIDESTATE
  sta entity_instances+entity_instance::state,x

  lda #100
  sta entity_locals+sneep_locals::counter,x

  jmp done
switch_to_flap_state:

  jsr sneep_spawn_feathers

  ;play a flap sound
  txa
  pha

  lda #<flap_sound
  sta sound_param_word_0
  lda #>flap_sound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax
  
  lda #SNEEP_FLAPSTATE
  sta entity_instances+entity_instance::state,x

  lda #100
  sta entity_locals+sneep_locals::counter,x

done:

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

  rts

sneep_move_horizontally:

  lda entity_instances+entity_instance::position_x,x
  cmp #16
  .scope
  bpl do_not_switch_direction
  cmp #(256 - SNEEP_WIDTH - 16)
  bmi do_not_switch_direction
  ;negate direction
  lda entity_locals+sneep_locals::velocity_x,x
  eor #$ff
  clc
  adc #$01
  sta entity_locals+sneep_locals::velocity_x,x
  lda entity_locals+sneep_locals::velocity_x+1,x
  eor #$ff
  adc #$00
  sta entity_locals+sneep_locals::velocity_x+1,x

  ;reset counter
  lda #0
  sta entity_locals+sneep_locals::counter,x

do_not_switch_direction:
  .endscope

  clc
  lda entity_instances+entity_instance::position_x,x
  adc entity_locals+sneep_locals::velocity_x,x
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc entity_locals+sneep_locals::velocity_x+1,x
  sta entity_instances+entity_instance::position_x+1,x

  rts

sneep_spawn_feathers:

  ;****SPAWN AND PARAMETERIZE A FEATHER****
  lda #entity_index_feather
  sta b0

  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  sec
  sbc #SNEEP_FEATHER1_X_OFFSET
  sta w0
  ;get out high byte of position_x
  lda #0
  sbc #0
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sec
  sbc #SNEEP_FEATHER_Y_OFFSET
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize the feather to go direction of sneep
  lda entity_locals+sneep_locals::velocity_x,x
  clc
  adc entity_locals+sneep_locals::velocity_x,x
  sta entity_locals+feather_locals::x_velocity,y
  lda entity_locals+sneep_locals::velocity_x+1,x
  adc entity_locals+sneep_locals::velocity_x+1,x
  sta entity_locals+feather_locals::x_velocity+1,y

  lda #$02
  sta entity_locals+feather_locals::y_velocity,y
  lda #$00
  sta entity_locals+feather_locals::y_velocity+1,y

  ;****SPAWN AND PARAMETERIZE A FEATHER****
  lda #entity_index_feather
  sta b0

  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  sec
  sbc #SNEEP_FEATHER2_X_OFFSET
  sta w0
  ;get out high byte of position_x
  lda #0
  sbc #0
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sec
  sbc #SNEEP_FEATHER_Y_OFFSET
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize the feather to go direction of sneep
  lda entity_locals+sneep_locals::velocity_x,x
  clc
  adc entity_locals+sneep_locals::velocity_x,x
  sta entity_locals+feather_locals::x_velocity,y
  lda entity_locals+sneep_locals::velocity_x+1,x
  adc entity_locals+sneep_locals::velocity_x+1,x
  sta entity_locals+feather_locals::x_velocity+1,y

  lda #$02
  sta entity_locals+feather_locals::y_velocity,y
  lda #$00
  sta entity_locals+feather_locals::y_velocity+1,y

  ;****SPAWN AND PARAMETERIZE A FEATHER****
  lda #entity_index_feather
  sta b0

  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  clc
  adc #SNEEP_FEATHER3_X_OFFSET
  sta w0
  ;get out high byte of position_x
  lda #0
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sec
  sbc #SNEEP_FEATHER_Y_OFFSET
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize the feather to go direction of sneep
  lda entity_locals+sneep_locals::velocity_x,x
  clc
  adc entity_locals+sneep_locals::velocity_x,x
  sta entity_locals+feather_locals::x_velocity,y
  lda entity_locals+sneep_locals::velocity_x+1,x
  adc entity_locals+sneep_locals::velocity_x+1,x
  sta entity_locals+feather_locals::x_velocity+1,y

  lda #$02
  sta entity_locals+feather_locals::y_velocity,y
  lda #$00
  sta entity_locals+feather_locals::y_velocity+1,y

  ;****SPAWN AND PARAMETERIZE A FEATHER****
  lda #entity_index_feather
  sta b0

  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  clc
  adc #SNEEP_FEATHER4_X_OFFSET
  sta w0
  ;get out high byte of position_x
  lda #0
  adc #0
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sec
  sbc #SNEEP_FEATHER_Y_OFFSET
  sta b1
  lda #0
  sta b2

  jsr entity_spawn

  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize the feather to go direction of sneep
  lda entity_locals+sneep_locals::velocity_x,x
  clc
  adc entity_locals+sneep_locals::velocity_x,x
  sta entity_locals+feather_locals::x_velocity,y
  lda entity_locals+sneep_locals::velocity_x+1,x
  adc entity_locals+sneep_locals::velocity_x+1,x
  sta entity_locals+feather_locals::x_velocity+1,y

  lda #$02
  sta entity_locals+feather_locals::y_velocity,y
  lda #$00
  sta entity_locals+feather_locals::y_velocity+1,y

  ; ;****END OF FEATHER SPAWNING****

  rts

.endproc

.endif
