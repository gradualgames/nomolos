.ifndef DEENTLE_INC
DEENTLE_INC = 1

DEENTLE_WIDTH = $10
DEENTLE_HEIGHT = $10

DEENTLE_INITSTATE = 0
DEENTLE_MOVERIGHTSTATE = 1
DEENTLE_MOVELEFTSTATE = 2

.proc deentle_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #DEENTLE_INITSTATE
  beq deentle_initState
  cmp #DEENTLE_MOVERIGHTSTATE
  beq deentle_moveRightState
  cmp #DEENTLE_MOVELEFTSTATE
  beq deentle_moveLeftState

deentle_initState:

  jsr entity_kill_if_redundant_entity

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;switch state to "run"
  lda #DEENTLE_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x
  rts

deentle_moveRightState:

  ;add 1 to position_x
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #1
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x

  ;do position_x - spawn_position_x
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc entity_instances+entity_instance::spawn_position_x,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sbc entity_instances+entity_instance::spawn_position_x+1,x
  sta w0+1

  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1
  bne dontSwitchToLeftState

  lda #DEENTLE_MOVELEFTSTATE
  sta entity_instances+entity_instance::state,x

dontSwitchToLeftState:

  jsr deentle_draw

  rts

deentle_moveLeftState:

  ;sub 1 from position_x
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #1
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  ;do spawn_position_x - position_x
  sec
  lda entity_instances+entity_instance::spawn_position_x,x
  sbc entity_instances+entity_instance::position_x,x
  sta w0
  lda entity_instances+entity_instance::spawn_position_x+1,x
  sbc entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1

  bne dontSwitchToRightState

  lda #DEENTLE_MOVERIGHTSTATE
  sta entity_instances+entity_instance::state,x

dontSwitchToRightState:

  jsr deentle_draw

  rts

deentle_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killDeentle

  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load deentle width and height
  lda #DEENTLE_WIDTH
  sta b2
  lda #DEENTLE_HEIGHT
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

  jmp killDeentle

nomolosNotAttacking:

  ;load deentle width and height
  lda #DEENTLE_WIDTH
  sta b2
  lda #DEENTLE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  lda entity_chr_offsets+(entity_index_deentle-1)
  sta sprite_group_offset

  lda #<spritesheet1_DeentleWalk
  sta w2
  lda #>spritesheet1_DeentleWalk
  sta w2+1
  jsr entity_draw_anim

deentleOffscreen:
  rts

killDeentle:

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
