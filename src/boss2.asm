.include "soundengine.inc"
.include "spritesheet_common.inc"
.include "spritesheet2.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export boss2_sprite_groups
boss2_sprite_groups:
  .byte $04
  .byte entity_index_nomolos
  .byte entity_index_explosion
  .byte entity_index_thoguth
  .byte entity_index_lightningbolt

.segment "ROM05"

.export boss2_music
boss2_music: 
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

.export boss2_palette
boss2_palette:
  .byte $0d,$00,$2d,$02,$0d,$07,$06,$0c,$0d,$00,$2d,$04,$0d,$00,$28,$08
;spritesheet1_palette
  .byte $0d,$0d,$27,$20,$0d,$0d,$04,$29,$0d,$0d,$0c,$11,$0d,$04,$14,$33

.export boss2_cycling_palettes
boss2_cycling_palettes:
  .byte 3
  .byte $0d,$03,$12,$21,$0d,$12,$20,$21,$0d,$24,$14,$04,$0d,$13,$33,$23
  .byte $0d,$03,$12,$21,$0d,$20,$21,$12,$0d,$24,$14,$04,$0d,$13,$33,$23
  .byte $0d,$03,$12,$21,$0d,$21,$12,$20,$0d,$24,$14,$04,$0d,$13,$33,$23

.export boss2_map
boss2_map = Map

.export boss2_map_column_table
boss2_map_column_table = MapColumnTable

.export boss2_attribute_column_table
boss2_attribute_column_table = AttributeColumnTable

.export boss2_meta_tile_column_table
boss2_meta_tile_column_table = MetaTileColumnTable

.export boss2_meta_tile_table
boss2_meta_tile_table = MetaTileTable

Map:
  .byte $00,$01,$02,$03,$04,$01,$05,$06,$07,$07,$08,$09,$0a,$0b,$0c,$07,$00,$01,$02,$03,$0d,$01,$05,$0e,$07,$07,$08,$09,$0a,$0b,$0c,$07
  .byte $0f,$10,$10,$10,$10,$11,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12
  .byte $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12
  .byte $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12

MapColumnTable:
  .byte $00,$00,$01,$00
  .byte $01,$02,$03,$00
  .byte $02,$04,$05,$00
  .byte $03,$06,$07,$00
  .byte $04,$08,$09,$00
  .byte $05,$04,$0a,$00
  .byte $06,$0b,$0c,$00
  .byte $07,$0d,$0d,$00
  .byte $07,$0e,$0f,$00
  .byte $08,$10,$11,$00
  .byte $09,$12,$13,$00
  .byte $0a,$14,$10,$00
  .byte $07,$15,$16,$00
  .byte $04,$08,$01,$00
  .byte $0b,$17,$17,$00
  .byte $07,$18,$19,$00
  .byte $07,$19,$19,$00
  .byte $07,$19,$1a,$00
  .byte $07,$1a,$1a,$00
AttributeColumnTable:
  .byte $11,$11,$11,$19,$01,$00,$50,$05
  .byte $00,$00,$02,$aa,$aa,$88,$50,$05
  .byte $08,$00,$00,$22,$00,$00,$50,$05
  .byte $aa,$aa,$88,$00,$00,$02,$50,$05
  .byte $22,$00,$00,$08,$00,$00,$50,$05
  .byte $44,$44,$04,$22,$40,$44,$54,$05
  .byte $55,$55,$45,$44,$54,$55,$55,$05
  .byte $00,$00,$00,$00,$00,$00,$00,$00
  .byte $cc,$cc,$cc,$0c,$00,$00,$00,$00
  .byte $00,$00,$f0,$0f,$00,$00,$00,$00
  .byte $33,$33,$33,$03,$00,$00,$00,$00
  .byte $55,$55,$05,$00,$50,$55,$55,$05
MetaTileColumnTable:
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$3c,$3c,$3c,$3c,$08,$08,$00
  .byte $00,$10,$10,$10,$10,$10,$0c,$10,$10,$10,$10,$10,$10,$08,$08,$00
  .byte $01,$11,$1e,$2a,$36,$10,$0d,$1b,$28,$34,$95,$10,$10,$08,$08,$00
  .byte $02,$12,$1f,$2b,$37,$41,$0e,$1c,$29,$35,$40,$49,$10,$08,$08,$00
  .byte $03,$10,$10,$10,$10,$10,$0f,$1d,$10,$10,$10,$10,$10,$08,$08,$00
  .byte $0c,$10,$10,$10,$10,$10,$00,$10,$10,$10,$10,$10,$10,$08,$08,$00
  .byte $0d,$1b,$28,$34,$95,$10,$01,$11,$1e,$2a,$36,$10,$10,$08,$08,$00
  .byte $0e,$1c,$29,$35,$40,$49,$02,$12,$1f,$2b,$37,$41,$10,$08,$08,$00
  .byte $0f,$1d,$10,$10,$10,$10,$03,$10,$10,$10,$10,$10,$10,$08,$08,$00
  .byte $00,$10,$10,$10,$10,$10,$0c,$10,$10,$10,$10,$10,$92,$08,$08,$00
  .byte $08,$08,$08,$08,$08,$38,$38,$38,$38,$08,$08,$08,$08,$08,$08,$00
  .byte $08,$08,$08,$08,$08,$31,$31,$31,$31,$08,$08,$08,$08,$08,$08,$00
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$00
  .byte $4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$07,$07,$07,$07,$07,$07,$00
  .byte $4f,$66,$6f,$79,$4f,$4f,$4f,$4f,$4f,$07,$07,$07,$07,$07,$07,$00
  .byte $4f,$67,$70,$7a,$4f,$4f,$4f,$4f,$4f,$4f,$07,$07,$07,$07,$07,$00
  .byte $4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$07,$07,$07,$07,$00
  .byte $5a,$5a,$5a,$5a,$5a,$5a,$63,$4f,$4f,$4f,$4f,$4f,$07,$07,$07,$00
  .byte $4f,$4f,$4f,$4f,$4f,$5c,$64,$4f,$4f,$4f,$4f,$4f,$4f,$91,$4f,$00
  .byte $4f,$4f,$4f,$4f,$4f,$5c,$64,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f,$00
  .byte $5b,$5b,$5b,$5b,$5b,$5b,$65,$4f,$4f,$4f,$4f,$4f,$07,$07,$07,$00
  .byte $4f,$66,$6f,$79,$4f,$4f,$4f,$4f,$4f,$4f,$07,$07,$07,$07,$07,$00
  .byte $4f,$67,$70,$7a,$4f,$4f,$4f,$4f,$4f,$07,$07,$07,$07,$07,$07,$00
  .byte $08,$08,$08,$08,$08,$4f,$4f,$4f,$4f,$08,$08,$08,$08,$08,$08,$00
  .byte $07,$07,$07,$07,$07,$07,$07,$07,$07,$94,$07,$07,$07,$07,$07,$00
  .byte $07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
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
  .byte $00,$00,$00,$86,$87,$92,$93,$00
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
  .byte $02,$00,$00,$21,$22,$30,$31,$00
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
  .byte $02,$00,$00,$3c,$3d,$48,$49,$00
MetaTile34:
  .byte $02,$00,$00,$3e,$3f,$4a,$4b,$00
MetaTile35:
  .byte $02,$00,$00,$40,$41,$4c,$4d,$00
MetaTile36:
  .byte $00,$00,$00,$42,$07,$4e,$10,$00
MetaTile37:
  .byte $00,$00,$00,$ce,$c8,$d8,$d9,$00
MetaTile38:
  .byte $00,$00,$00,$c8,$c8,$d9,$d9,$00
MetaTile39:
  .byte $00,$00,$00,$c8,$cf,$d9,$da,$00
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
  .byte $02,$00,$00,$54,$55,$5f,$55,$00
MetaTile46:
  .byte $02,$00,$00,$56,$57,$60,$61,$00
MetaTile47:
  .byte $02,$00,$00,$58,$59,$58,$62,$00
MetaTile48:
  .byte $00,$00,$00,$0a,$5a,$63,$64,$00
MetaTile49:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile50:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile51:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile52:
  .byte $02,$00,$00,$4f,$50,$0f,$5b,$00
MetaTile53:
  .byte $02,$00,$00,$51,$52,$5c,$5d,$00
MetaTile54:
  .byte $02,$00,$00,$00,$65,$0f,$10,$00
MetaTile55:
  .byte $00,$00,$00,$66,$67,$70,$71,$00
MetaTile56:
  .byte $00,$00,$00,$00,$68,$0f,$72,$00
MetaTile57:
  .byte $02,$00,$00,$69,$6a,$73,$74,$00
MetaTile58:
  .byte $02,$00,$00,$6b,$6c,$75,$76,$00
MetaTile59:
  .byte $02,$00,$00,$58,$6d,$77,$78,$00
MetaTile60:
  .byte $00,$00,$00,$6e,$6f,$79,$7a,$00
MetaTile61:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile62:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile63:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
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
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile72:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
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
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile81:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile82:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,$00
MetaTile83:
  .byte $00,$00,$00,$a4,$a5,$a4,$b5,$00
MetaTile84:
  .byte $00,$00,$00,$a6,$a7,$b6,$b7,$00
MetaTile85:
  .byte $00,$00,$00,$a8,$a9,$b8,$b9,$00
MetaTile86:
  .byte $00,$00,$00,$00,$aa,$0f,$ba,$00
MetaTile87:
  .byte $00,$00,$00,$ab,$07,$bb,$bc,$00
MetaTile88:
  .byte $02,$00,$00,$ac,$ad,$bd,$be,$00
MetaTile89:
  .byte $02,$00,$00,$ae,$07,$bf,$c0,$00
MetaTile90:
  .byte $03,$00,$00,$0a,$af,$0a,$c1,$00
MetaTile91:
  .byte $03,$00,$00,$b0,$0a,$c2,$0a,$00
MetaTile92:
  .byte $03,$00,$00,$b1,$b2,$c3,$c4,$00
MetaTile93:
  .byte $03,$00,$00,$b3,$b4,$c5,$c6,$00
MetaTile94:
  .byte $00,$00,$00,$c7,$c8,$d2,$d3,$00
MetaTile95:
  .byte $00,$00,$00,$c8,$c8,$d4,$d3,$00
MetaTile96:
  .byte $00,$00,$00,$c8,$c9,$d4,$d5,$00
MetaTile97:
  .byte $02,$00,$00,$ca,$cb,$0f,$d6,$00
MetaTile98:
  .byte $02,$00,$00,$cc,$cd,$d7,$10,$00
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
  .byte $02,$00,$00,$0a,$0a,$0a,$2f,$00
MetaTile105:
  .byte $02,$00,$00,$21,$df,$30,$31,$00
MetaTile106:
  .byte $02,$00,$00,$0a,$0a,$32,$0a,$00
MetaTile107:
  .byte $02,$00,$00,$ac,$e0,$0f,$e6,$00
MetaTile108:
  .byte $02,$00,$00,$e1,$07,$e7,$10,$00
MetaTile109:
  .byte $00,$00,$00,$00,$aa,$0f,$ba,$00
MetaTile110:
  .byte $00,$00,$00,$ab,$07,$bb,$bc,$00
MetaTile111:
  .byte $00,$00,$00,$e2,$e3,$0a,$e8,$00
MetaTile112:
  .byte $00,$00,$00,$e4,$e5,$e9,$0a,$00
MetaTile113:
  .byte $02,$00,$00,$3c,$3d,$48,$49,$00
MetaTile114:
  .byte $02,$00,$00,$3e,$3f,$4a,$4b,$00
MetaTile115:
  .byte $02,$00,$00,$40,$41,$4c,$4d,$00
MetaTile116:
  .byte $00,$00,$00,$ac,$ad,$bd,$be,$00
MetaTile117:
  .byte $00,$00,$00,$ae,$07,$bf,$c0,$00
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
  .byte $02,$00,$00,$54,$55,$5f,$55,$00
MetaTile124:
  .byte $02,$00,$00,$56,$57,$60,$61,$00
MetaTile125:
  .byte $02,$00,$00,$58,$59,$58,$62,$00
MetaTile126:
  .byte $00,$00,$00,$ca,$cb,$0f,$d6,$00
MetaTile127:
  .byte $00,$00,$00,$cc,$cd,$d7,$10,$00
MetaTile128:
  .byte $02,$00,$00,$0a,$d0,$db,$dc,$00
MetaTile129:
  .byte $02,$00,$00,$d1,$0a,$dd,$de,$00
MetaTile130:
  .byte $02,$00,$00,$69,$6a,$73,$74,$00
MetaTile131:
  .byte $02,$00,$00,$6b,$6c,$75,$76,$00
MetaTile132:
  .byte $02,$00,$00,$58,$6d,$77,$78,$00
MetaTile133:
  .byte $00,$00,$00,$ac,$e0,$0f,$e6,$00
MetaTile134:
  .byte $00,$00,$00,$e1,$07,$e7,$10,$00
MetaTile135:
  .byte $02,$00,$00,$e2,$e3,$0a,$e8,$00
MetaTile136:
  .byte $02,$00,$00,$e4,$e5,$e9,$0a,$00
MetaTile137:
  .byte $02,$00,$00,$0a,$7d,$0a,$0a,$00
MetaTile138:
  .byte $02,$00,$00,$7e,$7f,$0a,$0a,$00
MetaTile139:
  .byte $02,$00,$00,$80,$81,$0a,$0a,$00
MetaTile140:
  .byte $02,$00,$00,$82,$83,$0a,$0a,$00
MetaTile141:
  .byte $02,$00,$00,$84,$0a,$0a,$0a,$00
MetaTile142:
  .byte $02,$00,$00,$0a,$ea,$0a,$ec,$00
MetaTile143:
  .byte $02,$00,$00,$eb,$0a,$ed,$0a,$00
MetaTile144:
  .byte $01,$00,$00,$0d,$0e,$19,$1a,$00
MetaTile145:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_exit
MetaTile146:
  .byte $00,$00,$00,$00,$07,$0f,$10,entity_index_thoguth
MetaTile147:
  .byte $00,$00,$00,$00,$07,$0f,$10,entity_index_lightningbolt
MetaTile148:
  .byte $00,$00,$01,$0d,$0e,$19,$1a,entity_index_setrightmostx
MetaTile149:
  .byte $00,$00,$00,$00,$65,$0f,$10,$00
MetaTile150:
  .byte $02,$00,$00,$0a,$0a,$0a,$0a,$00
