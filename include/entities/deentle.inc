.ifndef DEENTLE_INC
DEENTLE_INC = 1

DEENTLE_INITSTATE = 0
DEENTLE_MOVERIGHTSTATE = 1
DEENTLE_MOVELEFTSTATE = 2

.export deentleUpdate
deentleUpdate:

  ;load current state
  lda entityPool+entityRAM::state,x
  ;figure out what state to jump to
  cmp #DEENTLE_INITSTATE
  beq deentle_initState
  cmp #DEENTLE_MOVERIGHTSTATE
  beq deentle_moveRightState
  cmp #DEENTLE_MOVELEFTSTATE
  beq deentle_moveLeftState

deentle_initState:

  ;init code for animation, etc. goes here
  lda #1
  sta entityPool+entityRAM::animationObject,x
  lda #$ff
  sta entityPool+entityRAM::animationObject+1,x
  
  ;switch state to "run"
  lda #DEENTLE_MOVELEFTSTATE
  sta entityPool+entityRAM::state,x
  rts

deentle_moveRightState:

  ;add 1 to PositionX
  clc
  lda entityPool+entityRAM::positionX,x
  adc #1
  sta entityPool+entityRAM::positionX,x
  lda entityPool+entityRAM::positionX+1,x
  adc #0
  sta entityPool+entityRAM::positionX+1,x
  
  ;do PositionX - spawnPositionX
  sec
  lda entityPool+entityRAM::positionX,x
  sbc entityPool+entityRAM::spawnPositionX,x
  sta w0
  lda entityPool+entityRAM::positionX+1,x
  sbc entityPool+entityRAM::spawnPositionX+1,x
  sta w0+1
  
  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1
  bne dontSwitchToLeftState
  
  lda #DEENTLE_MOVELEFTSTATE
  sta entityPool+entityRAM::state,x
  
dontSwitchToLeftState:

  jsr deentle_draw

  rts

deentle_moveLeftState:

  ;sub 1 from PositionX
  sec
  lda entityPool+entityRAM::positionX,x
  sbc #1
  sta entityPool+entityRAM::positionX,x
  lda entityPool+entityRAM::positionX+1,x
  sbc #0
  sta entityPool+entityRAM::positionX+1,x
  
  ;do spawnPositionX - PositionX
  sec
  lda entityPool+entityRAM::spawnPositionX,x
  sbc entityPool+entityRAM::positionX,x 
  sta w0
  lda entityPool+entityRAM::spawnPositionX+1,x
  sbc entityPool+entityRAM::positionX+1,x 
  sta w0+1
  
  ;difference is in w0, subtract our desired delta distance from it
  sec
  lda w0
  sbc #30
  sta w0
  lda w0+1
  sbc #0
  sta w0+1
  
  bne dontSwitchToRightState
  
  lda #DEENTLE_MOVERIGHTSTATE
  sta entityPool+entityRAM::state,x
  
dontSwitchToRightState:

  jsr deentle_draw

  rts
  
deentle_draw:

  jsr entity_compute_screen_coordinates

  ;test the x coordinate for whether it is a certain distance off screen. compare it
  ;to -32.
  ;-32 - -40 = 8. positive = offscreen, die. negative = onscreen, do not die.
  sec
  lda #$e0
  sbc entityScreenX
  lda #$ff
  sbc entityScreenX+1
  bmi deentleOnScreen
  
  jmp killDeentle
  
deentleOnScreen:  
  
  ;load deentle width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking
  
  ;load deentle width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_hitbox
  
  bne nomolosNotAttacking
  
  ;play an explode sound
  lda #<hitSound
  sta w0
  lda #>hitSound
  sta w0+1
  jsr loadSound
  
  jmp killDeentle
  
nomolosNotAttacking:

  ;load address of animation object into w1
  lda #<(entityPool+entityRAM::animationObject)
  sta w1
  lda #>(entityPool+entityRAM::animationObject)
  sta w1+1
  
  ;get the index into a
  txa
  clc
  ;do a 16 bit add onto the address with this index
  adc w1
  sta w1
  lda w1+1
  adc #0
  sta w1+1 
  
  ;load address of deentle animation definition into w2
  lda #<DeentleWalk
  sta w2
  lda #>DeentleWalk
  sta w2+1
  lda #0
  sta b2
  jsr sprite_update_animation  
  
  lda entityScreenX
  sta w3
  lda entityScreenX+1
  sta w3+1
  lda entityScreenY
  sta w4
  lda entityScreenY+1
  sta w4+1
  
  jsr sprite_draw_animation_16bit
deentleOffscreen:
  rts
  
killDeentle:

  ;make it dead
  lda #0
  sta entityPool+entityRAM::alive,x
  
  ;spawn an explosion entity
  lda #ExplosionIndex
  sta b0

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  
  jsr entity_spawn

  rts
  
.endif
