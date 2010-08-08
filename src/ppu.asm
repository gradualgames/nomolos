.include "zp.inc"
.include "ram.inc"
.include "fixedBankData.inc"
.include "ppu.inc"

.segment "CODE"

;Creates a decimal string based on a digit table and a power table
;and an input 8 bit value.
;Input:
; b0 - Value to create decimal string from
; w0 - Address of digit table
; w1 - Address of power table
; w2 - Address of destination buffer
;Output:
; w2 - Contains a string displayable by ppu_display_string
;Temporary:
; b1 - current power
; b2 - current digit
; b3 - index in dest buffer
; b4 - whether a nonzero digit has been encountered yet.
.proc ppu_create_decimal_string
 
  ;digit count
  lda #0
  sta b5
 
  ;look at first power
  ldy #0
  
  ;dest buffer index is zero
  lda #1
  sta b3
 
  ;nonzero digit has not been encountered, so false
  lda #0
  sta b4
  
  lda b0
  bne skipSetEncounteredFlag
  lda #1
  sta b4
  ;look at last power because the input value is zero
  ldy #2
skipSetEncounteredFlag:
 
nextPower:
  
  ;load power from power table
  lda (w1),y
  sta b1
  
  ;our current digit starts at 0
  lda #0
  sta b2

  ;load input value
  lda b0
subtractPowerLoop:
  
  ;subtract current power
  sec
  sbc b1
  bmi doneWithCurrentPower
  
  ;we successfully subtracted the power (non negative result), so we increment our current digit.
  inc b2
  
  jmp subtractPowerLoop
  
doneWithCurrentPower:

  lda b2
  beq noNonZeroDigitsEncounteredYet
  ;we know a digit is nonzero so b4 should be true now
  lda #1
  sta b4
noNonZeroDigitsEncounteredYet:

  ;we want to know how many times we subtracted the current power. we know from b2. want to subtract
  ;b2 * current power from the original value. 
  lda b0
  ldx b2
  
removePowerLoop:
  cpx #0
  beq exitRemovePowerLoop
  sec
  sbc b1
  dex
  jmp removePowerLoop
exitRemovePowerLoop:
  sta b0

  ;store y
  tya
  pha
  
  lda b4
  ;as long as this is zero, we want to skip writing a digit to the dest. buffer.
  beq skipUpperZeroDigit
  
  ;look up current digit in digit table and store it in destination buffer
  
  ;load y with the current digit
  ldy b2
  ;load the tile number out of the digit table
  lda (w0),y
  ;store the tile number in the destination buffer
  ldy b3
  sta (w2),y
  ;move on to next digit
  inc b3
  
skipUpperZeroDigit:
  
  ;restore y
  pla
  tay
  
  ;move on to next power
  iny
  
  cpy #3
  bne nextPower
 
  ;(b3-1) is digit count. store this at the beginning of dest buffer.
  ldy #0
  dec b3
  lda b3
  sta (w2),y
 
  rts
  
.endproc
 
;assumes VRAM is already pointing to where the text should start
;assumes w0 contains address of string to draw
.proc ppu_display_string
  ;load number of characters in string
  ldy #0
  lda (w0),y
  tax
  iny
:
  ;load character
  lda (w0),y
  ;write it to nametable
  sta $2007
  iny

  dex
  bne :-

  rts
.endproc
  
;loads a specified amount of chr data into VRAM starting at the current VRAM location.
;expects w0 to contain the address of the chr data.
;uses w1 to contain the number of bytes to copy from this location.
.proc ppu_load_chr_amount

  ;save y
  tya
  pha

  ldy #0
  lda (w0),y
  sta w1
  iny
  lda (w0),y
  sta w1+1
  iny
  
loadChrLoop:
  ;load a byte from the chr data
  lda (w0),y
  ;stuff it into vram
  sta $2007
  ;move the address along
  clc
  lda w0
  adc #1
  sta w0
  lda w0+1
  adc #0
  sta w0+1
  ;decrement the count
  sec
  lda w1
  sbc #1
  sta w1
  lda w1+1
  sbc #0
  sta w1+1
  
  ;keep looping while either lo or hi byte of count is not zero.
  lda w1
  bne loadChrLoop
  lda w1+1
  bne loadChrLoop
  
  ;restore y
  pla
  tay

  rts

.endproc
  
;loads in a set of groups of chr data (usually used as a sprite sheet)
;expects w2 to contain the address of the chr group set.
;the group set consists of a count for the number of groups (up to 255)
;and then word addresses thereafter.
.proc ppu_load_chr_groups
group_set_address = w2
group_address = w0

  ;load the count
  ldy #0
  lda (group_set_address),y
  tax
  iny
  
load_group_loop:

  ;load the next chr group
  lda (group_set_address),y
  sta group_address
  iny
  lda (group_set_address),y
  sta group_address+1
  iny
  
  jsr ppu_load_chr_amount
  
  dex
  bne load_group_loop

  rts
.endproc

  
;loads a nametable and attribute table located at address in w0
;assumes VRAM points to the nametable that is to be loaded
.proc ppu_load_name_table
  ldy #$00
  ldx #$04

:
  lda (w0),y
  sta $2007
  iny
  bne :-
  inc w0+1
  dex
  bne :-

  rts
.endproc
  
;expects VRAM to already be pointing to the nametable we want to clear.
;input: b0 - value to clear nametable with
;       b1 - value to clear attribute table with
.proc ppu_clear_name_table
  ;clear the nametable
  lda #$20
  sta $2006
  lda #$00
  sta $2006
  
  ;clear nametable. First we write three groups of 256 tiles, then one group of 192,
  ;adding up to 960 total tiles in the nametable.
  ldy #3  
  lda b0
:
  ldx #0
: sta $2007
  dex
  bne :-
  dey 
  bne :--
  
  ;clear last 192 tiles of nametable.
  ldx #192
: sta $2007
  dex
  bne :-
  
  ;next write will be to attribute table, where there are 64 bytes.
  ;clear them all to 0.
  ldx #64
  lda b1
: sta $2007
  dex
  bne :-

  rts
.endproc
  
brightness_table:
  .byte $00, $00, $00, $00
  .byte $00, $10, $10, $10
  .byte $00, $10, $20, $20
  .byte $00, $10, $20, $30
  
.proc ppu_adjust_color_brightness
color = b0
color_brightness = b1
color_hue = b2
input_brightness = b3

  lda input_brightness
  beq return_black
  
  ;get current brightness of color
  lda color
  and #%00110000
  sta color_brightness
  
  ;get hue of color
  lda color
  and #%00001111
  sta color_hue
  
  cmp #$0e
  beq return_black
  cmp #$0f
  beq return_black
  
  ;use color's brightness and input brightness to index into brightness_table
  ;and produce the adjusted color
  lda color_brightness
  lsr
  lsr
  clc
  adc input_brightness
  tax
  ;subtract one because brightness will be 1 thru 4 and 0 means drop to black
  ;we want the values 0, 1, 2, 3 not 1 ,2 ,3 ,4
  dex
  lda brightness_table,x
  ora color_hue
  
  ;return adjusted color
  sta color

  rts

return_black:

  lda #$3f
  sta color

  rts
  
.endproc
  
;expects w0 to have address of palette to transfer to dynamic palette
;expects b3 to contain desired brightness level
.proc ppu_load_dynamic_palette_brightness

  ldy #$1f

: 
  ;load a color from the palette
  lda (w0),y

  ;adjust that color's brightness based on input (b3)
  sta b0
  jsr ppu_adjust_color_brightness
  lda b0
  ;store it to dynamic palette
  sta dynamic_palette,y

  dey
  bpl :-

  rts
.endproc
  
;expects w0 to have address of palette
.proc ppu_load_palette
  ldy #0
  lda #$3F
  sta $2006
  lda #$00
  sta $2006  
  ldx #$00
: lda (w0),y
  sta $2007
  inx
  iny
  cpx #$20
  bne :-
  rts
.endproc

.proc ppu_load_palette_bg
  ldy #0
  lda #$3F
  sta $2006
  lda #$00
  sta $2006  
  ldx #$00
: lda (w0),y
  sta $2007
  inx
  iny
  cpx #$10
  bne :-
  rts
.endproc

.proc ppu_load_palette_spr
  ldy #0
  lda #$3F
  sta $2006
  lda #$10
  sta $2006  
  ldx #$00
: lda (w0),y
  sta $2007
  inx
  iny
  cpx #$10
  bne :-
  rts
.endproc
