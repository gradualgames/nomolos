.ifndef LIGHTNINGBOLT_INC
LIGHTNINGBOLT_INC = 1

.proc lightningbolt_update

  lda entity_instances+entity_instance::state,x
  cmp #LIGHTNINGBOLT_INITSTATE
  beq lightningbolt_init
  cmp #LIGHTNINGBOLT_FALLSTATE
  beq lightningbolt_fall

lightningbolt_init:

  ;reset the lightningbolt animation object
  jsr entity_reset_anim

  ;move lightningbolt offscreen
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #$10
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_y+1,x
  
  ;set velocity
  lda #0
  sta entity_locals+lightningbolt_locals::x_velocity,x
  sta entity_locals+lightningbolt_locals::x_velocity+1,x
  lda #0
  sta entity_locals+lightningbolt_locals::y_velocity,x
  lda #4
  sta entity_locals+lightningbolt_locals::y_velocity+1,x
  
  ;store a counter for the fall state
  lda #100
  sta entity_locals+lightningbolt_locals::counter,x
  
  ;set state to fall
  lda #LIGHTNINGBOLT_FALLSTATE
  sta entity_instances+entity_instance::state,x

  rts

lightningbolt_fall:

  jsr lightningbolt_move
  
  jsr lightningbolt_draw

  lda entity_instances+entity_instance::position_y+1,x
  cmp #1
  beq lightningboltDie
  
  rts

lightningbolt_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq lightningboltDie

  ;load width and height
  lda #LIGHTNINGBOLT_WIDTH
  sta b2
  lda #LIGHTNINGBOLT_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  dec entity_locals+lightningbolt_locals::counter,x
  lda entity_locals+lightningbolt_locals::counter,x
  and #$01
  beq do_not_draw

  lda entity_chr_offsets+(entity_index_thoguth-1)
  sta sprite_group_offset

  lda #<spritesheet2_ThoguthLightning
  sta w2
  lda #>spritesheet2_ThoguthLightning
  sta w2+1
  lda #0
  sta b2
  jsr entity_draw_anim
do_not_draw:
  
  rts
  
lightningbolt_move:

.scope addYVelocity
  clc
  lda entity_locals+lightningbolt_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+lightningbolt_locals::y_velocity+1,x
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
  
lightningboltDie:

  jsr entity_kill

  rts

.endproc
  
.endif