.include "soundengine.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export level5_sprite_groups
level5_sprite_groups:
  .byte $04
  .word spritesheet1_Nomolos_chr
  .word spritesheet1_statue_chr
  .word spritesheet1_raven_chr
  .word spritesheet1_Explosion_chr

.segment "ROM09"

.include "level5_patterns_source.inc"

.segment "ROM04"

.export level5_palette
level5_palette:
  .byte $0d,$0b,$1b,$12,$0d,$0a,$00,$2c,$0d,$07,$16,$26,$0d,$1b,$00,$10
  .byte $0d,$0d,$27,$20,$0d,$04,$29,$0d,$0d,$0d,$28,$20,$0d,$0d,$00,$29

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
  .byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$12,$13,$12,$14,$15,$15,$15,$15,$15,$15,$15,$15,$15
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15

MapColumnTable:
  .byte $00,$00,$01,$00
  .byte $01,$02,$03,$00
  .byte $02,$04,$05,$00
  .byte $03,$06,$07,$00
  .byte $04,$08,$09,$00
  .byte $05,$0a,$0b,$00
  .byte $06,$0c,$0d,$00
  .byte $06,$0e,$0f,$00
  .byte $06,$10,$11,$00
  .byte $06,$12,$13,$00
  .byte $06,$0b,$0c,$00
  .byte $06,$0d,$14,$00
  .byte $06,$0f,$10,$00
  .byte $06,$11,$12,$00
  .byte $07,$13,$15,$00
  .byte $08,$16,$17,$00
  .byte $08,$18,$19,$00
  .byte $08,$1a,$1b,$00
  .byte $08,$1c,$1b,$00
  .byte $08,$1d,$1e,$00
  .byte $08,$1c,$1f,$00
  .byte $08,$1f,$1f,$00
AttributeColumnTable:
  .byte $00,$00,$00,$3f,$33,$33,$a3,$00
  .byte $00,$00,$00,$0f,$00,$40,$a5,$00
  .byte $00,$00,$00,$0f,$00,$00,$a0,$00
  .byte $00,$00,$00,$0f,$00,$00,$a1,$00
  .byte $00,$00,$00,$0f,$00,$10,$a1,$00
  .byte $00,$00,$00,$33,$33,$33,$a3,$00
  .byte $00,$00,$00,$00,$00,$00,$a0,$00
  .byte $00,$00,$00,$00,$00,$00,$20,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTileColumnTable:
  .byte $01,$09,$13,$00,$00,$00,$33,$3d,$40,$40,$40,$40,$47,$49,$00,$00
  .byte $02,$08,$14,$00,$00,$00,$34,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $00,$0a,$15,$00,$00,$00,$35,$00,$00,$00,$00,$00,$45,$49,$00,$00
  .byte $03,$0b,$0d,$00,$00,$00,$35,$00,$00,$00,$00,$3f,$46,$49,$00,$00
  .byte $04,$0c,$0d,$00,$00,$00,$35,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $05,$0d,$0d,$00,$00,$00,$35,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $06,$0e,$0d,$00,$00,$00,$35,$00,$00,$00,$00,$00,$45,$49,$00,$00
  .byte $01,$07,$16,$00,$00,$00,$35,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $02,$08,$0f,$00,$00,$00,$35,$00,$00,$00,$00,$3f,$46,$49,$00,$00
  .byte $01,$09,$14,$00,$00,$00,$36,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $02,$08,$14,$00,$00,$00,$33,$3d,$40,$40,$40,$40,$47,$49,$00,$00
  .byte $00,$0a,$15,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $03,$0b,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $04,$0c,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $05,$0d,$0d,$00,$00,$4c,$00,$00,$00,$00,$00,$00,$4b,$49,$00,$00
  .byte $06,$0e,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $01,$07,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $02,$08,$0f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $01,$09,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $02,$08,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $05,$0d,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00
  .byte $00,$0a,$15,$4a,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $03,$0b,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $04,$0c,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $05,$0d,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $06,$0e,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$0f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$22,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $1f,$23,$0f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
MetaTileTable:
MetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $00,$00,$00,$00,$01,$00,$04,$00
MetaTile2:
  .byte $00,$00,$00,$00,$00,$05,$06,$00
MetaTile3:
  .byte $00,$00,$00,$00,$00,$00,$07,$00
MetaTile4:
  .byte $00,$00,$00,$00,$02,$08,$09,$00
MetaTile5:
  .byte $00,$00,$00,$03,$00,$0a,$0b,$00
MetaTile6:
  .byte $00,$00,$00,$00,$00,$0c,$00,$00
MetaTile7:
  .byte $00,$00,$00,$0d,$0e,$1a,$00,$00
MetaTile8:
  .byte $00,$00,$00,$0f,$10,$00,$00,$00
MetaTile9:
  .byte $00,$00,$00,$11,$0e,$00,$00,$00
MetaTile10:
  .byte $00,$00,$00,$12,$13,$00,$1b,$00
MetaTile11:
  .byte $00,$00,$00,$14,$15,$1c,$1d,$00
MetaTile12:
  .byte $00,$00,$00,$16,$17,$1e,$1f,$00
MetaTile13:
  .byte $00,$00,$00,$16,$17,$20,$1f,$00
MetaTile14:
  .byte $00,$00,$00,$18,$19,$21,$22,$00
MetaTile15:
  .byte $00,$00,$00,$23,$24,$30,$31,$00
MetaTile16:
  .byte $00,$00,$00,$25,$26,$32,$33,$00
MetaTile17:
  .byte $01,$00,$00,$27,$28,$34,$35,$00
MetaTile18:
  .byte $01,$00,$00,$29,$2a,$36,$37,$00
MetaTile19:
  .byte $00,$00,$00,$2b,$24,$38,$31,$00
MetaTile20:
  .byte $00,$00,$00,$25,$26,$32,$39,$00
MetaTile21:
  .byte $00,$00,$00,$2c,$2d,$3a,$3b,$00
MetaTile22:
  .byte $00,$00,$00,$2e,$2f,$3c,$3d,$00
MetaTile23:
  .byte $01,$00,$00,$3e,$3f,$44,$45,$00
MetaTile24:
  .byte $03,$00,$00,$40,$41,$46,$47,$00
MetaTile25:
  .byte $01,$00,$00,$42,$43,$48,$49,$00
MetaTile26:
  .byte $03,$00,$00,$4a,$4b,$4e,$4f,$00
MetaTile27:
  .byte $00,$00,$00,$4c,$4d,$50,$51,$00
MetaTile28:
  .byte $01,$00,$00,$52,$53,$59,$5a,$00
MetaTile29:
  .byte $03,$00,$00,$54,$55,$5b,$5c,$00
MetaTile30:
  .byte $01,$00,$00,$56,$57,$5d,$5e,$00
MetaTile31:
  .byte $00,$00,$00,$00,$58,$5f,$60,$00
MetaTile32:
  .byte $03,$00,$00,$00,$00,$61,$62,$00
MetaTile33:
  .byte $03,$00,$00,$63,$64,$6a,$6b,$00
MetaTile34:
  .byte $00,$00,$00,$00,$65,$00,$00,$00
MetaTile35:
  .byte $00,$00,$00,$66,$67,$00,$00,$00
MetaTile36:
  .byte $03,$00,$01,$68,$69,$6c,$6d,$00
MetaTile37:
  .byte $03,$00,$01,$6e,$6f,$70,$71,$00
MetaTile38:
  .byte $01,$00,$01,$72,$73,$80,$81,$00
MetaTile39:
  .byte $01,$00,$01,$74,$75,$82,$81,$00
MetaTile40:
  .byte $01,$00,$01,$76,$77,$83,$84,$00
MetaTile41:
  .byte $02,$00,$01,$78,$79,$85,$86,$00
MetaTile42:
  .byte $02,$00,$01,$7a,$7b,$87,$88,$00
MetaTile43:
  .byte $02,$00,$01,$7c,$7d,$89,$8a,$00
MetaTile44:
  .byte $03,$00,$01,$7e,$7f,$8b,$8c,$00
MetaTile45:
  .byte $01,$00,$01,$8d,$8e,$9e,$9f,$00
MetaTile46:
  .byte $01,$00,$01,$8f,$90,$a0,$a1,$00
MetaTile47:
  .byte $01,$00,$01,$8f,$91,$a0,$a2,$00
MetaTile48:
  .byte $02,$00,$01,$92,$93,$a3,$a4,$00
MetaTile49:
  .byte $02,$00,$01,$94,$93,$a5,$a4,$00
MetaTile50:
  .byte $02,$00,$01,$94,$95,$a5,$a6,$00
MetaTile51:
  .byte $03,$00,$01,$96,$97,$a7,$a8,$00
MetaTile52:
  .byte $03,$00,$01,$98,$99,$a9,$aa,$00
MetaTile53:
  .byte $03,$00,$01,$9a,$9b,$00,$ab,$00
MetaTile54:
  .byte $03,$00,$01,$9c,$9d,$ac,$ad,$00
MetaTile55:
  .byte $01,$00,$01,$ae,$af,$bc,$bd,$00
MetaTile56:
  .byte $01,$00,$01,$b0,$b1,$be,$bf,$00
MetaTile57:
  .byte $01,$00,$01,$b2,$b3,$c0,$c1,$00
MetaTile58:
  .byte $02,$00,$01,$b4,$b5,$c2,$c3,$00
MetaTile59:
  .byte $02,$00,$01,$94,$93,$c4,$c5,$00
MetaTile60:
  .byte $02,$00,$01,$b6,$b7,$c6,$c7,$00
MetaTile61:
  .byte $03,$00,$01,$b8,$b9,$c8,$c9,$00
MetaTile62:
  .byte $02,$00,$01,$ba,$bb,$ca,$cb,$00
MetaTile63:
  .byte $01,$00,$00,$cc,$cd,$d1,$d2,$00
MetaTile64:
  .byte $03,$00,$01,$ce,$cf,$ce,$cf,$00
MetaTile65:
  .byte $02,$00,$01,$d0,$cf,$d3,$cf,$00
MetaTile66:
  .byte $02,$00,$01,$d4,$d5,$e2,$e3,$00
MetaTile67:
  .byte $02,$00,$01,$d6,$d7,$e4,$e5,$00
MetaTile68:
  .byte $02,$00,$01,$d8,$d9,$e6,$e7,$00
MetaTile69:
  .byte $01,$00,$00,$da,$db,$e8,$e9,$00
MetaTile70:
  .byte $01,$00,$00,$dc,$dd,$ea,$eb,$00
MetaTile71:
  .byte $03,$00,$01,$de,$df,$ec,$ed,$00
MetaTile72:
  .byte $02,$00,$01,$e0,$e1,$ee,$ef,$00
MetaTile73:
  .byte $02,$00,$01,$f0,$f1,$f2,$f3,$00
MetaTile74:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_exit
MetaTile75:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_statue
MetaTile76:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_raven
