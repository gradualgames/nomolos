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
  .word 0
  
  .word 0
  .word 0
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
  .byte 11,11,10,6,6,3,2,ENV_STOP
volume_envelope_3:
  .byte 2,3,4,6,7,8,9,9,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte -128,ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,1,STL,7,C2,C3,DS3,G3,DS3,C3,DS3,C3,G2,C3,DS2,C3,C2,C3,DS3,G3
  .byte DS3,C3,DS3,C3,G2,C3,DS2,C3,C2,C3,F3,GS3,F3,C3,F3,C3,GS2,C3,F2,C3,C2,C3,F3,GS3
  .byte F3,C3,F3,C3,GS2,C3,F2,C3,C2,B2,D3,F3,D3,B2,D3,B2,GS2,B2,F2,B2,C2,B2,D3,F3
  .byte D3,B2,D3,B2,GS2,B2,F2,B2,C2,G2,C3,DS3,C3,G2,C3,G2,DS2,G2,C2,G2,AS1,G2,C3,DS3
  .byte C3,G2,C3,G2,DS2,G2,C2,G2,GS1,G2,C3,DS3,C3,G2,C3,G2,DS2,G2,C2,G2,G1,G2,C3,DS3
  .byte C3,G2,C3,G2,DS2,G2,C2,G2,FS1,A2,C3,DS3,C3,A2,C3,A2,DS2,A2,C2,A2,FS1,A2,C3,DS3
  .byte C3,A2,C3,A2,FS2,A2,D2,A2,G1,A2,AS2,D3,AS2,A2,AS2,A2,D2,A2,AS1,A2,G1,G2,AS2,D3
  .byte AS2,G2,AS2,G2,AS1,G2,G1,G2,DS1,AS2,D3,G3,D3,AS2,D3,AS2,G2,AS2,DS2,AS2,C2,A2,DS3,G3
  .byte DS3,A2,DS3,A2,C2,A2,A1,A2,D1,A2,C3,FS3,C3,A2,C3,A2,D2,A2,A1,A2,D1,A2,C3,FS3
  .byte C3,A2,C3,A2,D2,A2,A1,A2,D1,AS2,D3,G3,D3,AS2,D3,AS2,D2,AS2,AS1,AS2,D1,C3,FS3,A3
  .byte FS3,C3,FS3,C3,DS2,C3,C2,C3,D1,D3,G3,AS3,G3,D3,G3,D3,G2,D3,D2,D3,D1,D3,FS3,C4
  .byte FS3,D3,FS3,D3,A2,D3,FS2,D3,DS1,CS3,G3,AS3,G3,CS3,G3,CS3,G2,CS3,DS2,CS3,D1,C3,DS3,A3
  .byte DS3,C3,DS3,C3,FS2,C3,D2,C3,D1,AS2,E3,G3,E3,AS2,E3,AS2,E2,AS2,CS2,AS2,D1,A2,C3,G3
  .byte C3,A2,C3,A2,DS2,A2,C2,A2,D1,A2,C3,FS3,C3,A2,C3,A2,D2,A2,A1,A2,D1,G2,AS2,E3
  .byte AS2,G2,AS2,G2,CS2,G2,AS1,G2,D1,FS2,A2,DS3,A2,FS2,A2,FS2,C2,FS2,A1,FS2,D1,G2,AS2,D3
  .byte AS2,G2,AS2,G2,AS1,G2,G1,G2,D1,G2,A2,C3,A2,G2,A2,G2,DS2,G2,C2,G2,D1,FS2,A2,C3
  .byte A2,FS2,A2,FS2,D2,FS2,A1,FS2,G1,FS2,A2,C3,A2,FS2,A2,FS2,DS2,FS2,C2,FS2,G1,G2,A2,C3
  .byte B2,G2,B2,G2,D2,G2,B1,G2,G1,A2,C3,FS3,C3,A2,C3,A2,DS2,A2,C2,A2,G1,C3,FS3,A3
  .byte FS3,C3,FS3,C3,DS2,C3,C2,C3,G1,B2,D3,G3,D3,B2,D3,B2,G2,B2,D2,B2,G1,B2,D3,F3
  .byte D3,B2,D3,B2,GS2,B2,F2,B2,G1,G2,C3,DS3,C3,G2,C3,G2,DS2,G2,C2,G2,G1,FS2,C3,DS3
  .byte C3,FS2,C3,FS2,DS2,FS2,C2,FS2,G1,FS2,C3,DS3,C3,FS2,C3,FS2,DS2,FS2,C2,FS2,G1,G2,B2,D3
  .byte B2,G2,B2,D3,DS3,C3,A2,FS3,STL,70,G3,STL,14,G2,F2,GS2,G2,F2,DS2,D2
  .byte GOT
  .word Square1

Square2:
  .byte STV,3,STP,0,SDU,0,STL,7,C2,C3,DS3,G3,DS3,C3,DS3,C3,G2,C3,DS2,C3,C2,C3,DS3,G3
  .byte DS3,C3,DS3,C3,G2,C3,DS2,C3,C2,C3,F3,GS3,F3,C3,F3,C3,GS2,C3,F2,C3,C2,C3,F3,GS3
  .byte F3,C3,F3,C3,GS2,C3,F2,C3,C2,B2,D3,F3,D3,B2,D3,B2,GS2,B2,F2,B2,C2,B2,D3,F3
  .byte D3,B2,D3,B2,GS2,B2,F2,B2,C2,G2,C3,DS3,C3,G2,C3,G2,DS2,G2,C2,G2,AS1,G2,C3,DS3
  .byte C3,G2,C3,G2,DS2,G2,C2,G2,GS1,G2,C3,DS3,C3,G2,C3,G2,DS2,G2,C2,G2,G1,G2,C3,DS3
  .byte C3,G2,C3,G2,DS2,G2,C2,G2,FS1,A2,C3,DS3,C3,A2,C3,A2,DS2,A2,C2,A2,FS1,A2,C3,DS3
  .byte C3,A2,C3,A2,FS2,A2,D2,A2,G1,A2,AS2,D3,AS2,A2,AS2,A2,D2,A2,AS1,A2,G1,G2,AS2,D3
  .byte AS2,G2,AS2,G2,AS1,G2,G1,G2,DS1,AS2,D3,G3,D3,AS2,D3,AS2,G2,AS2,DS2,AS2,C2,A2,DS3,G3
  .byte DS3,A2,DS3,A2,C2,A2,A1,A2,D1,A2,C3,FS3,C3,A2,C3,A2,D2,A2,A1,A2,D1,A2,C3,FS3
  .byte C3,A2,C3,A2,D2,A2,A1,A2,D1,AS2,D3,G3,D3,AS2,D3,AS2,D2,AS2,AS1,AS2,D1,C3,FS3,A3
  .byte FS3,C3,FS3,C3,DS2,C3,C2,C3,D1,D3,G3,AS3,G3,D3,G3,D3,G2,D3,D2,D3,D1,D3,FS3,C4
  .byte FS3,D3,FS3,D3,A2,D3,FS2,D3,DS1,CS3,G3,AS3,G3,CS3,G3,CS3,G2,CS3,DS2,CS3,D1,C3,DS3,A3
  .byte DS3,C3,DS3,C3,FS2,C3,D2,C3,D1,AS2,E3,G3,E3,AS2,E3,AS2,E2,AS2,CS2,AS2,D1,A2,C3,G3
  .byte C3,A2,C3,A2,DS2,A2,C2,A2,D1,A2,C3,FS3,C3,A2,C3,A2,D2,A2,A1,A2,D1,G2,AS2,E3
  .byte AS2,G2,AS2,G2,CS2,G2,AS1,G2,D1,FS2,A2,DS3,A2,FS2,A2,FS2,C2,FS2,A1,FS2,D1,G2,AS2,D3
  .byte AS2,G2,AS2,G2,AS1,G2,G1,G2,D1,G2,A2,C3,A2,G2,A2,G2,DS2,G2,C2,G2,D1,FS2,A2,C3
  .byte A2,FS2,A2,FS2,D2,FS2,A1,FS2,G1,FS2,A2,C3,A2,FS2,A2,FS2,DS2,FS2,C2,FS2,G1,G2,A2,C3
  .byte B2,G2,B2,G2,D2,G2,B1,G2,G1,A2,C3,FS3,C3,A2,C3,A2,DS2,A2,C2,A2,G1,C3,FS3,A3
  .byte FS3,C3,FS3,C3,DS2,C3,C2,C3,G1,B2,D3,G3,D3,B2,D3,B2,G2,B2,D2,B2,G1,B2,D3,F3
  .byte D3,B2,D3,B2,GS2,B2,F2,B2,G1,G2,C3,DS3,C3,G2,C3,G2,DS2,G2,C2,G2,G1,FS2,C3,DS3
  .byte C3,FS2,C3,FS2,DS2,FS2,C2,FS2,G1,FS2,C3,DS3,C3,FS2,C3,FS2,DS2,FS2,C2,FS2,G1,G2,B2,D3
  .byte B2,G2,B2,D3,DS3,C3,A2,FS3,STL,70,G3,STL,14,G2,F2,GS2,G2,F2,DS2,D2
  .byte GOT
  .word Square2

Triangle:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL
  .byte 255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,126,A0
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL
  .byte 255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,126,A0
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
