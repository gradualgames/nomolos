.ifndef SHARK_INC
SHARK_INC = 1

SHARK_WIDTH = $10
SHARK_HALFWIDTH = $08
SHARK_HEIGHT = $10
SHARK_HALFHEIGHT = $08

.struct shark_locals
  y_velocity .word
  y_belowPenetration .byte
  x_collisionPointBottom .word
  y_collisionPointBottom .word
  restCounter .byte
  directionFlag .byte
.endstruct

SHARK_RESTCOUNTER_RESTLENGTH = 50

SHARK_DIRECTIONFLAG_LEFT =  %00000000
SHARK_DIRECTIONFLAG_RIGHT = %00000001

SHARK_INITSTATE = 0
SHARK_RESTSTATE = 1
SHARK_JUMPSTATE = 2

.proc shark_update

  ;load current state
  lda entity_instances+entity_instance::state,x
  ;figure out what state to jump to
  cmp #SHARK_INITSTATE
  beq shark_initState
  cmp #SHARK_RESTSTATE
  beq shark_restState
  cmp #SHARK_JUMPSTATE
  beq shark_jumpState

shark_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim
  
  ;set vertical velocity to zero
  lda #0
  sta entity_locals+shark_locals::y_velocity,x
  sta entity_locals+shark_locals::y_velocity+1,x
  
  ;set rest counter
  lda #SHARK_RESTCOUNTER_RESTLENGTH
  sta entity_locals+shark_locals::restCounter,x
  
  ;set direction flag
  lda #SHARK_DIRECTIONFLAG_LEFT
  sta entity_locals+shark_locals::directionFlag,x
  
  ;switch state to "jump"
  lda #SHARK_JUMPSTATE
  sta entity_instances+entity_instance::state,x
  rts

shark_restState:

  ;decrement rest counter
  dec entity_locals+shark_locals::restCounter,x
  bne stillResting
  
  ;on rest counter = 0, jump to jump state init and set vertical velocity
  lda #$0a
  sta entity_locals+shark_locals::y_velocity,x
  lda #$fc
  sta entity_locals+shark_locals::y_velocity+1,x
  lda #SHARK_JUMPSTATE
  sta entity_instances+entity_instance::state,x
  
  ;reset anim for the arc of the shark's jump to look realistic
  jsr entity_reset_anim
  
stillResting:

  jsr entity_compute_screen_coordinates
  jsr shark_draw

  rts
  
killShark:

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
  
shark_jumpState:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killShark
  
  ;slide shark in the direction he is facing
  lda entity_locals+shark_locals::directionFlag,x
  bne sharkGoingRight
sharkGoingLeft:

  lda entity_instances+entity_instance::position_x,x
  sec
  sbc #2
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  sbc #0
  sta entity_instances+entity_instance::position_x+1,x
  
  jmp sharkDirectionTestDone
sharkGoingRight:

  lda entity_instances+entity_instance::position_x,x
  clc
  adc #2
  sta entity_instances+entity_instance::position_x,x
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_instances+entity_instance::position_x+1,x
sharkDirectionTestDone:

  ;increment the vertical velocity
  lda entity_locals+shark_locals::y_velocity+1,x
  cmp #10
  bpl stopAccelerating
  clc
  lda entity_locals+shark_locals::y_velocity,x
  adc #$20
  sta entity_locals+shark_locals::y_velocity,x
  lda entity_locals+shark_locals::y_velocity+1,x
  adc #0
  sta entity_locals+shark_locals::y_velocity+1,x
stopAccelerating:
  
  ;add vertical velocity to 24 bit Y coordinate with sign extension
  clc
  lda entity_locals+shark_locals::y_velocity,x
  adc entity_instances+entity_instance::position_y_fine,x
  sta entity_instances+entity_instance::position_y_fine,x
  lda entity_locals+shark_locals::y_velocity+1,x
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
  adc #SHARK_HALFWIDTH
  sta entity_locals+shark_locals::x_collisionPointBottom,x
  sta w0
  lda entity_instances+entity_instance::position_x+1,x
  adc #0
  sta entity_locals+shark_locals::x_collisionPointBottom+1,x
  sta w0+1
  ;load the entity's Y coordinate + height
  clc
  lda entity_instances+entity_instance::position_y,x
  adc #SHARK_HEIGHT
  sta entity_locals+shark_locals::y_collisionPointBottom,x
  sta w1
  lda entity_instances+entity_instance::position_y+1,x
  adc #0
  sta entity_locals+shark_locals::y_collisionPointBottom+1,x
  sta w1+1
  
  ;jsr map_test_collision
  ;lda b1
  beq noBottomCollision
  
  lda #0
  sta entity_locals+shark_locals::y_velocity,x
  sta entity_locals+shark_locals::y_velocity+1,x
  
  ;there was a collision beneath the shark. calculate penetration distance and eject.
  lda entity_locals+shark_locals::y_collisionPointBottom,x
  and #penetration_calculation_mask
  sta entity_locals+shark_locals::y_belowPenetration,x
  sec
  lda entity_instances+entity_instance::position_y,x
  sbc entity_locals+shark_locals::y_belowPenetration,x
  sta entity_instances+entity_instance::position_y,x
  lda entity_instances+entity_instance::position_y+1,x
  sbc #0
  sta entity_instances+entity_instance::position_y+1,x
  
  ;set rest counter and transition to rest state. set direction bit based on Nomolos' location.
  lda #SHARK_RESTCOUNTER_RESTLENGTH
  sta entity_locals+shark_locals::restCounter,x
  lda #SHARK_RESTSTATE
  sta entity_instances+entity_instance::state,x
  
  lda entity_screen_x
  sec
  sbc nomolos_screen_x
  lda entity_screen_x+1
  sbc nomolos_screen_x+1
  bmi followToRight
followToLeft:
  lda #SHARK_DIRECTIONFLAG_LEFT
  sta entity_locals+shark_locals::directionFlag,x
  jmp followTestDone
followToRight:
  lda #SHARK_DIRECTIONFLAG_RIGHT
  sta entity_locals+shark_locals::directionFlag,x
followTestDone:
  
noBottomCollision:  
  
  jsr shark_draw

  rts
  
shark_draw:

  ;load shark width and height
  lda #SHARK_WIDTH
  sta b2
  lda #SHARK_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking
  
  ;load shark width and height
  lda #SHARK_WIDTH
  sta b2
  lda #SHARK_HEIGHT
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
  
  jmp killShark
  
nomolosNotAttacking:

  lda entity_chr_offsets+(entity_index_shark-1)
  sta sprite_group_offset

  lda #<spritesheet1_SharkLeap
  sta w2
  lda #>spritesheet1_SharkLeap
  sta w2+1

  lda entity_locals+shark_locals::directionFlag,x
  bne entity_facing_right
entity_facing_left:
  lda #%01000000
  sta b2
  jmp entity_facing_test_done
entity_facing_right:
  lda #%00000000
  sta b2
entity_facing_test_done:

  jsr entity_draw_anim

sharkOffscreen:
  rts
  
.endproc
  
.endif
