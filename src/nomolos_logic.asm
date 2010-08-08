.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "sprite.inc"
.include "map.inc"
.include "camera.inc"
.include "soundengine.inc"
.include "zp.inc"
.include "fixed_bank_data.inc"
.include "nomolos_logic.inc"
.include "controller.inc"
.include "play_level_state.inc"

.segment "CODE"

;this should be called when initializing the game
.proc nomolos_module_init

  lda #0
  sta nomolos_state_secondary

  rts

.endproc

;this should be called at the beginning of any level
.proc nomolos_init

  resetAnim nomolos_animation
  resetAnim nomolos_weapon_animation

  lda #0
  and #nomolos_walking_right_clear
  sta nomolos_state_primary

  lda #0
  sta nomolos_x_velocity
  lda #2
  sta nomolos_x_velocity+1
  lda #$00
  sta nomolos_y_velocity
  lda #$00
  sta nomolos_y_velocity+1

  lda #0
  sta nomolos_map_x
  ldy #level_data_struct::nomolos_start_x
  lda (base_address_rom_definition_table),y
  sta nomolos_map_x+1
  ldy #level_data_struct::starting_screen
  lda (base_address_rom_definition_table),y
  sta nomolos_map_x+2

  lda #0
  sta nomolos_map_y
  ldy #level_data_struct::nomolos_start_y
  lda (base_address_rom_definition_table),y
  sta nomolos_map_y+1
  lda #0
  sta nomolos_map_y+2

  jsr nomolos_compute_screen_coordinates

  lda #3
  sta nomolos_status_health

  lda #0
  sta nomolos_counter_attack_rect

  lda #0
  sta nomolos_attack_rect_x
  sta nomolos_attack_rect_x+1
  lda #0
  sta nomolos_attack_rect_y
  sta nomolos_attack_rect_y+1

  rts

.endproc

;adds a life to Nomolos. The accumulator is assumed to contain the
;number of lives to add.
.proc nomolos_add_life

  clc
  adc nomolos_status_lives
  sta nomolos_status_lives

  cmp #max_lives
  bmi :+
  lda #max_lives
  sta nomolos_status_lives
:
  rts

.endproc

;adds health to Nomolos. The accumulator is assumed to contain the
;number of hearts to add on to his health.
.proc nomolos_add_health

  clc
  adc nomolos_status_health
  sta nomolos_status_health

  cmp #max_health  ;if result is negative, that means nomolos_status_health - max_health was negative, which means we're less than max_health
                  ;negative is less, positive is more
  bmi :+
  lda #max_health
  sta nomolos_status_health
:

  rts

.endproc

;hurts Nomolos. It makes him bounce in the air a little bit, lose a heart,
;and become invincible temporarily.
.proc nomolos_hurt

  .ifdef INVINCIBLE
  rts
  .endif

  ;if blinking is on, skip this whole routine
  lda nomolos_state_primary
  and #nomolos_blinking_test
  lsr
  lsr
  bne skipHurt

  ;decrease nomolos' health.
  lda nomolos_status_health
  beq skipDecreaseHealth

  ;play a get hurt sound
  lda #<getHurtSound
  sta sound_param_word_0
  lda #>getHurtSound
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  dec nomolos_status_health
  bne nomolosNotDead

  ;on the instant that nomolos dies, we want him to die.
  jsr nomolos_die_attack

nomolosNotDead:
skipDecreaseHealth:

  ;make nomolos bounce a little bit.
  lda #nomolos_hurt_bounce_lo
  sta nomolos_y_velocity
  lda #nomolos_hurt_bounce_hi
  sta nomolos_y_velocity+1

  ;turn on blinking
  lda #$60
  sta nomolos_counter_temp_invincibility_blink
  lda nomolos_state_primary
  ora #nomolos_blinking_on_set
  sta nomolos_state_primary

skipHurt:

  rts

.endproc

;sets the nomolos dying state bit, and the sub state bit that represents "falling"
.proc nomolos_die_fall

  ;make certain we're not already dying...
  lda nomolos_state_primary
  and #nomolos_dying_test
  bne alreadyDying

  ;lose special weapon if any
  lda nomolos_state_secondary
  and #nomolos_attack_set_mask
  sta nomolos_state_secondary

  ;decrease Nomolos' lives
  dec nomolos_status_lives

  ;make nomolos die.
  lda nomolos_state_primary
  ora #nomolos_dying_on_set
  sta nomolos_state_primary

  ;make sure all following logic knows that this is death by falling.
  lda nomolos_state_secondary
  and #nomolos_fell_dying_clear
  sta nomolos_state_secondary

  ;store a frame counter value so we can pause a bit before transitioning to level out
  lda #127
  sta frame_counter

  ;stop all sound
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif

  ;play a die sound
  lda #<dieSound
  sta sound_param_word_0
  lda #>dieSound
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

alreadyDying:

  rts

.endproc

;sets the nomolos dying state bit and sets coordinates for the scaredy cat graphic.
.proc nomolos_die_attack

  ;decrease Nomolos' lives
  dec nomolos_status_lives

  ;lose special weapon if any
  lda nomolos_state_secondary
  and #nomolos_attack_set_mask
  sta nomolos_state_secondary

  ;make nomolos die.
  lda nomolos_state_primary
  ora #nomolos_dying_on_set
  sta nomolos_state_primary

  ;make sure all following logic knows that this is death by being attacked
  lda nomolos_state_secondary
  ora #nomolos_attacked_dying_set
  sta nomolos_state_secondary

  ;transfer current screen coordinates to scaredy cat coordinates.
  lda nomolos_screen_x
  sta nomolos_out_of_armor_screen_x
  lda nomolos_screen_x+1
  sta nomolos_out_of_armor_screen_x+1

  lda nomolos_screen_y
  sta nomolos_out_of_armor_screen_y
  lda nomolos_screen_y+1
  sta nomolos_out_of_armor_screen_y+1

  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif

  ;play a die sound
  lda #<dieSound
  sta sound_param_word_0
  lda #>dieSound
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  rts

.endproc

.proc nomolos_attack_spear

  lda #<attackSpearSound
  sta sound_param_word_0
  lda #>attackSpearSound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  ;turn on the attack hit box
  lda #$0c
  sta nomolos_counter_attack_rect
  lda nomolos_state_primary
  ora #nomolos_attack_on_set
  sta nomolos_state_primary

  ;reset animation
  resetAnim nomolos_animation

  ;set initial location for the hit box
  lda #$20
  sta nomolos_attack_rect_width
  lda #$08
  sta nomolos_attack_rect_height

  lda nomolos_state_primary
  and #1
  beq skipNomolosFacingLeft

  clc
  lda nomolos_screen_x
  adc #$f0
  sta nomolos_attack_rect_x
  lda nomolos_screen_x+1
  adc #$ff
  sta nomolos_attack_rect_x+1

  clc
  lda nomolos_screen_y
  adc #$0C
  sta nomolos_attack_rect_y
  lda nomolos_screen_y+1
  adc #$00
  sta nomolos_attack_rect_y+1

  ;flag that the spear is moving to the left
  lda nomolos_state_secondary
  and #nomolos_attack_direction_left_clear
  sta nomolos_state_secondary

  jmp skipNomolosFacingRight
skipNomolosFacingLeft:

  clc
  lda nomolos_screen_x
  adc #$10
  sta nomolos_attack_rect_x
  lda nomolos_screen_x+1
  adc #$00
  sta nomolos_attack_rect_x+1

  clc
  lda nomolos_screen_y
  adc #$0C
  sta nomolos_attack_rect_y
  lda nomolos_screen_y+1
  adc #$00
  sta nomolos_attack_rect_y+1

  ;flag that the spear is moving to the right
  lda nomolos_state_secondary
  ora #nomolos_attack_direction_right_set
  sta nomolos_state_secondary

skipNomolosFacingRight:

  rts

.endproc

.proc nomolos_attack_sword

  ;play an attack sound
  ldy #level_data_struct::attack_sound
  lda (base_address_rom_definition_table),y
  sta sound_param_word_0
  iny
  lda (base_address_rom_definition_table),y
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  ;turn on the attack hit box
  lda #$0c
  sta nomolos_counter_attack_rect
  lda nomolos_state_primary
  ora #nomolos_attack_on_set
  sta nomolos_state_primary

  ;reset animation
  resetAnim nomolos_animation

  rts

.endproc

.proc nomolos_attack_flail

  ;play an attack sound
  lda #<attackFlailSound
  sta sound_param_word_0
  lda #>attackFlailSound
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  ;turn on the attack hit box
  lda #nomolos_attack_flail_length
  sta nomolos_counter_attack_rect
  lda nomolos_state_primary
  ora #nomolos_attack_on_set
  sta nomolos_state_primary

  ;clear the location of the hit box
  lda #0
  sta nomolos_attack_rect_x
  sta nomolos_attack_rect_x+1
  sta nomolos_attack_rect_y
  sta nomolos_attack_rect_y+1
  sta nomolos_attack_rect_width
  sta nomolos_attack_rect_height

  ;reset animation
  resetAnim nomolos_animation

  ;reset weapon animation
  resetAnim nomolos_weapon_animation

  rts

.endproc

;Causes the hit box to be activated for a few frames.
.proc nomolos_attack

  ;if attacking is on, skip this whole routine
  lda nomolos_state_primary
  and #nomolos_attack_test
  bne skipAttack

  lda nomolos_state_secondary
  and #nomolos_attack_test_mask
  cmp #nomolos_attack_state_sword
  beq nomolosAttackSwordBranch
  cmp #nomolos_attack_state_flail
  beq nomolosAttackFlailBranch
  cmp #nomolos_attack_state_spear
  beq nomolosAttackSpearBranch
  jmp attackSwitchDone

nomolosAttackSpearBranch:

  jsr nomolos_attack_spear

  jmp attackSwitchDone

nomolosAttackSwordBranch:

  jsr nomolos_attack_sword

  jmp attackSwitchDone

nomolosAttackFlailBranch:

  jsr nomolos_attack_flail

attackSwitchDone:
skipAttack:

  rts

.endproc

;tests nomolos' state and animation and returns whether he is currently deadly.
;This routine should be used by entities to determine if they ought to be damaged
;by Nomolos' hit box.
;zero flag set = nomolos is not deadly
;zero flag clear = nomolos is deadly.
.proc nomolos_is_deadly

  lda nomolos_state_primary
  and #nomolos_attack_test
  beq nomolosNotAttacking

  lda nomolos_state_secondary
  and #nomolos_attack_test_mask
  cmp #nomolos_attack_state_sword
  beq nomolosAttackSwordBranch
  cmp #nomolos_attack_state_flail
  beq nomolosAttackFlailBranch
  cmp #nomolos_attack_state_spear
  beq nomolosAttackSpearBranch
  jmp attackSwitchDone

nomolosAttackSpearBranch:

  lda #1

  rts

  jmp attackSwitchDone

nomolosAttackSwordBranch:
  ;load current frame
  lda nomolos_animation+1
  cmp #0
  beq nomolosPawNotExtended

  ;we know his paw is extended here, clear zero flag
  lda #1

  rts

nomolosPawNotExtended:

  jmp attackSwitchDone

nomolosAttackFlailBranch:

  ;flail deadliness does not live as long as the counter
  lda nomolos_counter_attack_rect
  cmp #(nomolos_attack_flail_length - nomolos_attack_flail_deadly_length)
  bmi nomolosNotAttacking

  lda #1

  rts

attackSwitchDone:

nomolosNotAttacking:

  lda #0

  rts

.endproc

.proc nomolos_load_hurt_result

  ;load "hurt" result of map collision test
  lda b0
  beq :+
  lda nomolos_state_primary
  ora #nomolos_hurt_by_map_on_set
  sta nomolos_state_primary
:
  rts

.endproc

.proc nomolos_update_attack_sword

  lda #$10
  sta nomolos_attack_rect_width
  lda #$20
  sta nomolos_attack_rect_height

  lda nomolos_state_primary
  and #1
  beq skipNomolosFacingLeft

  clc
  lda nomolos_screen_x
  adc #$f0
  sta nomolos_attack_rect_x
  lda nomolos_screen_x+1
  adc #$ff
  sta nomolos_attack_rect_x+1

  lda nomolos_screen_y
  sta nomolos_attack_rect_y
  lda nomolos_screen_y+1
  sta nomolos_attack_rect_y+1

  jmp skipNomolosFacingRight
skipNomolosFacingLeft:

  clc
  lda nomolos_screen_x
  adc #$10
  sta nomolos_attack_rect_x
  lda nomolos_screen_x+1
  adc #$00
  sta nomolos_attack_rect_x+1

  lda nomolos_screen_y
  sta nomolos_attack_rect_y
  lda nomolos_screen_y+1
  sta nomolos_attack_rect_y+1

skipNomolosFacingRight:

  dec nomolos_counter_attack_rect
  bne skipAttackUpdate

  ;set attack state to off
  lda nomolos_state_primary
  and #nomolos_attack_off_clear
  sta nomolos_state_primary

  ;reset animation object
  resetAnim nomolos_animation
skipAttackUpdate:

  rts

.endproc

.proc nomolos_update_attack_flail

  ;store size of attack rect for flail
  lda #$38
  sta nomolos_attack_rect_width
  lda #$28
  sta nomolos_attack_rect_height

  ;test the direction Nomolos is facing
  lda nomolos_state_primary
  and #nomolos_walking_left_test
  beq nomolos_facing_right
nomolos_facing_left:

  sec
  lda nomolos_screen_x
  sbc #16
  sta nomolos_attack_rect_x
  lda nomolos_screen_x+1
  sbc #0
  sta nomolos_attack_rect_x+1

  sec
  lda nomolos_screen_y
  sbc #16
  sta nomolos_attack_rect_y
  lda nomolos_screen_y+1
  sbc #0
  sta nomolos_attack_rect_y+1

  jmp nomolos_direction_test_done
nomolos_facing_right:

  sec
  lda nomolos_screen_x
  sbc #24
  sta nomolos_attack_rect_x
  lda nomolos_screen_x+1
  sbc #0
  sta nomolos_attack_rect_x+1

  sec
  lda nomolos_screen_y
  sbc #16
  sta nomolos_attack_rect_y
  lda nomolos_screen_y+1
  sbc #0
  sta nomolos_attack_rect_y+1

nomolos_direction_test_done:

  dec nomolos_counter_attack_rect
  bne skip_attack_update

  ;set attack state to off
  lda nomolos_state_primary
  and #nomolos_attack_off_clear
  sta nomolos_state_primary

  ;reset animation object
  resetAnim nomolos_animation
skip_attack_update:

  rts

.endproc

.proc nomolos_update_attack_spear

  ;move the spear in the direction flagged by secondary state
  lda nomolos_state_secondary
  and #nomolos_attack_direction_test
  bne nomolosAttackRight
nomolosAttackLeft:

  sec
  lda nomolos_attack_rect_x
  sbc #10
  sta nomolos_attack_rect_x
  lda nomolos_attack_rect_x+1
  sbc #0
  sta nomolos_attack_rect_x+1

  jmp nomolosDirectionTestDone

nomolosAttackRight:

  clc
  lda nomolos_attack_rect_x
  adc #10
  sta nomolos_attack_rect_x
  lda nomolos_attack_rect_x+1
  adc #0
  sta nomolos_attack_rect_x+1

nomolosDirectionTestDone:

  dec nomolos_counter_attack_rect
  bne skipAttackUpdate

  ;set attack state to off
  lda nomolos_state_primary
  and #nomolos_attack_off_clear
  sta nomolos_state_primary

  ;reset animation object
  resetAnim nomolos_animation
skipAttackUpdate:
  rts

.endproc

.proc nomolos_test_collision_below

  ;Is there a collision at bottom left of Nomolos?
  lda nomolos_map_x+1
  sta w0
  lda nomolos_map_x+2
  sta w0+1
  lda nomolos_map_y+1
  clc
  adc #(nomolos_height+1)
  sta w1
  lda nomolos_map_y+2
  adc #0
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne yesBelowCollision

  ;Is there a collision at bottom right of Nomolos?
  lda nomolos_map_x+1
  clc
  adc #$0f
  sta w0
  lda nomolos_map_x+2
  adc #$00
  sta w0+1
  lda nomolos_map_y+1
  clc
  adc #(nomolos_height+1)
  sta w1
  lda nomolos_map_y+2
  adc #0
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne yesBelowCollision

noBelowCollision:
  rts

yesBelowCollision:

  ;Calculate penetration distance and store it in belowPenetrationDistance.
  ;Set below collision flag.
  lda nomolos_map_y+1
  clc
  adc #(nomolos_height+1)
  and #penetration_calculation_mask
  sta nomolos_below_ejection_distance

  ;eject by penetration distance
  lda nomolos_map_y+1
  sec
  sbc nomolos_below_ejection_distance
  sta nomolos_map_y+1
  lda nomolos_map_y+2
  sbc #0
  sta nomolos_map_y+2

  lda nomolos_state_primary
  ora #nomolos_below_collision_on_set
  sta nomolos_state_primary

  ;************************************************************
  ;Test A button for off-to-on transition and start the jump
  ;into the air if so.
  ;************************************************************

  ;Test if current state of A button is down and previous state is up. In other words,
  ;AND with #%00000011, then test for equality to 1.
  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #1
  bne skipButtonATest

  lda #nomolos_start_jump_lo
  sta nomolos_y_velocity
  lda #nomolos_start_jump_hi
  sta nomolos_y_velocity+1

  rts

skipButtonATest:

  ;set velocity to zero, since we've collided with the ground and the player
  ;has not pressed A.
  lda #0
  sta nomolos_y_velocity
  sta nomolos_y_velocity+1

  rts

.endproc

.proc nomolos_test_collision_above

  ;Is there a collision at top left of Nomolos?
  lda nomolos_map_x+1
  sta w0
  lda nomolos_map_x+2
  sta w0+1
  lda nomolos_map_y+1
  sta w1
  lda nomolos_map_y+2
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne yesAboveCollision

  ;Is there a collision at top right of Nomolos?
  lda nomolos_map_x+1
  clc
  adc #$0f
  sta w0
  lda nomolos_map_x+2
  adc #$00
  sta w0+1
  lda nomolos_map_y+1
  sta w1
  lda nomolos_map_y+2
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne yesAboveCollision

  ;is current state of A button released, and previous state of A button pressed?
  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000010
  bne dontStopRising

  ;yes, so stop rising into the air.
  lda #0
  sta nomolos_y_velocity
  sta nomolos_y_velocity+1
dontStopRising:

  rts

yesAboveCollision:
  ;There was an above collision:

  ;Calculate penetration distance and store it in abovePenetrationDistance.
  ;Set above collision flag.
  lda nomolos_map_y+1
  and #penetration_calculation_mask
  sta nomolos_above_ejection_distance
  lda #$0f  ;we subtract the above penetration distance from the height of a tile.
  sec
  sbc nomolos_above_ejection_distance
  sta nomolos_above_ejection_distance

  ;eject by penetration distance
  lda nomolos_map_y+1
  clc
  adc nomolos_above_ejection_distance
  sta nomolos_map_y+1
  lda nomolos_map_y+2
  adc #0
  sta nomolos_map_y+2

  lda nomolos_state_primary
  ora #nomolos_above_collision_on_set
  sta nomolos_state_primary

  ;reset velocity
  lda #0
  sta nomolos_y_velocity
  sta nomolos_y_velocity+1

  rts
.endproc

.proc nomolos_update

  ;************************************************************
  ;Load NomolosY coordinate and test to see if he is off screen
  ;to the bottom. If he is, he should die.
  ;************************************************************
  lda nomolos_map_y+2
  cmp #1
  bne @nomolosNotDead
  jsr nomolos_die_fall
@nomolosNotDead:

  ;************************************************************
  ;Load "nomolos dying" flag and update associated variables if
  ;true. Move scaredy cat graphic upwards and clear buttons
  ;that we do not want to respond to when dying is true.
  ;************************************************************
  lda nomolos_state_primary
  and #nomolos_dying_test
  beq nomolosNotDying

  ;clear buttons we don't want to respond to during dying state.
  lda #0
  sta buffer_controller+buttons::_a
  sta buffer_controller+buttons::_b
  sta buffer_controller+buttons::_left
  sta buffer_controller+buttons::_right

  lda nomolos_state_secondary
  and #nomolos_attacked_dying_test
  beq nomolosNotAttackedDying

  ;move scaredy cat graphic upwards.
  sec
  lda nomolos_out_of_armor_screen_y
  sbc #$03
  sta nomolos_out_of_armor_screen_y
  lda nomolos_out_of_armor_screen_y+1
  sbc #$00
  sta nomolos_out_of_armor_screen_y+1

  ;when the scaredy cat Y reaches a certain coordinate off the screen,
  ;we want to transition out of this level and to an appropriate "level in"
  ;state. For now, we will just re-load the current level.
  cmp #$fe
  bne scaredyCatStillRising

  lda #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  sta state_control_params+play_level_state_control::state

scaredyCatStillRising:

  jmp nomolosNotDying

nomolosNotAttackedDying:

  dec frame_counter
  bne skipLevelOutState

  lda #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  sta state_control_params+play_level_state_control::state

skipLevelOutState:

  ;we continue from here because we want to keep updating Nomolos'
  ;coordinates. They are used for the slumped armor so it can fall
  ;while Nomolos leaps off the screen in terror.

nomolosNotDying:

  ;************************************************************
  ;Load result of "hurt by map" flag and hurt nomolos if true.
  ;************************************************************
  lda nomolos_state_primary
  and #nomolos_hurt_by_map_test
  beq @notHurtByMap
  lda nomolos_state_primary
  and #nomolos_hurt_by_map_off_clear
  sta nomolos_state_primary
  jsr nomolos_hurt
@notHurtByMap:

  ;************************************************************
  ;Update counters for temporary invincibility and for attack
  ;hit box. Call attack routine if B transitions from off to
  ;on. Do not allow left or right movement if Nomolos is on the
  ;ground and in attack state.
  ;************************************************************

  ;Update blink counter and reset if zero
  dec nomolos_counter_temp_invincibility_blink
  bne skipBlinkReset

  lda nomolos_state_primary
  and #nomolos_blinking_off_clear
  sta nomolos_state_primary
skipBlinkReset:

  ;Update hitbox counter if attack state on
  lda nomolos_state_primary
  and #nomolos_attack_test
  beq skipAttack
  ;attack state was on

  ;test if anything is currently beneath nomolos
  lda nomolos_state_primary
  and #nomolos_below_collision_test
  beq below_collision_false
  ;nomolos is attacking and on the ground---don't let him
  ;move left or right. Store an on-to-off transition.
  lda #%00000010
  sta buffer_controller+buttons::_left
  lda #%00000010
  sta buffer_controller+buttons::_right

below_collision_false:

  lda nomolos_state_secondary
  and #nomolos_attack_test_mask
  cmp #nomolos_attack_state_sword
  beq nomolosAttackSwordBranch
  cmp #nomolos_attack_state_flail
  beq nomolosAttackFlailBranch
  cmp #nomolos_attack_state_spear
  beq nomolosAttackSpearBranch
  jmp attackSwitchDone

nomolosAttackSpearBranch:

  jsr nomolos_update_attack_spear

  jmp attackSwitchDone

nomolosAttackSwordBranch:

  jsr nomolos_update_attack_sword

  jmp attackSwitchDone

nomolosAttackFlailBranch:

  jsr nomolos_update_attack_flail

attackSwitchDone:
skipAttack:

  ;Run attack routine if B transitions from off to on
  lda buffer_controller+buttons::_b
  and #%00000011
  ;test for transition from off to on
  cmp #%00000001
  bne :+
  jsr nomolos_attack
:

  ;************************************************************
  ;Make gravity act on Nomolos.
  ;************************************************************

  ;Compare vertical speed max to current vertical speed.
  lda #nomolos_vertical_speed_max
  sec
  sbc nomolos_y_velocity+1
  ;we want to skip the following code if the result was negative
  bmi DoNotIncrementSpeed
  ;Yes:
  ;  nomolos_y_velocity = nomolos_y_velocity + nomolosVerticalAcceleration
  lda nomolos_y_velocity
  clc
  adc #nomolos_vertical_acceleration_lo
  sta nomolos_y_velocity
  lda nomolos_y_velocity+1
  adc #nomolos_vertical_acceleration_hi
  sta nomolos_y_velocity+1
DoNotIncrementSpeed:
  jsr nomolos_compute_screen_coordinates

  ;************************************************************
  ;Move vertical position according to vertical speed.
  ;************************************************************
  clc
  lda nomolos_map_y
  adc nomolos_y_velocity
  sta nomolos_map_y
  lda nomolos_map_y+1
  adc nomolos_y_velocity+1
  sta nomolos_map_y+1
  lda nomolos_y_velocity+1
  bmi @signExtend
  lda nomolos_map_y+2
  adc #0
  sta nomolos_map_y+2
  jmp noSignExtend
@signExtend:
  lda nomolos_map_y+2
  adc #$ff
  sta nomolos_map_y+2
noSignExtend:

  ;************************************************************
  ;Test vertical velocity sign and then detect collision with
  ;map and eject if necessary. Also check for A button press
  ;or release to start/stop jumping.
  ;************************************************************
  ;clear the collision flags
  lda nomolos_state_primary
  and #nomolos_below_collision_off_clear
  and #nomolos_above_collision_off_clear
  sta nomolos_state_primary

  lda nomolos_y_velocity+1
  bmi ySpeedNegative
ySpeedPositive:
  jsr nomolos_test_collision_below

  jmp ySpeedTestDone
ySpeedNegative:
  jsr nomolos_test_collision_above

dontStopRising:

ySpeedTestDone:

  ;************************************************************
  ;Test left and right buttons. Test for collision to the left
  ;and to the right. Move if there is room. Reset animation
  ;according to whether fighting state is off and on-to-off
  ;transition is true.
  ;************************************************************

  ;is there an on to off transition on the left button?
  lda buffer_controller+buttons::_left
  and #%00000011
  cmp #%00000010
  bne @skipMoveOff

  lda nomolos_state_primary
  ;if attack is on, do not reset the animation
  and #nomolos_attack_test
  bne @skipResetAnim
  resetAnim nomolos_animation
@skipResetAnim:

  lda nomolos_state_primary
  and #nomolos_moving_off_clear       ;state not moving
  sta nomolos_state_primary
@skipMoveOff:

  lda buffer_controller+buttons::_left ;Left

  ;is left button down?
  and #1
  bne skipJmpNotLeft
  jmp notLeft
skipJmpNotLeft:
  lda nomolos_state_primary
  ora #nomolos_walking_left_set
  ora #nomolos_moving_on_set

  sta nomolos_state_primary

  ;test collision with map
  lda nomolos_map_x+1
  sec
  sbc #1
  sta w0
  lda nomolos_map_x+2
  sbc #0
  sta w0+1
  lda nomolos_map_y+1
  clc
  adc #1
  sta w1
  lda nomolos_map_y+2
  adc #0
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne notLeft

  lda nomolos_map_x+1
  sec
  sbc #1
  sta w0
  lda nomolos_map_x+2
  sbc #0
  sta w0+1
  lda nomolos_map_y+1
  clc
  adc #$0f
  sta w1
  lda nomolos_map_y+2
  adc #0
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne notLeft

  lda nomolos_map_x+1
  sec
  sbc #1
  sta w0
  lda nomolos_map_x+2
  sbc #0
  sta w0+1
  lda nomolos_map_y+1
  clc
  adc #$1e
  sta w1
  lda nomolos_map_y+2
  adc #0
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne notLeft


  ;24 bit Sub
  sec
  lda nomolos_map_x
  sbc nomolos_x_velocity
  sta nomolos_map_x
  lda nomolos_map_x+1
  sbc nomolos_x_velocity+1
  sta nomolos_map_x+1
  lda nomolos_map_x+2
  sbc #0
  sta nomolos_map_x+2

  bpl skip_nomolos_do_not_go_past_zero

  lda #0
  sta nomolos_map_x
  sta nomolos_map_x+1
  sta nomolos_map_x+2

skip_nomolos_do_not_go_past_zero:

  lda nomolos_screen_x
  sta w0
  lda nomolos_screen_x+1
  sta w0+1
  jsr camera_scroll_left

  jsr nomolos_compute_screen_coordinates

notLeft:

  ;is there an on to off transition on the right button?
  lda buffer_controller+buttons::_right
  and #%00000011
  cmp #%00000010
  bne @skipMoveOff

  lda nomolos_state_primary
  ;if attack is on, do not reset the animation
  and #nomolos_attack_test
  bne @skipResetAnim
  resetAnim nomolos_animation
@skipResetAnim:

  lda nomolos_state_primary
  and #nomolos_moving_off_clear       ;state not moving
  sta nomolos_state_primary
@skipMoveOff:

  lda buffer_controller+buttons::_right ; Right

  ;is right button down?
  and #1
  bne skipJmpNotRight
  jmp notRight
skipJmpNotRight:

  lda nomolos_state_primary
  and #nomolos_walking_right_clear ;state is walking right
  ora #nomolos_moving_on_set       ;state is moving
  sta nomolos_state_primary

  ;test collision with map
  lda nomolos_map_x+1
  clc
  adc #$10
  sta w0
  lda nomolos_map_x+2
  adc #$00
  sta w0+1
  lda nomolos_map_y+1
  clc
  adc #1
  sta w1
  lda nomolos_map_y+2
  adc #0
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne notRight

  ;lda nomolos_map_x+1
  lda nomolos_map_x+1
  clc
  adc #$10
  sta w0
  lda nomolos_map_x+2
  adc #$00
  sta w0+1
  lda nomolos_map_y+1
  clc
  adc #$0f
  sta w1
  lda nomolos_map_y+2
  adc #0
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne notRight

  lda nomolos_map_x+1
  clc
  adc #$10
  sta w0
  lda nomolos_map_x+2
  adc #$00
  sta w0+1
  lda nomolos_map_y+1
  clc
  adc #$1e
  sta w1
  lda nomolos_map_y+2
  adc #0
  sta w1+1
  jsr map_test_collision
  jsr nomolos_load_hurt_result
  lda b1
  bne notRight

  ;24 bit add
  clc
  lda nomolos_map_x
  adc nomolos_x_velocity
  sta nomolos_map_x
  lda nomolos_map_x+1
  adc nomolos_x_velocity+1
  sta nomolos_map_x+1
  lda nomolos_map_x+2
  adc #0
  sta nomolos_map_x+2

  lda nomolos_screen_x
  sta w0
  lda nomolos_screen_x+1
  sta w0+1
  jsr camera_scroll_right

  jsr nomolos_compute_screen_coordinates

notRight:

  ;************************************************************
  ;Update Nomolos' animation object.
  ;************************************************************
  jsr nomolos_update_animation

  rts
.endproc

.proc nomolos_compute_screen_coordinates
  ;************************************************************
  ;Compute screen coordinates from level coordinates.
  ;************************************************************

  lda nomolos_map_x+1
  sta w0
  lda nomolos_map_x+2
  sta w0+1
  lda nomolos_map_y+1
  sta w1
  lda nomolos_map_y+2
  sta w1+1
  jsr camera_to_screen_coords
  lda w0
  sta nomolos_screen_x
  lda w0+1
  sta nomolos_screen_x+1
  lda w1
  sta nomolos_screen_y
  lda w1+1
  sta nomolos_screen_y+1

  rts
.endproc

.proc nomolos_update_animation

  ;switch to the actor and entity bank
  ldy #level_data_struct::nomolos_entity_bank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank

  lda #<nomolos_animation
  sta w1
  lda #>nomolos_animation
  sta w1+1

  lda nomolos_state_primary
  and #nomolos_attack_test
  beq skipUpdatenomolos_fighting

  lda nomolos_state_secondary
  and #nomolos_attack_test_mask
  cmp #nomolos_attack_state_sword
  beq nomolosAttackSwordBranch
  cmp #nomolos_attack_state_flail
  beq nomolosAttackFlailBranch
  cmp #nomolos_attack_state_spear
  beq nomolosAttackSpearBranch
  jmp attackSwitchDone

nomolosAttackSpearBranch:
  ldy #level_data_struct::nomolos_spear
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_update_animation

  jmp attackSwitchDone

nomolosAttackSwordBranch:
  ldy #level_data_struct::nomolos_fight
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_update_animation

  jmp attackSwitchDone

nomolosAttackFlailBranch:

  ldy #level_data_struct::nomolos_flail
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_update_animation

  lda #<nomolos_weapon_animation
  sta w1
  lda #>nomolos_weapon_animation
  sta w1+1

  ldy #level_data_struct::nomolos_flail_ball
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_update_animation

attackSwitchDone:
  rts
skipUpdatenomolos_fighting:

  lda nomolos_state_primary
  and #nomolos_moving_test
  beq skipUpdateNomolosMoving
  ldy #level_data_struct::nomolos_walk
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_update_animation
skipUpdateNomolosMoving:

  rts

.endproc

.proc nomolos_draw_attack_flail

  ;animation does not live as long as the attack counter
  lda nomolos_counter_attack_rect
  cmp #(nomolos_attack_flail_length - nomolos_attack_flail_deadly_length)
  bmi do_not_draw_flail

  ;draw the flail animation and flail ball animation here
  lda #<nomolos_animation
  sta w1
  lda #>nomolos_animation
  sta w1+1

  ldy #level_data_struct::nomolos_flail
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  ;get the direction bit into bit 6 of b2 for horiz flip
  clc
  lda nomolos_state_primary
  and #1
  ror
  ror
  ror
  sta b2

  lda nomolos_screen_x
  sta w3
  lda nomolos_screen_x+1
  sta w3+1
  lda nomolos_screen_y
  sta w4
  lda nomolos_screen_y+1
  sta w4+1

  jsr sprite_draw_animation_16bit

  ldy #level_data_struct::nomolos_flail_overlay
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_draw_animation_16bit

  lda #<nomolos_weapon_animation
  sta w1
  lda #>nomolos_weapon_animation
  sta w1+1

  ldy #level_data_struct::nomolos_flail_ball
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_draw_animation_16bit

  rts

do_not_draw_flail:

  resetAnim nomolos_animation

  jsr nomolos_draw_jumping_set_walking

  rts

.endproc

.proc nomolos_draw_attack_sword

  lda #<nomolos_animation
  sta w1
  lda #>nomolos_animation
  sta w1+1

  ldy #level_data_struct::nomolos_fight
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  ;get the direction bit into bit 6 of b2 for horiz flip
  clc
  lda nomolos_state_primary
  and #1
  ror
  ror
  ror
  sta b2

  lda nomolos_screen_x
  sta w3
  lda nomolos_screen_x+1
  sta w3+1
  lda nomolos_screen_y
  sta w4
  lda nomolos_screen_y+1
  sta w4+1

  jsr sprite_draw_animation_16bit

  ldy #level_data_struct::nomolos_fight_overlay
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_draw_animation_16bit

  rts

.endproc

.proc nomolos_draw_attack_spear

  lda #<nomolos_animation
  sta w1
  lda #>nomolos_animation
  sta w1+1

  ldy #level_data_struct::nomolos_spear
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  ;get the direction bit into bit 6 of b2 for horiz flip
  clc
  lda nomolos_state_secondary
  eor #$ff
  and #nomolos_attack_direction_test
  rol
  rol
  rol
  sta b2

  lda nomolos_screen_x
  sta w3
  lda nomolos_screen_x+1
  sta w3+1
  lda nomolos_screen_y
  sta w4
  lda nomolos_screen_y+1
  sta w4+1

  jsr sprite_draw_animation_16bit

  ldy #level_data_struct::nomolos_fight_overlay
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_draw_animation_16bit

  ;draw the spear at the location of the hit box
  lda nomolos_attack_rect_x
  sta w3
  lda nomolos_attack_rect_x+1
  sta w3+1
  lda nomolos_attack_rect_y
  sta w4
  lda nomolos_attack_rect_y+1
  sta w4+1

  ldy #level_data_struct::nomolos_spear_fly
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  jsr sprite_draw_metasprite_16bit

  rts

.endproc

;draws nomolos based on his current state.
.proc nomolos_draw

  ;load Nomolos' sprite group offset.
  ldy #level_data_struct::nomolos_offset
  lda (base_address_rom_definition_table),y
  sta sprite_group_offset

  lda nomolos_state_primary
  and #nomolos_dying_test
  beq nomolosNotDying

  lda nomolos_state_secondary
  and #nomolos_attacked_dying_test
  beq nomolosNotAttackedDying

  ;if we're in dying state, we will only ever draw the slumped armor and the scaredy cat graphic and return.
  ldy #level_data_struct::nomolos_slumped_armor
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  ;get Nomolos' screen coordinates.
  lda nomolos_screen_x
  sta w3
  lda nomolos_screen_x+1
  sta w3+1
  lda nomolos_screen_y
  sta w4
  lda nomolos_screen_y+1
  sta w4+1

  lda #0
  sta b2

  ;draw the slumped armor
  jsr sprite_draw_metasprite_16bit

  ldy #level_data_struct::nomolos_slumped_armor_overlay
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  ;draw the slumped armor overlay
  jsr sprite_draw_metasprite_16bit

  ldy #level_data_struct::nomolos_scaredy_cat
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  ;get Nomolos' screen coordinates.
  lda nomolos_out_of_armor_screen_x
  sta w3
  lda nomolos_out_of_armor_screen_x+1
  sta w3+1
  lda nomolos_out_of_armor_screen_y
  sta w4
  lda nomolos_out_of_armor_screen_y+1
  sta w4+1

  ;draw the scaredy cat
  jsr sprite_draw_metasprite_16bit

  ldy #level_data_struct::nomolos_scaredy_cat_overlay
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1

  ;draw the scaredy cat overlay
  jsr sprite_draw_metasprite_16bit

nomolosNotAttackedDying:

  rts
nomolosNotDying:

  lda nomolos_state_primary
  and #nomolos_blinking_test
  lsr
  lsr
  beq skipBlinkCheck

  ;check blink counter
  lda nomolos_counter_temp_invincibility_blink
  and #%00000011
  bne skipReturn
  rts
skipReturn:

skipBlinkCheck:

  ;test if nomolos is fighting. if he is, always draw him fighting
  ;regardless of whether he is in the air.
  lda nomolos_state_primary
  and #nomolos_attack_test
  beq skipDrawnomolos_fighting

  lda nomolos_state_secondary
  and #nomolos_attack_test_mask
  cmp #nomolos_attack_state_sword
  beq nomolosAttackSwordBranch
  cmp #nomolos_attack_state_flail
  beq nomolosAttackFlailBranch
  cmp #nomolos_attack_state_spear
  beq nomolosAttackSpearBranch

nomolosAttackSpearBranch:

  jsr nomolos_draw_attack_spear

  jmp attackSwitchDone

nomolosAttackFlailBranch:

  jsr nomolos_draw_attack_flail

  jmp attackSwitchDone

nomolosAttackSwordBranch:

  jsr nomolos_draw_attack_sword

  jmp attackSwitchDone

attackSwitchDone:

  rts

skipDrawnomolos_fighting:

  jsr nomolos_draw_jumping_set_walking

dontDrawNomolos:

  rts
.endproc

.proc nomolos_draw_jumping_set_walking

  ;test if there is anything below nomolos. if there is not,
  ;draw nomolos's jumping animation.
  lda nomolos_state_primary
  and #nomolos_below_collision_test
  lsr
  lsr
  lsr
  bne skipDrawnomolos_jumping

  jsr nomolos_draw_jumping

  rts

skipDrawnomolos_jumping:

  jsr nomolos_draw_walking

  rts

.endproc

.proc nomolos_draw_jumping

  resetAnim nomolos_animation

  lda #<nomolos_animation
  sta w1
  lda #>nomolos_animation
  sta w1+1

  ldy #level_data_struct::nomolos_jump
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  ;get the direction bit into bit 6 of b2 for horiz flip
  lda nomolos_state_primary
  and #1
  ror
  ror
  ror
  sta b2

  lda nomolos_screen_x
  sta w3
  lda nomolos_screen_x+1
  sta w3+1
  lda nomolos_screen_y
  sta w4
  lda nomolos_screen_y+1
  sta w4+1

  jsr sprite_draw_animation_16bit

  ldy #level_data_struct::nomolos_jump_overlay
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_draw_animation_16bit

  rts

.endproc

.proc nomolos_draw_walking

  lda #<nomolos_animation
  sta w1
  lda #>nomolos_animation
  sta w1+1

  lda nomolos_state_primary
  and #1
  bne skipnomolos_walkingRight
  ldy #level_data_struct::nomolos_walk_overlay
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1
  lda #%00000000
  sta b2

  lda nomolos_screen_x
  sta w3
  lda nomolos_screen_x+1
  sta w3+1
  lda nomolos_screen_y
  sta w4
  lda nomolos_screen_y+1
  sta w4+1
  jsr sprite_draw_animation_16bit

  ldy #level_data_struct::nomolos_walk
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1

  jsr sprite_draw_animation_16bit

  jmp skipnomolos_walkingLeft
skipnomolos_walkingRight:
  ldy #level_data_struct::nomolos_walk_overlay
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1
  lda #%01000000
  sta b2

  lda nomolos_screen_x
  sta w3
  lda nomolos_screen_x+1
  sta w3+1
  lda nomolos_screen_y
  sta w4
  lda nomolos_screen_y+1
  sta w4+1
  jsr sprite_draw_animation_16bit

  ldy #level_data_struct::nomolos_walk
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1
  jsr sprite_draw_animation_16bit

skipnomolos_walkingLeft:

  rts

.endproc

.proc nomolos_draw_hearts

  ldx nomolos_status_health
  beq skipDrawHearts

  lda #$10
  sta b0
  sta b1
  lda #0
  sta b2
  ldy #level_data_struct::heart_0
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1
drawNextHeart:
  jsr sprite_draw_metasprite_8bit
  lda b0
  clc
  adc #$08
  sta b0
  dex
  bne drawNextHeart
skipDrawHearts:

  rts
.endproc
