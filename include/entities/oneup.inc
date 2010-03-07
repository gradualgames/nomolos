.ifndef ONEUP_INC
ONEUP_INC = 1

.export oneup_update
.proc oneup_update

  jsr entity_compute_screen_coordinates
  
  ;test x coordinate for whether the item should die.
  sec
  lda #$f0
  sbc entity_screen_x
  lda #$ff
  sbc entity_screen_x+1
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
  jsr sound_load
    
  jmp oneUpDie
  
notTouching:

  lda #<OneUp0
  sta w0
  lda #>OneUp0
  sta w0+1
  
  lda entity_screen_x
  sta w3
  lda entity_screen_x+1
  sta w3+1
  lda entity_screen_y
  sta w4
  lda entity_screen_y+1
  sta w4+1
  
  jsr sprite_draw_metasprite_16bit
  
  rts

oneUpDie:

  lda #0
  sta entity_instances+entityRAM::alive,x
  rts
  
.endproc

.endif
