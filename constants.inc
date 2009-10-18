;Nomolos constants
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

;keeps the lowest 4 bits to get penetration distance from a y coordinate
penetrationCalculationMask = %00001111

scrollReact = 120