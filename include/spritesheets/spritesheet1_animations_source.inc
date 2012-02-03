.include "spritesheet1_animations_imports.inc"

spritesheet1_DeentleWalk:
  .byte $0a
  .word spritesheet1_Deentle0
  .word spritesheet1_Deentle1
  .word $0000

spritesheet1_BeedieBlob:
  .byte $0a
  .word spritesheet1_Beedie0
  .word spritesheet1_Beedie1
  .word $0000

spritesheet1_GrankFly:
  .byte $0a
  .word spritesheet1_Grank0
  .word spritesheet1_Grank1
  .word $0000

spritesheet1_Batree:
  .byte $0a
  .word spritesheet1_Batree0
  .word spritesheet1_Batree1
  .word $0000

spritesheet1_OwlFly:
  .byte $0a
  .word spritesheet1_Owl0
  .word spritesheet1_Owl1
  .word $0000

spritesheet1_OwlAttack:
  .byte $0a
  .word spritesheet1_Owl2
  .word $0000

spritesheet1_SnufferRun:
  .byte $0a
  .word spritesheet1_Snuffer0
  .word spritesheet1_Snuffer1
  .word $0000

spritesheet1_SnufferBite:
  .byte $0a
  .word spritesheet1_Snuffer2
  .word $0000

spritesheet1_SkelekinWalk:
  .byte $0a
  .word spritesheet1_Skelekin1
  .word spritesheet1_Skelekin2
  .word spritesheet1_Skelekin1
  .word spritesheet1_Skelekin0
  .word $0000

spritesheet1_ThoguthMarch:
  .byte $0a
  .word spritesheet1_ThoguthMarch0
  .word spritesheet1_ThoguthMarch1
  .word spritesheet1_ThoguthMarch0
  .word spritesheet1_ThoguthMarch2
  .word $0000

spritesheet1_ThoguthHammerfall:
  .byte 20
  .word spritesheet1_ThoguthHammerfall0
  .word spritesheet1_ThoguthHammerfall1
  .word spritesheet1_ThoguthHammerfall2
  .word $0000

spritesheet1_ThoguthLightning:
  .byte $03
  .word spritesheet1_ThoguthLightning0
  .word spritesheet1_ThoguthLightning1
  .word $0000

.ifndef DEMO_BUILD
spritesheet1_SnailCrawl:
  .byte $28
  .word spritesheet1_Snail0
  .word spritesheet1_Snail1
  .word $0000

spritesheet1_DragonFly:
  .byte $05
  .word spritesheet1_Dragon0
  .word spritesheet1_Dragon1
  .word spritesheet1_Dragon2
  .word spritesheet1_Dragon1
  .word $0000

spritesheet1_IceBallFly:
  .byte $02
  .word spritesheet1_IceBall2
  .word spritesheet1_IceBall1
  .word spritesheet1_IceBall0
  .word spritesheet1_IceBall1
  .word $0000

spritesheet1_SharkLeap:
  .byte 25
  .word spritesheet1_Shark0
  .word spritesheet1_Shark1
  .word spritesheet1_Shark2
  .word $0000

spritesheet1_bigfireballfly:
  .byte $02
  .word spritesheet1_bigfireball2
  .word spritesheet1_bigfireball1
  .word spritesheet1_bigfireball0
  .word spritesheet1_bigfireball1
  .word $0000

spritesheet1_SnowWalk:
  .byte $0a
  .word spritesheet1_SnowWalk0
  .word spritesheet1_SnowWalk1
  .word spritesheet1_SnowWalk0
  .word spritesheet1_SnowWalk2
  .word $0000

spritesheet1_SnowWalkOverlay:
  .byte $0a
  .word spritesheet1_SnowWalkOverlay0
  .word spritesheet1_SnowWalkOverlay1
  .word spritesheet1_SnowWalkOverlay0
  .word spritesheet1_SnowWalkOverlay2
  .word $0000
.endif
