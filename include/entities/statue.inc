.ifndef STATUE_INC
STATUE_INC = 1

STATUE_WIDTH = $10
STATUE_HEIGHT = $18

STATUE_INITSTATE = $00
STATUE_SITTHERESTATE = $01

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

statue_init:

  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #STATUE_HEIGHT
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  lda #STATUE_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  rts

statue_sit_there:

  jsr entity_compute_screen_coordinates

  jsr entity_item_test_death_zone
  beq statueDie

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

  ldy #level_data_struct::statue_offset
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

  jsr sprite_draw_metasprite_16bit

  rts

statueDie:

  jsr entity_kill
  rts

.endproc

.endif
