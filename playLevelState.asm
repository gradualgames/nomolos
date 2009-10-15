.segment "CODE"

;rom labels
.import Heart0

;state return labels
.import updatePPUFinished, updateFinished
;input system labels
.import readController
;map drawing labels
.import updateScrollPPU, updateAttributePPU
.import updateColumnPPU
;sprite drawing labels
.import drawMetaSprite, clearSprites, updateSprites
;entity update labels
.import updateEntities
;map decoding labels
.import decodeMap
;camera labels
.import updateCamera
;nomolos logic labels
.import updateNomolos, drawNomolos, drawNomolosHearts
;global variables
.importzp spriteAddress, spriteAddressStart, vblankDone

.importzp b0, b1, w0, controllerBuffer

;play level state labels
.export playLevelUpdate, playLevelUpdatePPU

playLevelUpdate:

  ;wait for vblank to complete
  lda #0
  sta vblankDone
: lda vblankDone
  beq :-

  jsr readController

  lda #0
  sta spriteAddress
  
  jsr clearSprites
  
  jsr updateNomolos
  jsr drawNomolos
  jsr drawNomolosHearts
  jsr updateEntities
  
  jsr decodeMap
    
  jmp updateFinished
  
playLevelUpdatePPU:
  jsr updateSprites
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU
  lda #1
  sta vblankDone
  jmp updatePPUFinished  