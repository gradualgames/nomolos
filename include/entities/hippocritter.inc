.ifndef HIPPOCRITTER_INC
HIPPOCRITTER_INC = 1

HIPPOCRITTER_WIDTH = $10
HIPPOCRITTER_HALFWIDTH = $08
HIPPOCRITTER_HEIGHT = $28
HIPPOCRITTER_HALFHEIGHT = $14

.struct hippocritterLocals
  y_velocity .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
  restCounter .byte
  directionFlag .byte
.endstruct

HIPPOCRITTER_RESTCOUNTER_RESTLENGTH = 25

HIPPOCRITTER_DIRECTIONFLAG_LEFT =  %00000000
HIPPOCRITTER_DIRECTIONFLAG_RIGHT = %00000001

HIPPOCRITTER_INITSTATE = 0
HIPPOCRITTER_RESTSTATE = 1
HIPPOCRITTER_JUMPSTATE = 2

.proc hippocritter_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #HIPPOCRITTER_INITSTATE
  beq hippocritter_initState
  cmp #HIPPOCRITTER_RESTSTATE
  beq hippocritter_restState
  cmp #HIPPOCRITTER_JUMPSTATE
  beq hippocritter_jumpState

hippocritter_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim

  ;position correctly
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc #$18
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #$00
  sta entity_instances+entity_instance::position_y+1,x

  ;set vertical velocity to zero
  lda #0
  sta entity_locals+hippocritterLocals::y_velocity,x
  sta entity_locals+hippocritterLocals::y_velocity+1,x

  ;set rest counter
  lda #HIPPOCRITTER_RESTCOUNTER_RESTLENGTH
  sta entity_locals+hippocritterLocals::restCounter,x

  ;set direction flag
  lda #HIPPOCRITTER_DIRECTIONFLAG_LEFT
  sta entity_locals+hippocritterLocals::directionFlag,x

  ;switch state to "jump"
  lda #HIPPOCRITTER_JUMPSTATE
  sta entity_instances+entity_instance::state,x
  rts

hippocritter_restState:

  ;decrement rest counter
  dec entity_locals+hippocritterLocals::restCounter,x
  bne stillResting

  ;on rest counter = 0, jump to jump state init and set vertical velocity
  lda #$0a
  sta entity_locals+hippocritterLocals::y_velocity,x
  lda #$fd
  sta entity_locals+hippocritterLocals::y_velocity+1,x
  lda #HIPPOCRITTER_JUMPSTATE
  sta entity_instances+entity_instance::state,x

stillResting:

  jsr entity_compute_screen_coordinates
  jsr hippocritter_draw

  rts

hippocritter_jumpState:

  jsr entity_compute_screen_coordinates

  ;slide hippocritter in the direction he is facing
  lda entity_locals+hippocritterLocals::directionFlag,x
  bne hippocritterGoingRight
hippocritterGoingLeft:

  ;test for collision on left side of hippocritter. reverse direction if true
  lda entity_instances+entity_instance::position_x,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #HIPPOCRITTER_HALFHEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq noLeftCollision
  lda #HIPPOCRITTER_DIRECTIONFLAG_RIGHT
  sta entity_locals+hippocritterLocals::directionFlag,x
noLeftCollision:

  lda entity_instances+entity_instance::position_x,x
  sec
  sbc #1
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x

  jmp hippocritterDirectionTestDone
hippocritterGoingRight:

  ;test for collision on right side of hippocritter. reverse direction if true
  lda entity_instances+entity_instance::position_x,x
  clc
  adc #HIPPOCRITTER_WIDTH
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta w0+1
  lda entity_instances+entity_instance::position_y,x
  clc
  adc #HIPPOCRITTER_HALFHEIGHT
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta w1+1
  jsr map_test_collision
  lda b1
  beq noRightCollision
  lda #HIPPOCRITTER_DIRECTIONFLAG_LEFT
  sta entity_locals+hippocritterLocals::directionFlag,x
noRightCollision:

  lda entity_instances+entity_instance::position_x,x
  clc
  adc #1
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x
hippocritterDirectionTestDone:

  ;increment the vertical velocity
  lda entity_locals+hippocritterLocals::y_velocity+1,x
  cmp #10
  bpl stopAccelerating
  clc
  lda entity_locals+hippocritterLocals::y_velocity,x
  adc #$20
  sta entity_locals+hippocritterLocals::y_velocity,x
  lda entity_locals+hippocritterLocals::y_velocity+1,x
  adc #0
  sta entity_locals+hippocritterLocals::y_velocity+1,x
stopAccelerating:

  ;add vertical velocity to 24 bit Y coordinate with sign extension
  clc
  lda entity_locals+hippocritterLocals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+hippocritterLocals::y_velocity+1,x
  bmi signExtend
  adc entity_instances+entity_instance::position_y,x
  sta entity_instances+entity_instance::position_y,x
  lda #0
  adc entity_instances+entity_instance::position_y+1,x
  sta entity_instances+entity_instance::position_y+1,x
  jmp signExtendAddDone
signExtend:
  adc entity_instances+entity_instance::position_y,x
  sta entity_instances+entity_instance::position_y,x
  lda #$ff
  adc entity_instances+entity_instance::position_y+1,x
  sta entity_instances+entity_instance::position_y+1,x
signExtendAddDone:

  ;perform collision detection and eject if necessary
  ;load the entity's X coordinate + 8
  clc
  lda entity_instances+entity_instance::position_x,x
  adc #HIPPOCRITTER_HALFWIDTH
  sta entity_locals+hippocritterLocals::x_collisionPointBottom,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_locals+hippocritterLocals::x_collisionPointBottom+1,x
  sta w0+1
  ;load the entity's Y coordinate + height
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #HIPPOCRITTER_HEIGHT
  sta entity_locals+hippocritterLocals::y_collisionPointBottom,x
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_locals+hippocritterLocals::y_collisionPointBottom+1,x
  sta w1+1

  jsr map_test_collision
  lda b1
  beq noBottomCollision

  lda #0
  sta entity_locals+hippocritterLocals::y_velocity,x
  sta entity_locals+hippocritterLocals::y_velocity+1,x

  ;there was a collision beneath the hippocritter. calculate penetration distance and eject.
  lda entity_locals+hippocritterLocals::y_collisionPointBottom,x
  and #penetration_calculation_mask
  sta entity_locals+hippocritterLocals::y_belowPenetration,x
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc entity_locals+hippocritterLocals::y_belowPenetration,x
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x

  ;set rest counter and transition to rest state. set direction bit based on Nomolos' location.
  lda #HIPPOCRITTER_RESTCOUNTER_RESTLENGTH
  sta entity_locals+hippocritterLocals::restCounter,x
  lda #HIPPOCRITTER_RESTSTATE
  sta entity_instances+entity_instance::state,x

  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:
  lda #HIPPOCRITTER_DIRECTIONFLAG_LEFT
  sta entity_locals+hippocritterLocals::directionFlag,x
  jmp followTestDone
followToRight:
  lda #HIPPOCRITTER_DIRECTIONFLAG_RIGHT
  sta entity_locals+hippocritterLocals::directionFlag,x
followTestDone:

noBottomCollision:

  jsr hippocritter_draw

  rts

hippocritter_draw:

  jsr entity_test_death_zone
  beq killHippocritter

  ;load hippocritter width and height
  lda #HIPPOCRITTER_WIDTH
  sta b2
  lda #HIPPOCRITTER_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos

  bne :+

  jsr nomolos_hurt

:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking

  ;load hippocritter width and height
  lda #HIPPOCRITTER_WIDTH
  sta b2
  lda #HIPPOCRITTER_HEIGHT
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

  jmp killHippocritter

nomolosNotAttacking:

  lda entity_chr_offsets+(entity_index_hippocritter-1)
  sta sprite_group_offset

  lda #<spritesheet2_Hippocritter0
  sta w0
  lda #>spritesheet2_Hippocritter0
  sta w0+1

  lda #0
  sta b2
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1

  jsr sprite_draw_metasprite_16bit

hippocritterOffscreen:
  rts

killHippocritter:

  ;make it dead
  jsr entity_kill

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

  rts
.endproc

.endif
