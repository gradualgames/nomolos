.include "zp.inc"

.segment "CODE"

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
.export rectInRect16
.proc rectInRect16
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
.export rectInRect
.proc rectInRect
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



  