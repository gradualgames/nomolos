.ifndef GRUBSELIMBOJ_INC
GRUBSELIMBOJ_INC = 1

GRUBSELIMBOJ_WIDTH = $20
GRUBSELIMBOJ_HEIGHT = $20

GRUBSELIMBOJ_PROXIMITY_WIDTH = $60
GRUBSELIMBOJ_PROXIMITY_HEIGHT = $60
GRUBSELIMBOJ_PROXIMITY_ADJUST_X = $20
GRUBSELIMBOJ_PROXIMITY_ADJUST_Y = $20

.struct grubselimboj_locals
  x_velocity .word
  y_velocity .word
  counter    .word
  health .byte
  damaged_counter .byte
.endstruct

GRUBSELIMBOJ_INITSTATE = 0
GRUBSELIMBOJ_FLYSTATE = 1
GRUBSELIMBOJ_RETURNINGSTATE = 2
GRUBSELIMBOJ_STATIONARYSTATE = 3
GRUBSELIMBOJ_DYINGSTATE = 4

GRUBSELIMBOJ_VERTSPEED = 10
GRUBSELIMBOJ_MAXVERTSPEED = 2
GRUBSELIMBOJ_HORIZSPEED = 10
GRUBSELIMBOJ_MAXHORIZSPEED = 3

GOAL_X = 160
GOAL_Y = 80

.proc grubselimboj_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #GRUBSELIMBOJ_INITSTATE
  beq grubselimboj_initState
  cmp #GRUBSELIMBOJ_FLYSTATE
  beq grubselimboj_flyState
  cmp #GRUBSELIMBOJ_RETURNINGSTATE
  beq grubselimboj_returningState
  cmp #GRUBSELIMBOJ_STATIONARYSTATE
  beq grubselimboj_stationaryState
  cmp #GRUBSELIMBOJ_DYINGSTATE
  beq grubselimboj_dyingState

grubselimboj_initState:

  jmp grubselimboj_initState_handler

grubselimboj_dyingState:

  jmp grubselimboj_dyingState_handler
  
grubselimboj_stationaryState:

  ;spawn a grank every once in a while
  lda entity_locals+grubselimboj_locals::counter,x
  and #%00111111
  bne do_not_spawn_grank
  
  ;spawn an entity
  lda #entity_index_grank
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

do_not_spawn_grank:

  ;spawn a fireball every once in a while
  .scope
  lda entity_locals+grubselimboj_locals::counter,x
  and #%01111111
  bne do_not_spawn_fireball
  
  ;spawn an entity
  lda #entity_index_bigfireball
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

do_not_spawn_fireball:
  .endscope

  sec
  lda entity_locals+grubselimboj_locals::counter,x
  sbc #1
  sta entity_locals+grubselimboj_locals::counter,x
  lda entity_locals+grubselimboj_locals::counter+1,x
  sbc #0
  sta entity_locals+grubselimboj_locals::counter+1,x

  bne do_not_switch_to_fly_state
  ;set counter to something
  lda #$ff
  sta entity_locals+grubselimboj_locals::counter,x
  lda #$03
  sta entity_locals+grubselimboj_locals::counter+1,x
  lda #GRUBSELIMBOJ_FLYSTATE
  sta entity_instances+entity_instance::state,x
do_not_switch_to_fly_state:

  jsr entity_compute_screen_coordinates

  jsr grubselimboj_draw

  rts
  
grubselimboj_returningState:

  jmp grubselimboj_returningState_handler
  
grubselimboj_flyState:

  jsr entity_compute_screen_coordinates

  jsr grubselimboj_addvelocity

  lda entity_screen_y
  sec
  sbc nomolos_screen_y
  lda entity_screen_y+1
  sbc nomolos_screen_y+1

  bmi followDown
followUp:

  ;subtract from y velocity
  lda entity_locals+grubselimboj_locals::y_velocity,x
  sec
  sbc #GRUBSELIMBOJ_VERTSPEED
  sta entity_locals+grubselimboj_locals::y_velocity,x
  lda entity_locals+grubselimboj_locals::y_velocity+1,x
  sbc #0
  sta entity_locals+grubselimboj_locals::y_velocity+1,x

  jmp followVertTestDone
followDown:

  ;add to y velocity
  lda entity_locals+grubselimboj_locals::y_velocity,x
  clc
  adc #GRUBSELIMBOJ_VERTSPEED
  sta entity_locals+grubselimboj_locals::y_velocity,x
  lda entity_locals+grubselimboj_locals::y_velocity+1,x
  adc #0
  sta entity_locals+grubselimboj_locals::y_velocity+1,x

followVertTestDone:

  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:

  ;subtract from x velocity
  lda entity_locals+grubselimboj_locals::x_velocity,x
  sec
  sbc #GRUBSELIMBOJ_HORIZSPEED
  sta entity_locals+grubselimboj_locals::x_velocity,x
  lda entity_locals+grubselimboj_locals::x_velocity+1,x
  sbc #0
  sta entity_locals+grubselimboj_locals::x_velocity+1,x

  jmp followTestDone
followToRight:

  ;add to x velocity
  lda entity_locals+grubselimboj_locals::x_velocity,x
  clc
  adc #GRUBSELIMBOJ_HORIZSPEED
  sta entity_locals+grubselimboj_locals::x_velocity,x
  lda entity_locals+grubselimboj_locals::x_velocity+1,x
  adc #0
  sta entity_locals+grubselimboj_locals::x_velocity+1,x

followTestDone:

  ;keep x and y velocity under control
  lda entity_locals+grubselimboj_locals::x_velocity+1,x  ;high byte is "pixel speed"
  bpl xVelocityPositive
xVelocityNegative:
.scope

  cmp #(-GRUBSELIMBOJ_MAXHORIZSPEED)
  bpl notMaxHoriz

  lda #(-GRUBSELIMBOJ_MAXHORIZSPEED)
  sta entity_locals+grubselimboj_locals::x_velocity+1,x

notMaxHoriz:
.endscope

  jmp xVelocityTestDone
xVelocityPositive:
.scope
  cmp #(GRUBSELIMBOJ_MAXHORIZSPEED)
  bmi notMaxHoriz

  lda #(GRUBSELIMBOJ_MAXHORIZSPEED)
  sta entity_locals+grubselimboj_locals::x_velocity+1,x

notMaxHoriz:
.endscope

xVelocityTestDone:

  ;keep x and y velocity under control
  lda entity_locals+grubselimboj_locals::y_velocity+1,x  ;high byte is "pixel speed"
  bpl yVelocityPositive
yVelocityNegative:
.scope

  cmp #(-GRUBSELIMBOJ_MAXVERTSPEED)
  bpl notMaxVert

  lda #(-GRUBSELIMBOJ_MAXVERTSPEED)
  sta entity_locals+grubselimboj_locals::y_velocity+1,x

notMaxVert:
.endscope

  jmp yVelocityTestDone
yVelocityPositive:
.scope
  cmp #(GRUBSELIMBOJ_MAXVERTSPEED)
  bmi notMaxVert

  lda #(GRUBSELIMBOJ_MAXVERTSPEED)
  sta entity_locals+grubselimboj_locals::y_velocity+1,x

notMaxVert:
.endscope

yVelocityTestDone:

  jsr grubselimboj_draw

  sec
  lda entity_locals+grubselimboj_locals::counter,x
  sbc #1
  sta entity_locals+grubselimboj_locals::counter,x
  lda entity_locals+grubselimboj_locals::counter+1,x
  sbc #0
  sta entity_locals+grubselimboj_locals::counter+1,x
  bne do_not_switch_to_returning_state
  lda #GRUBSELIMBOJ_RETURNINGSTATE
  sta entity_instances+entity_instance::state,x
do_not_switch_to_returning_state:
  
  ;spawn a fireball every once in a while
  .scope
  lda entity_locals+grubselimboj_locals::counter,x
  and #%01111111
  bne do_not_spawn_fireball
  
  ;spawn an entity
  lda #entity_index_bigfireball
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

do_not_spawn_fireball:
  .endscope
  
  rts

killGrubselimBoj:

  jsr play_level_state_init_victory_mode

  ;make it dead
  jsr entity_kill

  ;kill all other entities
  jsr entity_init_all

  rts
  
grubselimboj_dyingState_handler:

  jsr entity_compute_screen_coordinates
  
  jsr grubselimboj_draw

  dec entity_locals+grubselimboj_locals::counter,x
  beq killGrubselimBoj
  
  lda entity_locals+grubselimboj_locals::counter,x
  and #%00000010
  sta camera_scroll_x
  
  lda entity_locals+grubselimboj_locals::counter,x
  and #%00000011
  bne skip_spawn_explosion
  
  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ldy #10
  jsr entity_get_next_prn
  
  and #%00001111
  sta b3
  
  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  clc
  adc b3
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ldy #10
  jsr entity_get_next_prn
  
  and #%00001111
  sta b3
  
  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  clc
  adc b3
  sta b1

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
skip_spawn_explosion:

  rts
  
grubselimboj_initState_handler:
  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;initial location overrides the spawn location
  lda #<GOAL_X
  sta entity_instances+entity_instance::position_x,x
  lda #>GOAL_X
  sta entity_instances+entity_instance::position_x+1,x
  lda #<GOAL_Y
  sta entity_instances+entity_instance::position_y,x
  lda #>GOAL_Y
  sta entity_instances+entity_instance::position_y+1,x
  
  ;initial health
  lda #10
  sta entity_locals+grubselimboj_locals::health,x
  
  ;initial damaged counter
  lda #0
  sta entity_locals+grubselimboj_locals::damaged_counter,x
  
  ;set x velocity to 0
  lda #0
  sta entity_locals+grubselimboj_locals::x_velocity,x
  sta entity_locals+grubselimboj_locals::x_velocity+1,x

  ;set y velocity to 0
  sta entity_locals+grubselimboj_locals::y_velocity,x
  sta entity_locals+grubselimboj_locals::y_velocity+1,x

  ;set counter to something
  lda #$ff
  sta entity_locals+grubselimboj_locals::counter,x
  lda #$03
  sta entity_locals+grubselimboj_locals::counter+1,x
  
  ;switch state to "stationary"
  lda #GRUBSELIMBOJ_STATIONARYSTATE
  sta entity_instances+entity_instance::state,x
  rts
  
;this state causes the Grubselim Boj face to return to its
;"home position" on the volcano. He'll start out fast but
;slow down as he reaches GOAL_X and GOAL_Y. This is
;accomplished by calculating the distance on X and Y and
;using this value as a velocity on the fractional part of
;X and Y. To make it look reasonable we shift it left to
;make this process a little faster.
grubselimboj_returningState_handler:

  ;calculate distance between "goal" and X coordinate
  sec
  lda #<GOAL_X
  sbc entity_instances+entity_instance::position_x,x
  sta entity_locals+grubselimboj_locals::x_velocity,x
  lda #>GOAL_X
  sbc entity_instances+entity_instance::position_x+1,x
  sta entity_locals+grubselimboj_locals::x_velocity+1,x
  
  ;do an 16 bit arithmetic left shift on this value
  asl entity_locals+grubselimboj_locals::x_velocity,x
  rol entity_locals+grubselimboj_locals::x_velocity+1,x
  asl entity_locals+grubselimboj_locals::x_velocity,x
  rol entity_locals+grubselimboj_locals::x_velocity+1,x
  
  ;calculate distance between "goal" and Y coordinate
  sec
  lda #<GOAL_Y
  sbc entity_instances+entity_instance::position_y,x
  sta entity_locals+grubselimboj_locals::y_velocity,x
  lda #>GOAL_Y
  sbc entity_instances+entity_instance::position_y+1,x
  sta entity_locals+grubselimboj_locals::y_velocity+1,x
  
  ;do an 16 bit arithmetic left shift on this value
  asl entity_locals+grubselimboj_locals::y_velocity,x
  rol entity_locals+grubselimboj_locals::y_velocity+1,x
  asl entity_locals+grubselimboj_locals::y_velocity,x
  rol entity_locals+grubselimboj_locals::y_velocity+1,x
  
  jsr grubselimboj_addvelocity
  
  jsr entity_compute_screen_coordinates

  jsr grubselimboj_draw
  
  lda entity_locals+grubselimboj_locals::x_velocity,x
  ora entity_locals+grubselimboj_locals::x_velocity+1,x
  ora entity_locals+grubselimboj_locals::y_velocity,x
  ora entity_locals+grubselimboj_locals::y_velocity+1,x
  bne not_at_goal
  
  ;set counter to something
  lda #$ff
  sta entity_locals+grubselimboj_locals::counter,x
  lda #$03
  sta entity_locals+grubselimboj_locals::counter+1,x
  
  lda #GRUBSELIMBOJ_STATIONARYSTATE
  sta entity_instances+entity_instance::state,x
  
not_at_goal:

  rts

grubselimboj_addvelocity:

  ;add x velocity to 24 bit X coordinate with sign extension
.scope addXVelocity
  clc
  lda entity_locals+grubselimboj_locals::x_velocity,x
  adc entity_instances+entity_instance::position_x_fine,x
  sta entity_instances+entity_instance::position_x_fine,x
  lda entity_locals+grubselimboj_locals::x_velocity+1,x
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
  lda entity_locals+grubselimboj_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+grubselimboj_locals::y_velocity+1,x
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

  rts
  
grubselimboj_draw:

  ;load grubselimboj width and height
  lda #GRUBSELIMBOJ_WIDTH
  sta b2
  lda #GRUBSELIMBOJ_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  ;only check for a hit if the damaged counter is all the way down
  lda entity_locals+grubselimboj_locals::damaged_counter,x
  bne damaged_counter_not_zero
  
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load grubselimboj width and height
  lda #GRUBSELIMBOJ_WIDTH
  sta b2
  lda #GRUBSELIMBOJ_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox

  bne nomolosNotAttacking

  ;set damaged counter
  lda #20
  sta entity_locals+grubselimboj_locals::damaged_counter,x
  
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

  dec entity_locals+grubselimboj_locals::health,x
  bne health_not_zero
  
  ;make Nomolos invincible the instant we transition into dying state
  lda nomolos_state_primary
  ora #nomolos_invincibility_on_set
  sta nomolos_state_primary
  lda #0
  ;ensure that the invincibility blinking counter is already zero so it does not
  ;reset invincibility to "off" after boss has already started dying
  sta nomolos_counter_temp_invincibility_blink
  
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif
  
  lda #$ff
  sta entity_locals+grubselimboj_locals::counter,x
  
  lda #GRUBSELIMBOJ_DYINGSTATE
  sta entity_instances+entity_instance::state,x
  
health_not_zero:
nomolosNotAttacking:
damaged_counter_not_zero:

  lda entity_locals+grubselimboj_locals::damaged_counter,x
  beq entity_not_flashing
  
  dec entity_locals+grubselimboj_locals::damaged_counter,x
  
entity_not_flashing:

  ldy #level_data_struct::grubselimboj_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  lda #%00000000
  sta b2
  
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:

  lda #<spritesheet1_GrubselimBojEyes1
  sta w0
  lda #>spritesheet1_GrubselimBojEyes1
  sta w0+1

  lda entity_locals+grubselimboj_locals::damaged_counter,x
  and #%00000011
  sta b2
  
  jsr sprite_draw_metasprite_16bit
  
  jsr grubselimboj_draw_mouth

  jmp entity_facing_test_done
entity_facing_right:

  lda #<spritesheet1_GrubselimBojEyes0
  sta w0
  lda #>spritesheet1_GrubselimBojEyes0
  sta w0+1

  lda entity_locals+grubselimboj_locals::damaged_counter,x
  and #%00000011
  sta b2
  
  jsr sprite_draw_metasprite_16bit

  jsr grubselimboj_draw_mouth

entity_facing_test_done:

grubselimbojOffscreen:
  rts
  
grubselimboj_draw_mouth:

  ;transfer rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_screen_x
  sta w2
  lda entity_screen_x+1
  sta w2+1
  lda entity_screen_y
  sta w3
  lda entity_screen_y+1
  sta w3+1
  lda #GRUBSELIMBOJ_PROXIMITY_WIDTH
  sta b2
  lda #GRUBSELIMBOJ_PROXIMITY_HEIGHT
  sta b3

  ;adjust top left of rectangle
  sec
  lda w2
  sbc #GRUBSELIMBOJ_PROXIMITY_ADJUST_X
  sta w2
  lda w2+1
  sbc #0
  sta w2+1
  
  sec
  lda w3
  sbc #GRUBSELIMBOJ_PROXIMITY_ADJUST_Y
  sta w3
  lda w3+1
  sbc #0
  sta w3+1
  
  ;transfer Nomolos rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolos_screen_x
  sta w4
  lda nomolos_screen_x+1
  sta w4+1
  lda nomolos_screen_y
  sta w5
  lda nomolos_screen_y+1
  sta w5+1
  lda #nomolos_width
  sta b4
  lda #nomolos_height
  sta b5

  jsr geotests_rect_in_rect_16bit
  
  beq draw_mouth_open
  bne draw_mouth_closed
  
  ;zero flag set means there was a collision
draw_mouth_open:
  
  lda #<spritesheet1_GrubselimBojMouth0
  sta w0
  lda #>spritesheet1_GrubselimBojMouth0
  sta w0+1

  ;get parameters ready for drawing mouth
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  lda entity_locals+grubselimboj_locals::damaged_counter,x
  and #%00000011
  sta b2
  
  jsr sprite_draw_metasprite_16bit
  
  rts
  
draw_mouth_closed:

  lda #<spritesheet1_GrubselimBojMouth1
  sta w0
  lda #>spritesheet1_GrubselimBojMouth1
  sta w0+1

  ;get parameters ready for drawing mouth
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  lda entity_locals+grubselimboj_locals::damaged_counter,x
  and #%00000011
  sta b2
  
  jsr sprite_draw_metasprite_16bit

  rts
  
.endproc

.endif
