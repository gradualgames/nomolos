.include "constants.inc"

.importzp nomolosX, nomolosY, nomolosScreenX, nomolosScreenY
.importzp scrollX, nextScrollX, columnToUpdate
.importzp b0, b1, b2, b3, w0, w1

.export resetCamera, updateCamera, cameraToScreenCoords

.segment "CODE"

;computes screen coordinates based on a 16 bit X coordinate
;and an 8 bit Y coordinate.
;expects: w0 is the x coordinate.
;         w1 is the y coordinate.
;outputs: <w0 is the screen x coordinate.
;         <w1 is the screen y coordinate.
cameraToScreenCoords:

  ;subtract scrollX from the input X coordinate
  sec
  lda w0 ;load low byte of 16 bit X coord
  sbc scrollX
  sta w0
  lda w0+1 ;load high byte of 16 bit x coord
  sbc scrollX+1
  sta w0+1
  ;do nothing to y coordinate since camera never moves from 0 vertically
  
  rts

;resets camera to the beginning of a level (scrollX = 0)
resetCamera:

  lda #0
  sta nextScrollX
  sta nextScrollX+1
  lda #$00
  sta scrollX
  lda #$00
  sta scrollX+1
  lda #$00
  sta columnToUpdate

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