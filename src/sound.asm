.include "constants.inc"
.include "flags.inc"
.include "structs.inc"
.include "famitracker.inc"
.include "zp.inc"

.segment "CODE"

blankSound:
  .byte $ff

;fast forwards to the end of the current sound to ensure channel enable/disable commands
;are read before the next sound is played.
.export finishSound
.proc finishSound

  ;save x (entities use this)
  txa
  pha

  ;load current sound offset
  ldy soundOff
keepFinishing:
  ;load command
  lda (soundAddr),y
  ;at end?
  cmp #$ff
  beq soundFinished
  ;is this an enable command? Make sure to run it
  cmp #ENABLE_FAMITRACKER_CHANNEL
  bne enableCommandNotFoundYet
  ;move on to channel value
  iny
  lda (soundAddr),y
  ;move back to command index
  dey
  ;re-enable that channel
  .ifdef MUSIC_ENABLE
  tax
  jsr ft_enable_channel
  .endif
  
enableCommandNotFoundYet:

  ;move on to next entry
  iny
  iny
  ;keep looking for channel enable commands
  jmp keepFinishing
  
soundFinished:

  sty soundOff

  ;restore x (entities use this)
  pla
  tax
  
  rts

.endproc
  
.export playSound
.proc playSound

  ;load current sound offset
  ldy soundOff
  ;load x with the offset from $4000 (or famitracker channel command)
  lda (soundAddr),y
  
  tax
  ;see if we're at the end of the sound
  cpx #$ff
  ;quit if so
  beq soundDone
  ;if it wasn't -1, we have a register offset or a command.
  
  ;test for "disable famitracker channel" command, which is defined as $20
  cmp #DISABLE_FAMITRACKER_CHANNEL
  bne @notDisable
  
  ;point to the next byte
  iny
  
  ;grab the value
  lda (soundAddr),y
  .ifdef MUSIC_ENABLE
  tax
  jsr ft_disable_channel
  .endif
  
  ;point to the next entry in the sound
  iny
  sty soundOff
  
  jmp soundDone
@notDisable:
  cmp #ENABLE_FAMITRACKER_CHANNEL
  bne @notEnable
  
  ;point to the next byte
  iny
  
  ;grab the value
  lda (soundAddr),y
  .ifdef MUSIC_ENABLE
  tax
  jsr ft_enable_channel
  .endif
  
  ;point to the next entry in the sound
  iny
  sty soundOff
  
  jmp soundDone
@notEnable:

  ;point to the next byte
  iny

  ;grab the value
  lda (soundAddr),y
  
  ;stuff the value into the sound register
  sta $4000,x

  ;point to the next entry in the sound
  iny
  sty soundOff

soundDone:

  rts
  
.endproc

;finishes the current sound if there is one and
;loads a new sound into the sound address.
;w0 = address of sound to load
.export loadSound
.proc loadSound

  jsr finishSound
  lda w0
  sta soundAddr
  lda w0+1
  sta soundAddr+1
  lda #0
  sta soundOff  

  rts

.endproc

.export initsound
.proc initsound
        ; initialize sound hardware
  lda #$01
  sta $4015
  lda #$00
  sta $4001
  lda #$40
  sta $4017
  
  ;make sure the sound effect system is playing nothing at first
  lda #<blankSound
  sta soundAddr
  lda #>blankSound
  sta soundAddr+1
  lda #$00
  sta soundOff
  rts
  
.endproc
  
.export lowc
.proc lowc
  pha
  lda #$84
  sta $4000
  lda #$AA
  sta $4002
  lda #$09
  sta $4003
  pla
  rts
  
.endproc
