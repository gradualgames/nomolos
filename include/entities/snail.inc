.ifndef SNAIL_INC
SNAIL_INC = 1

.struct snail_locals
  direction .byte
  move_stop .byte
  distance  .byte
.endstruct

SNAIL_WIDTH = $18
SNAIL_HEIGHT = $10
SNAIL_HALFHEIGHT = $08

SNAIL_DISTANCE_TIL_ABOUT_FACE = 150
SNAIL_DISTANCE_TIL_SWITCH_STATE = 50
SNAIL_SPEED = 100

SNAIL_INITSTATE = 0
SNAIL_MOVESTATE = 1
SNAIL_STOPSTATE = 2

.proc snail_update

  ;load current state
  lda entity_instances+entityRAM::state,x
  ;figure out what state to jump to
  cmp #SNAIL_INITSTATE
  beq snail_initState
  cmp #SNAIL_MOVESTATE
  beq snail_moveState
  cmp #SNAIL_STOPSTATE
  beq snail_stopState

snail_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim
  
  lda #0
  sta entity_locals+snail_locals::direction,x
  lda #SNAIL_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+snail_locals::move_stop,x
  lda #SNAIL_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+snail_locals::distance,x
  
  lda #SNAIL_MOVESTATE
  sta entity_instances+entityRAM::state,x
  
  rts

snail_moveState:

  .scope
  dec entity_locals+snail_locals::move_stop,x
  bne do_not_switch_state
  
  lda #SNAIL_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+snail_locals::move_stop,x
  
  lda #SNAIL_STOPSTATE
  sta entity_instances+entityRAM::state,x
  
do_not_switch_state:
  .endscope
  
  dec entity_locals+snail_locals::distance,x
  bne do_not_flip_direction
  
  lda entity_locals+snail_locals::direction,x
  eor #$ff
  sta entity_locals+snail_locals::direction,x
  
  lda #SNAIL_DISTANCE_TIL_ABOUT_FACE
  sta entity_locals+snail_locals::distance,x
  
do_not_flip_direction:

  lda entity_locals+snail_locals::direction,x
  bne move_right
  
move_left:

  sec
  lda entity_instances+entityRAM::positionXFine,x
  sbc #SNAIL_SPEED
  sta entity_instances+entityRAM::positionXFine,x
  lda entity_instances+entityRAM::positionX,x
  sbc #0
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  sbc #0
  sta entity_instances+entityRAM::positionX+1,x

  jmp direction_test_done
move_right:

  clc
  lda entity_instances+entityRAM::positionXFine,x
  adc #SNAIL_SPEED
  sta entity_instances+entityRAM::positionXFine,x
  lda entity_instances+entityRAM::positionX,x
  adc #0
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  adc #0
  sta entity_instances+entityRAM::positionX+1,x

direction_test_done:

  jsr snail_draw

  rts

snail_stopState:

  .scope
  dec entity_locals+snail_locals::move_stop,x
  bne do_not_switch_state
  
  lda #SNAIL_DISTANCE_TIL_SWITCH_STATE
  sta entity_locals+snail_locals::move_stop,x
  
  lda #SNAIL_MOVESTATE
  sta entity_instances+entityRAM::state,x
  
do_not_switch_state:
  .endscope

  jsr snail_draw
  
  rts
  
killSnail:

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
  
snail_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killSnail
  
  ;load snail width and height
  lda #SNAIL_WIDTH
  sta b2
  lda #SNAIL_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
  jsr entity_reset_anim
  
:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking
  
  ;load snail width and height
  lda #SNAIL_WIDTH
  sta b2
  lda #SNAIL_HEIGHT
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
  
  jmp killSnail
  
nomolosNotAttacking:

  ldy #level_data_struct::snail_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::snail_crawl
  lda entity_locals+snail_locals::direction,x
  cmp #0
  bne snail_moving_right
  lda #%00000000
  sta b2
  jmp snail_direction_test_done
snail_moving_right:
  lda #%01000000
  sta b2
snail_direction_test_done:
  jsr entity_draw_anim
  
snailOffscreen:
  rts

.endproc
  
.endif
