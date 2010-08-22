.ifndef DRAGONBOSS_INC
DRAGONBOSS_INC = 1

.include "play_level_state.inc"

.struct dragonboss_locals
  state_switch_counter .byte
  substate_switch_counter .byte
  health .byte
  substate .byte
  prng_seed .byte
.endstruct

DRAGONBOSS_WIDTH = 32
DRAGONBOSS_HEIGHT = 8

DRAGONBOSS_INITSTATE = 0
DRAGONBOSS_INITBOSSMODESTATE = 1
DRAGONBOSS_TAILUPSTATE = 2
DRAGONBOSS_TAILDOWNSTATE = 3
DRAGONBOSS_GLOWINGEYESSTATE = 4
DRAGONBOSS_SPITICEBALLSSTATE = 5
DRAGONBOSS_DYINGSTATE = 6

DRAGONBOSS_SUBSTATE_NOT_ATTACKED = 0
DRAGONBOSS_SUBSTATE_ATTACKED = 1

;these should be drawn at location 22, 22 in the nametable
boss1_tail_up_tiles:
  .byte $06,$06,$66,$29,$67,$68,$29,$1f,$6f,$29,$70,$71,$29,$29,$76,$29,$77,$78,$79,$29,$7f,$7f,$80,$81,$82,$83,$93,$94,$95,$96,$97,$98
  .byte $a9,$aa,$ab,$ac,$9d,$9e

boss1_tail_down_tiles:
  .byte $06,$06,$66,$29,$5e,$5f,$29,$1f,$6f,$29,$69,$6a,$29,$29,$76,$29,$69,$69,$72,$29,$7f,$7f,$69,$69,$69,$7a,$84,$85,$86,$87,$88,$89
  .byte $99,$9a,$9b,$9c,$9d,$9e

boss1_glowing_eyes_color_sequence:
  .byte $05, $15, $25, $35, $25, $15, $05, $05
  
boss1_attacked_color_sequence:
  .byte $02, $12, $22, $32, $22, $12, $02, $02

dragonboss_update:

  lda entity_instances+entity_instance::state,x
  cmp #DRAGONBOSS_INITSTATE
  beq dragonboss_init
  cmp #DRAGONBOSS_INITBOSSMODESTATE
  beq dragonboss_initbossmodestate
  cmp #DRAGONBOSS_TAILUPSTATE
  beq dragonboss_tailupstate
  cmp #DRAGONBOSS_TAILDOWNSTATE
  beq dragonboss_taildownstate
  cmp #DRAGONBOSS_GLOWINGEYESSTATE
  beq dragonboss_glowingeyesstate
  cmp #DRAGONBOSS_SPITICEBALLSSTATE
  beq dragonboss_spiticeballsstate
  cmp #DRAGONBOSS_DYINGSTATE
  beq dragonboss_dyingstate

dragonboss_init:

  ;reset the dragonboss animation object
  jsr entity_reset_anim
  
  ;must wait one frame before initializing boss mode, or the load level
  ;state will replace the boss nmi routine with the normal play state nmi routine
  lda #1
  sta entity_locals+dragonboss_locals::state_switch_counter,x
  
  ;start dragon out with a certain amount of health
  lda #10
  sta entity_locals+dragonboss_locals::health,x
  
  ;load a seed for the prng (for explosions when the Dragon dies)
  lda #10
  sta entity_locals+dragonboss_locals::prng_seed,x
  
  ;dragon boss's substate starts out as not attacked
  lda #DRAGONBOSS_SUBSTATE_NOT_ATTACKED
  sta entity_locals+dragonboss_locals::substate,x
  
  lda #DRAGONBOSS_INITBOSSMODESTATE
  sta entity_instances+entity_instance::state,x

  rts

dragonboss_initbossmodestate:

  jsr dragonboss_substate_handler

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  bne do_not_switch_to_init_boss_mode_state
  
  jsr play_level_state_init_boss_mode

  lda #100
  sta entity_locals+dragonboss_locals::state_switch_counter,x
  
  lda #DRAGONBOSS_TAILDOWNSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_init_boss_mode_state:

  rts
  
dragonboss_tailupstate:

  jsr dragonboss_tailupstate_handler

  rts
  
dragonboss_taildownstate:

  jsr dragonboss_taildownstate_handler

  rts

dragonboss_spiticeballsstate:

  jsr dragonboss_spiticeballsstate_handler

  rts
  
dragonboss_dyingstate:

  jsr dragonboss_dyingstate_handler
  
  rts
  
dragonboss_glowingeyesstate:

  .scope
  
  dec entity_locals+dragonboss_locals::state_switch_counter,x

  lda entity_locals+dragonboss_locals::state_switch_counter,x
  cmp #64
  bpl pause_before_glow
  cmp #32
  beq switch_state
  and #%00011100
  lsr
  lsr

  ;get the current color the eyes should be
  tay
  lda boss1_glowing_eyes_color_sequence,y
  
  sta dynamic_palette + $1f
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data
  
pause_before_glow:
  .endscope
  
  ;make the screen shake for a little bit right after the tail slams
  ;to the ground
  lda entity_locals+dragonboss_locals::state_switch_counter,x
  cmp #80
  bmi do_not_vibrate
  and #%00000001
  asl
  sta camera_scroll_x
do_not_vibrate:
  
  jsr dragonboss_substate_handler
  
  rts
  
switch_state:
  
  lda #DRAGONBOSS_SPITICEBALLSSTATE
  sta entity_instances+entity_instance::state,x

  rts
  
dragonboss_taildownstate_handler:
  
  jsr dragonboss_substate_handler
  
  dec entity_locals+dragonboss_locals::state_switch_counter,x
  bne do_not_switch_to_tailupstate
  
  txa
  pha

  lda #<boss_boom_sound
  sta sound_param_word_0
  lda #>boss_boom_sound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax
  
  lda #22
  sta b0
  lda #20
  sta b1
  lda #<boss1_tail_down_tiles
  sta w0
  lda #>boss1_tail_down_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  lda #110
  sta entity_locals+dragonboss_locals::state_switch_counter,x
  
  lda #DRAGONBOSS_GLOWINGEYESSTATE
  sta entity_instances+entity_instance::state,x
  
do_not_switch_to_tailupstate:

  rts
  
dragonboss_dyingstate_handler:

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  
  ;the following code can modify how frequently explosions appear
  ;lda entity_locals+dragonboss_locals::state_switch_counter,x
  ;and #%00000100
  ;beq do_not_spawn_explosion

  ;generate random coordinates for explosion entity
  jsr dragonboss_get_next_prn
  lsr
  clc
  adc #100
  sta w0
  lda #0
  sta w0+1
  
  jsr dragonboss_get_next_prn
  sta w1
  lda #0
  sta w1+1
  
  ;only spawn explosion if these coordinates are on the dragon (hurt tile)
  jsr map_test_collision
  
  lda b0
  
  beq do_not_spawn_explosion
  
  lda #entity_index_explosion
  sta b0

  lda w1
   
  sta b1

  jsr entity_spawn
  
  txa
  pha

  lda #<hit_sound
  sta sound_param_word_0
  lda #>hit_sound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax
  
do_not_spawn_explosion:

  ;make the screen shake
  lda entity_locals+dragonboss_locals::state_switch_counter,x
  and #%00000010
  asl
  sta camera_scroll_x

  rts
  
.proc dragonboss_get_next_prn

  ldy #10
  
: lda entity_locals+dragonboss_locals::prng_seed,x
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor #$1d
noEor:
  sta entity_locals+dragonboss_locals::prng_seed,x
  dey
  bne :-

  rts
.endproc
  
dragonboss_spiticeballsstate_handler:

  jsr dragonboss_substate_handler
  
  ;****************************************************************
  ;Spawn and parameterize an iceball
  ;****************************************************************
  lda #entity_index_iceball
  sta b0

  lda #110
  sta w0
  lda #0
  sta w0+1
  
  lda #110
  sta b1

  jsr entity_spawn
  
  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the iceball we just spawned
  lda #$fd
  sta entity_locals+iceball_locals::x_velocity,y
  lda #$ff
  sta entity_locals+iceball_locals::x_velocity+1,y
  lda #2
  sta entity_locals+iceball_locals::y_velocity,y
  lda #0
  sta entity_locals+iceball_locals::y_velocity+1,y
  
  ;reset the iceball's animation
  lda #1
  sta entity_instances+entity_instance::animation_object,y
  lda #$ff
  sta entity_instances+entity_instance::animation_object+1,y
  
  lda #ICEBALL_FLYSTATE
  sta entity_instances+entity_instance::state,y
  
  ;****************************************************************
  ;Spawn and parameterize an iceball
  ;****************************************************************
  lda #entity_index_iceball
  sta b0

  lda #110
  sta w0
  lda #0
  sta w0+1
  
  lda #110
  sta b1

  jsr entity_spawn
  
  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the iceball we just spawned
  lda #$fe
  sta entity_locals+iceball_locals::x_velocity,y
  lda #$ff
  sta entity_locals+iceball_locals::x_velocity+1,y
  lda #2
  sta entity_locals+iceball_locals::y_velocity,y
  lda #0
  sta entity_locals+iceball_locals::y_velocity+1,y
  
  ;reset the iceball's animation
  lda #1
  sta entity_instances+entity_instance::animation_object,y
  lda #$ff
  sta entity_instances+entity_instance::animation_object+1,y
  
  lda #ICEBALL_FLYSTATE
  sta entity_instances+entity_instance::state,y
  
  ;****************************************************************
  ;Spawn and parameterize an iceball
  ;****************************************************************
  lda #entity_index_iceball
  sta b0

  lda #110
  sta w0
  lda #0
  sta w0+1
  
  lda #110
  sta b1

  jsr entity_spawn
  
  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the iceball we just spawned
  lda #$ff
  sta entity_locals+iceball_locals::x_velocity,y
  lda #$ff
  sta entity_locals+iceball_locals::x_velocity+1,y
  lda #2
  sta entity_locals+iceball_locals::y_velocity,y
  lda #0
  sta entity_locals+iceball_locals::y_velocity+1,y
  
  ;reset the iceball's animation
  lda #1
  sta entity_instances+entity_instance::animation_object,y
  lda #$ff
  sta entity_instances+entity_instance::animation_object+1,y
  
  lda #ICEBALL_FLYSTATE
  sta entity_instances+entity_instance::state,y
  
  lda #DRAGONBOSS_TAILUPSTATE
  sta entity_instances+entity_instance::state,x

  rts
  
dragonboss_tailupstate_handler:

  jsr dragonboss_substate_handler

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  bne do_not_switch_to_taildownstate
  
  ;spawn a couple of stalactite entities
  lda #entity_index_stalactite
  sta b0

  lda nomolos_screen_x
  sta w0
  lda #0
  sta w0+1
  
  lda #0
  sta b1

  jsr entity_spawn

  lda #entity_index_stalactite
  sta b0
  
  clc
  lda nomolos_screen_x
  adc #50
  sta w0
  lda #0
  sta w0+1
  
  lda #0
  sta b1

  jsr entity_spawn
  
  lda #entity_index_stalactite
  sta b0
  
  sec
  lda nomolos_screen_x
  sbc #50
  sta w0
  lda #0
  sta w0+1
  
  lda #0
  sta b1

  jsr entity_spawn
  
  lda #100
  sta entity_locals+dragonboss_locals::state_switch_counter,x
  
  lda #22
  sta b0
  lda #20
  sta b1
  lda #<boss1_tail_up_tiles
  sta w0
  lda #>boss1_tail_up_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  lda #DRAGONBOSS_TAILDOWNSTATE
  sta entity_instances+entity_instance::state,x
do_not_switch_to_taildownstate:

  rts
  
dragonboss_substate_handler:
 
  lda entity_locals+dragonboss_locals::substate,x
  cmp #DRAGONBOSS_SUBSTATE_NOT_ATTACKED
  beq dragonboss_substate_not_attacked
  cmp #DRAGONBOSS_SUBSTATE_ATTACKED
  beq dragonboss_substate_attacked

dragonboss_substate_not_attacked:

  jsr nomolos_is_deadly
  beq nomolos_not_attacking

  lda #112
  sta entity_screen_x
  lda #96
  sta entity_screen_y
  lda #0
  sta entity_screen_x+1
  sta entity_screen_y+1
  
  lda #DRAGONBOSS_WIDTH
  sta b2
  lda #DRAGONBOSS_HEIGHT
  sta b3

  jsr entity_test_collision_hitbox

  bne dragonboss_not_hit
dragonboss_hit:
  
  txa
  pha

  lda #<boss_hurt_sound
  sta sound_param_word_0
  lda #>boss_hurt_sound
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax
  
  ;decrease health
  dec entity_locals+dragonboss_locals::health,x
  
  ;the attacked state should live for a few frames while palette flickers
  lda #24
  sta entity_locals+dragonboss_locals::substate_switch_counter,x
  
  ;set substate to attacked
  lda #DRAGONBOSS_SUBSTATE_ATTACKED
  sta entity_locals+dragonboss_locals::substate,x
  
dragonboss_not_hit:
  
nomolos_not_attacking:

  jmp dragonboss_substate_switch_complete
  
dragonboss_substate_attacked:
  
  ;while we are in the attacked state, we want to be flickering
  ;the Dragon's palette somehow
  
  .scope
  
  lda entity_locals+dragonboss_locals::substate_switch_counter,x
  and #%00000111

  ;get the current color the eyes should be
  tay
  lda boss1_attacked_color_sequence,y
  
  sta dynamic_palette + $01
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  .endscope
  
  dec entity_locals+dragonboss_locals::substate_switch_counter,x
  bne do_not_switch_to_not_attacked_state
  
  ;find out if dragon should die now
  lda entity_locals+dragonboss_locals::health,x
  bne do_not_switch_to_dying_state
  
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif
  
  lda #DRAGONBOSS_DYINGSTATE
  sta entity_instances+entity_instance::state,x
  
do_not_switch_to_dying_state:
  
  ;attacked state is done, switch back to not attacked state
  lda #DRAGONBOSS_SUBSTATE_NOT_ATTACKED
  sta entity_locals+dragonboss_locals::substate,x
  
do_not_switch_to_not_attacked_state:
  
dragonboss_substate_switch_complete:
  
  jsr dragonboss_drawface

  rts
  
dragonboss_drawface:

  ;clear sprite attributes
  lda #0
  sta b2
  
  ldy #level_data_struct::dragonboss_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  ldy #level_data_struct::dragonboss_eyes
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  sec
  lda #112
  sbc camera_scroll_x
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

  sec
  lda #120
  sbc camera_scroll_x
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