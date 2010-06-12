.ifndef SNAIL_INC
SNAIL_INC = 1

.struct snail_locals
  anim_index .byte
.endstruct

SNAIL_WIDTH = $18
SNAIL_HEIGHT = $10
SNAIL_HALFHEIGHT = $08

SNAIL_INITSTATE = 0
SNAIL_MOVERIGHTSTATE = 1
SNAIL_MOVELEFTSTATE = 2

.export snail_update
.proc snail_update

  ;load current state
  lda entity_instances+entityRAM::state,x
  ;figure out what state to jump to
  cmp #SNAIL_INITSTATE
  beq snail_initState
  cmp #SNAIL_MOVERIGHTSTATE
  beq snail_moveRightState
  cmp #SNAIL_MOVELEFTSTATE
  beq snail_moveLeftState

snail_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim
  
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:

  lda #SNAIL_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x

  jmp entity_facing_test_done
entity_facing_right:

  lda #SNAIL_MOVERIGHTSTATE
  sta entity_instances+entityRAM::state,x

entity_facing_test_done:
  
  rts

snail_moveRightState:

  clc
  lda entity_instances+entityRAM::positionX,x
  adc #SNAIL_WIDTH
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  adc #$00
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #SNAIL_HALFHEIGHT
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_right_collision
  lda #SNAIL_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x
no_right_collision:

  clc
  lda entity_instances+entityRAM::positionX,x
  adc #$01
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  adc #$00
  sta entity_instances+entityRAM::positionX+1,x

  jsr snail_draw

  rts

snail_moveLeftState:
 
  lda entity_instances+entityRAM::positionX,x
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #SNAIL_HALFHEIGHT
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_left_collision
  lda #SNAIL_MOVERIGHTSTATE
  sta entity_instances+entityRAM::state,x
no_left_collision:
 
  sec
  lda entity_instances+entityRAM::positionX,x
  sbc #$01
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  sbc #$00
  sta entity_instances+entityRAM::positionX+1,x

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

  lda #ROMDefinitionTableStruct::SnailCrawl
  sta entity_locals+snail_locals::anim_index,x

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
  
  lda #ROMDefinitionTableStruct::SnailCrawl
  sta entity_locals+snail_locals::anim_index,x
  
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
  
  jmp killSnail
  
nomolosNotAttacking:

  ldy #ROMDefinitionTableStruct::SnailOffset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy entity_locals+snail_locals::anim_index,x
  lda entity_instances+entityRAM::state,x
  cmp #SNAIL_MOVELEFTSTATE
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
