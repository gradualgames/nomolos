.ifndef GORT_INC
GORT_INC = 1

.struct gort_locals
  counter .byte
  sprite_address .word
.endstruct

GORT_WIDTH  = $20
GORT_HEIGHT = $18

GORT_INITSTATE = 0
GORT_WAITSTATE = 1
GORT_FIRESTATE = 2

.proc gort_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #GORT_INITSTATE
  beq gort_initState
  cmp #GORT_WAITSTATE
  beq gort_waitState
  cmp #GORT_FIRESTATE
  beq gort_fireState

gort_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;set initial counter
  lda #30
  sta entity_locals+gort_locals::counter,x

  ;position correctly
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #$08
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_y+1,x
  
  ;switch state to "wait"
  lda #GORT_WAITSTATE
  sta entity_instances+entity_instance::state,x
  rts

gort_fireState:

  jsr entity_compute_screen_coordinates

  lda #<spritesheet2_Gort1
  sta entity_locals+gort_locals::sprite_address,x
  lda #>spritesheet2_Gort1
  sta entity_locals+gort_locals::sprite_address+1,x

  jsr gort_draw

  dec entity_locals+gort_locals::counter,x
  bne do_not_switch_to_wait_state

  lda #30
  sta entity_locals+gort_locals::counter,x

  lda #GORT_WAITSTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_wait_state:

  rts

gort_waitState:

  jsr entity_compute_screen_coordinates

  ;only test after a certain number of frames
  lda entity_locals+gort_locals::counter,x
  beq do_not_decrement_counter
  dec entity_locals+gort_locals::counter,x
  bne do_not_switch_to_fire_state
do_not_decrement_counter:

  ;compare Nomolos's X coordinate to the entity's X coordinate

  ;load left side of line A
  lda nomolos_screen_x
  sta b2
  ;load right side of line A
  clc
  adc #nomolos_width
  sta b3

  ;load left side of line B
  lda entity_screen_x
  sec 
  sbc #32
  sta b4
  ;load right side of line B
  clc
  adc #GORT_WIDTH
  adc #64
  sta b5

  jsr geotests_compare_range

  bne do_not_switch_to_fire_state

  ;spawn a laser entity
  lda #entity_index_laser
  sta b0

.scope
  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:

  ;get out low byte of position_x
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #2
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta w0+1

  jmp entity_facing_test_done
entity_facing_right:

  ;get out low byte of position_x
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #(GORT_WIDTH-2)
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  adc #$00
  sta w0+1

entity_facing_test_done:
.endscope

  ;get out position_y
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #$08
  sta b1
  lda entity_instances+entity_instance::position_y+1,x
  adc #$00
  sta b2

  jsr entity_spawn

  ;set how long the Gort will be in the fire state
  lda #30
  sta entity_locals+gort_locals::counter,x

  ;switch to fire state
  lda #GORT_FIRESTATE
  sta entity_instances+entity_instance::state,x

do_not_switch_to_fire_state:

  lda #<spritesheet2_Gort0
  sta entity_locals+gort_locals::sprite_address,x
  lda #>spritesheet2_Gort0
  sta entity_locals+gort_locals::sprite_address+1,x

  jsr gort_draw

  rts

gort_draw:

  jsr entity_test_death_zone
  beq kill_gort
  
  lda entity_instances+entity_instance::position_y+1,x
  bne kill_gort

  ;load gort width and height
  lda #GORT_WIDTH
  sta b2
  lda #GORT_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:

  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load entity width and height
  lda #GORT_WIDTH
  sta b2
  lda #GORT_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox

  bne nomolosNotAttacking

  ;play a hit sound
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

  jmp kill_gort

nomolosNotAttacking:

  lda entity_chr_offsets+(entity_index_gort-1)
  sta sprite_group_offset

  lda entity_locals+gort_locals::sprite_address,x
  sta w0
  lda entity_locals+gort_locals::sprite_address+1,x
  sta w0+1

  jsr entity_test_face_nomolos
  bpl entity_facing_right
entity_facing_left:
  lda #%01000000
  sta b2
  jmp entity_facing_test_done
entity_facing_right:
  lda #%00000000
  sta b2
entity_facing_test_done:

  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_metasprite_16bit

gortOffscreen:
  rts

kill_gort:

  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ;get out low byte of position_x
  lda entity_instances+entity_instance::position_x,x
  sta w0
  ;get out high byte of position_x
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1

  ;get out position_y
  lda entity_instances+entity_instance::position_y,x
  sta b1
  lda entity_instances+entity_instance::position_y+1,x
  sta b2

  jsr entity_spawn

  ;make it dead
  jsr entity_kill

  rts
.endproc

.endif
