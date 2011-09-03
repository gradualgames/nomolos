.ifndef LASER_INC
LASER_INC = 1

LASER_WIDTH = $10
LASER_HEIGHT = $10

LASER_INITSTATE = 0
LASER_FLYSTATE = 1

.struct laser_locals
  x_velocity .word
  y_velocity .word
.endstruct

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

  ;compare entity x position to nomolos x position to decide direction
  .scope
  sec
  lda nomolos_map_x+1
  sbc entity_instances+entity_instance::position_x,x
  lda nomolos_map_x+2
  sbc entity_instances+entity_instance::position_x+1,x
  bpl will_go_right
will_go_left:
  lda #$fc
  sta entity_locals+laser_locals::x_velocity,x
  lda #$ff
  sta entity_locals+laser_locals::x_velocity+1,x

  ;adjust starting point so laser can be fired from the point it was spawned at
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #LASER_WIDTH
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  jmp direction_test_done
will_go_right:
  lda #$04
  sta entity_locals+laser_locals::x_velocity,x
  lda #$00
  sta entity_locals+laser_locals::x_velocity+1,x
direction_test_done:
  .endscope

  .scope
  sec
  lda nomolos_map_y+1
  sbc entity_instances+entity_instance::position_y,x
  lda nomolos_map_y+2
  sbc entity_instances+entity_instance::position_y+1,x
  bpl will_go_down
will_go_up:
  lda #$fc
  sta entity_locals+laser_locals::y_velocity,x
  lda #$ff
  sta entity_locals+laser_locals::y_velocity+1,x

  ;adjust starting point so laser can be fired from the point it was spawned at
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #LASER_HEIGHT
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  jmp direction_test_done
will_go_down:
  lda #$04
  sta entity_locals+laser_locals::y_velocity,x
  lda #$00
  sta entity_locals+laser_locals::y_velocity+1,x

direction_test_done:
  .endscope

  rts

laser_fly_handler:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq laserDie

  ;load width and height
  lda #LASER_WIDTH
  sta b2
  lda #LASER_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

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

laserDie:

  jsr entity_kill

  rts

.endif