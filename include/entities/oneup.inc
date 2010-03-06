.ifndef ONEUP_INC
ONEUP_INC = 1

.export oneUpUpdate
.proc oneUpUpdate

  jsr entity_compute_screen_coordinates
  
  ;test x coordinate for whether the item should die.
  sec
  lda #$f0
  sbc entityScreenX
  lda #$ff
  sbc entityScreenX+1
  bmi skipJmpOneUpDie

  jmp oneUpDie
skipJmpOneUpDie:
  
  ;load entity width and height
  lda #$10
  sta b2
  lda #$10
  sta b3
  jsr entity_test_collision_nomolos
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
  
  lda #1
  jsr nomolos_add_life
    
  lda #<getItemSound
  sta w0
  lda #>getItemSound
  sta w0+1
  jsr loadSound
    
  jmp oneUpDie
  
notTouching:

  lda #<OneUp0
  sta w0
  lda #>OneUp0
  sta w0+1
  
  lda entityScreenX
  sta w3
  lda entityScreenX+1
  sta w3+1
  lda entityScreenY
  sta w4
  lda entityScreenY+1
  sta w4+1
  
  jsr drawMetaSprite16
  
  rts

oneUpDie:

  lda #0
  sta entityPool+entityRAM::alive,x
  rts
  
.endproc

.endif
