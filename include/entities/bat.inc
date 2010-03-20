.ifndef BAT_INC
BAT_INC = 1

BAT_INITSTATE = 0
BAT_MOVERIGHTSTATE = 1
BAT_MOVELEFTSTATE = 2

.export bat_update
.proc bat_update

  ;load current state
  lda entity_instances+entityRAM::state,x
  ;figure out what state to jump to
  cmp #BAT_INITSTATE
  beq bat_initState
  cmp #BAT_MOVERIGHTSTATE
  beq bat_moveRightState
  cmp #BAT_MOVELEFTSTATE
  beq bat_moveLeftState

bat_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entity_instances+entityRAM::animationObject,x
  lda #$ff
  sta entity_instances+entityRAM::animationObject+1,x
  
  ;switch state to "move left"
  lda #BAT_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x
  rts

bat_moveRightState:

  clc
  lda entity_instances+entityRAM::positionX,x
  adc #$10
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  adc #$00
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #$10
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_right_collision
  lda #BAT_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x
no_right_collision:

  clc
	lda entity_instances+entityRAM::positionX,x
	adc #$01
	sta entity_instances+entityRAM::positionX,x
	lda entity_instances+entityRAM::positionX+1,x
	adc #$00
	sta entity_instances+entityRAM::positionX+1,x

  jsr bat_draw

  rts

bat_moveLeftState:
 
  lda entity_instances+entityRAM::positionX,x
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #$10
  sta w1
  lda entity_instances+entityRAM::positionY+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq no_left_collision
  lda #BAT_MOVERIGHTSTATE
  sta entity_instances+entityRAM::state,x
no_left_collision:
 
  sec
	lda entity_instances+entityRAM::positionX,x
	sbc #$01
	sta entity_instances+entityRAM::positionX,x
	lda entity_instances+entityRAM::positionX+1,x
	sbc #$00
	sta entity_instances+entityRAM::positionX+1,x

  jsr bat_draw

  rts
  
bat_draw:

  jsr entity_compute_screen_coordinates

  ;test the x coordinate for whether it is a certain distance off screen. compare it
  ;to -32.
  ;-32 - -40 = 8. positive = offscreen, die. negative = onscreen, do not die.
  sec
  lda #$e0
  sbc entity_screen_x
  lda #$ff
  sbc entity_screen_x+1
  bmi batOnScreen
  
  jmp killBat
  
batOnScreen:  
  
  ;load bat width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking
  
  ;load bat width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_hitbox
  
  bne nomolosNotAttacking
  
  ;play an explode sound
  lda #<hitSound
  sta w0
  lda #>hitSound
  sta w0+1
  jsr sound_load
  
  jmp killBat
  
nomolosNotAttacking:

  ;load address of animation object into w1
  lda #<(entity_instances+entityRAM::animationObject)
  sta w1
  lda #>(entity_instances+entityRAM::animationObject)
  sta w1+1
  
  ;get the index into a
  txa
  clc
  ;do a 16 bit add onto the address with this index
  adc w1
  sta w1
  lda w1+1
  adc #0
  sta w1+1 
  
  ;load address of bat animation definition into w2
  ldy #ROMDefinitionTableStruct::BatFly
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_update_animation  
  
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  lda entity_instances+entityRAM::state,x
  cmp #BAT_MOVELEFTSTATE
  bne bat_moving_right
  lda #%01000000
  sta b2
  jmp bat_direction_test_done
bat_moving_right:
  lda #%00000000
  sta b2
bat_direction_test_done:
  jsr sprite_draw_animation_16bit
batOffscreen:
  rts
  
killBat:

  ;make it dead
  lda #0
  sta entity_instances+entityRAM::alive,x
  
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
