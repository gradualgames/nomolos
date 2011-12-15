.include "soundengine.inc"
.include "spritesheet_common.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export boss1_sprite_groups
boss1_sprite_groups:
  .byte $05
  .byte entity_index_nomolos
  .byte entity_index_explosion
  .byte entity_index_iceball
  .byte entity_index_stalactite
  .byte entity_index_dragonboss

.segment "ROM08"

.include "boss1_patterns_source.inc"

.segment "ROM05"

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
  .word 0
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
  .byte 13,11,10,8,5,1,ENV_STOP
volume_envelope_3:
  .byte 5,11,11,7,3,ENV_STOP
volume_envelope_4:
  .byte 2,3,3,5,7,10,12,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,6,D1,E1,F1,A1,F1,A1,D2,A1,F1,A1,F1,E1,D1,E1,F1,A1
  .byte F1,A1,D2,A1,F1,A1,F1,E1,CS1,E1,F1,A1,F1,A1,CS2,A1,F1,A1,F1,E1,CS1,E1,F1,A1
  .byte F1,A1,CS2,A1,F1,A1,F1,E1,D1,E1,F1,A1,F1,A1,D2,A1,F1,A1,F1,E1,D1,E1,F1,A1
  .byte F1,A1,D2,A1,F1,A1,F1,E1,CS1,E1,F1,A1,F1,A1,CS2,A1,F1,A1,F1,E1,CS1,E1,F1,A1
  .byte F1,A1,CS2,A1,F1,A1,F1,E1,D1,E1,F1,A1,F1,A1,D2,A1,F1,A1,F1,E1,D1,E1,F1,A1
  .byte F1,A1,D2,A1,F1,A1,F1,E1,G1,A1,AS1,D2,AS1,D2,G2,D2,AS1,D2,AS1,A1,G1,A1,AS1,D2
  .byte AS1,D2,G2,D2,AS1,D2,AS1,A1,C1,D1,E1,G1,E1,G1,C2,G1,E1,G1,E1,D1,C1,D1,E1,G1
  .byte E1,G1,C2,G1,E1,G1,E1,D1,F1,G1,A1,C2,A1,C2,F2,C2,A1,C2,A1,G1,F1,G1,A1,C2
  .byte A1,C2,F2,C2,A1,C2,A1,G1,AS2,C3,D3,F3,D3,F3,AS3,F3,D3,F3,D3,C3,AS2,C3,D3,F3
  .byte D3,F3,AS3,F3,D3,F3,D3,C3,E2,F2,G2,CS3,G2,CS3,E3,CS3,G2,CS3,G2,F2,E2,F2,G2,CS3
  .byte G2,CS3,E3,CS3,G2,CS3,G2,F2,A2,F3,D3,F3,D3,F3,A2,F3,D3,F3,D3,F3,A2,F3,D3,F3
  .byte D3,F3,A2,F3,D3,F3,D3,F3,A2,E3,D3,E3,D3,E3,A2,E3,D3,E3,D3,E3,A2,E3,CS3,E3
  .byte CS3,E3,CS3,E3,A2,E3,CS3,E3
  .byte GOT
  .word Square1

Square2:
  .byte STV,3,STP,0,SDU,0,STL,48,D2,STL,24,E2,F2,D2,STL,12,E2,F2,STL,72,E2,A2,STL,48
  .byte D2,STL,24,E2,F2,D2,STL,12,E2,F2,STL,72,E2,A2,STL,24,D2,E2,F2,D2,E2,F2,STL,48
  .byte AS2,STL,24,A2,STL,72,G2,STL,24,C2,D2,E2,C2,D2,E2,STL,48,A2,STL,24,G2,STL,72,F2
  .byte STL,12,F2,AS1,F2,AS1,F2,AS1,F2,AS1,F2,AS1,F2,AS1,CS2,G1,CS2,G2,CS3,G2,CS3,G2,CS3,G2
  .byte CS3,STV,2,G2,STV,4,STL,72,A2,STL,24,G2,A2,AS2,STL,72,A2,CS3
  .byte GOT
  .word Square2

Triangle:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,198,A0
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,255,A0,STL,198,A0
  .byte GOT
  .word Noise

.export boss1_palette
boss1_palette:
  .byte $0d,$12,$32,$22,$0d,$33,$23,$13,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d
  .byte $0d,$0d,$27,$20,$0d,$0d,$04,$29,$0d,$12,$21,$20,$0d,$32,$20,$05
  
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
  .byte $00,$00,$00,$01,$02,$03,$04,$05,$06,$00,$00,$00,$00,$00,$00,$00
MapColumnTable:
  .byte $00,$00,$00,$00
  .byte $00,$00,$01,$00
  .byte $00,$02,$03,$00
  .byte $00,$04,$05,$00
  .byte $00,$06,$07,$00
  .byte $00,$08,$00,$00
  .byte $00,$09,$00,$00
AttributeColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$50,$00
MetaTileColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00
  .byte $00,$00,$00,$00,$04,$09,$0f,$19,$00,$00,$00,$00,$39,$40,$00,$00
  .byte $00,$00,$00,$01,$05,$0c,$12,$1a,$1d,$21,$29,$2f,$3a,$40,$00,$00
  .byte $00,$00,$00,$02,$06,$0b,$13,$1b,$1e,$22,$2a,$30,$3b,$40,$00,$00
  .byte $00,$00,$00,$03,$07,$0d,$14,$14,$14,$14,$14,$31,$3c,$40,$00,$00
  .byte $00,$00,$00,$00,$08,$0e,$15,$1c,$1f,$14,$2b,$32,$3d,$40,$00,$00
  .byte $00,$00,$00,$00,$42,$44,$46,$48,$20,$23,$2c,$33,$3e,$40,$00,$00
  .byte $00,$00,$00,$00,$43,$45,$47,$49,$4a,$24,$27,$34,$3f,$40,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$25,$28,$27,$38,$40,$00,$00
  .byte $4b,$4b,$4b,$4b,$4b,$4b,$4b,$4b,$4b,$4b,$4b,$4b,$4b,$40,$00,$00
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
  .byte $00,$01,$00,$00,$09,$13,$14,$00
MetaTile5:
  .byte $00,$01,$00,$0a,$0b,$15,$16,$00
MetaTile6:
  .byte $00,$01,$00,$0c,$0d,$17,$18,$00
MetaTile7:
  .byte $00,$01,$00,$0e,$0f,$0d,$19,$00
MetaTile8:
  .byte $00,$01,$00,$10,$11,$1a,$1b,$00
MetaTile9:
  .byte $00,$01,$00,$1f,$20,$2c,$2d,$00
MetaTile10:
  .byte $00,$01,$00,$21,$22,$2e,$2f,$00
MetaTile11:
  .byte $00,$01,$00,$23,$24,$30,$31,$00
MetaTile12:
  .byte $00,$01,$00,$21,$22,$2e,$32,entity_index_dragonboss
MetaTile13:
  .byte $00,$01,$00,$25,$26,$33,$33,$00
MetaTile14:
  .byte $00,$01,$00,$27,$28,$34,$35,$00
MetaTile15:
  .byte $00,$01,$00,$3a,$3b,$47,$48,$00
MetaTile16:
  .byte $00,$01,$00,$3c,$3d,$49,$4a,$00
MetaTile17:
  .byte $00,$01,$00,$00,$3e,$4b,$4c,$00
MetaTile18:
  .byte $00,$01,$00,$3f,$40,$4d,$4e,$00
MetaTile19:
  .byte $00,$01,$00,$00,$3e,$4f,$4c,$00
MetaTile20:
  .byte $00,$01,$00,$33,$33,$33,$33,$00
MetaTile21:
  .byte $00,$01,$00,$41,$42,$50,$51,$00
MetaTile22:
  .byte $00,$01,$00,$56,$57,$66,$67,$00
MetaTile23:
  .byte $00,$01,$00,$58,$59,$68,$69,$00
MetaTile24:
  .byte $00,$01,$00,$5a,$5b,$6a,$6b,$00
MetaTile25:
  .byte $00,$01,$00,$56,$5c,$66,$6c,$00
MetaTile26:
  .byte $00,$01,$00,$5d,$5e,$6d,$6e,$00
MetaTile27:
  .byte $00,$01,$00,$5f,$5b,$6f,$6b,$00
MetaTile28:
  .byte $00,$01,$00,$60,$61,$70,$71,$00
MetaTile29:
  .byte $00,$01,$00,$76,$77,$7f,$80,$00
MetaTile30:
  .byte $00,$01,$00,$78,$79,$81,$25,$00
MetaTile31:
  .byte $00,$01,$00,$25,$7a,$33,$25,$00
MetaTile32:
  .byte $00,$01,$00,$7b,$7c,$82,$83,$00
MetaTile33:
  .byte $00,$01,$00,$86,$87,$8c,$8d,$00
MetaTile34:
  .byte $00,$01,$00,$88,$33,$8e,$33,$00
MetaTile35:
  .byte $00,$01,$00,$25,$89,$33,$25,$00
MetaTile36:
  .byte $00,$01,$00,$8a,$8b,$25,$8f,$00
MetaTile37:
  .byte $00,$00,$00,$00,$00,$90,$00,$00
MetaTile38:
  .byte $00,$01,$00,$91,$92,$9c,$9d,$00
MetaTile39:
  .byte $00,$01,$00,$33,$25,$33,$33,$00
MetaTile40:
  .byte $00,$01,$00,$93,$94,$25,$9e,$00
MetaTile41:
  .byte $00,$01,$00,$95,$96,$9f,$a0,$00
MetaTile42:
  .byte $00,$01,$00,$97,$98,$a1,$25,$00
MetaTile43:
  .byte $00,$01,$00,$99,$33,$a2,$33,$00
MetaTile44:
  .byte $00,$01,$00,$9a,$9b,$a3,$a4,$00
MetaTile45:
  .byte $00,$01,$00,$9c,$9c,$9c,$9c,$00
MetaTile46:
  .byte $00,$01,$00,$a5,$33,$9c,$ad,$00
MetaTile47:
  .byte $00,$01,$00,$a6,$25,$ae,$33,$00
MetaTile48:
  .byte $00,$01,$00,$a7,$33,$af,$33,$00
MetaTile49:
  .byte $00,$01,$00,$33,$a8,$b0,$b1,$00
MetaTile50:
  .byte $00,$01,$00,$a9,$33,$b2,$b2,$00
MetaTile51:
  .byte $00,$01,$00,$aa,$ab,$b3,$b4,$00
MetaTile52:
  .byte $00,$01,$00,$ac,$33,$b5,$b6,$00
MetaTile53:
  .byte $00,$01,$00,$b7,$b8,$cc,$cd,$00
MetaTile54:
  .byte $00,$01,$00,$b9,$ba,$ce,$cf,$00
MetaTile55:
  .byte $00,$01,$00,$bb,$bc,$d0,$d1,$00
MetaTile56:
  .byte $00,$01,$00,$bd,$be,$d2,$d3,$00
MetaTile57:
  .byte $00,$01,$00,$00,$bf,$d4,$d5,$00
MetaTile58:
  .byte $00,$01,$00,$c0,$c1,$d6,$d7,$00
MetaTile59:
  .byte $00,$01,$00,$c2,$c3,$d8,$d9,$00
MetaTile60:
  .byte $00,$01,$00,$c4,$c5,$da,$db,$00
MetaTile61:
  .byte $00,$01,$00,$c6,$c7,$dc,$dd,$00
MetaTile62:
  .byte $00,$01,$00,$c8,$c9,$de,$df,$00
MetaTile63:
  .byte $00,$01,$00,$ca,$cb,$d0,$d1,$00
MetaTile64:
  .byte $01,$00,$01,$e0,$e1,$e2,$e3,$00
MetaTile65:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_exit
MetaTile66:
  .byte $00,$01,$00,$12,$00,$1c,$1d,$00
MetaTile67:
  .byte $00,$00,$00,$00,$00,$1e,$00,$00
MetaTile68:
  .byte $00,$01,$00,$29,$2a,$36,$37,$00
MetaTile69:
  .byte $00,$01,$00,$2b,$00,$38,$39,$00
MetaTile70:
  .byte $00,$01,$00,$43,$44,$52,$53,$00
MetaTile71:
  .byte $00,$01,$00,$45,$46,$54,$55,$00
MetaTile72:
  .byte $00,$01,$00,$62,$63,$72,$73,$00
MetaTile73:
  .byte $00,$01,$00,$64,$65,$74,$75,$00
MetaTile74:
  .byte $00,$01,$00,$7d,$7e,$84,$85,$00
MetaTile75:
  .byte $00,$00,$01,$00,$00,$00,$00,$00
