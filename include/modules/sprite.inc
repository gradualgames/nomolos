.ifndef SPRITE_INC
SPRITE_INC = 1

.global sprite_draw_animation_8bit
.global sprite_draw_animation_16bit
.global sprite_update_animation
.global sprite_update_all
.global sprite_clear_all
.global sprite_draw_metasprite_8bit
.global sprite_draw_metasprite_16bit

.struct spriteStruct
  ycoord .byte
  tile .byte
  attribute .byte
  xcoord .byte
.endstruct

.struct animation
  frameCountDown .byte
  currentFrame .byte
.endstruct

.macro resetAnim animAddr

  lda #$01
  sta animAddr
  lda #$ff
  sta animAddr+1

.endmacro

.endif
