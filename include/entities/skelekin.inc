.ifndef SKELEKIN_INC
SKELEKIN_INC = 1

SKELEKIN_WIDTH = $10
SKELEKIN_HEIGHT = $20
SKELEKIN_HALFHEIGHT = $10

SKELEKIN_INITSTATE = 0
SKELEKIN_MOVERIGHTSTATE = 1
SKELEKIN_MOVELEFTSTATE = 2

.proc skelekin_update

  ;load current state
  lda entity_instances+entityRAM::state,x
  ;figure out what state to jump to
  cmp #SKELEKIN_INITSTATE
  beq skelekin_initState
  cmp #SKELEKIN_MOVERIGHTSTATE
  beq skelekin_moveRightState
  cmp #SKELEKIN_MOVELEFTSTATE
  beq skelekin_moveLeftState

skelekin_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim
  
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:

  lda #SKELEKIN_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x

  jmp entity_facing_test_done
entity_facing_right:

  lda #SKELEKIN_MOVERIGHTSTATE
  sta entity_instances+entityRAM::state,x

entity_facing_test_done:
  
  rts

skelekin_moveRightState:

  clc
  lda entity_instances+entityRAM::positionX,x
  adc #SKELEKIN_WIDTH
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  adc #$00
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #SKELEKIN_HALFHEIGHT
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_right_collision
  lda #SKELEKIN_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x
no_right_collision:

  clc
  lda entity_instances+entityRAM::positionX,x
  adc #$01
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  adc #$00
  sta entity_instances+entityRAM::positionX+1,x

  jsr skelekin_draw

  rts

skelekin_moveLeftState:
 
  lda entity_instances+entityRAM::positionX,x
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #SKELEKIN_HALFHEIGHT
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_left_collision
  lda #SKELEKIN_MOVERIGHTSTATE
  sta entity_instances+entityRAM::state,x
no_left_collision:
 
  sec
  lda entity_instances+entityRAM::positionX,x
  sbc #$01
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  sbc #$00
  sta entity_instances+entityRAM::positionX+1,x

  jsr skelekin_draw

  rts
  
skelekin_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killSkelekin
  
  ;load skelekin width and height
  lda #SKELEKIN_WIDTH
  sta b2
  lda #SKELEKIN_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking
  
  ;load skelekin width and height
  lda #SKELEKIN_WIDTH
  sta b2
  lda #SKELEKIN_HEIGHT
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
  
  jmp killSkelekin
  
nomolosNotAttacking:

  ldy #ROMDefinitionTableStruct::SkelekinOffset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda entity_instances+entityRAM::state,x
  cmp #SKELEKIN_MOVELEFTSTATE
  bne skelekin_moving_right
  lda #%01000000
  sta b2
  jmp skelekin_direction_test_done
skelekin_moving_right:
  lda #%00000000
  sta b2
skelekin_direction_test_done:
  ldy #ROMDefinitionTableStruct::SkelekinWalk
  jsr entity_draw_anim

skelekinOffscreen:
  rts
  
killSkelekin:

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
