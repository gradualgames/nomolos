.global sf_volume_envelope_silence
.global sf_volume_envelope_loud
.global sf_volume_envelope_1
.global sf_volume_envelope_decay
.global sf_volume_envelope_short_note
.global sf_volume_envelope_fade_in
.global sf_volume_envelope_fade_in_2
.global sf_volume_envelope_decay_slowly
.global sf_volume_envelope_owl
.global sf_volume_envelope_foom
.global sf_pitch_envelope_0
.global sf_pitch_envelope_1
.global sf_pitch_envelope_2
.global sf_pitch_envelope_3_owl
.global sf_duty_envelope_0
.global sf_duty_envelope_1

.global foom_sound
.global owl_hoot_sound
.global boss_hurt_sound
.global boss_boom_sound
.global attack_sound
.global attack_flail_sound
.global attack_spear_sound
.global hit_sound
.global get_health_sound
.global get_item_sound
.global get_hurt_sound
.global die_sound

SOUND_EFFECT_BASE = 10

.macro sound_effect_volume_addresses

  .word sf_volume_envelope_silence
  .word sf_volume_envelope_loud
  .word sf_volume_envelope_1
  .word sf_volume_envelope_decay
  .word sf_volume_envelope_short_note

  .word sf_volume_envelope_fade_in
  .word sf_volume_envelope_fade_in_2
  .word sf_volume_envelope_decay_slowly
  .word sf_volume_envelope_owl
  .word sf_volume_envelope_foom

.endmacro

.macro sound_effect_pitch_addresses

  .word sf_pitch_envelope_0
  .word sf_pitch_envelope_1
  .word sf_pitch_envelope_2
  .word sf_pitch_envelope_3_owl
  .word 0

  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

.endmacro

.macro sound_effect_duty_addresses

  .word sf_duty_envelope_0
  .word sf_duty_envelope_1
  .word 0
  .word 0
  .word 0

  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

.endmacro