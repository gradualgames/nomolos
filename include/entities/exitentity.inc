.include "soundengine.inc"

.ifndef EXITENTITY_INC
EXITENTITY_INC = 1

EXITENTITY_WIDTH = $20
EXITENTITY_HEIGHT = $ff

exit_level_update:

  jsr entity_compute_screen_coordinates

  ;load entity width and height
  lda #EXITENTITY_WIDTH
  sta b2
  lda #EXITENTITY_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  beq is_touching_nomolos
  rts
is_touching_nomolos:

  jsr entity_kill

  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif

  lda #0
  sta state_control_params+play_level_state_control::use_restart_point
  ldy #level_data_struct::next_level
  lda (base_address_rom_definition_table),y
  sta level_current
  lda #PLAYLEVELSTATE_SWITCHTOLEVELINSTATE
  sta state_control_params+play_level_state_control::state

  rts

.endif
