
;Meta Sprite Table
.export NomolosWalk0
NomolosWalk0:
  .byte $08
  .byte $00,$00,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$18,$03,$00,$08
  .byte $08,$19,$03,$08,$00
  .byte $10,$2b,$03,$00,$08
  .byte $10,$2c,$03,$08,$00
  .byte $18,$3e,$03,$00,$08
  .byte $18,$3f,$03,$08,$00
.export NomolosWalk1
NomolosWalk1:
  .byte $08
  .byte $00,$02,$03,$00,$08
  .byte $00,$03,$03,$08,$00
  .byte $08,$1a,$00,$00,$08
  .byte $08,$1b,$03,$08,$00
  .byte $10,$2d,$03,$00,$08
  .byte $10,$2e,$03,$08,$00
  .byte $18,$40,$03,$00,$08
  .byte $18,$41,$03,$08,$00
.export NomolosWalk2
NomolosWalk2:
  .byte $08
  .byte $00,$05,$03,$00,$08
  .byte $00,$06,$03,$08,$00
  .byte $08,$1c,$03,$00,$08
  .byte $08,$1d,$03,$08,$00
  .byte $10,$2f,$03,$00,$08
  .byte $10,$30,$03,$08,$00
  .byte $18,$42,$03,$00,$08
  .byte $18,$43,$03,$08,$00
.export NomolosJump0
NomolosJump0:
  .byte $08
  .byte $00,$07,$03,$00,$08
  .byte $00,$08,$03,$08,$00
  .byte $08,$1e,$03,$00,$08
  .byte $08,$1f,$03,$08,$00
  .byte $10,$31,$03,$00,$08
  .byte $10,$32,$03,$08,$00
  .byte $18,$44,$03,$00,$08
  .byte $18,$45,$03,$08,$00
.export NomolosWalkOverlay0
NomolosWalkOverlay0:
  .byte $04
  .byte $01,$0d,$02,$00,$08
  .byte $01,$0e,$02,$08,$00
  .byte $09,$24,$02,$00,$08
  .byte $09,$25,$02,$08,$00
.export NomolosWalkOverlay1
NomolosWalkOverlay1:
  .byte $04
  .byte $01,$0f,$02,$00,$08
  .byte $01,$10,$02,$08,$00
  .byte $09,$26,$02,$00,$08
  .byte $09,$27,$02,$08,$00
.export NomolosWalkOverlay2
NomolosWalkOverlay2:
  .byte $04
  .byte $01,$0f,$02,$00,$08
  .byte $01,$11,$02,$08,$00
  .byte $09,$26,$02,$00,$08
  .byte $09,$27,$02,$08,$00
.export NomolosJumpOverlay0
NomolosJumpOverlay0:
  .byte $04
  .byte $01,$0d,$02,$00,$08
  .byte $01,$12,$02,$08,$00
  .byte $09,$24,$02,$00,$08
  .byte $09,$25,$02,$08,$00
.export Heart0
Heart0:
  .byte $01
  .byte $00,$39,$02,$00,$00
.export Deentle0
Deentle0:
  .byte $04
  .byte $00,$50,$03,$00,$08
  .byte $00,$51,$03,$08,$00
  .byte $08,$64,$03,$00,$08
  .byte $08,$65,$03,$08,$00
.export Deentle1
Deentle1:
  .byte $04
  .byte $00,$52,$03,$00,$08
  .byte $00,$53,$03,$08,$00
  .byte $08,$66,$03,$00,$08
  .byte $08,$67,$03,$08,$00
.export Explosion0
Explosion0:
  .byte $04
  .byte $00,$54,$03,$00,$08
  .byte $00,$55,$03,$08,$00
  .byte $08,$68,$03,$00,$08
  .byte $08,$69,$03,$08,$00
.export Explosion1
Explosion1:
  .byte $04
  .byte $00,$56,$03,$00,$08
  .byte $00,$57,$03,$08,$00
  .byte $08,$6a,$03,$00,$08
  .byte $08,$6b,$03,$08,$00
.export Explosion2
Explosion2:
  .byte $04
  .byte $00,$58,$03,$00,$08
  .byte $00,$59,$03,$08,$00
  .byte $08,$6c,$03,$00,$08
  .byte $08,$6d,$03,$08,$00
.export Mouse0
Mouse0:
  .byte $02
  .byte $00,$5a,$02,$00,$08
  .byte $00,$5b,$00,$08,$00
.export SlumpedArmor0
SlumpedArmor0:
  .byte $06
  .byte $08,$6f,$00,$00,$08
  .byte $08,$70,$00,$08,$00
  .byte $10,$89,$03,$00,$08
  .byte $10,$8a,$03,$08,$00
  .byte $18,$9f,$03,$00,$08
  .byte $18,$a0,$03,$08,$00
.export SlumpedArmorOverlay0
SlumpedArmorOverlay0:
  .byte $02
  .byte $08,$6e,$02,$00,$00
  .byte $10,$88,$02,$00,$00
.export ScardyCat0
ScardyCat0:
  .byte $08
  .byte $00,$5c,$03,$00,$08
  .byte $00,$5d,$03,$08,$00
  .byte $08,$71,$03,$00,$08
  .byte $08,$72,$03,$08,$00
  .byte $10,$8b,$03,$00,$08
  .byte $10,$8c,$03,$08,$00
  .byte $18,$a1,$03,$00,$08
  .byte $18,$a2,$03,$08,$00
.export ScardyCatOverlay0
ScardyCatOverlay0:
  .byte $04
  .byte $08,$73,$02,$00,$08
  .byte $08,$74,$02,$08,$00
  .byte $10,$8d,$02,$00,$08
  .byte $10,$8e,$02,$08,$00
.export NomolosFight0
NomolosFight0:
  .byte $0a
  .byte $f8,$4c,$03,$00,$08
  .byte $f8,$17,$00,$08,$00
  .byte $00,$5e,$03,$00,$08
  .byte $00,$5f,$03,$08,$00
  .byte $08,$75,$03,$00,$08
  .byte $08,$76,$03,$08,$00
  .byte $10,$8f,$03,$00,$08
  .byte $10,$90,$03,$08,$00
  .byte $18,$a3,$03,$00,$08
  .byte $18,$a4,$03,$08,$00
.export NomolosFight1
NomolosFight1:
  .byte $10
  .byte $00,$60,$03,$00,$08
  .byte $00,$61,$03,$08,$00
  .byte $00,$62,$00,$10,$f8
  .byte $00,$17,$00,$18,$f0
  .byte $08,$77,$03,$00,$08
  .byte $08,$78,$03,$08,$00
  .byte $08,$79,$03,$10,$f8
  .byte $08,$7a,$03,$18,$f0
  .byte $10,$91,$03,$00,$08
  .byte $10,$92,$03,$08,$00
  .byte $10,$93,$03,$10,$f8
  .byte $10,$94,$03,$18,$f0
  .byte $18,$a5,$03,$00,$08
  .byte $18,$a6,$03,$08,$00
  .byte $18,$a7,$03,$10,$f8
  .byte $18,$17,$00,$18,$f0
.export NomolosFightOverlay0
NomolosFightOverlay0:
  .byte $04
  .byte $01,$13,$02,$00,$08
  .byte $01,$14,$02,$08,$00
  .byte $09,$17,$00,$00,$08
  .byte $09,$28,$02,$08,$00
.export NomolosFightOverlay1
NomolosFightOverlay1:
  .byte $04
  .byte $01,$15,$02,$00,$08
  .byte $01,$16,$02,$08,$00
  .byte $09,$29,$02,$00,$08
  .byte $09,$2a,$02,$08,$00
.export OneUp0
OneUp0:
  .byte $04
  .byte $00,$3d,$00,$00,$08
  .byte $00,$3d,$00,$08,$00
  .byte $08,$4d,$03,$00,$08
  .byte $08,$4e,$03,$08,$00
.export NomolosUseFlail0
NomolosUseFlail0:
  .byte $0c
  .byte $00,$09,$03,$00,$08
  .byte $00,$0a,$03,$08,$00
  .byte $00,$0b,$03,$10,$f8
  .byte $08,$20,$03,$00,$08
  .byte $08,$21,$03,$08,$00
  .byte $08,$22,$03,$10,$f8
  .byte $10,$33,$03,$00,$08
  .byte $10,$34,$03,$08,$00
  .byte $10,$35,$03,$10,$f8
  .byte $18,$46,$03,$00,$08
  .byte $18,$47,$03,$08,$00
  .byte $18,$48,$03,$10,$f8
.export NomolosUseFlail1
NomolosUseFlail1:
  .byte $0c
  .byte $00,$0c,$03,$00,$08
  .byte $00,$0a,$03,$08,$00
  .byte $00,$0b,$03,$10,$f8
  .byte $08,$23,$03,$00,$08
  .byte $08,$21,$03,$08,$00
  .byte $08,$22,$03,$10,$f8
  .byte $10,$36,$03,$00,$08
  .byte $10,$37,$03,$08,$00
  .byte $10,$38,$03,$10,$f8
  .byte $18,$49,$03,$00,$08
  .byte $18,$4a,$03,$08,$00
  .byte $18,$4b,$03,$10,$f8
.export FlailBall0
FlailBall0:
  .byte $01
  .byte $f0,$3a,$03,$ea,$16
.export FlailBall1
FlailBall1:
  .byte $01
  .byte $ec,$3a,$03,$00,$00
.export FlailBall2
FlailBall2:
  .byte $01
  .byte $f0,$3a,$03,$16,$ea
.export FlailBall3
FlailBall3:
  .byte $01
  .byte $00,$3a,$03,$28,$d8
.export FlailBall4
FlailBall4:
  .byte $01
  .byte $10,$3a,$03,$16,$ea
.export FlailBall5
FlailBall5:
  .byte $01
  .byte $14,$3a,$03,$00,$00
.export FlailBall6
FlailBall6:
  .byte $01
  .byte $10,$3a,$03,$ea,$16
.export FlailBall7
FlailBall7:
  .byte $01
  .byte $00,$3a,$03,$d8,$28
.export NomolosFlailOverlay0
NomolosFlailOverlay0:
  .byte $04
  .byte $01,$13,$02,$03,$05
  .byte $01,$14,$02,$0b,$fd
  .byte $09,$17,$00,$03,$05
  .byte $09,$28,$02,$0b,$fd
.export FlailItem0
FlailItem0:
  .byte $02
  .byte $00,$3b,$03,$00,$08
  .byte $00,$3c,$03,$08,$00
.export Beedie0
Beedie0:
  .byte $04
  .byte $00,$80,$02,$00,$08
  .byte $00,$81,$02,$08,$00
  .byte $08,$97,$02,$00,$08
  .byte $08,$98,$02,$08,$00
.export Beedie1
Beedie1:
  .byte $04
  .byte $00,$82,$02,$00,$08
  .byte $00,$83,$02,$08,$00
  .byte $08,$99,$02,$00,$08
  .byte $08,$9a,$02,$08,$00
.export Grank0
Grank0:
  .byte $04
  .byte $00,$84,$01,$00,$08
  .byte $00,$85,$01,$08,$00
  .byte $08,$9b,$01,$00,$08
  .byte $08,$9c,$01,$08,$00
.export Grank1
Grank1:
  .byte $04
  .byte $00,$86,$01,$00,$08
  .byte $00,$87,$01,$08,$00
  .byte $08,$9d,$01,$00,$08
  .byte $08,$9e,$01,$08,$00
.export NomolosUseSpear0
NomolosUseSpear0:
  .byte $0a
  .byte $f8,$4f,$03,$00,$08
  .byte $f8,$17,$00,$08,$00
  .byte $00,$63,$03,$00,$08
  .byte $00,$5f,$03,$08,$00
  .byte $08,$7b,$03,$00,$08
  .byte $08,$76,$03,$08,$00
  .byte $10,$95,$03,$00,$08
  .byte $10,$90,$03,$08,$00
  .byte $18,$a3,$03,$00,$08
  .byte $18,$a4,$03,$08,$00
.export NomolosUseSpear1
NomolosUseSpear1:
  .byte $0c
  .byte $00,$60,$03,$00,$08
  .byte $00,$61,$03,$08,$00
  .byte $00,$62,$00,$10,$f8
  .byte $08,$77,$03,$00,$08
  .byte $08,$78,$03,$08,$00
  .byte $08,$7c,$03,$10,$f8
  .byte $10,$91,$03,$00,$08
  .byte $10,$92,$03,$08,$00
  .byte $10,$96,$03,$10,$f8
  .byte $18,$a5,$03,$00,$08
  .byte $18,$a6,$03,$08,$00
  .byte $18,$a7,$03,$10,$f8
.export Spear0
Spear0:
  .byte $03
  .byte $00,$7d,$00,$00,$10
  .byte $00,$7e,$03,$08,$08
  .byte $00,$7f,$03,$10,$00
.export Skelekin0
Skelekin0:
  .byte $08
  .byte $00,$a8,$03,$00,$08
  .byte $00,$17,$00,$08,$00
  .byte $08,$ac,$03,$00,$08
  .byte $08,$ad,$03,$08,$00
  .byte $10,$bf,$03,$00,$08
  .byte $10,$c0,$03,$08,$00
  .byte $18,$d4,$03,$00,$08
  .byte $18,$d5,$03,$08,$00
.export Skelekin1
Skelekin1:
  .byte $08
  .byte $00,$a8,$03,$00,$08
  .byte $00,$17,$00,$08,$00
  .byte $08,$ac,$03,$00,$08
  .byte $08,$ae,$03,$08,$00
  .byte $10,$c1,$03,$00,$08
  .byte $10,$17,$00,$08,$00
  .byte $18,$d4,$03,$00,$08
  .byte $18,$17,$00,$08,$00
.export Skelekin2
Skelekin2:
  .byte $08
  .byte $00,$a8,$03,$00,$08
  .byte $00,$17,$00,$08,$00
  .byte $08,$af,$03,$00,$08
  .byte $08,$b0,$03,$08,$00
  .byte $10,$c2,$03,$00,$08
  .byte $10,$c0,$03,$08,$00
  .byte $18,$d4,$03,$00,$08
  .byte $18,$d5,$03,$08,$00

