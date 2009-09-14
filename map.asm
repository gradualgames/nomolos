.include "constants.asm"

;global variables
.importzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3
.importzp attributeBuffer, columnTileBuffer
.importzp metaTileBuffer, metaTileTableBaseAddress
.importzp attributeColumnToUpdate
.importzp metametaTileTableBaseAddress
.importzp levelBaseAddress, columnToUpdate, nametableToUpdate
.importzp scrollX, nextScrollX

;sound module
.import lowc

;map and camera interface
.export testMapCollision
.export decodeMap
.export updateColumn
.export updateAttribute
.export updateScrollPPU, updateColumnPPU
.export updateAttributePPU

.segment "CODE"

;This routine checks for collision with the map. It takes in a 16 bit X
;coordinate and an 8 bit Y coordinate.
;parameters:
;w0: 16 bit X coordinate in the map
;b0: 8 bit Y coordinate in the map
;outputs:
;the zero flag should be set if there is no collision, clear otherwise
.proc testMapCollision

  ;divide X coordinate by 16 to get column coordinate
  lda w0
  lsr w0+1
  ror
  lsr w0+1
  ror
  lsr w0+1
  ror
  lsr w0+1
  ror
  sta w0
  
  ;add this value to the level base address and store it in w1
  clc
  lda levelBaseAddress  
  adc w0
  sta w1
  lda levelBaseAddress+1
  adc w0+1
  sta w1+1
  
  ;now we have the exact offset in the level stored in w1
  ldy #$00
  ;load the meta tile column index
  lda (w1),y
  
  sta w2
  lda #0
  sta w2+1
  
  ;now shift left w2 by 4 to get offset within the meta tile column table.
  lda w2+1
  asl w2
  rol 
  asl w2
  rol 
  asl w2
  rol 
  asl w2
  rol 
  sta w2+1
  
  ;add this value to the base address and store it in w3
  clc
  lda w2
  adc metametaTileTableBaseAddress
  sta w3
  lda w2+1
  adc metametaTileTableBaseAddress+1
  sta w3+1
  
  ;now we have to figure out what row to look at
  ;load the Y coordinate
  lda b0  
  ;divide it by 16 to get row
  lsr
  lsr
  lsr
  lsr
  ;put the result in Y so we can look up a meta tile
  tay
  ;load the meta tile index
  lda (w3),y
  
  ;multiply by 8 to get offset from meta tile table
  asl
  asl
  asl
  tay
  
  ;point to the "solid" attribute. This is the big finale of the collision routine.
  iny
  lda #1
  lda (metaTileTableBaseAddress), y

  rts
.endproc
  
decodeMap:

  ;load the current scroll value and subtract the next scroll value. only when this is 0 or positive do we continue.
  lda scrollX
  sec
  sbc nextScrollX
  sta w0
  lda scrollX+1
  sbc nextScrollX+1
  sta w0+1
  beq doDecode
  bpl doDecode
  
  ;the result was negative, which means the scroll hasn't reached nextScrollX yet. Return.
  rts
  
doDecode:
  jsr lowc

  ;Load the current scroll value. Shifting this 16 bit value right by 4 will produce the correct column number for the leftmost
  ;column on the screen.

  lda scrollX
  sta w0
  sta w2
  lda scrollX+1
  sta w0+1
  sta w2+1
  
  ;calculate "the next" scrollX from the current scrollX value.
  lda w2
  ;cut off anything less than 16.
  and #%11110000
  ;do a 16 bit add of "16" to this "next" scrollX value.
  clc
  adc #$10
  sta w2
  lda w2+1
  adc #0
  sta w2+1
  
  ;transfer the computed next scrollX to our nextScrollX variable.
  lda w2
  sta nextScrollX
  lda w2+1
  sta nextScrollX+1

  ;calculate the nametable to draw the column into
  lda scrollX+1
  eor #$01  ;flip the lowest bit to get the opposite nametable
  and #$01  ;grab just the lowest bit
  asl
  asl
  ora #$20
  sta nametableToUpdate

  ;shift right w0 by 4
  lda w0
  lsr w0+1
  ror
  lsr w0+1
  ror
  lsr w0+1
  ror
  lsr w0+1
  ror
  sta w0

  ;At this point we should have the correct column for the leftmost column on the screen stored in w0.
  ;Add 16 to this number and we will have the column we wish to decode.

  clc
  lda w0
  adc #$10
  sta w0
  lda w0+1
  adc #$00
  sta w0+1

  ;now that we have the correct column, figure out what it is in "tile columns" for the PPU routine.
  ;load the column number
  lda w0
  ;multiply it by two, this is the tile column
  asl
  ;make sure it is from 0 to 31
  and #$1f
  sta columnToUpdate

  ;w0 now has the column number we wish to decode.
  ;The upper byte now has the map offset * 256, and the lower byte has the offset into the map data from that point.
  ;levelBaseAddress points to the current level. So load that address into w1, and add w0 to w1.

  lda levelBaseAddress
  sta w1
  lda levelBaseAddress+1
  sta w1+1

  clc           ; Clear the carry flag
  lda w0      ; Load little end of number 1 into accumulator register
  adc w1      ; Add with carry the little end of number 2
  sta w1      ; Store the little end of the result
  lda w0+1    ; Load big end of number 1 into accumulator
  adc w1+1    ; Add with carry the big end of number 2
  sta w1+1    ; Store the big end of the result

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
  lda w0+1
  asl w0
  rol 
  asl w0
  rol 
  asl w0
  rol 
  asl w0
  rol 
  sta w0+1

  lda metametaTileTableBaseAddress
  sta w1
  lda metametaTileTableBaseAddress+1
  sta w1+1

  clc         ; Clear the carry flag
  lda w0      ; Load little end of number 1 into accumulator register
  adc w1      ; Add with carry the little end of number 2
  sta w1      ; Store the little end of the result
  lda w0+1    ; Load big end of number 1 into accumulator
  adc w1+1    ; Add with carry the big end of number 2
  sta w1+1    ; Store the big end of the result

  ;Load the meta meta tile address, and call the updateColumn routine to get that meta tile into the PPU buffers.
  jsr updateColumn

  rts

;This routine decodes a single 1x15 meta-meta tile and places the proper
;name table tile numbers into two 30 byte buffers for use by updateColumnPPU
;w1: address of meta-meta tile to decode
;columnTileBuffer: the buffer to which the meta-meta tile will be decoded. It will consist of
;two 30 tile columns.
updateColumn:

  ;we need to calculate what the attributecolumnToUpdate is.
  ;we know the columnToUpdate. that's 0-31.
  ;if we shift this right, we get the meta tile column.
  ;if we shift this right again, we get the attribute column to update.
  lda columnToUpdate
  lsr
  sta b2
  lsr
  sta attributeColumnToUpdate

  ldy #0
  ldy #0
  ldx #15
:
  ;save y, we need it for indirect addressing again
  tya
  pha
  sta b3 ;store the metatile row
  lsr ;get the correct attribute row
  sta b0

  ;indirectly load the meta tile number
  lda (w1),y

  asl
  asl
  asl
  ;use this offset as an index
  tay

  ;y has the index of the attribute field
  lda (metaTileTableBaseAddress), y
  ;now a has the attribute to write

  sta b1

  jsr updateAttribute

  iny
  ;let's not bother with the solid flag for now
  iny
  ;load the top left
  lda (metaTileTableBaseAddress), y
  sta metaTileBuffer
  ;load the top right
  iny
  lda (metaTileTableBaseAddress), y
  sta metaTileBuffer+1
  ;load the bottm left tile
  iny
  lda (metaTileTableBaseAddress), y
  sta metaTileBuffer+2
  ;load the bottom right tile
  iny
  lda (metaTileTableBaseAddress), y
  sta metaTileBuffer+3

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
  lda metaTileBuffer
  ;store it in left column
  sta columnTileBuffer, y
  ;load the top right tile
  lda metaTileBuffer+1
  ;store it in the right column
  sta columnTileBuffer+30, y
  ;load the bottom left tile
  lda metaTileBuffer+2
  ;store it in the left column
  sta columnTileBuffer+1, y
  ;load the bottom right tile
  lda metaTileBuffer+3
  ;store it in the right column
  sta columnTileBuffer+31, y

  pla
  tay
  iny
  dex
  bne :-

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
  beq :+
  ;row bit 1, column bit 1
  lda #%00111111
  sta b5
  ror b1
  ror b1
  ror b1
  jmp gotMask
:
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
  beq :+
  ;row bit 0, column bit 1
  lda #%11110011
  sta b5
  rol b1
  rol b1
  jmp gotMask
:
  ;row bit 0, column bit 0
  lda #%11111100
  sta b5
  jmp gotMask


gotMask:

  ldy b0
  lda attributeBuffer, y
  and b5
  ora b1
  sta attributeBuffer, y

  pla
  tax
  pla
  tay
  ;pla

  rts
  
updateScrollPPU:

  lda nametableToUpdate
  eor #$04
  sta $2006
  lda #$00
  sta $2006

  lda scrollX
  sta $2005
  lda #0
  sta $2005

  rts

;dumps two columns of tiles to the PPU
;columnTileBuffer: the buffer containing both columns of tiles to write
;columnToUpdate: the column to update
updateColumnPPU:

  lda nametableToUpdate
  sta $2006
  lda columnToUpdate
  sta $2006

  ldy #0
  ldx #30
:
  lda columnTileBuffer, y
  sta $2007

  iny
  dex
  bne :-

  lda nametableToUpdate
  sta $2006
  lda columnToUpdate
  clc
  adc #1
  sta $2006

  ldy #0
  ldx #30
:
  lda columnTileBuffer+30, y
  sta $2007

  iny
  dex
  bne :-

  rts

updateAttributePPU:

;
  lda nametableToUpdate
  ora #$03
  sta $2006
  lda #%11000000
  ora attributeColumnToUpdate
  sta $2006

  lda attributeBuffer
  sta $2007
  lda attributeBuffer+4
  sta $2007

;
  lda nametableToUpdate
  ora #$03
  sta $2006
  lda #%11000000
  ora attributeColumnToUpdate
  ora #$08
  sta $2006

  lda attributeBuffer+1
  sta $2007
  lda attributeBuffer+5
  sta $2007

;
  lda nametableToUpdate
  ora #$03
  sta $2006
  lda #%11000000
  ora attributeColumnToUpdate
  ora #$10
  sta $2006

  lda attributeBuffer+2
  sta $2007
  lda attributeBuffer+6
  sta $2007

;
  lda nametableToUpdate
  ora #$03
  sta $2006
  lda #%11000000
  ora attributeColumnToUpdate
  ora #$18
  sta $2006

  lda attributeBuffer+3
  sta $2007
  lda attributeBuffer+7
  sta $2007

  rts  