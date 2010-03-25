.ifndef BAT_INC
BAT_INC = 1

.struct bat_locals
  y_velocity .word
.endstruct

BAT_INITSTATE = 0
BAT_DESCENT_STATE = 1
BAT_TROUGH_STATE = 2
BAT_ASCENT_STATE = 3
BAT_CREST_STATE = 4

BAT_VERTICAL_ACCELERATION = 20

.export bat_update
.proc bat_update

  ;load current state
  lda entity_instances+entityRAM::state,x
  ;figure out what state to jump to
  cmp #BAT_INITSTATE
  beq bat_initState
  cmp #BAT_DESCENT_STATE
  beq bat_descent_state
  cmp #BAT_TROUGH_STATE
  beq bat_trough_state
  cmp #BAT_ASCENT_STATE
  beq bat_ascent_state
  cmp #BAT_CREST_STATE
  beq bat_crest_state

bat_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entity_instances+entityRAM::animationObject,x
  lda #$ff
  sta entity_instances+entityRAM::animationObject+1,x
  
  ;clear locals
  lda #0
  sta entityLocals+bat_locals::y_velocity,x
  sta entityLocals+bat_locals::y_velocity+1,x
  
  ;switch state to "descent"
  lda #BAT_DESCENT_STATE
  sta entity_instances+entityRAM::state,x
  rts

bat_descent_state:

  ;increase vertical velocity until certain value is reached, then switch to trough state.
  clc
  lda entityLocals+bat_locals::y_velocity,x
  adc #BAT_VERTICAL_ACCELERATION
  sta entityLocals+bat_locals::y_velocity,x
  lda entityLocals+bat_locals::y_velocity+1,x
  adc #0
  sta entityLocals+bat_locals::y_velocity+1,x
  cmp #2
  bmi do_not_switch_to_trough_state
  
  lda #BAT_TROUGH_STATE
  sta entity_instances+entityRAM::state,x
  
do_not_switch_to_trough_state:
  
  jsr bat_move

  jsr bat_draw

  rts

bat_trough_state:

  ;decrease vertical velocity until zero, then switch to ascent state.
  sec
  lda entityLocals+bat_locals::y_velocity,x
  sbc #BAT_VERTICAL_ACCELERATION
  sta entityLocals+bat_locals::y_velocity,x
  lda entityLocals+bat_locals::y_velocity+1,x
  sbc #0
  sta entityLocals+bat_locals::y_velocity+1,x
  cmp #0
  bne do_not_switch_to_ascent_state

  lda #BAT_ASCENT_STATE
  sta entity_instances+entityRAM::state,x
  
do_not_switch_to_ascent_state:
  
  jsr bat_move
  
  jsr bat_draw

  rts
  
bat_ascent_state:

  ;decrease vertical velocity until certain value, then switch to crest state.
  sec
  lda entityLocals+bat_locals::y_velocity,x
  sbc #10
  sta entityLocals+bat_locals::y_velocity,x
  lda entityLocals+bat_locals::y_velocity+1,x
  sbc #0
  sta entityLocals+bat_locals::y_velocity+1,x
  cmp #$fe
  bpl do_not_switch_to_crest_state
  
  lda #BAT_CREST_STATE
  sta entity_instances+entityRAM::state,x
  
do_not_switch_to_crest_state:

  jsr bat_move

  jsr bat_draw
  
  rts
  
bat_crest_state:

  ;increase vertical velocity until zero, then switch to descent state.
  clc
  lda entityLocals+bat_locals::y_velocity,x
  adc #10
  sta entityLocals+bat_locals::y_velocity,x
  lda entityLocals+bat_locals::y_velocity+1,x
  adc #0
  sta entityLocals+bat_locals::y_velocity+1,x
  cmp #0
  bne do_not_switch_to_descent_state

  lda #BAT_DESCENT_STATE
  sta entity_instances+entityRAM::state,x
  
do_not_switch_to_descent_state:
  
  jsr bat_move

  jsr bat_draw
  
  rts
  
bat_move:

  ;move bat left
  sec
  lda entity_instances+entityRAM::positionX,x
  sbc #1
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  sbc #0
  sta entity_instances+entityRAM::positionX+1,x

  ;add y velocity to 24 bit Y coordinate with sign extension
.scope addYVelocity
  clc
  lda entityLocals+bat_locals::y_velocity,x
  adc entity_instances+entityRAM::positionYFine,x
  sta entity_instances+entityRAM::positionYFine,x
  lda entityLocals+bat_locals::y_velocity+1,x
  bmi signExtend
  adc entity_instances+entityRAM::positionY,x
  sta entity_instances+entityRAM::positionY,x
  lda #0
  adc entity_instances+entityRAM::positionY+1,x
  sta entity_instances+entityRAM::positionY+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entityRAM::positionY,x
  sta entity_instances+entityRAM::positionY,x
  lda #$ff
  adc entity_instances+entityRAM::positionY+1,x
  sta entity_instances+entityRAM::positionY+1,x
signExtendAddDone:
.endscope

  rts
  
bat_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killBat
  
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
