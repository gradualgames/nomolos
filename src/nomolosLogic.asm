.include "constants.inc"
.include "macros.inc"
.include "structs.inc"
.include "flags.inc"

;Sprite module labels
.import drawMetaSprite, drawMetaSprite16, drawAnimation, drawAnimation16, updateAnimation

;Map module labels (for collision detection)
.import testMapCollision

;Camera module labels
.import updateCamera, cameraToScreenCoords

;sound module labels
.import lowc, loadSound, playSound, finishSound

;famitracker module
.import ft_music_init

;global variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5
.importzp nomolosX, nomolosY, nomolosScreenX, nomolosScreenY
.importzp nomolosHitboxX, nomolosHitboxY
.importzp nomolosScaredyCatX, nomolosScaredyCatY
.importzp nomolosXSpeed, nomolosYSpeed, nomolosAnim, nomolosState, nomolosHealth
.importzp nomolosLives
.importzp nomolosBlinkCounter, nomolosHitboxCounter
.importzp nomolosAbovePenetrationDistance, nomolosBelowPenetrationDistance
.importzp romDefinitionTableBaseAddress
.importzp controllerBuffer
.importzp soundAddr, soundOff
.importzp stateControl

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
  sta nomolosHitboxX
  sta nomolosHitboxX+1
  lda #0
  sta nomolosHitboxY
  sta nomolosHitboxY+1

  rts
  
.endproc

;adds health to Nomolos. The accumulator is assumed to contain the
;number of hearts to add on to his health.
.proc addNomolosHealth

  clc
  adc nomolosHealth
  sta nomolosHealth
  
  cmp #maxHealth  ;if result is negative, that means nomolosHealth - maxHealth was negative, which means we're less than maxHealth
                  ;negative is less, positive is more
  bmi :+
  lda #maxHealth
  sta nomolosHealth
:

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
  bne nomolosNotDead
  ;on the instant that nomolos dies, we want him to die. 
  jsr nomolosDie
  
nomolosNotDead:
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
  
;sets the nomolos dying state bit and sets coordinates for the scaredy cat graphic.
.proc nomolosDie

  ;decrease Nomolos' lives
  dec nomolosLives

  ;make nomolos die.
  lda nomolosState
  ora #nomolosDyingOnOR
  sta nomolosState
  
  ;transfer current screen coordinates to scaredy cat coordinates. These coordinates
  ;are located in the same place in memory as the hit box, since we will not need the
  ;hit box while in dying state.
  lda nomolosScreenX
  sta nomolosScaredyCatX
  lda nomolosScreenX+1
  sta nomolosScaredyCatX+1
  
  lda nomolosScreenY
  sta nomolosScaredyCatY
  lda nomolosScreenY+1
  sta nomolosScaredyCatY+1
  
  ;tell famitracker to play the die sound
.if .defined(MUSIC_ENABLE)
  lda #2
  ldx #0
  jsr ft_music_init
.endif  

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
  
.proc loadHurtResult

  ;load "hurt" result of map collision test
  lda b0
  beq :+
  lda nomolosState
  ora #nomolosHurtByMapOnOR
  sta nomolosState
:
  rts

.endproc
  
.proc updateNomolos

  ;************************************************************
  ;Load NomolosY coordinate and test to see if he is off screen
  ;to the bottom. If he is, he should die.
  ;************************************************************
  lda nomolosY+2
  cmp #1
  bne @nomolosNotDead
  dec nomolosLives
  ;tell famitracker to play the die sound
.if .defined(MUSIC_ENABLE)
  lda #2
  ldx #0
  jsr ft_music_init
.endif  
  lda #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  sta stateControl+playLevelStateControl::state
@nomolosNotDead:
  
  ;************************************************************
  ;Load "nomolos dying" flag and update associated variables if
  ;true. Move scaredy cat graphic upwards and clear buttons 
  ;that we do not want to respond to when dying is true.
  ;************************************************************
  lda nomolosState
  and #nomolosDyingTestAND
  beq nomolosNotDying
  
  ;move scaredy cat graphic upwards.
  sec
  lda nomolosScaredyCatY
  sbc #$03
  sta nomolosScaredyCatY
  lda nomolosScaredyCatY+1
  sbc #$00
  sta nomolosScaredyCatY+1
  
  ;when the scaredy cat Y reaches a certain coordinate off the screen,
  ;we want to transition out of this level and to an appropriate "level in"
  ;state. For now, we will just re-load the current level.
  cmp #$fe
  bpl scaredyCatStillRising
  
  lda #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  sta stateControl+playLevelStateControl::state
  
scaredyCatStillRising:
  
  ;clear buttons we don't want to respond to during dying state.
  lda #0
  sta controllerBuffer+buttons::_a
  sta controllerBuffer+buttons::_b
  sta controllerBuffer+buttons::_left
  sta controllerBuffer+buttons::_right
  
  ;we continue from here because we want to keep updating Nomolos'
  ;coordinates. They are used for the slumped armor so it can fall
  ;while Nomolos leaps off the screen in terror.
  
nomolosNotDying:

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
  lda controllerBuffer+buttons::_b
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
  sta w1
  lda nomolosY+2
  adc #$ff
  sta w1+1
  jsr testMapCollision
  jsr loadHurtResult
  lda b1
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
  sta w1
  lda nomolosY+2
  adc #$ff
  sta w1+1
  jsr testMapCollision
  jsr loadHurtResult
  lda b1
  beq noTopRightCollision
  
  jmp yesAboveCollision
  
noTopRightCollision:

  jmp noAboveCollision
  
yesAboveCollision:
  ;There was an above collision:
 
  ;Calculate penetration distance and store it in abovePenetrationDistance.
  ;Set above collision flag.
  lda nomolosY+1
  clc
  adc #nomolosStartJumpHi
  and #penetrationCalculationMask
  sta nomolosAbovePenetrationDistance
  lda #$0f  ;we subtract the above penetration distance from the height of a tile.
  sec
  sbc nomolosAbovePenetrationDistance
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
  adc #(nomolosHeight+nomolosVerticalSpeedMax)
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  jsr loadHurtResult
  lda b1
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
  adc #(nomolosHeight+nomolosVerticalSpeedMax)
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  jsr loadHurtResult
  lda b1
  beq noBottomRightCollision
  
  jmp yesBottomCollision
  
noBottomRightCollision:
  
  beq noBelowCollision  ;we want to skip the following code when there is not a collision
                        ;set = not collision, so we use beq

yesBottomCollision:
  ;There was a below collision:
  
  ;Calculate penetration distance and store it in belowPenetrationDistance.
  ;Set below collision flag.
  lda nomolosY+1
  clc
  adc #(nomolosHeight+nomolosVerticalSpeedMax+2)
  and #penetrationCalculationMask
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
  lda controllerBuffer+buttons::_a
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
  lda controllerBuffer+buttons::_a
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
  lda controllerBuffer+buttons::_left
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
  
  lda controllerBuffer+buttons::_left ;Left

  ;is left button down?
  and #1
  bne skipJmpNotLeft
  jmp notLeft
skipJmpNotLeft:
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
  clc
  adc #1
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  jsr loadHurtResult
  lda b1
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
  jsr loadHurtResult
  lda b1
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
  adc #$1e
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  jsr loadHurtResult
  lda b1
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
  lda controllerBuffer+buttons::_right
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
  
  lda controllerBuffer+buttons::_right ; Right

  ;is right button down?
  and #1
  bne skipJmpNotRight
  jmp notRight
skipJmpNotRight:
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
  clc
  adc #1
  sta w1  
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  jsr loadHurtResult
  lda b1
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
  jsr loadHurtResult
  lda b1
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
  adc #$1e
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  jsr loadHurtResult
  lda b1
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
  sta w1
  lda nomolosY+2
  sta w1+1
  jsr cameraToScreenCoords
  lda w0
  sta nomolosScreenX
  lda w0+1
  sta nomolosScreenX+1
  lda w1
  sta nomolosScreenY 
  lda w1+1
  sta nomolosScreenY+1

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
  
;draws nomolos based on his current state.
.proc drawNomolos

  lda nomolosState
  and #nomolosDyingTestAND
  beq nomolosNotDying
  
  ;if we're in dying state, we will only ever draw the slumped armor and the scaredy cat graphic and return.
  ldy #ROMDefinitionTableStruct::SlumpedArmor
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  
  ;get Nomolos' screen coordinates.
  lda nomolosScreenX
  sta w3
  lda nomolosScreenX+1
  sta w3+1
  lda nomolosScreenY
  sta w4
  lda nomolosScreenY+1
  sta w4+1
  
  lda #0
  sta b2
  
  ;draw the slumped armor
  jsr drawMetaSprite16  
  
  ldy #ROMDefinitionTableStruct::SlumpedArmorOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  
  ;draw the slumped armor overlay
  jsr drawMetaSprite16
  
  ldy #ROMDefinitionTableStruct::ScaredyCat
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  
  ;get Nomolos' screen coordinates.
  lda nomolosScaredyCatX
  sta w3
  lda nomolosScaredyCatX+1
  sta w3+1
  lda nomolosScaredyCatY
  sta w4
  lda nomolosScaredyCatY+1
  sta w4+1
  
  ;draw the scaredy cat
  jsr drawMetaSprite16
  
  ldy #ROMDefinitionTableStruct::ScaredyCatOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  
  ;draw the scaredy cat overlay
  jsr drawMetaSprite16
  
  rts
nomolosNotDying:

  lda nomolosState
  and #1
  beq @skipNomolosFacingLeft
  
  clc
  lda nomolosScreenX
  adc #$f4
  sta nomolosHitboxX
  lda nomolosScreenX+1
  adc #$ff
  sta nomolosHitboxX+1
  
  lda nomolosScreenY
  sta nomolosHitboxY
  lda nomolosScreenY+1
  sta nomolosHitboxY+1

  jmp @skipNomolosFacingRight
@skipNomolosFacingLeft:

  clc
  lda nomolosScreenX
  adc #$10
  sta nomolosHitboxX
  lda nomolosScreenX+1
  adc #$00
  sta nomolosHitboxX+1

  lda nomolosScreenY
  sta nomolosHitboxY
  lda nomolosScreenY+1
  sta nomolosHitboxY+1

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
  sta w3
  lda nomolosScreenX+1
  sta w3+1
  lda nomolosScreenY
  sta w4
  lda nomolosScreenY+1
  sta w4+1
  
  jsr drawAnimation16
  
  ldy #ROMDefinitionTableStruct::NomolosFightOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr drawAnimation16
  
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
  sta w3
  lda nomolosScreenX+1
  sta w3+1
  lda nomolosScreenY
  sta w4
  lda nomolosScreenY+1
  sta w4+1
  
  jsr drawAnimation16
  
  ldy #ROMDefinitionTableStruct::NomolosJumpOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr drawAnimation16
  
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
  sta w3
  lda nomolosScreenX+1
  sta w3+1
  lda nomolosScreenY
  sta w4
  lda nomolosScreenY+1
  sta w4+1
  jsr drawAnimation16
  
  ldy #ROMDefinitionTableStruct::NomolosWalk
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr drawAnimation16
  
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
  sta w3
  lda nomolosScreenX+1
  sta w3+1
  lda nomolosScreenY
  sta w4
  lda nomolosScreenY+1
  sta w4+1
  jsr drawAnimation16
  
  ldy #ROMDefinitionTableStruct::NomolosWalk
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  jsr drawAnimation16
  
skipNomolosWalkingLeft:
  
dontDrawNomolos:

  rts
  
.endproc
  
.import NomolosWalk0
  
.proc drawNomolosHearts
  
  ldx nomolosHealth
  beq skipDrawHearts
  
  lda #$10
  sta b0
  sta b1
  lda #0
  sta b2
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