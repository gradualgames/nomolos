.ifndef MOUSE_INC
MOUSE_INC = 1

MOUSE_WIDTH = $10
MOUSE_HEIGHT = $08

MOUSE_INITSTATE = 0
MOUSE_SITTHERESTATE = 1

.export mouse_update
mouse_update:

  lda entity_instances+entityRAM::state,x
  cmp #MOUSE_INITSTATE
  beq mouseInit
  cmp #MOUSE_SITTHERESTATE
  beq mouseSitThere

mouseInit:

  ;reset the explosion animation object
  lda #$01
  sta entity_instances+entityRAM::animationObject,x
  lda #$ff
  sta entity_instances+entityRAM::animationObject+1,x
  
  lda #MOUSE_SITTHERESTATE
  sta entity_instances+entityRAM::state,x

  rts
  
mouseSitThere:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq mouseDie
  
  ;load entity width and height
  lda #MOUSE_WIDTH
  sta b2
  lda #MOUSE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  bne @notTouching
  
  lda #1
  jsr nomolos_add_health
  
  ;sound_play getHealthSound
  lda #<getHealthSound
  sta w0
  lda #>getHealthSound
  sta w0+1
  jsr sound_load
  
  jmp mouseDie
  
@notTouching:

  lda w0
  sta b0
  lda w1
  sta b1
  lda #0
  sta b2
  
  ;load address of animation object into w1
  lda #<(entity_instances+entityRAM::animationObject)
  sta w1
  lda #>(entity_instances+entityRAM::animationObject)
  sta w1+1
  
  ;get the index into a
  txa
  clc
  ;do a 16 bit add onto the address with this index
  adc w1
  sta w1
  lda w1+1
  adc #0
  sta w1+1 
  
  ldy #ROMDefinitionTableStruct::Mouse
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1
  jsr sprite_update_animation  
  
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  jsr sprite_draw_animation_16bit
  
mouseOffScreen:
  
  rts
  
mouseDie:

  jsr entity_kill

  rts
  
.endif