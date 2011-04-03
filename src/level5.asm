.include "soundengine.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export level5_sprite_groups
level5_sprite_groups:
  .byte $01
  .word spritesheet1_Nomolos_chr

.segment "ROM09"

.include "level5_patterns_source.inc"

.segment "ROM03"

.export level5_palette
level5_palette:
  .byte $0d,$1b,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0d,$0d,$27,$20,$0d,$04,$29,$0d,$0d,$0d,$27,$16,$0d,$0d,$06,$18

.export level5_music
level5_music: 
  .word Square1
  .word Square2
  .word Triangle
  .word Noise
  .word volume_envelopes
  .word pitch_envelopes
  .word duty_envelopes

volume_envelopes:
  .word volume_envelope_0
  .word volume_envelope_1
  .word volume_envelope_2
  .word volume_envelope_3
  .word volume_envelope_4

  .word volume_envelope_5
  .word volume_envelope_6
  .word 0
  .word 0
  .word 0
  
  sound_effect_volume_addresses

pitch_envelopes:
  .word pitch_envelope_0
  .word 0
  .word 0
  .word 0
  .word 0
  
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  
  sound_effect_pitch_addresses

duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1
  .word 0
  .word 0
  .word 0
  
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  
  sound_effect_duty_addresses

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 11,9,7,5,1,ENV_STOP
volume_envelope_3:
  .byte 13,13,12,11,10,10,9,7,6,5,4,2,2,ENV_STOP
volume_envelope_4:
  .byte 4,5,7,8,9,10,ENV_STOP
volume_envelope_5:
  .byte 3,1,0,0,0,ENV_STOP
volume_envelope_6:
  .byte 10,8,5,4,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte -128,-128,-128,-128,-128,ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,7,D4,D4,D4,D4,D4,D4,F4,F4,F4,F4,F4,F4,E4,E4,E4,E4
  .byte E4,E4,D4,D4,D4,D4,D4,D4,E4,E4,E4,E4,E4,E4,A4,A4,A4,A4,A4,A4,D5,AS4,A4,G4
  .byte F4,E4,F4,G4,A4,D4,E4,CS4,D3,D3,D3,D3,D3,D3,F3,F3,F3,F3,F3,F3,E3,E3,E3,E3
  .byte E3,E3,D3,D3,D3,D3,D3,D3,E3,E3,E3,E3,E3,E3,A3,A3,A3,A3,A3,A3,D4,AS3,A3,G3
  .byte F3,E3,F3,G3,A3,D3,E3,CS3,STV,3,STL,42,D3,STV,2,STL,49,A3,STL,7,E3,CS3,A2,G3
  .byte E3,STL,49,A3,STL,7,E3,CS3,A2,G3,E3,STL,42,A3,STL,7,AS3,G3,D3,AS2,G2,AS2,STL,42
  .byte G3,STL,7,A3,F3,C3,A2,F2,A2,STL,42,F3,STL,7,G3,E3,CS3,G2,E2,G2,STL,42,E3,STL
  .byte 7,F3,D3,A2,F2,D2,F2,F3,E3,D3,C3,AS2,A2,AS3,A3,G3,F3,E3,D3,CS3,E3,D3,E3,D3
  .byte E3,F3,A3,G3,A3,G3,A3,CS3,E3,D3,E3,D3,E3,F3,A3,G3,A3,G3,A3,A3,E3,CS3,A2,E2
  .byte CS2,A1,E1,CS1,A1,E1,CS1,STL,42,A0,STL,7,E3,E3,E3,E3,E3,E3,F3,F3,F3,F3,F3,F3
  .byte GS3,GS3,GS3,GS3,GS3,GS3,B3,B3,B3,B3,B3,B3,D4,D4,D4,D4,D4,D4,C4,B3,A3,GS3,STL,14
  .byte A3,STL,7,E2,E2,E2,E2,E2,E2,F2,F2,F2,F2,F2,F2,GS2,GS2,GS2,GS2,GS2,GS2,B2,B2,B2
  .byte B2,B2,B2,D3,D3,D3,D3,D3,D3,C3,B2,A2,GS2,STL,63,A2,STV,3,STL,7,F2,A2,F2,C3
  .byte A2,DS3,F2,C3,F2,A2,F2,DS3,F2,C3,F2,DS3,F2,F3,F2,D3,F2,C3,F2,B2,G2,B2,G2,D3
  .byte G2,F3,G2,D3,G2,B2,G2,F3,G2,E3,G2,F3,G2,G3,G2,E3,G2,D3,G2,CS3,A2,CS3,A2,E3
  .byte A2,G3,A2,E3,A2,CS3,A2,G3,A2,FS3,A2,G3,A2,A3,A2,FS3,A2,E3,A2,DS3,B2,FS3,DS3,A3
  .byte DS3,C4,DS3,B3,DS3,A3,DS3,GS3,D3,B3,F3,D4,G3,F4,GS3,E4,GS3,D4,GS3,CS4,G3,E4,AS3,G4
  .byte CS4,AS4,CS4,A4,CS4,G4,CS4,F4,E4,D4,C4,B3,A3,GS3,E3,A3,E3,B3,E3,GS3,E3,A3,E3,FS3
  .byte E3,GS3,E3,A3,E3,B3,E3,GS3,E3,A3,E3,FS3,E3,GS3,E3,A2,E3,A2,E3,GS2,E3,A2,E3,F2
  .byte D3,E2,E3,A2,E3,A2,E3,GS2,E3,A2,E3,F2,D3,STL,14,E2,STL,7,E3,D3,C3,B2,A3,G3
  .byte F3,E3,D3,C3,B2,D3,C3,B2,A2,GS2,A2,G2,F2,E2,D2,C2,B1,D2,C2,B1,A1,GS1,STL,42
  .byte A1
  .byte GOT
  .word Square1

Square2:
  .byte STV,3,STP,0,SDU,0,STL,42,D2,D2,A2,AS2,A2,F2,G2,A2,D1,D1,A1,AS1,A1,F1,G1,A1
  .byte STL,49,D2,STV,2,STL,7,F3,D3,A2,F2,D2,STL,49,A1,STL,7,F3,D3,A2,F2,D2,STL,49
  .byte A1,STL,7,F3,D3,A2,F2,D2,STL,49,G1,STL,7,E3,C3,G2,E2,C2,STL,49,F1,STL,7,D3
  .byte AS2,F2,D2,AS1,STL,49,E1,STL,7,CS3,A2,E2,CS2,A1,STL,42,D1,STL,14,D2,E2,F2,G2,A2
  .byte AS2,A2,STL,28,AS2,STL,14,A2,STL,28,AS2,STL,14,A2,STL,28,AS2,STL,14,A2,STL,28,AS2,STL
  .byte 126,A1,STL,14,A2,B2,CS3,D2,D3,C3,B2,D3,A2,STL,28,GS2,STL,14,FS2,E2,FS2,GS2,STL,42
  .byte A1,STL,14,A1,B1,CS2,D1,D2,C2,B1,D2,A1,STL,28,GS1,STL,14,FS1,E1,FS1,GS1,STL,84,A0
  .byte STL,14,F1,F1,F1,F1,F1,F1,F1,F1,F1,STV,3,GS1,GS1,GS1,G1,G1,G1,G1,G1,G1,G1,G1
  .byte G1,AS1,AS1,AS1,A1,A1,A1,A1,A1,A1,A1,A1,A1,C2,C2,C2,B1,B1,B1,B1,B1,B1,E1,E1
  .byte E1,E1,E1,E1,A1,A1,A1,A1,A1,A1,D2,E2,F2,E1,C2,D2,E2,C1,D1,E1,C2,D2,E2,C1
  .byte D1,E1,C2,D2,E2,A1,F1,E1,C2,D2,E2,A1,F1,E1,E2,GS1,A1,B1,C2,D2,E2,E1,A0,B0
  .byte C1,D1,E1,E1,STL,42,A0
  .byte GOT
  .word Square2

Triangle:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL
  .byte 255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,213,A0
  .byte GOT
  .word Triangle

Noise:
  .byte STV,5,STP,0,SDU,0,STL,7,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4
  .byte 4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4
  .byte 4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4
  .byte 4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4
  .byte 4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4
  .byte 4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4
  .byte 4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4
  .byte 4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4
  .byte 4,4,11,4,4,4,4,4,STV,6,STL,14,13,STL,28,6,STL,14,13,STL,28,6,STL,14
  .byte 13,STL,28,6,STL,126,13,STV,5,STL,7,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11
  .byte 4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4,11,4,4,4,4,4
  .byte GOT
  .word Noise

.export level5_map
level5_map = Map

.export level5_map_column_table
level5_map_column_table = MapColumnTable

.export level5_attribute_column_table
level5_attribute_column_table = AttributeColumnTable

.export level5_meta_tile_column_table
level5_meta_tile_column_table = MetaTileColumnTable

.export level5_meta_tile_table
level5_meta_tile_table = MetaTileTable
  
Map:
  .byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09

MapColumnTable:
  .byte $00,$00,$01,$00
  .byte $00,$02,$03,$00
  .byte $00,$04,$05,$00
  .byte $00,$06,$07,$00
  .byte $00,$08,$09,$00
  .byte $00,$09,$0a,$00
  .byte $00,$0b,$0c,$00
  .byte $00,$0d,$0a,$00
  .byte $00,$0e,$0f,$00
  .byte $00,$0f,$0f,$00
AttributeColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTileColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$05,$05,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$05,$05,$05,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$05,$05,$05,$05,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$05,$0b,$0e,$11,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$05,$05,$05,$05,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$05,$05,$05,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$05,$05,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$05,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$04,$06,$06,$06,$06,$06,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$0c,$10,$12,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$00,$00,$00,$02,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0a,$00,$00,$00,$02,$00
  .byte $00,$13,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
MetaTileTable:
MetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $00,$00,$00,$01,$02,$09,$0a,$00
MetaTile2:
  .byte $00,$00,$01,$03,$04,$0b,$0c,$00
MetaTile3:
  .byte $00,$00,$00,$05,$06,$0d,$0e,$00
MetaTile4:
  .byte $00,$00,$01,$07,$08,$0f,$10,$00
MetaTile5:
  .byte $00,$00,$00,$11,$12,$0f,$10,$00
MetaTile6:
  .byte $00,$00,$01,$13,$14,$1d,$1e,$00
MetaTile7:
  .byte $00,$00,$01,$15,$16,$1f,$20,$00
MetaTile8:
  .byte $00,$00,$01,$17,$18,$21,$22,$00
MetaTile9:
  .byte $00,$00,$01,$19,$1a,$00,$23,$00
MetaTile10:
  .byte $00,$00,$01,$1b,$1c,$24,$25,$00
MetaTile11:
  .byte $00,$00,$00,$26,$27,$2a,$2b,$00
MetaTile12:
  .byte $00,$00,$01,$28,$29,$2c,$2d,$00
MetaTile13:
  .byte $00,$00,$00,$2e,$2f,$36,$37,$00
MetaTile14:
  .byte $00,$00,$00,$30,$31,$38,$39,$00
MetaTile15:
  .byte $00,$00,$00,$32,$33,$3a,$3b,$00
MetaTile16:
  .byte $00,$00,$01,$34,$35,$34,$35,$00
MetaTile17:
  .byte $00,$00,$00,$3c,$3d,$40,$41,$00
MetaTile18:
  .byte $00,$00,$01,$3e,$3f,$42,$43,$00
MetaTile19:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_exit
