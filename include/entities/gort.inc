.ifndef GORT_INC
GORT_INC = 1

GORT_WIDTH  = $18
GORT_HEIGHT = $18

GORT_INITSTATE = 0
GORT_WAITSTATE = 1

.proc gort_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #GORT_INITSTATE
  beq gort_initState
  cmp #GORT_WAITSTATE
  beq gort_waitState

gort_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;position correctly
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #$08
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_y+1,x
  
  ;switch state to "wait"
  lda #GORT_WAITSTATE
  sta entity_instances+entity_instance::state,x
  rts

gort_waitState:

  jsr entity_compute_screen_coordinates

  jsr gort_draw

  rts

gort_draw:

  jsr entity_test_death_zone
  beq kill_gort
  
  lda entity_instances+entity_instance::position_y+1,x
  bne kill_gort

  ;load gort width and height
  lda #GORT_WIDTH
  sta b2
  lda #GORT_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load entity width and height
  lda #GORT_WIDTH
  sta b2
  lda #GORT_HEIGHT
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

  jmp kill_gort

nomolosNotAttacking:

  lda entity_chr_offsets+(entity_index_gort-1)
  sta sprite_group_offset

  lda #<spritesheet2_Gort0
  sta w0
  lda #>spritesheet2_Gort0
  sta w0+1

  lda #0
  sta b2
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_metasprite_16bit

gortOffscreen:
  rts

kill_gort:

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

  ;make it dead
  jsr entity_kill

  rts
.endproc

.endif
