.include "soundengine.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export level2_2sprite_groups
level2_2sprite_groups:
  .byte $07
  .word spritesheet1_Nomolos_chr
  .word spritesheet1_Deentle_chr
  .word spritesheet1_Explosion_chr
  .word spritesheet1_Beedie_chr
  .word spritesheet1_Grank_chr
  .word spritesheet1_Skelekin_chr
  .word spritesheet1_Bat_chr

.segment "ROM01"

.export level2_2music
level2_2music:
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
  .byte 15,13,12,10,9,8,7,7,6,5,5,4,4,3,3,2,2,2,2,1,1,1,1,1,0,ENV_STOP
volume_envelope_3:
  .byte 1,1,1,2,2,3,5,6,8,11,ENV_STOP
volume_envelope_4:
  .byte 1,1,1,2,2,3,5,6,8,11,ENV_STOP
volume_envelope_5:
  .byte 15,15,14,14,13,12,12,11,10,10,9,9,8,7,7,6,5,5,4,4,3,2,2,1,0,ENV_STOP
volume_envelope_6:
  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP

Square1:
  .byte STV,1,STP,0,SDU,0,STL,11,G2,STV,0,A0,STV,1,G2,STV,0,STL,55,A0,STV,1,STL,11
  .byte GS2,STV,0,A0,STV,1,G2,STV,0,STL,55,A0,STV,1,STL,11,F2,STV,0,A0,STV,1,D2,STV
  .byte 0,A0,STV,1,GS2,STV,0,A0,STV,1,F2,STV,0,A0,STV,1,B2,STV,0,A0,STV,1,GS2,STV
  .byte 0,A0,STV,1,C3,STV,0,A0,STV,1,B2,STV,0,A0,STV,2,DS2,D2,F2,DS2,G2,F2,GS2,G2
  .byte DS2,D2,F2,DS2,G2,F2,GS2,G2,C2,AS1,D2,C2,DS2,D2,F2,DS2,C2,AS1,D2,C2,DS2,D2,F2,DS2
  .byte DS2,D2,F2,DS2,G2,F2,GS2,G2,C2,B1,D2,C2,DS2,D2,F2,DS2,G2,F2,GS2,G2,AS2,GS2,C3,AS2
  .byte G2,F2,GS2,G2,AS2,GS2,C3,AS2
  .byte GOT
  .word Square1

Square2:
  .byte STV,1,STP,0,SDU,0,STL,11,DS3,STV,0,A0,STV,1,C3,STV,0,STL,55,A0,STV,1,STL,11
  .byte F3,STV,0,A0,STV,1,DS3,STV,0,STL,55,A0,STV,1,STL,11,GS2,STV,0,A0,STV,1,F2,STV
  .byte 0,A0,STV,1,B2,STV,0,A0,STV,1,GS2,STV,0,A0,STV,1,D3,STV,0,A0,STV,1,B2,STV
  .byte 0,A0,STV,1,FS3,STV,0,A0,STV,1,G3,STV,3,STL,22,G3,GS3,AS3,C4,STL,88,G3,STL,22
  .byte GS3,AS3,C4,D4,STL,88,GS3,STL,22,G3,D3,DS3,F3,STL,88,G3,STL,22,AS3,GS3,AS3,D4,STL,99
  .byte DS4
  .byte GOT
  .word Square2

Triangle:
  .byte STV,2,STP,0,SDU,0,STL,11,C2,STV,0,A0,STV,2,G2,STV,0,A0,STV,2,C3,STV,0,A0
  .byte STV,2,G2,STV,0,A0,STV,2,DS2,STV,0,A0,STV,2,C2,STV,0,A0,STV,2,DS2,STV,0,A0
  .byte STV,2,G2,STV,0,A0,STV,2,D2,STV,0,A0,STV,2,F2,STV,0,A0,STV,2,B2,STV,0,A0
  .byte STV,2,GS2,STV,0,A0,STV,2,F2,STV,0,A0,STV,2,D2,STV,0,A0,STV,2,FS2,STV,0,A0
  .byte STV,2,G2,STV,0,A0,STV,2,C2,STV,0,A0,STV,2,C3,STV,0,A0,STV,2,C2,STV,0,A0
  .byte STV,2,C3,STV,0,A0,STV,2,C2,STV,0,A0,STV,2,C3,STV,0,A0,STV,2,C2,STV,0,A0
  .byte STV,2,C3,STV,0,A0,STV,2,GS1,STV,0,A0,STV,2,GS2,STV,0,A0,STV,2,GS1,STV,0,A0
  .byte STV,2,GS2,STV,0,A0,STV,2,GS1,STV,0,A0,STV,2,GS2,STV,0,A0,STV,2,GS1,STV,0,A0
  .byte STV,2,GS2,STV,0,A0,STV,1,C2,STV,0,A0,STV,1,C3,STV,0,A0,STV,1,C2,STV,0,A0
  .byte STV,1,C3,STV,0,A0,STV,1,C2,STV,0,A0,STV,1,C3,STV,0,A0,STV,1,C2,STV,0,A0
  .byte STV,1,C3,STV,0,A0,STV,1,DS2,STV,0,A0,STV,1,DS3,STV,0,A0,STV,1,DS2,STV,0,A0
  .byte STV,1,DS3,STV,0,A0,STV,1,DS2,STV,0,A0,STV,1,DS3,STV,0,A0,STV,1,DS2,STV,0,A0
  .byte STV,1,DS3,STV,0,A0
  .byte GOT
  .word Triangle

Noise:
  .byte STV,2,STP,0,SDU,0,STL,22,3,STL,66,7,STL,22,3,STL,66,7,STL,22,3,STL,11,7
  .byte 7,STL,22,7,STL,44,7,STL,22,7,STL,11,7,STV,0,STL,255,A0,STL,255,A0,STL,227,A0

  .byte GOT
  .word Noise

.export level2_2palette
level2_2palette:
  .byte $0d,$00,$00,$02,$0d,$07,$06,$0c,$0d,$00,$00,$04,$0d,$00,$28,$08
;spritesheet1_palette
  .byte $0d,$0d,$27,$20,$0d,$04,$2a,$0d,$0d,$0d,$07,$38,$0d,$21,$21,$21

.export level2_2cycling_palettes
level2_2cycling_palettes:
  .byte 4
  .byte $0d,$00,$00,$02,$0d,$07,$06,$0c,$0d,$00,$00,$04,$0d,$00,$28,$08
  .byte $0d,$00,$00,$02,$0d,$07,$06,$0c,$0d,$00,$00,$04,$0d,$00,$28,$08
  .byte $0d,$00,$00,$02,$0d,$07,$06,$0c,$0d,$00,$00,$04,$0d,$00,$28,$08
  .byte $0d,$00,$00,$02,$0d,$07,$06,$0c,$0d,$00,$00,$04,$0d,$00,$28,$08

.export level2_2map
level2_2map = Map

.export level2_2map_column_table
level2_2map_column_table = MapColumnTable

.export level2_2attribute_column_table
level2_2attribute_column_table = AttributeColumnTable

.export level2_2meta_tile_column_table
level2_2meta_tile_column_table = MetaTileColumnTable

.export level2_2meta_tile_table
level2_2meta_tile_table = MetaTileTable

Map:
  .byte $00,$00,$00,$01,$02,$02,$02,$03,$04,$05,$06,$04,$05,$07,$08,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09

MapColumnTable:
  .byte $00,$00,$00,$00
  .byte $01,$01,$01,$00
  .byte $02,$02,$02,$00
  .byte $03,$02,$03,$00
  .byte $00,$04,$05,$00
  .byte $00,$06,$07,$00
  .byte $04,$08,$09,$00
  .byte $00,$0a,$0a,$00
  .byte $05,$0a,$0b,$00
  .byte $06,$0c,$0c,$00
AttributeColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
  .byte $55,$55,$55,$55,$00,$00,$00,$00
  .byte $00,$00,$00,$55,$00,$00,$00,$00
  .byte $00,$00,$00,$11,$00,$00,$00,$00
  .byte $00,$ff,$0f,$00,$00,$00,$00,$00
  .byte $44,$40,$44,$44,$44,$44,$44,$04
  .byte $55,$55,$55,$55,$55,$55,$55,$05
MetaTileColumnTable:
  .byte $07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $19,$19,$19,$19,$19,$19,$19,$19,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $07,$07,$07,$07,$07,$07,$19,$19,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $07,$07,$07,$07,$07,$07,$30,$30,$07,$07,$07,$07,$07,$07,$07,$00
  .byte $00,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$07,$07,$07,$00
  .byte $01,$11,$1e,$2a,$36,$10,$10,$10,$10,$10,$10,$10,$07,$07,$07,$00
  .byte $02,$12,$1f,$2b,$37,$41,$10,$10,$10,$10,$10,$10,$07,$07,$07,$00
  .byte $03,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$07,$07,$07,$00
  .byte $10,$10,$74,$7e,$85,$10,$10,$10,$10,$10,$10,$10,$07,$07,$07,$00
  .byte $10,$10,$75,$7f,$86,$10,$10,$10,$10,$10,$10,$10,$07,$07,$07,$00
  .byte $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$07,$07,$07,$00
  .byte $19,$19,$90,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$00
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
  .byte $02,$00,$00,$86,$87,$92,$93,$00
MetaTile6:
  .byte $00,$00,$00,$0b,$0c,$17,$18,$00
MetaTile7:
  .byte $00,$00,$01,$0d,$0e,$19,$1a,$00
MetaTile8:
  .byte $01,$00,$00,$0d,$0e,$19,$1a,$00
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
  .byte $01,$00,$00,$ce,$c8,$d8,$d9,$00
MetaTile62:
  .byte $01,$00,$00,$c8,$c8,$d9,$d9,$00
MetaTile63:
  .byte $01,$00,$00,$c8,$cf,$d9,$da,$00
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
  .byte $02,$00,$00,$ce,$c8,$d8,$d9,$00
MetaTile81:
  .byte $02,$00,$00,$c8,$c8,$d9,$d9,$00
MetaTile82:
  .byte $02,$00,$00,$c8,$cf,$d9,$da,$00
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
  .byte $03,$00,$00,$ce,$c8,$d8,$d9,$00
MetaTile100:
  .byte $03,$00,$00,$c8,$c8,$d9,$d9,$00
MetaTile101:
  .byte $03,$00,$00,$c8,$cf,$d9,$da,$00
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
  .byte $01,$00,$00,$7e,$7f,$0a,$0a,$00
MetaTile139:
  .byte $01,$00,$00,$80,$81,$0a,$0a,$00
MetaTile140:
  .byte $01,$00,$00,$82,$83,$0a,$0a,$00
MetaTile141:
  .byte $01,$00,$00,$84,$0a,$0a,$0a,$00
MetaTile142:
  .byte $03,$00,$00,$0a,$ea,$0a,$ec,$00
MetaTile143:
  .byte $03,$00,$00,$eb,$0a,$ed,$0a,$00
MetaTile144:
  .byte $00,$00,$00,$0a,$0a,$0a,$0a,entity_index_exit
