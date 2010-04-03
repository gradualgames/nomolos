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

  ;reset the animation object
  jsr entity_reset_anim
  
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
  ldy #ROMDefinitionTableStruct::Mouse
  jsr entity_draw_anim

  
mouseOffScreen:
  
  rts
  
mouseDie:

  jsr entity_kill

  rts
  
.endif