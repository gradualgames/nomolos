.ifndef DRAGONBOSS_INC
DRAGONBOSS_INC = 1

.include "play_level_state.inc"

.struct dragonboss_locals
  state_switch_counter .byte
  substate_switch_counter .byte
  brightness_counter .byte
  health .byte
  substate .byte
  drawstate .byte
  erase_row .byte
.endstruct

DRAGONBOSS_WIDTH = 32
DRAGONBOSS_HEIGHT = 8

DRAGONBOSS_INITSTATE = 0
DRAGONBOSS_INITBOSSMODESTATE = 1
DRAGONBOSS_TAILUPSTATE = 2
DRAGONBOSS_TAILDOWNSTATE = 3
DRAGONBOSS_GLOWINGEYESSTATE = 4
DRAGONBOSS_SPITICEBALLSSTATE = 5
DRAGONBOSS_CLOSEMOUTHSTATE = 6
DRAGONBOSS_DYINGSTATE = 7
DRAGONBOSS_ERASESTATE = 8

DRAGONBOSS_SUBSTATE_NOT_ATTACKED = 0
DRAGONBOSS_SUBSTATE_ATTACKED = 1
DRAGONBOSS_SUBSTATE_DYING = 2
DRAGONBOSS_SUBSTATE_ERASE = 3

DRAGONBOSS_DRAWSTATE_MOUTH_SHUT = 0
DRAGONBOSS_DRAWSTATE_MOUTH_OPEN = 1

;these should be drawn at location 14, 12 in the nametable
boss1_mouth_shut_tiles:
  .byte $05,$06,$1f,$20,$21,$22,$23,$2c,$2d,$2e,$32,$30,$3a,$3b,$3f,$40,$00,$47,$48,$4d,$4e,$4f,$56,$5c,$5d,$5e,$5f,$66,$6c,$6d,$6e,$6f

boss1_mouth_open_tiles:
  .byte $05,$06,$1f,$20,$21,$22,$23,$2c,$2d,$2e,$2f,$30,$3a,$3b,$3c,$3d,$00,$47,$48,$49,$4a,$4b,$56,$57,$58,$59,$5a,$66,$67,$68,$69,$6a

;these should be drawn at location 22, 22 in the nametable
boss1_tail_up_tiles:
  .byte $06,$06,$99,$33,$9a,$9b,$33,$25,$a2,$33,$a3,$a4,$33,$33,$a9,$33,$aa,$ab,$ac,$33,$b2,$b2,$b3,$b4,$b5,$b6,$c6,$c7,$c8,$c9,$ca,$cb
  .byte $dc,$dd,$de,$df,$d0,$d1

boss1_tail_down_tiles:
  .byte $06,$06,$99,$33,$91,$92,$33,$25,$a2,$33,$9c,$9d,$33,$33,$a9,$33,$9c,$9c,$a5,$33,$b2,$b2,$9c,$9c,$9c,$ad,$b7,$b8,$b9,$ba,$bb,$bc
  .byte $cc,$cd,$ce,$cf,$d0,$d1

;this should start at 14,8
boss1_erase_row_tiles:
  .byte $12,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  
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
  cmp #DRAGONBOSS_CLOSEMOUTHSTATE
  beq dragonboss_closemouthstate
  cmp #DRAGONBOSS_DYINGSTATE
  beq dragonboss_dyingstate
  cmp #DRAGONBOSS_ERASESTATE
  beq dragonboss_erasestate

dragonboss_init:

  jsr dragonboss_initstate_handler
  
  jsr dragonboss_drawface
  
  rts
  
dragonboss_initbossmodestate:

  jsr dragonboss_initbossmodestate_handler
  
  jsr dragonboss_drawface

  rts
  
dragonboss_tailupstate:

  jsr dragonboss_substate_handler

  jsr dragonboss_tailupstate_handler

  jsr dragonboss_drawface
  
  rts
  
dragonboss_taildownstate:

  jsr dragonboss_substate_handler

  jsr dragonboss_taildownstate_handler

  jsr dragonboss_drawface
  
  rts

dragonboss_glowingeyesstate:

  jsr dragonboss_substate_handler

  jsr dragonboss_glowingeyesstate_handler
  
  jsr dragonboss_drawface

  rts
  
dragonboss_spiticeballsstate:

  jsr dragonboss_substate_handler

  jsr dragonboss_spiticeballsstate_handler

  jsr dragonboss_drawface
  
  rts
  
dragonboss_closemouthstate:

  jsr dragonboss_substate_handler

  jsr dragonboss_closemouthstate_handler
  
  jsr dragonboss_drawface
  
  rts
  
dragonboss_dyingstate:

  jsr dragonboss_substate_handler

  jsr dragonboss_dyingstate_handler

  jsr dragonboss_drawface
  
  rts
  
dragonboss_erasestate:

  jsr dragonboss_substate_handler

  jsr dragonboss_erasestate_handler
  
  jsr dragonboss_drawface
  
  rts
  
;****************************************************************
;The Init state
;****************************************************************
.proc dragonboss_initstate_handler

  ;clear out special weapon bit (this is done for balance, some bosses are
  ;rendered too easy with the spear or flail)
  lda nomolos_state_secondary
  and #nomolos_attack_set_mask
  sta nomolos_state_secondary

  ;reset the dragonboss animation object
  jsr entity_reset_anim
  
  ;must wait one frame before initializing boss mode, or the load level
  ;state will replace the boss nmi routine with the normal play state nmi routine
  lda #1
  sta entity_locals+dragonboss_locals::state_switch_counter,x
  
  ;start dragon out with a certain amount of health
  lda #15
  sta entity_locals+dragonboss_locals::health,x
  
  ;load a seed for the prng (for explosions when the Dragon dies)
  lda #10
  sta entity_prng_seed
  
  ;dragon boss's substate starts out as not attacked
  lda #DRAGONBOSS_SUBSTATE_NOT_ATTACKED
  sta entity_locals+dragonboss_locals::substate,x
  
  ;dragon boss's mouth starts out as shut
  lda #DRAGONBOSS_DRAWSTATE_MOUTH_SHUT
  sta entity_locals+dragonboss_locals::drawstate,x
  
  lda #DRAGONBOSS_INITBOSSMODESTATE
  sta entity_instances+entity_instance::state,x

  rts
.endproc
  
;****************************************************************
;The Init Bossmode state
;This state waits a couple of frames before telling the play
;level state to switch to boss mode. This is because entity
;update functions do get called before the play level state is
;entered. If we initialized boss mode before play level state is
;entered, then the boss nmi routine would get replaced by the
;normal play level state nmi routine.
;****************************************************************
.proc dragonboss_initbossmodestate_handler

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  bne do_not_switch_to_init_boss_mode_state
  
  jsr play_level_state_init_boss_mode

  lda #1
  sta entity_locals+dragonboss_locals::state_switch_counter,x
  
  lda #DRAGONBOSS_TAILUPSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_init_boss_mode_state:
  rts
  
.endproc
  
;****************************************************************
;The Glowing Eyes state
;This state modifies the color of the Dragon's eyes to make them
;appear to glow briefly before he spits fireballs towards
;Nomolos. This serves as a warning that the Dragon is about to
;attack. This state occurs right after the tail is slammed to the
;ground, so it also shakes the screen for a little bit, adding
;a nice feeling of power to the Dragon having slammed its tail
;to the ground.
;****************************************************************
.proc dragonboss_glowingeyesstate_handler

  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

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
  sta camera_scroll_y
do_not_vibrate:
  
  rts
  
switch_state:
  
  lda #DRAGONBOSS_SPITICEBALLSSTATE
  sta entity_instances+entity_instance::state,x

  rts
.endproc
  
;****************************************************************
;The Tail Down state handler
;This state pauses until state_switch_counter has reached zero,
;and then it draws the Dragon's tail in the "down" position,
;accompanied by a "boom" sound effect. It then transitions to
;the "glowing eyes" state.
;****************************************************************
dragonboss_taildownstate_handler:
  
  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  bne do_not_switch_state
  
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
  
do_not_switch_state:

  rts
  
;****************************************************************
;The Dying state handler
;This state shakes the screen, and generates dozens of explosions
;randomly all over the Dragon's body. We use a pseudo random
;number generator to get coordinates for explosions, and if the
;coordinates happen to lie on a "hurt" tile we spawn the
;explosion.
;****************************************************************
dragonboss_dyingstate_handler:

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  
  ;the following code can modify how frequently explosions appear
  ;lda entity_locals+dragonboss_locals::state_switch_counter,x
  ;and #%00000100
  ;beq do_not_spawn_explosion

  ;generate random coordinates for explosion entity
  ldy #10
  jsr entity_get_next_prn
  lsr
  clc
  adc #100
  sta w0
  lda #0
  sta w0+1
  
  ldy #10
  jsr entity_get_next_prn
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

  lda #0
  sta b2

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
  
;****************************************************************
;This state just erases the Dragon graphics from the nametable.
;This happens after the Dragon has faded out.
;****************************************************************
.proc dragonboss_erasestate_handler

  ;make sure to clean up mess from vibrating the screen
  lda #0
  sta camera_scroll_x

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  bne do_not_kill_dragon
  
  jsr entity_kill
  
do_not_kill_dragon:

  lda entity_locals+dragonboss_locals::state_switch_counter,x
  and #%00000111
  bne do_not_increment_erase_row
  
  ;draw an erase row
  lda #14
  sta b0
  lda entity_locals+dragonboss_locals::erase_row,x
  sta b1
  lda #<boss1_erase_row_tiles
  sta w0
  lda #>boss1_erase_row_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  inc entity_locals+dragonboss_locals::erase_row,x
  
do_not_increment_erase_row:
  
  rts

.endproc
  
;****************************************************************
;This state just draws the dragon's mouth closed and notifies
;the sub-state machine to draw the overlay closed mouth. It
;then switches to the tail up state.
;****************************************************************
dragonboss_closemouthstate_handler:

  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

  dec entity_locals+dragonboss_locals::state_switch_counter,x
  bne do_not_switch_to_tail_up_state
  
  ;draw dragon's mouth closed
  lda #14
  sta b0
  lda #10
  sta b1
  lda #<boss1_mouth_shut_tiles
  sta w0
  lda #>boss1_mouth_shut_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  ;make sure the draw routine overlays the closed mouth sprite
  lda #DRAGONBOSS_DRAWSTATE_MOUTH_SHUT
  sta entity_locals+dragonboss_locals::drawstate,x
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  lda #100
  sta entity_locals+dragonboss_locals::state_switch_counter,x
  
  lda #DRAGONBOSS_TAILUPSTATE
  sta entity_instances+entity_instance::state,x
  
do_not_switch_to_tail_up_state:

  rts
  
;****************************************************************
;The Spit Iceballs state handler
;This state spawns three ice-balls and parameterizes them to fly
;down and to the left.
;****************************************************************
dragonboss_spiticeballsstate_handler:

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
  lda #0
  sta b2

  jsr entity_spawn
  
  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the iceball we just spawned
  lda #$fa
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
  lda #0
  sta b2

  jsr entity_spawn
  
  ;get index of entity just spawned
  lda b3
  tay
  
  ;parameterize/fully initialize the iceball we just spawned
  lda #$fc
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
  lda #0
  sta b2

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
  lda #0
  sta b2

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

  lda #DRAGONBOSS_CLOSEMOUTHSTATE
  sta entity_instances+entity_instance::state,x
  
  ;draw dragon's mouth open
  lda #14
  sta b0
  lda #10
  sta b1
  lda #<boss1_mouth_open_tiles
  sta w0
  lda #>boss1_mouth_open_tiles
  sta w0+1
  jsr ppu_draw_rectangular_region
  
  ;make sure the draw routine overlays the open mouth sprite
  lda #DRAGONBOSS_DRAWSTATE_MOUTH_OPEN
  sta entity_locals+dragonboss_locals::drawstate,x
  
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_RECTANGULAR_REGION
  sta state_control_params+play_level_state_control::upload_ppu_data

  rts
  
;****************************************************************
;The Tail Up State handler
;While the Dragon's tail is in the air, some icy stalactites are
;starting to form on the ceiling for the next time the Dragon
;slams his tail on the ground. This state waits until the state
;switch counter has reached zero to upload the tail up graphics
;and then switch to the tail down state.
;****************************************************************
dragonboss_tailupstate_handler:

  ;since we upload a nametable region right before transitioning to
  ;this state, there is a possibility that the palette was not uploaded
  ;during palette cycling from being attacked. So, we ensure that we
  ;upload the current dynamic palette here.
  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data

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
  sta b2

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
  sta b2

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
  sta b2

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
  
;****************************************************************
;The dragon boss's sub-state handler. This is responsible for
;managing state that can change concurrently with the top-level
;state, primarily how to fade the palette in and out to signify
;that the Dragon has been struck by Nomolos.
;****************************************************************
dragonboss_substate_handler:
 
  lda entity_locals+dragonboss_locals::substate,x
  cmp #DRAGONBOSS_SUBSTATE_NOT_ATTACKED
  beq dragonboss_substate_not_attacked
  cmp #DRAGONBOSS_SUBSTATE_ATTACKED
  beq dragonboss_substate_attacked
  cmp #DRAGONBOSS_SUBSTATE_DYING
  beq dragonboss_substate_dying
  cmp #DRAGONBOSS_SUBSTATE_ERASE
  beq dragonboss_substate_erase

dragonboss_substate_not_attacked:

  jsr dragonboss_substate_not_attacked_handler

  jmp dragonboss_substate_switch_complete
  
dragonboss_substate_attacked:
  
  jsr dragonboss_substate_attacked_handler
 
  jmp dragonboss_substate_switch_complete
  
dragonboss_substate_dying:

  jsr dragonboss_substate_dying_handler

  jmp dragonboss_substate_switch_complete
  
dragonboss_substate_erase:

  jsr dragonboss_substate_erase_handler
  
  jmp dragonboss_substate_switch_complete
  
dragonboss_substate_switch_complete:
  
  rts
  
;****************************************************************
;Dragon boss's substate not attacked handler
;****************************************************************
.proc dragonboss_substate_not_attacked_handler

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

  rts
.endproc
  
;****************************************************************
;Dragon boss's substate attacked handler
;****************************************************************
.proc dragonboss_substate_attacked_handler

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
  
  lda #DRAGONBOSS_SUBSTATE_NOT_ATTACKED
  sta entity_locals+dragonboss_locals::substate,x
  
do_not_switch_to_not_attacked_state:
  
  ;find out if dragon should die now
  lda entity_locals+dragonboss_locals::health,x
  bne do_not_switch_to_dying_state
  
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif
  
  ;make Nomolos invincible the instant we transition the Dragon into dying state
  lda nomolos_state_primary
  ora #nomolos_invincibility_on_set
  sta nomolos_state_primary
  lda #0
  ;ensure that the invincibility blinking counter is already zero so it does not
  ;reset invincibility to "off" after the dragon has already started dying
  sta nomolos_counter_temp_invincibility_blink
  
  lda #DRAGONBOSS_DYINGSTATE
  sta entity_instances+entity_instance::state,x
  
  lda #$fe
  sta entity_locals+dragonboss_locals::substate_switch_counter,x
  
  lda #4
  sta entity_locals+dragonboss_locals::brightness_counter,x
  
  lda #DRAGONBOSS_SUBSTATE_DYING
  sta entity_locals+dragonboss_locals::substate,x
do_not_switch_to_dying_state:
  
  rts

.endproc
  
;****************************************************************
;Dragon boss's substate dying handler
;****************************************************************
.proc dragonboss_substate_dying_handler

  dec entity_locals+dragonboss_locals::substate_switch_counter,x
  dec entity_locals+dragonboss_locals::substate_switch_counter,x
  bne do_not_decrement_brightness_counter
  
  dec entity_locals+dragonboss_locals::brightness_counter,x
  
do_not_decrement_brightness_counter:
  
  ldy #3
darken_dragon_palette_loop:
  lda dynamic_palette,y
  sta b0
  
  lda entity_locals+dragonboss_locals::brightness_counter,x
  sta b3
  
  jsr ppu_adjust_color_brightness
  
  lda b0
  sta dynamic_palette,y
  
  lda dynamic_palette+28,y
  sta b0
  
  lda entity_locals+dragonboss_locals::brightness_counter,x
  sta b3
  
  jsr ppu_adjust_color_brightness
  
  lda b0
  sta dynamic_palette+28,y
  
  dey
  bpl darken_dragon_palette_loop

  lda #PLAYLEVELSTATE_BOSSMODE_UPLOAD_DYNAMIC_PALETTE
  sta state_control_params+play_level_state_control::upload_ppu_data
  
  ;if the dragon has faded all the way out, switch to "erase" state
  lda entity_locals+dragonboss_locals::brightness_counter,x
  beq dragonboss_erase
  
  rts
  
dragonboss_erase:

  jsr play_level_state_init_victory_mode

  lda #160
  sta entity_locals+dragonboss_locals::state_switch_counter,x

  lda #6
  sta entity_locals+dragonboss_locals::erase_row,x
  
  lda #DRAGONBOSS_ERASESTATE
  sta entity_instances+entity_instance::state,x
  
  lda #DRAGONBOSS_SUBSTATE_ERASE
  sta entity_locals+dragonboss_locals::substate,x
  
  rts

.endproc
  
;****************************************************************
;Dragon boss's substate erase handler
;this substate does nothing
;****************************************************************
.proc dragonboss_substate_erase_handler

  rts

.endproc
  
;****************************************************************
;This routine draws the Dragon's face overlay as sprites,
;depending on whether his mouth is open or not.
;****************************************************************
dragonboss_drawface:

  ;clear sprite attributes
  lda #0
  sta b2
  
  lda entity_chr_offsets+(entity_index_dragonboss-1)
  sta sprite_group_offset

  ;get drawing state
  lda entity_locals+dragonboss_locals::drawstate,x
  cmp #DRAGONBOSS_DRAWSTATE_MOUTH_SHUT
  beq draw_mouth_shut
  cmp #DRAGONBOSS_DRAWSTATE_MOUTH_OPEN
  beq draw_mouth_open
  
draw_mouth_shut:
  lda #<spritesheet1_DragonFace0
  sta w0
  lda #>spritesheet1_DragonFace0
  sta w0+1
  jmp drawstate_switch_done
draw_mouth_open:
  lda #<spritesheet1_DragonFace1
  sta w0
  lda #>spritesheet1_DragonFace1
  sta w0+1
drawstate_switch_done:
  
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

  rts
  
.endif