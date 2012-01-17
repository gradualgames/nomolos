.include "zp.inc"
.include "ram.inc"
.include "fixed_bank_data.inc"
.include "mapper.inc"
.include "ppu.inc"
.include "statemanager.inc"
.include "flags.inc"
.include "soundengine.inc"
.include "controller.inc"

.segment "CODE"

;saves the current nmi routine and installs the
;sound updating nmi routine. This must
;be accompanied with an uninstall as well to restore
;the stack
.macro install_ppu_upload_sound_regs_nmi

  ;save current nmi routine
  lda update_ppu
  pha
  lda update_ppu+1
  pha

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_sound_regs_nmi
  sta update_ppu
  lda #>ppu_upload_sound_regs_nmi
  sta update_ppu+1

.endmacro

;restores previous nmi routine
.macro uninstall_ppu_upload_sound_regs_nmi

  ;restore previous nmi routine
  pla
  sta update_ppu+1
  pla
  sta update_ppu

.endmacro

;this nmi routine uploadsa the sound registers and then updates
;the sound engine. This is allowed to bleed outside of vblank since
;we're doing nothing to the PPU. We're using this only in situations
;where we want the sound to continue advancing with precise timing
;while we complete some menial task (like uploading data to the PPU)
.proc ppu_upload_sound_regs_nmi

  ;save regs
  pha
  tya
  pha
  txa
  pha
  
  .ifdef MUSIC_ENABLE
  jsr sound_upload
  jsr sound_update
  .endif

  ;restore regs
  pla
  tax
  pla
  tay
  pla

  rts

.endproc

;fades out, loads the font sheet palette, draws a string
;to the nametable, then fades in and waits a specified
;number of vsyncs
;expects w2 to hold address of string to print. String
;is expected to hold enough spaces to carry to next line
;if required.
;expects b5 to hold the number of vsyncs to count down
;while displaying the text slide.
;uses b6 as a return value for whether or not start was pressed while
;showing the slide (can be optionally used by caller to allow skipping
;of a cut scene sequence)
.proc ppu_show_text_slide
text_address1 = w2
start_was_pressed = b6

  ;make sure start_was_pressed begins as false
  lda #0
  sta start_was_pressed

  ;fade out
  jsr fade_out_palette

  install_ppu_upload_sound_regs_nmi

  ;turn off inc32, we're just loading a nametable in this state
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  ;turn off sprite visibility
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  ;turn off background visibility
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY

  ;the palette is all black, so it is safe to switch the PPU on and
  ;off outside of vblank, we just need to make sure if we start writing
  ;to it after this that it is off.
  upload_ppu_2000
  upload_ppu_2001

  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  jsr ppu_load_palette

  ;switch to PRG block containing font1
  lda font1+font::chr_prg_rom_bank
  sta mapper_bank_next
  jsr mapper_switch_bank

  ;load chr data
  lda font1+font::chr_address
  sta w0
  lda font1+font::chr_address+1
  sta w0+1

  ;set vram address to where we want to load the background chr data
  lda #$00
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

  jsr ppu_load_chr_amount

  ;clear the nametable
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006
  upload_ppu_2006

  lda #26
  sta b0
  lda #0
  sta b1
  jsr ppu_clear_name_table

  ;display string
  set_ppu_2006 $20, 14, 5
  lda w2
  sta w0
  lda w2+1
  sta w0+1
  jsr ppu_display_string
  
  ;reset scroll
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

  uninstall_ppu_upload_sound_regs_nmi

  ;turn sprite and background visibility on
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  ;fade in the palette
  lda #<(font1+font::palette)
  sta w0
  lda #>(font1+font::palette)
  sta w0+1
  jsr fade_in_palette

  ;show the slide for vsyncs vsyncs
  lda b5
  tax

wait_vsyncs_vblanks:
: lda nmi_counter
  bne :-

  .ifdef MUSIC_ENABLE
  jsr sound_update
  .endif

  inc nmi_counter

  jsr controller_read

  lda buffer_controller+buttons::_start
  and #1
  bne start_button_hit

  dex
  bne wait_vsyncs_vblanks

  rts

start_button_hit:

  ;set return flag that start button was pressed
  lda #1
  sta start_was_pressed

  rts

.endproc

; .struct ppu_slide
   ; palette_address .word
   ; nametable_address .word
   ; chr_address .word
   ; vsyncs .byte
   ; bank .byte
; .endstruct

;fades out, loads a palette and nametable graphics, then fades in and
;waits a specified number of vsync's
;expects w2 to hold address of slide parameters
.proc ppu_show_slide
start_was_pressed = b6
slide_address = w2

  ;make sure start_was_pressed begins as false
  lda #0
  sta start_was_pressed

  ;fade out
  jsr fade_out_palette

  ;switch to bank that contains slide data
  ldy #ppu_slide::bank
  lda (w2),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  install_ppu_upload_sound_regs_nmi

  ;turn off inc32, we're just loading a nametable in this state
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  ;turn off sprite visibility
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  ;turn off background visibility
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY

  ;the palette is all black, so it is safe to switch the PPU on and
  ;off outside of vblank, we just need to make sure if we start writing
  ;to it after this that it is off.
  upload_ppu_2000
  upload_ppu_2001

  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  jsr ppu_load_palette

  ;load chr data
  ldy #ppu_slide::chr_address
  lda (w2),y
  sta w0
  iny
  lda (w2),y
  sta w0+1

  lda #$00
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

  jsr ppu_load_chr_amount

  ;load the nametable and attribute table.
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006
  ldy #ppu_slide::nametable_address
  lda (w2),y
  sta w0
  iny
  lda (w2),y
  sta w0+1
  jsr ppu_load_name_table

  ;reset scroll
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

  uninstall_ppu_upload_sound_regs_nmi

  ;turn sprite and background visibility on
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  ;load palette
  ldy #ppu_slide::palette_address
  lda (w2),y
  sta w0
  iny
  lda (w2),y
  sta w0+1

  ;fade in
  jsr fade_in_palette

  ;show the slide for vsyncs vsyncs
  ldy #ppu_slide::vsyncs
  lda (w2),y
  tax

wait_vsyncs_vblanks:
: lda nmi_counter
  bne :-

  .ifdef MUSIC_ENABLE
  jsr sound_update
  .endif

  inc nmi_counter

  jsr controller_read

  lda buffer_controller+buttons::_start
  and #1
  bne start_button_hit

  dex
  bne wait_vsyncs_vblanks

  rts

start_button_hit:

  ;set return flag that start button was pressed
  lda #1
  sta start_was_pressed

  rts

.endproc

;Copies a rectangular region of tile numbers to buffer_rectangle in zp,
;and buffer_rectangle_x, buffer_rectangle_y, buffer_rectangle_width,
;buffer_rectangle_height, ready to b uploaded by ppu_upload_rectangular_region.
;expects b0 and b1 to contain the x and y coordinate, and w0 to contain the
;address of the region to draw.
.proc ppu_draw_rectangular_region
region_width = buffer_rectangle_width
region_height = buffer_rectangle_height
tile_index = b4

  ;save x
  txa
  pha

  ;store x and y coordinate
  lda b0
  sta buffer_rectangle_x
  lda b1
  sta buffer_rectangle_y
  
  ;get width of region
  ldy #0
  lda (w0),y
  sta region_width
  beq do_not_draw
  ;get height of region
  iny
  lda (w0),y
  sta region_height
  beq do_not_draw
  iny
  
  lda #2
  sta tile_index
  
  ;start copying region to buffer
  ldy region_height
row_loop:
  
  ldx region_width
column_loop:
  
  ;save y
  tya
  pha
  
  ldy tile_index
  
  ;get tile value
  lda (w0),y
  
  ;y is 2 ahead of where we need to be. store the tile value in the buffer.
  sta buffer_rectangle-2,y
  
  ;restore y
  pla
  tay
  
  ;next tile.
  inc tile_index
  
  dex
  bne column_loop
  
  dey
  bne row_loop
do_not_draw:
  
  ;restore x
  pla
  tax
  
  rts
.endproc

;Uploads buffer_rectangle to the ppu using buffer_rectangle_x, buffer_rectangle_y
;buffer_rectangle_width and buffer_rectangle_height as parameters.
.proc ppu_upload_rectangular_region
row = b0
column = b1
buffer_index = b2

  ;load top left of rectangle
  lda buffer_rectangle_y
  sta row
  lda buffer_rectangle_x
  sta column
  
  ;point VRAM at first row
  set_ppu_2006_abs name_table_to_view, row, column
  upload_ppu_2006
  
  ;start at beginning of buffer
  lda #0
  sta buffer_index

  ldy buffer_rectangle_height
  beq do_not_draw
row_loop:

  ldx buffer_rectangle_width
  beq do_not_draw
column_loop:

  ;save x
  txa
  pha
  
  ;get buffer index
  ldx buffer_index
  
  ;store next tile value in VRAM
  lda buffer_rectangle,x
  sta $2007
  
  inc buffer_index
  
  ;restore x
  pla
  tax

  dex
  bne column_loop
  
  ;point VRAM at next row
  clc
  lda ppu_2006+1
  adc #%00100000
  sta ppu_2006+1
  lda ppu_2006
  adc #0
  sta ppu_2006
  upload_ppu_2006
  
  dey
  bne row_loop

do_not_draw:
  lda #0
  sta buffer_rectangle_width
  sta buffer_rectangle_height
  
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

  ;save x
  txa
  pha

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
  
  ;restore x
  pla
  tax

  rts

return_black:

  lda #$0d
  sta color
  
  ;restore x
  pla
  tax

  rts

.endproc

;wrapper for below function to allow entities to call from separate bank
.proc ppu_load_dynamic_palette_brightness_preserve_calling_bank

  ;switch to the level and music bank
  lda mapper_bank_current  ;save current bank
  pha
  ldy #level_data_struct::level_music_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  jsr ppu_load_dynamic_palette_brightness
  
  ;restore previous bank
  pla
  sta mapper_bank_next
  jsr mapper_switch_bank
  
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
