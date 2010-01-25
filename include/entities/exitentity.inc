exitLevelUpdate:

  ;get out low byte of positionX
  lda entityPool+entityRAM::positionX,x
  sta w0
  ;get out high byte of positionX
  lda entityPool+entityRAM::positionX+1,x
  sta w0+1
  
  ;get out positionY
  lda entityPool+entityRAM::positionY,x
  sta w1
  lda entityPool+entityRAM::positionY+1,x
  sta w1+1
  jsr cameraToScreenCoords
  bpl skipJmpExitDie
  jmp exitDie
skipJmpExitDie:
  
  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda w0
  sta w2
  lda w0+1
  sta w2+1
  lda w1
  sta w3
  lda w1+1
  sta w3+1
  lda #$10
  sta b2
  lda #$10
  sta b3
  
  ;transfer Nomolos rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolosScreenX
  sta w4
  lda nomolosScreenX+1
  sta w4+1
  lda nomolosScreenY
  sta w5
  lda nomolosScreenY+1
  sta w5+1
  lda #nomolosWidth
  sta b4
  lda #nomolosHeight
  sta b5
  
  jsr rectInRect16
  
  beq skipJmpNotTouching
  jmp notTouching
skipJmpNotTouching:
  
  ;turn off music by playing track #0 of haltmusic  
.if .defined(MUSIC_ENABLE)
  lda #<haltmusic
  sta ft_music_addr
  lda #>haltmusic
  sta ft_music_addr+1
  lda #0
  ldx #0
  jsr ft_music_init
.endif  
  
  ldy #ROMDefinitionTableStruct::NextLevel
  lda (romDefinitionTableBaseAddress),y
  sta currentLevel
  lda #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  sta stateControl+playLevelStateControl::state
    
  jmp exitDie
  
notTouching:

  jmp returnFromEntityUpdate

exitDie:
  lda #0
  sta entityPool+entityRAM::alive,x
  jmp returnFromEntityUpdate
