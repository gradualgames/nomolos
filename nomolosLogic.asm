.include "constants.inc"

;ROM labels
.import NomolosWalk, NomolosWalkOverlay, Heart0
.import NomolosJump, NomolosJumpOverlay
.import NomolosFight, NomolosFightOverlay

;Sprite module labels
.import drawMetaSprite, drawAnimation, updateAnimation

;Map module labels (for collision detection)
.import testMapCollision

;Camera module labels
.import updateCamera, cameraToScreenCoords

;sound module labels
.import lowc

;global variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5
.importzp nomolosX, nomolosY, nomolosScreenX, nomolosScreenY
.importzp nomolosHitboxXOffset, nomolosHitboxYOffset
.importzp nomolosXSpeed, nomolosYSpeed, nomolosAnim, nomolosState, nomolosHealth
.importzp nomolosBlinkCounter, nomolosHitboxCounter
.importzp nomolosAbovePenetrationDistance, nomolosBelowPenetrationDistance
.importzp controllerBuffer

;Nomolos interface
.export initNomolos, updateNomolos, drawNomolos, drawNomolosHearts, hurtNomolos

.segment "CODE"

.proc initNomolos

  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
  
  lda #0
  and #nomolosWalkingRightAND  
  sta nomolosState
  
  lda #0
  sta nomolosXSpeed
  lda #2
  sta nomolosXSpeed+1
  lda #$00
  sta nomolosYSpeed
  lda #$00
  sta nomolosYSpeed+1  
  
  lda #0
  sta nomolosX
  lda #80
  sta nomolosX+1
  lda #0
  sta nomolosX+2
  
  lda #0
  sta nomolosY
  lda #90
  sta nomolosY+1
  
  lda #3
  sta nomolosHealth
  
  lda #0
  sta nomolosHitboxCounter
  
  lda #0
  sta nomolosHitboxXOffset
  lda #0
  sta nomolosHitboxYOffset

  rts
  
.endproc

;hurts Nomolos. It makes him bounce in the air a little bit, lose a heart,
;and become invincible temporarily.
.proc hurtNomolos

  ;if blinking is on, skip this whole routine
  lda nomolosState
  and #nomolosBlinkingTestAND
  lsr
  lsr
  bne skipHurt

  ;decrease nomolos' health.
  lda nomolosHealth
  beq skipDecreaseHealth
  dec nomolosHealth
skipDecreaseHealth:
  
  ;make nomolos bounce a little bit.
  lda #nomolosHurtBounceLo
  sta nomolosYSpeed
  lda #nomolosHurtBounceHi
  sta nomolosYSpeed+1
  
  ;turn on blinking
  lda #$60
  sta nomolosBlinkCounter
  lda nomolosState
  ora #nomolosBlinkingOnOR
  sta nomolosState  
  
skipHurt:

  rts
  
.endproc
  
;Causes the hit box to be activated for a few frames.
.proc nomolosAttack

  ;if attacking is on, skip this whole routine
  lda nomolosState
  and #nomolosAttackTestAND
  bne skipAttack

  ;turn on the attack hit box
  lda #$14
  sta nomolosHitboxCounter
  lda nomolosState
  ora #nomolosAttackOnOR
  sta nomolosState
  
  ;reset animation
  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
skipAttack:
  
  rts
  
.endproc
  
.proc updateNomolos

  dec nomolosBlinkCounter
  bne skipBlinkReset
  
  lda nomolosState
  and #nomolosBlinkingOffAND
  sta nomolosState
skipBlinkReset:

;Is the attack state on?
  lda nomolosState
  and #nomolosAttackTestAND
  beq skipAttackUpdate
  ;attack state was on
  
  dec nomolosHitboxCounter
  bne skipAttackUpdate
  
  ;set attack state to off
  lda nomolosState
  and #nomolosAttackOffAND
  sta nomolosState
  
  ;reset animation object
  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
skipAttackUpdate:

;Has the B button been hit?
  lda controllerBuffer+1
  and #%00000011
  ;transition from off to on
  cmp #%00000001
  bne skipAttack
  ;B button has been hit, run the attack routine
  ;jsr lowc
  jsr nomolosAttack
skipAttack:

;Is there a collision above Nomolos? (NomolosY - maxYCollisionDistance)
  ;top left
  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  clc
  adc #nomolosStartJumpHi
  adc #$ff
  sta b0
  jsr testMapCollision
  beq noTopLeftCollision
  
  jmp yesAboveCollision
  
noTopLeftCollision:
  
  ;top right
  lda nomolosX+1
  clc
  adc #$0f
  sta w0
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  clc
  adc #nomolosStartJumpHi
  adc #$ff
  sta b0
  jsr testMapCollision
  beq noTopRightCollision
  
  jmp yesAboveCollision
  
noTopRightCollision:

  jmp noAboveCollision
  
yesAboveCollision:
;  Yes:
;    calculate penetration distance and store it in abovePenetrationDistance
  lda nomolosY+1
  clc
  adc #nomolosStartJumpHi
  and #penetrationCalculationMask
  sta nomolosAbovePenetrationDistance
  lda #$10
  sec
  sbc nomolosAbovePenetrationDistance
  sbc #1
  sta nomolosAbovePenetrationDistance
;    nomolosState is TopCollision = true
  lda nomolosState
  ora #nomolosAboveCollisionOnOR
  sta nomolosState
  jmp skipNoAboveCollision
noAboveCollision:
;  No:
;    nomolosState is TopCollision = false
  lda nomolosState
  and #nomolosAboveCollisionOffAND
  sta nomolosState
skipNoAboveCollision:
;Is there a collision below Nomolos? (NomolosY + NomolosHeight + maxYCollisionDistance)
  ;bottom left
  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  clc
  adc #nomolosHeight
  adc #nomolosVerticalSpeedMax
  adc #1
  sta b0  
  jsr testMapCollision
  beq noBottomLeftCollision
  
  jmp yesBottomCollision
  
noBottomLeftCollision:
  
  ;bottom right
  lda nomolosX+1
  clc
  adc #$0f
  sta w0
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  clc
  adc #nomolosHeight
  adc #nomolosVerticalSpeedMax
  adc #1
  sta b0  
  jsr testMapCollision
  beq noBottomRightCollision
  
  jmp yesBottomCollision
  
noBottomRightCollision:
  
  beq noBelowCollision  ;we want to skip the following code when there is not a collision
                        ;set = not collision, so we use beq
;  Yes:
;    calculate penetration distance and store it in belowPenetrationDistance
  ;penetration distance would just be nomolosY+1+height+speedmax AND %00001111
yesBottomCollision:
  lda nomolosY+1
  clc
  adc #nomolosHeight
  adc #nomolosVerticalSpeedMax
  adc #1
  and #penetrationCalculationMask
  adc #1
  sta nomolosBelowPenetrationDistance
;    nomolosState is BottomCollision = true
  lda nomolosState
  ora #nomolosBelowCollisionOnOR
  sta nomolosState
  jmp yesBelowCollision
;  No:
noBelowCollision:
;    nomolosState is BottomCollision = false
  lda nomolosState
  and #nomolosBelowCollisionOffAND
  sta nomolosState
yesBelowCollision:
;
;;this is the falling code (also the slowing down while rising during a jump code)
;is nomolosYSpeed < nomolosVerticalSpeedMax?
  lda #nomolosVerticalSpeedMax  
  sec
  sbc nomolosYSpeed+1
  ;we want to skip the following code if the result was negative
  bmi DoNotIncrementSpeed
;  Yes:
;    nomolosYSpeed = nomolosYSpeed + nomolosVerticalAcceleration
  lda nomolosYSpeed
  clc
  adc #nomolosVerticalAccelerationLo
  sta nomolosYSpeed
  lda nomolosYSpeed+1
  adc #nomolosVerticalAccelerationHi
  sta nomolosYSpeed+1
DoNotIncrementSpeed:
    
;now we have the tentative nomolosYSpeed. We now must find out if it is appropriate.
    
;Is nomolosYSpeed positive?
  lda nomolosYSpeed+1
  bmi ySpeedNegative
;  Yes:    
;    Is nomolosState.BotCollision true?
  lda nomolosState
  and #nomolosBelowCollisionTestAND
  lsr
  lsr
  lsr
  ;we want to skip the following code if BotCollision is false. BotCollision is false corresponds to zero flag = true
  beq noBelowCollision2
;      Yes:
;        Calculate maxYCollisionDistance - belowPenetrationDistance
  lda #nomolosVerticalSpeedMax  
  sec
  sbc nomolosBelowPenetrationDistance
;        Is result = maxYCollisionDistance?
  cmp #nomolosVerticalSpeedMax
  bne penetrationNotEqualToMax
        

penetrationNotEqualToMax:  
;        Is result < nomolosYSpeed?  if result - nomolosYSpeed is negative, then this is true, so branch if positive.
  cmp nomolosYSpeed+1
  bpl penetrationNotLessThanYSpeed
;          Yes:
;            nomolosYSpeed = result
  clc
  adc #1
  sta nomolosYSpeed+1
  lda #0
  sta nomolosYSpeed
penetrationNotLessThanYSpeed:
;        ;if we reach here we know that Nomolos won't hit anything on the next iteration with the current
;        ;value of nomolosYSpeed
  jmp skipDisableJumpWhileFalling
noBelowCollision2:
  
skipDisableJumpWhileFalling:

  jmp skipYSpeedNegativeCode
ySpeedNegative:

  ;is current state of A button released, and previous state of A button pressed?
  lda controllerBuffer
  and #%00000011
  cmp #%00000010
  bne dontStopRising
  
  ;yes, so stop rising into the air.
  lda #0
  sta nomolosYSpeed
  sta nomolosYSpeed+1
  
dontStopRising:

  ;is above collision true?
  lda nomolosState
  and #nomolosAboveCollisionTestAND
  lsr
  lsr
  lsr
  lsr
  and #1   ;if the result of this instruction is 1, the zero flag will be false. if it is 0, zero flag will be true.
           ;we want to skip if the zero flag is true, because that would mean there is no above collision.
  beq noAboveCollision2
  ;if we arrive here, there was a collision above nomolos and we must decide what to do about it.
  
  ;calculate nomolosStartJumpHiPos + nomolosAbovePenetrationDistance
  lda #nomolosStartJumpHi
  clc
  adc nomolosAbovePenetrationDistance
  
penetrationNotEqualToStartJumpHi:
  cmp nomolosYSpeed+1
  bmi penetrationNotLessThanYSpeed2
  ;penetration is less than y speed, so set y speed to nomolosStartJumpHiPos
  sta nomolosYSpeed+1
  lda #0
  sta nomolosYSpeed

penetrationNotLessThanYSpeed2:
noAboveCollision2:

skipYSpeedNegativeCode:
 
  lda nomolosYSpeed+1
  bne skipButtonATest
  
  ;Test if current state of A button is down and previous state is up. In other words,
  ;AND with #%00000011, then test for equality to 1.
  lda controllerBuffer
  and #%00000011
  cmp #1
  bne skipButtonATest
  lda nomolosState
  and #nomolosBelowCollisionTestAND
  lsr
  lsr
  lsr
  beq skipButtonATest
  ;A button was down, collision was beneath so start the jump
  
  ;but don't start the jump if there's a collision above!
  ;is above collision true?
  lda nomolosState
  and #nomolosAboveCollisionTestAND
  lsr
  lsr
  lsr
  lsr
  and #1   ;if the result of this instruction is 1, the zero flag will be false. if it is 0, zero flag will be true.
           ;we want to skip if the zero flag is true, because that would mean there is no above collision.
  bne noAboveCollision3
  
  lda #nomolosStartJumpLo
  sta nomolosYSpeed
  lda #nomolosStartJumpHi
  sta nomolosYSpeed+1
  
skipButtonATest:
noAboveCollision3:
 
;;presumably if there is something directly above nomolos, or directly below nomolos, 
;;that will have been figured out before the following line occurs, and nomolosYSpeed
;;will have been modified accordingly.
;nomolosY = nomolosY + nomolosYSpeed
  clc
  lda nomolosY  
  adc nomolosYSpeed
  sta nomolosY
  lda nomolosY+1
  adc nomolosYSpeed+1
  sta nomolosY+1
  

  lda nomolosState  
  and #nomolosMovingOffAND       ;state is moving
  sta nomolosState

  ;is nomolos fighting? skip this animation reset code if so
  lda nomolosState
  and #nomolosAttackTestAND
  bne @skipResetAnim
  ;is there an on to off transition on the left button?
  lda controllerBuffer+6
  and #%00000011
  cmp #%00000010
  bne @skipResetAnim
  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
  lda nomolosState
  and #nomolosMovingOffAND       ;state not moving
  sta nomolosState
@skipResetAnim:
  
  lda controllerBuffer+6 ;Left

  ;is left button down?
  and #1
  beq notLeft
  lda nomolosState
  ora #nomolosWalkingLeftOR
  ora #nomolosMovingOnOR
  
  sta nomolosState
  
  ;test collision with map
  lda nomolosX+1
  sec
  sbc #1
  sta w0
  lda nomolosX+2
  sbc #0
  sta w0+1
  lda nomolosY+1
  sta b0
  inc b0
  jsr testMapCollision
  bne notLeft
  
  lda nomolosX+1
  sec
  sbc #1
  sta w0
  lda nomolosX+2
  sbc #0
  sta w0+1
  lda nomolosY+1
  clc
  adc #$0f
  sta b0
  jsr testMapCollision
  bne notLeft

  lda nomolosX+1
  sec
  sbc #1
  sta w0
  lda nomolosX+2
  sbc #0
  sta w0+1
  lda nomolosY+1
  clc 
  adc #$1f
  sta b0
  dec b0
  jsr testMapCollision
  bne notLeft
  
  ;also make certain nomolos can't walk past left part of screen
  lda nomolosScreenX
  beq notLeft
  
  ;24 bit Sub
  sec
  lda nomolosX
  sbc nomolosXSpeed
  sta nomolosX
  lda nomolosX+1
  sbc nomolosXSpeed+1
  sta nomolosX+1   
  lda nomolosX+2
  sbc #0
  sta nomolosX+2
  
  ;jsr updateNomolosAnimation
notLeft:
  
  ;is nomolos fighting? skip this animation reset code if so
  lda nomolosState
  and #nomolosAttackTestAND
  bne @skipResetAnim
  ;is there an on to off transition on the right button?
  lda controllerBuffer+7
  and #%00000011
  cmp #%00000010
  bne @skipResetAnim
  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
  lda nomolosState
  and #nomolosMovingOffAND       ;state not moving
  sta nomolosState
@skipResetAnim:
  
  lda controllerBuffer+7 ; Right

  ;is right button down?
  and #1
  beq notRight
  lda nomolosState
  and #nomolosWalkingRightAND ;state is walking right
  ora #nomolosMovingOnOR       ;state is moving
  sta nomolosState
  
  ;test collision with map
  lda nomolosX+1
  clc
  adc #$10
  sta w0  
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  sta b0
  inc b0
  jsr testMapCollision
  bne notRight
  
  ;lda nomolosX+1
  lda nomolosX+1
  clc
  adc #$10
  sta w0  
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  clc
  adc #$0f
  sta b0
  jsr testMapCollision
  bne notRight
  
  lda nomolosX+1
  clc
  adc #$10
  sta w0  
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  clc
  adc #$1f
  sta b0
  dec b0
  jsr testMapCollision
  bne notRight
  
  ;24 bit add
  clc
  lda nomolosX
  adc nomolosXSpeed
  sta nomolosX
  lda nomolosX+1
  adc nomolosXSpeed+1
  sta nomolosX+1
  lda nomolosX+2
  adc #0
  sta nomolosX+2
  
  ;jsr updateNomolosAnimation
notRight:

  ;compute screen coordinates from level coordinates
  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  sta b0
  jsr cameraToScreenCoords
  lda b1
  sta nomolosScreenX
  lda b0
  sta nomolosScreenY 

  ;tell the camera to center itself on Nomolos
  lda nomolosScreenX
  sta b0
  jsr updateCamera
  lda b0
  sta nomolosScreenX
  
  jsr updateNomolosAnimation
  
  rts
.endproc
  
.proc updateNomolosAnimation

  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1

  lda nomolosState
  and #nomolosAttackTestAND
  beq skipUpdateNomolosFighting
  
  lda #<NomolosFight
  sta w2
  lda #>NomolosFight
  sta w2+1
  
  jsr updateAnimation
  
  rts
skipUpdateNomolosFighting:
  
  lda nomolosState
  and #nomolosMovingTestAND
  beq skipUpdateNomolosMoving
  lda #<NomolosWalk
  sta w2
  lda #>NomolosWalk
  sta w2+1
 
  jsr updateAnimation
skipUpdateNomolosMoving:

  rts  
  
.endproc
  
.proc drawNomolos

  lda nomolosState
  and #1
  beq @skipNomolosFacingLeft
  lda #$f8
  sta nomolosHitboxXOffset
  jmp @skipNomolosFacingRight
@skipNomolosFacingLeft:
  lda #$08
  sta nomolosHitboxXOffset
@skipNomolosFacingRight:

  lda nomolosState
  and #nomolosBlinkingTestAND
  lsr
  lsr
  beq skipBlinkCheck
  
  ;check blink counter
  lda nomolosBlinkCounter
  and #%00000011
  bne skipReturn
  rts
skipReturn:
  
skipBlinkCheck:

  ;test if nomolos is fighting. if he is, always draw him fighting
  ;regardless of whether he is in the air.
  lda nomolosState
  and #nomolosAttackTestAND
  beq skipDrawNomolosFighting
  
  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1
  
  lda #<NomolosFight
  sta w2
  lda #>NomolosFight
  sta w2+1
  
  ;get the direction bit into bit 6 of b2 for horiz flip
  lda nomolosState
  and #1
  ror
  ror
  ror
  sta b2
  
  lda nomolosScreenX
  sta b0
  lda nomolosScreenY
  sta b1
  
  jsr drawAnimation
  
  lda #<NomolosFightOverlay
  sta w2
  lda #>NomolosFightOverlay
  sta w2+1
  
  jsr drawAnimation
  
  rts
  
skipDrawNomolosFighting:

  ;we need to test two cases to know if nomolos is jumping,
  ;in order to cover the case where he is motionless for a
  ;split second at the top of an arc.
  ;test if there is anything below nomolos. If there is nothing,
  ;we skip the Y speed test becase we know he should be drawn 
  ;jumping.
  lda nomolosState
  and #nomolosBelowCollisionTestAND
  lsr
  lsr
  lsr
  beq skipYSpeedTest

  ;check whether Nomolos is moving vertically
  lda nomolosYSpeed+1
  beq skipDrawNomolosJumping
skipYSpeedTest:
  
  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
  
  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1
  
  lda #<NomolosJump
  sta w2
  lda #>NomolosJump
  sta w2+1
  
  ;get the direction bit into bit 6 of b2 for horiz flip
  lda nomolosState
  and #1
  ror
  ror
  ror
  sta b2
  
  lda nomolosScreenX
  sta b0
  lda nomolosScreenY
  sta b1
  
  jsr drawAnimation
  
  lda #<NomolosJumpOverlay
  sta w2
  lda #>NomolosJumpOverlay
  sta w2+1
  
  jsr drawAnimation
  
  rts
skipDrawNomolosJumping:

  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1
  
  lda nomolosState
  and #1
  bne skipNomolosWalkingRight
  lda #<NomolosWalkOverlay
  sta w2
  lda #>NomolosWalkOverlay
  sta w2+1
  lda #%00000000
  sta b2
  
  lda nomolosScreenX
  sta b0
  lda nomolosScreenY
  sta b1
  jsr drawAnimation
  
  lda #<NomolosWalk
  sta w2
  lda #>NomolosWalk
  sta w2+1
  jsr drawAnimation
  
  jmp skipNomolosWalkingLeft
skipNomolosWalkingRight:
  lda #<NomolosWalkOverlay
  sta w2
  lda #>NomolosWalkOverlay
  sta w2+1
  lda #%01000000
  sta b2

  lda nomolosScreenX
  sta b0
  lda nomolosScreenY
  sta b1
  jsr drawAnimation
  
  lda #<NomolosWalk
  sta w2
  lda #>NomolosWalk
  sta w2+1
  jsr drawAnimation
  
skipNomolosWalkingLeft:
  
dontDrawNomolos:

  rts
  
.endproc
  
.proc drawNomolosHearts

  ldx nomolosHealth
  beq skipDrawHearts
  
  lda #$10
  sta b0
  sta b1
  lda #<Heart0
  sta w0
  lda #>Heart0
  sta w0+1
drawNextHeart:
  jsr drawMetaSprite
  lda b0
  clc
  adc #$08
  sta b0
  dex  
  bne drawNextHeart
skipDrawHearts:

  rts
  
.endproc