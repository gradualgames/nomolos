.ifndef PHOENIX_INC
PHOENIX_INC = 1

PHOENIX_WIDTH = $18
PHOENIX_HALFWIDTH = $0C
PHOENIX_HEIGHT = $28
PHOENIX_HALFHEIGHT = $14

.struct phoenix_locals
  x_velocity .word
  y_velocity .word
  anim_index .word
  fly_hover  .byte
  shoot_fireball .byte
  damaged_counter  .byte
  health           .byte
.endstruct

PHOENIX_INITSTATE = 0
PHOENIX_FLYSTATE = 1
PHOENIX_HOVERSTATE = 2

PHOENIX_TIME_TIL_STATE_SWITCH = 255
PHOENIX_TIME_TIL_SHOOT_FIREBALL = 20

PHOENIX_VERTSPEED = 10
PHOENIX_MAXVERTSPEED = 1
PHOENIX_HORIZSPEED = 10
PHOENIX_MAXHORIZSPEED = 4

.proc phoenix_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #PHOENIX_INITSTATE
  beq phoenix_initState
  cmp #PHOENIX_FLYSTATE
  beq phoenix_flyState
  cmp #PHOENIX_HOVERSTATE
  beq phoenix_hoverState

phoenix_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set x velocity to 0
  lda #0
  sta entity_locals+phoenix_locals::x_velocity,x
  sta entity_locals+phoenix_locals::x_velocity+1,x

  ;set y velocity to 0
  sta entity_locals+phoenix_locals::y_velocity,x
  sta entity_locals+phoenix_locals::y_velocity+1,x

  ;switch state to "fly"
  lda #PHOENIX_FLYSTATE
  sta entity_instances+entity_instance::state,x

  ;set fly_hover counter
  lda #PHOENIX_TIME_TIL_STATE_SWITCH
  sta entity_locals+phoenix_locals::fly_hover,x

  ;lda #PHOENIX_TIME_TIL_SHOOT_FIREBALL
  sta entity_locals+phoenix_locals::shoot_fireball,x

  ;set damaged counter to 0
  lda #0
  sta entity_locals+phoenix_locals::damaged_counter,x

  ;set health to 3
  lda #3
  sta entity_locals+phoenix_locals::health,x
  
  rts

phoenix_hoverState:

 .scope
  dec entity_locals+phoenix_locals::shoot_fireball,x
  bne do_not_shoot_fireball

  ;spawn an fireball entity
  lda #entity_index_fireball
  sta b0

  ;get out low byte of position_x
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #PHOENIX_HALFWIDTH
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sta b1

  jsr entity_spawn

  lda #PHOENIX_TIME_TIL_SHOOT_FIREBALL
  sta entity_locals+phoenix_locals::shoot_fireball,x

do_not_shoot_fireball:
 .endscope

  .scope
  dec entity_locals+phoenix_locals::fly_hover,x
  bne do_not_switch_state

  lda #PHOENIX_FLYSTATE
  sta entity_instances+entity_instance::state,x

  lda #PHOENIX_TIME_TIL_STATE_SWITCH
  sta entity_locals+phoenix_locals::fly_hover,x

  lda #0
  sta entity_locals+phoenix_locals::x_velocity,x
  sta entity_locals+phoenix_locals::x_velocity+1,x
  sta entity_locals+phoenix_locals::y_velocity,x
  sta entity_locals+phoenix_locals::y_velocity+1,x

do_not_switch_state:
  .endscope

  jsr entity_compute_screen_coordinates

  jsr phoenix_draw

  rts

phoenix_flyState:

  .scope
  dec entity_locals+phoenix_locals::fly_hover,x
  bne do_not_switch_state

  lda #PHOENIX_HOVERSTATE
  sta entity_instances+entity_instance::state,x

  lda #PHOENIX_TIME_TIL_STATE_SWITCH
  sta entity_locals+phoenix_locals::fly_hover,x

do_not_switch_state:
  .endscope

  jsr entity_compute_screen_coordinates

  ;add x velocity to 24 bit X coordinate with sign extension
.scope addXVelocity
  clc
  lda entity_locals+phoenix_locals::x_velocity,x
  adc entity_instances+entity_instance::position_x_fine,x
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_locals+phoenix_locals::x_velocity+1,x
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

  ;add y velocity to 24 bit Y coordinate with sign extension
.scope addYVelocity
  clc
  lda entity_locals+phoenix_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+phoenix_locals::y_velocity+1,x
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

  lda entity_screen_y
  sec
  sbc nomolos_screen_y
  lda entity_screen_y+1
  sbc nomolos_screen_y+1

  bmi followDown
followUp:

  ;subtract from y velocity
  lda entity_locals+phoenix_locals::y_velocity,x
  sec
  sbc #PHOENIX_VERTSPEED
  sta entity_locals+phoenix_locals::y_velocity,x
  lda entity_locals+phoenix_locals::y_velocity+1,x
  sbc #0
  sta entity_locals+phoenix_locals::y_velocity+1,x

  jmp followVertTestDone
followDown:

  ;add to y velocity
  lda entity_locals+phoenix_locals::y_velocity,x
  clc
  adc #PHOENIX_VERTSPEED
  sta entity_locals+phoenix_locals::y_velocity,x
  lda entity_locals+phoenix_locals::y_velocity+1,x
  adc #0
  sta entity_locals+phoenix_locals::y_velocity+1,x

followVertTestDone:

  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:

  ;subtract from x velocity
  lda entity_locals+phoenix_locals::x_velocity,x
  sec
  sbc #PHOENIX_HORIZSPEED
  sta entity_locals+phoenix_locals::x_velocity,x
  lda entity_locals+phoenix_locals::x_velocity+1,x
  sbc #0
  sta entity_locals+phoenix_locals::x_velocity+1,x

  jmp followTestDone
followToRight:

  ;add to x velocity
  lda entity_locals+phoenix_locals::x_velocity,x
  clc
  adc #PHOENIX_HORIZSPEED
  sta entity_locals+phoenix_locals::x_velocity,x
  lda entity_locals+phoenix_locals::x_velocity+1,x
  adc #0
  sta entity_locals+phoenix_locals::x_velocity+1,x

followTestDone:

  ;keep x and y velocity under control
  lda entity_locals+phoenix_locals::x_velocity+1,x  ;high byte is "pixel speed"
  bpl xVelocityPositive
xVelocityNegative:
.scope

  cmp #(-PHOENIX_MAXHORIZSPEED)
  bpl notMaxHoriz

  lda #(-PHOENIX_MAXHORIZSPEED)
  sta entity_locals+phoenix_locals::x_velocity+1,x

notMaxHoriz:
.endscope

  jmp xVelocityTestDone
xVelocityPositive:
.scope
  cmp #(PHOENIX_MAXHORIZSPEED)
  bmi notMaxHoriz

  lda #(PHOENIX_MAXHORIZSPEED)
  sta entity_locals+phoenix_locals::x_velocity+1,x

notMaxHoriz:
.endscope

xVelocityTestDone:

  ;keep x and y velocity under control
  lda entity_locals+phoenix_locals::y_velocity+1,x  ;high byte is "pixel speed"
  bpl yVelocityPositive
yVelocityNegative:
.scope

  cmp #(-PHOENIX_MAXVERTSPEED)
  bpl notMaxVert

  lda #(-PHOENIX_MAXVERTSPEED)
  sta entity_locals+phoenix_locals::y_velocity+1,x

notMaxVert:
.endscope

  jmp yVelocityTestDone
yVelocityPositive:
.scope
  cmp #(PHOENIX_MAXVERTSPEED)
  bmi notMaxVert

  lda #(PHOENIX_MAXVERTSPEED)
  sta entity_locals+phoenix_locals::y_velocity+1,x

notMaxVert:
.endscope

yVelocityTestDone:

  jsr phoenix_draw

  rts

kill_phoenix:

  ;make it dead
  jsr entity_kill

  ;spawn an explosion entity
  lda #entity_index_explosion
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

  jsr entity_spawn

  rts

phoenix_draw:

  jsr entity_test_death_zone
  beq kill_phoenix

  lda #<spritesheet1_PhoenixFly
  sta entity_locals+phoenix_locals::anim_index,x
  lda #>spritesheet1_PhoenixFly
  sta entity_locals+phoenix_locals::anim_index+1,x
  ;load phoenix width and height
  lda #PHOENIX_WIDTH
  sta b2
  lda #PHOENIX_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt
  lda #<spritesheet1_PhoenixFly
  sta entity_locals+phoenix_locals::anim_index,x
  lda #>spritesheet1_PhoenixFly
  sta entity_locals+phoenix_locals::anim_index+1,x

  jsr entity_reset_anim

:
  lda entity_locals+phoenix_locals::damaged_counter,x
  bne nomolosNotAttacking
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load phoenix width and height
  lda #PHOENIX_WIDTH
  sta b2
  lda #PHOENIX_HEIGHT
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

  ;set the damaged counter, this will make the entity flash
  lda #10
  sta entity_locals+phoenix_locals::damaged_counter,x
  
  ;decrement the entity's health
  dec entity_locals+phoenix_locals::health,x
  
  bne nomolosNotAttacking
  
  jmp kill_phoenix

nomolosNotAttacking:

  lda entity_locals+phoenix_locals::damaged_counter,x
  beq entity_not_flashing
  
  dec entity_locals+phoenix_locals::damaged_counter,x
  
entity_not_flashing:

  ldy #level_data_struct::phoenix_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda entity_locals+phoenix_locals::anim_index,x
  sta w2
  lda entity_locals+phoenix_locals::anim_index+1,x
  sta w2+1
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:
  ;make the entity flash by cycling through color attributes
  lda entity_locals+phoenix_locals::damaged_counter,x
  and #%00000011
  ;flip the sprite
  ora #%01000000
  sta b2
  jmp entity_facing_test_done
entity_facing_right:
  ;make the entity flash by cycling through color attributes
  lda entity_locals+phoenix_locals::damaged_counter,x
  and #%00000011
  ;do not flip the sprite
  sta b2
entity_facing_test_done:
  jsr entity_draw_anim

phoenixOffscreen:
  rts

.endproc

.endif
