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
  
sound0:
  .byte STL, 10
  .byte STV, $01
  .byte STP, $01
  .byte FS1
  .byte TRM
  
sound4:
  .byte STL, 1
  .byte STV, $03
  .byte STP, $00
  .byte A2,B2,C3,D3,E3,F3,G3,A3,B3,C4,D4,E4,F4,G4,A4,B4
  .byte STV, $00
  .byte B4
  .byte TRM
  
song6_2:
  .word song6_2_square1
  .word song6_2_square2
  .word song6_2_triangle
  .word song6_2_noise
  
song6_2_square1:
  .byte STL, _16TH
  .byte STV, $04
  .byte STP, $01
  .byte G2
  .byte STL, _16TH*3, G2
  .byte STL, _16TH, GS2
  .byte STL, _16TH*3, G2
  .byte STL, _16TH, F2, D2, GS2, F2, B2, GS2, C3, B2
  .byte STV, $03
  .byte STL, _32ND, DS2, D2, F2, DS2, G2, F2, GS2, G2, DS2, D2, F2, DS2, G2, F2, GS2, G2
  .byte C2, AS1, D2, C2, DS2, D2, F2, DS2, C2, AS1, D2, C2, DS2, D2, F2, DS2
  .byte DS2, D2, F2, DS2, G2, F2, GS2, G2, C2, B1, D2, C2, DS2, D2, F2, DS2
  .byte G2, F2, GS2, G2, AS2, GS2, C3, AS2, G2, F2, GS2, G2, AS2, GS2, C3, AS2
  .byte GOT
  .word song6_2_square1
  
song6_2_square2:
  .byte STL, _16TH
  .byte STV, $04
  .byte STP, $01
  .byte DS3
  .byte STL, _16TH*3, C3
  .byte STL, _16TH, F3
  .byte STL, _16TH*3, DS3
  .byte STL, _16TH, GS2, F2, B2, GS2, D3, B2, FS3, G3
  .byte STV, $05
  .byte G3, GS3, AS3, C4
  .byte STL, _16TH*4, G3
  .byte STL, _16TH, GS3, AS3, C4, D4
  .byte STL, _16TH*4, GS3
  .byte STL, _16TH, G3, D3, DS3, F3
  .byte STL, _16TH*4, G3
  .byte STL, _16TH, AS3, GS3, AS3, D4
  .byte STL, _16TH*4, DS4
  .byte GOT
  .word song6_2_square2
  
song6_2_triangle:
  .byte STL, _16TH
  .byte STV, $03
  .byte STP, $01
  .byte C2, G2, C3, G2, DS2, C2, DS2, G2, D2, F2, B2, GS2, F2, D2, FS2, G2
  .byte C2, C3, C2, C3, C2, C3, C2, C3, GS1, GS2, GS1, GS2, GS1, GS2, GS1, GS2
  .byte C2, C3, C2, C3, C2, C3, C2, C3, DS2, DS3, DS2, DS3, DS2, DS3, DS2, DS3
  .byte GOT
  .word song6_2_triangle
  
song6_2_noise:
  .byte STV, $03
  .byte STP, $01
  .byte STL, _16TH, AS2
  .byte STL, _16TH*3, GS2
  .byte STL, _16TH, AS2
  .byte STL, _16TH*3, GS2
  .byte STL, _16TH, AS2
  .byte STL, _32ND, GS2, GS2
  .byte STL, _16TH, GS2
  .byte STL, _8TH, GS2
  .byte STL, _16TH, GS2
  .byte STL, _8TH, GS2  
  .byte STV, $00
  .byte A0, A0, A0, A0, A0, A0, A0, A0
  .byte A0, A0, A0, A0, A0, A0, A0, A0
  .byte GOT
  .word song6_2_noise
  
k1:
  .word k1_square1
  .word k1_square2
  .word k1_triangle
  .word $0000
  
k1_square1:
  .byte STV, 2
  .byte STP, 1
  .byte STL, _32ND, FS3, GS3, A3, B3, CS4, CS3, F3, CS3
  .byte STL, _8TH+_16TH, FS3
  .byte STL, _16TH, GS3
  .byte STL, _32ND, A3, FS3, B3, GS3, CS4, A3, GS3, FS3
  .byte STL, _16TH, F3, CS4
  .byte STL, _64TH, D4, CS4, D4, CS4, D4, CS4, D4, CS4
  .byte STL, _32ND, CS4, B3, A3, GS3, FS3, E3, D3, CS3
  .byte STL, _16TH, D3, B3
  .byte STL, _64TH, CS4, B3, CS4, B3, CS4, B3, CS4, B3
  .byte STL, _32ND, B3, A3, GS3, FS3, E3, D3, CS3, B2
  .byte STL, _16TH, CS3, A3
  .byte STL, _64TH, B3, A3, B3, A3, B3, A3, B3, A3
  .byte STL, _32ND, A3, GS3, FS3, E3, D3, CS3, B2, A2
  .byte STL, _16TH, B2, GS3
  .byte STL, _64TH, A3, GS3, A3, GS3, A3, GS3, A3, GS3
  .byte STL, _32ND, GS3, FS3, F3, DS3, CS3, B2, A2, GS2, A2, FS2, B2, GS2, CS3, A2, GS2, FS2
  .byte F2, CS2, FS2, DS2, GS2, F2, A2, FS2, B2, GS2, CS3, A2, DS3, B2, F3, CS3, FS3, DS3, GS3, F3, A3, FS3
  .byte B3, GS3
  .byte STL, _8TH, CS4
  .byte STL, _64TH, B3, A3, B3, A3, B3, A3, GS3, A3
  .byte STL, _8TH, CS4
  .byte STL, _64TH, B3, A3, B3, A3, B3, A3, GS3, A3
  .byte STL, _8TH, CS4
  .byte STL, _64TH, B3, A3, B3, A3, B3, A3, GS3, A3
  .byte STL, _32ND, A3, FS3, B3, GS3, CS4, A3, GS3, FS3, F3, CS3, FS3, DS3, GS3, B2, A2, GS2
  .byte A2, FS2, B2, GS2, CS3, A2, GS2, FS2, F2, CS2, FS2, DS2, GS2, F2, A2, FS2, B2, B2, A2
  .byte GS2, A2, B2
  .byte STL, _64TH, CS3, B2, A2, B2
  .byte STL, _32ND, CS3, GS2, A2, FS2, GS2, F2
  .byte STL, _16TH, A2, GS2, FS2
  .byte STL, _16TH*6
  .byte F2
  .byte GOT
  .word k1_square1
  
k1_square2:
  .byte STV, 0
  .byte STP, 1
  .byte STL, _16TH*4
  .byte A0
  .byte STV, 2
  .byte STL, _32ND, FS2, GS2, A2, B2, CS3, CS2, F2, CS2
  .byte STL, _16TH, FS2, GS2, A2, B2, CS3, CS3, CS3, CS3, A2, A2, A2, A2, B2, B2, B2, B2
  .byte GS2, GS2, GS2, GS2, A2, A2, A2, A2
  .byte FS2, FS2, FS2, FS2, GS2, GS2, GS2, GS2
  .byte CS2, CS2, CS2, CS2, FS2, GS2, A2, B2
  .byte CS2, DS2, F2, FS2, GS2, A2, B2, CS3, DS3, F3, FS3, GS3
  .byte STL, _32ND, A3, FS3, D3, B2, GS3, F3, GS3, F3, A3, FS3, D3, B2, GS3, F3, CS3, F3, A3
  .byte FS3, D3, B2, GS3, F3, CS3, F3
  .byte STL, _16TH, FS2, GS2, A2, B2, CS3, DS2, F2, CS2
  .byte FS1, GS1, A1, B1, CS2, DS2, F2, FS2
  .byte STL, _32ND, GS1, GS2, FS2, F2
  .byte STL, _16TH, FS2, D2
  .byte STL, _8TH+_16TH, CS1
  .byte STL, _32ND, FS2, DS2, F2, CS2, DS2, C2, CS2, GS1, F1, GS1
  .byte STL, _64TH, CS1, DS1, CS1, DS1, CS1, DS1, CS1, DS1
  .byte STL, _8TH
  .byte CS1
  .byte GOT
  .word k1_square2
  
k1_triangle:
  .byte STV, 0
  .byte STP, 1
  .byte STL, _16TH*4
  .byte A0
  .byte STV, 2
  .byte STL, _32ND, FS2, GS2, A2, B2, CS3, CS2, F2, CS2
  .byte STL, _16TH, FS2, GS2, A2, B2, CS3, CS4, CS3, CS4, A2, A3, A2, A3, B2, B3, B2, B3
  .byte GS2, GS3, GS2, GS3, A2, A3, A2, A3
  .byte FS2, FS3, FS2, FS3, GS2, GS3, GS2, GS3
  .byte CS2, CS3, CS2, CS3, FS2, GS2, A2, B2
  .byte CS2, DS2, F2, FS2, GS2, A2, B2, CS3, DS3, F3, FS3, GS3
  .byte STL, _32ND, A3, FS3, D3, B2, GS3, F3, GS3, F3, A3, FS3, D3, B2, GS3, F3, CS3, F3, A3
  .byte FS3, D3, B2, GS3, F3, CS3, F3
  .byte STL, _16TH, FS2, GS2, A2, B2, CS3, DS2, F2, CS2
  .byte FS1, GS1, A1, B1, CS2, DS2, F2, FS2
  .byte STL, _32ND, GS1, GS2, FS2, F2
  .byte STL, _16TH, FS2, D2
  .byte STL, _8TH+_16TH, CS1
  .byte STL, _32ND, FS2, DS2, F2, CS2, DS2, C2, CS2, GS1, F1, GS1
  .byte STL, _64TH, CS1, DS1, CS1, DS1, CS1, DS1, CS1, DS1
  .byte STL, _8TH
  .byte CS1
  .byte GOT
  .word k1_triangle
  
k13:
  .word k13_square1
  .word k13_square2
  .word $0000
  .word $0000
  
k13_square1:
  .byte STL, _16TH
  .byte STV, 2
  .byte STP, 1
  .byte G4, D4
  .byte STL, _64TH, C4, B3, C4, B3
  .byte STL, _32ND, A3, G3, FS3, E3, D3, C3, B2, C3
  .byte STL, _8TH+_32ND, D3
  .byte STL, _32ND, G3, FS3, B3, A3, E4, D4, G4, FS4, C5, B4, A4, G4, FS4
  .byte STL, _16TH, G4, G3
  .byte STL, _32ND, FS3, B3, A3, E4, D4, G4, FS4, C5, B4, A4, G4, FS4
  .byte STL, _16TH, G4, D4
  .byte STL, _32ND, E4, E3, E3, E3, E3, E3, E3, G3
  .byte STL, _16TH, E3, E4
  .byte STL, _64TH, FS4, E4, FS4, E4
  .byte STL, _32ND, D4, C4, D4, D3, D3, D3, D3, D3, D3, FS3
  .byte STL, _16TH, D3, D4
  .byte STL, _64TH, E4, D4, E4, D4
  .byte STL, _32ND, C4, B3, C4, D3, D3, D3, D3, D3, D3, FS3
  .byte STL, _16TH, D3, C4
  .byte STL, _64TH, D4, C4, D4, C4
  .byte STL, _32ND, B3, A3, B3, G2, G2, G2, G2, G2, G2, B2
  .byte STL, _16TH, G2, B3
  .byte STL, _64TH, C4, B3, C4, B3
  .byte STL, _32ND, A3, G3, D4, A3, FS3, D3, B3, D3, B2, G2, D4, A3, FS3, D3, B3, D3, B2, G2
  .byte GOT
  .word k13_square1

k13_square2:
  .byte STL, _16TH*6
  .byte STV, 0
  .byte STP, 1
  .byte A1
  .byte STV, 2
  .byte STL, _16TH, G2, D2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, D2, D1
  .byte STL, _16TH, G1, G2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, D2, D1
  .byte STL, _16TH, G1, G2
  .byte STL, _64TH, C2, B1, C2, B1
  .byte STL, _32ND, A1, G1
  .byte STL, _8TH, C2
  .byte STL, _32ND, C4, C4, C4, E4
  .byte STL, _16TH, C4, C4
  .byte STL, _64TH, D4, C4, D4, C4
  .byte STL, _32ND, B3, A3
  .byte STL, _8TH, B3
  .byte STL, _32ND, B3, B3, B3, D4
  .byte STL, _16TH, B3, B2
  .byte STL, _64TH, C3, B2, C3, B2
  .byte STL, _32ND, A2, G2
  .byte STL, _8TH, D2
  .byte STL, _32ND, A3, A3, A3, C4
  .byte STL, _16TH, A3, D2
  .byte STL, _64TH, B2, A2, B2, A2
  .byte STL, _32ND, G2, FS2
  .byte STL, _8TH, G1
  .byte STL, _32ND, B3, B3, B3, D4
  .byte STL, _16TH, B3, G2
  .byte STL, _64TH, A2, G2, A2, G2
  .byte STL, _32ND, FS2, E2
  .byte STL, _16TH, D1, D2, D1, D2, D1, D2, D1, D2
  .byte GOT
  .word k13_square2
