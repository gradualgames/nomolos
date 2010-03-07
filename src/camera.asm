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

  ;subtract camera_scroll_x from the input X coordinate
  sec
  lda w0 ;load low byte of 16 bit X coord
  sbc camera_scroll_x
  sta w0
  lda w0+1 ;load high byte of 16 bit x coord
  sbc camera_scroll_x+1
  sta w0+1
  ;do nothing to y coordinate since camera never moves from 0 vertically
  
  rts
  
.endproc

;resets camera to the beginning of a level (camera_scroll_x = 0)
.export camera_reset
.proc camera_reset

  lda #0
  sta camera_scroll_next_x
  sta camera_scroll_next_x+1
  lda #$00
  sta camera_scroll_x
  lda #$00
  sta camera_scroll_x+1
  lda #$00
  sta column_to_update

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
  lda camera_scroll_x
  adc b1
  sta camera_scroll_x
  lda camera_scroll_x+1
  adc #0
  sta camera_scroll_x+1
  
:
  
  rts
  
.endproc
