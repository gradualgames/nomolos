.ifndef SHEEP_INC
SHEEP_INC = 1

.struct sheep_locals
  anim_address .word
.endstruct

SHEEP_WIDTH = $20
SHEEP_HALFWIDTH = $10
SHEEP_HEIGHT = $18
SHEEP_HALFHEIGHT = $0C

SHEEP_INITSTATE = 0
SHEEP_MOVERIGHTSTATE = 1
SHEEP_MOVELEFTSTATE = 2

.proc sheep_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #SHEEP_INITSTATE
  beq sheep_initState
  cmp #SHEEP_MOVERIGHTSTATE
  beq sheep_moveRightState
  cmp #SHEEP_MOVELEFTSTATE
  beq sheep_moveLeftState

sheep_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:

  lda #SHEEP_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x

  jmp entity_facing_test_done
entity_facing_right:

  lda #SHEEP_MOVERIGHTSTATE
  sta entity_instances+entity_instance::state,x

entity_facing_test_done:

  ;reposition the entity
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #8
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  rts

sheep_moveRightState:

  jsr sheep_test_below

  clc
  lda entity_instances+entity_instance::position_x,x
  adc #SHEEP_WIDTH
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #$00
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #SHEEP_HALFHEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_right_collision
  lda #SHEEP_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x
no_right_collision:

  clc
  lda entity_instances+entity_instance::position_x,x
  adc #$02
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #$00
  sta entity_instances+entity_instance::position_x+1,x

  jsr sheep_draw

  rts

sheep_moveLeftState:

  jsr sheep_test_below

  lda entity_instances+entity_instance::position_x,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #SHEEP_HALFHEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_left_collision
  lda #SHEEP_MOVERIGHTSTATE
  sta entity_instances+entity_instance::state,x
no_left_collision:

  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #$02
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_x+1,x

  jsr sheep_draw

  rts

killSheep:

  ;make it dead
  jsr entity_kill

  ;spawn an explosion entity
  lda #entity_index_explosionspawner
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

sheep_test_below:

  ;perform collision detection and eject if necessary
  ;load the entity's X coordinate + 8
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #SHEEP_HALFWIDTH
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta w0+1
  ;load the entity's Y coordinate + height
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #SHEEP_HEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1

  jsr map_test_collision
  lda b1
  bne bottom_collision
  
  ;there was nothing beneath the sheep so move it down
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #3
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_instances+entity_instance::position_y+1,x
  
bottom_collision:

  rts
  
sheep_draw:

  lda #<spritesheet2_SheepButt
  sta entity_locals+sheep_locals::anim_address,x
  lda #>spritesheet2_SheepButt
  sta entity_locals+sheep_locals::anim_address+1,x

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killSheep

  ;load sheep width and height
  lda #SHEEP_WIDTH
  sta b2
  lda #SHEEP_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

  lda #<spritesheet2_SheepButt
  sta entity_locals+sheep_locals::anim_address,x
  lda #>spritesheet2_SheepButt
  sta entity_locals+sheep_locals::anim_address+1,x

  jsr entity_reset_anim

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load sheep width and height
  lda #SHEEP_WIDTH
  sta b2
  lda #SHEEP_HEIGHT
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

  jmp killSheep

nomolosNotAttacking:

  lda entity_chr_offsets+(entity_index_sheep-1)
  sta sprite_group_offset

  lda entity_locals+sheep_locals::anim_address,x
  sta w2
  lda entity_locals+sheep_locals::anim_address+1,x
  sta w2+1
  lda entity_instances+entity_instance::state,x
  cmp #SHEEP_MOVELEFTSTATE
  bne sheep_moving_right
  lda #%01000000
  sta b2
  jmp sheep_direction_test_done
sheep_moving_right:
  lda #%00000000
  sta b2
sheep_direction_test_done:
  jsr entity_draw_anim

sheepOffscreen:
  rts

.endproc

.endif
