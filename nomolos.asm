.include "constants.inc"

;ROM labels
.import palette, MetaTileTable, MetaMetaTileTable, Level, EntityDefinitionTable

;state labels
.import loadLevelUpdatePPU, loadLevelUpdate, clearSprites

;entity module
.import initEntities

;sound module
.import initsound

;global variables/RAM labels
.exportzp b0, b1, b2, b3, b4, b5, w0, w1, w2, w3, w4, w5, vblankDone, update
.exportzp update, updatePPU, attributeBuffer, attributeColumnToUpdate
.exportzp columnTileBuffer, columnToUpdate, nametableToUpdate
.exportzp levelBaseAddress, metaTileBuffer, metaTileTableBaseAddress
.exportzp entityDefinitionTableBaseAddress
.exportzp metametaTileTableBaseAddress, nomolosAnim
.exportzp nomolosScreenX, nomolosScreenY, nomolosState
.exportzp nomolosAbovePenetrationDistance, nomolosBelowPenetrationDistance
.exportzp nomolosX, nomolosY, nomolosXSpeed, nomolosYSpeed, spriteAddress
.exportzp scrollX, nextScrollX
.exportzp controllerBuffer
.export stack, sprite, entityPool

;update return labels
.export updatePPUFinished, updateFinished

.segment "HEADER"
.byte "NES",$1a        ;iNES header
.byte $02 ;            ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $01 ;            ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
.byte $01 ;            ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #0 (NROM)
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
nomolosBelowPenetrationDistance: .res 1
nomolosAbovePenetrationDistance: .res 1
nomolosAnim: .res 2

nomolosState: .res 1

scrollX:                           .res 2
nextScrollX:                       .res 2
levelBaseAddress:                  .res 2
metametaTileTableBaseAddress:      .res 2
metaTileTableBaseAddress:          .res 2
entityDefinitionTableBaseAddress:  .res 2

attributeBuffer: .res 8
attributeColumnToUpdate: .res 1

columnTileBuffer:  .res 60
metaTileBuffer:    .res 4
columnToUpdate:    .res 1
nametableToUpdate: .res 1
spriteAddress: .res 1

controllerBuffer: .res 8

.segment "STACK"
stack:  .res 256
  
.segment "RAM"
sprite: .res 256
;The following is the entity pool. All entities are treated as chunks of
;16 bytes from this pool with the following schema:
;.dsb alive = 1
;.dsb index = definition index (this is a parameter)
;.dsw spawnPositionX = initialXOffset + x
;.dsb spawnPositionY = initialYOffset + y
;.dsb positionXFine  = unknown, this is expected to be used (or not used) by the entity
;.dsw positionX      = x (this is a parameter)
;.dsb positionYFine  = unknown, this is expected to be used (or not used) by the entity
;.dsb positionY      = y (this is a parameter)
;.dsb state          = initialState
;.dsw animationObject  = unknown, this expected to be set by the entity
;.dsb 3 ;padding to 16 bytes

entityPool: .res 256

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

  jsr initsound
  jsr loadPalette
  jsr clearSprites

  ;set load level state.
  jsr initEntities  ;kill all entities
  lda #0
  sta nextScrollX
  sta nextScrollX+1
  lda #1
  sta nomolosAnim
  lda #0
  sta nomolosAnim+1
  lda #0
  and #nomolosWalkingRightAND  
  sta nomolosState
  lda #0
  sta nomolosXSpeed
  lda #2
  sta nomolosXSpeed+1
  lda #$00
  sta nomolosYSpeed
  lda #$00
  sta nomolosYSpeed+1
  
  
  lda #0
  sta nomolosX
  lda #120
  sta nomolosX+1
  lda #0
  sta nomolosX+2
  
  lda #0
  sta nomolosY
  lda #90
  sta nomolosY+1
    
  
  lda #<Level
  sta levelBaseAddress
  lda #>Level
  sta levelBaseAddress+1
  lda #<MetaMetaTileTable
  sta metametaTileTableBaseAddress
  lda #>MetaMetaTileTable
  sta metametaTileTableBaseAddress+1
  lda #<MetaTileTable
  sta metaTileTableBaseAddress
  lda #>MetaTileTable
  sta metaTileTableBaseAddress+1
  lda #<EntityDefinitionTable
  sta entityDefinitionTableBaseAddress
  lda #>EntityDefinitionTable
  sta entityDefinitionTableBaseAddress+1
  

  lda #$00
  sta scrollX
  lda #$00
  sta scrollX+1
  lda #$00
  sta columnToUpdate

  lda #<loadLevelUpdate
  sta update
  lda #>loadLevelUpdate
  sta update+1
  lda #<loadLevelUpdatePPU
  sta updatePPU
  lda #>loadLevelUpdatePPU
  sta updatePPU+1

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

loop:

  jmp (update)

updateFinished:

;the following loops are used to measure how much time we have left in the main loop.
;  ldy #17      ;2
;:
;  ldx #$ff      ;2
;:
;  dex           ;2 * 255
;  bne :-         ;3 * 254 + 2
;  
;  dey           ;2 * 17
;  bne :--        ;3 * 16 + 2

  jmp loop


loadPalette:
  lda #$3F
  ldx #$00
  sta $2006
  stx $2006
: lda palette,x
  sta $2007
  inx
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

  ;the following loops are meant to measure how many cycles we have left to use for vblank
;  ldy #20      ;2
;--
;  ldx #$ff      ;2
;-
;  dex           ;2 * 255
;  bne -         ;3 * 254 + 2
;  dey           ;2 * 19
;  bne --        ;3 * 18 + 2

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

