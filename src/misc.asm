.include "zp.inc"
.include "miscdata.inc"

.segment "CODE"

;bankswitches using UnROM.
;b0 - the bank to switch to
.export bankswitch
.proc bankswitch
  txa
  pha

  ldx b0
  lda banktable,x        ;read a byte from the banktable
  sta banktable,x        ;and write it back, switching banks at $8000
  sta currentBank        ;store off the current bank
 
  pla
  tax 
  rts
.endproc
  
;Creates a decimal string based on a digit table and a power table
;and an input 8 bit value.
;Input:
; b0 - Value to create decimal string from
; w0 - Address of digit table
; w1 - Address of power table
; w2 - Address of destination buffer
;Output:
; w2 - Contains a string displayable by displayString
;Temporary:
; b1 - current power
; b2 - current digit
; b3 - index in dest buffer
; b4 - whether a nonzero digit has been encountered yet.
.export createDecimalString
.proc createDecimalString
 
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
.export displayString
.proc displayString
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
  
;loads 8k of chr data into VRAM starting at address $0000
;expects w0 to have address of chr data to load.
;uses w1 to count how much data has been shoveled
.export loadChr
.proc loadChr
  ;start at $0000 in VRAM
  lda #$00
  sta $2006
  sta $2006
  ;count from 0
  lda #0
  sta w1
  sta w1+1
  ldy #0
  
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
  ;count the data
  clc
  lda w1
  adc #1
  sta w1
  lda w1+1
  adc #0
  sta w1+1
  
  ;have we reached 8kb of data?
  cmp #$20
  bne loadChrLoop

  rts
.endproc
  
;loads a nametable and attribute table located at address in w0
;assumes VRAM points to the nametable that is to be loaded
.export loadNametable
.proc loadNametable
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
.export clearNametable
.proc clearNametable
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
  
;expects w0 to have address of palette
.export loadPalette
.proc loadPalette
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

.export loadPaletteBg
.proc loadPaletteBg
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

.export loadPaletteSpr
.proc loadPaletteSpr
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
