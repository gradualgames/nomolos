.importzp w0, w1, w2, w3, w4, w5

.export rectInRect

.segment "CODE"

;tests one rectangle for whether it intersects another.
;rectangle A:
;w2 - top left x, y
;w3 - bot right x, y
;rectangle B:
;w4 - top left x, y
;w5 - bot right x, y
;outputs:
;Z - true = intersection, false = no intersection
rectInRect:

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



  