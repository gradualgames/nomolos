.import entityPool

.importzp b0, b1, w0, entityDefinitionTableBaseAddress

.export updateEntities, returnFromEntityUpdate, initEntities, spawnEntity

.segment "CODE"

;This routine indirectly jumps to every update routine for every live entity.
;The entities are expected to jump back to returnFromEntityUpdate when they
;are finished.
updateEntities:

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
  lda entityPool,x
  beq skipUpdate
  ;if we arrive here, x points to a live entity
  ;point to the entity index
  inx
  ;load the entity index
  lda entityPool,x
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
  ;the entity update routine must know the index of its RAM entry.
  ;right now, x points to the entity RAM entry, +1 because of looking at index.
  ;point to the beginning of the entity RAM entry
  dex
  ;jump to the entity update routine indirectly
  jmp (w0)
returnFromEntityUpdate:
  ;entities are expected to return here.
skipUpdate:
  ;restore y
  pla
  tay
  ;iterate to next entity
  dey
  bpl nextEntity


  rts

;This routine initializes the entity pool. All this
;entails is filling the first byte of every 16 byte chunk with zero.
initEntities:
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
  sta entityPool, y
  dex
  bpl :-
  rts
  
;This routine spawns a single entity. It works by first searching
;for the first "dead" entity in the entityPool. When it finds this
;dead entity, it fills it according to the following schema:
;.dsb alive = 1
;.dsb index = definition index (this is a parameter)
;.dsw spawnPositionX = initialXOffset + x
;.dsb spawnPositionY = initialYOffset + y
;.dsb positionXFine  = unknown, this is expected to be used (or not used) by the entity
;.dsw positionX      = x (this is a parameter)
;.dsb positionYFine  = unknown, this is expected to be used (or not used) by the entity
;.dsb positionY      = y (this is a parameter)
;.dsb state          = initialState
;.dsw animationObject  = unknown, this expected to be set by the entity
;.dsb 3 ;padding to 16 bytes

;the following parameters are expected:
;b0 = index of entity definition to spawn
;w0 = positionX
;b1 = positionY

spawnEntity:

  ;start at the last entity
  ldy #$0f
:
  tya
  asl
  asl
  asl
  asl
  tax
  lda entityPool,x
  beq :+  ;found a dead entity, jump out with current value of x
  dey
  bpl :-
:
  ;when we get here we are pointing at a dead entity with x
  
  ;make the entity alive. ALIVE! MUA HUAH HAH HAH
  lda #$01
  sta entityPool,x
  
  ;point to the "index" field
  inx
  ;store the kind of entity this is
  lda b0
  sta entityPool,x
  
  ;now that we know the kind of entity this is, we must look up
  ;the entity and pull out its initialXOffset and initialYOffset,
  ;add these to the input parameters, and store them in positionX and positionY.
  
  ;the entity definition schema is as follows:
  ;.dw UpdateRoutine
  ;.db initialXOffset ;XOffset from parent meta-tile
  ;.db initialYOffset ;YOffset from parent meta-tile
  ;.db initialState   ;intended to trigger UpdateRoutine to put the enemy into its
  ;                   ;initial state.
  
  ;a holds the entity index, so multiply it by 8 to get an entity offset
  asl
  asl
  asl
  ;put the entity offset into y
  tay
  
  ;skip the UpdateRoutine, we're not interested in it here
  iny
  iny
  
  ;load the initial x offset
  lda (entityDefinitionTableBaseAddress),y  
  ;negate it
  eor #$ff
  clc 
  adc #01
  
  ;now add this to the low byte of the x parameter
  clc
  adc w0
  sta w0   ;store result in low byte
  lda #$ff ;load all 1's, since we negated our x offset
  adc w0+1 ;add the upper byte of the x parameter
  sta w0+1 ;store result in high byte of x parameter
  
  ;now w0 should have the spawnPositionX value
  ;point to spawnPositionX. Load it with w0.
  inx
  lda w0
  sta entityPool,x
  inx
  lda w0+1
  sta entityPool,x
  
  ;point to initial y offset
  iny
  ;load the initial y offset
  lda (entityDefinitionTableBaseAddress),y
  ;negate it
  eor #$ff
  clc
  adc #01
  
  ;now add this to the y parameter (b1)
  clc
  adc b1
  sta b1  ;store result in y parameter
  
  ;now b1 should have the spawnPositionY value
  ;point to spawnPositionY. Load it with b1.
  inx
  lda b1
  sta entityPool,x
  
  ;point to positionXFine
  inx
  lda #$00
  sta entityPool,x
  ;point to positionX
  inx
  lda w0
  sta entityPool,x
  inx
  lda w0+1
  sta entityPool,x
  
  ;point to positionYFine
  inx
  lda #$00
  sta entityPool,x
  ;point to positionY
  inx
  lda b1
  sta entityPool,x
  
  ;point to the initial state
  iny
  ;load initial state
  lda (entityDefinitionTableBaseAddress),y  
  ;point to state variable in entity entry
  inx
  ;store the initial state there
  sta entityPool,X
  
  ;at this point the entity should be fully spawned and ready
  ;to have its update routine called.

  rts