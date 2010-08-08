.ifndef DEENTLE_INC
DEENTLE_INC = 1

DEENTLE_WIDTH = $10
DEENTLE_HEIGHT = $10

DEENTLE_INITSTATE = 0
DEENTLE_MOVERIGHTSTATE = 1
DEENTLE_MOVELEFTSTATE = 2

.proc deentle_update

  ;load current state
  lda entity_instances+entityRAM::state,x
  ;figure out what state to jump to
  cmp #DEENTLE_INITSTATE
  beq deentle_initState
  cmp #DEENTLE_MOVERIGHTSTATE
  beq deentle_moveRightState
  cmp #DEENTLE_MOVELEFTSTATE
  beq deentle_moveLeftState

deentle_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;switch state to "run"
  lda #DEENTLE_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x
  rts

deentle_moveRightState:

  ;add 1 to PositionX
  clc
  lda entity_instances+entityRAM::positionX,x
  adc #1
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  adc #0
  sta entity_instances+entityRAM::positionX+1,x

  ;do PositionX - spawnPositionX
  sec
  lda entity_instances+entityRAM::positionX,x
  sbc entity_instances+entityRAM::spawnPositionX,x
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  sbc entity_instances+entityRAM::spawnPositionX+1,x
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
  sta entity_instances+entityRAM::state,x

dontSwitchToLeftState:

  jsr deentle_draw

  rts

deentle_moveLeftState:

  ;sub 1 from PositionX
  sec
  lda entity_instances+entityRAM::positionX,x
  sbc #1
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  sbc #0
  sta entity_instances+entityRAM::positionX+1,x

  ;do spawnPositionX - PositionX
  sec
  lda entity_instances+entityRAM::spawnPositionX,x
  sbc entity_instances+entityRAM::positionX,x
  sta w0
  lda entity_instances+entityRAM::spawnPositionX+1,x
  sbc entity_instances+entityRAM::positionX+1,x
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
  sta entity_instances+entityRAM::state,x

dontSwitchToRightState:

  jsr deentle_draw

  rts

deentle_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killDeentle

  ;load deentle width and height
  lda #DEENTLE_WIDTH
  sta b2
  lda #DEENTLE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:
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

  ldy #level_data_struct::deentle_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::deentle_walk
  jsr entity_draw_anim

deentleOffscreen:
  rts

killDeentle:

  ;make it dead
  jsr entity_kill

  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ;get out low byte of positionX
  lda entity_instances+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1

  ;get out positionY
  lda entity_instances+entityRAM::positionY,x
  sta b1

  jsr entity_spawn

  rts
.endproc

.endif
