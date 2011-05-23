.ifndef STATUE_INC
STATUE_INC = 1

STATUE_WIDTH = $10
STATUE_HEIGHT = $18

STATUE_INITSTATE = $00
STATUE_SITTHERESTATE = $01

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

  ldy #level_data_struct::statue_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda #<spritesheet2_statue0
  sta w0
  lda #>spritesheet2_statue0
  sta w0+1

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
