.ifndef CONSTANTS_INC
CONSTANTS_INC = 1

;bit positions for PPU control register $2000
PPU0_EXECUTE_NMI = 7
PPU0_MASTER_SLAVE = 6
PPU0_SPRITE_SIZE = 5
PPU0_BACKGROUND_PATTERN_TABLE_ADDRESS = 4
PPU0_SPRITE_PATTERN_TABLE_ADDRESS = 3
PPU0_ADDRESS_INCREMENT = 2
PPU0_NAMETABLE_ADDRESS1 = 1
PPU0_NAMETABLE_ADDRESS0 = 0

;bit positions for PPU control register $2001
PPU1_FULL_BACKGROUND_COLOR_2 = 7
PPU1_FULL_BACKGROUND_COLOR_1 = 6
PPU1_FULL_BACKGROUND_COLOR_0 = 5
PPU1_COLOR_INTENSITY_2 = 7
PPU1_COLOR_INTENSITY_1 = 6
PPU1_COLOR_INTENSITY_0 = 5
PPU1_SPRITE_VISIBILITY = 4
PPU1_BACKGROUND_VISIBILITY = 3
PPU1_SPRITE_CLIPPING = 2
PPU1_BACKGROUND_CLIPPING = 1
PPU1_DISPLAY_TYPE = 0

;Sound constants
DISABLE_FAMITRACKER_CHANNEL = $20
ENABLE_FAMITRACKER_CHANNEL = $21

;Nomolos state constants
nomolosWalkingRightAND       = %11111110
nomolosWalkingLeftOR         = %00000001

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
;nomolosAttackCrossbow = %00000100

nomolosStartingLives = $03
nomolosHurtBounceLo = $0a
nomolosHurtBounceHi = $fd
nomolosStartJumpLo = $0a
nomolosStartJumpHi = $f8
nomolosStartJumpHiPos = $07
nomolosVerticalAccelerationLo = $5a
nomolosVerticalAccelerationHi = $00
nomolosVerticalSpeedMax = $0a
nomolosWidth = $10
nomolosHeight = $20
nomolosHitboxWidth = $0c
nomolosHitboxHeight = $20

startingLevel = $00
maxHealth = 3
maxLives = 20

;keeps the lowest 4 bits to get penetration distance from a y coordinate
penetrationCalculationMask = %00001111
scrollReact = 120

.endif