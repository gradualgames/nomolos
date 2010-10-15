.include "soundengine.inc"
.include "sound_effects.inc"

.segment "CODE"

sf_volume_envelope_silence:
  .byte 0, ENV_STOP

sf_volume_envelope_loud:
  .byte 15, ENV_STOP

sf_volume_envelope_1:
  .byte 14, 12, 11, 9, 7, 6, 4, 2, 1, 0, 0, 2, 3, 5, 8, 6, 3, 1, ENV_STOP

sf_volume_envelope_decay:
  .byte 15, 14, 12, 8, 7, 6, 3, 1, 0, ENV_STOP

sf_volume_envelope_short_note:
  .byte 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, ENV_STOP

sf_volume_envelope_fade_in:
  .byte 0, 1, 3, 6, 7, 8, 12, 14, 15, ENV_STOP

sf_volume_envelope_fade_in_2:
  .byte 5, 8, 10, 10, 12, 12, 15, 15, 10, 10, 6, 6, 3, 3, 0, 0, 0, ENV_STOP

sf_volume_envelope_decay_slowly:
  .byte 15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 8, 6, 4, 2, 1, 0, ENV_STOP
  
sf_volume_envelope_owl:
  .byte 4,4,6,6,11,11,10,10,8,8,6,6,4,4,0,0,ENV_STOP
  
sf_pitch_envelope_0:
  .byte 0, ENV_LOOP

sf_pitch_envelope_1:
  .byte 0, 1, 2, 3, 4, 5, 4, 3, 2, 1, -1, -2, -3, -4, -5, ENV_LOOP

sf_pitch_envelope_2:
  .byte 0, -10, -20, -30, -40, -50, -60, ENV_STOP
  
sf_pitch_envelope_3_owl:
  .byte 1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,ENV_STOP
  
sf_duty_envelope_0:
  .byte 0
sf_duty_envelope_1:
  .byte -128,ENV_LOOP
  
owl_hoot_sound:
  .byte STV,SOUND_EFFECT_BASE+8,STP,SOUND_EFFECT_BASE+3,SDU,SOUND_EFFECT_BASE+1,STL,15,C4
  .byte TRM
  
boss_hurt_sound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte C3, B2, A2, G2, F2, E2, D2, CS2
  .byte C2, B1, A1, G1, F1, E1, D1, C1
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM
  
boss_boom_sound:
  .byte STL, 20
  .byte STV, SOUND_EFFECT_BASE+7
  .byte STP, SOUND_EFFECT_BASE+0
  .byte 15
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

attack_sound:
  .byte STL, 10
  .byte STV, SOUND_EFFECT_BASE+5
  .byte STP, SOUND_EFFECT_BASE+1
  .byte 3
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

attack_flail_sound:
  .byte STL, 10
  .byte STV, SOUND_EFFECT_BASE+5
  .byte STP, SOUND_EFFECT_BASE+1
  .byte 12
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

attack_spear_sound:
  .byte STL, 20
  .byte STV, SOUND_EFFECT_BASE+6
  .byte STP, SOUND_EFFECT_BASE+1
  .byte 5
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

hit_sound:
  .byte STL, 2
  .byte STV, SOUND_EFFECT_BASE+3
  .byte STP, SOUND_EFFECT_BASE+1
  .byte 11, 12, 13
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

get_hurt_sound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte C5, B4, A4, G4, F4, E4, D4, C4
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

die_sound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte C6, B5, A5, G5, F5, E5, D5, CS5
  .byte C5, B4, A4, G4, F4, E4, D4, C4
  .byte STV, SOUND_EFFECT_BASE+0
  .byte A0
  .byte TRM

get_health_sound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte A4,C5,E4,A3,C6,E7
  .byte A4,C5,E4,A3,C6,E7
  .byte TRM

get_item_sound:
  .byte STL, 1
  .byte STV, SOUND_EFFECT_BASE+1
  .byte STP, SOUND_EFFECT_BASE+1
  .byte A4, AS4, B4, C5, CS5, D5, DS5, E5
  .byte A4, AS4, B4, C5, CS5, D5, DS5, E5
  .byte TRM
