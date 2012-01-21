.ifndef SNUFFER_INC
SNUFFER_INC = 1

.struct snuffer_locals
  anim_address .word
.endstruct

SNUFFER_WIDTH = $20
SNUFFER_HALFWIDTH = $10
SNUFFER_HEIGHT = $18
SNUFFER_HALFHEIGHT = $0C

SNUFFER_INITSTATE = 0
SNUFFER_MOVERIGHTSTATE = 1
SNUFFER_MOVELEFTSTATE = 2

.proc snuffer_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #SNUFFER_INITSTATE
  beq snuffer_initState
  cmp #SNUFFER_MOVERIGHTSTATE
  beq snuffer_moveRightState
  cmp #SNUFFER_MOVELEFTSTATE
  beq snuffer_moveLeftState

snuffer_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:

  lda #SNUFFER_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x

  jmp entity_facing_test_done
entity_facing_right:

  lda #SNUFFER_MOVERIGHTSTATE
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

snuffer_moveRightState:

  jsr snuffer_test_below

  clc
  lda entity_instances+entity_instance::position_x,x
  adc #SNUFFER_WIDTH
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #$00
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #SNUFFER_HALFHEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_right_collision
  lda #SNUFFER_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x
no_right_collision:

  clc
  lda entity_instances+entity_instance::position_x,x
  adc #$02
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #$00
  sta entity_instances+entity_instance::position_x+1,x

  jsr snuffer_draw

  rts

snuffer_moveLeftState:

  jsr snuffer_test_below

  lda entity_instances+entity_instance::position_x,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #SNUFFER_HALFHEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_left_collision
  lda #SNUFFER_MOVERIGHTSTATE
  sta entity_instances+entity_instance::state,x
no_left_collision:

  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #$02
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_x+1,x

  jsr snuffer_draw

  rts

killSnuffer:

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

snuffer_test_below:

  ;perform collision detection and eject if necessary
  ;load the entity's X coordinate + 8
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #SNUFFER_HALFWIDTH
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta w0+1
  ;load the entity's Y coordinate + height
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #SNUFFER_HEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1

  jsr map_test_collision
  lda b1
  bne bottom_collision
  
  ;there was nothing beneath the snuffer so move it down
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #3
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_instances+entity_instance::position_y+1,x
  
bottom_collision:

  rts
  
snuffer_draw:

  lda #<spritesheet1_SnufferRun
  sta entity_locals+snuffer_locals::anim_address,x
  lda #>spritesheet1_SnufferRun
  sta entity_locals+snuffer_locals::anim_address+1,x

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killSnuffer

  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load snuffer width and height
  lda #SNUFFER_WIDTH
  sta b2
  lda #SNUFFER_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox

  bne nomolosNotAttacking

  jmp killSnuffer

nomolosNotAttacking:

  ;load snuffer width and height
  lda #SNUFFER_WIDTH
  sta b2
  lda #SNUFFER_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

  lda #<spritesheet1_SnufferBite
  sta entity_locals+snuffer_locals::anim_address,x
  lda #>spritesheet1_SnufferBite
  sta entity_locals+snuffer_locals::anim_address+1,x

  jsr entity_reset_anim

:

  lda entity_chr_offsets+(entity_index_snuffer-1)
  sta sprite_group_offset

  lda entity_locals+snuffer_locals::anim_address,x
  sta w2
  lda entity_locals+snuffer_locals::anim_address+1,x
  sta w2+1
  lda entity_instances+entity_instance::state,x
  cmp #SNUFFER_MOVELEFTSTATE
  bne snuffer_moving_right
  lda #%01000000
  sta b2
  jmp snuffer_direction_test_done
snuffer_moving_right:
  lda #%00000000
  sta b2
snuffer_direction_test_done:
  jsr entity_draw_anim

snufferOffscreen:
  rts

.endproc

.endif
