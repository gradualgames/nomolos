.include "soundengine.inc"
.include "spritesheet_common.inc"
.include "spritesheet2.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export level6_sprite_groups
level6_sprite_groups:
  .byte $01
  .byte entity_index_nomolos

.segment "ROM09"

.include "level6_patterns_source.inc"

.segment "ROM05"

.export level6_palette
level6_palette:
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$27,$20,$0d,$04,$29,$0d,$0d,$0d,$28,$20,$0d,$0d,$00,$29

.export level6_cycling_palettes
level6_cycling_palettes:
  .byte 58
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$24,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$30,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$30,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$24,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$30,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10



.export level6_music
level6_music:
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

.export level6_map
level6_map = Map

.export level6_map_column_table
level6_map_column_table = MapColumnTable

.export level6_attribute_column_table
level6_attribute_column_table = AttributeColumnTable

.export level6_meta_tile_column_table
level6_meta_tile_column_table = MetaTileColumnTable

.export level6_meta_tile_table
level6_meta_tile_table = MetaTileTable
  
Map:
  .byte $00,$01,$02,$03,$04,$01,$05,$06,$07,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08

MapColumnTable:
  .byte $00,$00,$01,$00
  .byte $01,$02,$03,$00
  .byte $02,$04,$05,$00
  .byte $00,$00,$06,$00
  .byte $03,$01,$07,$00
  .byte $04,$04,$08,$00
  .byte $05,$09,$0a,$00
  .byte $06,$0b,$0c,$00
  .byte $06,$0c,$0c,$00
AttributeColumnTable:
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$0f
  .byte $00,$a8,$66,$66,$06,$00,$00,$0f
  .byte $00,$a2,$99,$99,$09,$40,$44,$0f
  .byte $33,$33,$33,$33,$33,$73,$77,$0f
  .byte $00,$a6,$99,$99,$09,$00,$00,$0f
  .byte $11,$05,$00,$00,$00,$00,$00,$0f
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTileColumnTable:
  .byte $38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$3e,$44,$00
  .byte $3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$40,$44,$00
  .byte $00,$00,$00,$07,$10,$10,$1e,$10,$2f,$00,$00,$00,$00,$00,$44,$00
  .byte $00,$00,$04,$08,$0e,$16,$1c,$24,$2d,$00,$00,$00,$00,$00,$44,$00
  .byte $00,$00,$05,$09,$0f,$17,$1d,$25,$2e,$00,$00,$00,$00,$00,$44,$00
  .byte $00,$00,$00,$0a,$11,$11,$1f,$11,$30,$00,$00,$1b,$23,$2c,$44,$00
  .byte $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$3f,$44,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2b,$34,$2c,$44,$00
  .byte $00,$00,$0b,$0a,$11,$11,$1f,$11,$30,$00,$00,$00,$00,$00,$44,$00
  .byte $03,$06,$0c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$44,$00
  .byte $00,$00,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$44,$00
  .byte $48,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
MetaTileTable:
MetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $00,$00,$00,$01,$02,$07,$08,$00
MetaTile2:
  .byte $00,$00,$00,$03,$04,$09,$0a,$00
MetaTile3:
  .byte $01,$00,$00,$05,$06,$0b,$06,$00
MetaTile4:
  .byte $02,$00,$00,$00,$0c,$10,$11,$00
MetaTile5:
  .byte $02,$00,$00,$0d,$00,$12,$13,$00
MetaTile6:
  .byte $01,$00,$00,$0e,$0f,$14,$0f,$00
MetaTile7:
  .byte $02,$00,$00,$15,$16,$22,$23,$00
MetaTile8:
  .byte $02,$00,$00,$17,$18,$24,$25,$00
MetaTile9:
  .byte $02,$00,$00,$19,$1a,$26,$27,$00
MetaTile10:
  .byte $02,$00,$00,$1b,$1c,$28,$29,$00
MetaTile11:
  .byte $01,$00,$00,$1d,$1e,$2a,$2b,$00
MetaTile12:
  .byte $01,$00,$00,$1f,$20,$2c,$2d,$00
MetaTile13:
  .byte $01,$00,$00,$21,$00,$2e,$00,$00
MetaTile14:
  .byte $01,$00,$00,$2f,$30,$3f,$40,$00
MetaTile15:
  .byte $01,$00,$00,$31,$32,$41,$42,$00
MetaTile16:
  .byte $02,$00,$00,$33,$34,$43,$44,$00
MetaTile17:
  .byte $02,$00,$00,$35,$36,$45,$46,$00
MetaTile18:
  .byte $03,$00,$00,$37,$38,$47,$48,$00
MetaTile19:
  .byte $03,$00,$00,$39,$3a,$49,$4a,$00
MetaTile20:
  .byte $03,$00,$00,$3b,$3c,$4b,$4c,$00
MetaTile21:
  .byte $03,$00,$00,$3d,$3e,$4d,$4e,$00
MetaTile22:
  .byte $01,$00,$00,$4f,$50,$57,$58,$00
MetaTile23:
  .byte $01,$00,$00,$51,$52,$59,$5a,$00
MetaTile24:
  .byte $03,$00,$00,$00,$53,$5b,$5c,$00
MetaTile25:
  .byte $03,$00,$00,$54,$55,$5d,$5e,$00
MetaTile26:
  .byte $03,$00,$00,$56,$00,$5f,$60,$00
MetaTile27:
  .byte $01,$00,$00,$61,$62,$71,$72,$00
MetaTile28:
  .byte $01,$00,$00,$63,$64,$73,$74,$00
MetaTile29:
  .byte $01,$00,$00,$65,$66,$75,$76,$00
MetaTile30:
  .byte $02,$00,$00,$67,$68,$77,$78,$00
MetaTile31:
  .byte $02,$00,$00,$69,$6a,$79,$7a,$00
MetaTile32:
  .byte $03,$00,$00,$6b,$6c,$7b,$7c,$00
MetaTile33:
  .byte $03,$00,$00,$6d,$6e,$6d,$6e,$00
MetaTile34:
  .byte $03,$00,$00,$6f,$70,$7d,$7e,$00
MetaTile35:
  .byte $01,$00,$00,$7f,$80,$8d,$8e,$00
MetaTile36:
  .byte $01,$00,$00,$81,$82,$8f,$90,$00
MetaTile37:
  .byte $01,$00,$00,$83,$84,$91,$92,$00
MetaTile38:
  .byte $03,$00,$00,$85,$86,$93,$94,$00
MetaTile39:
  .byte $03,$00,$00,$85,$86,$93,$95,$00
MetaTile40:
  .byte $03,$00,$00,$7b,$87,$7b,$96,$00
MetaTile41:
  .byte $03,$00,$00,$88,$89,$97,$98,$00
MetaTile42:
  .byte $03,$00,$00,$8a,$7e,$99,$7e,$00
MetaTile43:
  .byte $01,$00,$00,$8b,$8c,$9a,$9b,$00
MetaTile44:
  .byte $01,$00,$00,$9c,$9d,$ab,$ac,$00
MetaTile45:
  .byte $01,$00,$00,$9e,$9f,$ad,$ae,$00
MetaTile46:
  .byte $01,$00,$00,$a0,$a1,$af,$b0,$00
MetaTile47:
  .byte $02,$00,$00,$a2,$a3,$b1,$b2,$00
MetaTile48:
  .byte $02,$00,$00,$a4,$a5,$b3,$b4,$00
MetaTile49:
  .byte $03,$00,$00,$7b,$a6,$7b,$a6,$00
MetaTile50:
  .byte $03,$00,$00,$6d,$a7,$6d,$a7,$00
MetaTile51:
  .byte $03,$00,$00,$a8,$7e,$a8,$7e,$00
MetaTile52:
  .byte $01,$00,$00,$a9,$aa,$b5,$b6,$00
MetaTile53:
  .byte $03,$00,$00,$b7,$b8,$bd,$be,$00
MetaTile54:
  .byte $03,$00,$00,$b9,$ba,$be,$be,$00
MetaTile55:
  .byte $03,$00,$00,$bb,$bc,$be,$bf,$00
MetaTile56:
  .byte $03,$00,$00,$c0,$c1,$c6,$c7,$00
MetaTile57:
  .byte $03,$00,$00,$c2,$c3,$c2,$c3,$00
MetaTile58:
  .byte $03,$00,$00,$c4,$c5,$c8,$c5,$00
MetaTile59:
  .byte $02,$00,$00,$c9,$ca,$cf,$d0,$00
MetaTile60:
  .byte $02,$00,$00,$cb,$cc,$d1,$d2,$00
MetaTile61:
  .byte $02,$00,$00,$cd,$ce,$d3,$d4,$00
MetaTile62:
  .byte $03,$00,$00,$d5,$d6,$e1,$e2,$00
MetaTile63:
  .byte $03,$00,$00,$d7,$d8,$e3,$e4,$00
MetaTile64:
  .byte $03,$00,$00,$d9,$da,$e5,$e6,$00
MetaTile65:
  .byte $02,$00,$00,$db,$dc,$e7,$e8,$00
MetaTile66:
  .byte $02,$00,$00,$dd,$de,$e9,$ea,$00
MetaTile67:
  .byte $02,$00,$00,$df,$e0,$eb,$ec,$00
MetaTile68:
  .byte $03,$00,$01,$ed,$ee,$f5,$f6,$00
MetaTile69:
  .byte $02,$00,$00,$ef,$f0,$f7,$f8,$00
MetaTile70:
  .byte $02,$00,$00,$f1,$f2,$f9,$fa,$00
MetaTile71:
  .byte $02,$00,$00,$f3,$f4,$fb,$fc,$00
MetaTile72:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_exit
