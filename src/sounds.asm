.linecont +
.include "soundengine.inc"
.include "sounds.inc"

.segment "CODE"

.define volume_envelopes \
  volume_envelope_silence, \
  volume_envelope_loud, \
  volume_envelope_1, \
  volume_envelope_decay, \
  volume_envelope_short_note, \
  volume_envelope_fade_in
  
volume_envelopes_lo: .lobytes volume_envelopes
volume_envelopes_hi: .hibytes volume_envelopes

.define pitch_envelopes pitch_envelope_0, pitch_envelope_1
pitch_envelopes_lo: .lobytes pitch_envelopes
pitch_envelopes_hi: .hibytes pitch_envelopes

volume_envelope_silence:
  .byte 0, ENV_STOP

volume_envelope_loud:
  .byte 15, ENV_STOP

volume_envelope_1:
  .byte 14, 12, 11, 9, 7, 6, 4, 2, 1, 0, 0, 2, 3, 5, 8, 6, 3, 1, ENV_STOP
  
volume_envelope_decay:
  .byte 15, 14, 12, 8, 7, 6, 3, 1, 0, ENV_STOP
  
volume_envelope_short_note:
  .byte 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, ENV_STOP
  
volume_envelope_fade_in:
  .byte 0, 1, 3, 6, 7, 8, 12, 14, 15, ENV_STOP
  
pitch_envelope_0: 
  .byte 0, 1, 2, 3, 4, 5, 4, 3, 2, 1, -1, -2, -3, -4, -5, ENV_LOOP

pitch_envelope_1:
  .byte 0, ENV_STOP