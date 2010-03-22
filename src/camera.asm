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

  lda #$00
  sta camera_scroll_x
  lda #$00
  sta camera_scroll_x+1
  lda #$00
  sta column_to_update

  rts
  
.endproc
  
;moves the camera in response to input position
;expects: w0 is screen X coordinate to respond to
;output:  w0 has been adjusted based on how far the camera was scrolled.
.export camera_scroll_right
.proc camera_scroll_right

  sec
  lda w0
  sbc #scrollReactRight
  lda w0+1
  sbc #0
  bmi :+
  
  ;x coord was to the right of scrollReactRight. now we scroll the camera, by how much? w0 - scrollReactRight
  sec
  lda w0
  sbc #scrollReactRight
  sta w1
  lda w0+1
  sbc #0
  sta w1+1
  
  clc
  lda camera_scroll_x
  adc w1
  sta camera_scroll_x
  lda camera_scroll_x+1
  adc w1+1
  sta camera_scroll_x+1
  
  lda #1
  sta camera_will_scroll_right
  
  
:

  rts

.endproc

;moves the camera in response to input position
;expects: b0 is screen X coordinate to respond to
;output:  b0 has been adjusted based on how far the camera was scrolled.
.export camera_scroll_left
.proc camera_scroll_left


  sec
  lda w0
  sbc #scrollReactLeft
  lda w0+1
  sbc #0
  bpl :+
  
  ;x coord was to the left of scrollReactLeft. now we scroll the camera, by how much? scrollReactLeft - w0
  sec
  lda #scrollReactLeft
  sbc w0
  sta w1
  lda #0
  sbc w0+1
  sta w1+1
  
  sec
  lda camera_scroll_x
  sbc w1
  sta camera_scroll_x
  lda camera_scroll_x+1
  sbc w1+1
  sta camera_scroll_x+1
  
  lda #0
  sta camera_will_scroll_right
  
:

  rts
.endproc