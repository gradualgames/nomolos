.include "structs.inc"
.include "constants.inc"

;zeropage labels
.importzp stateControl

;state return labels
.import updatePPUFinished, updateFinished

.export levelInUpdate, levelInPPUUpdate

.segment "CODE"

levelInUpdate:

  lda stateControl+levelInStateControl::state
  cmp #LEVELINSTATE_INIT
  beq levelInStateInit
  cmp #LEVELINSTATE_RUN
  beq levelInStateRun
  
levelInStateInit:

  ;TODO: We want to switch to the nametable clear state from here.

  lda #LEVELINSTATE_RUN
  sta stateControl+levelInStateControl::state
  
  jmp stateCommandComplete

levelInStateRun:

  jmp stateCommandComplete

stateCommandComplete:

  jmp updateFinished

levelInPPUUpdate:

  jmp updatePPUFinished