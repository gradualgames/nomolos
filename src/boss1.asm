.include "soundengine.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"

.segment "CODE"

.export boss1_sprite_groups
boss1_sprite_groups:
  .byte $03
  .word spritesheet1_Nomolos_chr
  .word spritesheet1_Explosion_chr
  .word spritesheet1_IceBall_chr

.segment "ROM4"

.include "boss1_patterns_source.inc"

.segment "ROM1"

.export boss1_music
boss1_music:
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
  .word 0
  .word 0
  .word 0

  .word 0
  .word 0
  .word 0
  .word 0

  .word sf_volume_envelope_silence
  .word sf_volume_envelope_loud
  .word sf_volume_envelope_1
  .word sf_volume_envelope_decay
  .word sf_volume_envelope_short_note

  .word sf_volume_envelope_fade_in
  .word sf_volume_envelope_fade_in_2
  .word 0
  .word 0
  .word 0

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

  .word sf_pitch_envelope_0
  .word sf_pitch_envelope_1
  .word 0
  .word 0
  .word 0

  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 12,10,6,4,3,4,5,8,10,8,5,3,3,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte -128,ENV_LOOP

Square1:
  .byte STV,0,STL,21,A0,STV,2,STP,0,SDU,1,GS4,C5,GS4,F4,C4,CS4,GS3,AS3,G4,AS4,G4,E4,C4
  .byte CS4,AS3,C4,F4,GS4,F4,C4,GS3,F3,C3,CS4,E3,F3,C4,G3,AS3,GS3,G3,STV,0,STL,126,A0,STV
  .byte 2,STL,14,E4,F4,G4,F4,E4,STL,98,F4,STL,14,E4,F4,G4,F4,E4,STL,98,F4,STL,14,D4
  .byte DS4,F4,DS4,D4,STL,98,C4,STL,14,B3,C4,D4,C4,B3,STL,98,C4,STL,14,B3,C4,D4,STL,21
  .byte G4,F4,F4,DS4,DS4,D4,D4,C4,STL,126,B3,STL,14,C4,B3,C4,STL,126,D4,STL,14,C4,B3,C4
  .byte STL,126,D4,STL,14,D4,DS4,F4,DS4,D4,STL,98,C4,STL,14,D4,DS4,F4,STL,21,G3,F4,DS4,C4
  .byte F4,D4,C4,B3,STL,168,C4
  .byte GOT
  .word Square1

Square2:
  .byte STV,2,STP,0,SDU,1,STL,84,F2,F2,G2,G2,GS3,GS3,STL,42,AS3,GS3,G3,C3,STL,21,F2,F3
  .byte GS3,F3,CS3,AS2,G2,E3,GS2,F3,GS3,F3,CS3,AS2,G2,E3,GS2,F3,GS3,F3,D3,F3,G2,B2,C2,C3
  .byte DS3,C3,GS2,C3,D2,B2,DS2,C3,DS3,C3,GS2,C3,D2,B2,STL,42,DS2,C3,F2,GS2,STL,21,G2,F3
  .byte GS3,F3,D3,F3,GS2,F3,G2,F3,GS3,F3,D3,F3,GS2,F3,G2,F3,GS3,F3,D3,F3,G2,B2,C2,C3
  .byte DS3,C3,GS2,C3,F2,GS2,STL,84,G1,G1,STL,168,C1
  .byte GOT
  .word Square2

Triangle:
  .byte STV,0,STL,168,A0,STV,2,STP,0,SDU,1,STL,84,F3,E3,F3,C3,STL,42,CS3,C3,AS2,C3,STV
  .byte 0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,231
  .byte A0
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL
  .byte 255,A0,STL,255,A0,STL,255,A0,STL,138,A0
  .byte GOT
  .word Noise

.export boss1_palette
boss1_palette:
  .byte $0d,$12,$32,$22,$0d,$33,$23,$13,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d
  .byte $0d,$0d,$27,$20,$0d,$04,$11,$0d,$0d,$0d,$20,$06,$0d,$0d,$20,$32

.export boss1_cycling_palettes
boss1_cycling_palettes:
  .byte 3
  .byte $0d,$03,$12,$21,$0d,$12,$20,$21,$0d,$24,$14,$04,$0d,$13,$33,$23
  .byte $0d,$03,$12,$21,$0d,$20,$21,$12,$0d,$24,$14,$04,$0d,$13,$33,$23
  .byte $0d,$03,$12,$21,$0d,$21,$12,$20,$0d,$24,$14,$04,$0d,$13,$33,$23

.export boss1_map
boss1_map = Map

.export boss1_map_column_table
boss1_map_column_table = MapColumnTable

.export boss1_attribute_column_table
boss1_attribute_column_table = AttributeColumnTable

.export boss1_meta_tile_column_table
boss1_meta_tile_column_table = MetaTileColumnTable

.export boss1_meta_tile_table
boss1_meta_tile_table = MetaTileTable

Map:
  .byte $00,$01,$01,$02,$03,$04,$05,$06
MapColumnTable:
  .byte $00,$00,$01,$00
  .byte $00,$01,$01,$00
  .byte $00,$01,$02,$00
  .byte $00,$03,$04,$00
  .byte $00,$05,$06,$00
  .byte $00,$07,$08,$00
  .byte $00,$09,$00,$00
AttributeColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$05,$00
MetaTileColumnTable:
  .byte $35,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$34,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$34,$00,$00,$00
  .byte $00,$00,$00,$04,$09,$0e,$13,$00,$00,$00,$00,$2c,$34,$00,$00,$00
  .byte $00,$00,$01,$05,$0a,$0f,$14,$17,$1b,$20,$26,$2d,$34,$00,$00,$00
  .byte $00,$00,$02,$06,$0b,$10,$15,$18,$1c,$21,$27,$2e,$34,$00,$00,$00
  .byte $00,$00,$03,$07,$0c,$11,$11,$11,$11,$11,$28,$2f,$34,$00,$00,$00
  .byte $00,$00,$00,$08,$0d,$12,$16,$19,$11,$22,$29,$30,$34,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$1a,$1d,$23,$2a,$31,$34,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$1e,$24,$2b,$32,$34,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$1f,$25,$24,$33,$34,$00,$00,$00
MetaTileTable:
MetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $00,$01,$00,$00,$01,$00,$04,$00
MetaTile2:
  .byte $00,$01,$00,$02,$03,$05,$06,$00
MetaTile3:
  .byte $00,$01,$00,$00,$00,$07,$08,$00
MetaTile4:
  .byte $00,$01,$00,$00,$09,$10,$11,$00
MetaTile5:
  .byte $00,$01,$00,$0a,$0b,$12,$13,$00
MetaTile6:
  .byte $00,$01,$00,$0c,$0d,$14,$15,$00
MetaTile7:
  .byte $00,$01,$00,$0e,$0f,$0d,$16,$00
MetaTile8:
  .byte $00,$01,$00,$00,$00,$17,$18,$00
MetaTile9:
  .byte $00,$01,$00,$19,$1a,$23,$24,$00
MetaTile10:
  .byte $00,$01,$00,$1b,$1c,$25,$26,$00
MetaTile11:
  .byte $00,$01,$00,$1d,$1e,$27,$28,$00
MetaTile12:
  .byte $00,$01,$00,$1f,$20,$29,$29,$00
MetaTile13:
  .byte $00,$01,$00,$21,$22,$2a,$2b,$00
MetaTile14:
  .byte $00,$01,$00,$2c,$2d,$33,$34,$00
MetaTile15:
  .byte $00,$01,$00,$2e,$2f,$35,$36,$00
MetaTile16:
  .byte $00,$01,$00,$00,$30,$37,$38,$00
MetaTile17:
  .byte $00,$01,$00,$29,$29,$29,$29,$00
MetaTile18:
  .byte $00,$01,$00,$31,$32,$39,$3a,$00
MetaTile19:
  .byte $00,$01,$00,$3b,$3c,$42,$43,$00
MetaTile20:
  .byte $00,$01,$00,$3d,$3e,$44,$45,$00
MetaTile21:
  .byte $00,$01,$00,$3f,$40,$46,$47,$00
MetaTile22:
  .byte $00,$01,$00,$41,$00,$48,$49,$00
MetaTile23:
  .byte $00,$01,$00,$4a,$4b,$4f,$50,$00
MetaTile24:
  .byte $00,$01,$00,$4c,$4d,$51,$1f,$00
MetaTile25:
  .byte $00,$01,$00,$1f,$4e,$29,$1f,$00
MetaTile26:
  .byte $00,$01,$00,$00,$00,$52,$53,$00
MetaTile27:
  .byte $00,$01,$00,$54,$55,$5a,$5b,$00
MetaTile28:
  .byte $00,$01,$00,$56,$29,$5c,$29,$00
MetaTile29:
  .byte $00,$01,$00,$1f,$57,$29,$1f,$00
MetaTile30:
  .byte $00,$01,$00,$58,$59,$1f,$5d,$00
MetaTile31:
  .byte $00,$01,$00,$00,$00,$53,$00,$00
MetaTile32:
  .byte $00,$01,$00,$5e,$5f,$67,$68,$00
MetaTile33:
  .byte $00,$01,$00,$60,$61,$69,$1f,$00
MetaTile34:
  .byte $00,$01,$00,$62,$29,$6a,$29,$00
MetaTile35:
  .byte $00,$01,$00,$63,$64,$6b,$6c,$00
MetaTile36:
  .byte $00,$01,$00,$29,$1f,$29,$29,$00
MetaTile37:
  .byte $00,$01,$00,$65,$66,$1f,$6d,$00
MetaTile38:
  .byte $00,$01,$00,$6e,$1f,$75,$29,$00
MetaTile39:
  .byte $00,$01,$00,$6f,$29,$76,$29,$00
MetaTile40:
  .byte $00,$01,$00,$29,$70,$77,$78,$00
MetaTile41:
  .byte $00,$01,$00,$71,$29,$79,$79,$00
MetaTile42:
  .byte $00,$01,$00,$72,$73,$7a,$7b,$00
MetaTile43:
  .byte $00,$01,$00,$74,$29,$7c,$7d,$00
MetaTile44:
  .byte $00,$01,$00,$00,$7e,$8d,$8e,$00
MetaTile45:
  .byte $00,$01,$00,$7f,$80,$8f,$90,$00
MetaTile46:
  .byte $00,$01,$00,$81,$82,$91,$92,$00
MetaTile47:
  .byte $00,$01,$00,$83,$84,$93,$94,$00
MetaTile48:
  .byte $00,$01,$00,$85,$86,$95,$96,$00
MetaTile49:
  .byte $00,$01,$00,$87,$88,$97,$98,$00
MetaTile50:
  .byte $00,$01,$00,$89,$8a,$99,$9a,$00
MetaTile51:
  .byte $00,$01,$00,$8b,$8c,$9b,$9c,$00
MetaTile52:
  .byte $01,$00,$01,$9d,$9e,$9f,$a0,$00
MetaTile53:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_exit
