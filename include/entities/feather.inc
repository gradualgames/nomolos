.ifndef FEATHER_INC
FEATHER_INC = 1

.proc feather_update

  lda entity_instances+entity_instance::state,x
  cmp #FEATHER_INITSTATE
  beq feather_init
  cmp #FEATHER_FLYSTATE
  beq feather_fly

feather_init:

  jmp feather_init_handler

feather_fly:

  jmp feather_fly_handler

feather_init_handler:

  ;reset the feather animation object
  jsr entity_reset_anim

  ;set state to fly
  lda #FEATHER_FLYSTATE
  sta entity_instances+entity_instance::state,x

  lda entity_locals+feather_locals::x_velocity+1,x
  bpl do_not_adjust_starting_x
  ;adjust starting point so feather can be fired from the point it was spawned at
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #FEATHER_WIDTH
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x
do_not_adjust_starting_x:

  lda entity_locals+feather_locals::y_velocity+1,x
  bpl do_not_adjust_starting_y
  ;adjust starting point so feather can be fired from the point it was spawned at
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #FEATHER_HEIGHT
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x
do_not_adjust_starting_y:

  rts

feather_fly_handler:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq featherDie

  ;load width and height
  lda #FEATHER_WIDTH
  sta b2
  lda #FEATHER_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  clc
  lda entity_instances+entity_instance::position_x,x
  adc entity_locals+feather_locals::x_velocity,x
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc entity_locals+feather_locals::x_velocity+1,x
  sta entity_instances+entity_instance::position_x+1,x

  clc
  lda entity_instances+entity_instance::position_y,x
  adc entity_locals+feather_locals::y_velocity,x
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc entity_locals+feather_locals::y_velocity+1,x
  sta entity_instances+entity_instance::position_y+1,x

  lda entity_chr_offsets+(entity_index_sneep-1)
  sta sprite_group_offset

  lda #<spritesheet2_SneepFeather0
  sta w0
  lda #>spritesheet2_SneepFeather0
  sta w0+1

  ;exclusive or the signs of the velocities together. If we get nonzero,
  ;we want the feather to be oriented as /. If we get zero, we want the
  ;feather to be oriented as \.
  lda entity_locals+feather_locals::x_velocity+1,x
  and #$80 
  sta b0
  lda entity_locals+feather_locals::y_velocity+1,x
  and #$80
  sta b1
  
  lda b0
  eor b1
  bne forwardslash_oriented
backwardslash_oriented:

  lda #%01000000
  sta b2

  jmp orientation_test_done
forwardslash_oriented:

  lda #%00000000
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

featherDie:

  jsr entity_kill

  rts

.endproc

.endif