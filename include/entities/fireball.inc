.ifndef FIREBALL_INC
FIREBALL_INC = 1

.struct fireball_locals
  x_velocity .word
  y_velocity .word
.endstruct

FIREBALL_WIDTH = $10
FIREBALL_HEIGHT = $10

FIREBALL_INITSTATE = 0
FIREBALL_FLYSTATE = 1

fireball_update:

  lda entity_instances+entity_instance::state,x
  cmp #FIREBALL_INITSTATE
  beq fireball_init
  cmp #FIREBALL_FLYSTATE
  beq fireball_fly

fireball_init:

  ;reset the fireball animation object
  jsr entity_reset_anim

  ;set state to fly
  lda #FIREBALL_FLYSTATE
  sta entity_instances+entity_instance::state,x

  ;compare entity x position to nomolos x position to decide direction
  .scope
  sec
  lda nomolos_map_x+1
  sbc entity_instances+entity_instance::position_x,x
  lda nomolos_map_x+2
  sbc entity_instances+entity_instance::position_x+1,x
  bpl will_go_right
will_go_left:
  lda #$ff
  sta entity_locals+fireball_locals::x_velocity,x
  sta entity_locals+fireball_locals::x_velocity+1,x
  jmp direction_test_done
will_go_right:
  lda #$01
  sta entity_locals+fireball_locals::x_velocity,x
  lda #$00
  sta entity_locals+fireball_locals::x_velocity+1,x
direction_test_done:
  .endscope

  .scope
  sec
  lda nomolos_map_y+1
  sbc entity_instances+entity_instance::position_y,x
  lda nomolos_map_y+2
  sbc entity_instances+entity_instance::position_y+1,x
  bpl will_go_up
will_go_down:
  lda #$ff
  sta entity_locals+fireball_locals::y_velocity,x
  sta entity_locals+fireball_locals::y_velocity+1,x
  jmp direction_test_done
will_go_up:
  lda #$01
  sta entity_locals+fireball_locals::y_velocity,x
  lda #$00
  sta entity_locals+fireball_locals::y_velocity+1,x
direction_test_done:
  .endscope

  rts

fireball_fly:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq fireballDie

  ;load width and height
  lda #FIREBALL_WIDTH
  sta b2
  lda #FIREBALL_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  clc
  lda entity_instances+entity_instance::position_x,x
  adc entity_locals+fireball_locals::x_velocity,x
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc entity_locals+fireball_locals::x_velocity+1,x
  sta entity_instances+entity_instance::position_x+1,x

  clc
  lda entity_instances+entity_instance::position_y,x
  adc entity_locals+fireball_locals::y_velocity,x
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc entity_locals+fireball_locals::y_velocity+1,x
  sta entity_instances+entity_instance::position_y+1,x

  ldy #level_data_struct::fireball_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda #<spritesheet1_FireballFly
  sta w2
  lda #>spritesheet1_FireballFly
  sta w2+1
  jsr entity_draw_anim

  lda entity_instances+entity_instance::animation_object+1,x

  rts

fireballDie:

  jsr entity_kill

  rts

.endif