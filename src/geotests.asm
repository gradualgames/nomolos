.include "zp.inc"

.segment "CODE"

;tests whether a point is inside a rectangle using 8 bit coordinates.
;b1 - x coordinate of point to test
;b2 - y coordinate of point to test
;b3 - top left x of rectangle
;b4 - top left y of rectangle
;b5 - width
;b6 - height
;global variables:
;b7 - bottom right x of rectangle
;b8 - bottom right x of rectangle
.export geotests_point_in_rect_8bit
.proc geotests_point_in_rect_8bit

  ;calculate bottom right x (b3 + b5)
  lda b3
  clc
  adc b5
  sta b7

  ;calculate bottom right y (b4 + b6)
  lda b4
  clc
  adc b6
  sta b8

  ;if x < top left x (b3 - b1 is positive), test fails
  lda b3
  sec
  sbc b1
  bpl point_not_in_rect

  ;if y < top left y (b4 - b2 is positive), test fails
  lda b4
  sec
  sbc b2
  bpl point_not_in_rect

  ;if x > bottom right x (b1 - b7 is positive), test fails
  lda b1
  sec
  sbc b7
  bpl point_not_in_rect

  ;if y > bottom right y (b2 - b8 is positive), test fails
  lda b2
  sec
  sbc b8
  bpl point_not_in_rect

point_is_in_rect:

  ;set zero flag (point IS inside rectangle)
  lda #$00

  rts

point_not_in_rect:

  ;clear zero flag (point is NOT inside rectangle)
  lda #$ff

  rts

.endproc

;tests one rectangle for whether it intersects another.
;rectangle A:
;w2 - left x
;w3 - top y
;b2 - width
;b3 - height
;rectangle B:
;w4 - left x
;w5 - top y
;b4 - width
;b5 - height
;global variables used:
;rectangle A:
;w6 - right x
;w7 - bottom y
;rectangle B:
;w8 - right x
;w9 - bottom y
.export geotests_rect_in_rect_16bit
.proc geotests_rect_in_rect_16bit
  ;compute bottom of rectangle A
  clc
  lda w3
  adc b3
  sta w7
  lda w3+1
  adc #0
  sta w7+1

  ;load bottom of rectA (w7)
  ;subtract top of rectB (w5)
  sec
  lda w7
  sbc w5
  lda w7+1
  sbc w5+1
  bpl :+
  ;clear zero flag
  lda #$ff
  rts
:

  ;compute bottom of rectangle B
  clc
  lda w5
  adc b5
  sta w9
  lda w5+1
  adc #0
  sta w9+1

  ;load top of rectA (w3)
  ;subtract bottom of rectB (w9)
  sec
  lda w3
  sbc w9
  lda w3+1
  sbc w9+1
  bmi :+
  ;clear zero flag
  lda #$ff
  rts
:

  ;compute right of rectangle A
  clc
  lda w2
  adc b2
  sta w6
  lda w2+1
  adc #0
  sta w6+1

  ;load right of rectA (w6)
  ;subtract left of rectB (w4)
  sec
  lda w6
  sbc w4
  lda w6+1
  sbc w4+1
  bpl :+
  ;clear zero flag
  lda #$ff
  rts
:

  ;compute right of rectangle B
  clc
  lda w4
  adc b4
  sta w8
  lda w4+1
  adc #0
  sta w8+1

  ;load left of rectA (w2)
  ;subtract right of rectB (w8)
  sec
  lda w2
  sbc w8
  lda w2+1
  sbc w8+1
  bmi :+
  lda #$ff
  rts
:

  ;set zero flag
  lda #0

  rts
.endproc

;tests one rectangle for whether it intersects another.
;rectangle A:
;w2 - top left x, y
;w3 - bot right x, y
;rectangle B:
;w4 - top left x, y
;w5 - bot right x, y
;outputs:
;Z - true = intersection, false = no intersection
.export geotests_rect_in_rect
.proc geotests_rect_in_rect
  ;load bottom of rectA
  lda w3+1
  sec
  ;subtract top of rectB
  sbc w4+1
  bpl :+
  ;clear zero flag
  lda #$ff
  rts
:
  ;load top of rectA
  lda w2+1
  sec
  ;subtract bottom of rectB
  sbc w5+1
  bmi :+
  ;clear zero flag
  lda #$ff
  rts
:
  ;load right of rectA
  lda w3
  sec
  ;subtract left of rectB
  sbc w4
  bpl :+
  ;clear zero flag
  lda #$ff
  rts
:
  ;load left of rectA
  lda w2
  sec
  ;subtract right of rectB
  sbc w5
  bmi :+
  lda #$ff
  rts
:

  ;set zero flag
  lda #0

  rts
.endproc

;a 1 dimensional intersection comparison
;line A:
;b2 - left x
;b3 - right x
;line B:
;b4 - left x
;b5 - right x
;Z - true = intersection, false = no intersection
.export geotests_compare_range
.proc geotests_compare_range

  ;if line A right x < line B left x (b4 - b3), test fails
  lda b4
  sec
  sbc b3
  bpl fail

  ;if line A left x > line B right X (b2 - b5), test fails
  lda b2
  sec
  sbc b5
  bpl fail

  ;set zero flag (success)
  lda #$00

  rts

fail:

  ;clear zero flag (failure)
  lda #$ff

  rts

.endproc

;// check if 2 rectangles intersect
;inline bool RectRectIntersection(const fRECT& rect1, const fRECT& rect2)
;{
;	if(rectA.bottom < rectB.top)		return false;
;	if(rectA.top > rectB.bottom)		return false;
;	if(rectA.right < rectB.left)		return false;
;	if(rectA.left > rectB.right)		return false;;;;;
;
;	return true;
;}



