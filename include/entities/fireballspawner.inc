.ifndef FIREBALLSPAWNER_INC
FIREBALLSPAWNER_INC = 1

.struct fireballspawner_locals
  counter .byte
  prng_seed .byte
.endstruct

FIREBALLSPAWNER_INITSTATE = 0
FIREBALLSPAWNER_RUNSTATE = 1

.proc fireballspawner_get_next_prn
  ldy #10
  
: lda entity_locals+fireballspawner_locals::prng_seed,x
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor #$1d
noEor:
  sta entity_locals+fireballspawner_locals::prng_seed,x
  dey
  bne :-

  rts
.endproc
  
.proc fireballspawner_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  cmp #FIREBALLSPAWNER_INITSTATE
  beq fireballspawner_init
  cmp #FIREBALLSPAWNER_RUNSTATE
  beq fireballspawner_run

fireballspawner_init:

  lda entity_instances+entity_instance::index,x
  sta b0
  lda entity_instances+entity_instance::spawn_position_x,x
  sta w0
  lda entity_instances+entity_instance::spawn_position_x+1,x
  sta w0+1
  lda entity_instances+entity_instance::spawn_position_y,x
  sta b1
  jsr entity_kill_if_redundant_entity

  ;init spawn counter
  lda #0
  sta entity_locals+fireballspawner_locals::counter,x
  
  ;set random number seed
  lda #11
  sta entity_locals+fireballspawner_locals::prng_seed,x

  ;reposition the entity
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #8
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x
  
  ;set state to run
  lda #FIREBALLSPAWNER_RUNSTATE
  sta entity_instances+entity_instance::state,x

  rts

fireballspawner_run:

  jsr fireballspawner_get_next_prn

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq kill_fireballspawner
  
  dec entity_locals+fireballspawner_locals::counter,x
  lda entity_locals+fireballspawner_locals::counter,x
  and #$1f
  bne do_not_spawn_fireball

  ;play a foom sound
  txa
  pha

  lda #<foom_sound
  sta sound_param_word_0
  lda #>foom_sound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax
  
  ;spawn a fireball entity
  lda #entity_index_fireball
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
  
  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the fireball we just spawned
  lda entity_locals+fireballspawner_locals::prng_seed,x
  sta entity_locals+fireball_locals::x_velocity,y
  
  ror
  ror
  and #$01
  bne right
left:
  lda #$ff
  sta entity_locals+fireball_locals::x_velocity+1,y
  jmp random_direction_test_done
right:
  lda #$01
  sta entity_locals+fireball_locals::x_velocity+1,y
random_direction_test_done:

  ;set vertical velocity
  lda #$0a
  sta entity_locals+fireball_locals::y_velocity,y
  lda #$fc
  sta entity_locals+fireball_locals::y_velocity+1,y
  
  ;reset the fireball's animation
  lda #1
  sta entity_instances+entity_instance::animation_object,y
  lda #$ff
  sta entity_instances+entity_instance::animation_object+1,y
  
  lda #FIREBALL_JUMPSTATE
  sta entity_instances+entity_instance::state,y
  
do_not_spawn_fireball:

  rts
 
kill_fireballspawner:

  jsr entity_kill
  
  rts
  
.endproc

.endif
