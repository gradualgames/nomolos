.ifndef BOULDER_INC
BOULDER_INC = 1

BOULDER_WIDTH = $10
BOULDER_HEIGHT = $08
BOULDER_INITSTATE = $00
BOULDER_SITTHERESTATE = $01

.proc boulder_update

  lda entity_instances+entity_instance::state,x
  cmp #BOULDER_INITSTATE
  beq boulder_init
  cmp #BOULDER_SITTHERESTATE
  beq boulder_sit_there

boulder_init:

  lda #BOULDER_SITTHERESTATE
  sta entity_instances+entity_instance::state,x

  rts

boulder_sit_there:

  jsr entity_compute_screen_coordinates

  jsr boulder_draw

  rts

boulder_draw:

  lda entity_chr_offsets+(entity_index_boulder-1)
  sta sprite_group_offset

  lda #<spritesheet1_BoulderEye0
  sta w0
  lda #>spritesheet1_BoulderEye0
  sta w0+1

  lda #%00000000
  sta b2

  lda #141
  sta w3
  lda #0
  sta w3+1
  lda #92
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet1_BoulderEye1
  sta w0
  lda #>spritesheet1_BoulderEye1
  sta w0+1

  lda #%00000000
  sta b2

  lda #164
  sta w3
  lda #0
  sta w3+1
  lda #94
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet1_BoulderCrown0
  sta w0
  lda #>spritesheet1_BoulderCrown0
  sta w0+1

  lda #%00000000
  sta b2

  lda #152
  sta w3
  lda #0
  sta w3+1
  lda #64
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet1_BoulderScepter0
  sta w0
  lda #>spritesheet1_BoulderScepter0
  sta w0+1

  lda #%00000000
  sta b2

  lda #160
  sta w3
  lda #0
  sta w3+1
  lda #127
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  lda #<spritesheet1_BoulderScepter1
  sta w0
  lda #>spritesheet1_BoulderScepter1
  sta w0+1

  lda #%00000000
  sta b2

  lda #184
  sta w3
  lda #0
  sta w3+1
  lda #159
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  rts

.endproc

.endif

