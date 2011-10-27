.include "soundengine.inc"
.include "spritesheet_common.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export boss5_sprite_groups
boss5_sprite_groups:
  .byte $05
  .byte entity_index_nomolos
  .byte entity_index_explosion
  .byte entity_index_iceball
  .byte entity_index_lightningbolt
  .byte entity_index_boulder

.segment "ROM09"

.include "boss5_patterns_source.inc"

.segment "ROM05"

.export boss5_music
boss5_music:
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
  .byte 14,14,14,11,4,2,2,2,ENV_STOP
volume_envelope_3:
  .byte 6,9,11,11,7,6,5,5,ENV_STOP
volume_envelope_4:
  .byte 15,2,0,0,0,0,ENV_STOP
volume_envelope_5:
  .byte 0,ENV_STOP
volume_envelope_6:
  .byte 9,9,9,6,2,1,1,1,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte -128,0,ENV_STOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,12,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1
  .byte G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,A1,AS1
  .byte AS2,C2,D2,D3,FS3,D3,C3,A2,AS2,D3,G2,FS2,D3,D2,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1
  .byte G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,A1,AS1
  .byte AS2,C2,D2,D3,FS3,D3,C3,A2,STL,6,A2,STV,6,A2,STV,2,A3,STV,6,A3,STV,2,C4,STV
  .byte 6,C4,STV,2,A3,STV,6,A3,STV,2,FS3,STV,6,FS3,STV,2,D3,STV,6,D3,STV,2,G2,STV
  .byte 6,G2,STV,2,G3,STV,6,G3,STV,2,AS3,STV,6,AS3,STV,2,G3,STV,6,G3,STV,2,E3,STV
  .byte 6,E3,STV,2,C3,STV,6,C3,STV,2,F2,STV,6,F2,STV,2,F3,STV,6,F3,STV,2,A3,STV
  .byte 6,A3,STV,2,F3,STV,6,F3,STV,2,D3,STV,6,D3,STV,2,AS2,STV,6,AS2,STV,2,E2,STV
  .byte 6,E2,STV,2,E3,STV,6,E3,STV,2,G3,STV,6,G3,STV,2,E3,STV,6,E3,STV,2,CS3,STV
  .byte 6,CS3,STV,2,A2,STV,6,A2,STV,2,STL,12,D2,D3,F3,C2,C3,E3,AS1,AS2,D3,A1,A2,C3
  .byte G1,G2,AS2,F1,F2,A2,E1,E2,G2,D1,D2,F2,A0,CS1,E1,A1,CS2,E2,A1,CS2,E2,A2,CS3,E3
  .byte A1,A2,B1,CS2,A2,D2,E2,A2,F2,G2,A2,F2,E2,A2,D2,CS2,A2,D2,A1,A2,B1,CS2,A2,D2
  .byte E2,A2,F2,G2,A2,F2,E2,A2,D2,CS2,A2,D2,A1,A2,CS3,A2,E2,CS2,D2,D3,F3,A3,F3,D3
  .byte G1,G2,AS2,D3,AS2,G2,A1,A2,D3,A1,A2,CS3,D1,D2,F2,A2,F2,D2,A1,A2,B1,CS2,A2,D2
  .byte E2,A2,F2,G2,A2,F2,E2,A2,D2,CS2,A2,D2,A1,A2,B1,CS2,A2,D2,E2,A2,F2,G2,A2,F2
  .byte E2,A2,D2,CS2,A2,D2,A1,A2,CS3,A2,E2,CS2,STL,6,D1,STV,6,D1,STV,2,D2,STV,6,D2
  .byte STV,2,F2,STV,6,F2,STV,2,A2,STV,6,A2,STV,2,F2,STV,6,F2,STV,2,D2,STV,6,D2
  .byte STV,2,G1,STV,6,G1,STV,2,G2,STV,6,G2,STV,2,AS2,STV,6,AS2,STV,2,D3,STV,6,D3
  .byte STV,2,AS2,STV,6,AS2,STV,2,G2,STV,6,G2,STV,2,A1,STV,6,A1,STV,2,A2,STV,6,A2
  .byte STV,2,D3,STV,6,D3,STV,2,A1,STV,6,A1,STV,2,A2,STV,6,A2,STV,2,CS3,STV,6,CS3
  .byte STV,2,D2,STV,6,D2,STV,2,D3,STV,6,D3,STV,2,F3,STV,6,F3,STV,2,A3,STV,6,A3
  .byte STV,2,F3,STV,6,F3,STV,2,D3,STV,6,D3,STV,2,G1,STV,6,G1,STV,2,G2,STV,6,G2
  .byte STV,2,AS2,STV,6,AS2,STV,2,D3,STV,6,D3,STV,2,AS2,STV,6,AS2,STV,2,G2,STV,6,G2
  .byte STV,2,A1,STV,6,A1,STV,2,A2,STV,6,A2,STV,2,D3,STV,6,D3,STV,2,A1,STV,6,A1
  .byte STV,2,A2,STV,6,A2,STV,2,CS3,STV,6,CS3,STV,2,D2,STV,6,D2,STV,2,A2,STV,6,A2
  .byte STV,2,CS2,STV,6,CS2,STV,2,D2,STV,6,D2,STV,2,A2,STV,6,A2,STV,2,CS2,STV,6,CS2
  .byte STV,2,D2,STV,6,D2,STV,2,A2,STV,6,A2,STV,2,CS2,STV,6,CS2,STV,2,D2,STV,6,D2
  .byte STV,2,A2,STV,6,A2,STV,2,CS2,STV,6,CS2,STV,2,STL,12,D2,A2,CS2,D2,A2,CS2,D2,A2
  .byte CS2,D2,A2,CS2,D2,E2,D2,C2,AS1,A1
  .byte GOT
  .word Square1

Square2:
  .byte STV,0,STL,48,A0,STV,3,STP,0,SDU,1,STL,12,D3,STL,6,D3,STL,3,AS2,D3,STL,48,G3
  .byte STL,12,D3,STL,6,D3,STL,3,AS2,D3,STL,48,G3,STL,12,D3,STL,6,D3,STL,3,AS2,D3,STL
  .byte 24,G3,STL,12,D3,STL,24,D3,STL,12,C3,STL,3,C3,AS2,C3,STL,15,AS2,STL,12,A2,STL,3
  .byte A2,G2,A2,STL,15,G2,STL,12,A2,STL,3,C3,AS2,C3,STL,15,AS2,STL,12,A2,STL,3,A2,G2
  .byte A2,STL,15,G2,STL,12,A2,STL,3,C3,AS2,C3,STL,15,AS2,STL,12,C3,STL,3,DS3,D3,DS3,STL
  .byte 15,D3,STL,12,E3,STL,3,G3,FS3,G3,STL,15,FS3,STL,12,G3,A3,AS3,C4,C4,STL,24,AS3,STL
  .byte 3,AS3,A3,AS3,STL,21,A3,STL,3,G3,A3,STL,48,G3,STL,12,D3,STL,6,D3,STL,3,AS2,D3
  .byte STL,48,G3,STL,12,D3,STL,6,D3,STL,3,AS2,D3,STL,24,G3,STL,12,D3,STL,24,D3,STL,12
  .byte C3,STL,3,C3,AS2,C3,STL,15,AS2,STL,12,A2,STL,3,A2,G2,A2,STL,15,G2,STL,12,A2,STL
  .byte 3,C3,AS2,C3,STL,15,AS2,STL,12,A2,STL,3,A2,G2,A2,STL,15,G2,STL,12,A2,STL,3,C3
  .byte AS2,C3,STL,15,AS2,STL,12,C3,STL,3,DS3,D3,DS3,STL,15,D3,STL,12,E3,STL,3,G3,FS3,G3
  .byte STL,15,FS3,STL,12,G3,STL,24,A3,STL,12,AS3,STL,3,A3,STL,45,C4,STL,3,AS3,STL,9,D4
  .byte STL,3,A3,STL,9,C4,STL,3,A3,STL,21,C4,STL,3,G3,STL,21,AS3,STL,3,A3,STL,9,C4
  .byte STL,3,G3,STL,9,AS3,STL,3,G3,STL,21,AS3,STL,3,F3,STL,21,A3,STL,3,G3,STL,9,AS3
  .byte STL,3,F3,STL,9,A3,STL,3,F3,STL,21,A3,STL,3,E3,STL,21,G3,STL,3,F3,STL,9,A3
  .byte STL,3,E3,STL,9,G3,STL,3,G3,F3,G3,STL,15,F3,STL,12,A3,STL,3,F3,E3,F3,STL,15
  .byte E3,STL,12,A3,STL,3,E3,D3,E3,STL,15,D3,STL,12,A3,STL,3,D3,C3,D3,STL,15,C3,STL
  .byte 12,A3,STL,3,C3,AS2,C3,STL,15,AS2,STL,12,A3,STL,3,AS2,A2,AS2,STL,15,A2,STL,12,A3
  .byte STL,3,A2,G2,A2,STL,15,G2,STL,12,A3,STL,3,G2,F2,G2,STL,15,F2,STL,12,A3,STL,48
  .byte E2,STL,3,CS3,STL,9,E3,STL,3,CS3,STL,9,E3,STL,3,A2,CS3,E3,STL,39,A3,STL,3,CS3
  .byte STL,9,E3,STL,3,CS3,STL,9,E3,STL,3,A2,CS3,E3,STL,51,A3,STL,12,A3,STL,3,D3,CS3
  .byte D3,STL,15,CS3,STL,12,D3,STL,24,E3,STL,12,F3,STL,3,A3,G3,A3,STL,15,G3,STL,12,F3
  .byte STL,24,E3,STL,12,F3,STL,3,G3,F3,G3,STL,15,F3,STL,36,E3,STL,12,A3,STL,3,D3,CS3
  .byte D3,STL,15,CS3,STL,12,D3,STL,24,E3,STL,12,F3,STL,3,A3,G3,A3,STL,15,G3,STL,12,F3
  .byte STL,24,E3,STL,12,F3,STL,3,G3,F3,G3,STL,15,F3,STL,24,E3,STL,12,A3,G3,STL,24,G3
  .byte F3,STL,12,D4,C4,STL,24,C4,AS3,STL,12,AS3,G3,STL,36,F3,STL,3,CS3,F3,E3,F3,STL,24
  .byte E3,E3,STL,18,D3,STL,6,A3,G3,F3,E3,D3,STL,12,D3,STL,48,CS3,STL,12,A3,STL,3,D3
  .byte CS3,D3,STL,15,CS3,STL,12,D3,STL,24,E3,STL,12,F3,STL,3,A3,G3,A3,STL,15,G3,STL,12
  .byte F3,STL,24,E3,STL,12,F3,STL,3,G3,F3,G3,STL,15,F3,STL,36,E3,STL,12,A3,STL,3,D3
  .byte CS3,D3,STL,15,CS3,STL,12,D3,STL,24,E3,STL,12,F3,STL,3,A3,G3,A3,STL,15,G3,STL,12
  .byte F3,STL,24,E3,STL,12,F3,STL,3,G3,F3,G3,STL,15,F3,STL,24,E3,STL,12,A3,G3,STL,24
  .byte G3,F3,STL,12,D4,C4,STL,24,C4,AS3,STL,12,AS3,G3,STL,36,F3,STL,3,CS3,E3,F3,E3,F3
  .byte STL,21,E3,STL,24,E3,D3,STL,12,D4,C4,STL,24,C4,AS3,STL,12,AS3,G3,STL,36,F3,STL,3
  .byte CS3,E3,F3,E3,F3,STL,21,E3,STL,24,D2,STL,12,E2,STL,24,F2,STL,12,E2,STL,24,D2,STL
  .byte 12,E2,STL,24,F2,STL,12,E2,STL,24,D2,STL,12,CS2,STL,24,D2,STL,12,CS2,STL,24,D2,STL
  .byte 12,CS2,STL,24,D2,STL,12,CS2,D2,STV,5,SDU,0,STL,60,F3
  .byte GOT
  .word Square2

Triangle:
  .byte STV,2,STP,0,SDU,0,STL,12,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1
  .byte G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,A1,AS1
  .byte AS2,C2,D2,D3,FS3,D3,C3,A2,AS2,D3,G2,FS2,D3,D2,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1
  .byte G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,A1,AS1
  .byte AS2,C2,D2,D3,FS3,D3,C3,A2,A2,A3,C4,A3,FS3,D3,G2,G3,AS3,G3,E3,C3,F2,F3,A3,F3
  .byte D3,AS2,E2,E3,G3,E3,CS3,A2,D2,D3,F3,C2,C3,E3,AS1,AS2,D3,A1,A2,C3,G1,G2,AS2,F1
  .byte F2,A2,E1,E2,G2,D1,D2,F2,A0,CS1,E1,A1,CS2,E2,A1,CS2,E2,A2,CS3,E3,A1,A2,B1,CS2
  .byte A2,D2,E2,A2,F2,G2,A2,F2,STV,3,SDU,1,E2,A2,D2,CS2,A2,D2,A1,A2,B1,CS2,A2,D2
  .byte E2,A2,F2,G2,A2,F2,E2,A2,D2,CS2,A2,D2,STV,2,SDU,0,A1,A2,CS3,A2,E2,CS2,D2,D3
  .byte F3,A3,F3,D3,G1,G2,AS2,D3,AS2,G2,A1,A2,D3,A1,A2,CS3,D1,D2,F2,A2,F2,D2,A1,A2
  .byte B1,CS2,A2,D2,E2,A2,F2,G2,A2,F2,E2,A2,D2,CS2,A2,D2,A1,A2,B1,CS2,A2,D2,E2,A2
  .byte F2,G2,A2,F2,E2,A2,D2,CS2,A2,D2,A1,A2,CS3,A2,E2,CS2,D1,D2,F2,A2,F2,D2,G1,G2
  .byte AS2,D3,AS2,G2,A1,A2,D3,A1,A2,CS3,D2,D3,F3,A3,F3,D3,G1,G2,AS2,D3,AS2,G2,A1,A2
  .byte D3,A1,A2,CS3,D2,A2,CS2,D2,A2,CS2,D2,A2,CS2,D2,A2,CS2,D2,A2,CS2,D2,A2,CS2,D2,A2
  .byte CS2,D2,A2,CS2,D2,E2,D2,C2,AS1,A1
  .byte GOT
  .word Triangle

Noise:
  .byte STV,4,STP,0,SDU,0,STL,12,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15,15,10,15
  .byte 15,10
  .byte GOT
  .word Noise

.export boss5_palette
boss5_palette:
  .byte $0d,$07,$06,$20,$0d,$04,$24,$20,$0d,$04,$14,$24,$0d,$07,$06,$04
  .byte $0d,$0d,$27,$20,$0d,$04,$2a,$0d,$0d,$06,$2a,$18,$0d,$32,$20,$05
  
.export boss5_map
boss5_map = Map

.export boss5_map_column_table
boss5_map_column_table = MapColumnTable

.export boss5_attribute_column_table
boss5_attribute_column_table = AttributeColumnTable

.export boss5_meta_tile_column_table
boss5_meta_tile_column_table = MetaTileColumnTable

.export boss5_meta_tile_table
boss5_meta_tile_table = MetaTileTable

Map:
  .byte $00,$00,$00,$01,$02,$03,$04,$05
MapColumnTable:
  .byte $00,$00,$00,$00
  .byte $01,$01,$02,$00
  .byte $02,$03,$04,$00
  .byte $03,$05,$06,$00
  .byte $04,$07,$08,$00
  .byte $05,$09,$0a,$00
AttributeColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$50,$55,$00,$00,$00
  .byte $00,$00,$90,$a9,$55,$55,$05,$00
  .byte $00,$00,$20,$52,$55,$f5,$00,$00
  .byte $00,$00,$00,$dd,$5d,$f5,$05,$00
  .byte $00,$00,$00,$00,$33,$03,$00,$00
MetaTileColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$52,$00,$00
  .byte $00,$00,$00,$53,$00,$00,$00,$19,$23,$2d,$00,$00,$00,$52,$00,$00
  .byte $00,$00,$00,$00,$01,$08,$10,$1a,$24,$2e,$00,$00,$00,$52,$00,$00
  .byte $00,$00,$00,$00,$02,$09,$11,$1b,$25,$2f,$37,$3f,$46,$52,$00,$00
  .byte $00,$00,$00,$00,$03,$0a,$12,$1c,$26,$30,$38,$40,$47,$52,$00,$00
  .byte $00,$00,$00,$00,$04,$0b,$13,$1d,$27,$31,$39,$41,$00,$52,$00,$00
  .byte $00,$00,$00,$00,$05,$0c,$14,$1e,$28,$32,$3a,$42,$00,$52,$00,$00
  .byte $00,$00,$00,$00,$06,$0d,$15,$1f,$29,$33,$3b,$43,$48,$52,$00,$00
  .byte $00,$00,$00,$00,$07,$0e,$16,$20,$2a,$34,$3c,$44,$49,$52,$00,$00
  .byte $00,$00,$00,$00,$00,$0f,$17,$21,$2b,$35,$3d,$45,$00,$52,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$18,$22,$2c,$36,$3e,$00,$00,$52,$00,$00
MetaTileTable:
MetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $00,$00,$00,$00,$01,$0d,$0e,$00
MetaTile2:
  .byte $00,$01,$00,$02,$03,$0f,$10,$00
MetaTile3:
  .byte $00,$01,$00,$04,$05,$11,$00,$00
MetaTile4:
  .byte $00,$01,$00,$06,$07,$12,$10,$00
MetaTile5:
  .byte $00,$01,$00,$08,$09,$0f,$13,$00
MetaTile6:
  .byte $00,$01,$00,$0a,$0b,$14,$15,$00
MetaTile7:
  .byte $00,$00,$00,$0c,$00,$16,$17,$00
MetaTile8:
  .byte $00,$00,$00,$18,$19,$23,$13,$00
MetaTile9:
  .byte $01,$01,$00,$13,$1a,$24,$25,$00
MetaTile10:
  .byte $02,$01,$00,$1b,$1c,$26,$27,$00
MetaTile11:
  .byte $02,$01,$00,$1d,$1e,$28,$29,$00
MetaTile12:
  .byte $00,$01,$00,$10,$19,$2a,$13,$00
MetaTile13:
  .byte $00,$01,$00,$13,$1f,$0f,$2b,$00
MetaTile14:
  .byte $00,$01,$00,$20,$21,$2c,$2d,$00
MetaTile15:
  .byte $00,$00,$00,$22,$00,$2e,$2f,$00
MetaTile16:
  .byte $00,$00,$00,$07,$30,$3d,$3e,$00
MetaTile17:
  .byte $01,$01,$00,$31,$32,$3f,$40,$00
MetaTile18:
  .byte $02,$01,$00,$33,$34,$41,$42,$00
MetaTile19:
  .byte $02,$01,$00,$35,$36,$43,$44,$00
MetaTile20:
  .byte $00,$01,$00,$37,$19,$45,$0f,$00
MetaTile21:
  .byte $01,$01,$00,$11,$38,$46,$47,$00
MetaTile22:
  .byte $03,$01,$00,$39,$3a,$10,$48,$00
MetaTile23:
  .byte $00,$01,$00,$3b,$3c,$49,$4a,$00
MetaTile24:
  .byte $00,$00,$00,$00,$00,$4b,$00,$00
MetaTile25:
  .byte $01,$00,$00,$00,$4c,$00,$59,$00
MetaTile26:
  .byte $01,$00,$00,$4d,$4e,$5a,$5b,$00
MetaTile27:
  .byte $02,$01,$00,$4f,$50,$5c,$5d,$00
MetaTile28:
  .byte $02,$01,$00,$10,$51,$10,$5e,$00
MetaTile29:
  .byte $01,$01,$00,$52,$53,$5f,$60,$00
MetaTile30:
  .byte $01,$01,$00,$0f,$10,$61,$62,$00
MetaTile31:
  .byte $01,$01,$00,$54,$4d,$63,$64,$00
MetaTile32:
  .byte $03,$01,$00,$10,$55,$65,$66,$00
MetaTile33:
  .byte $00,$01,$00,$56,$57,$67,$68,$00
MetaTile34:
  .byte $00,$00,$00,$58,$00,$69,$00,$00
MetaTile35:
  .byte $01,$00,$00,$00,$6a,$00,$7b,$00
MetaTile36:
  .byte $01,$00,$00,$4d,$6b,$4d,$4d,$00
MetaTile37:
  .byte $01,$01,$00,$6c,$6d,$7c,$7d,$00
MetaTile38:
  .byte $01,$01,$00,$6e,$6f,$52,$52,$00
MetaTile39:
  .byte $01,$01,$00,$70,$71,$7e,$7f,$00
MetaTile40:
  .byte $01,$01,$00,$72,$73,$80,$81,$00
MetaTile41:
  .byte $01,$01,$00,$74,$75,$82,$4d,$00
MetaTile42:
  .byte $03,$01,$00,$76,$77,$10,$83,$00
MetaTile43:
  .byte $03,$01,$00,$78,$79,$84,$85,$00
MetaTile44:
  .byte $00,$00,$00,$7a,$00,$86,$00,$00
MetaTile45:
  .byte $01,$00,$00,$00,$87,$00,$00,$00
MetaTile46:
  .byte $01,$00,$00,$88,$4d,$00,$92,$00
MetaTile47:
  .byte $01,$01,$00,$89,$8a,$93,$94,$00
MetaTile48:
  .byte $01,$01,$00,$52,$52,$52,$52,$00
MetaTile49:
  .byte $01,$01,$00,$52,$8b,$52,$95,$00
MetaTile50:
  .byte $01,$01,$00,$8c,$4d,$96,$97,$00
MetaTile51:
  .byte $01,$01,$00,$4d,$4d,$98,$99,$00
MetaTile52:
  .byte $01,$01,$00,$8d,$8e,$9a,$9b,$00
MetaTile53:
  .byte $03,$01,$00,$8f,$90,$9c,$9d,$00
MetaTile54:
  .byte $00,$00,$00,$91,$00,$9e,$00,$00
MetaTile55:
  .byte $01,$01,$00,$9f,$a0,$aa,$ab,$00
MetaTile56:
  .byte $01,$01,$00,$a1,$52,$ac,$ad,$00
MetaTile57:
  .byte $01,$01,$00,$52,$52,$ae,$af,$00
MetaTile58:
  .byte $01,$01,$00,$a2,$a3,$b0,$b1,$00
MetaTile59:
  .byte $01,$01,$00,$a4,$a5,$b2,$b3,$00
MetaTile60:
  .byte $01,$01,$00,$4d,$a6,$4d,$b4,$00
MetaTile61:
  .byte $03,$01,$00,$a7,$a8,$b5,$b6,$00
MetaTile62:
  .byte $00,$00,$00,$a9,$00,$b7,$00,$00
MetaTile63:
  .byte $01,$01,$00,$4d,$4d,$c3,$4d,$00
MetaTile64:
  .byte $01,$01,$00,$b8,$b9,$4d,$c4,$00
MetaTile65:
  .byte $03,$01,$00,$ba,$bb,$c5,$c6,$00
MetaTile66:
  .byte $03,$01,$00,$bc,$bd,$4d,$c7,$00
MetaTile67:
  .byte $03,$01,$00,$be,$bf,$c8,$10,$00
MetaTile68:
  .byte $03,$01,$00,$10,$c0,$10,$c9,$00
MetaTile69:
  .byte $00,$01,$00,$c1,$c2,$ca,$cb,$00
MetaTile70:
  .byte $01,$01,$00,$cc,$4d,$d0,$d1,$00
MetaTile71:
  .byte $01,$01,$00,$4d,$cd,$d2,$d3,$00
MetaTile72:
  .byte $01,$01,$00,$ce,$4d,$d4,$d5,$00
MetaTile73:
  .byte $01,$01,$00,$4d,$cf,$d6,$d7,$00
MetaTile74:
  .byte $01,$01,$00,$00,$d8,$de,$df,$00
MetaTile75:
  .byte $01,$01,$00,$d9,$52,$e0,$e1,$00
MetaTile76:
  .byte $01,$01,$00,$da,$db,$e2,$e3,$00
MetaTile77:
  .byte $01,$01,$00,$dc,$dd,$e4,$e5,$00
MetaTile78:
  .byte $01,$01,$00,$e6,$4d,$e9,$4d,$00
MetaTile79:
  .byte $01,$01,$00,$e7,$e8,$4d,$ea,$00
MetaTile80:
  .byte $01,$00,$00,$eb,$ec,$00,$00,$00
MetaTile81:
  .byte $01,$00,$00,$ed,$ee,$00,$00,$00
MetaTile82:
  .byte $00,$00,$01,$00,$00,$00,$00,$00
MetaTile83:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_boulder
MetaTile84:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_lightningbolt
MetaTile85:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_iceball
