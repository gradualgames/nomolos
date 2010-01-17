.include "constants.inc"
.include "macros.inc"
.include "flags.inc"
.include "structs.inc"

;ROM labels
.import ROMDefinitionTable0
.import ROMDefinitionTable1

;camera module
.import resetCamera

;nomolosLogic module
.import initNomolos

;state labels
.import loadLevelUpdatePPU, loadLevelUpdate, clearSprites
.import levelInUpdate, levelInPPUUpdate
.import titleStateUpdate, titleStateUpdatePPU

;entity module
.import initEntities

;sound module
.import initsound, playSound

;global variables/RAM labels
.exportzp b0, b1, b2, b3, b4, b5, b6, b7, b8, b9
.exportzp w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, vblankDone
.exportzp stringBuffer
.exportzp stateControl
.exportzp update, updatePPU, attributeBuffer, attributeColumnToUpdate
.exportzp columnTileBuffer, columnToUpdate, nametableToUpdate
.exportzp levelBaseAddress, metaTileBuffer, metaTileTableBaseAddress
.exportzp entityDefinitionTableBaseAddress, romDefinitionTableBaseAddress
.exportzp metametaTileTableBaseAddress
.exportzp currentLevel
.exportzp nomolosAnim, nomolosScreenX, nomolosScreenY, nomolosState
.exportzp nomolosHealth, nomolosBlinkCounter, nomolosHitboxCounter
.exportzp nomolosAbovePenetrationDistance, nomolosBelowPenetrationDistance
.exportzp nomolosX, nomolosY, nomolosXSpeed, nomolosYSpeed, spriteAddress
.exportzp nomolosHitboxX, nomolosHitboxY
.exportzp nomolosScaredyCatX, nomolosScaredyCatY
.exportzp nomolosLives
.exportzp scrollX, nextScrollX
.exportzp controllerBuffer
.exportzp soundAddr, soundOff
.exportzp paletteStep, frameCounter
.exportzp ft_music_addr
.export stack, sprite, entityPool

;misc
.export loadPalette, loadNametable, clearNametable
.export displayString, createDecimalString

;misc data
.export haltmusic
.export font1, powerTable
.export livesString, levelString, gameOverString
.export LevelDefinitionTable
.export titlePalette, titleNametable, titleChrRomBank

;update return labels
.export updatePPUFinished, updateFinished

.segment "HEADER"
.byte "NES",$1a        ;iNES header
.byte $04 ;            ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $04 ;            ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
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
b6:       .res 1
b7:       .res 1
b8:       .res 1
b9:       .res 1
w0:       .res 2
w1:       .res 2
w2:       .res 2
w3:       .res 2
w4:       .res 2
w5:       .res 2
w6:       .res 2
w7:       .res 2
w8:       .res 2
w9:       .res 2

stringBuffer: .res 8

vblankDone:  .res 1

update:     .res 2
updatePPU:  .res 2
stateControl: .res 16

nomolosX: .res 3  ;24 bit x (16 bit coord + 8 bit fine movement)
nomolosY: .res 3  ;24 bit y (16 bit coord + 8 bit fine movement)
nomolosXSpeed: .res 2
nomolosYSpeed: .res 2
nomolosScreenX: .res 2
nomolosScreenY: .res 2
nomolosHitboxX: .res 2
nomolosHitboxY: .res 2
;the following two variables occupy the same location as the hit box, because
;the hit box will not be used while nomolos is dying.
nomolosScaredyCatX = nomolosHitboxX
nomolosScaredyCatY = nomolosHitboxY
nomolosBelowPenetrationDistance: .res 1
nomolosAbovePenetrationDistance: .res 1
nomolosAnim: .res 2
nomolosBlinkCounter: .res 1
nomolosHitboxCounter: .res 1
nomolosState: .res 1
nomolosHealth: .res 1
nomolosLives: .res 1

scrollX:                           .res 2
nextScrollX:                       .res 2
levelBaseAddress:                  .res 2
metametaTileTableBaseAddress:      .res 2
metaTileTableBaseAddress:          .res 2
entityDefinitionTableBaseAddress:  .res 2
romDefinitionTableBaseAddress: .res 2
currentLevel:                      .res 1

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

ft_music_addr: .res 2

;variables specific to level out state
paletteStep: .res 1
frameCounter: .res 1

.segment "STACK"
stack:  .res 256
  
.segment "BSS"
sprite: .res 256

entityPool: .res 256

;FamiTracker driver must be included here so its variables come after the sprite
;page and entity page. This avoids clobbering graphics/sound memory.
.include "driver.s"
.export ft_enable_channel, ft_disable_channel
.export ft_music_init, ft_music_play

.segment "CODE"

.macro initMMC1

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

.endmacro
  
.macro initNES

  sei
  cld
  ldx #$FF
  txs
  inx
  stx $2001

  waitVBlank
  waitVBlank

.endmacro

.macro clearRAM

  lda #$00
:
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne :-

.endmacro

reset:
  initNES
  clearRAM
  initMMC1

  lda #TITLESTATE_INIT
  sta stateControl+titleStateControl::state
  switchState titleStateUpdate, titleStateUpdatePPU
  
loop:

  jmp (update)

updateFinished:

  jmp loop

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
displayString:
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
  
;loads a nametable and attribute table located at address in w0
;assumes VRAM points to the nametable that is to be loaded
loadNametable:
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
  
;expects VRAM to already be pointing to the nametable we want to clear.
;input: b0 - value to clear nametable with
;       b1 - value to clear attribute table with
clearNametable:

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
  
;expects w0 to have address of palette
loadPalette:
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
  
;level definitions
LevelDefinitionTable:
Level1:
  .byte $00, $01, $00
  .word ROMDefinitionTable0
  .byte $00, $00, $00  ;pad to 8 bytes. this may be used eventually anyway (music track for example)
Level2:
  .byte $02, $03, $01
  .word ROMDefinitionTable1
  .byte $00, $00, $00
  
;miscellaneous data
haltmusic:
.incbin "haltmusic.bin"

font1:
  .byte $04
  .byte $35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e
  .byte $0d,$20,$0d,$0d,$0d,$00,$00,$00,$0d,$00,$00,$00,$0d,$00,$00,$00
  .byte $0d,$20,$0d,$0d,$0d,$00,$00,$00,$0d,$00,$00,$00,$0d,$00,$00,$00

;table of decimal powers for creating decimal strings from 8 bit numbers
powerTable:
  .byte 100, 10, 1
  
levelString:
  .byte $06,$26,$04,$15,$04,$0b,$1a

livesString:
  .byte $06,$26,$08,$15,$04,$12,$1a
  
gameOverString:
  .byte $09,$21,$1b,$27,$1f,$1a,$29,$30,$1f,$2c
  
titleChrRomBank:
  .byte $06
  
titlePalette:
;Palette
  .byte $01,$0d,$27,$2a,$01,$27,$0d,$04,$01,$0d,$04,$10,$01,$0d,$10,$27
  .byte $01,$0d,$27,$2a,$01,$27,$0d,$04,$01,$0d,$04,$10,$01,$0d,$10,$27
  
titleNametable:
;Name Table
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$01,$02,$03,$04,$00,$00,$00,$00,$00,$05,$06,$07,$08,$09,$0a,$07,$0b,$0c,$0d,$0e,$0f,$10,$0d,$00,$11,$12,$13,$14,$15,$16
  .byte $00,$00,$17,$18,$19,$1a,$1b,$1b,$1b,$1c,$00,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$00,$2b,$2c,$2d,$2e,$2f,$30
  .byte $00,$31,$32,$33,$34,$35,$36,$36,$36,$37,$38,$1d,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c
  .byte $4d,$4e,$4f,$50,$36,$36,$36,$36,$36,$36,$36,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5e,$5f,$60,$61,$62,$5e,$63
  .byte $64,$65,$66,$36,$36,$67,$68,$69,$6a,$6b,$6c,$6d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $6e,$6f,$36,$36,$36,$70,$6f,$71,$72,$73,$74,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $6e,$6f,$36,$36,$36,$75,$6f,$6f,$6f,$6f,$75,$76,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $77,$78,$36,$36,$36,$75,$75,$75,$79,$7a,$75,$75,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $7b,$7c,$36,$36,$36,$7d,$7d,$7e,$7f,$80,$81,$82,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $83,$84,$85,$86,$36,$36,$36,$36,$87,$87,$87,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $88,$89,$8a,$7b,$36,$36,$36,$36,$8b,$8c,$8d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $8e,$8e,$8f,$90,$91,$92,$93,$91,$94,$95,$96,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$7c,$6f,$33,$7c,$75,$98,$99,$00,$00,$00,$00,$00,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$7c,$6f,$33,$7c,$6f,$6f,$a5,$00,$00,$00,$00,$00,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$7c,$6f,$33,$7c,$6f,$6f,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$b1,$b2,$50,$7c,$6f,$6f,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$97,$33,$b3,$6c,$b4,$7c,$6f,$6f,$a5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$b5,$94,$b6,$19,$b7,$b8,$b9,$ba,$bb,$bc,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $4d,$bd,$75,$be,$bf,$c0,$36,$36,$36,$c1,$c2,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $7b,$19,$79,$c3,$c4,$68,$68,$68,$c5,$c6,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $c7,$c8,$c9,$ca,$cb,$6f,$6f,$6f,$cc,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $cd,$75,$cc,$00,$cb,$6f,$6f,$6f,$ce,$cf,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $d0,$d1,$8a,$00,$cb,$6f,$6f,$6f,$d2,$d3,$d4,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $d5,$8e,$00,$00,$cb,$d6,$d6,$d6,$d6,$d7,$d8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$d9,$8e,$8e,$8e,$8e,$8e,$da,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;Attribute Table
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ab,$3f,$cf,$ff,$ff,$ff,$ff,$ff
  .byte $ee,$f3,$fc,$ff,$ff,$ff,$ff,$ff
  .byte $fe,$ff,$a5,$ff,$0f,$0f,$0f,$ff
  .byte $ff,$ff,$ff,$ff,$f0,$f0,$f0,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
  
.segment "VECTORS"
  .word vblank
  .word reset
  .word irq