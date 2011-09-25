.ifndef SNEEP_INC
SNEEP_INC = 1

.struct sneep_locals
  counter .byte
  velocity_x .word
  velocity_y .word
  health .byte
  damaged_counter .byte
.endstruct

SNEEP_GOINGRIGHT = $0100
SNEEP_GOINGLEFT  = $FE00

SNEEP_TIMETILABOUTFACE = 80

SNEEP_WIDTH = $20
SNEEP_HEIGHT = $28

SNEEP_INITSTATE = 0
SNEEP_RUNSTATE = 1

.proc sneep_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #SNEEP_INITSTATE
  beq sneep_init_state
  cmp #SNEEP_RUNSTATE
  beq sneep_run_state

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

  ;initial health
  lda #20
  sta entity_locals+thoguth_locals::health,x
  
  ;initial damaged counter
  lda #0
  sta entity_locals+thoguth_locals::damaged_counter,x

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

  inc entity_locals+sneep_locals::counter,x
  lda entity_locals+sneep_locals::counter,x
  cmp #SNEEP_TIMETILABOUTFACE
  bne do_not_switch_direction
  
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

  clc
  lda entity_instances+entity_instance::position_x_fine,x
  adc entity_locals+sneep_locals::velocity_x,x
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_instances+entity_instance::position_x,x
  adc entity_locals+sneep_locals::velocity_x+1,x
  sta entity_instances+entity_instance::position_x,x

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

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
  lda entity_locals+thoguth_locals::damaged_counter,x
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

  jmp killSneep

damaged_counter_not_zero:
health_not_zero:
nomolosNotAttacking:

  lda entity_locals+thoguth_locals::damaged_counter,x
  beq entity_not_flashing
  
  dec entity_locals+thoguth_locals::damaged_counter,x
  
entity_not_flashing:

  lda entity_chr_offsets+(entity_index_sneep-1)
  sta sprite_group_offset

  lda entity_locals+sneep_locals::velocity_x+1,x
  bmi sneep_going_left
sneep_going_right:

  lda entity_locals+thoguth_locals::damaged_counter,x
  and #%00000011
  ora #%01000000
  sta b2

  jmp sneep_direction_test_done
sneep_going_left:

  lda entity_locals+thoguth_locals::damaged_counter,x
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

sneepOffscreen:
  rts

.endproc

.endif
