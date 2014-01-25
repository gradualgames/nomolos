.ifndef SPRITE_INC
SPRITE_INC = 1

.global sprite_module_init
.global sprite_draw_animation_16bit
.global sprite_update_animation
.global sprite_update_all
.global sprite_clear_all
.global sprite_draw_metasprite_16bit
.global sprite_draw_overlay

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

.macro reset_anim animAddr

  lda #$01
  sta animAddr
  lda #$ff
  sta animAddr+1

.endmacro

.endif
