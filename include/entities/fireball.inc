.ifndef FIREBALL_INC
FIREBALL_INC = 1

.proc fireball_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #FIREBALL_INITSTATE
  beq fireball_initState
  cmp #FIREBALL_JUMPSTATE
  beq fireball_jumpState

fireball_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim
  
  ;set vertical velocity
  lda #$0a
  sta entity_locals+fireball_locals::y_velocity,x
  lda #$fd
  sta entity_locals+fireball_locals::y_velocity+1,x
  
  ;compute screen coordinates, decide which direction to go
  jsr entity_compute_screen_coordinates
  
  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:
  ;set x velocity
  lda #$00
  sta entity_locals+fireball_locals::x_velocity,x
  lda #$ff
  sta entity_locals+fireball_locals::x_velocity+1,x

  jmp followTestDone
followToRight:
  ;set x velocity
  lda #$00
  sta entity_locals+fireball_locals::x_velocity,x
  lda #$01
  sta entity_locals+fireball_locals::x_velocity+1,x
followTestDone:
  
  ;switch state to "jump"
  lda #FIREBALL_JUMPSTATE
  sta entity_instances+entity_instance::state,x
  rts

fireball_jumpState:

  jsr entity_compute_screen_coordinates

  ;increment the vertical velocity
  lda entity_locals+fireball_locals::y_velocity+1,x
  cmp #10
  bpl stopAccelerating
  clc
  lda entity_locals+fireball_locals::y_velocity,x
  adc #$20
  sta entity_locals+fireball_locals::y_velocity,x
  lda entity_locals+fireball_locals::y_velocity+1,x
  adc #0
  sta entity_locals+fireball_locals::y_velocity+1,x
stopAccelerating:

  ;add vertical velocity to 24 bit X coordinate with sign extension
  .scope
  clc
  lda entity_locals+fireball_locals::x_velocity,x
  adc entity_instances+entity_instance::position_x_fine,x
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_locals+fireball_locals::x_velocity+1,x
  bmi signExtend
  adc entity_instances+entity_instance::position_x,x
  sta entity_instances+entity_instance::position_x,x
  lda #0
  adc entity_instances+entity_instance::position_x+1,x
  sta entity_instances+entity_instance::position_x+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entity_instance::position_x,x
  sta entity_instances+entity_instance::position_x,x
  lda #$ff
  adc entity_instances+entity_instance::position_x+1,x
  sta entity_instances+entity_instance::position_x+1,x
signExtendAddDone:
  .endscope

  ;add vertical velocity to 24 bit Y coordinate with sign extension
  .scope
  clc
  lda entity_locals+fireball_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+fireball_locals::y_velocity+1,x
  bmi signExtend
  adc entity_instances+entity_instance::position_y,x
  sta entity_instances+entity_instance::position_y,x
  lda #0
  adc entity_instances+entity_instance::position_y+1,x
  sta entity_instances+entity_instance::position_y+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entity_instance::position_y,x
  sta entity_instances+entity_instance::position_y,x
  lda #$ff
  adc entity_instances+entity_instance::position_y+1,x
  sta entity_instances+entity_instance::position_y+1,x
signExtendAddDone:
  .endscope

  jsr fireball_draw

  rts

fireball_draw:

  jsr entity_test_death_zone
  beq kill_fireball
  
  lda entity_instances+entity_instance::position_y+1,x
  bne kill_fireball

  ;load fireball width and height
  lda #FIREBALL_WIDTH
  sta b2
  lda #FIREBALL_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

nomolosNotAttacking:

  ldy #level_data_struct::fireball_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda #<spritesheet1_FireballFly
  sta w2
  lda #>spritesheet1_FireballFly
  sta w2+1
  lda #0
  sta b2
  jsr entity_draw_anim

fireballOffscreen:
  rts

kill_fireball:

  ;make it dead
  jsr entity_kill

  rts
.endproc

.endif
