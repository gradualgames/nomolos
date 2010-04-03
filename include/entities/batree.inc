.ifndef BATREE_INC
BATREE_INC = 1

BATREE_WIDTH = $18
BATREE_HEIGHT = $28
BATREE_BATSPAWN_INTERVAL = 50

.struct batree_locals
  batspawn_counter .byte
.endstruct

BATREE_INITSTATE = 0
BATREE_MOVERIGHTSTATE = 1
BATREE_MOVELEFTSTATE = 2

.export batree_update
.proc batree_update

  ;load current state
  lda entity_instances+entityRAM::state,x
  ;figure out what state to jump to
  cmp #BATREE_INITSTATE
  beq batree_initState
  cmp #BATREE_MOVERIGHTSTATE
  beq batree_moveRightState
  cmp #BATREE_MOVELEFTSTATE
  beq batree_moveLeftState

batree_initState:

  ;init code for animation, etc. goes here
  jsr entity_reset_anim
  
  ;set initial batspawn_counter
  lda #BATREE_BATSPAWN_INTERVAL
  sta entity_locals+batree_locals::batspawn_counter,x
  
  ;switch state to "run"
  lda #BATREE_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x
  rts

batree_moveRightState:

  ;add 1 to PositionX
  clc
  lda entity_instances+entityRAM::positionX,x
  adc #1
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  adc #0
  sta entity_instances+entityRAM::positionX+1,x
  
  ;do PositionX - spawnPositionX
  sec
  lda entity_instances+entityRAM::positionX,x
  sbc entity_instances+entityRAM::spawnPositionX,x
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  sbc entity_instances+entityRAM::spawnPositionX+1,x
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
  
  lda #BATREE_MOVELEFTSTATE
  sta entity_instances+entityRAM::state,x
  
dontSwitchToLeftState:

  jsr batree_draw
  
  jsr batree_update_batspawn_counter

  rts

batree_moveLeftState:

  ;sub 1 from PositionX
  sec
  lda entity_instances+entityRAM::positionX,x
  sbc #1
  sta entity_instances+entityRAM::positionX,x
  lda entity_instances+entityRAM::positionX+1,x
  sbc #0
  sta entity_instances+entityRAM::positionX+1,x
  
  ;do spawnPositionX - PositionX
  sec
  lda entity_instances+entityRAM::spawnPositionX,x
  sbc entity_instances+entityRAM::positionX,x 
  sta w0
  lda entity_instances+entityRAM::spawnPositionX+1,x
  sbc entity_instances+entityRAM::positionX+1,x 
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
  
  lda #BATREE_MOVERIGHTSTATE
  sta entity_instances+entityRAM::state,x
  
dontSwitchToRightState:

  jsr batree_draw
  
  jsr batree_update_batspawn_counter

  rts
  
batree_update_batspawn_counter:

  dec entity_locals+batree_locals::batspawn_counter,x
  bne do_not_spawn_bat
  
  ;spawn bat at location of batree
;This routine spawns a single entity. It works by first searching
;for the first "dead" entity in the entity_instances. When it finds this
;dead entity, it fills it according to the entityRAM struct.

;the following parameters are expected:
;b0 = index of entity definition to spawn
;w0 = positionX
;b1 = positionY

  lda entity_instances+entityRAM::positionX,x
  sta w0
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1
  lda entity_instances+entityRAM::positionY,x
  clc
  adc #16
  sta b1
  lda #entity_index_bat
  sta b0
  jsr entity_spawn
  
  ;reset bat spawn counter
  lda #BATREE_BATSPAWN_INTERVAL
  sta entity_locals+batree_locals::batspawn_counter,x
  
do_not_spawn_bat:

  rts
  
batree_draw:

  jsr entity_compute_screen_coordinates

  jsr entity_test_death_zone
  beq killBatree
  
  ;load batree width and height
  lda #BATREE_WIDTH
  sta b2
  lda #BATREE_HEIGHT
  sta b3
  jsr entity_test_collision_nomolos
  
  bne :+
  
  jsr nomolos_hurt
  
:
  jsr nomolos_is_deadly
  beq nomolosNotAttacking
  
  ;load batree width and height
  lda #BATREE_WIDTH
  sta b2
  lda #BATREE_HEIGHT
  sta b3
  jsr entity_test_collision_hitbox
  
  bne nomolosNotAttacking
  
  ;play an explode sound
  lda #<hitSound
  sta w0
  lda #>hitSound
  sta w0+1
  jsr sound_load
  
  jmp killBatree
  
nomolosNotAttacking:

  ;load address of animation object into w1
  lda #<(entity_instances+entityRAM::animationObject)
  sta w1
  lda #>(entity_instances+entityRAM::animationObject)
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
  
  ;load address of batree animation definition into w2
  ldy #ROMDefinitionTableStruct::Batree
  lda (base_address_rom_definition_table),y
  sta w2
  iny
  lda (base_address_rom_definition_table),y
  sta w2+1
  
  lda #0
  sta b2
  jsr sprite_update_animation  
  
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
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
  
  jsr sprite_draw_animation_16bit
batreeOffscreen:
  rts
  
killBatree:

  ;make it dead
  jsr entity_kill
  
  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  ;get out low byte of positionX
  lda entity_instances+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entity_instances+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entity_instances+entityRAM::positionY,x
  sta b1
  
  jsr entity_spawn

  rts
.endproc
  
.endif
