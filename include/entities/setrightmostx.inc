.ifndef setrightmostx_update
setrightmostx_update:
.endif

.scope

  jsr entity_compute_screen_coordinates

  ;set rightmost x
  sec
  lda entity_instances+entity_instance::position_x,x
  sbc #$f0
  sta camera_rightmost_x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #$00
  sta camera_rightmost_x+1

  jsr entity_kill

  rts

.endscope
