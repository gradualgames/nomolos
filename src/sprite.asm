.include "zp.inc"
.include "ram.inc"
.include "sprite.inc"

.segment "CODE"

;should be called at start of program
.proc sprite_module_init

  lda #0
  sta next_sprite_address

  rts

.endproc

;draws an animation and expects to be passed parameters that sprite_draw_metasprite_16bit will use also
;w1: location of animation object
;w2: location of animation definition
.proc sprite_draw_animation_16bit
  ;get the current frame of this animation object
  ldy #animation::currentFrame
  lda (w1),y
  ;check if animation is in start state, load frame 0 if so.
  cmp #$ff
  bne :+
  lda #0
:
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
  jsr sprite_draw_metasprite_16bit

  rts
.endproc

;draws an animation
;w1: location of animation object
;w2: location of animation definition
.proc sprite_draw_animation_8bit
  ;get the current frame of this animation object
  ldy #animation::currentFrame
  lda (w1),y
  ;check if animation is in start state, load frame 0 if so.
  cmp #$ff
  bne :+
  lda #0
:
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
  jsr sprite_draw_metasprite_8bit

  rts
.endproc

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
.proc sprite_update_animation
  ;get the frame count down of this animation object
  ldy #animation::frameCountDown
  lda (w1),y
  ;decrement the frame count down
  sec
  sbc #1
  sta (w1),y
  ;if the frame count down hasn't reached zero, skip the frame update code
  bne skipFrameUpdate
  ;reset the frame count value
  ldy #animation::frameCountDown
  lda (w2),y
  sta (w1),y

  ;get the current frame number of this animation object
  ldy #animation::currentFrame
  lda (w1),y
  clc
  adc #1
  sta (w1),y
  asl
  tay
  ;move to second byte for end-of-animation marker. The high byte of meta sprite
  ;addresses can never be zero---this is why we do this. If we checked the first
  ;of two bytes, we could accidentally find zero in a meta sprite address and
  ;think this is the end of the animation!
  iny
  iny
  lda (w2),y
  ;if the byte is zero, we must reset the frame counter
  bne skipFrameUpdate
  lda #0
  ldy #animation::currentFrame
  sta (w1),y
skipFrameUpdate:
  rts
.endproc

;Draws a meta sprite at 16 bit screen X and Y. Also, it will
;clip individual sprites if they are off of the screen.
;Temporary Parameters:
;w0: the location of the meta sprite to draw
;w3: the 16 bit x coordinate at which to draw the sprite
;w4: the 16 bit y coordinate at which to draw the sprite
;b2: extra bits to OR into the sprite attribute
;    (presumably %01000000 to flip horiz)
;b5: tile group offset. All tile offsets within meta sprites are relative to this value.
;Global Variables:
;next_sprite_address: the current sprite that will be overwritten in the sprite buffer
;b3: temporarily stores how many sprite entries are in the currently drawing meta sprite
;b4: temporarily stores x offset
;w5: temporarily stores whether the x coordinate (low byte) and y coordinate (high byte)
; are onscreen.
.proc sprite_draw_metasprite_16bit

  ;save regs
  txa
  pha

  ;****************************************************************************
  ;test the high byte of the x coordinate for onscreen or offscreen
  ;****************************************************************************
  lda w3+1
  beq xOnScreen
  bpl xOffScreenPositive
  bmi xOffScreenNegative

xOnScreen:
  lda #$01
  sta w5
  jmp xHighByteTestDone

xOffScreenPositive:

  ;we already know the x coordinate is positive. But if it is not 1 (the screen immediately
  ;out of view), it is much too far away to be visible. Exit the routine if so.

  cmp #$01
  beq @xCoordinateNotTooFar

  ;restore regs and return from routine; we know the sprite is too far off the screen to consider.
  pla
  tax
  rts

@xCoordinateNotTooFar:

  ;x is off the screen but not too far that the sprite might not be visible
  lda #$00
  sta w5
  jmp xHighByteTestDone

xOffScreenNegative:

  ;we already know the x coordinate is negative. But if it is not -1 (the screen immediately
  ;out of view), it is much too far away to be visible. Exit the routine if so.

  cmp #$ff
  beq @xCoordinateNotTooFar

  ;restore regs and return from routine; we know the sprite is too far off the screen to consider.
  pla
  tax
  rts

@xCoordinateNotTooFar:

  ;x is off screen but not too far that the sprite might not be visible
  lda #$00
  sta w5

xHighByteTestDone:

  ;****************************************************************************
  ;test the high byte of the y coordinate for onscreen or offscreen
  ;****************************************************************************
  lda w4+1
  beq yOnScreen
  bpl yOffScreenPositive
  bmi yOffScreenNegative

yOnScreen:
  lda #$01
  sta w5+1
  jmp yHighByteTestDone

yOffScreenPositive:

  ;we already know the y coordinate is positive. But if it is not 1 (the screen immediately
  ;out of view), it is much too far away to be visible. Exit the routine if so.

  cmp #$01
  beq @yCoordinateNotTooFar

  ;restore regs and return from routine; we know the sprite is too far off the screen to consider.
  pla
  tax
  rts

@yCoordinateNotTooFar:

  ;test the low byte of the y coordinate, make sure it is positive. if it is negative the sprite
  ;is too far away.
  lda w4
  bpl @yCoordinateNotTooFar2

  ;restore regs and return from routine; we know the sprite is too far off the screen to consider.
  pla
  tax
  rts

@yCoordinateNotTooFar2:


  ;y is off the screen but not too far that the sprite might not be visible
  lda #$00
  sta w5+1
  jmp yHighByteTestDone

yOffScreenNegative:

  ;we already know the y coordinate is negative. But if it is not -1 (the screen immediately
  ;out of view), it is much too far away to be visible. Exit the routine if so.

  cmp #$ff
  beq @yCoordinateNotTooFar

  ;restore regs and return from routine; we know the sprite is too far off the screen to consider.
  pla
  tax
  rts

@yCoordinateNotTooFar:

  ;y is off screen but not too far that the sprite might not be visible
  lda #$00
  sta w5+1

yHighByteTestDone:

  ;at this point, w5 knows whether the x coordinate and y coordinates are on or off screen.
  ;now we will start rendering the sprite, and each time we add an offset we will compute whether
  ;it is on or offscreen.

  ;load the number of sprite entries
  ldy #0
  lda (w0),y
  sta b3

  ;we want to start writing to the sprite buffer at next_sprite_address
  ldx next_sprite_address

  ;point to the first sprite entry, this is the y coordinate
  iny

;sprite entry loop
nextSpriteEntry:

  ;save the "onscreen" flags for x and y
  lda w5
  pha
  lda w5+1
  pha

  ;****************************************************************************
  ;Load the Y coordinate offset, add it to low byte of input Y coordinate,
  ;test for wraparound.
  ;****************************************************************************

  ;load the y coordinate offset
  lda (w0),y
  ;test the sign
  bmi testNegativeWraparoundY
testPositiveWraparoundY:

  ;add the low byte of the y coordinate
  clc
  adc w4
  bcc wrapAroundTestDoneY
  ;carry was set, there was positive wraparound
  ;negate the onscreen flag for the y coordinate
  pha
  lda w5+1
  eor #$01
  sta w5+1
  pla

  jmp wrapAroundTestDoneY
testNegativeWraparoundY:

  ;add the low byte of the y coordinate, known to be negative
  sec
  adc w4
  bcs wrapAroundTestDoneY
  ;carry was clear, there was negative wraparound
  ;negate the onscreen flag for the y coordinate
  pha
  lda w5+1
  eor #$01
  sta w5+1
  pla

wrapAroundTestDoneY:

  ;temporarily store the calculated y coordinate in the sprite, we
  ;will determine if it is onscreen and clip it later
  sta sprite+spriteStruct::ycoord,x

  ;****************************************************************************
  ;Load Tile number of sprite
  ;****************************************************************************

  ;move on to the tile number
  iny

  ;copy the tile number into the sprite
  clc
  lda (w0),y
  ;add the grouping offset
  adc sprite_group_offset
  sta sprite+spriteStruct::tile,x

  ;****************************************************************************
  ;Load Attribute of sprite
  ;****************************************************************************

  ;move on to the attribute
  iny
  ;copy it over but OR in b2
  lda (w0),y
  eor b2
  sta sprite+spriteStruct::attribute,x

  ;****************************************************************************
  ;Load flipped or non flipped x offset
  ;****************************************************************************

  ;test to see if sprite is flipped.
  bit b2
  bvs @spriteIsFlipped

  ;point to the non flipped x offset
  iny
  lda (w0),y
  sta b4
  jmp spriteNotFlipped

@spriteIsFlipped:

  ;point to the flipped x offset
  iny
  iny
  lda (w0),y
  sta b4
  ;step y back so we can advance to the next entry in a uniform way
  dey

spriteNotFlipped:

  ;****************************************************************************
  ;Load the X coordinate offset, add it to low byte of input X coordinate,
  ;test for wraparound.
  ;****************************************************************************

  ;at this point we've loaded the x offset
  ;test the sign
  lda b4
  bmi testNegativeWraparoundX
testPositiveWraparoundX:

  ;add the low byte of the x coordinate
  clc
  adc w3
  bcc wrapAroundTestDoneX
  ;carry was set, there was positive wraparound
  ;negate the onscreen flag for the x coordinate
  pha
  lda w5
  eor #$01
  sta w5
  pla

  jmp wrapAroundTestDoneX
testNegativeWraparoundX:

  ;add the low byte of the x coordinate, known to be negative
  clc
  adc w3
  bcs wrapAroundTestDoneX
  ;carry was clear, there was negative wraparound
  ;negate the onscreen flag for the x coordinate
  pha
  lda w5
  eor #$01
  sta w5
  pla

wrapAroundTestDoneX:

  ;temporarily store the calculated x coordinate in the sprite, we
  ;will determine if it is onscreen and clip it later
  sta sprite+spriteStruct::xcoord,x

  ;****************************************************************************
  ;Load the two "onscreen" flags, and them together to see if sprite should be
  ;clipped or not
  ;****************************************************************************
  lda w5
  and w5+1
  bne @spriteOnScreen

  ;clip the sprite by setting both of its coordinates to the invisible coordinate
  lda #$ff
  sta sprite+spriteStruct::ycoord,x
  sta sprite+spriteStruct::xcoord,x

@spriteOnScreen:

  ;move on to the next sprite entry
  iny
  iny

  ;restore the "onscreen" flags for x and y
  pla
  sta w5+1
  pla
  sta w5

  ;move on to next sprite entry
  inx
  inx
  inx
  inx

  dec b3
  beq skipNextSpriteEntry
  jmp nextSpriteEntry
skipNextSpriteEntry:

  ;set next_sprite_address to current value of x, this is the next sprite
  stx next_sprite_address

  ;restore regs
  pla
  tax

  rts
.endproc

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
;b2: extra bits to OR into the sprite attributes
;    (presumably %01000000 to flip horiz)
;Global Variables:
;next_sprite_address: the current sprite that will be overwritten in the sprite buffer
;b3: temporarily stores how many sprite entries are in the currently drawing meta sprite
.proc sprite_draw_metasprite_8bit
  ;save regs
  txa
  pha

  ;load the number of sprite entries
  ldy #0
  lda (w0),y
  sta b3

  ;we want to start writing to the sprite buffer at next_sprite_address
  ldx next_sprite_address

  ;point to the first sprite entry, this is the y coordinate
  iny

nextSpriteEntry:

  ;load the y coordinate from the meta sprite
  lda (w0),y
  ;add the y coordinate parameter
  clc
  adc b1
  sta sprite, x

  ;point to the tile index
  iny
  inx
  ;copy it over
  lda (w0),y
  sta sprite, x

  ;point to the sprite attribute
  iny
  inx
  ;copy it over but OR in b2
  lda (w0),y
  ora b2
  sta sprite,x

  ;test to see if sprite is flipped.
  bit b2
  bvs @spriteIsFlipped

  ;point to the non flipped x coordinate
  iny
  lda (w0),y
  jmp spriteNotFlipped

@spriteIsFlipped:

  ;point to the flipped x coordinate
  iny
  iny
  lda (w0),y
  ;step y back so we can advance to the next entry in a uniform way
  dey

spriteNotFlipped:

  ;add the x coordinate paramter
  clc
  adc b0

  ;store result in sprite
  inx
  sta sprite,x

  ;point to the next sprite entry
  iny
  iny
  inx

  ;decrement the sprite entry counter
  dec b3
  bne nextSpriteEntry

  txa
  sta next_sprite_address

  ;restore regs
  pla
  tax

  rts
.endproc

.proc sprite_update_all
  lda #>(sprite)
  sta $4014    ; Jam page $200-$2FF into SPR-RAM
  rts
.endproc

.proc sprite_clear_all
  lda #$ff
  ldx #$00
: sta sprite, x
  inx
  bne :-
  rts
.endproc
