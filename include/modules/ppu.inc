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

.macro waitVBlank

:
  bit $2002
  bpl :-

.endmacro

.endif
