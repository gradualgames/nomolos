;state return labels
.import updatePPUFinished, updateFinished
;map drawing labels
.import updateScrollPPU, updateAttributePPU
.import updateColumnPPU
;sprite drawing labels
.import updateSprites, drawNomolos
;camera labels
.import decodeMap, updateCamera
;nomolos logic labels
.import getInput
;global variables
.importzp spriteAddress, vblankDone

;play level state labels
.export playLevelUpdate, playLevelUpdatePPU

.segment "CODE"

playLevelUpdate:

  ;wait for vblank to complete
  lda #0
  sta vblankDone
: lda vblankDone
  beq :-

  jsr getInput
  jsr updateCamera
  jsr decodeMap
  ;reset sprite address. This must be done before any sprites are
  ;drawn to the sprite buffer. It gets pushed along as every sprite
  ;is added.
  lda #0
  sta spriteAddress
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