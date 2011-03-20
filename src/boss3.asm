.include "spritesheet1.inc"
.include "soundengine.inc"
.include "sound_effects.inc"
.include "entities.inc"

.segment "CODE"

.export boss3_sprite_groups
boss3_sprite_groups:
  .byte $03
  .word spritesheet1_Nomolos_chr
  .word spritesheet1_Explosion_chr
  .word spritesheet1_GrubselimBoj_chr

.segment "ROM04"
  
.export boss3_palette
boss3_palette:
  .byte $0d,$07,$17,$27,$0d,$07,$05,$16,$0d,$08,$18,$28,$0d,$07,$15,$25
;spritesheet1_palette
  .byte $0d,$0d,$27,$20,$0d,$04,$2a,$0d,$0d,$0d,$07,$38,$0d,$00,$00,$00
  
.export boss3_music
boss3_music: 
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

.export boss3_map
boss3_map = Map

.export boss3_map_column_table
boss3_map_column_table = MapColumnTable

.export boss3_attribute_column_table
boss3_attribute_column_table = AttributeColumnTable

.export boss3_meta_tile_column_table
boss3_meta_tile_column_table = MetaTileColumnTable

.export boss3_meta_tile_table
boss3_meta_tile_table = MetaTileTable
  
Map:
  .byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
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
  .byte $09,$12,$13,$00
  .byte $0a,$14,$15,$00
  .byte $0b,$16,$17,$00
  .byte $0c,$17,$17,$00
AttributeColumnTable:
  .byte $aa,$aa,$aa,$aa,$aa,$6a,$55,$05
  .byte $aa,$aa,$aa,$aa,$6a,$55,$55,$05
  .byte $aa,$aa,$aa,$6a,$55,$55,$55,$05
  .byte $aa,$aa,$6a,$55,$55,$55,$55,$05
  .byte $aa,$6a,$55,$55,$5d,$55,$55,$05
  .byte $aa,$5a,$55,$55,$5f,$55,$55,$05
  .byte $aa,$9a,$55,$55,$57,$55,$55,$05
  .byte $aa,$aa,$9a,$55,$55,$55,$55,$05
  .byte $aa,$aa,$aa,$9a,$55,$55,$55,$05
  .byte $aa,$aa,$aa,$aa,$9a,$55,$55,$05
  .byte $a2,$aa,$aa,$aa,$aa,$9a,$55,$05
  .byte $aa,$aa,$aa,$aa,$aa,$aa,$9a,$09
  .byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$0a
MetaTileColumnTable:
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$56,$5e,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$30,$3d,$3d,$3d,$56,$5e,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$29,$3d,$3d,$56,$5e,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$31,$3d,$56,$5e,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$56,$5e,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$56,$5e,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$56,$5e,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$56,$5e,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$56,$5e,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$56,$5e,$5f,$5f,$5f,$42,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$57,$5f,$5f,$5f,$5f,$43,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$58,$5f,$5f,$5f,$5f,$43,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$59,$61,$5f,$5f,$5f,$44,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$59,$61,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$59,$61,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$59,$61,$5f,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$59,$61,$5f,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$59,$61,$5f,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$30,$3d,$59,$61,$5f,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$29,$3d,$3d,$59,$61,$5f,$5f,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$31,$3d,$3d,$3d,$59,$61,$5f,$5f,$00
  .byte $78,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$59,$61,$5f,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$59,$61,$00
  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$00
MetaTileTable:
MetaTile0:
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .byte $00,$00,$00,$00,$01,$04,$05,$00
MetaTile2:
  .byte $00,$00,$00,$02,$03,$06,$07,$00
MetaTile3:
  .byte $00,$00,$00,$00,$00,$08,$00,$00
MetaTile4:
  .byte $00,$00,$00,$09,$0a,$16,$17,$00
MetaTile5:
  .byte $00,$00,$00,$0b,$0c,$18,$19,$00
MetaTile6:
  .byte $00,$00,$00,$0d,$0e,$1a,$1b,$00
MetaTile7:
  .byte $01,$00,$00,$0f,$10,$1c,$1d,$00
MetaTile8:
  .byte $01,$00,$00,$11,$12,$1e,$1f,$00
MetaTile9:
  .byte $00,$00,$00,$13,$14,$20,$21,$00
MetaTile10:
  .byte $00,$00,$00,$00,$00,$22,$00,$00
MetaTile11:
  .byte $00,$00,$00,$00,$15,$23,$24,$00
MetaTile12:
  .byte $00,$00,$00,$00,$00,$25,$00,$00
MetaTile13:
  .byte $00,$00,$00,$26,$27,$21,$21,$00
MetaTile14:
  .byte $00,$00,$00,$28,$29,$21,$21,$00
MetaTile15:
  .byte $01,$00,$00,$21,$2a,$30,$31,$00
MetaTile16:
  .byte $01,$00,$00,$2b,$2c,$32,$33,$00
MetaTile17:
  .byte $01,$00,$00,$2d,$2e,$34,$35,$00
MetaTile18:
  .byte $01,$00,$00,$11,$12,$36,$37,$00
MetaTile19:
  .byte $01,$00,$00,$2f,$21,$38,$21,$00
MetaTile20:
  .byte $01,$00,$00,$2f,$21,$38,$39,$00
MetaTile21:
  .byte $00,$00,$00,$21,$4c,$21,$52,$00
MetaTile22:
  .byte $00,$00,$00,$4d,$4e,$53,$54,$00
MetaTile23:
  .byte $00,$00,$00,$4f,$21,$55,$21,$00
MetaTile24:
  .byte $00,$00,$00,$21,$21,$21,$21,$00
MetaTile25:
  .byte $01,$00,$00,$3a,$2e,$3e,$35,$00
MetaTile26:
  .byte $01,$00,$00,$3b,$2e,$34,$35,$00
MetaTile27:
  .byte $01,$00,$00,$3c,$3d,$36,$37,$00
MetaTile28:
  .byte $01,$00,$00,$3c,$12,$36,$37,$00
MetaTile29:
  .byte $01,$00,$00,$3a,$2e,$3e,$3f,$00
MetaTile30:
  .byte $01,$00,$00,$2d,$2e,$40,$41,$00
MetaTile31:
  .byte $00,$00,$00,$21,$5a,$21,$21,$00
MetaTile32:
  .byte $00,$00,$00,$5b,$5c,$62,$63,$00
MetaTile33:
  .byte $00,$00,$00,$5d,$21,$21,$21,$00
MetaTile34:
  .byte $01,$00,$00,$42,$43,$46,$47,$00
MetaTile35:
  .byte $01,$00,$00,$44,$45,$48,$49,$00
MetaTile36:
  .byte $00,$00,$00,$64,$65,$67,$68,$00
MetaTile37:
  .byte $00,$00,$00,$73,$74,$7f,$80,$00
MetaTile38:
  .byte $00,$00,$00,$56,$57,$5e,$5f,$00
MetaTile39:
  .byte $00,$00,$00,$4a,$4b,$50,$51,$00
MetaTile40:
  .byte $00,$00,$00,$58,$59,$60,$61,$00
MetaTile41:
  .byte $02,$00,$01,$4a,$4b,$50,$51,$00
MetaTile42:
  .byte $03,$00,$00,$21,$4c,$21,$52,$00
MetaTile43:
  .byte $03,$00,$00,$4d,$4e,$53,$54,$00
MetaTile44:
  .byte $03,$00,$00,$4f,$21,$55,$21,$00
MetaTile45:
  .byte $02,$00,$00,$21,$4c,$21,$52,$00
MetaTile46:
  .byte $02,$00,$00,$4d,$4e,$53,$54,$00
MetaTile47:
  .byte $02,$00,$00,$4f,$21,$55,$21,$00
MetaTile48:
  .byte $02,$00,$01,$56,$57,$5e,$5f,$00
MetaTile49:
  .byte $02,$00,$01,$58,$59,$60,$61,$00
MetaTile50:
  .byte $03,$00,$00,$21,$5a,$21,$21,$00
MetaTile51:
  .byte $03,$00,$00,$5b,$5c,$62,$63,$00
MetaTile52:
  .byte $03,$00,$00,$5d,$21,$21,$21,$00
MetaTile53:
  .byte $02,$00,$00,$21,$5a,$21,$21,$00
MetaTile54:
  .byte $02,$00,$00,$5b,$5c,$62,$63,$00
MetaTile55:
  .byte $02,$00,$00,$5d,$21,$21,$21,$00
MetaTile56:
  .byte $03,$00,$00,$56,$57,$5e,$5f,$00
MetaTile57:
  .byte $03,$00,$00,$4a,$4b,$50,$51,$00
MetaTile58:
  .byte $03,$00,$00,$58,$59,$60,$61,$00
MetaTile59:
  .byte $03,$00,$00,$64,$65,$67,$68,$00
MetaTile60:
  .byte $00,$00,$00,$21,$21,$66,$21,$00
MetaTile61:
  .byte $02,$00,$00,$21,$21,$21,$21,$00
MetaTile62:
  .byte $02,$00,$00,$64,$65,$67,$68,$00
MetaTile63:
  .byte $00,$00,$00,$6d,$6e,$79,$7a,$00
MetaTile64:
  .byte $00,$00,$00,$6f,$70,$7b,$7c,$00
MetaTile65:
  .byte $00,$00,$00,$71,$72,$7d,$7e,$00
MetaTile66:
  .byte $03,$00,$01,$6d,$6e,$79,$7a,$00
MetaTile67:
  .byte $03,$00,$01,$6f,$70,$7b,$7c,$00
MetaTile68:
  .byte $03,$00,$01,$71,$72,$7d,$7e,$00
MetaTile69:
  .byte $03,$00,$00,$73,$74,$7f,$80,$00
MetaTile70:
  .byte $03,$00,$00,$69,$6a,$75,$76,$00
MetaTile71:
  .byte $03,$00,$00,$6b,$6c,$77,$78,$00
MetaTile72:
  .byte $02,$00,$00,$73,$74,$7f,$80,$00
MetaTile73:
  .byte $00,$00,$00,$81,$82,$87,$88,$00
MetaTile74:
  .byte $00,$00,$00,$83,$84,$89,$8a,$00
MetaTile75:
  .byte $00,$00,$00,$85,$86,$8b,$8c,$00
MetaTile76:
  .byte $03,$00,$00,$81,$82,$87,$88,$00
MetaTile77:
  .byte $03,$00,$00,$83,$84,$89,$8a,$00
MetaTile78:
  .byte $03,$00,$00,$85,$86,$8b,$8c,$00
MetaTile79:
  .byte $02,$00,$00,$21,$21,$66,$21,$00
MetaTile80:
  .byte $00,$00,$00,$8d,$8e,$97,$98,$00
MetaTile81:
  .byte $00,$00,$00,$8f,$90,$99,$9a,$00
MetaTile82:
  .byte $00,$00,$00,$91,$92,$9b,$9c,$00
MetaTile83:
  .byte $03,$00,$00,$8d,$8e,$97,$98,$00
MetaTile84:
  .byte $03,$00,$00,$8f,$90,$99,$9a,$00
MetaTile85:
  .byte $03,$00,$00,$91,$92,$9b,$9c,$00
MetaTile86:
  .byte $01,$00,$00,$21,$21,$21,$9d,$00
MetaTile87:
  .byte $01,$00,$00,$93,$94,$9e,$9f,$00
MetaTile88:
  .byte $01,$00,$00,$95,$96,$a0,$a1,$00
MetaTile89:
  .byte $01,$00,$00,$21,$21,$a2,$21,$00
MetaTile90:
  .byte $02,$00,$00,$69,$6a,$75,$76,$00
MetaTile91:
  .byte $02,$00,$00,$6b,$6c,$77,$78,$00
MetaTile92:
  .byte $00,$00,$00,$69,$6a,$75,$76,$00
MetaTile93:
  .byte $00,$00,$00,$6b,$6c,$77,$78,$00
MetaTile94:
  .byte $01,$00,$00,$a3,$a4,$ab,$ac,$00
MetaTile95:
  .byte $01,$00,$00,$a5,$a6,$ad,$ae,$00
MetaTile96:
  .byte $01,$00,$00,$a7,$a8,$af,$b0,$00
MetaTile97:
  .byte $01,$00,$00,$a9,$aa,$b1,$b2,$00
MetaTile98:
  .byte $02,$00,$00,$6d,$6e,$79,$7a,$00
MetaTile99:
  .byte $02,$00,$00,$6f,$70,$7b,$7c,$00
MetaTile100:
  .byte $02,$00,$00,$71,$72,$7d,$7e,$00
MetaTile101:
  .byte $02,$00,$00,$b3,$b4,$bd,$be,$00
MetaTile102:
  .byte $02,$00,$00,$b5,$b6,$bf,$c0,$00
MetaTile103:
  .byte $00,$00,$00,$b7,$b8,$c1,$c2,$00
MetaTile104:
  .byte $02,$00,$00,$b9,$ba,$c3,$c4,$00
MetaTile105:
  .byte $00,$00,$00,$bb,$bc,$c5,$c6,$00
MetaTile106:
  .byte $02,$00,$00,$81,$82,$87,$88,$00
MetaTile107:
  .byte $02,$00,$00,$83,$84,$89,$8a,$00
MetaTile108:
  .byte $02,$00,$00,$85,$86,$8b,$8c,$00
MetaTile109:
  .byte $00,$00,$00,$c7,$c8,$c9,$ca,$00
MetaTile110:
  .byte $00,$00,$00,$b3,$b4,$bd,$be,$00
MetaTile111:
  .byte $00,$00,$00,$b5,$b6,$bf,$c0,$00
MetaTile112:
  .byte $00,$00,$00,$b9,$ba,$c3,$c4,$00
MetaTile113:
  .byte $03,$00,$00,$b3,$b4,$bd,$be,$00
MetaTile114:
  .byte $03,$00,$00,$b5,$b6,$bf,$c0,$00
MetaTile115:
  .byte $03,$00,$00,$b9,$ba,$c3,$c4,$00
MetaTile116:
  .byte $03,$00,$00,$21,$21,$21,$21,$00
MetaTile117:
  .byte $02,$00,$00,$8d,$8e,$97,$98,$00
MetaTile118:
  .byte $02,$00,$00,$8f,$90,$99,$9a,$00
MetaTile119:
  .byte $02,$00,$00,$91,$92,$9b,$9c,$00
MetaTile120:
  .byte $00,$00,$00,$21,$21,$21,$21,entity_index_exit
