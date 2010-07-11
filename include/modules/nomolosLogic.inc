.ifndef NOMOLOSLOGIC_INC
NOMOLOSLOGIC_INC = 1

.global nomolos_init
.global nomolos_update
.global nomolos_draw
.global nomolos_draw_hearts
.global nomolos_hurt
.global nomolos_is_deadly
.global nomolos_add_health
.global nomolos_add_life

;Nomolos state constants
nomolosWalkingRightAND       = %11111110
nomolosWalkingLeftOR         = %00000001
nomolosWalkingLeftTestAND    = %00000001

nomolosMovingOffAND          = %11111101
nomolosMovingOnOR            = %00000010
nomolosMovingTestAND         = %00000010

nomolosBlinkingOnOR          = %00000100
nomolosBlinkingOffAND        = %11111011
nomolosBlinkingTestAND       = %00000100

nomolosBelowCollisionOnOR    = %00001000
nomolosBelowCollisionOffAND  = %11110111
nomolosBelowCollisionTestAND = %00001000

nomolosAboveCollisionOnOR    = %00010000
nomolosAboveCollisionOffAND  = %11101111
nomolosAboveCollisionTestAND = %00010000

nomolosAttackOnOR            = %00100000
nomolosAttackOffAND          = %11011111
nomolosAttackTestAND         = %00100000

nomolosHurtByMapOnOR         = %01000000
nomolosHurtByMapOffAND       = %10111111
nomolosHurtByMapTestAND      = %01000000

nomolosDyingOnOR             = %10000000
nomolosDyingOffAND           = %01111111
nomolosDyingTestAND          = %10000000

;nomolos sub-state constants
nomolosAttackedDyingOR      = %00000001
nomolosAttackedDyingTestAND = %00000001
nomolosFellDyingAND        = %11111110

nomolosAttackTestMask  = %00000110
nomolosAttackSetMask   = %11111001
nomolosAttackSword     = %00000000
nomolosAttackFlail     = %00000010
nomolosAttackSpear     = %00000100

nomolosAttackDirectionRightOR =  %00001000
nomolosAttackDirectionLeftAND = %11110111
nomolosAttackDirectionTestAND    = %00001000

nomolosStartingLives = $03
nomolosHurtBounceLo = $0a
nomolosHurtBounceHi = $fd
nomolosStartJumpLo = $00
nomolosStartJumpHi = $f8
nomolosStartJumpHiPos = $07
nomolosVerticalAccelerationLo = $5a
nomolosVerticalAccelerationHi = $00
nomolosVerticalSpeedMax = $0a
nomolosWidth = $10
nomolosHeight = $20

startingLevel = $00
maxHealth = 3
maxLives = 20
lastEntity = 15

;keeps the lowest 4 bits to get penetration distance from a y coordinate
penetrationCalculationMask = %00001111

.endif
