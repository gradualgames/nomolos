.ifndef LASER_INC
LASER_INC = 1

laser_update:

  lda entity_instances+entity_instance::state,x
  cmp #LASER_INITSTATE
  beq laser_init
  cmp #LASER_FLYSTATE
  beq laser_fly

laser_init:

  jmp laser_init_handler

laser_fly:

  jmp laser_fly_handler

laser_init_handler:

  ;reset the laser animation object
  jsr entity_reset_anim

  ;set state to fly
  lda #LASER_FLYSTATE
  sta entity_instances+entity_instance::state,x

  txa
  pha

  lda #<laser_sound
  sta sound_param_word_0
  lda #>laser_sound
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax

  lda entity_locals+laser_locals::x_velocity+1,x
  bpl do_not_adjust_starting_x
  ;adjust starting point so laser can be fired from the point it was spawned at
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #LASER_WIDTH
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x
do_not_adjust_starting_x:

  lda entity_locals+laser_locals::y_velocity+1,x
  bpl do_not_adjust_starting_y
  ;adjust starting point so laser can be fired from the point it was spawned at
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #LASER_HEIGHT
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x
do_not_adjust_starting_y:

  rts

laserDie:

  jsr entity_kill

  rts

laser_fly_handler:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq laserDie

  lda nomolos_screen_x
  sta w3
  lda nomolos_screen_x+1
  sta w3+1

  lda nomolos_screen_y
  sta w4
  lda nomolos_screen_y+1
  sta w4+1

  lda #nomolos_width
  sta b5
  lda #nomolos_height
  sta b6

  lda entity_locals+laser_locals::x_velocity+1,x
  bpl laser_going_right
laser_going_left:
  ;if laser is oriented as / (going left),
  ;calculate bottom left point and top right for collision with nomolos

  lda entity_screen_x
  sta w1
  lda entity_screen_x+1
  sta w1+1
  lda entity_screen_y
  clc
  adc #LASER_HEIGHT
  sta w2
  lda entity_screen_y
  adc #0
  sta w2+1

  .scope
  jsr geotests_point_in_rect_16bit
  bne do_not_hurt_nomolos

  jsr nomolos_hurt

do_not_hurt_nomolos:
  .endscope

  lda entity_screen_x
  clc
  adc #LASER_WIDTH
  sta w1
  lda entity_screen_x+1
  adc #0
  sta w1+1

  lda entity_screen_y
  sta w2
  lda entity_screen_y+1
  sta w2+1

  .scope
  jsr geotests_point_in_rect_16bit
  bne do_not_hurt_nomolos

  jsr nomolos_hurt

do_not_hurt_nomolos:
  .endscope

  jmp laser_direction_test_done
  ;if laser is oriented as \ (going right),
  ;calculate bottom right and top left for collision with nomolos
laser_going_right:

  lda entity_screen_x
  clc
  adc #LASER_WIDTH
  sta w1
  lda entity_screen_x+1
  adc #0
  sta w1+1

  lda entity_screen_y
  clc
  adc #LASER_HEIGHT
  sta w2
  lda entity_screen_y+1
  adc #0
  sta w2+1

  .scope
  jsr geotests_point_in_rect_16bit
  bne do_not_hurt_nomolos

  jsr nomolos_hurt

do_not_hurt_nomolos:
  .endscope

  lda entity_screen_x
  sta w1
  lda entity_screen_x+1
  sta w1+1

  lda entity_screen_y
  sta w2
  lda entity_screen_y+1
  sta w2+1

  .scope
  jsr geotests_point_in_rect_16bit
  bne do_not_hurt_nomolos

  jsr nomolos_hurt

do_not_hurt_nomolos:
  .endscope

laser_direction_test_done:

  clc
  lda entity_instances+entity_instance::position_x,x
  adc entity_locals+laser_locals::x_velocity,x
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc entity_locals+laser_locals::x_velocity+1,x
  sta entity_instances+entity_instance::position_x+1,x

  clc
  lda entity_instances+entity_instance::position_y,x
  adc entity_locals+laser_locals::y_velocity,x
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc entity_locals+laser_locals::y_velocity+1,x
  sta entity_instances+entity_instance::position_y+1,x

  lda entity_chr_offsets+(entity_index_laser-1)
  sta sprite_group_offset

  lda #<spritesheet2_Laser0
  sta w0
  lda #>spritesheet2_Laser0
  sta w0+1

  ;exclusive or the signs of the velocities together. If we get nonzero,
  ;we want the laser to be oriented as /. If we get zero, we want the
  ;laser to be oriented as \.
  lda entity_locals+laser_locals::x_velocity+1,x
  and #$80 
  sta b0
  lda entity_locals+laser_locals::y_velocity+1,x
  and #$80
  sta b1
  
  lda b0
  eor b1
  bne forwardslash_oriented
backwardslash_oriented:

  lda #%00000000
  sta b2

  jmp orientation_test_done
forwardslash_oriented:

  lda #%01000000
  sta b2

orientation_test_done:

  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda entity_instances+entity_instance::animation_object+1,x

  rts

.endif