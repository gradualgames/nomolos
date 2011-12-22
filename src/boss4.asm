.include "spritesheet_common.inc"
.include "spritesheet1.inc"
.include "soundengine.inc"
.include "sound_effects.inc"
.include "entities.inc"

.segment "CODE"

.export boss4_sprite_groups
boss4_sprite_groups:
  .byte $03
  .byte entity_index_nomolos
  .byte entity_index_explosion
  .byte entity_index_sneep

.segment "ROM05"
  
.export boss4_palette
boss4_palette:
  .byte $0d,$0b,$1b,$12,$0d,$1b,$00,$10,$0d,$0a,$00,$2c,$0d,$07,$16,$26
  .byte $0d,$0d,$27,$20,$0d,$0d,$04,$29,$0d,$0d,$26,$25,$0d,$0d,$15,$25

.export boss4_music
boss4_music: 
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

.export boss4_map
boss4_map = Map

.export boss4_map_column_table
boss4_map_column_table = MapColumnTable

.export boss4_attribute_column_table
boss4_attribute_column_table = AttributeColumnTable

.export boss4_meta_tile_column_table
boss4_meta_tile_column_table = MetaTileColumnTable

.export boss4_meta_tile_table
boss4_meta_tile_table = MetaTileTable
  
Map:
  .byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

MapColumnTable:
  .byte $00,$00,$01,$00
  .byte $01,$02,$03,$00
  .byte $02,$04,$05,$00
  .byte $03,$06,$07,$00
  .byte $04,$07,$08,$00
  .byte $05,$01,$02,$00
  .byte $06,$09,$04,$00
  .byte $07,$0a,$0b,$00
  .byte $08,$0c,$0d,$00
  .byte $09,$0e,$0f,$00
  .byte $0a,$10,$11,$00
  .byte $0b,$12,$13,$00
  .byte $0c,$14,$15,$00
  .byte $0d,$16,$17,$00
  .byte $0e,$17,$17,$00
AttributeColumnTable:
  .byte $40,$55,$55,$55,$55,$55,$55,$0a
  .byte $55,$dd,$5d,$55,$55,$55,$55,$0a
  .byte $51,$55,$55,$55,$55,$55,$55,$0a
  .byte $00,$51,$55,$77,$57,$55,$55,$0a
  .byte $00,$54,$55,$dd,$5d,$55,$55,$0a
  .byte $54,$55,$55,$55,$55,$55,$55,$0a
  .byte $55,$77,$57,$55,$55,$55,$55,$0a
  .byte $10,$55,$55,$55,$55,$55,$55,$0a
  .byte $00,$10,$55,$55,$55,$55,$55,$0a
  .byte $00,$00,$10,$55,$55,$55,$55,$0a
  .byte $00,$00,$00,$10,$55,$55,$55,$0a
  .byte $00,$00,$00,$00,$10,$55,$55,$0a
  .byte $00,$00,$00,$00,$00,$10,$55,$0a
  .byte $00,$00,$00,$00,$00,$00,$10,$02
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTileColumnTable:
  .byte $0f,$00,$17,$18,$18,$53,$60,$69,$69,$69,$69,$69,$69,$73,$3f,$00
  .byte $10,$17,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $11,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $18,$18,$25,$2d,$33,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $12,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $13,$19,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $14,$00,$19,$18,$18,$18,$25,$2d,$33,$18,$18,$18,$18,$18,$40,$00
  .byte $14,$00,$00,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $0f,$00,$17,$18,$18,$18,$25,$2d,$33,$18,$18,$18,$18,$18,$40,$00
  .byte $18,$18,$25,$2d,$33,$18,$18,$18,$18,$18,$18,$18,$18,$7f,$40,$00
  .byte $00,$19,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $00,$00,$19,$18,$18,$53,$60,$69,$69,$69,$69,$69,$69,$73,$40,$00
  .byte $00,$00,$00,$19,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$19,$18,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$19,$18,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$00,$19,$18,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$19,$18,$18,$18,$18,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$19,$18,$18,$18,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$19,$18,$18,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$19,$18,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$19,$18,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$19,$18,$40,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$19,$3f,$00
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
  .byte $01,$00,$00,$3e,$3f,$4a,$4b,$00
MetaTile24:
  .byte $01,$00,$00,$40,$41,$4c,$4d,$00
MetaTile25:
  .byte $01,$00,$00,$42,$43,$4e,$4f,$00
MetaTile26:
  .byte $03,$00,$00,$27,$28,$34,$35,$00
MetaTile27:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile28:
  .byte $03,$00,$00,$29,$2a,$36,$37,$00
MetaTile29:
  .byte $01,$00,$00,$54,$55,$58,$59,$00
MetaTile30:
  .byte $03,$00,$00,$3e,$3f,$4a,$4b,$00
MetaTile31:
  .byte $03,$00,$00,$40,$41,$4c,$4d,$00
MetaTile32:
  .byte $03,$00,$00,$42,$43,$4e,$4f,$00
MetaTile33:
  .byte $01,$00,$00,$5c,$5d,$63,$64,$00
MetaTile34:
  .byte $01,$00,$00,$5e,$5f,$65,$66,$00
MetaTile35:
  .byte $01,$00,$00,$60,$61,$67,$68,$00
MetaTile36:
  .byte $01,$00,$00,$00,$00,$6b,$6c,$00
MetaTile37:
  .byte $03,$00,$00,$54,$55,$58,$59,$00
MetaTile38:
  .byte $01,$00,$00,$82,$83,$8f,$90,$00
MetaTile39:
  .byte $01,$00,$00,$84,$85,$91,$92,$00
MetaTile40:
  .byte $01,$00,$00,$86,$87,$93,$94,$00
MetaTile41:
  .byte $01,$00,$00,$6d,$6e,$74,$75,$00
MetaTile42:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile43:
  .byte $01,$00,$00,$72,$73,$76,$77,$00
MetaTile44:
  .byte $03,$00,$00,$5c,$5d,$63,$64,$00
MetaTile45:
  .byte $03,$00,$00,$5e,$5f,$65,$66,$00
MetaTile46:
  .byte $03,$00,$00,$60,$61,$67,$68,$00
MetaTile47:
  .byte $01,$00,$00,$9c,$9d,$ad,$ae,$00
MetaTile48:
  .byte $01,$00,$00,$9e,$9d,$af,$ae,$00
MetaTile49:
  .byte $01,$00,$00,$9e,$9f,$af,$b0,$00
MetaTile50:
  .byte $01,$00,$00,$78,$79,$7a,$7b,$00
MetaTile51:
  .byte $03,$00,$00,$6d,$6e,$74,$75,$00
MetaTile52:
  .byte $03,$00,$00,$d6,$d7,$db,$dc,$00
MetaTile53:
  .byte $01,$00,$00,$be,$bf,$cc,$cd,$00
MetaTile54:
  .byte $01,$00,$00,$9e,$9d,$ce,$cf,$00
MetaTile55:
  .byte $01,$00,$00,$c0,$c1,$d0,$d1,$00
MetaTile56:
  .byte $03,$00,$00,$00,$00,$6b,$6c,$00
MetaTile57:
  .byte $03,$00,$00,$e4,$e5,$f2,$f3,$00
MetaTile58:
  .byte $03,$00,$00,$e6,$e7,$f4,$f5,$00
MetaTile59:
  .byte $01,$00,$00,$d6,$d7,$db,$dc,$00
MetaTile60:
  .byte $01,$00,$00,$7c,$7d,$8a,$8b,$00
MetaTile61:
  .byte $01,$00,$00,$7e,$7f,$8c,$8b,$00
MetaTile62:
  .byte $01,$00,$00,$80,$81,$8d,$8e,$00
MetaTile63:
  .byte $02,$00,$01,$7c,$7d,$8a,$8b,$00
MetaTile64:
  .byte $02,$00,$01,$7e,$7f,$8c,$8b,$00
MetaTile65:
  .byte $02,$00,$01,$80,$81,$8d,$8e,$00
MetaTile66:
  .byte $03,$00,$00,$82,$83,$8f,$90,$00
MetaTile67:
  .byte $03,$00,$00,$84,$85,$91,$92,$00
MetaTile68:
  .byte $03,$00,$00,$86,$87,$93,$94,$00
MetaTile69:
  .byte $03,$00,$00,$72,$73,$76,$77,$00
MetaTile70:
  .byte $01,$00,$00,$88,$89,$95,$96,$00
MetaTile71:
  .byte $01,$00,$00,$e4,$e5,$f2,$f3,$00
MetaTile72:
  .byte $01,$00,$00,$e6,$e7,$f4,$f5,$00
MetaTile73:
  .byte $01,$00,$00,$97,$98,$a8,$a9,$00
MetaTile74:
  .byte $01,$00,$00,$99,$9a,$aa,$ab,$00
MetaTile75:
  .byte $01,$00,$00,$99,$9b,$aa,$ac,$00
MetaTile76:
  .byte $02,$00,$00,$97,$98,$a8,$a9,$00
MetaTile77:
  .byte $02,$00,$00,$99,$9a,$aa,$ab,$00
MetaTile78:
  .byte $02,$00,$00,$99,$9b,$aa,$ac,$00
MetaTile79:
  .byte $03,$00,$00,$9c,$9d,$ad,$ae,$00
MetaTile80:
  .byte $03,$00,$00,$9e,$9d,$af,$ae,$00
MetaTile81:
  .byte $03,$00,$00,$9e,$9f,$af,$b0,$00
MetaTile82:
  .byte $03,$00,$00,$78,$79,$7a,$7b,$00
MetaTile83:
  .byte $01,$00,$01,$a0,$a1,$b1,$b2,$00
MetaTile84:
  .byte $01,$00,$00,$a2,$a3,$b3,$b4,$00
MetaTile85:
  .byte $01,$00,$00,$a4,$a5,$00,$b5,$00
MetaTile86:
  .byte $01,$00,$00,$a6,$a7,$b6,$b7,$00
MetaTile87:
  .byte $01,$00,$00,$b8,$b9,$c6,$c7,$00
MetaTile88:
  .byte $01,$00,$00,$ba,$bb,$c8,$c9,$00
MetaTile89:
  .byte $01,$00,$00,$bc,$bd,$ca,$cb,$00
MetaTile90:
  .byte $02,$00,$00,$b8,$b9,$c6,$c7,$00
MetaTile91:
  .byte $02,$00,$00,$ba,$bb,$c8,$c9,$00
MetaTile92:
  .byte $02,$00,$00,$bc,$bd,$ca,$cb,$00
MetaTile93:
  .byte $03,$00,$00,$be,$bf,$cc,$cd,$00
MetaTile94:
  .byte $03,$00,$00,$9e,$9d,$ce,$cf,$00
MetaTile95:
  .byte $03,$00,$00,$c0,$c1,$d0,$d1,$00
MetaTile96:
  .byte $01,$00,$01,$c2,$c3,$d2,$d3,$00
MetaTile97:
  .byte $02,$00,$00,$c4,$c5,$d4,$d5,$00
MetaTile98:
  .byte $03,$00,$00,$c4,$c5,$d4,$d5,$00
MetaTile99:
  .byte $01,$00,$00,$c4,$c5,$d4,$d5,$00
MetaTile100:
  .byte $00,$00,$00,$56,$57,$5a,$5b,$00
MetaTile101:
  .byte $02,$00,$00,$de,$df,$ec,$ed,$00
MetaTile102:
  .byte $02,$00,$00,$e0,$e1,$ee,$ef,$00
MetaTile103:
  .byte $02,$00,$00,$e2,$e3,$f0,$f1,$00
MetaTile104:
  .byte $02,$00,$00,$d6,$d7,$db,$dc,$00
MetaTile105:
  .byte $01,$00,$01,$d8,$d9,$d8,$d9,$00
MetaTile106:
  .byte $02,$00,$00,$da,$d9,$dd,$d9,$00
MetaTile107:
  .byte $03,$00,$00,$da,$d9,$dd,$d9,$00
MetaTile108:
  .byte $01,$00,$01,$da,$d9,$dd,$d9,$00
MetaTile109:
  .byte $00,$00,$00,$00,$62,$69,$6a,$00
MetaTile110:
  .byte $03,$00,$00,$de,$df,$ec,$ed,$00
MetaTile111:
  .byte $03,$00,$00,$e0,$e1,$ee,$ef,$00
MetaTile112:
  .byte $03,$00,$00,$e2,$e3,$f0,$f1,$00
MetaTile113:
  .byte $02,$00,$00,$e4,$e5,$f2,$f3,$00
MetaTile114:
  .byte $02,$00,$00,$e6,$e7,$f4,$f5,$00
MetaTile115:
  .byte $01,$00,$01,$e8,$e9,$f6,$f7,$00
MetaTile116:
  .byte $02,$00,$00,$ea,$eb,$f8,$f9,$00
MetaTile117:
  .byte $03,$00,$00,$ea,$eb,$f8,$f9,$00
MetaTile118:
  .byte $01,$00,$00,$ea,$eb,$f8,$f9,$00
MetaTile119:
  .byte $00,$00,$00,$00,$6f,$00,$00,$00
MetaTile120:
  .byte $00,$00,$00,$70,$71,$00,$00,$00
MetaTile121:
  .byte $01,$00,$00,$de,$df,$ec,$ed,$00
MetaTile122:
  .byte $01,$00,$00,$e0,$e1,$ee,$ef,$00
MetaTile123:
  .byte $01,$00,$00,$e2,$e3,$f0,$f1,$00
MetaTile124:
  .byte $03,$00,$00,$fa,$fb,$fc,$fd,$00
MetaTile125:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_exit
MetaTile126:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_setrightmostx
MetaTile127:
  .byte $01,$00,$00,$40,$41,$4c,$4d,entity_index_sneep
MetaTile128:
  .byte $00,$00,$00,$44,$45,$50,$51,$00
MetaTile129:
  .byte $00,$00,$00,$46,$47,$52,$53,$00
MetaTile130:
  .byte $00,$00,$00,$48,$49,$00,$00,$00
MetaTile131:
  .byte $01,$00,$00,$00,$00,$00,$00,$00
