.ifndef FLAGS_INC
FLAGS_INC = 1

DEENTLE_INITSTATE = 0
DEENTLE_MOVERIGHTSTATE = 1
DEENTLE_MOVELEFTSTATE = 2

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
  lda #0
  sta entityPool+entityRAM::animationObject+1,x
  
  ;switch state to "run"
  lda #DEENTLE_MOVELEFTSTATE
  sta entityPool+entityRAM::state,x
  jmp returnFromEntityUpdate

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

  jmp returnFromEntityUpdate

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

  jmp returnFromEntityUpdate
  
  rts
  
deentle_draw:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  ;add 16 to positionX to get the right side of the Deentle
  clc
  lda w0
  adc #$10
  sta w0
  lda w0+1
  adc #$00
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  jsr cameraToScreenCoords
  bpl dontKillDeentle 
  jmp killDeentle
dontKillDeentle:
  beq deentleNotOffscreen1
  jmp deentleOffscreen
deentleNotOffscreen1:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  ;get positionY
  lda entityPool+entityRAM::positionY,x
  sta b1
  jsr cameraToScreenCoords
  beq deentleNotOffscreen2
  jmp deentleOffscreen
deentleNotOffscreen2:
  
  ;transfer Deentle rectangle to w0 = top left and w1 = bot right
  lda b0
  sta w0
  clc
  adc #$10
  sta w1
  lda b1
  sta w0+1
  clc
  adc #$10
  sta w1+1
  
  ;transfer Nomolos rectangle to w2 = top left and w3 = bot right
  lda nomolosScreenX
  sta w2
  clc
  adc #nomolosWidth
  sta w3
  lda nomolosScreenY
  sta w2+1
  clc
  adc #nomolosHeight
  sta w3+1
  
  jsr rectInRect
  
  bne :+
  
  jsr hurtNomolos
  
:
  jsr nomolosDeadly
  beq nomolosNotAttacking
  
  ;transfer Deentle rectangle to w0 = top left and w1 = bot right
  lda b0
  sta w0
  clc
  adc #$10
  sta w1
  lda b1
  sta w0+1
  clc
  adc #$10
  sta w1+1
  
  ;transfer Nomolos rectangle to w2 = top left and w3 = bot right
  lda nomolosScreenX
  clc
  adc nomolosHitboxXOffset ;slide rectangle over for hit box
  sta w2
  ;clc
  adc #nomolosHitboxWidth
  sta w3
  lda nomolosScreenY
  sta w2+1
  clc
  adc #nomolosHitboxHeight
  sta w3+1
  
  jsr rectInRect
  
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
  jsr updateAnimation  
  jsr drawAnimation
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
  
  jsr spawnEntity

  rts
  
.endif
