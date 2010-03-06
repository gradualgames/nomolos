;global headers
.include "constants.inc"

;modules
.include "zp.inc"

.segment "CODE"

;computes screen coordinates based on a 16 bit X coordinate
;and an 8 bit Y coordinate.
;expects: w0 is the x coordinate.
;         w1 is the y coordinate.
;outputs: <w0 is the screen x coordinate.
;         <w1 is the screen y coordinate.
.export camera_to_screen_coords
.proc camera_to_screen_coords

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
  
.endproc

;resets camera to the beginning of a level (scrollX = 0)
.export camera_reset
.proc camera_reset

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
  
.endproc
  
;moves the camera in response to input position
;expects: b0 is screen X coordinate to respond to
;output:  b0 has been adjusted based on how far the camera was scrolled.
.export camera_update
.proc camera_update

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
  
.endproc
