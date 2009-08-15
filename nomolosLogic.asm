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
.importzp controllerBuffer

;Nomolos interface
.export updateNomolos, drawNomolos

.segment "CODE"

.proc updateNomolos

  ; Is the jumping state off?
  ; Yes:
    ; Is the A button pressed?
  lda controllerBuffer
  and #1
  beq AButtonNotPressed
  
  lda #$fa
  sta nomolosYSpeed+1
  lda #$00
  sta nomolosYSpeed
  
AButtonNotPressed:
      ; Yes:
        ; Set Nomolos jumping state to ON.
        ; Set Nomolos vertical speed to -JUMPINGSTARTSPEED.
  
  ; Is NomolosVerticalSpeed negative?
  lda nomolosYSpeed+1
  bpl nomolosYSpeedNegative
  ; Yes:
      ; Is there a collision at NomolosY + NomolosVerticalSpeed?
        ; Yes:
          ; Negate Nomolos vertical speed.
  ; No:
nomolosYSpeedNegative:
    ; Is there a collision at NomolosY + NomolosHeight + NomolosVerticalSpeed?
  lda nomolosY+1
  clc
  adc #nomolosHeight
  adc nomolosYSpeed+1
  sta b0
  lda nomolosX+1
  sta w0
  lda nomolosX+2
  sta w0+1
  jsr testMapCollision
  bne bottomCollision
  
  lda nomolosY+1
  clc
  adc #nomolosHeight
  adc nomolosYSpeed+1
  sta b0
  lda nomolosX+1
  clc
  adc #$0f
  sta w0
  lda nomolosX+2
  adc #0
  sta w0+1
  jsr testMapCollision
  bne bottomCollision
  
  jmp noBottomCollision
  
bottomCollision:
  
  
      ; Yes:
        ; NomolosVerticalSpeed = 0 - nomolosVerticalAcceleration
  lda #$00
  sta nomolosYSpeed
  sta nomolosYSpeed+1
  sec
  lda nomolosYSpeed
  sbc #nomolosVerticalAccelerationLo
  sta nomolosYSpeed
  lda nomolosYSpeed+1
  sbc #nomolosVerticalAccelerationHi
  sta nomolosYSpeed+1
        ; Is NomolosVerticalSpeed < NomolosVerticalAcceleration?
          ; Yes:
            ; Set Nomolos jumping state to OFF.
      ; No:
noBottomCollision:
        ; Is NomolosVerticalSpeed > NOMOLOSVERTICALSPEEDMAX?
  lda nomolosYSpeed+1
  cmp #nomolosVerticalSpeedMax
  bpl ySpeedGreaterThanMax
          ; No:
            ; NomolosVerticalSpeed += NomolosVerticalAcceleration
  lda nomolosYSpeed
  clc
  adc #nomolosVerticalAccelerationLo
  sta nomolosYSpeed
  lda nomolosYSpeed+1
  adc #nomolosVerticalAccelerationHi
  sta nomolosYSpeed+1
ySpeedGreaterThanMax:
  
            ; Set Nomolos jumping state to ON.
  ; NomolosY = NomolosY + NomolosVerticalSpeed
  lda nomolosY
  clc
  adc nomolosYSpeed
  sta nomolosY
  lda nomolosYSpeed+1
  adc nomolosY+1
  sta nomolosY+1

  lda nomolosState
  and #nomolosMovingOffAND  ;state is not moving
  sta nomolosState
  
  ;lda #$01  ; strobe joypad
  ;sta $4016
  ;lda #$00
  ;sta $4016

  ;lda $4016  ; Is the A button down?
  ;lda $4016  ; B does nothing
  ;lda $4016          ; Select does nothing
  ;lda $4016          ; Start does nothing
  ;lda $4016          ; Up
  
  ; lda controllerBuffer+4 ;up
  ; and #1
  ; beq notUp
  
  ; ;16 bit sub
  ; lda nomolosY
  ; sec
  ; sbc #255
  ; sta nomolosY
  ; lda nomolosY+1
  ; sbc #0
  ; sta nomolosY+1
; notUp:
  
  ; lda controllerBuffer+5 ;down
  
  ; and #1
  ; beq notDown
  ; ;16 bit add
  ; lda nomolosY
  ; clc
  ; adc #255
  ; sta nomolosY
  ; lda nomolosY+1
  ; adc #0
  ; sta nomolosY+1
; notDown:
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