;File: nomolos_scrolling.asm
;Author: Derek Andrews

;    +--------+------+------------------------------------------+
;    | Offset | Size | Content(s)                               |
;    +--------+------+------------------------------------------+
;    |   0    |  3   | 'NES'                                    |
;    |   3    |  1   | $1A                                      |
;    |   4    |  1   | 16K PRG-ROM page count                   |
;    |   5    |  1   | 8K CHR-ROM page count                    |
;    |   6    |  1   | ROM Control Byte #1                      |
;    |        |      |   %####vTsM                              |
;    |        |      |    |  ||||+- 0=Horizontal mirroring      |
;    |        |      |    |  ||||   1=Vertical mirroring        |
;    |        |      |    |  |||+-- 1=SRAM enabled              |
;    |        |      |    |  ||+--- 1=512-byte trainer present  |
;    |        |      |    |  |+---- 1=Four-screen mirroring     |
;    |        |      |    |  |                                  |
;    |        |      |    +--+----- Mapper # (lower 4-bits)     |
;    |   7    |  1   | ROM Control Byte #2                      |
;    |        |      |   %####0000                              |
;    |        |      |    |  |                                  |
;    |        |      |    +--+----- Mapper # (upper 4-bits)     |
;    |  8-15  |  8   | $00                                      |
;    | 16-..  |      | Actual 16K PRG-ROM pages (in linear      |
;    |  ...   |      | order). If a trainer exists, it precedes |
;    |  ...   |      | the first PRG-ROM page.                  |
;    | ..-EOF |      | CHR-ROM pages (in ascending order).      |
;    +--------+------+------------------------------------------+

.byte "NES",$1a        ;iNES header
.byte $02 ;            ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $01 ;            ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
.byte $01 ;            ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #0 (NROM)
.byte $00 ;            ;Rest of Mapper #2 bits (all 0)
.byte 0,0,0,0,0,0,0,0  ; pad header to 16 bytes

  .base $0000

  .enum $0000
lobyte:      .dsb 1
hibyte:      .dsb 1
buttonA:     .dsb 1
vblankdone:  .dsb 1
countDown:   .dsb 1
b0:       .dsb 1
b1:       .dsb 1
b2:       .dsb 1
b3:       .dsb 1
b4:       .dsb 1
b5:       .dsb 1
w0:       .dsw 1
w1:       .dsw 1
w2:       .dsw 1
w3:       .dsw 1
w4:       .dsw 1
w5:       .dsw 1

update:     .dsw 1
updatePPU:  .dsw 1

CurrentColumnX:         .dsw 1
ColumnOutsideOfWindowX:   .dsw 1
ColumnOutsideOfWindow:    .dsb 1
ColumnAddressInWorld:   .dsw 1
CurrentWorldPage        .dsb 1

ScrollX:            .dsw 1
ScrollIncrement:    .dsb 1
LevelBaseAddress:   .dsw 1
LevelPages:         .dsb 1

AttributeBuffer: .dsb 8
AttributeColumnToUpdate: .dsb 1

ColumnTileBuffer: .dsb 60
MetaMetaTileAddress: .dsw 1
MetaTileBuffer: .dsb 4
ColumnToUpdate: .dsb 1
NametableToUpdate: .dsb 1

  .enum $0200
sprite: .dsb 256
  .ende

  .base $8000

palette:

;Image Palette
  .db $11,$15,$12,$03,$11,$19,$1a,$07,$00,$00,$00,$00,$00,$00,$00,$00

;Sprite Palette
  .db $21,$3f,$27,$2a,$21,$3f,$17,$28,$00,$00,$00,$00,$00,$00,$00,$00

MetaTileTable:
MetaTile0:
  .db $01,$00,$00,$00,$00,$00,$00,$00
MetaTile1:
  .db $00,$00,$01,$01,$02,$02,$00,$00
MetaTile2:
  .db $01,$00,$03,$01,$02,$02,$00,$00
MetaTile3:
  .db $01,$00,$01,$01,$02,$02,$00,$00
MetaTile4:
  .db $01,$00,$01,$04,$02,$02,$00,$00
MetaMetaTileTable:
MetaMetaTile0:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile1:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$03,$00
MetaMetaTile2:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$03,$00
MetaMetaTile3:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$03,$00
MetaMetaTile4:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$03,$00
MetaMetaTile5:
  .db $00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile6:
  .db $00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile7:
  .db $00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile8:
  .db $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile9:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile10:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$03,$00
MetaMetaTile11:
  .db $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile12:
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,$03,$00
MetaMetaTile13:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$03,$00
MetaMetaTile14:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$03,$00,$03,$00,$03,$00
MetaMetaTile15:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$04,$00,$03,$00
MetaMetaTile16:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$03,$00
MetaMetaTile17:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$03,$00
MetaMetaTile18:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$03,$00
MetaMetaTile19:
  .db $00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile20:
  .db $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile21:
  .db $00,$00,$00,$00,$01,$00,$01,$01,$01,$01,$01,$00,$00,$00,$03,$00
MetaMetaTile22:
  .db $00,$00,$03,$03,$03,$03,$03,$03,$03,$00,$03,$00,$00,$00,$03,$00
MetaMetaTile23:
  .db $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile24:
  .db $00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile25:
  .db $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$03,$00
MetaMetaTile26:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$03,$00
MetaMetaTile27:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$03,$00
MetaMetaTile28:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$03,$00
MetaMetaTile29:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$03,$00
MetaMetaTile30:
  .db $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$03,$00
MetaMetaTile31:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$03,$00
Level:
  .db $00,$00,$00,$00,$00,$00,$00,$01,$02,$02,$02,$02,$03,$00,$00,$04,$04,$04,$04,$04,$00,$00,$05,$06,$07,$08,$09,$0a,$00,$00,$05,$06
  .db $06,$0b,$00,$00,$0c,$00,$00,$0d,$0e,$0e,$0f,$00,$00,$10,$11,$11,$12,$00,$00,$00,$13,$14,$14,$14,$13,$00,$00,$00,$15,$00,$00,$16
  .db $00,$00,$00,$00,$17,$18,$18,$18,$18,$19,$00,$00,$1a,$09,$09,$09,$09,$09,$0a,$00,$17,$18,$18,$18,$18,$18,$19,$00,$00,$1b,$1b,$1b
  .db $1b,$1b,$1b,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1c,$1d,$1e,$1f,$1f,$1e,$1d,$1c,$00,$00

  .pad $C000

reset:
  sei    ; disable IRQs
  cld    ; disable decimal mode
  ldx #$FF
  txs    ; Set up stack
  inx    ; now X = 0
  stx $2001    ; disable rendering

-       ; First wait for vblank to make sure PPU is ready
  bit $2002
  bpl -
-       ; Second wait for vblank, PPU is ready after this
  bit $2002
  bpl -

clrmem:
  lda #$00
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne clrmem

  jsr loadpalette

  lda #<Level
  sta LevelBaseAddress
  lda #>Level
  sta LevelBaseAddress+1

  lda #$00
  sta ScrollX
  lda #$00
  sta ScrollX+1
  lda #$00
  sta ColumnToUpdate
  lda #$0A
  sta countDown

 ; Set basic PPU registers.  Load background from $0000,
	; sprites from $1000, and the name table from $2000.

;    +---------+----------------------------------------------------------+
;    | Address | Description                                              |
;    +---------+----------------------------------------------------------+
;    |  $2000  | PPU Control Register #1 (W)                              |
;    |         |                                                          |
;    |         |    D7: Execute NMI on VBlank                             |
;    |         |           0 = Disabled                                   |
;    |         |           1 = Enabled                                    |
;    |         |    D6: PPU Master/Slave Selection --+                    |
;    |         |           0 = Master                +-- UNUSED           |
;    |         |           1 = Slave               --+                    |
;    |         |    D5: Sprite Size                                       |
;    |         |           0 = 8x8                                        |
;    |         |           1 = 8x16                                       |
;    |         |    D4: Background Pattern Table Address                  |
;    |         |           0 = $0000 (VRAM)                               |
;    |         |           1 = $1000 (VRAM)                               |
;    |         |    D3: Sprite Pattern Table Address                      |
;    |         |           0 = $0000 (VRAM)                               |
;    |         |           1 = $1000 (VRAM)                               |
;    |         |    D2: PPU Address Increment                             |
;    |         |           0 = Increment by 1                             |
;    |         |           1 = Increment by 32                            |
;    |         | D1-D0: Name Table Address                                |
;    |         |         00 = $2000 (VRAM)                                |
;    |         |         01 = $2400 (VRAM)                                |
;    |         |         10 = $2800 (VRAM)                                |
;    |         |         11 = $2C00 (VRAM)                                |
;    +---------+----------------------------------------------------------+
;       76543210
  lda #%10001100
  sta $2000

;    +---------+----------------------------------------------------------+
;    |  $2001  | PPU Control Register #2 (W)                              |
;    |         |                                                          |
;    |         | D7-D5: Full Background Colour (when D0 == 1)             |
;    |         |         000 = None  +------------+                       |
;    |         |         001 = Green              | NOTE: Do not use more |
;    |         |         010 = Blue               |       than one type   |
;    |         |         100 = Red   +------------+                       |
;    |         | D7-D5: Colour Intensity (when D0 == 0)                   |
;    |         |         000 = None            +--+                       |
;    |         |         001 = Intensify green    | NOTE: Do not use more |
;    |         |         010 = Intensify blue     |       than one type   |
;    |         |         100 = Intensify red   +--+                       |
;    |         |    D4: Sprite Visibility                                 |
;    |         |           0 = Sprites not displayed                      |
;    |         |           1 = Sprites visible                            |
;    |         |    D3: Background Visibility                             |
;    |         |           0 = Background not displayed                   |
;    |         |           1 = Background visible                         |
;    |         |    D2: Sprite Clipping                                   |
;    |         |           0 = Sprites invisible in left 8-pixel column   |
;    |         |           1 = No clipping                                |
;    |         |    D1: Background Clipping                               |
;    |         |           0 = BG invisible in left 8-pixel column        |
;    |         |           1 = No clipping                                |
;    |         |    D0: Display Type                                      |
;    |         |           0 = Colour display                             |
;    |         |           1 = Monochrome display                         |
;    +---------+----------------------------------------------------------+
;       76543210
  lda #%00011110
  sta $2001

;set load level state.
  lda #<loadLevelUpdate
  sta update
  lda #>loadLevelUpdate
  sta update+1
  lda #<loadLevelUpdatePPU
  sta updatePPU
  lda #>loadLevelUpdatePPU
  sta updatePPU+1

loop:

  ;wait for vblank to complete
  lda #0
  sta vblankdone
- lda vblankdone
  beq -

  jmp (update)

updateFinished:

;the following loops are used to measure how much time we have left in the main loop.
;  ldy #16       ;2
;--
;  ldx #$ff      ;2
;-
;  dex           ;2 * 255
;  bne -         ;3 * 255 + 2
;  dey           ;2 * 16
;  bne --        ;3 * 16 + 2

  jmp loop

playLevelUpdate:

  jsr getInput
  jsr decodeMap

  jmp updateFinished

loadLevelUpdate:

  lda #$20
  sta NametableToUpdate

  lda ColumnToUpdate
  lsr
  tay
  lda (LevelBaseAddress),y

  ;store the meta meta tile index as a 16 bit number
  sta MetaMetaTileAddress
  lda #0
  sta MetaMetaTileAddress+1

  ;shift left this number by 4
  ldx #4
-
  asl MetaMetaTileAddress
  rol MetaMetaTileAddress+1
  dex
  bne -

  ;now add MetaMetaTileTable to this number
  clc
	lda MetaMetaTileAddress
	adc #<MetaMetaTileTable
	sta MetaMetaTileAddress
	lda MetaMetaTileAddress+1
	adc #>MetaMetaTileTable
	sta MetaMetaTileAddress+1

  lda ColumnToUpdate
  jsr updateColumn

  lda countDown
  beq ++
  dec countDown
  bne +
++

  inc ColumnToUpdate
  inc ColumnToUpdate

  lda ColumnToUpdate
  cmp #30
  bne +
  lda #<playLevelUpdate
  sta update
  lda #>playLevelUpdate
  sta update+1
  lda #<playLevelUpdatePPU
  sta updatePPU
  lda #>playLevelUpdatePPU
  sta updatePPU+1
+

  jmp updateFinished

loadpalette:
  lda #$3F
  ldx #$00
  sta $2006
  stx $2006
- lda palette,x
  sta $2007
  inx
  cpx #$20
  bne -
  rts

getInput:

  lda #$01  ; strobe joypad
  sta $4016
  lda #$00
  sta $4016

  lda $4016  ; Is the A button down?
  lda $4016  ; B does nothing
  lda $4016          ; Select does nothing
  lda $4016          ; Start does nothing
  lda $4016          ; Up
  lda $4016          ; Down
  lda $4016          ; Left

  lda $4016          ; Right

  ;is right button down?
  and #1
  beq ++
  ;yes
  lda ScrollX
  clc
  adc #2
  bcc +
  inc ScrollX+1
+
  sta ScrollX
++

  rts

decodeMap:

;Load the current scroll value. Shifting this 16 bit value right by 4 will produce the correct column number for the leftmost
;column on the screen.

  lda ScrollX
  sta w0
  lda ScrollX+1
  sta w0+1

;the upper byte + 1 will cause the lowest bit of the upper byte to designate the nametable to which the column should be drawn.
;this is because the upper byte = multiples of 256 pixels, so upper byte + 1 = next chunk of 256 pixels, or next nametable.
  clc
  adc #$01  ;add one to the upper byte
  and #$01  ;grab just the lowest bit
  asl
  asl
  ora #$20
  sta NametableToUpdate

  ldx #4
-
  lsr w0+1
  ror w0
  dex
  bne -

;At this point we should have the correct column for the leftmost column on the screen stored in w0.
;Add 16 to this number and we will have the column we wish to decode.
  lda w0
  clc
  adc #$10
  sta w0
  bcc +
  inc w0+1
+

;now that we have the correct column, figure out what it is in "tile columns" for the PPU routine.
;load the column number
  lda w0
;multiply it by two, this is the tile column
  asl
;make sure it is from 0 to 31
  and #$1f
  sta ColumnToUpdate


;w0 now has the column number we wish to decode.
;The upper byte now has the map offset * 256, and the lower byte has the offset into the map data from that point.
;LevelBaseAddress points to the current level. So load that address into w1, and add w0 to w1.

  lda LevelBaseAddress
  sta w1
  lda LevelBaseAddress+1
  sta w1+1

  clc		    ; Clear the carry flag
	lda w0  	; Load little end of number 1 into accumulator register
	adc w1  	; Add with carry the little end of number 2
	sta w1  	; Store the little end of the result
	lda w0+1	; Load big end of number 1 into accumulator
	adc w1+1	; Add with carry the big end of number 2
	sta w1+1	; Store the big end of the result

;at this point, w1 should now have the correct offset into the level.

  ldy #0
;Load the value at the map offset value just calculated.
  lda (w1), y
;we should now have a value from the map itself.

;Use this offset to figure out which meta meta tile to look at. In other words, load it into the low byte of a word,
;then shift left the word by 4 to get the correct meta meta tile address.

;store the meta meta tile offset
  sta w0
  lda #0
  sta w0+1

;now shift left w0 by 4.
  ldx #4
-
  asl w0
  rol w0+1
  dex
  bne -

  lda #<MetaMetaTileTable
  sta w1
  lda #>MetaMetaTileTable
  sta w1+1

  clc		    ; Clear the carry flag
	lda w0  	; Load little end of number 1 into accumulator register
	adc w1  	; Add with carry the little end of number 2
	sta w1  	; Store the little end of the result
	lda w0+1	; Load big end of number 1 into accumulator
	adc w1+1	; Add with carry the big end of number 2
	sta w1+1	; Store the big end of the result

  ;at this point, w1 should have the meta meta tile address
  lda w1
  sta MetaMetaTileAddress
  lda w1+1
  sta MetaMetaTileAddress+1

;Load the meta meta tile address, and call the updateColumn routine to get that meta tile into the PPU buffers.
  jsr updateColumn

  rts

;This routine decodes a single 1x15 meta-meta tile and places the proper
;name table tile numbers into two 30 byte buffers for use by updateColumnPPU
;MetaMetaTileAddress: address of meta-meta tile to decode
;ColumnTileBuffer: the buffer to which the meta-meta tile will be decoded. It will consist of
;two 30 tile columns.
updateColumn:

;we need to calculate what the AttributeColumnToUpdate is.
;we know the ColumnToUpdate. that's 0-31.
;if we shift this right, we get the meta tile column.
;if we shift this right again, we get the attribute column to update.
  lda ColumnToUpdate
  lsr
  sta b2
  lsr
  sta AttributeColumnToUpdate

  ldy #0
  ldx #15
-
  ;save y, we need it for indirect addressing again
  tya
  pha
  sta b3 ;store the metatile row
  lsr ;get the correct attribute row
  sta b0

  ;indirectly load the meta tile number
  lda (MetaMetaTileAddress),y

  asl
  asl
  asl
  ;use this offset as an index
  tay

  ;y has the index of the attribute field
  lda MetaTileTable, y
  ;now a has the attribute to write

  sta b1

  jsr updateAttribute

  iny
  ;let's not bother with the solid flag for now
  iny
  ;load the top left
  lda MetaTileTable, y
  sta MetaTileBuffer
  ;load the top right
  lda MetaTileTable+1, y
  sta MetaTileBuffer+1
  ;load the bottm left tile
  lda MetaTileTable+2, y
  sta MetaTileBuffer+2
  ;load the bottom right tile
  lda MetaTileTable+3, y
  sta MetaTileBuffer+3

  ;figure out an offset into the column buffer
  ;restore y but save it again
  pla
  tay
  pha

  ;multiply current index by 2, this is the offset into the column buffer
  asl a
  tay

  ;now y should have the offset into the column buffer
  ;load the top left tile
  lda MetaTileBuffer
  ;store it in left column
  sta ColumnTileBuffer, y
  ;load the top right tile
  lda MetaTileBuffer+1
  ;store it in the right column
  sta ColumnTileBuffer+30, y
  ;load the bottom left tile
  lda MetaTileBuffer+2
  ;store it in the left column
  sta ColumnTileBuffer+1, y
  ;load the bottom right tile
  lda MetaTileBuffer+3
  ;store it in the right column
  sta ColumnTileBuffer+31, y

  pla
  tay
  iny
  dex
  bne -

  rts

;This routine updates a single attribute value in the attribute buffer.
;b0: The attribute row to update.
;b1: The attribute value we want to put into the attribute.
;b2: The current metatile column.
;b3: The current metatile row.
updateAttribute:
  ;pha
  tya
  pha
  txa
  pha

  lda b3   ;get the metatile row.
  and #$01 ;keep the lowest bit
  beq rowBitWasZero

  ;do the column test
  lda b2
  and #$01
  beq +
  ;row bit 1, column bit 1
  lda #%00111111
  sta b5
  ror b1
  ror b1
  ror b1
  jmp gotMask
+
  ;row bit 1, column bit 0
  lda #%11001111
  sta b5
  ror b1
  ror b1
  ror b1
  ror b1
  ror b1
  jmp gotMask


rowBitWasZero:

  ;do the column test
  lda b2
  and #$01
  beq +
  ;row bit 0, column bit 1
  lda #%11110011
  sta b5
  rol b1
  rol b1
  jmp gotMask
+
  ;row bit 0, column bit 0
  lda #%11111100
  sta b5
  jmp gotMask


gotMask:

  ldy b0
  lda AttributeBuffer, y
  and b5
  ora b1
  sta AttributeBuffer, y

  pla
  tax
  pla
  tay
  ;pla

  rts

vblank:

  pha
  txa
  pha
  tya
  pha
  php

  jmp (updatePPU)

updatePPUFinished:

  lda #1
  sta vblankdone

  plp
  pla
  tay
  pla
  tax
  pla

irq:
  rti

playLevelUpdatePPU:
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU
  jmp updatePPUFinished
loadLevelUpdatePPU:
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU       
  jmp updatePPUFinished

updateScrollPPU:

  lda NametableToUpdate
  eor #$04
  sta $2006
  lda #$00
  sta $2006

  lda ScrollX
  sta $2005
  lda #0
  sta $2005

  rts

;dumps two columns of tiles to the PPU
;ColumnTileBuffer: the buffer containing both columns of tiles to write
;ColumnToUpdate: the column to update
updateColumnPPU:

  lda NametableToUpdate
  sta $2006
  lda ColumnToUpdate
  sta $2006

  ldy #0
  ldx #30
-
  lda ColumnTileBuffer, y
  sta $2007

  iny
  dex
  bne -

  lda NametableToUpdate
  sta $2006
  lda ColumnToUpdate
  clc
  adc #1
  sta $2006

  ldy #0
  ldx #30
-
  lda ColumnTileBuffer+30, y
  sta $2007

  iny
  dex
  bne -

  rts

updateAttributePPU:

;
  lda NametableToUpdate
  ora #$03
  sta $2006
  lda #%11000000
  ora AttributeColumnToUpdate
  sta $2006

  lda AttributeBuffer
  sta $2007
  lda AttributeBuffer+4
  sta $2007

;
  lda NametableToUpdate
  ora #$03
  sta $2006
  lda #%11000000
  ora AttributeColumnToUpdate
  ora #$08
  sta $2006

  lda AttributeBuffer+1
  sta $2007
  lda AttributeBuffer+5
  sta $2007

;
  lda NametableToUpdate
  ora #$03
  sta $2006
  lda #%11000000
  ora AttributeColumnToUpdate
  ora #$10
  sta $2006

  lda AttributeBuffer+2
  sta $2007
  lda AttributeBuffer+6
  sta $2007

;
  lda NametableToUpdate
  ora #$03
  sta $2006
  lda #%11000000
  ora AttributeColumnToUpdate
  ora #$18
  sta $2006

  lda AttributeBuffer+3
  sta $2007
  lda AttributeBuffer+7
  sta $2007

  rts





  .pad $FFFA
  .dw vblank
  .dw reset
  .dw irq

;CHR-ROM

  .base $0000

;Pattern Table
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $88,$99,$33,$66,$44,$44,$cc,$33,$77,$66,$cc,$99,$bb,$bb,$33,$cc
  .db $cc,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .db $00,$01,$03,$06,$04,$44,$cc,$33,$03,$06,$0c,$19,$3b,$3b,$33,$cc
  .db $80,$80,$30,$60,$44,$44,$cc,$33,$40,$60,$c0,$98,$b8,$ba,$33,$cc

; Fill the rest of the first CHR-ROM block with zeroes.
  .pad $1000

; Here begins the second 4K block.  The sprites get their data from this page.

;Pattern Table
  .db $00,$01,$02,$04,$08,$10,$21,$60,$00,$00,$01,$03,$07,$0f,$1e,$1f
  .db $c0,$98,$b0,$d0,$90,$98,$3c,$3e,$00,$00,$00,$20,$60,$60,$d8,$d0
  .db $00,$00,$01,$02,$04,$08,$10,$21,$00,$00,$00,$01,$03,$07,$0f,$1e
  .db $00,$80,$90,$b0,$d0,$90,$98,$3c,$00,$00,$00,$00,$20,$60,$60,$d8
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $07,$1c,$2e,$5f,$8c,$c0,$c3,$c7,$00,$03,$1d,$32,$7f,$3f,$3c,$3b
  .db $e0,$38,$74,$fa,$31,$03,$c3,$e1,$00,$c0,$b8,$4c,$fe,$fc,$3c,$de
  .db $07,$1c,$2e,$5f,$9e,$cc,$c3,$87,$00,$03,$1d,$32,$73,$3f,$3c,$7b
  .db $e0,$38,$74,$fa,$79,$33,$c3,$e3,$00,$c0,$b8,$4c,$ce,$fc,$3c,$dc
  .db $70,$40,$60,$70,$40,$20,$10,$0c,$0f,$3f,$1f,$0f,$3f,$1f,$0f,$03
  .db $1a,$06,$06,$02,$22,$24,$18,$10,$e4,$f8,$f8,$fc,$dc,$d8,$e0,$e0
  .db $60,$70,$40,$60,$70,$40,$20,$10,$1f,$0f,$3f,$1f,$0f,$3f,$1f,$0f
  .db $3e,$1a,$06,$06,$02,$22,$24,$18,$d0,$e4,$f8,$f8,$fc,$dc,$d8,$e0
  .db $00,$00,$00,$00,$00,$00,$01,$0e,$00,$00,$00,$00,$00,$00,$00,$01
  .db $6f,$24,$20,$23,$47,$80,$0c,$00,$14,$1b,$1f,$1c,$38,$7f,$f3,$ff
  .db $f2,$24,$04,$84,$b3,$00,$d8,$3e,$2c,$d8,$f8,$78,$4c,$ff,$27,$c1
  .db $00,$06,$19,$21,$cd,$09,$09,$0a,$00,$00,$06,$1e,$32,$f6,$f6,$f4
  .db $00,$60,$98,$84,$b3,$90,$90,$50,$00,$00,$60,$78,$4c,$6f,$6f,$2f
  .db $4f,$24,$20,$21,$cd,$00,$1b,$7c,$34,$1b,$1f,$1e,$32,$ff,$e4,$83
  .db $f6,$24,$04,$c4,$e2,$01,$30,$00,$28,$d8,$f8,$38,$1c,$fe,$cf,$ff
  .db $00,$00,$00,$00,$00,$00,$80,$70,$00,$00,$00,$00,$00,$00,$00,$80
  .db $07,$07,$08,$10,$32,$22,$32,$22,$00,$00,$07,$0f,$0d,$1d,$0d,$1d
  .db $e0,$e0,$10,$08,$44,$44,$44,$44,$00,$00,$e0,$f0,$b8,$b8,$b8,$b8
  .db $0c,$07,$07,$08,$10,$30,$22,$31,$03,$00,$00,$07,$0f,$0f,$1d,$0e
  .db $10,$e0,$e0,$10,$88,$44,$24,$24,$e0,$00,$00,$e0,$70,$b8,$d8,$d8
  .db $0c,$07,$07,$08,$10,$31,$22,$32,$03,$00,$00,$07,$0f,$0e,$1d,$0d
  .db $10,$e0,$e0,$10,$88,$04,$24,$44,$e0,$00,$00,$e0,$70,$f8,$d8,$b8
  .db $10,$21,$4f,$48,$80,$90,$b2,$85,$0f,$1e,$30,$37,$7f,$6f,$4d,$78
  .db $78,$c1,$09,$c0,$d0,$50,$11,$18,$87,$3e,$f6,$3f,$2f,$af,$ee,$e7
  .db $01,$00,$80,$6c,$3c,$04,$82,$c0,$fe,$ff,$7f,$93,$c3,$fb,$7d,$3f
  .db $82,$84,$88,$10,$20,$20,$20,$20,$7c,$78,$70,$e0,$c0,$c0,$c0,$c0
  .db $41,$21,$11,$08,$04,$04,$04,$04,$3e,$1e,$0e,$07,$03,$03,$03,$03
  .db $80,$00,$01,$36,$3c,$20,$41,$03,$7f,$ff,$fe,$c9,$c3,$df,$be,$fc
  .db $1e,$83,$90,$03,$0b,$0a,$88,$18,$e1,$7c,$6f,$fc,$f4,$f5,$77,$e7
  .db $08,$84,$f2,$12,$01,$09,$4d,$a1,$f0,$78,$0c,$ec,$fe,$f6,$b2,$1e
  .db $31,$20,$10,$08,$07,$04,$08,$07,$0e,$1f,$0f,$07,$00,$03,$07,$00
  .db $84,$04,$08,$10,$e0,$18,$04,$f8,$78,$f8,$f0,$e0,$00,$e0,$f8,$00
  .db $20,$30,$20,$10,$28,$47,$32,$0f,$1f,$0f,$1f,$0f,$17,$38,$0c,$00
  .db $c4,$04,$76,$09,$01,$e2,$24,$18,$38,$f8,$88,$f6,$fe,$1c,$18,$00
  .db $21,$30,$20,$20,$20,$43,$31,$0f,$1e,$0f,$1f,$1f,$1f,$3c,$0e,$00
  .db $84,$04,$06,$09,$11,$e2,$24,$18,$78,$f8,$f8,$f6,$ee,$1c,$18,$00
  .db $98,$61,$06,$09,$09,$08,$08,$07,$60,$00,$01,$06,$06,$07,$07,$00
  .db $98,$18,$10,$13,$80,$e0,$01,$fe,$67,$e7,$ef,$ec,$7f,$1f,$fe,$00
  .db $40,$40,$30,$19,$09,$01,$80,$7f,$bf,$bf,$cf,$e6,$f6,$fe,$7f,$00
  .db $40,$80,$60,$10,$10,$10,$10,$e0,$80,$00,$80,$e0,$e0,$e0,$e0,$00
  .db $02,$01,$06,$08,$08,$08,$08,$07,$01,$00,$01,$07,$07,$07,$07,$00
  .db $02,$02,$0c,$98,$90,$80,$01,$fe,$fd,$fd,$f3,$67,$6f,$7f,$fe,$00
  .db $19,$18,$08,$c8,$01,$07,$80,$7f,$e6,$e7,$f7,$37,$fe,$f8,$7f,$00
  .db $19,$86,$60,$90,$90,$10,$10,$e0,$06,$00,$80,$60,$60,$e0,$e0,$00

  .pad $2000
