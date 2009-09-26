;Nomolos constants
nomolosWalkingRightAND =      %11111110
nomolosWalkingLeftOR   =      %00000001

nomolosMovingOffAND    =      %11111101
nomolosMovingOnOR      =      %00000010

;removed due to improving/simplifying the jumping code
;nomolosJumpingOffAND   =      %11111011
;nomolosJumpingOnOR     =      %00000100
;nomolosJumpingTestAND  =      %00000100

nomolosBlinkingOffAND   =      %11111011
nomolosBlinkingOnOR     =      %00000100
nomolosBlinkingTestAND  =      %00000100

nomolosBelowCollisionOnOR =    %00001000
nomolosBelowCollisionOffAND =  %11110111
nomolosBelowCollisionTestAND = %00001000

nomolosAboveCollisionOnOR =    %00010000
nomolosAboveCollisionOffAND =  %11101111
nomolosAboveCollisionTestAND = %00010000

nomolosHurtBounceLo = $0a
nomolosHurtBounceHi = $fd
nomolosStartJumpLo = $0a
nomolosStartJumpHi = $f8
nomolosStartJumpHiPos = $07
nomolosVerticalAccelerationLo = $5a
nomolosVerticalAccelerationHi = $00
nomolosVerticalSpeedMax = $0a
nomolosHeight = $20

;keeps the lowest 4 bits to get penetration distance from a y coordinate
penetrationCalculationMask = %00001111

scrollReact = 120