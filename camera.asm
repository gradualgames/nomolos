.segment "ZEROPAGE"
scrollReact = 120
scrollX:                      .res 2

.segment "CODE"

;computes camera coordinates for Nomolos and all on screen game objects
;also moves the camera in response to Nomolos' position
updateCamera:

  ;16 bit sub of NomolosX - ScrollX
  sec
  lda nomolosX+1 ;load low byte of 16 bit part of 24 bit X coord
  sbc scrollX
  sta nomolosScreenX
  lda nomolosX+2
  sbc scrollX+1
  sta nomolosScreenX+1
  
  lda nomolosY+1
  sta nomolosScreenY

  ;compare nomolosScreenX to middle of screen.
  lda nomolosScreenX
  sec
  sbc #scrollReact
  bmi :+
    
  sta b0
  ;adjust nomolosScreenX based on difference with middle of screen.
  sec
  lda nomolosScreenX
  sbc b0
  sta nomolosScreenX
  ;scroll the camera
  clc
  lda scrollX
  adc b0
  sta scrollX
  lda scrollX+1
  adc #0
  sta scrollX+1
  
:
  
  rts