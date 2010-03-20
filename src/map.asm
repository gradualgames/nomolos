.include "constants.inc"
.include "structs.inc"
.include "zp.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "sound.inc"
.include "entity.inc"

.segment "CODE"

;This routine checks for collision with the map. It takes in a 16 bit X
;coordinate and a 16 bit Y coordinate.
;parameters:
;w0: 16 bit X coordinate in the map
;w1: 16 bit Y coordinate in the map
;outputs:
;the zero flag should be set if there is no collision, clear otherwise
;b0: whether or not the collision was with a "hurt" tile.
;b1: whether or not the collision was with a "solid" tile.
.export map_test_collision
.proc map_test_collision
  ;switch to the level and music bank
  lda mapper_bank_current  ;save current bank
  pha
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  lda #0
  sta b0
  sta b1

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
  
  ;add this value to the level base address and store it in w2
  clc
  lda base_address_level  
  adc w0
  sta w2
  lda base_address_level+1
  adc w0+1
  sta w2+1
  
  ;now we have the exact offset in the level stored in w2
  ldy #$00
  ;load the meta tile column index
  lda (w2),y
  
  sta w3
  lda #0
  sta w3+1
  
  ;now shift left w3 by 4 to get offset within the meta tile column table.
  lda w3+1
  asl w3
  rol 
  asl w3
  rol 
  asl w3
  rol 
  asl w3
  rol 
  sta w3+1
  
  ;add this value to the base address and store it in w4
  clc
  lda w3
  adc base_address_meta_meta_tile_table
  sta w4
  lda w3+1
  adc base_address_meta_meta_tile_table+1
  sta w4+1
  
  ;now we have to figure out what row to look at.
  ;load the high byte of the Y coordinate...if this is nonzero, we're outside the visible map.
  lda w1+1
  beq @insideScreen
  
  ;being outside the map means the map didn't hurt Nomolos.
  lda #0
  sta b0
  ;being outside the map also means no collision.
  sta b1
  
  ;restore previous bank
  pla
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  rts
@insideScreen:
  ;load the Y coordinate
  ;divide it by 16 to get row
  lda w1
  lsr w1+1
  ror
  lsr w1+1
  ror
  lsr w1+1
  ror
  lsr w1+1
  ror
  sta w1
  ;put the result in Y so we can look up a meta tile
  tay
  ;load the meta tile index
  lda (w4),y
  
  ;get this meta tile number into a 16 bit situation so we can multiply it by 8
  sta w3
  lda #0
  sta w3+1
  
  ;now shift left w3 by 3 to get offset within the meta tile table.
  lda w3+1
  asl w3
  rol 
  asl w3
  rol 
  asl w3
  rol 
  sta w3+1
  
  ;add base_address_meta_tile_table to w3
  clc
  lda w3
  adc base_address_meta_tile_table
  sta w3
  lda w3+1
  adc base_address_meta_tile_table+1
  sta w3+1
  
  ldy #0
  
  ;point to the "hurt" attribute. Store this in b0.
  iny
  lda (w3),y
  sta b0
  
  ;point to the "solid" attribute. This is the big finale of the collision routine.
  iny
  ;lda #1
  lda (w3), y
  sta b1
  
  ;restore previous bank
  pla
  sta mapper_bank_next
  jsr mapper_switch_bank

  rts
.endproc
  
.export map_decode
.proc map_decode
  ;switch to the level and music bank
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;load the current scroll value and subtract the next scroll value. only when this is 0 or positive do we continue.
  lda camera_scroll_x
  sec
  sbc camera_scroll_next_x
  sta w0
  lda camera_scroll_x+1
  sbc camera_scroll_next_x+1
  sta w0+1
  beq doDecode
  bpl doDecode
  
  ;the result was negative, which means the scroll hasn't reached camera_scroll_next_x yet. Return.
  rts
  
doDecode:
  ;jsr sound_play_low_c  ;quick hack to determine aurally whether each column is getting drawn only once.

  ;Load the current scroll value. Shifting this 16 bit value right by 4 will produce the correct column number for the leftmost
  ;column on the screen.

  lda camera_scroll_x
  sta w0
  sta w2
  sta w3 ;spawnX
  lda camera_scroll_x+1
  sta w0+1
  sta w2+1
  sta w3+1 ;spawnX+1
  
  ;add 256 to w3 to get correct spawnX
  lda w3+1
  clc
  adc #1
  sta w3+1
  
  ;calculate "the next" camera_scroll_x from the current camera_scroll_x value.
  lda w2
  ;cut off anything less than 16.
  and #%11110000
  ;do a 16 bit add of "16" to this "next" camera_scroll_x value.
  clc
  adc #$10
  sta w2
  lda w2+1
  adc #0
  sta w2+1
  
  ;transfer the computed next camera_scroll_x to our camera_scroll_next_x variable.
  lda w2
  sta camera_scroll_next_x
  lda w2+1
  sta camera_scroll_next_x+1

  ;calculate the nametable to draw the column into
  lda camera_scroll_x+1
  eor #$01  ;flip the lowest bit to get the opposite nametable
  and #$01  ;grab just the lowest bit
  asl
  asl
  ora #$20
  sta name_table_to_update

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
  sta column_to_update

  ;w0 now has the column number we wish to decode.
  ;The upper byte now has the map offset * 256, and the lower byte has the offset into the map data from that point.
  ;base_address_level points to the current level. So load that address into w1, and add w0 to w1.

  lda base_address_level
  sta w1
  lda base_address_level+1
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

  lda base_address_meta_meta_tile_table
  sta w1
  lda base_address_meta_meta_tile_table+1
  sta w1+1

  clc         ; Clear the carry flag
  lda w0      ; Load little end of number 1 into accumulator register
  adc w1      ; Add with carry the little end of number 2
  sta w1      ; Store the little end of the result
  lda w0+1    ; Load big end of number 1 into accumulator
  adc w1+1    ; Add with carry the big end of number 2
  sta w1+1    ; Store the big end of the result

  ;Load the meta meta tile address, and call the map_update_column routine to get that meta tile into the PPU buffers.
  jsr map_update_column

  rts
.endproc

;This routine decodes a single 1x15 meta-meta tile and places the proper
;name table tile numbers into two 30 byte buffers for use by map_update_column_ppu
;w1: address of meta-meta tile to decode
;buffer_column: the buffer to which the meta-meta tile will be decoded. It will consist of
;two 30 tile columns.
.export map_update_column
.proc map_update_column
  ;we need to calculate what the attributecolumnToUpdate is.
  ;we know the column_to_update. that's 0-31.
  ;if we shift this right, we get the meta tile column.
  ;if we shift this right again, we get the attribute column to update.
  lda column_to_update
  lsr
  sta b2 ;metaTileColumn
  lsr
  sta attribute_column_to_update

  ldy #0
  ldy #0
  ldx #15
nextTile:
  ;save y, we need it for indirect addressing again
  sty b4 ;spawnY
  tya
  pha
  sta b3 ;store the metatile row
  lsr ;get the correct attribute row
  sta b0

  ;indirectly load the meta tile number
  lda (w1),y

  ;get this meta tile number into a 16 bit situation so we can multiply it by 8
  sta w2
  lda #0
  sta w2+1
  
  ;now shift left w2 by 3 to get offset within the meta tile table.
  lda w2+1
  asl w2
  rol 
  asl w2
  rol 
  asl w2
  rol 
  sta w2+1
  
  ;add base_address_meta_tile_table to w2
  clc
  lda w2
  adc base_address_meta_tile_table
  sta w2
  lda w2+1
  adc base_address_meta_tile_table+1
  sta w2+1
  
  ldy #0

  ;y has the index of the attribute field
  lda (w2), y
  ;now a has the attribute to write

  sta b1

  jsr map_update_attribute

  iny
  ;let's not bother with the hurt flag for now
  iny
  ;let's not bother with the solid flag for now
  iny
  ;load the top left
  lda (w2), y
  sta buffer_meta_tile
  ;load the top right
  iny
  lda (w2), y
  sta buffer_meta_tile+1
  ;load the bottm left tile
  iny
  lda (w2), y
  sta buffer_meta_tile+2
  ;load the bottom right tile
  iny
  lda (w2), y
  sta buffer_meta_tile+3
  ;load the entity number to spawn
  iny
  lda (w2), y
  sta b0
  
  ;save metaTileColumn, this is used by map_update_attribute for the entire loop.
  lda b2 ;metaTileColumn
  pha
  
  lda w3
  sta w0
  lda w3+1
  sta w0+1
  lda b4
  asl
  asl
  asl
  asl
  sta b1
  jsr entity_spawn
  
  pla
  sta b2 ;metaTileColumn
  
;doNotSpawn:
  
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
  lda buffer_meta_tile
  ;store it in left column
  sta buffer_column, y
  ;load the top right tile
  lda buffer_meta_tile+1
  ;store it in the right column
  sta buffer_column+30, y
  ;load the bottom left tile
  lda buffer_meta_tile+2
  ;store it in the left column
  sta buffer_column+1, y
  ;load the bottom right tile
  lda buffer_meta_tile+3
  ;store it in the right column
  sta buffer_column+31, y

  pla
  tay
  iny
  dex
  beq @skipNextTile
  jmp nextTile
@skipNextTile:

  rts
.endproc

;This routine updates a single attribute value in the attribute buffer.
;b0: The attribute row to update.
;b1: The attribute value we want to put into the attribute.
;b2: The current metatile column.
;b3: The current metatile row.
.export map_update_attribute
.proc map_update_attribute
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
  lda buffer_attribute, y
  and b5
  ora b1
  sta buffer_attribute, y

  pla
  tax
  pla
  tay

  rts
.endproc
  
.export map_update_scroll_ppu
.proc map_update_scroll_ppu
  lda name_table_to_update
  eor #$04
  sta $2006
  lda #$00
  sta $2006

  lda camera_scroll_x
  sta $2005
  lda #0
  sta $2005

  rts
.endproc

;dumps two columns of tiles to the PPU
;buffer_column: the buffer containing both columns of tiles to write
;column_to_update: the column to update
.export map_update_column_ppu
.proc map_update_column_ppu

  lda name_table_to_update
  sta $2006
  lda column_to_update
  sta $2006

  ldy #0
  ldx #30
:
  lda buffer_column, y
  sta $2007

  iny
  dex
  bne :-

  lda name_table_to_update
  sta $2006
  lda column_to_update
  clc
  adc #1
  sta $2006

  ldy #0
  ldx #30
:
  lda buffer_column+30, y
  sta $2007

  iny
  dex
  bne :-

  rts
.endproc

.export map_update_attribute_ppu
.proc map_update_attribute_ppu

;
  lda name_table_to_update
  ora #$03
  sta $2006
  lda #%11000000
  ora attribute_column_to_update
  sta $2006

  lda buffer_attribute
  sta $2007
  lda buffer_attribute+4
  sta $2007

;
  lda name_table_to_update
  ora #$03
  sta $2006
  lda #%11000000
  ora attribute_column_to_update
  ora #$08
  sta $2006

  lda buffer_attribute+1
  sta $2007
  lda buffer_attribute+5
  sta $2007

;
  lda name_table_to_update
  ora #$03
  sta $2006
  lda #%11000000
  ora attribute_column_to_update
  ora #$10
  sta $2006

  lda buffer_attribute+2
  sta $2007
  lda buffer_attribute+6
  sta $2007

;
  lda name_table_to_update
  ora #$03
  sta $2006
  lda #%11000000
  ora attribute_column_to_update
  ora #$18
  sta $2006

  lda buffer_attribute+3
  sta $2007
  lda buffer_attribute+7
  sta $2007

  rts  
.endproc
