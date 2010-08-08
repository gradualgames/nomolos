.include "zp.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "sound.inc"
.include "entity.inc"
.include "fixedBankData.inc"

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
map_x_coordinate = w0
map_y_coordinate = w1
collision_was_hurt_tile = b0
collision_was_solid_tile = b1
meta_tile_column_index = w2

map_index = w3
map_column_index = w4
attribute_column_address = w5
map_column_address = w6
meta_tile_column_address = w7
meta_tile_address = w8

  lda map_y_coordinate+1
  beq skip_leave_map_test_collision
  lda #0
  sta b0
  sta b1
  rts
skip_leave_map_test_collision:

  ;switch to the level and music bank
  lda mapper_bank_current  ;save current bank
  pha
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;compute meta tile column index from camera_scroll_x by dividing by 16, or shifting right by 4.
  lda map_x_coordinate
  sta meta_tile_column_index
  lda map_x_coordinate+1
  sta meta_tile_column_index+1
  
  lda meta_tile_column_index
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  sta meta_tile_column_index
  
  ;calculate map column index
  lda meta_tile_column_index
  sta map_column_index
  lda meta_tile_column_index+1
  sta map_column_index+1
  
  lsr map_column_index+1
  ror map_column_index
  
  clc
  lda base_address_map
  adc map_column_index
  sta map_column_index
  lda base_address_map+1
  adc map_column_index+1
  sta map_column_index+1
  
  ldy #0
  lda (map_column_index),y
  
  ;interpret this as a 16 bit value
  sta map_column_address
  lda #0
  sta map_column_address+1
  
  ;shift left the map column address by 2
  lda map_column_address+1
  asl map_column_address
  rol 
  asl map_column_address
  rol 
  sta map_column_address+1
  
  ;add the base address on
  clc
  lda base_address_map_column_table
  adc map_column_address
  sta map_column_address
  lda base_address_map_column_table+1
  adc map_column_address+1
  sta map_column_address+1

  ;point at left meta tile column index within the map column. now test for whether we are looking
  ;at the right one instead.
  ldy #1
  
  ;lets figure out whether we want to decode the left or the right side of the map column
  ;check lowest bit. If it is 1, we do right side, otherwise left
  lda meta_tile_column_index
  and #1
  beq decode_left_column
decode_right_column:
  ;point at the right meta tile column index within the map column.
  iny
decode_left_column:

  ;get the meta tile column index
  lda (map_column_address),y
  
  ;interpret this as a 16 bit number
  sta meta_tile_column_address
  lda #0
  sta meta_tile_column_address+1
  
  ;shift left the meta tile column address by 4 since each meta tile column is 16 bytes long
  ;now shift left w0 by 4.
  lda meta_tile_column_address+1
  asl meta_tile_column_address
  rol 
  asl meta_tile_column_address
  rol 
  asl meta_tile_column_address
  rol 
  asl meta_tile_column_address
  rol 
  sta meta_tile_column_address+1
  
  ;calculate full address of meta tile column address by adding it to the base address of the meta tile column table
  clc
  lda base_address_meta_tile_column_table
  adc meta_tile_column_address
  sta meta_tile_column_address
  lda base_address_meta_tile_column_table+1
  adc meta_tile_column_address+1
  sta meta_tile_column_address+1
  
  ;now we have full address of the meta tile column stored in meta_tile_column_address  
  ;use y coordinate to compute index into meta tile column. divide it by 16
  lda map_y_coordinate
  lsr
  lsr
  lsr
  lsr
  
  ;transfer a to y to use y as an index from the computed meta tile column
  tay
  
  ;get the index of the meta tile.
  lda (meta_tile_column_address),y
  
  ;interpret this as a 16 bit value
  sta meta_tile_address
  lda #0
  ;now shift left the meta_tile_address by 3 to get correct offset
  sta meta_tile_address+1
  lda meta_tile_address+1
  asl meta_tile_address
  rol 
  asl meta_tile_address
  rol 
  asl meta_tile_address
  rol 
  sta meta_tile_address+1
  ;now calculate full address of meta_tile_address by adding base_address_meta_tile_table
  clc
  lda base_address_meta_tile_table
  adc meta_tile_address
  sta meta_tile_address
  lda base_address_meta_tile_table+1
  adc meta_tile_address+1
  sta meta_tile_address+1

  ;now transfer results to collision_was_hurt_tile and collision_was_solid_tile
  ldy #1 ;index of hurt
  lda (meta_tile_address),y
  sta collision_was_hurt_tile
  
  ldy #2 ;index of solid
  lda (meta_tile_address),y
  sta collision_was_solid_tile
  
  ;restore previous bank
  pla
  sta mapper_bank_next
  jsr mapper_switch_bank

  rts

.endproc

;decodes the map left or right depending on the camera_will_scroll_right variable.
;if the variable is 1, it scrolls right, zero, it scrolls left.
.export map_decode
.proc map_decode
  ;do not decode map if direction is 0
  lda camera_scroll_direction
  beq camera_scroll_test_done
  ;now decide what direction to decode in
  bmi camera_scrolling_left
  jsr map_decode_right_side
  jmp camera_scroll_test_done
camera_scrolling_left:
  jsr map_decode_left_side
camera_scroll_test_done:
  rts
.endproc

;does this for left-scrolling. There is a sibling function, map_decode_right_side, for right-scrolling.
.export map_decode_left_side
.proc map_decode_left_side
meta_tile_column_index = w0
  
  ;switch to the level and music bank
  lda mapper_bank_current  ;save current bank
  pha
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;compute meta tile column index from camera_scroll_x by dividing by 16, or shifting right by 4.
  lda camera_scroll_x
  sta meta_tile_column_index
  lda camera_scroll_x+1
  sta meta_tile_column_index+1
  
  lda meta_tile_column_index
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  sta meta_tile_column_index
  
  ;now meta_tile_column_index is the correct value for the map column decoder
  lda meta_tile_column_index
  sta w1
  lda meta_tile_column_index+1
  sta w1+1
  
  ;compute the name_table_to_update based on the upper byte of camera_scroll_x
  lda camera_scroll_x+1
  and #1
  beq name_table_is_2000
name_table_is_2400:
  lda #$24
  sta name_table_to_update
  sta name_table_to_view
  jmp name_table_to_update_test_done
name_table_is_2000:
  lda #$20
  sta name_table_to_update
  sta name_table_to_view
name_table_to_update_test_done:

  ;compute attribute column to update based on the meta tile column index
  lda meta_tile_column_index
  lsr
  and #%00000111
  sta attribute_column_to_update
  
  ;compute column to update based on meta_tile_column_index
  lda meta_tile_column_index
  asl
  and #%00011111
  sta column_to_update
  
  jsr map_decode_column
  
  ;restore previous bank
  pla
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  rts
.endproc
  
;computes correct parameters for map_decode_column and ppu update routines based on current camera_scroll_x.
;does this for right-scrolling. There is a sibling function, map_decode_left_side, for left-scrolling.
.export map_decode_right_side
.proc map_decode_right_side
meta_tile_column_index = w0
  
  ;switch to the level and music bank
  lda mapper_bank_current  ;save current bank
  pha
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;compute meta tile column index from camera_scroll_x by dividing by 16, or shifting right by 4.
  lda camera_scroll_x
  sta meta_tile_column_index
  lda camera_scroll_x+1
  sta meta_tile_column_index+1
  
  lda meta_tile_column_index
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  lsr meta_tile_column_index+1
  ror
  sta meta_tile_column_index
  
  ;now that we have meta tile column index, we want to add 16 to it so we're off the right side of the screen.
  clc
  lda meta_tile_column_index
  adc #$10
  sta meta_tile_column_index
  lda meta_tile_column_index+1
  adc #$00
  sta meta_tile_column_index+1
  
  ;now meta_tile_column_index is the correct value for the map column decoder
  lda meta_tile_column_index
  sta w1
  lda meta_tile_column_index+1
  sta w1+1
  
  ;compute the name_table_to_update based on the upper byte of camera_scroll_x
  lda camera_scroll_x+1
  and #1
  beq name_table_is_2400
name_table_is_2000:
  lda #$20
  sta name_table_to_update
  lda #$24
  sta name_table_to_view
  jmp name_table_to_update_test_done
name_table_is_2400:
  lda #$24
  sta name_table_to_update
  lda #$20
  sta name_table_to_view
name_table_to_update_test_done:

  ;compute attribute column to update based on the meta tile column index
  lda meta_tile_column_index
  lsr
  and #%00000111
  sta attribute_column_to_update
  
  ;compute column to update based on meta_tile_column_index
  lda meta_tile_column_index
  asl
  and #%00011111
  sta column_to_update
  
  jsr map_decode_column
  
  ;restore previous bank
  pla
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  rts
.endproc
  
;decodes a single column from the map. It will fill an entire attribute buffer
;with the correct attributes, and it will fill a two-column buffer with tile indices.
;does not do anything with PPU that is the job of the PPU upload routines
;parameters:
;expects w1 to contain index of column to decode, in meta tile column units. From this, the
;map column index will be deduced.
;expects base_address_map to contain address of map data
;expects base_address_map_column_table to contain address of map column table
;expects base_address_attribute_column_table to contain address of attribute column table
;expects base_address_meta_tile_column_table to contain address of meta tile column table
;expects base_address_meta_tile_table to contain address of meta tile table
.export map_decode_column
.proc map_decode_column
meta_tile_column_index = w1
map_index = w0
map_column_index = w2
attribute_column_address = w3
map_column_address = w4
meta_tile_column_address = w5
meta_tile_address = w6

  ;calculate map_index from meta_tile_column_index
  lda meta_tile_column_index
  sta map_column_index
  lda meta_tile_column_index+1
  sta map_column_index+1
  
  lsr map_column_index+1
  ror map_column_index
  
  clc
  lda base_address_map
  adc map_column_index
  sta map_column_index
  lda base_address_map+1
  adc map_column_index+1
  sta map_column_index+1
  
  ldy #0
  lda (map_column_index),y
  
  ;interpret this as a 16 bit value
  sta map_column_address
  lda #0
  sta map_column_address+1
  
  ;shift left the map column address by 2
  lda map_column_address+1
  asl map_column_address
  rol 
  asl map_column_address
  rol 
  sta map_column_address+1
  
  ;add the base address on
  clc
  lda base_address_map_column_table
  adc map_column_address
  sta map_column_address
  lda base_address_map_column_table+1
  adc map_column_address+1
  sta map_column_address+1

  ;load the index of the attribute column
  ldy #0
  clc
  lda (map_column_address),y
  
  ;interpret this index as a 16-bit number
  sta attribute_column_address
  lda #0
  sta attribute_column_address+1
  
  ;now calculate the address of the attribute column based on this index
  ;multiply by 8
  ;now shift left attribute_column_address by 3.
  lda attribute_column_address+1
  asl attribute_column_address
  rol 
  asl attribute_column_address
  rol 
  asl attribute_column_address
  rol 
  sta attribute_column_address+1
  
  ;attribute_column_address now has 16-bit offset of attribute column.
  ;now calculate address of attribute column based on table address
  clc
  lda base_address_attribute_column_table
  adc attribute_column_address
  sta attribute_column_address
  lda base_address_attribute_column_table+1
  adc attribute_column_address+1
  sta attribute_column_address+1
  
  ;attribute_column_address now has 16-bit address of attribute column. copy it to attribute buffer
  ldy #7
attribute_copy_loop:
  lda (attribute_column_address),y
  sta buffer_attribute,y
  dey
  bpl attribute_copy_loop
  
  
  ;point at left meta tile column index within the map column. now test for whether we are looking
  ;at the right one instead.
  ldy #1
  
  ;lets figure out whether we want to decode the left or the right side of the map column
  ;check lowest bit. If it is 1, we do right side, otherwise left
  lda meta_tile_column_index
  and #1
  beq decode_left_column
decode_right_column:
  ;point at the right meta tile column index within the map column.
  iny
decode_left_column:

  ;get the meta tile column index
  lda (map_column_address),y
  
  ;interpret this as a 16 bit number
  sta meta_tile_column_address
  lda #0
  sta meta_tile_column_address+1
  
  ;shift left the meta tile column address by 4 since each meta tile column is 16 bytes long
  ;now shift left w0 by 4.
  lda meta_tile_column_address+1
  asl meta_tile_column_address
  rol 
  asl meta_tile_column_address
  rol 
  asl meta_tile_column_address
  rol 
  asl meta_tile_column_address
  rol 
  sta meta_tile_column_address+1
  
  ;calculate full address of meta tile column address by adding it to the base address of the meta tile column table
  clc
  lda base_address_meta_tile_column_table
  adc meta_tile_column_address
  sta meta_tile_column_address
  lda base_address_meta_tile_column_table+1
  adc meta_tile_column_address+1
  sta meta_tile_column_address+1
  
  ;now we have full address of the meta tile column stored in meta_tile_column_address  
  ;loop through all 15 indices within the meta tile column, and write the left column to the first 30 bytes of the
  ;buffer and the right column to the second 30 bytes of the buffer.
  ;we don't need map column or y anymore.
  ldx #0
  ldy #0
column_loop:
  ;start of column loop

  ;get index of meta tile
  lda (meta_tile_column_address),y
  ;interpret this as a 16 bit value
  sta meta_tile_address
  lda #0
  ;now shift left the meta_tile_address by 3 to get correct offset
  sta meta_tile_address+1
  lda meta_tile_address+1
  asl meta_tile_address
  rol 
  asl meta_tile_address
  rol 
  asl meta_tile_address
  rol 
  sta meta_tile_address+1
  ;now calculate full address of meta_tile_address by adding base_address_meta_tile_table
  clc
  lda base_address_meta_tile_table
  adc meta_tile_address
  sta meta_tile_address
  lda base_address_meta_tile_table+1
  adc meta_tile_address+1
  sta meta_tile_address+1
  
  ;now meta_tile_address has full address of a meta tile to decode
  ;store y
  tya
  pha
  
  ldy #3
  lda (meta_tile_address),y
  sta buffer_column,x
  iny
  ;pointing at top right tile index
  lda (meta_tile_address),y
  sta buffer_column+30,x
  inx
  iny
  ;pointing at bottom left tile index
  lda (meta_tile_address),y
  sta buffer_column,x
  iny
  ;pointing at bottom right tile index
  lda (meta_tile_address),y
  sta buffer_column+30,x
  inx
  ;point at entity
  iny
  lda (meta_tile_address),y
  ;entity index to spawn
  sta b0

  ;calculate x coordinate at which to spawn entity
  lda camera_scroll_direction
  beq do_not_spawn_entity
camera_scroll_to_right:
  bmi spawn_entity_to_left
  lda camera_scroll_x
  and #%00001111
  bne do_not_spawn_entity
  lda camera_scroll_x
  sta w0
  clc
  lda camera_scroll_x+1
  adc #1
  sta w0+1
  jmp camera_scroll_test_done
spawn_entity_to_left:
  lda camera_scroll_x
  and #%00001111
  bne do_not_spawn_entity
  lda camera_scroll_x
  sta w0
  lda camera_scroll_x+1
  sta w0+1
camera_scroll_test_done:
  
  ;get y's stored value off of stack
  pla
  pha
  asl
  asl
  asl
  asl
  sta b1
  
  jsr entity_spawn
do_not_spawn_entity:
  iny
  
  ;restore y
  pla
  tay  
  
  ;increment y to next meta tile
  iny

  cpy #15
  bne column_loop
  
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

.export map_update_scroll_ppu
.proc map_update_scroll_ppu
  lda name_table_to_view
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  lda camera_scroll_x
  sta ppu_2005
  lda #0
  sta ppu_2005+1
  upload_ppu_2005
  
.endproc