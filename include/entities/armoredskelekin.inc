.ifndef ARMOREDSKELEKIN_INC
ARMOREDSKELEKIN_INC = 1

ARMOREDSKELEKIN_WIDTH = $10
ARMOREDSKELEKIN_HEIGHT = $28
ARMOREDSKELEKIN_HALFHEIGHT = $14

ARMOREDSKELEKIN_INITSTATE = 0
ARMOREDSKELEKIN_MOVERIGHTSTATE = 1
ARMOREDSKELEKIN_MOVELEFTSTATE = 2

.proc armoredskelekin_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #ARMOREDSKELEKIN_INITSTATE
  beq armoredskelekin_initState
  cmp #ARMOREDSKELEKIN_MOVERIGHTSTATE
  beq armoredskelekin_moveRightState
  cmp #ARMOREDSKELEKIN_MOVELEFTSTATE
  beq armoredskelekin_moveLeftState

armoredskelekin_initState:

  jsr entity_kill_if_redundant_entity

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:

  lda #ARMOREDSKELEKIN_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x

  jmp entity_facing_test_done
entity_facing_right:

  lda #ARMOREDSKELEKIN_MOVERIGHTSTATE
  sta entity_instances+entity_instance::state,x

entity_facing_test_done:

  ;reposition the entity
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #$18
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  rts

armoredskelekin_moveRightState:

  jmp armoredskelekin_moveRightState_handler
  
armoredskelekin_moveLeftState:

  jmp armoredskelekin_moveLeftState_handler
  
armoredskelekin_moveRightState_handler:

  clc
  lda entity_instances+entity_instance::position_x,x
  adc #ARMOREDSKELEKIN_WIDTH
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #$00
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #(ARMOREDSKELEKIN_HALFHEIGHT+8)  ;make sure to test blocks on ground
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_right_collision
  lda #ARMOREDSKELEKIN_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x
no_right_collision:

  clc
  lda entity_instances+entity_instance::position_x,x
  adc #ARMOREDSKELEKIN_WIDTH
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #$00
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #ARMOREDSKELEKIN_HEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  bne no_right_pit
  lda #ARMOREDSKELEKIN_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x
no_right_pit:

  clc
  lda entity_instances+entity_instance::position_x,x
  adc #$01
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #$00
  sta entity_instances+entity_instance::position_x+1,x

  jsr armoredskelekin_draw

  rts

armoredskelekin_moveLeftState_handler:

  lda entity_instances+entity_instance::position_x,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #(ARMOREDSKELEKIN_HALFHEIGHT+8)  ;make sure to test blocks on ground
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_left_collision
  lda #ARMOREDSKELEKIN_MOVERIGHTSTATE
  sta entity_instances+entity_instance::state,x
no_left_collision:

  clc
  lda entity_instances+entity_instance::position_x,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #ARMOREDSKELEKIN_HEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  bne no_left_pit
  lda #ARMOREDSKELEKIN_MOVERIGHTSTATE
  sta entity_instances+entity_instance::state,x
no_left_pit:

  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #$01
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_x+1,x

  jsr armoredskelekin_draw

  rts

armoredskelekin_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killArmoredSkelekin

  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load armoredskelekin width and height
  lda #ARMOREDSKELEKIN_WIDTH
  sta b2
  lda #ARMOREDSKELEKIN_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox

  bne nomolosNotAttacking

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

  jmp killArmoredSkelekin

nomolosNotAttacking:

  ;load armoredskelekin width and height
  lda #ARMOREDSKELEKIN_WIDTH
  sta b2
  lda #ARMOREDSKELEKIN_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  lda entity_chr_offsets+(entity_index_armoredskelekin-1)
  sta sprite_group_offset

  lda entity_instances+entity_instance::state,x
  cmp #ARMOREDSKELEKIN_MOVELEFTSTATE
  bne armoredskelekin_moving_right
  lda #%01000000
  sta b2
  jmp armoredskelekin_direction_test_done
armoredskelekin_moving_right:
  lda #%00000000
  sta b2
armoredskelekin_direction_test_done:
  lda #<spritesheet2_ArmoredSkelekinWalk
  sta w2
  lda #>spritesheet2_ArmoredSkelekinWalk
  sta w2+1
  jsr entity_draw_anim

armoredskelekinOffscreen:
  rts

killArmoredSkelekin:

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

.endproc

.endif
