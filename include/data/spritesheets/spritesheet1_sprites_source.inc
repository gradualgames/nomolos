
;Meta Sprite Table
.export NomolosWalk0
NomolosWalk0:
  .byte $08
  .byte $00,$00,$00,$00,$08
  .byte $00,$01,$00,$08,$00
  .byte $08,$18,$00,$00,$08
  .byte $08,$19,$00,$08,$00
  .byte $10,$2b,$02,$00,$08
  .byte $10,$2c,$02,$08,$00
  .byte $18,$3e,$02,$00,$08
  .byte $18,$3f,$02,$08,$00
.export NomolosWalk1
NomolosWalk1:
  .byte $08
  .byte $00,$02,$00,$00,$08
  .byte $00,$03,$00,$08,$00
  .byte $08,$1a,$00,$00,$08
  .byte $08,$1b,$00,$08,$00
  .byte $10,$2d,$02,$00,$08
  .byte $10,$2e,$02,$08,$00
  .byte $18,$40,$02,$00,$08
  .byte $18,$41,$02,$08,$00
.export NomolosWalk2
NomolosWalk2:
  .byte $08
  .byte $00,$05,$00,$00,$08
  .byte $00,$06,$00,$08,$00
  .byte $08,$1c,$00,$00,$08
  .byte $08,$1d,$00,$08,$00
  .byte $10,$2f,$02,$00,$08
  .byte $10,$30,$02,$08,$00
  .byte $18,$42,$02,$00,$08
  .byte $18,$43,$02,$08,$00
.export NomolosJump0
NomolosJump0:
  .byte $08
  .byte $00,$07,$00,$00,$08
  .byte $00,$08,$00,$08,$00
  .byte $08,$1e,$02,$00,$08
  .byte $08,$1f,$02,$08,$00
  .byte $10,$31,$02,$00,$08
  .byte $10,$32,$02,$08,$00
  .byte $18,$44,$02,$00,$08
  .byte $18,$45,$02,$08,$00
.export NomolosWalkOverlay0
NomolosWalkOverlay0:
  .byte $04
  .byte $01,$0d,$01,$00,$08
  .byte $01,$0e,$01,$08,$00
  .byte $09,$24,$01,$00,$08
  .byte $09,$25,$01,$08,$00
.export NomolosWalkOverlay1
NomolosWalkOverlay1:
  .byte $04
  .byte $01,$0f,$01,$00,$08
  .byte $01,$10,$01,$08,$00
  .byte $09,$26,$01,$00,$08
  .byte $09,$27,$01,$08,$00
.export NomolosWalkOverlay2
NomolosWalkOverlay2:
  .byte $04
  .byte $01,$0f,$01,$00,$08
  .byte $01,$11,$01,$08,$00
  .byte $09,$26,$01,$00,$08
  .byte $09,$27,$01,$08,$00
.export NomolosJumpOverlay0
NomolosJumpOverlay0:
  .byte $04
  .byte $01,$0d,$01,$00,$08
  .byte $01,$12,$01,$08,$00
  .byte $09,$24,$01,$00,$08
  .byte $09,$25,$01,$08,$00
.export Heart0
Heart0:
  .byte $01
  .byte $00,$39,$01,$00,$00
.export Deentle0
Deentle0:
  .byte $04
  .byte $00,$4f,$02,$00,$08
  .byte $00,$50,$02,$08,$00
  .byte $08,$62,$02,$00,$08
  .byte $08,$63,$02,$08,$00
.export Deentle1
Deentle1:
  .byte $04
  .byte $00,$51,$02,$00,$08
  .byte $00,$52,$02,$08,$00
  .byte $08,$64,$02,$00,$08
  .byte $08,$65,$02,$08,$00
.export Explosion0
Explosion0:
  .byte $04
  .byte $00,$53,$00,$00,$08
  .byte $00,$54,$00,$08,$00
  .byte $08,$66,$00,$00,$08
  .byte $08,$67,$00,$08,$00
.export Explosion1
Explosion1:
  .byte $04
  .byte $00,$55,$00,$00,$08
  .byte $00,$56,$00,$08,$00
  .byte $08,$68,$00,$00,$08
  .byte $08,$69,$00,$08,$00
.export Explosion2
Explosion2:
  .byte $04
  .byte $00,$57,$00,$00,$08
  .byte $00,$58,$00,$08,$00
  .byte $08,$6a,$00,$00,$08
  .byte $08,$6b,$00,$08,$00
.export Mouse0
Mouse0:
  .byte $02
  .byte $00,$59,$02,$00,$08
  .byte $00,$5a,$02,$08,$00
.export SlumpedArmor0
SlumpedArmor0:
  .byte $06
  .byte $08,$6d,$00,$00,$08
  .byte $08,$6e,$00,$08,$00
  .byte $10,$7a,$02,$00,$08
  .byte $10,$7b,$02,$08,$00
  .byte $18,$86,$02,$00,$08
  .byte $18,$87,$02,$08,$00
.export SlumpedArmorOverlay0
SlumpedArmorOverlay0:
  .byte $02
  .byte $08,$6c,$01,$00,$00
  .byte $10,$79,$01,$00,$00
.export ScardyCat0
ScardyCat0:
  .byte $08
  .byte $00,$5b,$00,$00,$08
  .byte $00,$5c,$00,$08,$00
  .byte $08,$6f,$00,$00,$08
  .byte $08,$70,$00,$08,$00
  .byte $10,$7c,$00,$00,$08
  .byte $10,$7d,$00,$08,$00
  .byte $18,$88,$00,$00,$08
  .byte $18,$89,$00,$08,$00
.export ScardyCatOverlay0
ScardyCatOverlay0:
  .byte $04
  .byte $00,$71,$01,$00,$08
  .byte $00,$72,$01,$08,$00
  .byte $08,$7e,$01,$00,$08
  .byte $08,$7f,$01,$08,$00
.export NomolosFight0
NomolosFight0:
  .byte $0a
  .byte $f8,$4c,$00,$00,$08
  .byte $f8,$17,$00,$08,$00
  .byte $00,$5d,$00,$00,$08
  .byte $00,$5e,$00,$08,$00
  .byte $08,$73,$02,$00,$08
  .byte $08,$74,$00,$08,$00
  .byte $10,$80,$02,$00,$08
  .byte $10,$81,$02,$08,$00
  .byte $18,$8a,$02,$00,$08
  .byte $18,$8b,$02,$08,$00
.export NomolosFight1
NomolosFight1:
  .byte $10
  .byte $00,$5f,$00,$00,$08
  .byte $00,$60,$00,$08,$00
  .byte $00,$61,$00,$10,$f8
  .byte $00,$17,$00,$18,$f0
  .byte $08,$75,$02,$00,$08
  .byte $08,$76,$02,$08,$00
  .byte $08,$77,$00,$10,$f8
  .byte $08,$78,$00,$18,$f0
  .byte $10,$82,$02,$00,$08
  .byte $10,$83,$02,$08,$00
  .byte $10,$84,$00,$10,$f8
  .byte $10,$85,$00,$18,$f0
  .byte $18,$8c,$02,$00,$08
  .byte $18,$8d,$02,$08,$00
  .byte $18,$8e,$02,$10,$f8
  .byte $18,$17,$00,$18,$f0
.export NomolosFightOverlay0
NomolosFightOverlay0:
  .byte $04
  .byte $01,$13,$01,$00,$08
  .byte $01,$14,$01,$08,$00
  .byte $09,$17,$00,$00,$08
  .byte $09,$28,$01,$08,$00
.export NomolosFightOverlay1
NomolosFightOverlay1:
  .byte $04
  .byte $01,$15,$01,$00,$08
  .byte $01,$16,$01,$08,$00
  .byte $09,$29,$01,$00,$08
  .byte $09,$2a,$01,$08,$00
.export OneUp0
OneUp0:
  .byte $04
  .byte $00,$3d,$00,$00,$08
  .byte $00,$3d,$00,$08,$00
  .byte $08,$4d,$02,$00,$08
  .byte $08,$4e,$02,$08,$00
.export NomolosUseFlail0
NomolosUseFlail0:
  .byte $0c
  .byte $00,$09,$02,$00,$08
  .byte $00,$0a,$00,$08,$00
  .byte $00,$0b,$00,$10,$f8
  .byte $08,$20,$02,$00,$08
  .byte $08,$21,$00,$08,$00
  .byte $08,$22,$00,$10,$f8
  .byte $10,$33,$02,$00,$08
  .byte $10,$34,$02,$08,$00
  .byte $10,$35,$02,$10,$f8
  .byte $18,$46,$02,$00,$08
  .byte $18,$47,$02,$08,$00
  .byte $18,$48,$02,$10,$f8
.export NomolosUseFlail1
NomolosUseFlail1:
  .byte $0c
  .byte $00,$0c,$02,$00,$08
  .byte $00,$0a,$00,$08,$00
  .byte $00,$0b,$00,$10,$f8
  .byte $08,$23,$02,$00,$08
  .byte $08,$21,$00,$08,$00
  .byte $08,$22,$00,$10,$f8
  .byte $10,$36,$02,$00,$08
  .byte $10,$37,$02,$08,$00
  .byte $10,$38,$02,$10,$f8
  .byte $18,$49,$02,$00,$08
  .byte $18,$4a,$02,$08,$00
  .byte $18,$4b,$02,$10,$f8
.export FlailBall0
FlailBall0:
  .byte $01
  .byte $f0,$3a,$02,$ea,$16
.export FlailBall1
FlailBall1:
  .byte $01
  .byte $ec,$3a,$02,$00,$00
.export FlailBall2
FlailBall2:
  .byte $01
  .byte $f0,$3a,$02,$16,$ea
.export FlailBall3
FlailBall3:
  .byte $01
  .byte $00,$3a,$02,$28,$d8
.export FlailBall4
FlailBall4:
  .byte $01
  .byte $10,$3a,$02,$16,$ea
.export FlailBall5
FlailBall5:
  .byte $01
  .byte $14,$3a,$02,$00,$00
.export FlailBall6
FlailBall6:
  .byte $01
  .byte $10,$3a,$02,$ea,$16
.export FlailBall7
FlailBall7:
  .byte $01
  .byte $00,$3a,$02,$d8,$28
.export NomolosFlailOverlay0
NomolosFlailOverlay0:
  .byte $04
  .byte $01,$13,$01,$03,$05
  .byte $01,$14,$01,$0b,$fd
  .byte $09,$17,$00,$03,$05
  .byte $09,$28,$01,$0b,$fd
.export FlailItem0
FlailItem0:
  .byte $02
  .byte $00,$3b,$02,$00,$08
  .byte $00,$3c,$02,$08,$00

