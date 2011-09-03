.ifndef ATTACKNID_INC
ATTACKNID_INC = 1

.struct attacknid_locals
  original_y .word
  goal_y .word
.endstruct

ATTACKNID_WIDTH = $10
ATTACKNID_HEIGHT = $10

ATTACKNID_INITSTATE = 0
ATTACKNID_WAITSTATE = 1
ATTACKNID_CLIMBDOWNSTATE = 2
ATTACKNID_CLIMBUPSTATE = 3

.proc attacknid_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #ATTACKNID_INITSTATE
  beq attacknid_initState
  cmp #ATTACKNID_WAITSTATE
  beq attacknid_wait_state
  cmp #ATTACKNID_CLIMBDOWNSTATE
  beq attacknid_climb_down_state
  cmp #ATTACKNID_CLIMBUPSTATE
  beq attacknid_climb_up_state

attacknid_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;remember original Y coordinate
  lda entity_instances+entity_instance::position_y,x
  sta entity_locals+attacknid_locals::original_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sta entity_locals+attacknid_locals::original_y+1,x

  ;switch state to "wait"
  lda #ATTACKNID_WAITSTATE
  sta entity_instances+entity_instance::state,x
  rts

attacknid_wait_state:

  jsr entity_compute_screen_coordinates

  ;compare Nomolos's X coordinate to the entity's X coordinate

  ;load left side of line A
  lda nomolos_screen_x
  sta b2
  ;load right side of line A
  clc
  adc #nomolos_width
  sta b3

  ;load left side of line B
  lda entity_screen_x
  sec 
  sbc #32
  sta b4
  ;load right side of line B
  clc
  adc #ATTACKNID_WIDTH
  adc #64
  sta b5

  jsr geotests_compare_range
  bne do_not_switch_to_climb_down_state

  ;store goal Y
  lda nomolos_map_y+1
  sta entity_locals+attacknid_locals::goal_y,x
  lda nomolos_map_y+2
  sta entity_locals+attacknid_locals::goal_y+1,x

  lda #ATTACKNID_CLIMBDOWNSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_climb_down_state:

  jsr attacknid_draw

  rts

attacknid_climb_down_state:

  jsr entity_compute_screen_coordinates

  clc
  lda entity_instances+entity_instance::position_y,x
  adc #$04
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc #$00
  sta entity_instances+entity_instance::position_y+1,x

  ;compare y coordinate to goal y.
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc entity_locals+attacknid_locals::goal_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc entity_locals+attacknid_locals::goal_y+1,x

  bmi do_not_switch_to_climb_up_state

  lda #ATTACKNID_CLIMBUPSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_climb_up_state:

  jsr attacknid_draw

  rts

attacknid_climb_up_state:

  jsr entity_compute_screen_coordinates

  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #$01
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_y+1,x

  ;compare y coordinate to original y

  sec
  lda entity_instances+entity_instance::position_y,x
  sbc entity_locals+attacknid_locals::original_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc entity_locals+attacknid_locals::original_y+1,x
  bpl do_not_switch_to_wait_state

  lda #ATTACKNID_WAITSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_wait_state:

  jsr attacknid_draw

  rts

killAttacknid:

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

attacknid_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killAttacknid

  ;load attacknid width and height
  lda #ATTACKNID_WIDTH
  sta b2
  lda #ATTACKNID_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load attacknid width and height
  lda #ATTACKNID_WIDTH
  sta b2
  lda #ATTACKNID_HEIGHT
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

  jmp killAttacknid

nomolosNotAttacking:

  lda entity_chr_offsets+(entity_index_attacknid-1)
  sta sprite_group_offset

  lda #<spritesheet2_AttacknidClimb
  sta w2
  lda #>spritesheet2_AttacknidClimb
  sta w2+1
  jsr entity_draw_anim

attacknidOffscreen:
  rts

.endproc

.endif
