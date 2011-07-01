.include "spritesheet_common_animations_imports.inc"

;Animations
.ifndef spritesheet_common_NomolosWalk
spritesheet_common_NomolosWalk:
.endif
  .byte $06
  .word spritesheet_common_NomolosWalk0
  .word spritesheet_common_NomolosWalk1
  .word spritesheet_common_NomolosWalk0
  .word spritesheet_common_NomolosWalk2
  .word $0000

.ifndef spritesheet_common_nomolos_jump
spritesheet_common_nomolos_jump:
.endif
  .byte $0a
  .word spritesheet_common_nomolos_jump0
  .word $0000

.ifndef spritesheet_common_nomolos_walk_overlay
spritesheet_common_nomolos_walk_overlay:
.endif
  .byte $0a
  .word spritesheet_common_nomolos_walk_overlay0
  .word spritesheet_common_nomolos_walk_overlay1
  .word spritesheet_common_nomolos_walk_overlay0
  .word spritesheet_common_nomolos_walk_overlay2
  .word $0000

.ifndef spritesheet_common_nomolos_jump_overlay
spritesheet_common_nomolos_jump_overlay:
.endif
  .byte $0a
  .word spritesheet_common_nomolos_jump_overlay0
  .word $0000

.ifndef spritesheet_common_Heart
spritesheet_common_Heart:
.endif
  .byte $0a
  .word spritesheet_common_Heart0
  .word $0000

.ifndef spritesheet_common_Mouse
spritesheet_common_Mouse:
.endif
  .byte $0a
  .word spritesheet_common_Mouse0
  .word $0000

.ifndef spritesheet_common_nomolos_fight
spritesheet_common_nomolos_fight:
.endif
  .byte $06
  .word spritesheet_common_nomolos_fight0
  .word spritesheet_common_nomolos_fight1
  .word $0000

.ifndef spritesheet_common_nomolos_fight_overlay
spritesheet_common_nomolos_fight_overlay:
.endif
  .byte $06
  .word spritesheet_common_nomolos_fight_overlay0
  .word spritesheet_common_nomolos_fight_overlay1
  .word $0000

.ifndef spritesheet_common_NomolosUseFlail
spritesheet_common_NomolosUseFlail:
.endif
  .byte $06
  .word spritesheet_common_NomolosUseFlail0
  .word spritesheet_common_NomolosUseFlail1
  .word $0000

.ifndef spritesheet_common_FlailBall
spritesheet_common_FlailBall:
.endif
  .byte $01
  .word spritesheet_common_FlailBall0
  .word spritesheet_common_FlailBall1
  .word spritesheet_common_FlailBall2
  .word spritesheet_common_FlailBall3
  .word spritesheet_common_FlailBall4
  .word spritesheet_common_FlailBall5
  .word spritesheet_common_FlailBall6
  .word spritesheet_common_FlailBall7
  .word $0000

.ifndef spritesheet_common_nomolos_flail_overlay
spritesheet_common_nomolos_flail_overlay:
.endif
  .byte $06
  .word spritesheet_common_nomolos_flail_overlay0
  .word spritesheet_common_nomolos_flail_overlay0
  .word $0000

.ifndef spritesheet_common_FlailItem
spritesheet_common_FlailItem:
.endif
  .byte $0a
  .word spritesheet_common_FlailItem0
  .word $0000

.ifndef spritesheet_common_NomolosUseSpear
spritesheet_common_NomolosUseSpear:
.endif
  .byte $06
  .word spritesheet_common_NomolosUseSpear0
  .word spritesheet_common_NomolosUseSpear1
  .word $0000

.ifndef spritesheet_common_SpearFly
spritesheet_common_SpearFly:
.endif
  .byte $0a
  .word spritesheet_common_Spear0
  .word $0000

.ifndef spritesheet_common_Explosion
spritesheet_common_Explosion:
.endif
  .byte 3
  .word spritesheet_common_Explosion2
  .word spritesheet_common_Explosion1
  .word spritesheet_common_Explosion0
  .word $0000