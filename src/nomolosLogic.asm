.include "constants.inc"
.include "macros.inc"
.include "structs.inc"
.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "sprite.inc"
.include "map.inc"
.include "camera.inc"
.include "sound.inc"
.include "famitracker.inc"
.include "zp.inc"

.segment "CODE"

.export nomolos_init
.proc nomolos_init

  resetAnim nomolosAnim
  resetAnim nomolosWeaponAnim

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

;adds a life to Nomolos. The accumulator is assumed to contain the
;number of lives to add.
.export nomolos_add_life
.proc nomolos_add_life

  clc
  adc nomolosLives
  sta nomolosLives
  
  cmp #maxLives  
  bmi :+
  lda #maxLives
  sta nomolosLives
:
  rts

.endproc

;adds health to Nomolos. The accumulator is assumed to contain the
;number of hearts to add on to his health.
.export nomolos_add_health
.proc nomolos_add_health

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
.export nomolos_hurt
.proc nomolos_hurt

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
  jsr nomolos_die_attack
  
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

;sets the nomolos dying state bit, and the sub state bit that represents "falling"
.export nomolos_die_fall
.proc nomolos_die_fall

  ;make certain we're not already dying...
  lda nomolosState
  and #nomolosDyingTestAND
  bne alreadyDying

  ;lose special weapon if any
  lda nomolosSubState
  and #nomolosAttackSetMask
  sta nomolosSubState
  
  ;decrease Nomolos' lives
  dec nomolosLives
  
  ;make nomolos die.
  lda nomolosState
  ora #nomolosDyingOnOR
  sta nomolosState
  
  ;make sure all following logic knows that this is death by falling.
  lda nomolosSubState
  and #nomolosFellDyingAND
  sta nomolosSubState
  
  ;store a frame counter value so we can pause a bit before transitioning to level out
  lda #200
  sta frameCounter
  
  ;tell famitracker to play the die sound
.if .defined(MUSIC_ENABLE)
  lda #2
  ldx #0
  jsr ft_music_init
.endif  

alreadyDying:

  rts
  
.endproc
  
;sets the nomolos dying state bit and sets coordinates for the scaredy cat graphic.
.export nomolos_die_attack
.proc nomolos_die_attack

  lda currentBank
  pha

  ;decrease Nomolos' lives
  dec nomolosLives

  ;lose special weapon if any
  lda nomolosSubState
  and #nomolosAttackSetMask
  sta nomolosSubState
  
  ;make nomolos die.
  lda nomolosState
  ora #nomolosDyingOnOR
  sta nomolosState
  
  ;make sure all following logic knows that this is death by being attacked
  lda nomolosSubState
  ora #nomolosAttackedDyingOR
  sta nomolosSubState
  
  ;transfer current screen coordinates to scaredy cat coordinates.
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
  ;switch to the level and music bank
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (romDefinitionTableBaseAddress),y
  sta nextBank
  jsr bankswitch
  lda #2
  ldx #0
  jsr ft_music_init
.endif  

  pla
  sta nextBank
  jsr bankswitch

  rts

.endproc
  
.proc nomolos_attack_spear

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
  
  ;set initial location for the hit box
  lda #$20
  sta nomolosHitboxWidth
  lda #$08
  sta nomolosHitboxHeight

  lda nomolosState
  and #1
  beq skipNomolosFacingLeft
  
  clc
  lda nomolosScreenX
  adc #$f0
  sta nomolosHitboxX
  lda nomolosScreenX+1
  adc #$ff
  sta nomolosHitboxX+1
  
  clc
  lda nomolosScreenY
  adc #$10
  sta nomolosHitboxY
  lda nomolosScreenY+1
  adc #$00
  sta nomolosHitboxY+1

  jmp skipNomolosFacingRight
skipNomolosFacingLeft:

  clc
  lda nomolosScreenX
  adc #$10
  sta nomolosHitboxX
  lda nomolosScreenX+1
  adc #$00
  sta nomolosHitboxX+1

  clc
  lda nomolosScreenY
  adc #$10
  sta nomolosHitboxY
  lda nomolosScreenY+1
  adc #$00
  sta nomolosHitboxY+1

skipNomolosFacingRight:
  
  rts

.endproc
  
;Causes the hit box to be activated for a few frames.
.export nomolos_attack_sword
.proc nomolos_attack_sword

  ;if attacking is on, skip this whole routine
  lda nomolosState
  and #nomolosAttackTestAND
  bne skipAttack

  lda nomolosSubState
  and #nomolosAttackTestMask
  cmp #nomolosAttackSword
  beq nomolosAttackSwordBranch
  cmp #nomolosAttackFlail
  beq nomolosAttackFlailBranch
  cmp #nomolosAttackSpear
  beq nomolosAttackSpearBranch
  jmp attackSwitchDone
  
nomolosAttackSpearBranch:

  jsr nomolos_attack_spear

  jmp attackSwitchDone
  
nomolosAttackSwordBranch:
  
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
  
  jmp attackSwitchDone
  
nomolosAttackFlailBranch:

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
  
  ;reset weapon animation
  resetAnim nomolosWeaponAnim
  
attackSwitchDone:
skipAttack:
  
  rts
  
.endproc
  
;tests nomolos' state and animation and returns whether he is currently deadly.
;This routine should be used by entities to determine if they ought to be damaged
;by Nomolos' hit box.
;zero flag set = nomolos is not deadly
;zero flag clear = nomolos is deadly.
.export nomolos_is_deadly
.proc nomolos_is_deadly

  lda nomolosState
  and #nomolosAttackTestAND
  beq nomolosNotAttacking
  
  lda nomolosSubState
  and #nomolosAttackTestMask
  cmp #nomolosAttackSword
  beq nomolosAttackSwordBranch
  cmp #nomolosAttackFlail
  beq nomolosAttackFlailBranch
  cmp #nomolosAttackSpear
  beq nomolosAttackSpearBranch
  jmp attackSwitchDone
  
nomolosAttackSpearBranch:

  lda #1

  rts

  jmp attackSwitchDone
  
nomolosAttackSwordBranch:
  ;load current frame
  lda nomolosAnim+1
  cmp #0
  beq nomolosPawNotExtended
  
  ;we know his paw is extended here, clear zero flag
  lda #1
  
  rts
  
nomolosPawNotExtended:
  
  jmp attackSwitchDone
  
nomolosAttackFlailBranch:

  ;lets just say he's always deadly
  lda #1
  
  rts
  
attackSwitchDone:
  
nomolosNotAttacking:

  lda #0

  rts

.endproc
  
.export nomolos_load_hurt_result
.proc nomolos_load_hurt_result

  ;load "hurt" result of map collision test
  lda b0
  beq :+
  lda nomolosState
  ora #nomolosHurtByMapOnOR
  sta nomolosState
:
  rts

.endproc
  
.proc nomolos_update_attack_sword

  lda #$10
  sta nomolosHitboxWidth
  lda #$20
  sta nomolosHitboxHeight

  lda nomolosState
  and #1
  beq skipNomolosFacingLeft
  
  clc
  lda nomolosScreenX
  adc #$f0
  sta nomolosHitboxX
  lda nomolosScreenX+1
  adc #$ff
  sta nomolosHitboxX+1
  
  lda nomolosScreenY
  sta nomolosHitboxY
  lda nomolosScreenY+1
  sta nomolosHitboxY+1

  jmp skipNomolosFacingRight
skipNomolosFacingLeft:

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

skipNomolosFacingRight:

  dec nomolosHitboxCounter
  bne skipAttackUpdate
  
  ;set attack state to off
  lda nomolosState
  and #nomolosAttackOffAND
  sta nomolosState
  
  ;reset animation object
  resetAnim nomolosAnim
skipAttackUpdate:

  rts

.endproc
  
.export nomolos_update_attack_flail
.proc nomolos_update_attack_flail

  lda #$10
  sta nomolosHitboxWidth
  lda #$20
  sta nomolosHitboxHeight

  lda nomolosHitboxCounter
  and #1
  beq skipNomolosFacingLeft
  
  clc
  lda nomolosScreenX
  adc #$e0
  sta nomolosHitboxX
  lda nomolosScreenX+1
  adc #$ff
  sta nomolosHitboxX+1
  
  lda nomolosScreenY
  sta nomolosHitboxY
  lda nomolosScreenY+1
  sta nomolosHitboxY+1

  jmp skipNomolosFacingRight
skipNomolosFacingLeft:

  clc
  lda nomolosScreenX
  adc #$20
  sta nomolosHitboxX
  lda nomolosScreenX+1
  adc #$00
  sta nomolosHitboxX+1

  lda nomolosScreenY
  sta nomolosHitboxY
  lda nomolosScreenY+1
  sta nomolosHitboxY+1

skipNomolosFacingRight:

  dec nomolosHitboxCounter
  bne skipAttackUpdate
  
  ;set attack state to off
  lda nomolosState
  and #nomolosAttackOffAND
  sta nomolosState
  
  ;reset animation object
  resetAnim nomolosAnim
skipAttackUpdate:

  rts

.endproc
  
.proc nomolos_update_attack_spear

  ;move the spear in the direction nomolos is facing
  lda nomolosState
  and #1
  beq nomolosFacingRight
nomolosFacingLeft:
  
  sec
  lda nomolosHitboxX
  sbc #10
  sta nomolosHitboxX
  lda nomolosHitboxX+1
  sbc #0
  sta nomolosHitboxX+1
  
  jmp nomolosDirectionTestDone
  
nomolosFacingRight:

  clc
  lda nomolosHitboxX
  adc #10
  sta nomolosHitboxX
  lda nomolosHitboxX+1
  adc #0
  sta nomolosHitboxX+1

nomolosDirectionTestDone:  

  dec nomolosHitboxCounter
  bne skipAttackUpdate
  
  ;set attack state to off
  lda nomolosState
  and #nomolosAttackOffAND
  sta nomolosState
  
  ;reset animation object
  resetAnim nomolosAnim
skipAttackUpdate:
  rts

.endproc
  
.proc nomolos_test_collision_below

  ;Is there a collision at bottom left of Nomolos?
  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  clc
  adc #(nomolosHeight+1)
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  jsr nomolos_load_hurt_result
  lda b1
  bne yesBelowCollision

  ;Is there a collision at bottom right of Nomolos?
  lda nomolosX+1
  clc
  adc #$0f
  sta w0
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  clc
  adc #(nomolosHeight+1)
  sta w1
  lda nomolosY+2
  adc #0
  sta w1+1
  jsr testMapCollision
  jsr nomolos_load_hurt_result
  lda b1
  bne yesBelowCollision
  
noBelowCollision:
  rts
  
yesBelowCollision:

  ;Calculate penetration distance and store it in belowPenetrationDistance.
  ;Set below collision flag.
  lda nomolosY+1
  clc
  adc #(nomolosHeight+1)
  and #penetrationCalculationMask
  sta nomolosBelowPenetrationDistance
  
  ;eject by penetration distance
  lda nomolosY+1
  sec
  sbc nomolosBelowPenetrationDistance
  sta nomolosY+1
  lda nomolosY+2
  sbc #0
  sta nomolosY+2
  
  lda nomolosState
  ora #nomolosBelowCollisionOnOR
  sta nomolosState
  
  ;************************************************************
  ;Test A button for off-to-on transition and start the jump
  ;into the air if so.
  ;************************************************************

  ;Test if current state of A button is down and previous state is up. In other words,
  ;AND with #%00000011, then test for equality to 1.
  lda controllerBuffer+buttons::_a
  and #%00000011
  cmp #1
  bne skipButtonATest
  
  lda #nomolosStartJumpLo
  sta nomolosYSpeed
  lda #nomolosStartJumpHi
  sta nomolosYSpeed+1

  rts
  
skipButtonATest:
  
  ;set velocity to zero, since we've collided with the ground and the player
  ;has not pressed A.
  lda #0
  sta nomolosYSpeed
  sta nomolosYSpeed+1
  
  rts

.endproc
  
.proc nomolos_test_collision_above

  ;Is there a collision at top left of Nomolos?
  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  sta w1
  lda nomolosY+2
  sta w1+1
  jsr testMapCollision
  jsr nomolos_load_hurt_result
  lda b1
  bne yesAboveCollision
  
  ;Is there a collision at top right of Nomolos?
  lda nomolosX+1
  clc
  adc #$0f
  sta w0
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  sta w1
  lda nomolosY+2
  sta w1+1
  jsr testMapCollision
  jsr nomolos_load_hurt_result
  lda b1
  bne yesAboveCollision
  
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
  
  rts
  
yesAboveCollision:
  ;There was an above collision:
 
  ;Calculate penetration distance and store it in abovePenetrationDistance.
  ;Set above collision flag.
  lda nomolosY+1
  and #penetrationCalculationMask
  sta nomolosAbovePenetrationDistance
  lda #$0f  ;we subtract the above penetration distance from the height of a tile.
  sec
  sbc nomolosAbovePenetrationDistance
  sta nomolosAbovePenetrationDistance
  
  ;eject by penetration distance
  lda nomolosY+1
  clc
  adc nomolosAbovePenetrationDistance
  sta nomolosY+1
  lda nomolosY+2
  adc #0
  sta nomolosY+2
  
  lda nomolosState
  ora #nomolosAboveCollisionOnOR
  sta nomolosState
  
  ;reset velocity
  lda #0
  sta nomolosYSpeed
  sta nomolosYSpeed+1
  
  rts
.endproc
  
.export nomolos_update
.proc nomolos_update

  ;************************************************************
  ;Load NomolosY coordinate and test to see if he is off screen
  ;to the bottom. If he is, he should die.
  ;************************************************************
  lda nomolosY+2
  cmp #1
  bne @nomolosNotDead
  jsr nomolos_die_fall
@nomolosNotDead:
  
  ;************************************************************
  ;Load "nomolos dying" flag and update associated variables if
  ;true. Move scaredy cat graphic upwards and clear buttons 
  ;that we do not want to respond to when dying is true.
  ;************************************************************
  lda nomolosState
  and #nomolosDyingTestAND
  beq nomolosNotDying
  
  ;clear buttons we don't want to respond to during dying state.
  lda #0
  sta controllerBuffer+buttons::_a
  sta controllerBuffer+buttons::_b
  sta controllerBuffer+buttons::_left
  sta controllerBuffer+buttons::_right
  
  lda nomolosSubState
  and #nomolosAttackedDyingTestAND
  beq nomolosNotAttackedDying
  
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
  
  jmp nomolosNotDying
  
nomolosNotAttackedDying:
  
  dec frameCounter
  bne skipLevelOutState
  
  lda #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  sta stateControl+playLevelStateControl::state
  
skipLevelOutState:
  
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
  jsr nomolos_hurt
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
  beq skipAttack
  ;attack state was on
  
  lda nomolosSubState
  and #nomolosAttackTestMask
  cmp #nomolosAttackSword
  beq nomolosAttackSwordBranch
  cmp #nomolosAttackFlail
  beq nomolosAttackFlailBranch
  cmp #nomolosAttackSpear
  beq nomolosAttackSpearBranch
  jmp attackSwitchDone
  
nomolosAttackSpearBranch:

  jsr nomolos_update_attack_spear
  
  jmp attackSwitchDone
  
nomolosAttackSwordBranch:

  jsr nomolos_update_attack_sword

  jmp attackSwitchDone
  
nomolosAttackFlailBranch:

  jsr nomolos_update_attack_flail
  
attackSwitchDone:
skipAttack:

  ;Run attack routine if B transitions from off to on
  lda controllerBuffer+buttons::_b
  and #%00000011
  ;test for transition from off to on
  cmp #%00000001
  bne :+
  jsr nomolos_attack_sword
:

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
  ;Test vertical velocity sign and then detect collision with
  ;map and eject if necessary. Also check for A button press
  ;or release to start/stop jumping.
  ;************************************************************
  ;clear the collision flags
  lda nomolosState
  and #nomolosBelowCollisionOffAND
  and #nomolosAboveCollisionOffAND
  sta nomolosState
  
  lda nomolosYSpeed+1
  bmi ySpeedNegative
ySpeedPositive:
  jsr nomolos_test_collision_below
  
  jmp ySpeedTestDone
ySpeedNegative:
  jsr nomolos_test_collision_above
  
dontStopRising:

ySpeedTestDone:
  
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
  jsr nomolos_load_hurt_result
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
  jsr nomolos_load_hurt_result
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
  jsr nomolos_load_hurt_result
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
  
  ;jsr nomolos_update_animation
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
  jsr nomolos_load_hurt_result
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
  jsr nomolos_load_hurt_result
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
  jsr nomolos_load_hurt_result
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
  jsr nomolos_update_animation
  
  rts
.endproc
  
.export nomolos_update_animation
.proc nomolos_update_animation

  ;switch to the actor and entity bank
  ldy #ROMDefinitionTableStruct::NomolosAndEntityBank
  lda (romDefinitionTableBaseAddress),y
  sta nextBank
  jsr bankswitch  

  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1

  lda nomolosState
  and #nomolosAttackTestAND
  beq skipUpdateNomolosFighting
  
  lda nomolosSubState
  and #nomolosAttackTestMask
  cmp #nomolosAttackSword
  beq nomolosAttackSwordBranch
  cmp #nomolosAttackFlail
  beq nomolosAttackFlailBranch
  cmp #nomolosAttackSpear
  beq nomolosAttackSpearBranch
  jmp attackSwitchDone
  
nomolosAttackSpearBranch:
  ldy #ROMDefinitionTableStruct::NomolosSpear
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_update_animation  

  jmp attackSwitchDone
  
nomolosAttackSwordBranch:
  ldy #ROMDefinitionTableStruct::NomolosFight
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_update_animation
  
  jmp attackSwitchDone
  
nomolosAttackFlailBranch:

  ldy #ROMDefinitionTableStruct::NomolosFlail
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_update_animation
  
  lda #<nomolosWeaponAnim
  sta w1
  lda #>nomolosWeaponAnim
  sta w1+1

  ldy #ROMDefinitionTableStruct::FlailBall
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_update_animation
  
attackSwitchDone:
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
 
  jsr sprite_update_animation
skipUpdateNomolosMoving:

  rts  
  
.endproc
  
.export nomolos_draw_attack_flail
.proc nomolos_draw_attack_flail

  ;draw the flail animation and flail ball animation here
  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1
  
  ldy #ROMDefinitionTableStruct::NomolosFlail
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  ;get the direction bit into bit 6 of b2 for horiz flip
  clc
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
  
  jsr sprite_draw_animation_16bit
  
  ldy #ROMDefinitionTableStruct::NomolosFlailOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_draw_animation_16bit
  
  lda #<nomolosWeaponAnim
  sta w1
  lda #>nomolosWeaponAnim
  sta w1+1
  
  ldy #ROMDefinitionTableStruct::FlailBall
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_draw_animation_16bit
  
  rts

.endproc
  
.export nomolos_draw_attack_sword
.proc nomolos_draw_attack_sword

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
  clc
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
  
  jsr sprite_draw_animation_16bit
  
  ldy #ROMDefinitionTableStruct::NomolosFightOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_draw_animation_16bit
  
  rts

.endproc

.export nomolos_draw_attack_spear
.proc nomolos_draw_attack_spear

  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1
  
  ldy #ROMDefinitionTableStruct::NomolosSpear
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  ;get the direction bit into bit 6 of b2 for horiz flip
  clc
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
  
  jsr sprite_draw_animation_16bit
  
  ldy #ROMDefinitionTableStruct::NomolosFightOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_draw_animation_16bit
  
  ;draw the spear at the location of the hit box
  lda nomolosHitboxX
  sta w3
  lda nomolosHitboxX+1
  sta w3+1
  lda nomolosHitboxY
  sta w4
  lda nomolosHitboxY+1
  sta w4+1
  
  ldy #ROMDefinitionTableStruct::SpearFly
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  
  jsr sprite_draw_metasprite_16bit
  
  rts

.endproc
  
;draws nomolos based on his current state.
.export nomolos_draw
.proc nomolos_draw

  lda nomolosState
  and #nomolosDyingTestAND
  beq nomolosNotDying
  
  lda nomolosSubState
  and #nomolosAttackedDyingTestAND
  beq nomolosNotAttackedDying
  
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
  jsr sprite_draw_metasprite_16bit  
  
  ldy #ROMDefinitionTableStruct::SlumpedArmorOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  
  ;draw the slumped armor overlay
  jsr sprite_draw_metasprite_16bit
  
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
  jsr sprite_draw_metasprite_16bit
  
  ldy #ROMDefinitionTableStruct::ScaredyCatOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  
  ;draw the scaredy cat overlay
  jsr sprite_draw_metasprite_16bit
  
nomolosNotAttackedDying:
  
  rts
nomolosNotDying:

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
  
  lda nomolosSubState
  and #nomolosAttackTestMask
  cmp #nomolosAttackSword
  beq nomolosAttackSwordBranch
  cmp #nomolosAttackFlail
  beq nomolosAttackFlailBranch
  cmp #nomolosAttackSpear
  beq nomolosAttackSpearBranch
  
nomolosAttackSpearBranch:

  jsr nomolos_draw_attack_spear
  
  jmp attackSwitchDone
  
nomolosAttackFlailBranch:

  jsr nomolos_draw_attack_flail

  jmp attackSwitchDone
  
nomolosAttackSwordBranch:

  jsr nomolos_draw_attack_sword
  
  jmp attackSwitchDone
  
attackSwitchDone:
  
  rts
  
skipDrawNomolosFighting:


  ;test if there is anything below nomolos. if there is not,
  ;draw nomolos's jumping animation.
  lda nomolosState
  and #nomolosBelowCollisionTestAND
  lsr
  lsr
  lsr
  bne skipDrawNomolosJumping

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
  
  jsr sprite_draw_animation_16bit
  
  ldy #ROMDefinitionTableStruct::NomolosJumpOverlay
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_draw_animation_16bit
  
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
  jsr sprite_draw_animation_16bit
  
  ldy #ROMDefinitionTableStruct::NomolosWalk
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  
  jsr sprite_draw_animation_16bit
  
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
  jsr sprite_draw_animation_16bit
  
  ldy #ROMDefinitionTableStruct::NomolosWalk
  lda (romDefinitionTableBaseAddress),y
  sta w2
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w2+1
  jsr sprite_draw_animation_16bit
  
skipNomolosWalkingLeft:
  
dontDrawNomolos:

  rts  
.endproc
  
.export nomolos_draw_hearts
.proc nomolos_draw_hearts
  
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
  jsr sprite_draw_metasprite_8bit
  lda b0
  clc
  adc #$08
  sta b0
  dex  
  bne drawNextHeart
skipDrawHearts:

  rts  
.endproc
