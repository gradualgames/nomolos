.ifndef PPU_INC
PPU_INC = 1

.import ppu_create_decimal_string
.import ppu_display_string
.import ppu_set_vram_address
.import ppu_load_chr_amount
.import ppu_load_chr_groups
.import ppu_load_name_table
.import ppu_clear_name_table
.import ppu_load_palette
.import ppu_load_palette_bg
.import ppu_load_palette_spr

;bit positions for PPU control register $2000
PPU0_EXECUTE_NMI = 7
PPU0_MASTER_SLAVE = 6
PPU0_SPRITE_SIZE = 5
PPU0_BACKGROUND_PATTERN_TABLE_ADDRESS = 4
PPU0_SPRITE_PATTERN_TABLE_ADDRESS = 3
PPU0_ADDRESS_INCREMENT = 2
PPU0_NAMETABLE_ADDRESS1 = 1
PPU0_NAMETABLE_ADDRESS0 = 0

;bit positions for PPU control register $2001
PPU1_FULL_BACKGROUND_COLOR_2 = 7
PPU1_FULL_BACKGROUND_COLOR_1 = 6
PPU1_FULL_BACKGROUND_COLOR_0 = 5
PPU1_COLOR_INTENSITY_2 = 7
PPU1_COLOR_INTENSITY_1 = 6
PPU1_COLOR_INTENSITY_0 = 5
PPU1_SPRITE_VISIBILITY = 4
PPU1_BACKGROUND_VISIBILITY = 3
PPU1_SPRITE_CLIPPING = 2
PPU1_BACKGROUND_CLIPPING = 1
PPU1_DISPLAY_TYPE = 0

  ; ;now let's write a string!
  ; lda #$20
  ; ;at location 13, 10
  ; ora #%00000010
  ; sta $2006
  ; lda #%00001010
  ; sta $2006

.macro set_ppu_2006 nametable, row, column

  lda #nametable
  ;or in the upper two bits of row
  ora #(row >> 3)
  sta $2006
  lda #column
  ;or in the lower three bits of row
  ora #<(row << 5)
  sta $2006

.endmacro
  
.macro set_ppu_2000_bit bit_position

  ;load the current state of the ppu register
  lda ppu_2000
  ora #( 1 << bit_position )
  sta ppu_2000

.endmacro

.macro clear_ppu_2000_bit bit_position

  ;load the current state of the ppu register
  lda ppu_2000
  and #( ~( 1 << bit_position ) )
  sta ppu_2000

.endmacro

.macro set_ppu_2001_bit bit_position

  ;load the current state of the ppu register
  lda ppu_2001
  ora #( 1 << bit_position )
  sta ppu_2001

.endmacro

.macro clear_ppu_2001_bit bit_position

  ;load the current state of the ppu register
  lda ppu_2001
  and #( ~( 1 << bit_position ) )
  sta ppu_2001

.endmacro

.macro upload_ppu_2000

  lda ppu_2000
  sta $2000

.endmacro

.macro upload_ppu_2001

  lda ppu_2001
  sta $2001

.endmacro

.macro waitVBlank

:
  bit $2002
  bpl :-

.endmacro

.endif
