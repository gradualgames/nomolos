.include "constants.inc"
.include "macros.inc"
.include "flags.inc"
.include "structs.inc"

;ROM labels

.import ROMDefinitionTable0
.import ROMDefinitionTable1
.import ft_music_addr

;camera module
.import resetCamera

;nomolosLogic module
.import initNomolos

;state labels
.import loadLevelUpdatePPU, loadLevelUpdate, clearSprites

;entity module
.import initEntities

;sound module
.import initsound, playSound

;global variables/RAM labels
.exportzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5, vblankDone, update
.exportzp update, updatePPU, attributeBuffer, attributeColumnToUpdate
.exportzp columnTileBuffer, columnToUpdate, nametableToUpdate
.exportzp levelBaseAddress, metaTileBuffer, metaTileTableBaseAddress
.exportzp entityDefinitionTableBaseAddress, romDefinitionTableBaseAddress
.exportzp metametaTileTableBaseAddress, nomolosAnim
.exportzp nomolosScreenX, nomolosScreenY, nomolosState
.exportzp nomolosHealth, nomolosBlinkCounter, nomolosHitboxCounter
.exportzp nomolosAbovePenetrationDistance, nomolosBelowPenetrationDistance
.exportzp nomolosX, nomolosY, nomolosXSpeed, nomolosYSpeed, spriteAddress
.exportzp nomolosHitboxXOffset, nomolosHitboxYOffset
.exportzp scrollX, nextScrollX
.exportzp controllerBuffer
.exportzp soundAddr, soundOff
.export stack, sprite, entityPool

;update return labels
.export updatePPUFinished, updateFinished

.segment "HEADER"
.byte "NES",$1a        ;iNES header
.byte $04 ;            ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $01 ;            ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
.byte $11 ;            ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #1 (MMC1)
.byte $00 ;            ;Rest of Mapper #0 bits (all 0)
.byte 0,0,0,0,0,0,0,0  ; pad header to 16 bytes
.segment "ZEROPAGE"
b0:       .res 1
b1:       .res 1
b2:       .res 1
b3:       .res 1
b4:       .res 1
b5:       .res 1
w0:       .res 2
w1:       .res 2
w2:       .res 2
w3:       .res 2
w4:       .res 2
w5:       .res 2

buttonA:     .res 1
vblankDone:  .res 1

update:     .res 2
updatePPU:  .res 2

nomolosX: .res 3  ;24 bit x (16 bit coord + 8 bit fine movement)
nomolosY: .res 2  ;16 bit y (8 bit coord + 8 bit fine movement)
nomolosXSpeed: .res 2
nomolosYSpeed: .res 2
nomolosScreenX: .res 1
nomolosScreenY: .res 1
nomolosHitboxXOffset: .res 1
nomolosHitboxYOffset: .res 1
nomolosBelowPenetrationDistance: .res 1
nomolosAbovePenetrationDistance: .res 1
nomolosAnim: .res 2
nomolosBlinkCounter: .res 1
nomolosHitboxCounter: .res 1
nomolosState: .res 1
nomolosHealth: .res 1

scrollX:                           .res 2
nextScrollX:                       .res 2
levelBaseAddress:                  .res 2
metametaTileTableBaseAddress:      .res 2
metaTileTableBaseAddress:          .res 2
entityDefinitionTableBaseAddress:  .res 2
romDefinitionTableBaseAddress: .res 2

attributeBuffer: .res 8
attributeColumnToUpdate: .res 1

columnTileBuffer:  .res 60
metaTileBuffer:    .res 4
columnToUpdate:    .res 1
nametableToUpdate: .res 1
spriteAddress: .res 1

controllerBuffer: .res 8

soundAddr: .res 2
soundOff: .res 1

.segment "STACK"
stack:  .res 256
  
.segment "BSS"
sprite: .res 256

entityPool: .res 256

;FamiTracker driver must be included here so its variables come after the sprite
;page and entity page. This avoids clobbering graphics/sound memory.
.include "driver.s"
.export ft_enable_channel, ft_disable_channel

.segment "CODE"

reset:
  sei
  cld
  ldx #$FF
  txs
  inx
  stx $2001

:
  bit $2002
  bpl :-
:
  bit $2002
  bpl :-

:
  lda #$00
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne :-

  ; initialize the MMC1 mapper...
  ;reset the PRG rom control register...
  lda #%10000000
  sta $8000

;  $8000-9FFF:  [...C PSMM]
;    C = CHR Mode (0=8k mode, 1=4k mode)
;    P = PRG Size (0=32k mode, 1=16k mode)
;    S = Slot select:
;        0 = $C000 swappable, $8000 fixed to page $00 (mode A)
;        1 = $8000 swappable, $C000 fixed to page $0F (mode B)
;        This bit is ignored when 'P' is clear (32k mode)
;    M = Mirroring control:
;        %00 = 1ScA
;        %01 = 1ScB
;        %10 = Vert
;        %11 = Horz  
  lda #%00011110
  sta $8000
  lsr
  sta $8000
  lsr
  sta $8000
  lsr
  sta $8000
  lsr
  sta $8000

  ;reset the first CHR rom control register
  lda #%10000000
  sta $A000

  ;reset the second CHR rom control register, then load bank 1 from $1000?
  lda #%10000000
  sta $C000
  lda #$01
  sta $C000
  sta $C000
  sta $C000
  sta $C000
  sta $C000
  
  ;reset the PRG rom control register, then load bank 0
  lda #%10000000
  sta $E000
  lda #%00000000
  sta $E000
  lsr
  sta $E000
  lsr
  sta $E000
  lsr
  sta $E000
  lsr
  sta $E000  
  
  loadLevel ROMDefinitionTable1
  jsr initsound
  jsr loadPalette
  jsr clearSprites
  jsr initEntities
  jsr initNomolos  
  jsr resetCamera  
  switchState loadLevelUpdate, loadLevelUpdatePPU

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
;  lda #%00011110
;  sta $2001
  lda #%00000000
  sta $2001

  ;initialize music driver as NTSC and track #0.
.if .defined(MUSIC_ENABLE)
  lda #0
  ldx #0
  jsr ft_music_init
.endif
  
loop:

  jmp (update)

updateFinished:

  jmp loop

loadPalette:
  ldy #ROMDefinitionTableStruct::palette
  lda (romDefinitionTableBaseAddress),y
  sta w0
  iny
  lda (romDefinitionTableBaseAddress),y
  sta w0+1
  ldy #0
  lda #$3F
  ldx #$00
  sta $2006
  stx $2006
: lda (w0),y
  sta $2007
  inx
  iny
  cpx #$20
  bne :-
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

  .ifdef MUSIC_ENABLE
  jsr ft_music_play
  .endif
  jsr playSound

  plp
  pla
  tay
  pla
  tax
  pla

irq:
  rti
  
.segment "VECTORS"
  .word vblank
  .word reset
  .word irq

