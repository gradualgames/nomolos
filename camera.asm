.include "constants.inc"

.importzp nomolosX, nomolosY, nomolosScreenX, nomolosScreenY
.importzp scrollX
.importzp b0, b1, b2, w0

.export updateCamera, cameraToScreenCoords

.segment "CODE"

;computes screen coordinates based on a 16 bit X coordinate
;and an 8 bit Y coordinate.
;expects: w0 is the x coordinate.
;         b0 is the y coordinate.
;outputs: b1 is the screen x coordinate.
;         b2 is the high byte of the screen x coordinate
;         b0 is the screen y coordinate.
cameraToScreenCoords:

  sec
  lda w0 ;load low byte of 16 bit X coord
  sbc scrollX
  sta b1
  lda w0+1 ;load high byte of 16 bit x coord
  sbc scrollX+1
  sta b2
  
  rts

;moves the camera in response to input position
;expects: b0 is screen X coordinate to respond to
;output:  b0 has been adjusted based on how far the camera was scrolled.
updateCamera:

  ;compare b0 to middle of screen.
  lda b0
  sec
  sbc #scrollReact
  bmi :+
    
  sta b1
  ;adjust b0 based on difference with middle of screen.
  sec
  lda b0
  sbc b1
  sta b0
  ;scroll the camera
  clc
  lda scrollX
  adc b1
  sta scrollX
  lda scrollX+1
  adc #0
  sta scrollX+1
  
:
  
  rts