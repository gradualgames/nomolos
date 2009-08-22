.include "constants.asm"

;ROM labels
.import NomolosWalkLeft, NomolosWalkRight

;Sprite module labels
.import drawAnimation, updateAnimation

;Map module labels (for collision detection)
.import testMapCollision

;global variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5
.importzp nomolosX, nomolosY, nomolosScreenX, nomolosScreenY
.importzp nomolosXSpeed, nomolosYSpeed, nomolosAnim, nomolosState
.importzp nomolosAbovePenetrationDistance, nomolosBelowPenetrationDistance
.importzp controllerBuffer

;Nomolos interface
.export updateNomolos, drawNomolos

.segment "CODE"

.proc updateNomolos

;Is there a collision above Nomolos? (NomolosY - maxYCollisionDistance)
;  Yes:
;    calculate penetration distance and store it in abovePenetrationDistance
;    nomolosState is TopCollision = true
;  No:
;    nomolosState is TopCollision = false
;Is there a collision below Nomolos? (NomolosY + NomolosHeight + maxYCollisionDistance)
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
  beq noBelowCollision  ;we want to skip the following code when there is not a collision
                        ;set = not collision, so we use beq
;  Yes:
;    calculate penetration distance and store it in belowPenetrationDistance
  ;penetration distance would just be nomolosY+1+height+speedmax AND %00001111
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
  ;we want to skip the following code if the result was positive
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
;    
;;now we have the tentative nomolosYSpeed. We now must find out if it is appropriate.
;    
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
;          Yes:
;            ;we know nomolos is standing squarely on a platform somewhere
;            Is A button down?
;              Yes:
;                nomolosYSpeed = startJumpingSpeed (this is a negative value)             

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
noBelowCollision2:
;  No:
ySpeedNegative:
 
  lda nomolosYSpeed+1
  bne :+
  lda nomolosState
  and #nomolosJumpingTestAND
  lsr
  lsr
  and #1
  beq jumpingDisabled
  
  ;Test if A button is down and collision is beneath nomolos.
  lda controllerBuffer
  and #1
  beq :+
  lda nomolosState
  and #nomolosBelowCollisionTestAND
  lsr
  lsr
  lsr
  beq :+
  ;A button was down, collision was beneath so start the jump and disable jumping for now.
  lda #$0a
  sta nomolosYSpeed
  lda #$f8
  sta nomolosYSpeed+1
  
  lda nomolosState
  and #nomolosJumpingOffAND
  sta nomolosState
:

jumpingDisabled:

  ;jumping was disabled. is A button up?
  lda controllerBuffer
  and #1
  bne :+
  ;yes 
  lda nomolosState
  and #nomolosBelowCollisionTestAND
  lsr
  lsr
  lsr
  beq :+
  lda nomolosState
  ora #nomolosJumpingOnOR
  sta nomolosState
:
  

;    Is nomolosState.TopCollision true?
;      Yes:
;        Calculate maxYCollisionDistance - abovePenetrationDistance
;        Is result = maxYCollisionDistance?
;          Yes:
;            ;nomolos bumped his head, stop his speed so falling will begin
;            nomolosYSpeed = 0
;        Is result < abs(nomolosYSpeed)? 
;          Yes:
;            ;on next iteration, nomolos will be right up against what he's headed towards          
;            nomolosYSpeed = result
;        ;if we reach here we know that Nomolos won't hit anything on the next iteration with the current
;        ;value of nomolosYSpeed
;        Is A button down?
;          No:
;            ;stop rising into the air
;            nomolosYSpeed = 0
;            
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
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  sta b0
  jsr testMapCollision
  bne notLeft
  
  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  clc
  adc #$0f
  sta b0
  jsr testMapCollision
  bne notLeft

  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  lda nomolosY+1
  clc 
  adc #$1f
  sta b0
  jsr testMapCollision
  bne notLeft
  
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
  
  jsr updateNomolosAnimation
notLeft:
  
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
  adc #$0f
  sta w0  
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  sta b0
  jsr testMapCollision
  bne notRight
  
  ;lda nomolosX+1
  lda nomolosX+1
  clc
  adc #$0f
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
  adc #$0f
  sta w0  
  lda nomolosX+2
  adc #$00
  sta w0+1
  lda nomolosY+1
  clc
  adc #$1f
  sta b0
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
  
  jsr updateNomolosAnimation
notRight:

  lda nomolosState
  and #2
  bne :+
  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
:
  
  rts
.endproc
  
updateNomolosAnimation:

  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1
  
  lda nomolosState
  and #1
  bne :+
  lda #<NomolosWalkRight
  sta w2
  lda #>NomolosWalkRight
  sta w2+1
  jmp :++
:
  lda #<NomolosWalkLeft
  sta w2
  lda #>NomolosWalkLeft
  sta w2+1
:  
  jsr updateAnimation

  rts  
  
drawNomolos:

  lda #<nomolosAnim
  sta w1
  lda #>nomolosAnim
  sta w1+1
  
  lda nomolosState
  and #1
  bne :+
  lda #<NomolosWalkRight
  sta w2
  lda #>NomolosWalkRight
  sta w2+1
  jmp :++
:
  lda #<NomolosWalkLeft
  sta w2
  lda #>NomolosWalkLeft
  sta w2+1
:  
  
  ;jsr updateAnimation
  
  lda nomolosScreenX
  sta b0
  lda nomolosScreenY
  sta b1
  jsr drawAnimation

  rts