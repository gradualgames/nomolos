.ifndef SNUFFER_INC
SNUFFER_INC = 1

.struct snuffer_locals
  anim_index .byte
.endstruct

SNUFFER_WIDTH = $20
SNUFFER_HEIGHT = $18
SNUFFER_HALFHEIGHT = $0C

SNUFFER_INITSTATE = 0
SNUFFER_MOVERIGHTSTATE = 1
SNUFFER_MOVELEFTSTATE = 2

.export snuffer_update
.proc snuffer_update

  ;load current state
  lda entity_instances+entityRAM::state,x
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
  sta entity_instances+entityRAM::state,x

  jmp entity_facing_test_done
entity_facing_right:

  lda #SNUFFER_MOVERIGHTSTATE
  sta entity_instances+entityRAM::state,x

entity_facing_test_done:
  
  rts

snuffer_moveRightState:

  clc
  lda entity_instances+entityRAM::positionX,x
  adc #SNUFFER_WIDTH
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  adc #$00
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #SNUFFER_HALFHEIGHT
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_right_collision
  lda #SNUFFER_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x
no_right_collision:

  clc
  lda entity_instances+entityRAM::positionX,x
  adc #$02
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  adc #$00
  sta entity_instances+entityRAM::positionX+1,x

  jsr snuffer_draw

  rts

snuffer_moveLeftState:
 
  lda entity_instances+entityRAM::positionX,x
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #SNUFFER_HALFHEIGHT
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_left_collision
  lda #SNUFFER_MOVERIGHTSTATE
  sta entity_instances+entityRAM::state,x
no_left_collision:
 
  sec
  lda entity_instances+entityRAM::positionX,x
  sbc #$02
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  sbc #$00
  sta entity_instances+entityRAM::positionX+1,x

  jsr snuffer_draw

  rts
  
killSnuffer:

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
  
snuffer_draw:

  lda #ROMDefinitionTableStruct::SnufferRun
  sta entity_locals+snuffer_locals::anim_index,x

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killSnuffer
  
  ;load snuffer width and height
  lda #SNUFFER_WIDTH
  sta b2
  lda #SNUFFER_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
  lda #ROMDefinitionTableStruct::SnufferBite
  sta entity_locals+snuffer_locals::anim_index,x
  
  jsr entity_reset_anim
  
:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking
  
  ;load snuffer width and height
  lda #SNUFFER_WIDTH
  sta b2
  lda #SNUFFER_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox
  
  bne nomolosNotAttacking
  
  ;play a hit sound
  txa
  pha
  
  lda #<hitSound
  sta sound_param_word_0
  lda #>hitSound
  sta sound_param_word_0+1
  
  lda #3
  sta sound_param_byte_0
  
  ldx #soundeffect_two
  jsr stream_initialize
  
  pla
  tax
  
  jmp killSnuffer
  
nomolosNotAttacking:

  ldy #ROMDefinitionTableStruct::SnufferOffset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy entity_locals+snuffer_locals::anim_index,x
  lda entity_instances+entityRAM::state,x
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
