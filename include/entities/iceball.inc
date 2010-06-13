.ifndef ICEBALL_INC
ICEBALL_INC = 1

.struct iceball_locals
  x_velocity .word
  y_velocity .word
.endstruct

ICEBALL_WIDTH = $10
ICEBALL_HEIGHT = $10

ICEBALL_INITSTATE = 0
ICEBALL_FLYSTATE = 1

iceball_update:

  lda entity_instances+entityRAM::state,x
  cmp #ICEBALL_INITSTATE
  beq iceball_init
  cmp #ICEBALL_FLYSTATE
  beq iceball_fly
  
iceball_init:

  ;reset the iceball animation object
  jsr entity_reset_anim
  
  ;set state to fly
  lda #ICEBALL_FLYSTATE
  sta entity_instances+entityRAM::state,x
  
  ;compare entity x position to nomolos x position to decide direction
  .scope
  sec
  lda nomolos_map_x+1
  sbc entity_instances+entityRAM::positionX,x
  lda nomolos_map_x+2
  sbc entity_instances+entityRAM::positionX+1,x
  bpl will_go_right
will_go_left:
  lda #$ff
  sta entity_locals+iceball_locals::x_velocity,x
  sta entity_locals+iceball_locals::x_velocity+1,x
  jmp direction_test_done
will_go_right:
  lda #$01
  sta entity_locals+iceball_locals::x_velocity,x
  lda #$00
  sta entity_locals+iceball_locals::x_velocity+1,x
direction_test_done:
  .endscope

  .scope
  sec
  lda nomolos_map_y+1
  sbc entity_instances+entityRAM::positionY,x
  lda nomolos_map_y+2
  sbc entity_instances+entityRAM::positionY+1,x
  bpl will_go_up
will_go_down:
  lda #$ff
  sta entity_locals+iceball_locals::y_velocity,x
  sta entity_locals+iceball_locals::y_velocity+1,x
  jmp direction_test_done
will_go_up:
  lda #$01
  sta entity_locals+iceball_locals::y_velocity,x
  lda #$00
  sta entity_locals+iceball_locals::y_velocity+1,x
direction_test_done:
  .endscope
  
  rts
  
iceball_fly:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq iceballDie
  
  ;load width and height
  lda #ICEBALL_WIDTH
  sta b2
  lda #ICEBALL_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
:
  
  clc
  lda entity_instances+entityRAM::positionX,x
  adc entity_locals+iceball_locals::x_velocity,x
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  adc entity_locals+iceball_locals::x_velocity+1,x
  sta entity_instances+entityRAM::positionX+1,x
  
  clc
  lda entity_instances+entityRAM::positionY,x
  adc entity_locals+iceball_locals::y_velocity,x
  sta entity_instances+entityRAM::positionY,x
  lda entity_instances+entityRAM::positionY+1,x
  adc entity_locals+iceball_locals::y_velocity+1,x
  sta entity_instances+entityRAM::positionY+1,x
  
  ldy #ROMDefinitionTableStruct::IceBallOffset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset
  
  ldy #ROMDefinitionTableStruct::IceBallFly
  jsr entity_draw_anim
  
  lda entity_instances+entityRAM::animationObject+1,x

  rts
  
iceballDie:

  jsr entity_kill

  rts
  
.endif