.ifndef GRUBSELIMBOJ_INC
GRUBSELIMBOJ_INC = 1

GRUBSELIMBOJ_WIDTH = $20
GRUBSELIMBOJ_HEIGHT = $10

.struct grubselimboj_locals
  x_velocity .word
  y_velocity .word
.endstruct

GRUBSELIMBOJ_INITSTATE = 0
GRUBSELIMBOJ_FLYSTATE = 1

GRUBSELIMBOJ_VERTSPEED = 10
GRUBSELIMBOJ_MAXVERTSPEED = 2
GRUBSELIMBOJ_HORIZSPEED = 10
GRUBSELIMBOJ_MAXHORIZSPEED = 3

.proc grubselimboj_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #GRUBSELIMBOJ_INITSTATE
  beq grubselimboj_initState
  cmp #GRUBSELIMBOJ_FLYSTATE
  beq grubselimboj_flyState

grubselimboj_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set x velocity to 0
  lda #0
  sta entity_locals+grubselimboj_locals::x_velocity,x
  sta entity_locals+grubselimboj_locals::x_velocity+1,x

  ;set y velocity to 0
  sta entity_locals+grubselimboj_locals::y_velocity,x
  sta entity_locals+grubselimboj_locals::y_velocity+1,x

  ;switch state to "fly"
  lda #GRUBSELIMBOJ_FLYSTATE
  sta entity_instances+entity_instance::state,x
  rts

grubselimboj_flyState:

  jsr entity_compute_screen_coordinates

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

  rts

grubselimboj_draw:

  jsr entity_test_death_zone
  beq killGrubselimBoj

  ;load grubselimboj width and height
  lda #GRUBSELIMBOJ_WIDTH
  sta b2
  lda #GRUBSELIMBOJ_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load grubselimboj width and height
  lda #GRUBSELIMBOJ_WIDTH
  sta b2
  lda #GRUBSELIMBOJ_HEIGHT
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

  jmp killGrubselimBoj

nomolosNotAttacking:

  ldy #level_data_struct::grubselimboj_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda #<spritesheet1_GrubselimBojEyes0
  sta w0
  lda #>spritesheet1_GrubselimBojEyes0
  sta w0+1

  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  lda #0
  sta b2

  jsr sprite_draw_metasprite_16bit

grubselimbojOffscreen:
  rts

killGrubselimBoj:

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
.endproc

.endif
