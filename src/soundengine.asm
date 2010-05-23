.linecont +
.include "soundengine.inc"
.include "sounds.inc"

.segment "ZEROPAGE"
sound_local_byte_0: .res 1
sound_local_byte_1: .res 1
sound_local_byte_2: .res 1

sound_local_word_0: .res 2
sound_local_word_1: .res 2
sound_local_word_2: .res 2

sound_param_byte_0: .res 1
sound_param_byte_1: .res 1
sound_param_byte_2: .res 1

sound_param_word_0: .res 2
sound_param_word_1: .res 2
sound_param_word_2: .res 2

stream_byte: .res 1

apu_data_ready: .res 1
apu_square_1_old: .res 1
apu_square_2_old: .res 1

.segment "BSS"

streams: .res stream_size*MAX_STREAMS

;five total channels, 4 bytes per channel, so 40 bytes.
apu_register_sets: .res 40

.segment "CODE"

.proc sound_initialize

  ;enable square 1, square 2, triangle and noise
  lda #%00001111
  sta $4015

  lda #0
  sta apu_data_ready
  jsr sound_initialize_apu_buffer

  rts

.endproc

;kill all active streams and halt sound
.proc sound_stop

  ;kill all streams
  ldx #0
loop:

  lda #0
  sta streams+stream::active,x
  
  txa
  clc
  adc #stream_size
  tax
  cpx #stream_size*MAX_STREAMS
  bne loop  

  jsr sound_initialize_apu_buffer
  
  rts
.endproc

.proc sound_update

  ;apu data not ready
  lda #0
  sta apu_data_ready
  
  ;copy all streams' register sets to apu registers for upload
  ldx #0
stream_register_copy_loop:

  ;load whether this stream is active
  lda streams+stream::active,x
  beq stream_not_active

  ;update the stream
  jsr stream_update
  
  ;load channel number
  lda streams+stream::channel,x
  ;multiply by four to get location within apu_register_sets
  asl
  asl
  tay
  ;copy the registers over
  lda streams+stream::channel_registers,x
  sta apu_register_sets,y
  lda streams+stream::channel_registers+1,x
  sta apu_register_sets+1,y
  lda streams+stream::channel_registers+2,x
  sta apu_register_sets+2,y
  lda streams+stream::channel_registers+3,x
  sta apu_register_sets+3,y
stream_not_active:
  
  txa
  clc
  adc #stream_size
  tax
  cpx #stream_size*MAX_STREAMS
  bne stream_register_copy_loop
  
  ;apu data ready
  lda #1
  sta apu_data_ready

  rts
.endproc

; Note table borrowed from freq_ntsc.bin provided with Famitracker's driver.
.define note_table \
             $07f2, $077f, $0714, $06ae, $064e, $05f3, $059e, \
      $054d, $0501, $04b9, $0475, $0435, $03f9, $03bf, $038a, \
      $0357, $0327, $02f9, $02cf, $02a6, $0280, $025c, $023a, \
      $021a, $01fc, $01df, $01c5, $01ab, $0193, $017c, $0167, \
      $0153, $0140, $012e, $011d, $010d, $00fe, $00ef, $00e2, \
      $00d5, $00c9, $00be, $00b3, $00a9, $00a0, $0097, $008e, \
      $0086, $007f, $0077, $0071, $006a, $0064, $005f, $0059, \
      $0054, $0050, $004b, $0047, $0043, $003f, $003b, $0038, \
      $0035, $0032, $002f, $002c, $002a, $0028, $0025, $0023, \
      $0021, $001f, $001d, $001c, $001a, $0019, $0017, $0016, \
      $0015, $0014, $0012, $0011, $0010, $000f, $000e, $000e

;these were the first 9 values in Famitracker's table. I'm not sure what
;they are, but they don't seem to be note values! Perhaps they are for the
;noise channel. Not sure.
;      $0d5c, $0c9c, $0be7, $0b3c, $0a9b, $0a02, $0972, $08eb, \
;      $086a,
      
; ;Note table originally created by Celius, transcribed to the following table by MetalSlime. Thanks guys!
; .define note_table \
                                                                     ; $07F1, $0780, $0713, \
      ; $06AD, $064D, $05F3, $059D, $054D, $0500, $04B8, $0475, $0435, $03F8, $03BF, $0389, \
      ; $0356, $0326, $02F9, $02CE, $02A6, $027F, $025C, $023A, $021A, $01FB, $01DF, $01C4, \
      ; $01AB, $0193, $017C, $0167, $0151, $013F, $012D, $011C, $010C, $00FD, $00EF, $00E2, \
      ; $00D2, $00C9, $00BD, $00B3, $00A9, $009F, $0096, $008E, $0086, $007E, $0077, $0070, \
      ; $006A, $0064, $005E, $0059, $0054, $004F, $004B, $0046, $0042, $003F, $003B, $0038, \
      ; $0034, $0031, $002F, $002C, $0029, $0027, $0025, $0023, $0021, $001F, $001D, $001B, \
      ; $001A, $0018, $0017, $0015, $0014, $0013, $0012, $0011, $0010, $000F, $000E, $000D, \
      ; $000C, $000C, $000B, $000A, $000A, $0009, $0008                                     
  
note_table_lo: .lobytes note_table
note_table_hi: .hibytes note_table

.define channel_callback_table \
  square_1_play_note, \
  square_2_play_note, \
  triangle_play_note, \
  noise_play_note
  
channel_callback_table_lo: .lobytes channel_callback_table
channel_callback_table_hi: .hibytes channel_callback_table

.define stream_callback_table \
  stream_set_length, \
  stream_set_volume_envelope, \
  stream_set_pitch_envelope, \
  stream_set_duty_envelope, \  
  stream_goto, \
  stream_terminate
  
stream_callback_table_lo: .lobytes stream_callback_table
stream_callback_table_hi: .hibytes stream_callback_table

  ;****************************************************************
  ;these callbacks are all note playback and only execute once per
  ;frame.
  ;****************************************************************

.proc square_1_play_note

  ;set negate flag for sweep unit
  lda #$08
  sta streams+stream::channel_registers+1,x

  ;load note index
  ldy stream_byte
  
  ;load low byte of note
  lda note_table_lo,y
  ;store in low 8 bits of pitch
  sta streams+stream::channel_registers+2,x
  ;load high byte of note
  lda note_table_hi,y
  sta streams+stream::channel_registers+3,x
  
  ;load volume index
  lda streams+stream::volume_index,x
  tay
  ;load volume address
  lda volume_envelopes_lo,y
  sta sound_local_word_0
  lda volume_envelopes_hi,y
  sta sound_local_word_0+1
  ;load volume offset
  ldy streams+stream::volume_offset,x
  
  ;load volume value for this frame, but hard code flags and duty for now
  lda (sound_local_word_0),y
  cmp #ENV_STOP
  beq volume_stop
  cmp #ENV_LOOP
  beq volume_loop
  
  lda #%00110000
  ora (sound_local_word_0),y
  sta streams+stream::channel_registers,x

  inc streams+stream::volume_offset,x  
  
  jmp volume_stop
volume_loop:

  lda #0
  sta streams+stream::volume_offset,x
  
volume_stop:
  
  ;load pitch index
  lda streams+stream::pitch_index,x
  tay
  ;load pitch address
  lda pitch_envelopes_lo,y
  sta sound_local_word_0
  lda pitch_envelopes_hi,y
  sta sound_local_word_0+1
  ;load pitch offset
  ldy streams+stream::pitch_offset,x
 
  ;load pitch value
  lda (sound_local_word_0),y
  cmp #ENV_STOP
  beq pitch_stop
  cmp #ENV_LOOP
  beq pitch_loop
 
  clc
  lda streams+stream::channel_registers+2,x
  adc (sound_local_word_0),y
  bcs :+
  sta streams+stream::channel_registers+2,x
:

  ;move pitch offset along
  inc streams+stream::pitch_offset,x
  
  jmp pitch_stop
pitch_loop:

  lda #0
  sta streams+stream::pitch_offset,x
  
pitch_stop:

  rts
.endproc

square_2_play_note = square_1_play_note

.proc triangle_play_note

  ;load note index
  ldy stream_byte
  
  ;load low byte of note
  lda note_table_lo,y
  ;store in low 8 bits of pitch
  sta streams+stream::channel_registers+2,x
  ;load high byte of note
  lda note_table_hi,y
  sta streams+stream::channel_registers+3,x
  
  ;load volume index
  lda streams+stream::volume_index,x
  tay
  ;load volume address
  lda volume_envelopes_lo,y
  sta sound_local_word_0
  lda volume_envelopes_hi,y
  sta sound_local_word_0+1
  ;load volume offset
  ldy streams+stream::volume_offset,x
  
  ;load volume value for this frame, but hard code flags and duty for now
  lda (sound_local_word_0),y
  cmp #ENV_STOP
  beq volume_stop
  cmp #ENV_LOOP
  beq volume_loop
  
  lda #%10000000
  ora (sound_local_word_0),y
  sta streams+stream::channel_registers,x

  inc streams+stream::volume_offset,x  
  
  jmp volume_stop
volume_loop:

  lda #0
  sta streams+stream::volume_offset,x
  
volume_stop:
  
  ;load pitch index
  lda streams+stream::pitch_index,x
  tay
  ;load pitch address
  lda pitch_envelopes_lo,y
  sta sound_local_word_0
  lda pitch_envelopes_hi,y
  sta sound_local_word_0+1
  ;load pitch offset
  ldy streams+stream::pitch_offset,x
 
  ;load pitch value
  lda (sound_local_word_0),y
  cmp #ENV_STOP
  beq pitch_stop
  cmp #ENV_LOOP
  beq pitch_loop
 
  clc
  lda streams+stream::channel_registers+2,x
  adc (sound_local_word_0),y
  bcs :+
  sta streams+stream::channel_registers+2,x
:

  ;move pitch offset along
  inc streams+stream::pitch_offset,x
  
  jmp pitch_stop
pitch_loop:

  lda #0
  sta streams+stream::pitch_offset,x
  
pitch_stop:

  rts
.endproc

.proc noise_play_note

  ;load note index
  ldy stream_byte
  
  ;load low byte of note
  lda note_table_lo,y
  ;store in low 8 bits of pitch
  and #%01111111
  ora #%00110000
  sta streams+stream::channel_registers+2,x
  
  ;load volume index
  lda streams+stream::volume_index,x
  tay
  ;load volume address
  lda volume_envelopes_lo,y
  sta sound_local_word_0
  lda volume_envelopes_hi,y
  sta sound_local_word_0+1
  ;load volume offset
  ldy streams+stream::volume_offset,x
  
  ;load volume value for this frame, hard code disable flags
  lda (sound_local_word_0),y
  bmi volume_envelope_finished
  lda #%00110000  
  ora (sound_local_word_0),y
  sta streams+stream::channel_registers,x
  
  ;move volume offset along
  inc streams+stream::volume_offset,x
volume_envelope_finished:
  
  rts
.endproc

 
  ;****************************************************************
  ;these callbacks are all stream control and execute in sequence
  ;until exhausted. 
  ;****************************************************************

.proc stream_set_volume_envelope

  advance_stream_read_address
  ;load byte at read address
  lda streams+stream::read_address,x
  sta sound_local_word_0
  lda streams+stream::read_address+1,x
  sta sound_local_word_0+1
  ldy #0
  lda (sound_local_word_0),y
  sta streams+stream::volume_index,x
  lda #0
  sta streams+stream::volume_offset,x

  rts
.endproc

.proc stream_set_pitch_envelope

  advance_stream_read_address
  ;load byte at read address
  lda streams+stream::read_address,x
  sta sound_local_word_0
  lda streams+stream::read_address+1,x
  sta sound_local_word_0+1
  ldy #0
  lda (sound_local_word_0),y
  sta streams+stream::pitch_index,x
  lda #0
  sta streams+stream::pitch_offset,x

  rts
.endproc

.proc stream_set_duty_envelope
  rts
.endproc
 
.proc stream_set_length

  advance_stream_read_address
  ;load byte at read address
  lda streams+stream::read_address,x
  sta sound_local_word_0
  lda streams+stream::read_address+1,x
  sta sound_local_word_0+1
  ldy #0
  lda (sound_local_word_0),y
  sta streams+stream::length,x
  sta streams+stream::frame_counter,x

  rts
.endproc

;this opcode loops to the beginning of the stream. It expects the two
;following bytes to contain the address to loop to.
.proc stream_goto

  advance_stream_read_address
  ;load byte at read address
  lda streams+stream::read_address,x
  sta sound_local_word_0
  lda streams+stream::read_address+1,x
  sta sound_local_word_0+1
  ldy #0
  lda (sound_local_word_0),y  
  sta streams+stream::read_address,x
  ldy #1
  lda (sound_local_word_0),y
  sta streams+stream::read_address+1,x
  
  sec
  lda streams+stream::read_address,x
  sbc #1
  sta streams+stream::read_address,x
  lda streams+stream::read_address+1,x
  sbc #0
  sta streams+stream::read_address+1,x

  rts

.endproc

;this opcode returns from the parent caller by popping two bytes off
;the stack and then doing rts.
.proc stream_terminate

  ;set the current stream to inactive
  lda #0
  sta streams+stream::active,x

  ;pop current address off the stack
  pla
  pla
  
  ;return from parent caller
  rts
.endproc
 
;expects sound_param_word_1 to contain address of a song definition,
;assumed to be four addresses to initialize streams on, for square1, square2, triangle and noise.
;any addresses found to be zero will not initialize that channel.
.proc song_initialize
song_address = sound_param_word_1

  ;load square 1 stream
  ldy #0
  lda (song_address),y
  sta sound_param_word_0
  iny
  lda (song_address),y
  beq no_square_1
  sta sound_param_word_0+1
  
  lda #0
  sta sound_param_byte_0
  
  ldx #0
  jsr stream_initialize
no_square_1:
  
  ;load square 2 stream
  iny
  lda (song_address),y
  sta sound_param_word_0
  iny
  lda (song_address),y
  beq no_square_2
  sta sound_param_word_0+1
  
  lda #1
  sta sound_param_byte_0
  
  ldx #16
  jsr stream_initialize
no_square_2:
  
  ;load triangle stream
  iny
  lda (song_address),y
  sta sound_param_word_0
  iny
  lda (song_address),y
  beq no_triangle
  sta sound_param_word_0+1
  
  lda #2
  sta sound_param_byte_0
  
  ldx #32
  jsr stream_initialize
no_triangle:
  
  ;load noise stream
  iny
  lda (song_address),y
  sta sound_param_word_0
  iny
  lda (song_address),y
  beq no_noise
  sta sound_param_word_0+1
  
  lda #3
  sta sound_param_byte_0
  
  ldx #48
  jsr stream_initialize
no_noise:
  rts
  
.endproc
 
;expects x to contain the offset of the stream instance to initialize
;expects sound_param_byte_0 to contain the channel on which to play the stream.
;expects sound_param_word_0 to contain the starting read address of the stream to
;initialize.
.proc stream_initialize
channel = sound_param_byte_0
starting_read_address = sound_param_word_0

  ;set stream to be active
  lda #1
  sta streams+stream::active,x
  
  ;set a default note length (20 frames)
  lda #20
  sta streams+stream::length,x
  
  ;set initial frame counter
  sta streams+stream::frame_counter,x
  
  ;set initial envelope indices
  lda #0
  sta streams+stream::volume_index,x
  sta streams+stream::pitch_index,x
  sta streams+stream::duty_index,x
  sta streams+stream::volume_offset,x
  sta streams+stream::pitch_offset,x
  sta streams+stream::duty_offset,x
  
  ;set channel
  lda channel
  sta streams+stream::channel,x
  
  ;set initial read address
  lda starting_read_address
  sta streams+stream::read_address,x
  lda starting_read_address+1
  sta streams+stream::read_address+1,x

  rts
.endproc
 
;updates a single stream
;expects x to be pointing to a stream instance as an offset from streams
.proc stream_update
callback_address = sound_local_word_0
read_address = sound_local_word_1

  ;load current read address of stream
  lda streams+stream::read_address,x
  sta read_address
  lda streams+stream::read_address+1,x
  sta read_address+1
  
  ;load next byte from stream data
  ldy #0
  lda (read_address),y
  sta stream_byte
  
  ;is this byte a note or a stream opcode?
  cmp #OPCODES_BASE
  bpl process_opcode
process_note:
  
  ;determine which channel callback to use
  lda streams+stream::channel,x
  tay
  lda channel_callback_table_lo,y
  sta callback_address
  lda channel_callback_table_hi,y
  sta callback_address+1
  
  ;call the channel callback!
  jsr indirect_jsr_callback_address
  
  ;decrement the frame counter. on zero, advance the stream's read address.
  dec streams+stream::frame_counter,x
  bne frame_counter_not_zero
  
  ;reset the frame counter
  lda streams+stream::length,x
  sta streams+stream::frame_counter,x
  
  ;reset volume, pitch, and duty offsets
  lda #0
  sta streams+stream::volume_offset,x
  sta streams+stream::pitch_offset,x
  sta streams+stream::duty_offset,x
  
  ;advance the stream's read address.
  advance_stream_read_address
  
frame_counter_not_zero:
  
  rts
process_opcode:

  ;look up the opcode in the stream callbacks table
  sec
  sbc #OPCODES_BASE
  tay
  ;get the address
  lda stream_callback_table_lo,y
  sta callback_address
  lda stream_callback_table_hi,y
  sta callback_address+1
  ;call the callback!
  jsr indirect_jsr_callback_address
  
  ;advance the stream's read address.
  advance_stream_read_address
  
  ;immediately process the next opcode or note. The idea here is that
  ;all stream control opcodes will execute during the current frame as "setup"
  ;for the next note. All notes will execute once per frame and will always
  ;return from this routine. This leaves the problem, how would the stream
  ;control opcode "terminate" work? It works by pulling the current return 
  ;address off the stack and then performing an rts, effectively returning
  ;from its caller, this routine.
  jmp stream_update
  
.proc indirect_jsr_callback_address
  jmp (callback_address)
  rts
.endproc
  
.endproc

.proc sound_initialize_apu_buffer

  ;****************************************************************
  ;Initialize Square 1
  ;****************************************************************

  ;set Saw Envelope Disable and Length Counter Disable to 1 for square 1.
  lda #%00110000
  sta apu_register_sets
  
  lda #$08    ;set Negate flag on the sweep unit
  sta apu_register_sets+1
  
  ;set period to C9, which is a C#...just in case nobody writes to him
  lda #$C9
  sta apu_register_sets+2
  
  ;make sure the old value starts out different from the first default value
  sta apu_square_1_old
  
  lda #$00
  sta apu_register_sets+3
  
  ;****************************************************************
  ;Initialize Square 2
  ;****************************************************************

  ;set Saw Envelope Disable and Length Counter Disable to 1 for square 2.
  lda #%00110000
  sta apu_register_sets+4
  
  lda #$08    ;set Negate flag on the sweep unit
  sta apu_register_sets+5
  
  ;set period to C9, which is a C#...just in case nobody writes to him
  lda #$C9
  sta apu_register_sets+6
  
  ;make sure the old value starts out different from the first default value
  sta apu_square_2_old
  
  lda #$00
  sta apu_register_sets+7
  
  ;****************************************************************
  ;Initialize Triangle
  ;****************************************************************
  lda #%10000000
  sta apu_register_sets+8
  
  lda #$C9
  sta apu_register_sets+10
  
  lda #$00
  sta apu_register_sets+11
  
  ;****************************************************************
  ;Initialize Noise
  ;****************************************************************
  lda #%00110000
  sta apu_register_sets+12
  
  lda #%00000000
  sta apu_register_sets+13
  
  lda #%00000000
  sta apu_register_sets+14
  
  rts
.endproc

.proc sound_upload

  lda apu_data_ready
  beq apu_data_not_ready

  jsr sound_upload_apu_register_sets
  
apu_data_not_ready:

  rts
.endproc
  
;adapted from MetalSlime's Nerdy Nights sound engine
.proc sound_upload_apu_register_sets
square1:
  lda apu_register_sets+0
  sta $4000
  lda apu_register_sets+1
  sta $4001
  lda apu_register_sets+2
  sta $4002
  lda apu_register_sets+3
  cmp apu_square_1_old       ;compare to last write
  beq square2                ;don't write this frame if they were equal
  sta $4003  
  sta apu_square_1_old       ;save the value we just wrote to $4003
square2:
  lda apu_register_sets+4
  sta $4004
  lda apu_register_sets+5
  sta $4005
  lda apu_register_sets+6
  sta $4006
  lda apu_register_sets+7
  cmp apu_square_2_old
  beq triangle
  sta $4007
  sta apu_square_2_old       ;save the value we just wrote to $4007
triangle:
  lda apu_register_sets+8
  sta $4008
  lda apu_register_sets+10
  sta $400A
  lda apu_register_sets+11
  sta $400B
noise:
  lda apu_register_sets+12
  sta $400C
  lda apu_register_sets+14
  sta $400E
  lda apu_register_sets+15
  sta $400F
  
  ;clear out all volume values from this frame in case a sound effect is killed suddenly
  lda #%00110000
  sta apu_register_sets
  sta apu_register_sets+4
  sta apu_register_sets+12
  lda #%10000000
  sta apu_register_sets+8
  
  rts
.endproc
