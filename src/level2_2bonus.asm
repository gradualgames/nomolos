.feature force_range
.include "soundengine.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "ROM15"

.export level2_2bonusmusic
level2_2bonusmusic:
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
  .word duty_envelope_2
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
  .byte 13,9,6,5,4,4,4,3,2,0,ENV_STOP
volume_envelope_2:
  .byte 8,3,1,0,0,ENV_STOP
volume_envelope_3:
  .byte 12,10,7,5,2,1,0,ENV_STOP
volume_envelope_4:
  .byte 0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte 192,ENV_LOOP
duty_envelope_2:
  .byte 192,ENV_LOOP

Square1:
  .byte STV,1,STP,0,SDU,1,STL,24,D4,STL,8,A3,AS3,D4,G3,AS3,A3,D4,F3,A3,G3,AS3,E3,G3
  .byte F3,A3,D3,F3,E3,G3,CS3,E3,STL,16,D3,STL,32,D4,D4,C4,AS3,A3,STL,24,G3,STL,8
  .byte F3,E3,D3,F3,E3,D3,CS3,D3,A3,A2,A3,A2,G3,F3,E3,D3,F3,E3,D3,E3,G3,F3,E3,F3,A3
  .byte A2,A3,A2,G3,F3,E3,F3,A3,G3,F3,G3,AS3,A3,G3,A3,C4,C3,C4,C3,AS3,A3,G3,F3,A3
  .byte G3,F3,G3,AS3,A3,G3,A3,C4,C3,C4,C3,AS3,A3,G3,FS3,A3,G3,FS3,G3,AS3,A3,C4,AS3
  .byte D4,D3,D4,D3,C4,B3,A3,GS3,B3,A3,GS3,A3,C4,B3,D4,C4,E4,E3,E4,E3,D4,C4,B3,A3
  .byte G3,F3,E3,D3,C3,B2,A2,STL,136,E3,STL,8,E3,F3,FS3,G3,GS3,A3,B3,C4,GS3,A3,B3
  .byte C4,CS4,D4,DS4,E4,C4,D4,E4,F4,FS4,G4,GS4,A4,G4,F4,E4,D4,C4,B3,A3,STL,136,E3
  .byte STL,8,E3,F3,FS3,G3,GS3,A3,B3,C4,GS3,A3,B3,C4,CS4,D4,DS4,E4,C4,D4,E4,F4,FS4
  .byte G4,GS4,A4,E4,F4,B3,C4,A3,B3,GS3,STL,40,A3,STL,8,B3,E3,D4,STL,16,D4,STL,24
  .byte C4,STL,8,B3,E3,D4,STL,16,D4,STL,24,C4,STL,8,B3,E3,D4,D4,C4,B3,A3,STL,16,GS3
  .byte STL,4,B3,A3,GS3,A3,STL,40,B3,STL,8,C4,B3,A3,STL,16,A3,STL,24,B3,STL,8,C4,B3
  .byte A3,STL,16,A3,STL,24,B3,STL,8,C4,B3,A3,B3,D4,C4,B3,C4,A3,B3,GS3,A3,STL,16,A4
  .byte STL,8,E4,F4,A4,D4,F4,E4,A4,C4,E4,D4,F4,B3,D4,C4,E4,A3,C4,B3,D4,GS3,B3,A3,E3
  .byte F3,D3,C3,A3,B2,GS3,STL,16,A3
  .byte GOT
  .word Square1
Square2:
  .byte STV,0,STL,216,A0,STV,3,STP,0,SDU,2,STL,8,A2,AS2,D3,G2,AS2,A2,D3,F2,A2,G2,AS2
  .byte E2,G2,F2,A2,D2,F2,E2,G2,CS2,E2,STL,16,D2,STV,1,SDU,1,F1,G1,A1,D1,D2,CS2,A1
  .byte AS1,F1,G1,A1,D1,D2,CS2,A1,D2,A1,AS1,C2,F1,F2,E2,C2,D2,A1,AS1,C2,F1,STL,32
  .byte F2,STL,16,DS2,D2,C2,AS1,A1,G1,STL,32,G2,STL,16,F2,E2,D2,C2,B1,A1,A2,GS2,E2
  .byte F2,C2,D2,F2,STL,8,E1,E2,F2,FS2,G2,GS2,A2,B2,C3,GS2,A2,B2,C3,CS3,D3,DS3,STL,16
  .byte E3,STL,32,E3,STL,16,D3,C3,B2,A2,A2,GS2,A2,F2,D2,C2,A1,D2,F2,STL,8,E1,E2,F2
  .byte FS2,G2,GS2,A2,B2,C3,GS2,A2,B2,C3,CS3,D3,DS3,STL,16,E3,STL,32,E3,STL,16,D3
  .byte C3,B2,A2,A2,GS2,A2,F2,D2,C2,D2,E2,E1,STL,8,A1,STV,3,SDU,2,A2,STV,1,SDU,1,F2
  .byte STV,3,SDU,2,D2,STV,1,SDU,1,STL,32,GS1,STL,8,A1,A2,F2,D2,STL,32,GS1,STL,8,A1
  .byte A2,F2,D2,STL,32,GS1,STL,16,A1,D2,E2,F2,STL,8,E1,E2,B1,E1,STL,32,F1,STL,8,E1
  .byte E2,B1,E1,STL,32,F1,STL,8,E1,E2,B1,E1,STL,32,F1,STL,8,GS1,STV,3,SDU,2,GS1,STV,1
  .byte SDU,1,A1,STV,3,SDU,2,A1,STV,1,SDU,1,E2,STV,3,SDU,2,E2,STV,1,SDU,1,E1,STV,3
  .byte SDU,2,E1,STV,1,SDU,1,A1,STV,3,SDU,2,A1,STV,1,SDU,1,C3,STV,3,SDU,2,C3,STV,1
  .byte SDU,1,D3,STV,3,SDU,2,D3,STV,1,SDU,1,B2,STV,3,SDU,2,B2,STV,1,SDU,1,C3,STV,3
  .byte SDU,2,C3,STV,1,SDU,1,A2,STV,3,SDU,2,A2,STV,1,SDU,1,B2,STV,3,SDU,2,B2,STV,1
  .byte SDU,1,GS2,STV,3,SDU,2,GS2,STV,1,SDU,1,A2,STV,3,SDU,2,A2,STV,1,SDU,1,C2,STV,3
  .byte SDU,2,C2,STV,1,SDU,1,F2,STV,3,SDU,2,F2,STV,1,SDU,1,B1,STV,3,SDU,2,B1,STV,1
  .byte SDU,1,C2,STV,3,SDU,2,C2,STV,1,SDU,1,D2,D2,E2,STV,3,SDU,2,E2,STV,1,SDU,1,E1
  .byte STV,3,SDU,2,E1,STV,1,SDU,1,STL,16,A0
  .byte GOT
  .word Square2
Triangle:
  .byte STV,4,STP,0,SDU,0,STL,255,A3,STL,145,A3,STV,3,SDU,2,STL,16,F2,G2,A2,D2,D3
  .byte CS3,A2,STV,1,SDU,1,AS2,F2,G2,A2,D2,D3,CS3,A2,D3,A2,AS2,C3,F2,F3,E3,C3,D3,A2
  .byte AS2,C3,F2,STL,32,F3,STL,16,DS3,D3,C3,AS2,A2,G2,STL,32,G3,STL,16,F3,E3,D3,C3
  .byte B2,A2,A3,GS3,E3,F3,C3,D3,F3,STL,128,E2,STL,16,E4,STL,32,E4,STL,16,D4,C4,B3
  .byte A3,A3,GS3,A3,F3,D3,C3,A2,D3,F3,STL,128,E2,STL,16,E4,STL,32,E4,STL,16,D4,C4
  .byte B3,A3,A3,GS3,A3,F3,D3,C3,D3,E3,E2,STL,8,A1,A2,F2,D2,STL,32,GS1,STL,8,A1,A2
  .byte F2,D2,STL,32,GS1,STL,8,A1,A2,F2,D2,STL,32,GS1,STL,16,A1,D2,E2,F2,STL,8,E1
  .byte E2,B1,E1,STL,32,F1,STL,8,E1,E2,B1,E1,STL,32,F1,STL,8,E1,E2,B1,E1,STL,32,F1
  .byte STL,16,GS1,A1,E2,E1,A1,C3,D3,B2,C3,A2,B2,GS2,A2,C2,F2,B1,C2,D2,E2,E1,A0
  .byte GOT
  .word Triangle
Noise:
  .byte STV,0,STL,255,4,STL,145,4,STV,2,STP,0,SDU,0,STL,16,11,11,11,11,11,11,11,11
  .byte 11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,STL,32,11,STL,16
  .byte 11,11,11,11,11,11,STL,32,11,STL,16,11,11,11,11,11,11,11,11,11,11,11,11,11
  .byte STL,176,11,STL,16,11,11,11,11,11,11,11,11,11,11,11,11,11,STL,176,11,STL,16
  .byte 11,11,11,11,11,11,11,11,11,11,11,11,11,STL,8,11,7,4,7,STL,32,11,STL,8,11,7
  .byte 4,7,STL,32,11,STL,8,11,7,4,7,STL,32,11,STL,16,11,11,11,11,STL,8,11,7,4,7,STL,32
  .byte 11,STL,8,11,7,4,7,STL,32,11,STL,8,11,7,4,7,STL,32,11,STL,16,11,11,11,11,11
  .byte 11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11
  .byte GOT
  .word Noise

.export level2_2bonuspalette
level2_2bonuspalette:
  .byte $0d,$10,$00,$02,$0d,$07,$06,$0c,$0d,$10,$00,$04,$0d,$10,$28,$08
;spritesheet1_palette
  .byte $3f,$3f,$27,$20,$3f,$3f,$04,$29,$3f,$3f,$07,$38,$3f,$3f,$3f,$3f

.export level2_2bonuscycling_palettes
level2_2bonuscycling_palettes:
  .byte 4
  .byte $0d,$10,$00,$02,$0d,$07,$06,$0c,$0d,$10,$00,$04,$0d,$10,$08,$08
  .byte $0d,$10,$00,$02,$0d,$07,$06,$0c,$0d,$10,$00,$04,$0d,$10,$18,$08
  .byte $0d,$10,$00,$02,$0d,$07,$06,$0c,$0d,$10,$00,$04,$0d,$10,$28,$08
  .byte $0d,$10,$00,$02,$0d,$07,$06,$0c,$0d,$10,$00,$04,$0d,$10,$18,$08

.export level2_2bonusmap
level2_2bonusmap = Map

.export level2_2bonusmap_column_table
level2_2bonusmap_column_table = MapColumnTable

.export level2_2bonusattribute_column_table
level2_2bonusattribute_column_table = AttributeColumnTable

.export level2_2bonusmeta_tile_column_table
level2_2bonusmeta_tile_column_table = MetaTileColumnTable

.export level2_2bonusmeta_tile_table
level2_2bonusmeta_tile_table = MetaTileTable

Map:
  .byte $00,$00,$00,$01,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02
  .byte $03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04
  .byte $02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03
  .byte $04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$04,$02,$03,$05,$06,$07,$08,$09,$0a,$04,$02,$03,$05,$06
  .byte $07,$08,$09,$0a,$04,$02,$03,$05,$06,$07,$08,$09,$0a,$04,$02,$03,$0b,$0c,$0d,$0e,$0f,$10,$11,$0c,$0d,$12,$13,$10,$11,$0c,$0d,$0e
  .byte $0f,$10,$11,$14,$15,$0e,$0f,$10,$11,$0c,$0d,$0e,$0f,$16,$0b,$0c,$0d,$0e,$0f,$10,$11,$0c,$0d,$12,$02,$03,$04,$02,$17,$18,$19,$1a
  .byte $1b,$1c,$1c,$1c,$1c,$1c,$1c,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d
  .byte $1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d

MapColumnTable:
  .byte $00,$00,$00,$00
  .byte $01,$01,$01,$00
  .byte $01,$02,$02,$00
  .byte $02,$03,$04,$00
  .byte $03,$05,$02,$00
  .byte $04,$05,$06,$00
  .byte $05,$06,$07,$00
  .byte $06,$08,$09,$00
  .byte $07,$0a,$07,$00
  .byte $08,$07,$06,$00
  .byte $09,$0b,$04,$00
  .byte $0a,$05,$0c,$00
  .byte $0b,$0c,$0d,$00
  .byte $0c,$0e,$0f,$00
  .byte $0d,$10,$0d,$00
  .byte $0e,$0d,$0c,$00
  .byte $0f,$11,$12,$00
  .byte $10,$13,$0c,$00
  .byte $11,$10,$02,$00
  .byte $12,$02,$0c,$00
  .byte $13,$0c,$02,$00
  .byte $14,$03,$0f,$00
  .byte $15,$11,$04,$00
  .byte $16,$14,$15,$00
  .byte $17,$16,$17,$00
  .byte $18,$18,$18,$00
  .byte $19,$19,$1a,$00
  .byte $1a,$1b,$1c,$00
  .byte $1a,$1d,$1d,$00
  .byte $1a,$1e,$1e,$00
AttributeColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
  .byte $55,$55,$55,$55,$00,$00,$00,$00
  .byte $f3,$55,$55,$55,$00,$00,$00,$00
  .byte $77,$55,$55,$55,$00,$00,$00,$00
  .byte $77,$55,$55,$55,$44,$44,$00,$00
  .byte $55,$55,$55,$55,$11,$55,$00,$00
  .byte $f3,$55,$55,$55,$00,$55,$44,$00
  .byte $77,$55,$55,$55,$00,$55,$11,$00
  .byte $55,$55,$55,$55,$44,$55,$00,$00
  .byte $f3,$55,$55,$55,$11,$11,$00,$00
  .byte $77,$55,$55,$55,$44,$00,$00,$00
  .byte $55,$55,$55,$55,$55,$44,$44,$04
  .byte $f3,$55,$55,$55,$55,$11,$11,$01
  .byte $77,$55,$55,$55,$55,$44,$44,$04
  .byte $55,$55,$55,$55,$55,$11,$11,$01
  .byte $f3,$55,$55,$55,$55,$44,$44,$04
  .byte $77,$55,$55,$55,$55,$11,$11,$01
  .byte $77,$55,$55,$55,$11,$00,$00,$00
  .byte $55,$55,$55,$55,$44,$00,$00,$00
  .byte $55,$55,$55,$55,$11,$00,$00,$00
  .byte $f3,$55,$55,$55,$44,$00,$00,$00
  .byte $f3,$55,$55,$55,$11,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$50,$05
  .byte $11,$11,$11,$51,$55,$55,$55,$05
  .byte $55,$55,$f5,$50,$55,$55,$55,$05
  .byte $44,$44,$44,$54,$d5,$55,$55,$05
  .byte $55,$55,$55,$55,$55,$55,$55,$05
MetaTileColumnTable:
  .byte $07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $19,$19,$19,$19,$19,$19,$19,$19,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $08,$08,$08,$08,$08,$08,$19,$19,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $a7,$63,$08,$08,$08,$08,$19,$19,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $95,$64,$08,$08,$08,$08,$19,$19,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $a9,$65,$08,$08,$08,$08,$19,$19,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $08,$08,$08,$08,$08,$08,$19,$19,$19,$19,$19,$19,$07,$07,$07,$00
  .byte $08,$08,$08,$08,$08,$08,$19,$19,$07,$07,$19,$19,$07,$07,$07,$00
  .byte $a7,$63,$08,$08,$08,$08,$19,$19,$07,$07,$19,$19,$07,$07,$07,$00
  .byte $95,$64,$08,$08,$08,$08,$19,$19,$07,$07,$19,$19,$19,$19,$07,$00
  .byte $a9,$65,$08,$08,$08,$08,$19,$19,$07,$07,$19,$19,$19,$19,$07,$00
  .byte $a7,$63,$08,$08,$08,$08,$19,$19,$19,$19,$19,$19,$07,$07,$07,$00
  .byte $08,$08,$08,$08,$08,$08,$19,$19,$19,$19,$07,$07,$07,$07,$07,$00
  .byte $08,$08,$08,$08,$08,$08,$19,$19,$19,$19,$19,$19,$19,$19,$19,$00
  .byte $a7,$63,$08,$08,$08,$08,$19,$19,$19,$19,$19,$19,$19,$19,$19,$00
  .byte $95,$64,$08,$08,$08,$08,$19,$19,$19,$19,$07,$07,$07,$07,$07,$00
  .byte $a9,$65,$08,$08,$08,$08,$19,$19,$19,$19,$07,$07,$07,$07,$07,$00
  .byte $a7,$63,$08,$08,$08,$08,$19,$19,$19,$19,$07,$07,$07,$07,$07,$00
  .byte $95,$64,$08,$08,$08,$08,$19,$19,$19,$19,$19,$19,$19,$19,$19,$00
  .byte $a9,$65,$08,$08,$08,$08,$19,$19,$19,$19,$19,$19,$19,$19,$19,$00
  .byte $4a,$4a,$4a,$4a,$4a,$4a,$4a,$4a,$4a,$4a,$4a,$4a,$4a,$08,$08,$00
  .byte $4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$08,$08,$00
  .byte $19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$08,$08,$00
  .byte $18,$18,$18,$18,$18,$18,$25,$19,$19,$19,$19,$19,$19,$08,$08,$00
  .byte $19,$19,$19,$19,$19,$5c,$26,$19,$19,$19,$19,$19,$19,$08,$08,$00
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$27,$19,$19,$19,$19,$19,$19,$08,$08,$00
  .byte $19,$19,$19,$19,$19,$19,$19,$19,$19,$5d,$19,$19,$19,$08,$08,$00
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$31,$31,$31,$31,$08,$08,$00
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$a4,$a5,$a5,$a5,$08,$08,$00
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$00
  .byte $19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$00
MetaTileTable:
MetaTile0:
  .byte $00,$00,$00,$00,$01,$0f,$10,$00
MetaTile1:
  .byte $00,$00,$00,$02,$03,$11,$12,$00
MetaTile2:
  .byte $00,$00,$00,$04,$05,$13,$14,$00
MetaTile3:
  .byte $00,$00,$00,$06,$07,$0f,$10,$00
MetaTile4:
  .byte $01,$00,$00,$08,$09,$15,$16,$00
MetaTile5:
  .byte $02,$01,$01,$86,$87,$92,$93,$00
MetaTile6:
  .byte $00,$00,$00,$0b,$0c,$17,$18,$00
MetaTile7:
  .byte $00,$00,$01,$0d,$0e,$19,$1a,$00
MetaTile8:
  .byte $01,$00,$01,$0d,$0e,$19,$1a,$00
MetaTile9:
  .byte $03,$00,$00,$0d,$0e,$19,$1a,$00
MetaTile10:
  .byte $00,$00,$00,$25,$26,$35,$16,$00
MetaTile11:
  .byte $00,$00,$00,$27,$28,$36,$18,$00
MetaTile12:
  .byte $02,$00,$00,$00,$01,$0f,$10,$00
MetaTile13:
  .byte $02,$00,$00,$02,$03,$11,$12,$00
MetaTile14:
  .byte $02,$00,$00,$04,$05,$13,$14,$00
MetaTile15:
  .byte $02,$00,$00,$06,$07,$0f,$10,$00
MetaTile16:
  .byte $00,$00,$00,$00,$07,$0f,$10,$00
MetaTile17:
  .byte $00,$00,$00,$1b,$1c,$29,$2a,$00
MetaTile18:
  .byte $00,$00,$00,$1d,$1e,$2b,$2c,$00
MetaTile19:
  .byte $00,$00,$00,$00,$07,$0f,$2d,$00
MetaTile20:
  .byte $00,$00,$00,$1f,$20,$2e,$2f,$00
MetaTile21:
  .byte $00,$00,$00,$21,$22,$30,$31,$00
MetaTile22:
  .byte $00,$00,$00,$23,$24,$32,$33,$00
MetaTile23:
  .byte $00,$00,$00,$00,$07,$34,$10,$00
MetaTile24:
  .byte $00,$00,$00,$0a,$af,$0a,$c1,$00
MetaTile25:
  .byte $01,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile26:
  .byte $00,$00,$00,$b0,$0a,$c2,$0a,$00
MetaTile27:
  .byte $02,$00,$00,$1b,$1c,$29,$2a,$00
MetaTile28:
  .byte $02,$00,$00,$1d,$1e,$2b,$2c,$00
MetaTile29:
  .byte $02,$00,$00,$00,$07,$0f,$10,$00
MetaTile30:
  .byte $00,$00,$00,$37,$38,$43,$44,$00
MetaTile31:
  .byte $00,$00,$00,$39,$3a,$45,$46,$00
MetaTile32:
  .byte $00,$00,$00,$00,$3b,$0f,$47,$00
MetaTile33:
  .byte $00,$00,$00,$3c,$3d,$48,$49,$00
MetaTile34:
  .byte $00,$00,$00,$3e,$3f,$4a,$4b,$00
MetaTile35:
  .byte $00,$00,$00,$40,$41,$4c,$4d,$00
MetaTile36:
  .byte $00,$00,$00,$42,$07,$4e,$10,$00
MetaTile37:
  .byte $00,$00,$01,$ce,$c8,$d8,$d9,$00
MetaTile38:
  .byte $00,$00,$01,$c8,$c8,$d9,$d9,$00
MetaTile39:
  .byte $00,$00,$01,$c8,$cf,$d9,$da,$00
MetaTile40:
  .byte $02,$00,$00,$37,$38,$43,$44,$00
MetaTile41:
  .byte $02,$00,$00,$39,$3a,$45,$46,$00
MetaTile42:
  .byte $00,$00,$00,$4f,$50,$0f,$5b,$00
MetaTile43:
  .byte $00,$00,$00,$51,$52,$5c,$5d,$00
MetaTile44:
  .byte $00,$00,$00,$00,$53,$0f,$5e,$00
MetaTile45:
  .byte $00,$00,$00,$54,$55,$5f,$55,$00
MetaTile46:
  .byte $00,$00,$00,$56,$57,$60,$61,$00
MetaTile47:
  .byte $00,$00,$00,$58,$59,$58,$62,$00
MetaTile48:
  .byte $00,$00,$00,$0a,$5a,$63,$64,$00
MetaTile49:
  .byte $01,$00,$00,$0a,$af,$0a,$c1,$00
MetaTile50:
  .byte $02,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile51:
  .byte $01,$00,$00,$b0,$0a,$c2,$0a,$00
MetaTile52:
  .byte $02,$00,$00,$4f,$50,$0f,$5b,$00
MetaTile53:
  .byte $02,$00,$00,$51,$52,$5c,$5d,$00
MetaTile54:
  .byte $00,$00,$00,$00,$65,$0f,$10,$00
MetaTile55:
  .byte $00,$00,$00,$66,$67,$70,$71,$00
MetaTile56:
  .byte $00,$00,$00,$00,$68,$0f,$72,$00
MetaTile57:
  .byte $00,$00,$00,$69,$6a,$73,$74,$00
MetaTile58:
  .byte $00,$00,$00,$6b,$6c,$75,$76,$00
MetaTile59:
  .byte $00,$00,$00,$58,$6d,$77,$78,$00
MetaTile60:
  .byte $00,$00,$00,$6e,$6f,$79,$7a,$00
MetaTile61:
  .byte $01,$00,$01,$ce,$c8,$d8,$d9,$00
MetaTile62:
  .byte $01,$00,$01,$c8,$c8,$d9,$d9,$00
MetaTile63:
  .byte $01,$00,$01,$c8,$cf,$d9,$da,$00
MetaTile64:
  .byte $02,$00,$00,$66,$67,$70,$71,$00
MetaTile65:
  .byte $00,$00,$00,$00,$7b,$0f,$10,$00
MetaTile66:
  .byte $00,$00,$00,$7c,$7d,$88,$89,$00
MetaTile67:
  .byte $00,$00,$00,$7e,$7f,$8a,$8b,$00
MetaTile68:
  .byte $00,$00,$00,$80,$81,$8c,$8d,$00
MetaTile69:
  .byte $00,$00,$00,$82,$83,$8e,$8f,$00
MetaTile70:
  .byte $00,$00,$00,$84,$85,$90,$91,$00
MetaTile71:
  .byte $02,$00,$00,$0a,$af,$0a,$c1,$00
MetaTile72:
  .byte $02,$00,$00,$b0,$0a,$c2,$0a,$00
MetaTile73:
  .byte $02,$00,$00,$00,$7b,$0f,$10,$00
MetaTile74:
  .byte $00,$00,$00,$94,$95,$9d,$9e,$00
MetaTile75:
  .byte $00,$00,$00,$96,$96,$96,$96,$00
MetaTile76:
  .byte $00,$00,$00,$97,$98,$9f,$98,$00
MetaTile77:
  .byte $03,$00,$00,$99,$9a,$a0,$a1,$00
MetaTile78:
  .byte $03,$00,$00,$9b,$9c,$a2,$a3,$00
MetaTile79:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile80:
  .byte $02,$00,$01,$ce,$c8,$d8,$d9,$00
MetaTile81:
  .byte $02,$00,$01,$c8,$c8,$d9,$d9,$00
MetaTile82:
  .byte $02,$00,$01,$c8,$cf,$d9,$da,$00
MetaTile83:
  .byte $00,$00,$00,$a4,$a5,$a4,$b5,$00
MetaTile84:
  .byte $00,$00,$00,$a6,$a7,$b6,$b7,$00
MetaTile85:
  .byte $00,$00,$00,$a8,$a9,$b8,$b9,$00
MetaTile86:
  .byte $02,$00,$00,$00,$aa,$0f,$ba,$00
MetaTile87:
  .byte $02,$00,$00,$ab,$07,$bb,$bc,$00
MetaTile88:
  .byte $00,$00,$00,$ac,$ad,$bd,$be,$00
MetaTile89:
  .byte $00,$00,$00,$ae,$07,$bf,$c0,$00
MetaTile90:
  .byte $03,$00,$00,$0a,$af,$0a,$c1,$00
MetaTile91:
  .byte $03,$00,$00,$b0,$0a,$c2,$0a,$00
MetaTile92:
  .byte $03,$00,$00,$b1,$b2,$c3,$c4,$00
MetaTile93:
  .byte $03,$00,$00,$b3,$b4,$c5,$c6,$00
MetaTile94:
  .byte $02,$00,$00,$c7,$c8,$d2,$d3,$00
MetaTile95:
  .byte $02,$00,$00,$c8,$c8,$d4,$d3,$00
MetaTile96:
  .byte $02,$00,$00,$c8,$c9,$d4,$d5,$00
MetaTile97:
  .byte $00,$00,$00,$ca,$cb,$0f,$d6,$00
MetaTile98:
  .byte $00,$00,$00,$cc,$cd,$d7,$10,$00
MetaTile99:
  .byte $03,$00,$01,$ce,$c8,$d8,$d9,$00
MetaTile100:
  .byte $03,$00,$01,$c8,$c8,$d9,$d9,$00
MetaTile101:
  .byte $03,$00,$01,$c8,$cf,$d9,$da,$00
MetaTile102:
  .byte $00,$00,$00,$0a,$d0,$db,$dc,$00
MetaTile103:
  .byte $00,$00,$00,$d1,$0a,$dd,$de,$00
MetaTile104:
  .byte $01,$00,$00,$0a,$0a,$0a,$2f,$00
MetaTile105:
  .byte $01,$00,$00,$21,$df,$30,$31,$00
MetaTile106:
  .byte $01,$00,$00,$0a,$0a,$32,$0a,$00
MetaTile107:
  .byte $00,$00,$00,$ac,$e0,$0f,$e6,$00
MetaTile108:
  .byte $00,$00,$00,$e1,$07,$e7,$10,$00
MetaTile109:
  .byte $00,$00,$00,$00,$aa,$0f,$ba,$00
MetaTile110:
  .byte $00,$00,$00,$ab,$07,$bb,$bc,$00
MetaTile111:
  .byte $00,$00,$00,$e2,$e3,$0a,$e8,$00
MetaTile112:
  .byte $00,$00,$00,$e4,$e5,$e9,$0a,$00
MetaTile113:
  .byte $01,$00,$00,$3c,$3d,$48,$49,$00
MetaTile114:
  .byte $01,$00,$00,$3e,$3f,$4a,$4b,$00
MetaTile115:
  .byte $01,$00,$00,$40,$41,$4c,$4d,$00
MetaTile116:
  .byte $03,$00,$00,$ac,$ad,$bd,$be,$00
MetaTile117:
  .byte $03,$00,$00,$ae,$07,$bf,$c0,$00
MetaTile118:
  .byte $00,$00,$00,$c7,$c8,$d2,$d3,$00
MetaTile119:
  .byte $00,$00,$00,$c8,$c8,$d4,$d3,$00
MetaTile120:
  .byte $00,$00,$00,$c8,$c9,$d4,$d5,$00
MetaTile121:
  .byte $00,$00,$00,$0a,$ea,$0a,$ec,$00
MetaTile122:
  .byte $00,$00,$00,$eb,$0a,$ed,$0a,$00
MetaTile123:
  .byte $01,$00,$00,$54,$55,$5f,$55,$00
MetaTile124:
  .byte $01,$00,$00,$56,$57,$60,$61,$00
MetaTile125:
  .byte $01,$00,$00,$58,$59,$58,$62,$00
MetaTile126:
  .byte $03,$00,$00,$ca,$cb,$0f,$d6,$00
MetaTile127:
  .byte $03,$00,$00,$cc,$cd,$d7,$10,$00
MetaTile128:
  .byte $03,$00,$00,$0a,$d0,$db,$dc,$00
MetaTile129:
  .byte $03,$00,$00,$d1,$0a,$dd,$de,$00
MetaTile130:
  .byte $01,$00,$00,$69,$6a,$73,$74,$00
MetaTile131:
  .byte $01,$00,$00,$6b,$6c,$75,$76,$00
MetaTile132:
  .byte $01,$00,$00,$58,$6d,$77,$78,$00
MetaTile133:
  .byte $03,$00,$00,$ac,$e0,$0f,$e6,$00
MetaTile134:
  .byte $03,$00,$00,$e1,$07,$e7,$10,$00
MetaTile135:
  .byte $03,$00,$00,$e2,$e3,$0a,$e8,$00
MetaTile136:
  .byte $03,$00,$00,$e4,$e5,$e9,$0a,$00
MetaTile137:
  .byte $01,$00,$00,$0a,$7d,$0a,$0a,$00
MetaTile138:
  .byte $01,$00,$01,$7e,$7f,$0a,$0a,$00
MetaTile139:
  .byte $01,$00,$01,$80,$81,$0a,$0a,$00
MetaTile140:
  .byte $01,$00,$01,$82,$83,$0a,$0a,$00
MetaTile141:
  .byte $01,$00,$00,$84,$0a,$0a,$0a,$00
MetaTile142:
  .byte $03,$00,$00,$0a,$ea,$0a,$ec,$00
MetaTile143:
  .byte $03,$00,$00,$eb,$0a,$ed,$0a,$00
MetaTile144:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_exit
MetaTile145:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_beedie
MetaTile146:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_skelekin
MetaTile147:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_mouse
MetaTile148:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_bat
MetaTile149:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_grank
MetaTile150:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_deentle
MetaTile151:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_spear
MetaTile152:
  .byte $00,$00,$00,$00,$07,$0f,$10,entity_index_grank
MetaTile153:
  .byte $01,$00,$00,$58,$6d,$77,$78,entity_index_beedie
MetaTile154:
  .byte $00,$00,$00,$00,$07,$0f,$10,entity_index_bat
MetaTile155:
  .byte $00,$00,$00,$00,$07,$0f,$10,entity_index_deentle
MetaTile156:
  .byte $01,$00,$00,$6b,$6c,$75,$76,entity_index_skelekin
MetaTile157:
  .byte $00,$00,$00,$96,$96,$96,$96,entity_index_beedie
MetaTile158:
  .byte $00,$00,$00,$96,$96,$96,$96,entity_index_flail
MetaTile159:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_flail
MetaTile160:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_restart
MetaTile161:
  .byte $01,$00,$00,$6b,$6c,$75,$76,entity_index_deentle
MetaTile162:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_one_up
MetaTile163:
  .byte $01,$00,$00,$08,$09,$15,$16,$00
MetaTile164:
  .byte $01,$00,$00,$0d,$0e,$19,$1a,entity_index_exit
MetaTile165:
  .byte $01,$00,$00,$0d,$0e,$19,$1a,$00
MetaTile166:
  .byte $01,$00,$00,$0d,$0e,$19,$1a,entity_index_setrightmostx
MetaTile167:
  .byte $03,$00,$01,$0a,$af,$0a,$c1,$00
MetaTile168:
  .byte $00,$00,$01,$0a,$0a,$0a,$0a,$00
MetaTile169:
  .byte $03,$00,$01,$b0,$0a,$c2,$0a,$00
MetaTile170:
  .byte $01,$00,$00,$69,$6a,$73,$74,entity_index_skelekin
MetaTile171:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_warpzone
MetaTile172:
  .byte $01,$00,$00,$0d,$0e,$19,$1a,$00
