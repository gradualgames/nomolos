.export initsound, lowc

.segment "CODE"

initsound:
        ; initialize sound hardware
  lda #$01
  sta $4015
  lda #$00
  sta $4001
  lda #$40
  sta $4017
  rts
  
lowc:
  pha
  lda #$84
  sta $4000
  lda #$AA
  sta $4002
  lda #$09
  sta $4003
  pla
  rts