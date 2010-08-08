;global headers

.include "camera.inc"
.include "fixed_bank_data.inc"

;modules
.include "zp.inc"

.segment "CODE"

;computes screen coordinates based on a 16 bit X coordinate
;and an 8 bit Y coordinate.
;expects: w0 is the x coordinate.
;         w1 is the y coordinate.
;outputs: <w0 is the screen x coordinate.
;         <w1 is the screen y coordinate.
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
.proc camera_reset

  lda #$00
  sta camera_scroll_x

  ldy #level_data_struct::starting_screen
  lda (base_address_rom_definition_table),y
  sta camera_scroll_x+1

  lda #$00
  sta camera_min_scroll_x
  ldy #level_data_struct::starting_screen
  lda (base_address_rom_definition_table),y
  sta camera_min_scroll_x+1

  ;max scroll x starts out one screen over
  clc
  lda camera_min_scroll_x
  adc #0
  sta camera_max_scroll_x
  lda camera_min_scroll_x+1
  adc #1
  sta camera_max_scroll_x+1

  ;camera enabled by default
  lda #1
  sta camera_scroll_enabled

  rts

.endproc

;moves the camera in response to input position
;expects: w0 is screen X coordinate to respond to
;users: w1
.proc camera_scroll_right

  lda camera_scroll_enabled
  beq do_not_scroll

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

  ;compare max scroll x to current scroll x

  ;compute right side of "already seen" window
  clc
  lda camera_scroll_x
  adc #250
  sta w1
  lda camera_scroll_x+1
  adc #0
  sta w1+1

  ;compare this to current max
  sec
  lda w1
  sbc camera_max_scroll_x
  lda w1+1
  sbc camera_max_scroll_x+1

  ;if this is positive, then we must increase the max
  bmi negative
positive:
  lda w1
  sta camera_max_scroll_x
  lda w1+1
  sta camera_max_scroll_x+1
negative:

  lda #1
  sta camera_scroll_direction

:
do_not_scroll:

  rts

.endproc

;moves the camera in response to input position
;expects: w0 is screen X coordinate to respond to
.proc camera_scroll_left

  lda camera_scroll_enabled
  beq do_not_scroll

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

  ;do not scroll past zero
  bpl skip_do_not_scroll_past_zero
  lda #0
  sta camera_scroll_x
  sta camera_scroll_x+1
skip_do_not_scroll_past_zero:

  ;compute left side of "already seen" window
  clc
  lda camera_scroll_x
  adc #5
  sta w1
  lda camera_scroll_x+1
  adc #0
  sta w1+1

  ;compare to current minimum
  sec
  lda w1
  sbc camera_min_scroll_x
  lda w1+1
  sbc camera_min_scroll_x+1

  bpl positive
negative:
  lda w1
  sta camera_min_scroll_x
  lda w1+1
  sta camera_min_scroll_x+1
positive:

  lda #$ff
  sta camera_scroll_direction

:
do_not_scroll:

  rts
.endproc