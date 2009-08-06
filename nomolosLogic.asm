.include "constants.asm"

;ROM labels
.import NomolosWalkLeft, NomolosWalkRight

;Sprite module labels
.import drawAnimation, updateAnimation

;global variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5
.importzp nomolosX, nomolosY, nomolosScreenX, nomolosScreenY
.importzp nomolosXSpeed, nomolosAnim, nomolosState

;Nomolos interface
.export getInput, drawNomolos

.segment "CODE"

getInput:

  lda nomolosState
  and #nomolosMovingOffAND  ;state is not moving
  sta nomolosState
  
  lda #$01  ; strobe joypad
  sta $4016
  lda #$00
  sta $4016

  lda $4016  ; Is the A button down?
  lda $4016  ; B does nothing
  lda $4016          ; Select does nothing
  lda $4016          ; Start does nothing
  lda $4016          ; Up
  
  and #1
  beq :+
  ;16 bit sub
  lda nomolosY
  sec
  sbc #255
  sta nomolosY
  lda nomolosY+1
  sbc #0
  sta nomolosY+1
:
  
  lda $4016          ; Down
  
  and #1
  beq :+
  ;16 bit add
  lda nomolosY
  clc
  adc #255
  sta nomolosY
  lda nomolosY+1
  adc #0
  sta nomolosY+1
:
  lda $4016          ; Left

  ;is left button down?
  and #1
  beq :+  
  lda nomolosState
  ora #nomolosWalkingLeftOR
  ora #nomolosMovingOnOR
  
  sta nomolosState
  
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
:
  
  lda $4016          ; Right

  ;is right button down?
  and #1
  beq :+
  lda nomolosState
  and #nomolosWalkingRightAND ;state is walking right
  ora #nomolosMovingOnOR       ;state is moving
  sta nomolosState
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
:

  lda nomolosState
  and #2
  bne :+
  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
:
  
  rts

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