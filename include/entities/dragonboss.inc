.ifndef DRAGONBOSS_INC
DRAGONBOSS_INC = 1

.include "play_level_state.inc"

.struct dragonboss_locals
  state_switch_counter .byte
.endstruct

DRAGONBOSS_WIDTH = $10
DRAGONBOSS_HEIGHT = $10

DRAGONBOSS_INITSTATE = 0
DRAGONBOSS_INITBOSSMODESTATE = 1
DRAGONBOSS_RUNSTATE = 2

;these should be drawn at location 22, 22 in the nametable
boss1_tail_up_tiles:
  .byte $06,$06,$66,$29,$67,$68,$29,$1f,$6f,$29,$70,$71,$29,$29,$76,$29,$77,$78,$79,$29,$7f,$7f,$80,$81,$82,$83,$93,$94,$95,$96,$97,$98
  .byte $a9,$aa,$ab,$ac,$9d,$9e

boss1_tail_down_tiles:
  .byte $06,$06,$66,$29,$5e,$5f,$29,$1f,$6f,$29,$69,$6a,$29,$29,$76,$29,$69,$69,$72,$29,$7f,$7f,$69,$69,$69,$7a,$84,$85,$86,$87,$88,$89
  .byte $99,$9a,$9b,$9c,$9d,$9e

dragonboss_update:

  lda entity_instances+entity_instance::state,x
  cmp #DRAGONBOSS_INITSTATE
  beq dragonboss_init
  cmp #DRAGONBOSS_INITBOSSMODESTATE
  beq dragonboss_initbossmodestate
  cmp #DRAGONBOSS_RUNSTATE
  beq dragonboss_runstate

dragonboss_init:

  ;reset the dragonboss animation object
  jsr entity_reset_anim
  
  lda #100
  sta entity_locals+dragonboss_locals::state_switch_counter,x
  
  lda #DRAGONBOSS_INITBOSSMODESTATE
  sta entity_instances+entity_instance::state,x

  rts

dragonboss_initbossmodestate:

  jsr dragonboss_drawface

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  bne do_not_switch_to_init_boss_mode_state
  
  jsr play_level_state_init_boss_mode

  lda #22
  sta b0
  lda #20
  sta b1
  lda #<boss1_tail_down_tiles
  sta w0
  lda #>boss1_tail_down_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  lda #DRAGONBOSS_RUNSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_init_boss_mode_state:

  rts
  
dragonboss_runstate:

  jsr dragonboss_drawface

  rts

dragonboss_drawface:

  ldy #level_data_struct::dragonboss_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::dragonboss_eyes
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  lda #112
  sta w3
  lda #0
  sta w3+1
  lda #87
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit
  
  ldy #level_data_struct::dragonboss_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::dragonboss_nose
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  lda #120
  sta w3
  lda #0
  sta w3+1
  lda #111
  sta w4
  lda #0
  sta w4+1

  jsr sprite_draw_metasprite_16bit

  rts
  
.endif