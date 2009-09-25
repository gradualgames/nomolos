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
.import updateNomolos, drawNomolos
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
  
  ;reset sprite address. This must be done before any sprites are
  ;drawn to the sprite buffer. It gets pushed along as every sprite
  ;is added.
  lda spriteAddressStart
  clc
  adc #32
  sta spriteAddressStart
  sta spriteAddress
  jsr clearSprites
  
  jsr updateNomolos
  jsr updateEntities
  ;jsr updateCamera
  jsr decodeMap
  jsr drawNomolos
  
  lda #16
  sta b0
  sta b1
  lda #<Heart0
  sta w0
  lda #>Heart0
  sta w0+1
  jsr drawMetaSprite
  lda #24
  sta b0
  jsr drawMetaSprite
  lda #32
  sta b0
  jsr drawMetaSprite
  
  
  jmp updateFinished
  
playLevelUpdatePPU:
  jsr updateSprites
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU
  lda #1
  sta vblankDone
  jmp updatePPUFinished  