.segment "HEADER"
.byte "NES",$1a        ;iNES header
.byte $02 ;            ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $01 ;            ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
.byte $01 ;            ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #0 (NROM)
.byte $00 ;            ;Rest of Mapper #2 bits (all 0)
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
nomolosScreenX: .res 1
nomolosScreenY: .res 1
nomolosAnim: .res 2

nomolosWalkingRightAND = %11111110
nomolosWalkingLeftOR   = %00000001
nomolosMovingOffAND    = %11111101
nomolosMovingOnOR      = %00000010
nomolosState: .res 1

scrollReact = 120
scrollX:                      .res 2
levelBaseAddress:             .res 2
metametaTileTableBaseAddress: .res 2
metaTileTableBaseAddress:     .res 2

attributeBuffer: .res 8
attributecolumnToUpdate: .res 1

columnTileBuffer:  .res 60
metaTileBuffer:    .res 4
columnToUpdate:    .res 1
nametableToUpdate: .res 1
spriteAddress: .res 1

.segment "STACK"
stack:  .res 256
  
.segment "RAM"
sprite: .res 256

.include "rom0.asm"
  
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

  jsr loadPalette
  jsr clearSprites

  ;set load level state.
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
  
  lda #0
  sta nomolosX
  lda #50
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
;  ldy #19      ;2
;--
;  ldx #$ff      ;2
;-
;  dex           ;2 * 255
;  bne -         ;3 * 254 + 2
;  dey           ;2 * 19
;  bne --        ;3 * 18 + 2

  jmp loop

.include "loadLevelState.asm"
.include "playLevelState.asm"
.include "nomolosLogic.asm"
.include "sprite.asm"
.include "camera.asm"
.include "map.asm"

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

.segment "CHRROM1"  
;Pattern Table
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $88,$99,$33,$66,$44,$44,$cc,$33,$77,$66,$cc,$99,$bb,$bb,$33,$cc
  .byte $cc,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  .byte $00,$01,$03,$06,$04,$44,$cc,$33,$03,$06,$0c,$19,$3b,$3b,$33,$cc
  .byte $80,$80,$30,$60,$44,$44,$cc,$33,$40,$60,$c0,$98,$b8,$ba,$33,$cc

; Here begins the second 4K block.  The sprites get their data from this page.

.segment "CHRROM2"
;Pattern Table
  .byte $00,$01,$02,$04,$08,$10,$21,$60,$00,$00,$01,$03,$07,$0f,$1e,$1f
  .byte $c0,$98,$b0,$d0,$90,$98,$3c,$3e,$00,$00,$00,$20,$60,$60,$d8,$d0
  .byte $00,$00,$01,$02,$04,$08,$10,$21,$00,$00,$00,$01,$03,$07,$0f,$1e
  .byte $00,$80,$90,$b0,$d0,$90,$98,$3c,$00,$00,$00,$00,$20,$60,$60,$d8
  .byte $03,$19,$0d,$0b,$09,$19,$3c,$7c,$00,$00,$00,$04,$06,$06,$1b,$0b
  .byte $00,$80,$40,$20,$10,$08,$84,$06,$00,$00,$80,$c0,$e0,$f0,$78,$f8
  .byte $00,$01,$09,$0d,$0b,$09,$19,$3c,$00,$00,$00,$00,$04,$06,$06,$1b
  .byte $00,$00,$80,$40,$20,$10,$08,$84,$00,$00,$00,$80,$c0,$e0,$f0,$78
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $07,$1c,$2e,$5f,$8c,$c0,$c3,$c7,$00,$03,$1d,$32,$7f,$3f,$3c,$3b
  .byte $e0,$38,$74,$fa,$31,$03,$c3,$e1,$00,$c0,$b8,$4c,$fe,$fc,$3c,$de
  .byte $07,$1c,$2e,$5f,$9e,$cc,$c3,$87,$00,$03,$1d,$32,$73,$3f,$3c,$7b
  .byte $e0,$38,$74,$fa,$79,$33,$c3,$e3,$00,$c0,$b8,$4c,$ce,$fc,$3c,$dc
  .byte $70,$40,$60,$70,$40,$20,$10,$0c,$0f,$3f,$1f,$0f,$3f,$1f,$0f,$03
  .byte $1a,$06,$06,$02,$22,$24,$18,$10,$e4,$f8,$f8,$fc,$dc,$d8,$e0,$e0
  .byte $60,$70,$40,$60,$70,$40,$20,$10,$1f,$0f,$3f,$1f,$0f,$3f,$1f,$0f
  .byte $3e,$1a,$06,$06,$02,$22,$24,$18,$d0,$e4,$f8,$f8,$fc,$dc,$d8,$e0
  .byte $58,$60,$60,$40,$44,$24,$18,$08,$27,$1f,$1f,$3f,$3b,$1b,$07,$07
  .byte $0e,$02,$06,$0e,$02,$04,$08,$30,$f0,$fc,$f8,$f0,$fc,$f8,$f0,$c0
  .byte $7c,$58,$60,$60,$40,$44,$24,$18,$0b,$27,$1f,$1f,$3f,$3b,$1b,$07
  .byte $06,$0e,$02,$06,$0e,$02,$04,$08,$f8,$f0,$fc,$f8,$f0,$fc,$f8,$f0
  .byte $00,$00,$00,$00,$00,$00,$01,$0e,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $6f,$24,$20,$23,$47,$80,$0c,$00,$14,$1b,$1f,$1c,$38,$7f,$f3,$ff
  .byte $f2,$24,$04,$84,$b3,$00,$d8,$3e,$2c,$d8,$f8,$78,$4c,$ff,$27,$c1
  .byte $00,$06,$19,$21,$cd,$09,$09,$0a,$00,$00,$06,$1e,$32,$f6,$f6,$f4
  .byte $00,$60,$98,$84,$b3,$90,$90,$50,$00,$00,$60,$78,$4c,$6f,$6f,$2f
  .byte $4f,$24,$20,$21,$cd,$00,$1b,$7c,$34,$1b,$1f,$1e,$32,$ff,$e4,$83
  .byte $f6,$24,$04,$c4,$e2,$01,$30,$00,$28,$d8,$f8,$38,$1c,$fe,$cf,$ff
  .byte $00,$00,$00,$00,$00,$00,$80,$70,$00,$00,$00,$00,$00,$00,$00,$80
  .byte $07,$07,$08,$10,$32,$22,$32,$22,$00,$00,$07,$0f,$0d,$1d,$0d,$1d
  .byte $e0,$e0,$10,$08,$44,$44,$44,$44,$00,$00,$e0,$f0,$b8,$b8,$b8,$b8
  .byte $0c,$07,$07,$08,$10,$30,$22,$31,$03,$00,$00,$07,$0f,$0f,$1d,$0e
  .byte $10,$e0,$e0,$10,$88,$44,$24,$24,$e0,$00,$00,$e0,$70,$b8,$d8,$d8
  .byte $0c,$07,$07,$08,$10,$31,$22,$32,$03,$00,$00,$07,$0f,$0e,$1d,$0d
  .byte $10,$e0,$e0,$10,$88,$04,$24,$44,$e0,$00,$00,$e0,$70,$f8,$d8,$b8
  .byte $07,$07,$08,$10,$22,$22,$22,$22,$00,$00,$07,$0f,$1d,$1d,$1d,$1d
  .byte $e0,$e0,$10,$08,$4c,$44,$4c,$44,$00,$00,$e0,$f0,$b0,$b8,$b0,$b8
  .byte $08,$07,$07,$08,$11,$22,$24,$24,$07,$00,$00,$07,$0e,$1d,$1b,$1b
  .byte $30,$e0,$e0,$10,$08,$0c,$44,$8c,$c0,$00,$00,$e0,$f0,$f0,$b8,$70
  .byte $08,$07,$07,$08,$11,$20,$24,$22,$07,$00,$00,$07,$0e,$1f,$1b,$1d
  .byte $30,$e0,$e0,$10,$08,$8c,$44,$4c,$c0,$00,$00,$e0,$f0,$70,$b8,$b0
  .byte $10,$21,$4f,$48,$80,$90,$b2,$85,$0f,$1e,$30,$37,$7f,$6f,$4d,$78
  .byte $78,$c1,$09,$c0,$d0,$50,$11,$18,$87,$3e,$f6,$3f,$2f,$af,$ee,$e7
  .byte $01,$00,$80,$6c,$3c,$04,$82,$c0,$fe,$ff,$7f,$93,$c3,$fb,$7d,$3f
  .byte $82,$84,$88,$10,$20,$20,$20,$20,$7c,$78,$70,$e0,$c0,$c0,$c0,$c0
  .byte $41,$21,$11,$08,$04,$04,$04,$04,$3e,$1e,$0e,$07,$03,$03,$03,$03
  .byte $80,$00,$01,$36,$3c,$20,$41,$03,$7f,$ff,$fe,$c9,$c3,$df,$be,$fc
  .byte $1e,$83,$90,$03,$0b,$0a,$88,$18,$e1,$7c,$6f,$fc,$f4,$f5,$77,$e7
  .byte $08,$84,$f2,$12,$01,$09,$4d,$a1,$f0,$78,$0c,$ec,$fe,$f6,$b2,$1e
  .byte $31,$20,$10,$08,$07,$04,$08,$07,$0e,$1f,$0f,$07,$00,$03,$07,$00
  .byte $84,$04,$08,$10,$e0,$18,$04,$f8,$78,$f8,$f0,$e0,$00,$e0,$f8,$00
  .byte $20,$30,$20,$10,$28,$47,$32,$0f,$1f,$0f,$1f,$0f,$17,$38,$0c,$00
  .byte $c4,$04,$76,$09,$01,$e2,$24,$18,$38,$f8,$88,$f6,$fe,$1c,$18,$00
  .byte $21,$30,$20,$20,$20,$43,$31,$0f,$1e,$0f,$1f,$1f,$1f,$3c,$0e,$00
  .byte $84,$04,$06,$09,$11,$e2,$24,$18,$78,$f8,$f8,$f6,$ee,$1c,$18,$00
  .byte $21,$20,$10,$08,$07,$18,$20,$1f,$1e,$1f,$0f,$07,$00,$07,$1f,$00
  .byte $8c,$04,$08,$10,$e0,$20,$10,$e0,$70,$f8,$f0,$e0,$00,$c0,$e0,$00
  .byte $23,$20,$6e,$90,$80,$47,$24,$18,$1c,$1f,$11,$6f,$7f,$38,$18,$00
  .byte $04,$0c,$04,$08,$14,$e2,$4c,$f0,$f8,$f0,$f8,$f0,$e8,$1c,$30,$00
  .byte $21,$20,$60,$90,$88,$47,$24,$18,$1e,$1f,$1f,$6f,$77,$38,$18,$00
  .byte $84,$0c,$04,$04,$04,$c2,$8c,$f0,$78,$f0,$f8,$f8,$f8,$3c,$70,$00
  .byte $98,$61,$06,$09,$09,$08,$08,$07,$60,$00,$01,$06,$06,$07,$07,$00
  .byte $98,$18,$10,$13,$80,$e0,$01,$fe,$67,$e7,$ef,$ec,$7f,$1f,$fe,$00
  .byte $40,$40,$30,$19,$09,$01,$80,$7f,$bf,$bf,$cf,$e6,$f6,$fe,$7f,$00
  .byte $40,$80,$60,$10,$10,$10,$10,$e0,$80,$00,$80,$e0,$e0,$e0,$e0,$00
  .byte $02,$01,$06,$08,$08,$08,$08,$07,$01,$00,$01,$07,$07,$07,$07,$00
  .byte $02,$02,$0c,$98,$90,$80,$01,$fe,$fd,$fd,$f3,$67,$6f,$7f,$fe,$00
  .byte $19,$18,$08,$c8,$01,$07,$80,$7f,$e6,$e7,$f7,$37,$fe,$f8,$7f,$00
  .byte $19,$86,$60,$90,$90,$10,$10,$e0,$06,$00,$80,$60,$60,$e0,$e0,$00

