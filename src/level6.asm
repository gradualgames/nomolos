.include "soundengine.inc"
.include "spritesheet_common.inc"
.include "spritesheet2.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export level6_sprite_groups
level6_sprite_groups:
  .byte $08
  .byte entity_index_nomolos
  .byte entity_index_explosion
  .byte entity_index_bat
  .byte entity_index_gort
  .byte entity_index_hippocritter
  .byte entity_index_armoredskelekin
  .byte entity_index_attacknid
  .byte entity_index_laser

.segment "ROM09"

.include "level6_patterns_source.inc"

.segment "ROM05"

.export level6_palette
level6_palette:
  .byte $0d,$0d,$00,$10,$0d,$03,$04,$23,$0d,$01,$11,$2c,$0d,$07,$05,$10
  .byte $0d,$0d,$27,$20,$0d,$04,$29,$0d,$0d,$0d,$01,$00,$0d,$0d,$03,$13

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
  .word volume_envelope_4

  .word volume_envelope_5
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
  .byte 14,13,10,7,3,1,1,ENV_STOP
volume_envelope_3:
  .byte 0,ENV_STOP
volume_envelope_4:
  .byte 8,0,ENV_STOP
volume_envelope_5:
  .byte 6,6,6,6,6,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP
duty_envelope_1:
  .byte -64,ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,1,STL,7,A1,D4,A3,A3,D4,D4,D4,A3,A4,D4,F4,A3,F3,D4,A4,F3
  .byte G3,D4,A4,AS3,E3,D4,G4,AS3,F3,CS4,G4,A3,D3,D4,F4,A3,E3,AS3,F4,G3,CS3,A3,E4,G3
  .byte D3,A3,E4,F3,F2,A3,D4,F3,G2,AS3,D4,E3,A2,A3,D4,F3,AS2,G3,CS4,E3,F2,A3,D4,F3
  .byte G2,AS3,D4,E3,A2,A3,D4,F3,AS2,G3,CS4,E3,F2,A3,D4,F3,G2,AS3,D4,E3,A2,A3,CS4,G3
  .byte D2,F2,A2,F2,D2,G2,AS2,G2,D2,F2,A2,F2,D2,E2,G2,E2,D1,D2,F2,D2,D1,E2,G2,E2
  .byte D1,F2,A2,F2,D1,F2,A2,F2,D1,G2,AS2,G2,D1,G2,AS2,G2,D1,F2,A2,F2,F1,F2,A2,F2
  .byte G1,G2,AS2,G2,AS1,G2,AS2,G2,A1,A2,CS3,A2,F1,F2,A2,F2,G1,G2,AS2,G2,AS1,G2,AS2,G2
  .byte A1,A2,CS3,A2,E2,A2,CS3,A2,CS2,A2,CS3,A2,A1,A2,CS3,A2,D2,E2,F2,E2,D2,C2,AS1,A1
  .byte STL,21,G1,STL,7,F1,G1,A1,STL,14,D1
  .byte GOT
  .word Square1

Square2:
  .byte STV,2,STP,0,SDU,1,STL,7,A0,D3,A2,A2,D3,D3,D3,A2,A3,D3,F3,A2,F2,D3,A3,F2
  .byte G2,D3,A3,AS2,E2,D3,G3,AS2,F2,CS3,G3,A2,D2,D3,F3,A2,E2,AS2,F3,G2,CS2,A2,E3,G2
  .byte D2,A2,E3,F2,F1,A2,D3,F2,G1,AS2,D3,E2,A1,A2,D3,F2,AS1,G2,CS3,E2,F1,A2,D3,F2
  .byte G1,AS2,D3,E2,A1,A2,D3,F2,AS1,G2,CS3,E2,F1,A2,D3,F2,G1,AS2,D3,E2,A1,A2,CS3,G2
  .byte D3,F3,A3,F3,D3,G3,AS3,G3,D3,F3,A3,F3,D3,E3,G3,E3,D2,D3,F3,D3,D2,E3,G3,E3
  .byte D2,F3,A3,F3,D2,F3,A3,F3,D2,G3,AS3,G3,D2,G3,AS3,G3,D2,F3,A3,F3,F2,F3,A3,F3
  .byte G2,G3,AS3,G3,AS2,G3,AS3,G3,A2,A3,CS4,A3,F2,F3,A3,F3,G2,G3,AS3,G3,AS2,G3,AS3,G3
  .byte A2,A3,CS4,A3,E3,A3,CS4,A3,CS3,A3,CS4,A3,A2,A3,CS4,A3,D3,E3,F3,E3,D3,C3,AS2,A2
  .byte STL,21,G2,STL,7,F2,G2,A2,STL,14,D2
  .byte GOT
  .word Square2

Triangle:
  .byte STV,3,STP,0,SDU,0,STL,255,C1,STL,255,C1,STL,218,C1,STV,5,STL,14,A4,STL,7,G4,F4
  .byte E4,D4,CS4,E4,STV,2,SDU,1,STL,28,D4,STV,5,SDU,0,STL,7,A4,G4,STV,2,SDU,1,STL
  .byte 28,A4,STV,5,SDU,0,STL,7,G4,F4,E4,D4,CS4,E4,STV,2,SDU,1,STL,28,D4,STL,42,A3
  .byte STV,5,SDU,0,STL,7,AS3,A3,G3,F3,E3,D3,STV,2,SDU,1,STL,28,CS3,STL,42,A3,STV,5
  .byte SDU,0,STL,7,AS3,A3,G3,F3,E3,D3,STV,2,SDU,1,STL,28,CS3,STL,42,A3,STV,5,SDU,0
  .byte STL,7,AS3,A3,G3,F3,E3,G3,F3,E3,D3,E3,F3,G3,A3,B3,CS4,A3,D4,F3,E3,D3,STL,14
  .byte D3
  .byte GOT
  .word Triangle

Noise:
  .byte STV,4,STP,0,SDU,0,STL,14,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10
  .byte 15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10
  .byte 15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10
  .byte 15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10,15,10
  .byte 15,10,15,10,15,10,15,10
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
  .byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09

MapColumnTable:
  .byte $00,$00,$01,$00
  .byte $01,$02,$03,$00
  .byte $02,$04,$05,$00
  .byte $03,$06,$07,$00
  .byte $04,$08,$09,$00
  .byte $05,$0a,$0b,$00
  .byte $06,$0c,$0d,$00
  .byte $07,$0e,$0f,$00
  .byte $08,$10,$11,$00
  .byte $08,$11,$11,$00
AttributeColumnTable:
  .byte $44,$05,$00,$00,$00,$00,$00,$0f
  .byte $00,$81,$6a,$66,$66,$00,$00,$0f
  .byte $00,$20,$9a,$99,$99,$00,$00,$0f
  .byte $44,$44,$44,$44,$44,$54,$55,$0f
  .byte $11,$11,$11,$11,$11,$51,$55,$0f
  .byte $00,$80,$6a,$66,$66,$00,$00,$0f
  .byte $00,$24,$9a,$99,$99,$00,$00,$0f
  .byte $11,$05,$00,$00,$00,$00,$00,$0f
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTileColumnTable:
  .byte $00,$00,$0b,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$45,$00
  .byte $03,$06,$0c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$4a,$45,$00
  .byte $4f,$00,$0d,$00,$07,$10,$10,$1e,$10,$2f,$00,$00,$00,$00,$45,$00
  .byte $00,$00,$00,$04,$08,$0e,$16,$1c,$24,$2d,$00,$00,$00,$00,$45,$00
  .byte $00,$00,$00,$05,$09,$0f,$17,$1d,$25,$2e,$00,$00,$00,$00,$45,$00
  .byte $00,$00,$00,$00,$0a,$11,$11,$1f,$11,$30,$00,$00,$00,$00,$45,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1b,$23,$2c,$45,$00
  .byte $38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$3e,$45,$00
  .byte $3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$40,$45,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2b,$34,$2c,$45,$00
  .byte $00,$00,$00,$00,$07,$10,$10,$1e,$10,$2f,$00,$00,$00,$4d,$45,$00
  .byte $00,$00,$00,$04,$08,$0e,$16,$1c,$24,$2d,$4e,$00,$00,$00,$45,$00
  .byte $00,$00,$00,$05,$09,$0f,$17,$1d,$25,$2e,$00,$00,$00,$4b,$45,$00
  .byte $4f,$00,$0b,$00,$0a,$11,$11,$1f,$11,$30,$00,$00,$00,$00,$45,$00
  .byte $03,$06,$0c,$00,$00,$00,$4c,$00,$00,$00,$00,$00,$00,$00,$45,$00
  .byte $00,$00,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$45,$00
  .byte $49,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
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
  .byte $01,$00,$00,$83,$84,$91,$84,$00
MetaTile38:
  .byte $03,$00,$00,$85,$86,$92,$93,$00
MetaTile39:
  .byte $03,$00,$00,$85,$86,$92,$94,$00
MetaTile40:
  .byte $03,$00,$00,$7b,$87,$7b,$95,$00
MetaTile41:
  .byte $03,$00,$00,$88,$89,$96,$97,$00
MetaTile42:
  .byte $03,$00,$00,$8a,$7e,$98,$7e,$00
MetaTile43:
  .byte $01,$00,$00,$8b,$8c,$99,$9a,$00
MetaTile44:
  .byte $01,$00,$00,$9b,$9c,$aa,$ab,$00
MetaTile45:
  .byte $01,$00,$00,$9d,$9e,$ac,$ad,$00
MetaTile46:
  .byte $01,$00,$00,$9f,$a0,$ae,$af,$00
MetaTile47:
  .byte $02,$00,$00,$a1,$a2,$b0,$b1,$00
MetaTile48:
  .byte $02,$00,$00,$a3,$a4,$b2,$b3,$00
MetaTile49:
  .byte $03,$00,$00,$7b,$a5,$7b,$a5,$00
MetaTile50:
  .byte $03,$00,$00,$6d,$a6,$6d,$a6,$00
MetaTile51:
  .byte $03,$00,$00,$a7,$7e,$a7,$7e,$00
MetaTile52:
  .byte $01,$00,$00,$a8,$a9,$b4,$b5,$00
MetaTile53:
  .byte $03,$00,$00,$b6,$b7,$bc,$bd,$00
MetaTile54:
  .byte $03,$00,$00,$b8,$b9,$bd,$bd,$00
MetaTile55:
  .byte $03,$00,$00,$ba,$bb,$bd,$be,$00
MetaTile56:
  .byte $01,$00,$00,$bf,$c0,$ca,$cb,$00
MetaTile57:
  .byte $01,$00,$00,$c1,$c1,$c1,$c1,$00
MetaTile58:
  .byte $01,$00,$00,$c2,$c3,$cc,$c3,$00
MetaTile59:
  .byte $02,$00,$00,$c4,$c5,$cd,$ce,$00
MetaTile60:
  .byte $02,$00,$00,$c6,$c7,$cf,$d0,$00
MetaTile61:
  .byte $02,$00,$00,$c8,$c9,$d1,$d2,$00
MetaTile62:
  .byte $01,$00,$00,$d3,$d4,$d3,$e1,$00
MetaTile63:
  .byte $01,$00,$00,$d5,$d6,$e2,$e3,$00
MetaTile64:
  .byte $01,$00,$00,$d7,$d8,$e4,$e5,$00
MetaTile65:
  .byte $02,$00,$00,$d9,$da,$e6,$e7,$00
MetaTile66:
  .byte $02,$00,$00,$db,$dc,$e8,$e9,$00
MetaTile67:
  .byte $02,$00,$00,$dd,$de,$ea,$eb,$00
MetaTile68:
  .byte $03,$00,$00,$df,$e0,$ec,$ed,$00
MetaTile69:
  .byte $03,$00,$01,$ee,$ef,$f6,$f7,$00
MetaTile70:
  .byte $02,$00,$00,$f0,$f1,$f8,$f9,$00
MetaTile71:
  .byte $02,$00,$00,$f2,$f3,$fa,$fb,$00
MetaTile72:
  .byte $02,$00,$00,$f4,$f5,$fc,$fd,$00
MetaTile73:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_exit
MetaTile74:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_gort
MetaTile75:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_hippocritter
MetaTile76:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_bat
MetaTile77:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_armoredskelekin
MetaTile78:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_attacknid
MetaTile79:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_laser
