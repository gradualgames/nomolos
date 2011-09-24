.ifndef SNEEP_INC
SNEEP_INC = 1

SNEEP_WIDTH = $10
SNEEP_HEIGHT = $10

SNEEP_INITSTATE = 0
SNEEP_STANDSTATE = 1

.proc sneep_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #SNEEP_INITSTATE
  beq sneep_initState
  cmp #SNEEP_STANDSTATE
  beq sneep_standState

sneep_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #24
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  ;switch state
  lda #SNEEP_STANDSTATE
  sta entity_instances+entity_instance::state,x
  rts

sneep_standState:

  jsr entity_compute_screen_coordinates

  jsr sneep_draw

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
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load sneep width and height
  lda #SNEEP_WIDTH
  sta b2
  lda #SNEEP_HEIGHT
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

  jmp killSneep

nomolosNotAttacking:

  lda entity_chr_offsets+(entity_index_sneep-1)
  sta sprite_group_offset

  lda #<spritesheet2_SneepRun
  sta w2
  lda #>spritesheet2_SneepRun
  sta w2+1
  jsr entity_draw_anim

  lda #<spritesheet2_SneepEyeRun
  sta w2
  lda #>spritesheet2_SneepEyeRun
  sta w2+1
  jsr entity_draw_anim

sneepOffscreen:
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
.endproc

.endif
