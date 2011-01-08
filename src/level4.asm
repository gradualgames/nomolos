.include "soundengine.inc"
.include "spritesheet1.inc"
.include "entities.inc"
.include "fixed_bank_data.inc"
.include "sound_effects.inc"

.segment "CODE"

.export level4_sprite_groups
level4_sprite_groups:
  .byte $03
  .word spritesheet1_Nomolos_chr
  .word spritesheet1_Explosion_chr
  .word spritesheet1_Phoenix_chr

.segment "ROM09"

.include "level4_patterns_source.inc"

.segment "ROM02"

.export level4_music
level4_music:
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

.export level4_palette
level4_palette:
  .byte $0d,$27,$17,$07,$0d,$05,$07,$16,$0d,$08,$18,$28,$0d,$07,$25,$15
  .byte $0d,$0d,$27,$20,$0d,$04,$29,$0d,$0d,$0d,$27,$16,$0d,$0d,$06,$18

.export level4_map
level4_map = Map

.export level4_map_column_table
level4_map_column_table = MapColumnTable

.export level4_attribute_column_table
level4_attribute_column_table = AttributeColumnTable

.export level4_meta_tile_column_table
level4_meta_tile_column_table = MetaTileColumnTable

.export level4_meta_tile_table
level4_meta_tile_table = MetaTileTable

Map:
  .byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0a,$0b,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c

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
  .byte $0a,$14,$14,$00
  .byte $0a,$14,$15,$00
  .byte $0a,$15,$15,$00
AttributeColumnTable:
  .byte $00,$00,$00,$00,$00,$00,$ac,$00
  .byte $00,$00,$00,$00,$00,$00,$a3,$00
  .byte $00,$55,$05,$00,$c0,$cc,$ac,$00
  .byte $50,$55,$05,$00,$f0,$ff,$af,$00
  .byte $00,$55,$05,$00,$00,$00,$80,$00
  .byte $00,$55,$00,$00,$0a,$ff,$cc,$0a
  .byte $50,$55,$00,$00,$02,$33,$00,$0a
  .byte $00,$55,$00,$00,$00,$40,$55,$0a
  .byte $00,$00,$00,$00,$00,$50,$55,$0a
  .byte $00,$00,$00,$00,$00,$10,$11,$02
  .byte $00,$00,$00,$00,$00,$00,$00,$00
MetaTileColumnTable:
  .byte $00,$04,$0d,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$29,$15,$00
  .byte $00,$05,$0e,$15,$15,$15,$15,$15,$15,$15,$15,$15,$31,$2a,$2e,$00
  .byte $00,$04,$0d,$15,$15,$15,$15,$15,$15,$15,$15,$30,$32,$2a,$2e,$00
  .byte $00,$05,$0e,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$2a,$2e,$00
  .byte $00,$05,$0f,$16,$1c,$15,$15,$15,$15,$15,$15,$15,$15,$2a,$2e,$00
  .byte $00,$06,$10,$17,$1d,$15,$15,$15,$15,$33,$35,$35,$35,$2a,$2e,$00
  .byte $01,$07,$11,$11,$1d,$15,$15,$15,$15,$34,$36,$36,$36,$2a,$2e,$00
  .byte $02,$08,$11,$18,$1d,$15,$15,$15,$15,$2f,$37,$37,$37,$2a,$2e,$00
  .byte $03,$09,$12,$19,$1c,$15,$15,$15,$15,$15,$15,$15,$15,$2b,$2e,$00
  .byte $00,$0a,$13,$19,$1c,$15,$15,$15,$15,$15,$15,$15,$15,$2c,$15,$00
  .byte $00,$0b,$0f,$1a,$15,$15,$15,$15,$22,$15,$1f,$24,$15,$15,$2a,$00
  .byte $00,$06,$10,$11,$41,$15,$15,$15,$1e,$15,$20,$25,$27,$28,$2a,$00
  .byte $01,$07,$11,$1b,$15,$15,$15,$15,$23,$15,$21,$26,$15,$2d,$2a,$00
  .byte $02,$08,$11,$18,$15,$15,$15,$15,$15,$15,$15,$15,$15,$2d,$2a,$00
  .byte $03,$09,$12,$19,$15,$15,$15,$15,$15,$15,$15,$15,$38,$3c,$2a,$00
  .byte $00,$0c,$14,$19,$15,$15,$15,$15,$15,$15,$15,$38,$3c,$3d,$2a,$00
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$39,$3d,$3d,$2a,$00
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$3a,$3e,$3d,$2a,$00
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$3b,$3f,$3d,$2a,$00
  .byte $40,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$00
  .byte $15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$15,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
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
  .byte $00,$00,$00,$21,$21,$21,$21,$00
MetaTile22:
  .byte $01,$00,$00,$3a,$2e,$3e,$35,$00
MetaTile23:
  .byte $01,$00,$00,$3b,$2e,$34,$35,$00
MetaTile24:
  .byte $01,$00,$00,$3c,$3d,$36,$37,$00
MetaTile25:
  .byte $01,$00,$00,$3c,$12,$36,$37,$00
MetaTile26:
  .byte $01,$00,$00,$3a,$2e,$3e,$3f,$00
MetaTile27:
  .byte $01,$00,$00,$2d,$2e,$40,$41,$00
MetaTile28:
  .byte $01,$00,$00,$42,$43,$46,$47,$00
MetaTile29:
  .byte $01,$00,$00,$44,$45,$48,$49,$00
MetaTile30:
  .byte $02,$00,$01,$4a,$4b,$50,$51,$00
MetaTile31:
  .byte $03,$00,$00,$21,$4c,$21,$52,$00
MetaTile32:
  .byte $03,$00,$00,$4d,$4e,$53,$54,$00
MetaTile33:
  .byte $03,$00,$00,$4f,$21,$55,$21,$00
MetaTile34:
  .byte $02,$00,$01,$56,$57,$5e,$5f,$00
MetaTile35:
  .byte $02,$00,$01,$58,$59,$60,$61,$00
MetaTile36:
  .byte $03,$00,$00,$21,$5a,$21,$21,$00
MetaTile37:
  .byte $03,$00,$00,$5b,$5c,$62,$63,$00
MetaTile38:
  .byte $03,$00,$00,$5d,$21,$21,$21,$00
MetaTile39:
  .byte $03,$00,$00,$64,$65,$67,$68,$00
MetaTile40:
  .byte $03,$00,$00,$73,$74,$7f,$80,$00
MetaTile41:
  .byte $02,$00,$01,$a7,$a8,$b1,$b2,$00
MetaTile42:
  .byte $02,$00,$01,$a9,$aa,$b3,$b4,$00
MetaTile43:
  .byte $00,$00,$00,$ab,$ac,$b5,$b6,$00
MetaTile44:
  .byte $02,$00,$01,$ad,$ae,$b7,$b8,$00
MetaTile45:
  .byte $00,$00,$00,$af,$b0,$b9,$ba,$00
MetaTile46:
  .byte $00,$00,$00,$bb,$bc,$bd,$be,$00
MetaTile47:
  .byte $03,$00,$01,$71,$72,$7d,$7e,$00
MetaTile48:
  .byte $00,$00,$00,$21,$21,$66,$21,$00
MetaTile49:
  .byte $03,$00,$00,$69,$6a,$75,$76,$00
MetaTile50:
  .byte $03,$00,$00,$6b,$6c,$77,$78,$00
MetaTile51:
  .byte $03,$00,$01,$6d,$6e,$79,$7a,$00
MetaTile52:
  .byte $03,$00,$01,$6f,$70,$7b,$7c,$00
MetaTile53:
  .byte $03,$00,$01,$81,$82,$87,$88,$00
MetaTile54:
  .byte $03,$00,$01,$83,$84,$89,$8a,$00
MetaTile55:
  .byte $03,$00,$01,$85,$86,$8b,$8c,$00
MetaTile56:
  .byte $01,$00,$00,$21,$21,$21,$91,$00
MetaTile57:
  .byte $01,$00,$00,$8d,$8e,$92,$93,$00
MetaTile58:
  .byte $01,$00,$00,$8f,$90,$94,$95,$00
MetaTile59:
  .byte $01,$00,$00,$21,$21,$96,$21,$00
MetaTile60:
  .byte $01,$00,$00,$97,$98,$9f,$a0,$00
MetaTile61:
  .byte $01,$00,$00,$99,$9a,$a1,$a2,$00
MetaTile62:
  .byte $01,$00,$00,$9b,$9c,$a3,$a4,$00
MetaTile63:
  .byte $01,$00,$00,$9d,$9e,$a5,$a6,$00
MetaTile64:
  .byte $00,$00,$00,$21,$21,$21,$21,entity_index_exit
MetaTile65:
  .byte $00,$00,$00,$21,$21,$21,$21,entity_index_phoenix
