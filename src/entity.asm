.include "structs.inc"
.include "macros.inc"
.include "ram.inc"
.include "zp.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "camera.inc"
.include "geotests.inc"
.include "constants.inc"

.segment "CODE"

.export compareEntityRectToHitboxRect
;assumes b2 and b3 represent the width and height of the calling entity
.proc compareEntityRectToHitboxRect
  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entityScreenX
  sta w2
  lda entityScreenX+1
  sta w2+1
  lda entityScreenY
  sta w3
  lda entityScreenY+1
  sta w3+1
  
  ;transfer Hitbox rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda nomolosHitboxX
  sta w4
  lda nomolosHitboxX+1
  sta w4+1
  lda nomolosHitboxWidth
  sta b4
  lda nomolosHitboxHeight
  sta b5
    
  jsr rectInRect16
  rts
.endproc

.export compareEntityRectToNomolosRect
;assumes b2 and b3 represent the width and height of the current entity
.proc compareEntityRectToNomolosRect
  ;transfer Deentle rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entityScreenX
  sta w2
  lda entityScreenX+1
  sta w2+1
  lda entityScreenY
  sta w3
  lda entityScreenY+1
  sta w3+1
  
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
  rts
.endproc

.export getEntityScreenCoordinates
.proc getEntityScreenCoordinates
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

  ;save screen coordinates for use later
  lda w0
  sta entityScreenX
  lda w0+1
  sta entityScreenX+1
  lda w1
  sta entityScreenY
  lda w1+1
  sta entityScreenY+1
  rts
.endproc

;This routine indirectly jumps to every update routine for every live entity.
;The entities are expected to jump back to returnFromEntityUpdate when they
;are finished.
.export updateEntities
.proc updateEntities

  ;switch to the actor and entity bank
  ldy #ROMDefinitionTableStruct::NomolosAndEntityBank
  lda (romDefinitionTableBaseAddress),y
  sta nextBank
  jsr bankswitch

  ;start at last entity
  ldy #$0f
nextEntity:
  ;save y 
  tya  
  pha
  
  ;multiply by 4 to get the entity RAM object offset
  asl
  asl
  asl
  asl
  tax
  lda entityPool+entityRAM::alive,x
  beq skipUpdate
  ;if we arrive here, x points to a live entity

  ;load the entity index
  lda entityPool+entityRAM::index,x
  ;multiply the entity index by 8
  asl
  asl
  asl
  tay
  ;now y points to the entity definition
  
  ;load low byte of update routine
  lda (entityDefinitionTableBaseAddress),y
  ;might as well use w0..
  sta w0
  ;point to high byte of update routine
  iny
  ;load high byte of update routine
  lda (entityDefinitionTableBaseAddress),y
  ;put the high byte into w0
  sta w0+1

  ;jump to the entity update routine indirectly
  jsr indirectJsrW0
  
  ;entities are expected to return here.
skipUpdate:
  ;restore y
  pla
  tay
  ;iterate to next entity
  dey
  bpl nextEntity

  rts
  
.endproc
  
.proc indirectJsrW0
  jmp (w0)
.endproc

;This routine initializes the entity pool. All this
;entails is filling the first byte of every 16 byte chunk with zero.
.export initEntities
.proc initEntities
  ldx #$0f
:
  ;multiply the index by 16
  txa
  asl
  asl
  asl
  asl
  tay
  lda #$00
  sta entityPool+entityRAM::alive, y
  dex
  bpl :-
  rts
.endproc
  
;This routine spawns a single entity. It works by first searching
;for the first "dead" entity in the entityPool. When it finds this
;dead entity, it fills it according to the entityRAM struct.

;the following parameters are expected:
;b0 = index of entity definition to spawn
;w0 = positionX
;b1 = positionY
.export spawnEntity
.proc spawnEntity

  ;save regs
  pha
  txa
  pha
  tya 
  pha

  ;start at the last entity
  ldy #$0f
:
  tya
  asl
  asl
  asl
  asl
  tax
  lda entityPool+entityRAM::alive,x
  beq :+  ;found a dead entity, jump out with current value of x
  dey
  bpl :-
:
  ;when we get here we are pointing at a dead entity with x
  
  ;make the entity alive. ALIVE! MUA HUAH HAH HAH
  lda #$01
  sta entityPool+entityRAM::alive,x
  
  ;store the kind of entity this is
  lda b0
  sta entityPool+entityRAM::index,x
  
  ;now that we know the kind of entity this is, we must look up
  ;the entity and pull out its initialXOffset and initialYOffset,
  ;add these to the input parameters, and store them in positionX and positionY.
  
  ;a holds the entity index, so multiply it by 8 to get an entity offset
  asl
  asl
  asl
  ;put the entity offset into y
  tay
  
  ;skip the UpdateRoutine, we're not interested in it here
  iny
  iny
  
  ;store the initial X offset in b2 for now
  lda (entityDefinitionTableBaseAddress),y
  sta b2
  
  ;load the low byte of the x parameter, and do a 16 bit subtract from this
  sec
  lda w0
  sbc b2
  sta w0
  lda w0+1
  sbc #0
  sta w0+1  

  ;now w0 should have the spawnPositionX value
  lda w0
  sta entityPool+entityRAM::spawnPositionX,x
  lda w0+1
  sta entityPool+entityRAM::spawnPositionX+1,x
  
  ;load initial y offset
  iny
  ;load the initial y offset and store it in b2 for now
  lda (entityDefinitionTableBaseAddress),y
  sta b2
  
  ;subtract this from the y parameter
  sec
  lda b1
  sbc b2
  sta b1  ;store result in y parameter
  
  ;now b1 should have the spawnPositionY value
  lda b1
  sta entityPool+entityRAM::spawnPositionY,x
  
  ;load positionXFine
  lda #$00
  sta entityPool+entityRAM::positionXFine,x
  ;load positionX
  lda w0
  sta entityPool+entityRAM::positionX,x
  lda w0+1
  sta entityPool+entityRAM::positionX+1,x
  
  ;load positionYFine
  lda #$00
  sta entityPool+entityRAM::positionYFine,x
  ;load positionY
  lda b1
  sta entityPool+entityRAM::positionY,x
  lda #0
  sta entityPool+entityRAM::positionY+1,x
  
  ;point to the initial state
  iny
  ;load initial state
  lda (entityDefinitionTableBaseAddress),y  
  ;point to state variable in entity entry
  ;store the initial state there
  sta entityPool+entityRAM::state,x
  
  ;at this point the entity should be fully spawned and ready
  ;to have its update routine called.
  
  ;restore regs
  pla
  tay
  pla
  tax
  pla

  rts
.endproc
