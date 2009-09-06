.import entityPool

.importzp b0, b1, w0, entityDefinitionTableBaseAddress

.export updateEntities, returnFromEntityUpdate, initEntities, spawnEntity

.segment "CODE"

updateEntities:
returnFromEntityUpdate:
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
;.dsw positionX      = x (this is a parameter)
;.dsb positionXExtra 
;.dsb positionY      = y (this is a parameter)
;.dsb positionYExtra
;.dsb state          = initialState
;.dsw animationObject  = unknown, this expected to be set by the entity
;.dsb 3 ;padding to 16 bytes

;the following parameters are expected:
;b0 = index of entity definition to spawn
;w0 = positionX
;b1 = positionY

spawnEntity:

  ;start at the last entity
  ldx #$0f
:
  txa
  asl
  asl
  asl
  asl
  tay
  lda entityPool,y
  beq :+  ;found a dead entity, jump out with current value of y
  dex
  bpl :-
:
  ;when we get here we are pointing at a dead entity with y
  
  ;make the entity alive. ALIVE! MUA HUAH HAH HAH
  lda #$01
  sta entityPool,y
  
  ;point to the "index" field
  iny
  ;save off y into x, we're soon going to use y for looking things up in an entity def
  tya
  tax
  ;store the kind of entity this is
  lda b0
  sta entityPool,y
  
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
  
  ;point to the initial state
  iny
  ;load initial state
  lda (entityDefinitionTableBaseAddress),y
  
  ;point to state variable in entity entry
  inx
  ;store the initial state there
  sta entityPool,X
  
  
  
  

  rts