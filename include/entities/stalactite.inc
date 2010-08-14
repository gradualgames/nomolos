.ifndef STALACTITE_INC
STALACTITE_INC = 1

.struct stalactite_locals
  x_velocity .word
  y_velocity .word
.endstruct

STALACTITE_WIDTH = $10
STALACTITE_HEIGHT = $10

STALACTITE_INITSTATE = 0
STALACTITE_FALLSTATE = 1

stalactite_update:

  lda entity_instances+entity_instance::state,x
  cmp #STALACTITE_INITSTATE
  beq stalactite_init
  cmp #STALACTITE_FALLSTATE
  beq stalactite_fall

stalactite_init:

  ;reset the stalactite animation object
  jsr entity_reset_anim

  lda #0
  sta entity_locals+stalactite_locals::x_velocity,x
  sta entity_locals+stalactite_locals::x_velocity+1,x
  lda #2
  sta entity_locals+stalactite_locals::y_velocity,x
  lda #0
  sta entity_locals+stalactite_locals::y_velocity+1,x
  
  ;set state to fall
  lda #STALACTITE_FALLSTATE
  sta entity_instances+entity_instance::state,x

  rts

stalactite_fall:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq stalactiteDie

  ;load width and height
  lda #STALACTITE_WIDTH
  sta b2
  lda #STALACTITE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  clc
  lda entity_instances+entity_instance::positionX,x
  adc entity_locals+stalactite_locals::x_velocity,x
  sta entity_instances+entity_instance::positionX,x
  lda entity_instances+entity_instance::positionX+1,x
  adc entity_locals+stalactite_locals::x_velocity+1,x
  sta entity_instances+entity_instance::positionX+1,x

  clc
  lda entity_instances+entity_instance::positionY,x
  adc entity_locals+stalactite_locals::y_velocity,x
  sta entity_instances+entity_instance::positionY,x
  lda entity_instances+entity_instance::positionY+1,x
  adc entity_locals+stalactite_locals::y_velocity+1,x
  sta entity_instances+entity_instance::positionY+1,x

  ldy #level_data_struct::stalactite_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::stalactite_fall
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
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

stalactiteDie:

  jsr entity_kill

  rts

.endif