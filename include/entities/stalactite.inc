.ifndef STALACTITE_INC
STALACTITE_INC = 1

.struct stalactite_locals
  x_velocity .word
  y_velocity .word
  counter .byte
.endstruct

STALACTITE_WIDTH = $10
STALACTITE_HEIGHT = $10

STALACTITE_INITSTATE = 0
STALACTITE_STARTFALLSTATE = 1
STALACTITE_FALLSTATE = 2

stalactite_update:

  lda entity_instances+entity_instance::state,x
  cmp #STALACTITE_INITSTATE
  beq stalactite_init
  cmp #STALACTITE_STARTFALLSTATE
  beq stalactite_startfall
  cmp #STALACTITE_FALLSTATE
  beq stalactite_fall

stalactite_init:

  ;reset the stalactite animation object
  jsr entity_reset_anim

  ;move stalactite offscreen
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #$10
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_y+1,x
  
  ;start velocity out slow
  lda #0
  sta entity_locals+stalactite_locals::x_velocity,x
  sta entity_locals+stalactite_locals::x_velocity+1,x
  lda #40
  sta entity_locals+stalactite_locals::y_velocity,x
  lda #0
  sta entity_locals+stalactite_locals::y_velocity+1,x
  
  ;store a counter for the start fall state
  lda #100
  sta entity_locals+stalactite_locals::counter,x
  
  ;set state to start-fall
  lda #STALACTITE_STARTFALLSTATE
  sta entity_instances+entity_instance::state,x

  rts

stalactite_startfall:

  jsr stalactite_move
  
  jsr stalactite_draw

  dec entity_locals+stalactite_locals::counter,x
  bne skip_switch_to_fallstate
  
  lda #0
  sta entity_locals+stalactite_locals::x_velocity,x
  sta entity_locals+stalactite_locals::x_velocity+1,x
  lda #0
  sta entity_locals+stalactite_locals::y_velocity,x
  lda #4
  sta entity_locals+stalactite_locals::y_velocity+1,x
  
  ;set state to fall
  lda #STALACTITE_FALLSTATE
  sta entity_instances+entity_instance::state,x
  
skip_switch_to_fallstate:

  rts
  
stalactite_fall:

  jsr stalactite_move
  
  jsr stalactite_draw

  lda entity_instances+entity_instance::position_y+1,x
  bne stalactiteDie
  
  rts

stalactite_draw:

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

  lda entity_chr_offsets+(entity_index_stalactite-1)
  sta sprite_group_offset

  lda #<spritesheet1_Stalactite0
  sta w0
  lda #>spritesheet1_Stalactite0
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
  
stalactite_move:

.scope addYVelocity
  clc
  lda entity_locals+stalactite_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+stalactite_locals::y_velocity+1,x
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
  
stalactiteDie:

  jsr entity_kill

  rts

.endif