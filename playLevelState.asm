.segment "CODE"

;state return labels
.import updatePPUFinished, updateFinished
;input system labels
.import readController
;map drawing labels
.import updateScrollPPU, updateAttributePPU
.import updateColumnPPU
;sprite drawing labels
.import clearSprites, updateSprites, drawNomolos
;entity update labels
.import updateEntities
;map decoding labels
.import decodeMap
;camera labels
.import updateCamera
;nomolos logic labels
.import updateNomolos
;global variables
.importzp spriteAddress, vblankDone

;temporary hack to test entity spawning
.importzp b0, b1, w0, controllerBuffer
.import spawnEntity

;play level state labels
.export playLevelUpdate, playLevelUpdatePPU

playLevelUpdate:

  ;wait for vblank to complete
  lda #0
  sta vblankDone
: lda vblankDone
  beq :-

  jsr readController
  
  ;reset sprite address. This must be done before any sprites are
  ;drawn to the sprite buffer. It gets pushed along as every sprite
  ;is added.
  lda #0
  sta spriteAddress
  jsr clearSprites
  
  jsr updateNomolos
  jsr updateEntities
  ;jsr updateCamera
  jsr decodeMap
  jsr drawNomolos
  jmp updateFinished
  
playLevelUpdatePPU:
  jsr updateSprites
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU
  lda #1
  sta vblankDone
  jmp updatePPUFinished  