.include "constants.inc"
.include "macros.inc"
.include "structs.inc"

;Sprite module labels
.import drawMetaSprite, drawAnimation, updateAnimation

;Map module labels (for collision detection)
.import testMapCollision

;Camera module labels
.import updateCamera, cameraToScreenCoords

;sound module labels
.import lowc, loadSound, playSound, finishSound

;global variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5
.importzp nomolosX, nomolosY, nomolosScreenX, nomolosScreenY
.importzp nomolosHitboxXOffset, nomolosHitboxYOffset
.importzp nomolosXSpeed, nomolosYSpeed, nomolosAnim, nomolosState, nomolosHealth
.importzp nomolosBlinkCounter, nomolosHitboxCounter
.importzp nomolosAbovePenetrationDistance, nomolosBelowPenetrationDistance
.importzp romDefinitionTableBaseAddress
.importzp controllerBuffer
.importzp soundAddr, soundOff

;Nomolos interface
.export initNomolos, updateNomolos, drawNomolos, drawNomolosHearts, hurtNomolos
.export nomolosDeadly, addNomolosHealth

.segment "CODE"

.proc initNomolos

  resetAnim nomolosAnim
  
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
  lda #0
  sta nomolosY+2
  
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

;adds health to Nomolos. The accumulator is assumed to contain the
;number of hearts to add on to his health.
.proc addNomolosHealth

  clc
  adc nomolosHealth
  sta nomolosHealth

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
  
  ;play a hit sound
  ldy #ROMDefinitionTableStruct::hitSound
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  jsr loadSound
  
skipHurt:

  rts
  
.endproc
  
;Causes the hit box to be activated for a few frames.
.proc nomolosAttack

  ;if attacking is on, skip this whole routine
  lda nomolosState
  and #nomolosAttackTestAND
  bne skipAttack

  ;play an attack sound
  ldy #ROMDefinitionTableStruct::attackSound
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  jsr loadSound
  
  ;turn on the attack hit box
  lda #$0c
  sta nomolosHitboxCounter
  lda nomolosState
  ora #nomolosAttackOnOR
  sta nomolosState
  
  ;reset animation
  resetAnim nomolosAnim
skipAttack:
  
  rts
  
.endproc
  
;tests nomolos' state and animation and returns whether he is currently deadly.
;This routine should be used by entities to determine if they ought to be damaged
;by Nomolos' hit box.
;zero flag set = nomolos is not deadly
;zero flag clear = nomolos is deadly.
.proc nomolosDeadly

  lda nomolosState
  and #nomolosAttackTestAND
  beq @nomolosNotAttacking
  
  ;load current frame
  lda nomolosAnim+1
  cmp #0
  beq @nomolosPawNotExtended
  
  ;we know his paw is extended here, clear zero flag
  lda #1
  
  rts
  
@nomolosPawNotExtended:
  
@nomolosNotAttacking:

  lda #0

  rts

.endproc
  
.proc updateNomolos

  ;************************************************************
  ;Load result of "hurt by map" flag and hurt nomolos if true.
  ;************************************************************
  lda nomolosState
  and #nomolosHurtByMapTestAND
  beq @notHurtByMap
  lda nomolosState
  and #nomolosHurtByMapOffAND
  sta nomolosState
  jsr hurtNomolos
@notHurtByMap:

  ;************************************************************
  ;Update counters for temporary invincibility and for attack
  ;hit box. Call attack routine if B transitions from off to
  ;on.
  ;************************************************************

  ;Update blink counter and reset if zero
  dec nomolosBlinkCounter
  bne skipBlinkReset
  
  lda nomolosState
  and #nomolosBlinkingOffAND
  sta nomolosState
skipBlinkReset:

  ;Update hitbox counter if attack state on
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
  resetAnim nomolosAnim
skipAttackUpdate:

  ;Run attack routine if B transitions from off to on
  lda controllerBuffer+1
  and #%00000011
  ;test for transition from off to on
  cmp #%00000001
  bne skipAttack
  jsr nomolosAttack
skipAttack:

  ;************************************************************
  ;Test for collisions above and below Nomolos.
  ;************************************************************
  
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
  sta w1
  lda nomolosY+2
  adc #$ff
  sta w1+1
  jsr testMapCollision
  beq noTopLeftCollision
  
  jmp yesAboveCollision
  
noTopLeftCollision:
  
  ;Is there a collision above Nomolos? (NomolosY - maxYCollisionDistance)
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
  sta w1
  lda nomolosY+2
  adc #$ff
  sta w1+1
  jsr testMapCollision
  beq noTopRightCollision
  
  jmp yesAboveCollision
  
noTopRightCollision:

  jmp noAboveCollision
  
yesAboveCollision:
  ;There was an above collision:
  ;load "hurt" result of map collision test
  lda b0
  beq @skipSetHurt
  lda nomolosState
  ora #nomolosHurtByMapOnOR
  sta nomolosState
@skipSetHurt:
 
  ;Calculate penetration distance and store it in abovePenetrationDistance.
  ;Set above collision flag.
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
  lda nomolosState
  ora #nomolosAboveCollisionOnOR
  sta nomolosState
  jmp skipNoAboveCollision
noAboveCollision:
  ;There was no above collision.
  ;Clear above collision flag.
  lda nomolosState
  and #nomolosAboveCollisionOffAND
  sta nomolosState
skipNoAboveCollision:
  ;Is there a collision below Nomolos?
  ;(NomolosY + NomolosHeight + maxYCollisionDistance)
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
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  beq noBottomLeftCollision
  
  jmp yesBottomCollision
  
noBottomLeftCollision:
  
  ;Is there a collision below Nomolos?
  ;(NomolosY + NomolosHeight + maxYCollisionDistance)
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
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  beq noBottomRightCollision
  
  jmp yesBottomCollision
  
noBottomRightCollision:
  
  beq noBelowCollision  ;we want to skip the following code when there is not a collision
                        ;set = not collision, so we use beq

yesBottomCollision:
  ;There was a below collision:
  ;load "hurt" result of map collision test
  lda b0
  beq @skipSetHurt
  lda nomolosState
  ora #nomolosHurtByMapOnOR
  sta nomolosState
@skipSetHurt:
  
  ;Calculate penetration distance and store it in belowPenetrationDistance.
  ;Set below collision flag.
  lda nomolosY+1
  clc
  adc #nomolosHeight
  adc #nomolosVerticalSpeedMax
  adc #1
  and #penetrationCalculationMask
  adc #1
  sta nomolosBelowPenetrationDistance
  lda nomolosState
  ora #nomolosBelowCollisionOnOR
  sta nomolosState
  jmp yesBelowCollision
noBelowCollision:
  ;There was no below collision.
  ;Clear below collision flag.
  lda nomolosState
  and #nomolosBelowCollisionOffAND
  sta nomolosState
yesBelowCollision:

  ;************************************************************
  ;Make gravity act on Nomolos.
  ;************************************************************

  ;Compare vertical speed max to current vertical speed.
  lda #nomolosVerticalSpeedMax  
  sec
  sbc nomolosYSpeed+1
  ;we want to skip the following code if the result was negative
  bmi DoNotIncrementSpeed
  ;Yes:
  ;  nomolosYSpeed = nomolosYSpeed + nomolosVerticalAcceleration
  lda nomolosYSpeed
  clc
  adc #nomolosVerticalAccelerationLo
  sta nomolosYSpeed
  lda nomolosYSpeed+1
  adc #nomolosVerticalAccelerationHi
  sta nomolosYSpeed+1
DoNotIncrementSpeed:
    
  ;************************************************************
  ;Find out if the newly calculated vertical speed would make
  ;Nomolos cut into a tile and modify it accordingly.
  ;************************************************************

  ;Test sign of vertical speed so we know what direction we may
  ;need to modify it.
  lda nomolosYSpeed+1
  bmi ySpeedNegative
  ;Vertical speed was positive.
  ;Test for a below collision.
  lda nomolosState
  and #nomolosBelowCollisionTestAND
  lsr
  lsr
  lsr
  beq @noBelowCollision
  ;There was a below collision. 
  ;Compare max vertical speed to below penetration distance.
  lda #nomolosVerticalSpeedMax  
  sec
  sbc nomolosBelowPenetrationDistance
  ;Determine if the penetration is less than the calculated
  ;vertical speed.
  cmp nomolosYSpeed+1
  bpl @penetrationNotLessThanYSpeed
  ;Penetration was less than the calculated vertical speed,
  ;so modify the vertical speed to be equal to the penetration
  ;distance.
  clc
  adc #1
  sta nomolosYSpeed+1
  lda #0
  sta nomolosYSpeed
@penetrationNotLessThanYSpeed:
  ;Penetration was greater than the calculated vertical speed,
  ;so we do not need to modify the vertical speed.
@noBelowCollision:

  jmp skipYSpeedNegativeCode
ySpeedNegative:
  ;Vertical speed was negative.
  ;Test A for on to off transition, stop rising if true.

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

  ;Test for an above collision.
  lda nomolosState
  and #nomolosAboveCollisionTestAND
  lsr
  lsr
  lsr
  lsr
  and #1   
  beq @noAboveCollision
  ;There was a collision above Nomolos.
  
  ;Compare start jump speed to above penetration distance.
  ;Start jump speed is negative so we add it to above penetration distance.
  lda #nomolosStartJumpHi
  clc
  adc nomolosAbovePenetrationDistance
  cmp nomolosYSpeed+1
  bmi @penetrationNotLessThanYSpeed
  ;Vertical speed is greater than the penetration, so we must stop rising
  ;into the air.
  sta nomolosYSpeed+1
  lda #0
  sta nomolosYSpeed

@penetrationNotLessThanYSpeed:
@noAboveCollision:
skipYSpeedNegativeCode:
  ;Vertical speed is less than the penetration, so we don't need to do
  ;anything else. 
  
  ;************************************************************
  ;Test A button for off-to-on transition and start the jump
  ;into the air if so.
  ;************************************************************

  ;Test vertical speed. Skip A button test if is nonzero.
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
  and #1          
  bne @noAboveCollision
  
  lda #nomolosStartJumpLo
  sta nomolosYSpeed
  lda #nomolosStartJumpHi
  sta nomolosYSpeed+1
  
@noAboveCollision:
skipButtonATest:
 
  ;************************************************************
  ;Move vertical position according to vertical speed.
  ;************************************************************
  clc
  lda nomolosY  
  adc nomolosYSpeed
  sta nomolosY
  lda nomolosY+1
  adc nomolosYSpeed+1
  sta nomolosY+1
  lda nomolosYSpeed+1
  bmi @signExtend
  lda nomolosY+2
  adc #0
  sta nomolosY+2
  jmp noSignExtend
@signExtend:
  lda nomolosY+2
  adc #$ff
  sta nomolosY+2
noSignExtend:

  
  ;************************************************************
  ;Test left and right buttons. Test for collision to the left
  ;and to the right. Move if there is room. Reset animation
  ;according to whether fighting state is off and on-to-off 
  ;transition is true.
  ;************************************************************

  ;is there an on to off transition on the left button?
  lda controllerBuffer+6
  and #%00000011
  cmp #%00000010
  bne @skipMoveOff
  
  lda nomolosState
  ;if attack is on, do not reset the animation
  and #nomolosAttackTestAND
  bne @skipResetAnim
  resetAnim nomolosAnim
@skipResetAnim:

  lda nomolosState
  and #nomolosMovingOffAND       ;state not moving
  sta nomolosState
@skipMoveOff:
  
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
  sta w1
  inc w1
  lda nomolosY+2
  adc #0
  sta w1+1
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
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
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
  sta w1
  dec w1
  lda nomolosY+2
  adc #0
  sta w1+1
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
  
  ;is there an on to off transition on the right button?
  lda controllerBuffer+7
  and #%00000011
  cmp #%00000010
  bne @skipMoveOff
  
  lda nomolosState
  ;if attack is on, do not reset the animation
  and #nomolosAttackTestAND
  bne @skipResetAnim
  resetAnim nomolosAnim
@skipResetAnim:

  lda nomolosState
  and #nomolosMovingOffAND       ;state not moving
  sta nomolosState
@skipMoveOff:
  
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
  sta w1
  inc w1
  lda nomolosY+2
  adc #0
  sta w1+1
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
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
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
  sta w1
  dec w1
  lda nomolosY+2
  adc #0
  sta w1+1
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
  
notRight:

  ;************************************************************
  ;Compute screen coordinates from level coordinates.
  ;************************************************************

  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  sta b1
  jsr cameraToScreenCoords
  lda b0
  sta nomolosScreenX
  lda b1
  sta nomolosScreenY 

  ;************************************************************
  ;Move camera to center itself on Nomolos.
  ;************************************************************
  lda nomolosScreenX
  sta b0
  jsr updateCamera
  lda b0
  sta nomolosScreenX
  
  ;************************************************************
  ;Update Nomolos' animation object.
  ;************************************************************
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
  
  ldy #ROMDefinitionTableStruct::NomolosFight
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr updateAnimation
  
  rts
skipUpdateNomolosFighting:
  
  lda nomolosState
  and #nomolosMovingTestAND
  beq skipUpdateNomolosMoving
  ldy #ROMDefinitionTableStruct::NomolosWalk
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
 
  jsr updateAnimation
skipUpdateNomolosMoving:

  rts  
  
.endproc
  
.proc drawNomolos

  lda nomolosState
  and #1
  beq @skipNomolosFacingLeft
  lda #$f4
  sta nomolosHitboxXOffset
  jmp @skipNomolosFacingRight
@skipNomolosFacingLeft:
  lda #$10
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
  
  ldy #ROMDefinitionTableStruct::NomolosFight
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
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
  
  ldy #ROMDefinitionTableStruct::NomolosFightOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
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
  
  resetAnim nomolosAnim
  
  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1
  
  ldy #ROMDefinitionTableStruct::NomolosJump
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
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
  
  ldy #ROMDefinitionTableStruct::NomolosJumpOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
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
  ldy #ROMDefinitionTableStruct::NomolosWalkOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  lda #%00000000
  sta b2
  
  lda nomolosScreenX
  sta b0
  lda nomolosScreenY
  sta b1
  jsr drawAnimation
  
  ldy #ROMDefinitionTableStruct::NomolosWalk
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr drawAnimation
  
  jmp skipNomolosWalkingLeft
skipNomolosWalkingRight:
  ldy #ROMDefinitionTableStruct::NomolosWalkOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  lda #%01000000
  sta b2

  lda nomolosScreenX
  sta b0
  lda nomolosScreenY
  sta b1
  jsr drawAnimation
  
  ldy #ROMDefinitionTableStruct::NomolosWalk
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
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
  ldy #ROMDefinitionTableStruct::Heart0
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
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