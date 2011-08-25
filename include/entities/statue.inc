.ifndef STATUE_INC
STATUE_INC = 1

.struct statue_locals
  y_velocity .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
.endstruct

STATUE_WIDTH = $10
STATUE_HALFWIDTH = $08
STATUE_HEIGHT = $28

STATUE_INITSTATE = $00
STATUE_SITTHERESTATE = $01
STATUE_JUMPSTATE = $02

STATUE_PROXIMITY_WIDTH = $30
STATUE_PROXIMITY_HEIGHT = $30
STATUE_PROXIMITY_ADJUST_X = $10
STATUE_PROXIMITY_ADJUST_Y = $10

.proc statue_update

  lda entity_instances+entity_instance::state,x
  cmp #STATUE_INITSTATE
  beq statue_init
  cmp #STATUE_SITTHERESTATE
  beq statue_sit_there
  cmp #STATUE_JUMPSTATE
  beq statue_jump

statue_init:

  jmp statue_init_handler

statue_sit_there:

  jmp statue_sit_there_handler

statue_jump:

  jmp statue_jump_handler

statue_init_handler:
  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #(STATUE_HEIGHT-$10)
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  lda #STATUE_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  rts

statue_jump_handler:

  ;increment the vertical velocity
  lda entity_locals+statue_locals::y_velocity+1,x
  cmp #10
  bpl stopAccelerating
  clc
  lda entity_locals+statue_locals::y_velocity,x
  adc #$40
  sta entity_locals+statue_locals::y_velocity,x
  lda entity_locals+statue_locals::y_velocity+1,x
  adc #0
  sta entity_locals+statue_locals::y_velocity+1,x
stopAccelerating:

  ;add vertical velocity to 24 bit Y coordinate with sign extension
  clc
  lda entity_locals+statue_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+statue_locals::y_velocity+1,x
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

  ;perform collision detection and eject if necessary
  ;load the entity's X coordinate + 8
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #STATUE_HALFWIDTH
  sta entity_locals+statue_locals::x_collisionPointBottom,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_locals+statue_locals::x_collisionPointBottom+1,x
  sta w0+1
  ;load the entity's Y coordinate + height
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #STATUE_HEIGHT
  sta entity_locals+statue_locals::y_collisionPointBottom,x
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_locals+statue_locals::y_collisionPointBottom+1,x
  sta w1+1

  jsr map_test_collision
  lda b1
  beq noBottomCollision

  lda #0
  sta entity_locals+statue_locals::y_velocity,x
  sta entity_locals+statue_locals::y_velocity+1,x

  ;there was a collision beneath the entity. calculate penetration distance and eject.
  lda entity_locals+statue_locals::y_collisionPointBottom,x
  and #penetration_calculation_mask
  sta entity_locals+statue_locals::y_belowPenetration,x
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc entity_locals+statue_locals::y_belowPenetration,x
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x
  
  ;switch to sit there state
  lda #STATUE_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

noBottomCollision:

  jsr entity_compute_screen_coordinates

  jsr statue_draw

  rts

statue_sit_there_handler:

  jsr entity_compute_screen_coordinates

  jsr entity_item_test_death_zone
  beq statueDie

  ;compare Nomolos's X coordinate to the entity's X coordinate

  ;load left side of line A
  lda nomolos_screen_x
  sta b2
  ;load right side of line A
  clc
  adc #nomolos_width
  sta b3

  ;load left side of line B
  lda entity_screen_x
  sta b4
  ;load right side of line B
  clc
  adc #STATUE_WIDTH
  sta b5

  jsr geotests_compare_range

  bne do_not_switch_to_jump_state

  ;initialize the jump state
  lda #$0a
  sta entity_locals+statue_locals::y_velocity,x
  lda #$fa
  sta entity_locals+statue_locals::y_velocity+1,x

  lda #STATUE_JUMPSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_jump_state:

  jsr statue_draw

  rts

statueDie:

  jsr entity_kill

  ;spawn an explosion entity
  lda #entity_index_explosionspawner
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
  lda entity_instances+entity_instance::position_y+1,x
  sta b2

  jsr entity_spawn

  rts

statue_draw:

  ;transfer rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_screen_x
  sta w2
  lda entity_screen_x+1
  sta w2+1
  lda entity_screen_y
  sta w3
  lda entity_screen_y+1
  sta w3+1
  lda #STATUE_PROXIMITY_WIDTH
  sta b2
  lda #STATUE_PROXIMITY_HEIGHT
  sta b3

  ;adjust top left of rectangle
  sec
  lda w2
  sbc #STATUE_PROXIMITY_ADJUST_X
  sta w2
  lda w2+1
  sbc #0
  sta w2+1
  
  sec
  lda w3
  sbc #STATUE_PROXIMITY_ADJUST_Y
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
  
  beq draw_eyes_shut
  bne draw_eyes_open

draw_eyes_open:

  lda #<spritesheet2_statue0
  sta w0
  lda #>spritesheet2_statue0
  sta w0+1
  jmp proximity_test_done

draw_eyes_shut:

  lda #<spritesheet2_statue1
  sta w0
  lda #>spritesheet2_statue1
  sta w0+1

proximity_test_done:

  lda entity_chr_offsets+(entity_index_statue-1)
  sta sprite_group_offset

  lda #0
  sta b2
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  ;load statue width and height
  lda #STATUE_WIDTH
  sta b2
  lda #STATUE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load statue width and height
  lda #STATUE_WIDTH
  sta b2
  lda #STATUE_HEIGHT
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

  jmp statueDie

nomolosNotAttacking:

  rts

.endproc

.endif
