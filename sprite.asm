;global variables
.importzp b0, b1, w0, w1, w2
.importzp spriteAddress
.import sprite

;sprite manipulation interface
.export drawAnimation, updateAnimation, updateSprites, clearSprites

.segment "CODE"

;draws an animation
;w1: location of animation object
;w2: location of animation definition  
drawAnimation:
  ;get the current frame of this animation object
  ldy #1
  lda (w1),y
  asl
  tay
  iny
  ;load low byte of meta sprite address
  lda (w2),y
  sta w0
  iny
  ;load high byte of meta sprite address
  lda (w2),y
  sta w0+1
  ;display current frame
  jsr drawMetaSprite
  
  rts
  
;Updates a single animation. Assumes the animation at w1 has the following format:
;RAM stuff used:
;Temporary Parameters:
;w1: Location of animation object
;    assumes animation object is defined as:
;    .dsb frameCountDown
;    .dsb currentFrame
;w2: Location of animation definition
;    assumes animation definition is defined as:
;    .byte frameCountDownReset
;    .dw frameAddress
;    .dw frameAddress etc.
;    .byte $00
;Global Variables:
updateAnimation:

  ;get the frame count down of this animation object
  ldy #0
  lda (w1),y
  ;decrement the frame count down
  sec
  sbc #1
  sta (w1),y
  ;if the frame count down hasn't reached zero, skip the frame update code
  bne :+
  ;reset the frame count value
  ldy #0
  lda (w2),y
  sta (w1),y
  
  ;get the current frame number of this animation object
  iny
  lda (w1),y
  clc
  adc #1
  sta (w1),y
  asl
  tay
  iny
  lda (w2),y
  ;if the byte is zero, we must reset the frame counter
  bne :+
  lda #0
  ldy #1
  sta (w1),y
:
  rts
  

;       +-----------+-----------+-----+------------+
;       | Sprite #0 | Sprite #1 | ... | Sprite #63 |
;       +-+------+--+-----------+-----+------------+
;         |      |   
;         +------+----------+--------------------------------------+
;         + Byte | Bits     | Description                          |
;         +------+----------+--------------------------------------+
;         |  0   | YYYYYYYY | Y Coordinate - 1. Consider the coor- |
;         |      |          | dinate the upper-left corner of the  |
;         |      |          | sprite itself.                       |
;         |  1   | IIIIIIII | Tile Index #                         |
;         |  2   | vhp000cc | Attributes                           |
;         |      |          |   v = Vertical Flip   (1=Flip)       |
;         |      |          |   h = Horizontal Flip (1=Flip)       |
;         |      |          |   p = Background Priority            |
;         |      |          |         0 = In front                 |
;         |      |          |         1 = Behind                   |
;         |      |          |   c = Upper two (2) bits of colour   |
;         |  3   | XXXXXXXX | X Coordinate (upper-left corner)     |
;         +------+----------+--------------------------------------+

;Draws a single meta sprite into the sprite buffer
;RAM stuff used:
;Temporary Parameters:
;w0: the location of the meta sprite to draw
;b0: the x coordinate at which to draw the meta sprite
;b1: the y coordinate at which to draw the meta sprite
;Global Variables:
;spriteAddress: the current sprite that will be overwritten in the sprite buffer
drawMetaSprite:

  ;load the number of sprite entries
  ldy #0
  lda (w0), y
  ;multiply number of sprite entries * 4 bytes per entry
  asl
  asl
  tay
  ;y should now point to the last byte of the last sprite entry. we don't need to subtract 1 because of 
  ;the # of sprite entries byte.

  clc
  adc spriteAddress

  ;a now has spriteAddress + numberOfSpriteEntries * 4. put this in x for easy indexing into the sprite array
  tax

  ;move spriteAddress along so next call will put the next sprite later in the sprite buffer
  sta spriteAddress

  ;subtract one from x to point to the correct byte in the sprite array
  dex

:
  ;load the x coordinate of the current sprite entry
  lda (w0), y
  clc
  ;compute final x coordinate
  adc b0
  ;store x coordinate in the sprite array
  sta sprite, x

  ;decrement our indices
  dex
  dey

  ;load the attribute value of the current sprite entry
  lda (w0), y
  sta sprite, x

  ;decrement our indices
  dex
  dey

  ;load the tile value of the current sprite entry
  lda (w0), y
  sta sprite, x

  ;decrement our indices
  dex
  dey

  ;load the y coordinate value of the current sprite entry
  lda (w0), y
  clc
  ;compute final y coordinate
  adc b1
  ;store y coordinate in the sprite array
  sta sprite, x

  ;decrement our indices
  dex
  dey
  bne :-

  rts

updateSprites:
  lda #>(sprite)
  sta $4014    ; Jam page $200-$2FF into SPR-RAM
  rts

clearSprites:
  lda #$ff
  ldx #$00
: sta sprite, x
  inx
  bne :-
  rts
