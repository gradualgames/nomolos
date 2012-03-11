.ifndef EXPLOSIONSPAWNER_INITSTATE
EXPLOSIONSPAWNER_INITSTATE = 0
.endif

.ifndef EXPLOSIONSPAWNER_SPAWNSTATE
EXPLOSIONSPAWNER_SPAWNSTATE = 1
.endif

.ifndef explosionspawner_locals_def
explosionspawner_locals_def = 1
.struct explosionspawner_locals
  counter .byte
  x_offset .byte
  y_offset .byte
.endstruct
.endif

.ifndef explosionspawner_update
explosionspawner_update:
.endif
.scope

  lda entity_instances+entity_instance::state,x
  cmp #EXPLOSIONSPAWNER_INITSTATE
  beq explosionspawnerInit
  cmp #EXPLOSIONSPAWNER_SPAWNSTATE
  beq explosionspawnerSpawnState

explosionspawnerInit:

  jsr entity_compute_screen_coordinates

  ;kill if offscreen horizontally
  lda entity_screen_x+1
  bne kill_explosionspawner
  ;kill if offscreen positive (so not on 0, but yes on positive)
  lda entity_screen_y+1
  beq :+
  bpl kill_explosionspawner
:
  
  ;start counter
  lda #21
  sta entity_locals+explosionspawner_locals::counter,x

  lda #0
  sta entity_locals+explosionspawner_locals::x_offset,x
  sta entity_locals+explosionspawner_locals::y_offset,x

  ;switch to spawn state
  lda #EXPLOSIONSPAWNER_SPAWNSTATE
  sta entity_instances+entity_instance::state,x

  rts

kill_explosionspawner:

  jsr entity_kill

  rts

explosionspawnerSpawnState:

  dec entity_locals+explosionspawner_locals::counter,x
  beq kill_explosionspawner

  lda entity_locals+explosionspawner_locals::counter,x
  and #$02
  sta camera_scroll_y

  lda entity_locals+explosionspawner_locals::counter,x
  and #$03
  bne do_not_spawn_explosion

  lda entity_locals+explosionspawner_locals::x_offset,x
  clc
  adc #$04
  sta entity_locals+explosionspawner_locals::x_offset,x
  lda entity_locals+explosionspawner_locals::x_offset,x
  cmp #$08
  bne do_not_increment_y_offset
  lda #$00
  sta entity_locals+explosionspawner_locals::x_offset,x
  lda entity_locals+explosionspawner_locals::y_offset,x
  clc
  adc #$04
  sta entity_locals+explosionspawner_locals::y_offset,x
do_not_increment_y_offset:

  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  clc
  adc entity_locals+explosionspawner_locals::x_offset,x
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  clc
  adc entity_locals+explosionspawner_locals::y_offset,x
  sta b1
  lda entity_instances+entity_instance::position_y+1,x
  sta b2

  jsr entity_spawn

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

do_not_spawn_explosion:

  rts

.endscope
