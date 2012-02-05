.ifndef MOUSE_WIDTH
MOUSE_WIDTH = $10
.endif

.ifndef MOUSE_HEIGHT
MOUSE_HEIGHT = $08
.endif

.ifndef MOUSE_INITSTATE
MOUSE_INITSTATE = 0
.endif 

.ifndef MOUSE_SITTHERESTATE
MOUSE_SITTHERESTATE = 1
.endif

.ifndef mouse_update
mouse_update:
.endif
.scope

  lda entity_instances+entity_instance::state,x
  cmp #MOUSE_INITSTATE
  beq mouseInit
  cmp #MOUSE_SITTHERESTATE
  beq mouseSitThere

mouseInit:

  jsr entity_kill_if_redundant_entity

  ;reset the animation object
  jsr entity_reset_anim

  lda #MOUSE_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  jsr entity_test_picked_up_state

  ;reposition the entity so it sits at the bottom of the tile where it was spawned
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #7
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_instances+entity_instance::position_y+1,x
  
  rts

mouseSitThere:

  jsr entity_compute_screen_coordinates

  ;if Nomolos' state is dying, exit
  lda nomolos_state_primary
  and #nomolos_dying_test
  bne notTouching

  jsr entity_item_test_death_zone
  beq mouseDie

  ;load entity width and height
  lda #MOUSE_WIDTH
  sta b2
  lda #MOUSE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne notTouching

  lda #1
  jsr nomolos_add_health

  ;play get health sound
  txa
  pha

  lda #<get_health_sound
  sta sound_param_word_0
  lda #>get_health_sound
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax

  jsr entity_set_picked_up

  jmp mouseDie

notTouching:

  lda w0
  sta b0
  lda w1
  sta b1

  lda entity_chr_offsets+(entity_index_nomolos-1)
  sta sprite_group_offset

  lda #0
  sta b2
  lda #<spritesheet_common_Mouse
  sta w2
  lda #>spritesheet_common_Mouse
  sta w2+1
  jsr entity_draw_anim


mouseOffScreen:

  rts

mouseDie:

  jsr entity_kill

  rts

.endscope
