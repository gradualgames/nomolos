.include "soundengine.inc"
.include "controller.inc"

.ifndef EXITENTITY_WIDTH
EXITENTITY_WIDTH = $20
.endif

.ifndef EXITENTITY_HEIGHT
EXITENTITY_HEIGHT = $ff
.endif

.ifndef exit_level_update
exit_level_update:
.endif

.scope

  jsr entity_kill_if_redundant_entity

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

  jsr controller_clear

  jsr entity_kill

  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif

  .ifndef DEMO_BUILD
  lda #0
  sta state_control_params+play_level_state_control::use_restart_point
  ldy #level_data_struct::next_level
  lda (base_address_rom_definition_table),y
  sta level_current
  lda #PLAYLEVELSTATE_SWITCHTOLEVELINSTATE
  sta state_control_params+play_level_state_control::state
  .else

  lda level_current
  cmp #(num_levels-1)
  bne :+

  lda #PLAYLEVELSTATE_SWITCHTOENDINGSTATE
  sta state_control_params+play_level_state_control::state

  rts
:

  lda #0
  sta state_control_params+play_level_state_control::use_restart_point
  ldy #level_data_struct::next_level
  lda (base_address_rom_definition_table),y
  sta level_current
  lda #PLAYLEVELSTATE_SWITCHTOLEVELINSTATE
  sta state_control_params+play_level_state_control::state

  .endif

  rts

.endscope
