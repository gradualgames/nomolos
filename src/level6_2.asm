.include "soundengine.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "ROM05"

.export level_6_2_map
level_6_2_map = Map

.export level_6_2_map_column_table
level_6_2_map_column_table = MapColumnTable

.export level_6_2_attribute_column_table
level_6_2_attribute_column_table = AttributeColumnTable

.export level_6_2_meta_tile_column_table
level_6_2_meta_tile_column_table = MetaTileColumnTable

.export level_6_2_meta_tile_table
level_6_2_meta_tile_table = MetaTileTable

Map:
  .byte $00,$01,$01,$02,$03,$04,$05,$06,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
  .byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
  .byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
  .byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
  .byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
  .byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03

MapColumnTable:
  .byte $00,$00,$01,$00
  .byte $01,$02,$02,$00
  .byte $01,$02,$03,$00
  .byte $02,$04,$04,$00
  .byte $03,$05,$06,$00
  .byte $03,$06,$07,$00
  .byte $02,$08,$09,$00
AttributeColumnTable:
  .byte $a2,$88,$88,$88,$88,$88,$a8,$0a
  .byte $00,$00,$00,$00,$00,$00,$a0,$0a
  .byte $00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$f0,$ff,$ff,$0f
MetaTileColumnTable:
  .byte $0c,$19,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$94,$a0,$00
  .byte $00,$1a,$27,$27,$27,$27,$27,$27,$27,$27,$3c,$27,$56,$94,$a0,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$94,$a0,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$95,$a1,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$96,$a2,$a2,$a2,$a2,$b2,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$97,$a3,$a3,$a3,$a3,$b3,$00
  .byte $b5,$00,$00,$00,$00,$00,$00,$00,$00,$98,$a4,$a4,$a4,$a4,$b4,$00
  .byte $b6,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $b7,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
MetaTileTable:
MetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $02,$00,$00,$61,$62,$71,$72,$00
MetaTile2:
  .byte $03,$00,$00,$00,$00,$00,$00,$00
MetaTile3:
  .byte $03,$00,$00,$0e,$0f,$14,$0f,$00
MetaTile4:
  .byte $03,$00,$00,$01,$02,$07,$08,$00
MetaTile5:
  .byte $00,$00,$00,$01,$02,$07,$08,$00
MetaTile6:
  .byte $00,$00,$00,$03,$04,$09,$0a,$00
MetaTile7:
  .byte $01,$00,$00,$01,$02,$07,$08,$00
MetaTile8:
  .byte $01,$00,$00,$0e,$0f,$14,$0f,$00
MetaTile9:
  .byte $02,$00,$00,$01,$02,$07,$08,$00
MetaTile10:
  .byte $02,$00,$00,$7f,$80,$8d,$8e,$00
MetaTile11:
  .byte $02,$00,$00,$00,$0c,$10,$11,$00
MetaTile12:
  .byte $02,$00,$00,$0d,$00,$12,$13,$00
MetaTile13:
  .byte $03,$00,$00,$1d,$1e,$2a,$2b,$00
MetaTile14:
  .byte $03,$00,$00,$1f,$20,$2c,$2d,$00
MetaTile15:
  .byte $03,$00,$00,$21,$00,$2e,$00,$00
MetaTile16:
  .byte $02,$00,$00,$03,$04,$09,$0a,$00
MetaTile17:
  .byte $01,$00,$00,$03,$04,$09,$0a,$00
MetaTile18:
  .byte $01,$00,$00,$1d,$1e,$2a,$2b,$00
MetaTile19:
  .byte $01,$00,$00,$1f,$20,$2c,$2d,$00
MetaTile20:
  .byte $01,$00,$00,$21,$00,$2e,$00,$00
MetaTile21:
  .byte $00,$00,$00,$61,$62,$71,$72,$00
MetaTile22:
  .byte $02,$00,$00,$9b,$9c,$aa,$ab,$00
MetaTile23:
  .byte $02,$00,$00,$15,$16,$22,$23,$00
MetaTile24:
  .byte $02,$00,$00,$17,$18,$24,$25,$00
MetaTile25:
  .byte $02,$00,$00,$19,$1a,$26,$27,$00
MetaTile26:
  .byte $02,$00,$00,$1b,$1c,$28,$29,$00
MetaTile27:
  .byte $03,$00,$00,$37,$38,$47,$48,$00
MetaTile28:
  .byte $03,$00,$00,$39,$3a,$49,$4a,$00
MetaTile29:
  .byte $03,$00,$00,$3b,$3c,$4b,$4c,$00
MetaTile30:
  .byte $03,$00,$00,$3d,$3e,$4d,$4e,$00
MetaTile31:
  .byte $02,$00,$00,$00,$00,$00,$00,$00
MetaTile32:
  .byte $02,$00,$00,$0e,$0f,$14,$0f,$00
MetaTile33:
  .byte $00,$00,$00,$7f,$80,$8d,$8e,$00
MetaTile34:
  .byte $01,$00,$00,$2f,$30,$3f,$40,$00
MetaTile35:
  .byte $01,$00,$00,$31,$32,$41,$42,$00
MetaTile36:
  .byte $02,$00,$00,$33,$34,$43,$44,$00
MetaTile37:
  .byte $03,$00,$00,$2f,$30,$3f,$40,$00
MetaTile38:
  .byte $03,$00,$00,$31,$32,$41,$42,$00
MetaTile39:
  .byte $02,$00,$00,$35,$36,$45,$46,$00
MetaTile40:
  .byte $03,$00,$00,$00,$53,$5b,$5c,$00
MetaTile41:
  .byte $03,$00,$00,$54,$55,$5d,$5e,$00
MetaTile42:
  .byte $03,$00,$00,$56,$00,$5f,$60,$00
MetaTile43:
  .byte $02,$00,$00,$1d,$1e,$2a,$2b,$00
MetaTile44:
  .byte $02,$00,$00,$1f,$20,$2c,$2d,$00
MetaTile45:
  .byte $02,$00,$00,$21,$00,$2e,$00,$00
MetaTile46:
  .byte $00,$00,$00,$9b,$9c,$aa,$ab,$00
MetaTile47:
  .byte $01,$00,$00,$4f,$50,$57,$58,$00
MetaTile48:
  .byte $01,$00,$00,$51,$52,$59,$5a,$00
MetaTile49:
  .byte $03,$00,$00,$4f,$50,$57,$58,$00
MetaTile50:
  .byte $03,$00,$00,$51,$52,$59,$5a,$00
MetaTile51:
  .byte $03,$00,$00,$6b,$6c,$7b,$7c,$00
MetaTile52:
  .byte $03,$00,$00,$6d,$6e,$6d,$6e,$00
MetaTile53:
  .byte $03,$00,$00,$6f,$70,$7d,$7e,$00
MetaTile54:
  .byte $01,$00,$00,$61,$62,$71,$72,$00
MetaTile55:
  .byte $01,$00,$00,$63,$64,$73,$74,$00
MetaTile56:
  .byte $01,$00,$00,$65,$66,$75,$76,$00
MetaTile57:
  .byte $02,$00,$00,$67,$68,$77,$78,$00
MetaTile58:
  .byte $03,$00,$00,$63,$64,$73,$74,$00
MetaTile59:
  .byte $03,$00,$00,$65,$66,$75,$76,$00
MetaTile60:
  .byte $02,$00,$00,$69,$6a,$79,$7a,$00
MetaTile61:
  .byte $03,$00,$00,$85,$86,$92,$93,$00
MetaTile62:
  .byte $03,$00,$00,$85,$86,$92,$94,$00
MetaTile63:
  .byte $03,$00,$00,$7b,$87,$7b,$95,$00
MetaTile64:
  .byte $03,$00,$00,$88,$89,$96,$97,$00
MetaTile65:
  .byte $03,$00,$00,$8a,$7e,$98,$7e,$00
MetaTile66:
  .byte $01,$00,$00,$8b,$8c,$99,$9a,$00
MetaTile67:
  .byte $00,$00,$00,$8b,$8c,$99,$9a,$00
MetaTile68:
  .byte $02,$00,$00,$8b,$8c,$99,$9a,$00
MetaTile69:
  .byte $01,$00,$00,$7f,$80,$8d,$8e,$00
MetaTile70:
  .byte $01,$00,$00,$81,$82,$8f,$90,$00
MetaTile71:
  .byte $01,$00,$00,$83,$84,$91,$84,$00
MetaTile72:
  .byte $03,$00,$00,$81,$82,$8f,$90,$00
MetaTile73:
  .byte $03,$00,$00,$83,$84,$91,$84,$00
MetaTile74:
  .byte $03,$00,$00,$7b,$a5,$7b,$a5,$00
MetaTile75:
  .byte $03,$00,$00,$6d,$a6,$6d,$a6,$00
MetaTile76:
  .byte $03,$00,$00,$a7,$7e,$a7,$7e,$00
MetaTile77:
  .byte $01,$00,$00,$a8,$a9,$b4,$b5,$00
MetaTile78:
  .byte $00,$00,$00,$a8,$a9,$b4,$b5,$00
MetaTile79:
  .byte $02,$00,$00,$a8,$a9,$b4,$b5,$00
MetaTile80:
  .byte $01,$00,$00,$9b,$9c,$aa,$ab,$00
MetaTile81:
  .byte $01,$00,$00,$9d,$9e,$ac,$ad,$00
MetaTile82:
  .byte $01,$00,$00,$9f,$a0,$ae,$af,$00
MetaTile83:
  .byte $02,$00,$00,$a1,$a2,$b0,$b1,$00
MetaTile84:
  .byte $03,$00,$00,$9d,$9e,$ac,$ad,$00
MetaTile85:
  .byte $03,$00,$00,$9f,$a0,$ae,$af,$00
MetaTile86:
  .byte $02,$00,$00,$a3,$a4,$b2,$b3,$00
MetaTile87:
  .byte $03,$00,$00,$b6,$b7,$bc,$bd,$00
MetaTile88:
  .byte $03,$00,$00,$b8,$b9,$bd,$bd,$00
MetaTile89:
  .byte $03,$00,$00,$ba,$bb,$bd,$be,$00
MetaTile90:
  .byte $00,$00,$00,$bf,$c0,$ca,$cb,$00
MetaTile91:
  .byte $00,$00,$00,$c1,$c1,$c1,$c1,$00
MetaTile92:
  .byte $00,$00,$00,$c2,$c3,$cc,$c3,$00
MetaTile93:
  .byte $02,$00,$00,$ee,$ef,$f6,$f7,$00
MetaTile94:
  .byte $01,$00,$00,$00,$0c,$10,$11,$00
MetaTile95:
  .byte $01,$00,$00,$0d,$00,$12,$13,$00
MetaTile96:
  .byte $01,$00,$00,$00,$00,$00,$00,$00
MetaTile97:
  .byte $00,$00,$00,$d3,$d4,$d3,$e1,$00
MetaTile98:
  .byte $00,$00,$00,$d5,$d6,$e2,$e3,$00
MetaTile99:
  .byte $00,$00,$00,$d7,$d8,$e4,$e5,$00
MetaTile100:
  .byte $01,$00,$00,$15,$16,$22,$23,$00
MetaTile101:
  .byte $01,$00,$00,$17,$18,$24,$25,$00
MetaTile102:
  .byte $01,$00,$00,$19,$1a,$26,$27,$00
MetaTile103:
  .byte $01,$00,$00,$1b,$1c,$28,$29,$00
MetaTile104:
  .byte $00,$00,$00,$c4,$c5,$cd,$ce,$00
MetaTile105:
  .byte $00,$00,$00,$c6,$c7,$cf,$d0,$00
MetaTile106:
  .byte $00,$00,$00,$c8,$c9,$d1,$d2,$00
MetaTile107:
  .byte $01,$00,$00,$c4,$c5,$cd,$ce,$00
MetaTile108:
  .byte $01,$00,$00,$c6,$c7,$cf,$d0,$00
MetaTile109:
  .byte $01,$00,$00,$c8,$c9,$d1,$d2,$00
MetaTile110:
  .byte $01,$00,$00,$85,$86,$92,$93,$00
MetaTile111:
  .byte $01,$00,$00,$85,$86,$92,$94,$00
MetaTile112:
  .byte $02,$00,$00,$bf,$c0,$ca,$cb,$00
MetaTile113:
  .byte $02,$00,$00,$c1,$c1,$c1,$c1,$00
MetaTile114:
  .byte $02,$00,$00,$c2,$c3,$cc,$c3,$00
MetaTile115:
  .byte $01,$00,$00,$33,$34,$43,$44,$00
MetaTile116:
  .byte $02,$00,$00,$2f,$30,$3f,$40,$00
MetaTile117:
  .byte $02,$00,$00,$31,$32,$41,$42,$00
MetaTile118:
  .byte $01,$00,$00,$35,$36,$45,$46,$00
MetaTile119:
  .byte $00,$00,$00,$d9,$da,$e6,$e7,$00
MetaTile120:
  .byte $00,$00,$00,$db,$dc,$e8,$e9,$00
MetaTile121:
  .byte $00,$00,$00,$dd,$de,$ea,$eb,$00
MetaTile122:
  .byte $01,$00,$00,$d9,$da,$e6,$e7,$00
MetaTile123:
  .byte $01,$00,$00,$db,$dc,$e8,$e9,$00
MetaTile124:
  .byte $01,$00,$00,$dd,$de,$ea,$eb,$00
MetaTile125:
  .byte $02,$00,$00,$d3,$d4,$d3,$e1,$00
MetaTile126:
  .byte $02,$00,$00,$d5,$d6,$e2,$e3,$00
MetaTile127:
  .byte $02,$00,$00,$d7,$d8,$e4,$e5,$00
MetaTile128:
  .byte $02,$00,$00,$4f,$50,$57,$58,$00
MetaTile129:
  .byte $02,$00,$00,$51,$52,$59,$5a,$00
MetaTile130:
  .byte $01,$00,$00,$df,$e0,$ec,$ed,$00
MetaTile131:
  .byte $00,$00,$00,$f0,$f1,$f8,$f9,$00
MetaTile132:
  .byte $00,$00,$00,$f2,$f3,$fa,$fb,$00
MetaTile133:
  .byte $00,$00,$00,$f4,$f5,$fc,$fd,$00
MetaTile134:
  .byte $01,$00,$00,$f0,$f1,$f8,$f9,$00
MetaTile135:
  .byte $01,$00,$00,$f2,$f3,$fa,$fb,$00
MetaTile136:
  .byte $01,$00,$00,$f4,$f5,$fc,$fd,$00
MetaTile137:
  .byte $02,$00,$00,$85,$86,$92,$93,$00
MetaTile138:
  .byte $02,$00,$00,$85,$86,$92,$94,$00
MetaTile139:
  .byte $01,$00,$00,$bf,$c0,$ca,$cb,$00
MetaTile140:
  .byte $01,$00,$00,$c1,$c1,$c1,$c1,$00
MetaTile141:
  .byte $01,$00,$00,$c2,$c3,$cc,$c3,$00
MetaTile142:
  .byte $01,$00,$00,$67,$68,$77,$78,$00
MetaTile143:
  .byte $02,$00,$00,$63,$64,$73,$74,$00
MetaTile144:
  .byte $02,$00,$00,$65,$66,$75,$76,$00
MetaTile145:
  .byte $01,$00,$00,$69,$6a,$79,$7a,$00
MetaTile146:
  .byte $02,$00,$00,$df,$e0,$ec,$ed,$00
MetaTile147:
  .byte $02,$00,$01,$c4,$c5,$cd,$ce,$00
MetaTile148:
  .byte $02,$00,$01,$c6,$c7,$cf,$d0,$00
MetaTile149:
  .byte $02,$00,$01,$c8,$c9,$d1,$d2,$00
MetaTile150:
  .byte $03,$00,$01,$c4,$c5,$cd,$ce,$00
MetaTile151:
  .byte $03,$00,$01,$c6,$c7,$cf,$d0,$00
MetaTile152:
  .byte $03,$00,$01,$c8,$c9,$d1,$d2,$00
MetaTile153:
  .byte $01,$00,$00,$d3,$d4,$d3,$e1,$00
MetaTile154:
  .byte $01,$00,$00,$d5,$d6,$e2,$e3,$00
MetaTile155:
  .byte $01,$00,$00,$d7,$d8,$e4,$e5,$00
MetaTile156:
  .byte $02,$00,$00,$81,$82,$8f,$90,$00
MetaTile157:
  .byte $02,$00,$00,$83,$84,$91,$84,$00
MetaTile158:
  .byte $03,$00,$00,$df,$e0,$ec,$ed,$00
MetaTile159:
  .byte $02,$00,$01,$d9,$da,$e6,$e7,$00
MetaTile160:
  .byte $02,$00,$01,$db,$dc,$e8,$e9,$00
MetaTile161:
  .byte $02,$00,$01,$dd,$de,$ea,$eb,$00
MetaTile162:
  .byte $03,$00,$01,$d9,$da,$e6,$e7,$00
MetaTile163:
  .byte $03,$00,$01,$db,$dc,$e8,$e9,$00
MetaTile164:
  .byte $03,$00,$01,$dd,$de,$ea,$eb,$00
MetaTile165:
  .byte $00,$00,$00,$85,$86,$92,$93,$00
MetaTile166:
  .byte $00,$00,$00,$85,$86,$92,$94,$00
MetaTile167:
  .byte $03,$00,$00,$ee,$ef,$f6,$f7,$00
MetaTile168:
  .byte $00,$00,$00,$ee,$ef,$f6,$f7,$00
MetaTile169:
  .byte $01,$00,$00,$ee,$ef,$f6,$f7,$00
MetaTile170:
  .byte $01,$00,$00,$a1,$a2,$b0,$b1,$00
MetaTile171:
  .byte $02,$00,$00,$9d,$9e,$ac,$ad,$00
MetaTile172:
  .byte $02,$00,$00,$9f,$a0,$ae,$af,$00
MetaTile173:
  .byte $01,$00,$00,$a3,$a4,$b2,$b3,$00
MetaTile174:
  .byte $00,$00,$00,$df,$e0,$ec,$ed,$00
MetaTile175:
  .byte $02,$00,$00,$f0,$f1,$f8,$f9,$00
MetaTile176:
  .byte $02,$00,$01,$f2,$f3,$fa,$fb,$00
MetaTile177:
  .byte $02,$00,$01,$f4,$f5,$fc,$fd,$00
MetaTile178:
  .byte $03,$00,$01,$f0,$f1,$f8,$f9,$00
MetaTile179:
  .byte $03,$00,$01,$f2,$f3,$fa,$fb,$00
MetaTile180:
  .byte $03,$00,$01,$f4,$f5,$fc,$fd,$00
MetaTile181:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_hippocritter
MetaTile182:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_exit
MetaTile183:
  .byte $00,$00,$00,$00,$00,$00,$00,entity_index_setrightmostx
