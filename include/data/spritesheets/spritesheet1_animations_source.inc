;Animations
.export NomolosWalk
NomolosWalk:
  .byte $06
  .word NomolosWalk0
  .word NomolosWalk1
  .word NomolosWalk0
  .word NomolosWalk2
  .word $0000

.export NomolosJump
NomolosJump:
  .byte $0a
  .word NomolosJump0
  .word $0000

.export NomolosWalkOverlay
NomolosWalkOverlay:
  .byte $0a
  .word NomolosWalkOverlay0
  .word NomolosWalkOverlay1
  .word NomolosWalkOverlay0
  .word NomolosWalkOverlay2
  .word $0000

.export NomolosJumpOverlay
NomolosJumpOverlay:
  .byte $0a
  .word NomolosJumpOverlay0
  .word $0000

.export Heart
Heart:
  .byte $0a
  .word Heart0
  .word $0000

.export DeentleWalk
DeentleWalk:
  .byte $0a
  .word Deentle0
  .word Deentle1
  .word $0000

.export Explosion
Explosion:
  .byte $02
  .word Explosion0
  .word Explosion1
  .word Explosion2
  .word $0000

.export Mouse
Mouse:
  .byte $0a
  .word Mouse0
  .word $0000

.export NomolosFight
NomolosFight:
  .byte $06
  .word NomolosFight0
  .word NomolosFight1
  .word $0000

.export NomolosFightOverlay
NomolosFightOverlay:
  .byte $06
  .word NomolosFightOverlay0
  .word NomolosFightOverlay1
  .word $0000

.export NomolosUseFlail
NomolosUseFlail:
  .byte $06
  .word NomolosUseFlail0
  .word NomolosUseFlail1
  .word $0000

.export FlailBall
FlailBall:
  .byte $01
  .word FlailBall0
  .word FlailBall1
  .word FlailBall2
  .word FlailBall3
  .word FlailBall4
  .word FlailBall5
  .word FlailBall6
  .word FlailBall7
  .word $0000

.export NomolosFlailOverlay
NomolosFlailOverlay:
  .byte $06
  .word NomolosFlailOverlay0
  .word NomolosFlailOverlay0
  .word $0000

.export FlailItem
FlailItem:
  .byte $0a
  .word FlailItem0
  .word $0000

.export BeedieBlob
BeedieBlob:
  .byte $0a
  .word Beedie0
  .word Beedie1
  .word $0000

.export GrankFly
GrankFly:
  .byte $0a
  .word Grank0
  .word Grank1
  .word $0000

.export NomolosUseSpear
NomolosUseSpear:
  .byte $06
  .word NomolosUseSpear0
  .word NomolosUseSpear1
  .word $0000

.export SpearFly
SpearFly:
  .byte $0a
  .word Spear0
  .word $0000

