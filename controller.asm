.segment "CODE"

.importzp controllerBuffer

.export readController

;deserializes the controller into a buffer
;output: controllerBuffer
.proc readController
  lda #$01  ; strobe joypad
  sta $4016
  lda #$00
  sta $4016
  lda $4016  ; A 
  ;put button bit into carry
  ror 
  ;put carry bit into controller buffer. use rol to keep
  ;history of button presses.
  rol controllerBuffer
  lda $4016  ; B 
  ror
  rol controllerBuffer+1
  lda $4016          ; Select 
  sta controllerBuffer+2
  lda $4016          ; Start 
  sta controllerBuffer+3
  lda $4016          ; Up
  sta controllerBuffer+4
  lda $4016          ; Down
  sta controllerBuffer+5
  lda $4016          ; Left 
  ror
  rol controllerBuffer+6
  lda $4016          ; Right  
  ror
  rol controllerBuffer+7
  rts
.endproc