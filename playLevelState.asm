.include "flags.inc"
.include "structs.inc"
.include "macros.inc"

;rom labels
.import Heart0

.import loadLevel

;level out state labels
.import levelOutUpdate, levelOutPPUUpdate
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
.importzp update, updatePPU
.importzp spriteAddress, spriteAddressStart, vblankDone
.importzp stateControl
.importzp b0, b1, b2, w0, controllerBuffer

;play level state labels
.export playLevelUpdate, playLevelUpdatePPU

.segment "CODE"

playLevelUpdate:

  ;wait for vblank to complete
  lda #0
  sta vblankDone
: lda vblankDone
  beq :-

  ;turn monochrome bit on
  .ifdef DISPLAY_FRAME_CPU_USAGE
  lda #%00011111
  sta $2001
  .endif
  
  jsr readController
  
  jsr clearSprites
  
  jsr updateNomolos
  jsr drawNomolos
  jsr drawNomolosHearts
  jsr updateEntities
  
  jsr decodeMap
    
  lda stateControl+playLevelStateControl::state
  cmp #PLAYLEVELSTATE_SWITCHLEVEL
  beq switchLevel
  cmp #PLAYLEVELSTATE_SWITCHTOLEVELOUTSTATE
  beq switchToLevelOutState
  
  jmp stateCommandComplete
  
switchLevel:
  lda stateControl+playLevelStateControl::romDefinitionTable
  sta w0
  lda stateControl+playLevelStateControl::romDefinitionTable+1
  sta w0+1
  lda stateControl+playLevelStateControl::bgChrBank
  sta b0
  lda stateControl+playLevelStateControl::sprChrBank
  sta b1
  lda stateControl+playLevelStateControl::prgBank
  sta b2
  jmp loadLevel
  
switchToLevelOutState:

  lda #LEVELOUTSTATE_INIT
  sta stateControl+levelOutStateControl::state
  switchState levelOutUpdate, levelOutPPUUpdate
  
stateCommandComplete:
    
  ;turn monochrome bit off
  .ifdef DISPLAY_FRAME_CPU_USAGE
  lda #%00011110
  sta $2001
  .endif
    
  jmp updateFinished
  
playLevelUpdatePPU:

  jsr updateSprites
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU
  lda #1
  sta vblankDone
  jmp updatePPUFinished  