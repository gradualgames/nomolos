.include "soundengine.inc"
.include "controller.inc"

.ifndef WARPZONE_WIDTH
WARPZONE_WIDTH = $10
.endif

.ifndef WARPZONE_HEIGHT
WARPZONE_HEIGHT = $10
.endif

.ifndef warpzone_update
warpzone_update:
.endif

.scope

  jsr entity_kill_if_redundant_entity

  jsr entity_compute_screen_coordinates

  ;load entity width and height
  lda #WARPZONE_WIDTH
  sta b2
  lda #WARPZONE_HEIGHT
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

  ;hard coded to jump to the bonus level
  lda #0
  sta state_control_params+play_level_state_control::use_restart_point
  ldy #0
  sta level_current
  lda #PLAYLEVELSTATE_SWITCHTOLEVELINSTATE
  sta state_control_params+play_level_state_control::state

  rts

.endscope
