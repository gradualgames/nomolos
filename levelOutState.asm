;state return labels
.import updatePPUFinished, updateFinished

.export levelOutUpdate, levelOutPPUUpdate

.segment "CODE"

levelOutUpdate:

  jmp updateFinished
  
levelOutPPUUpdate:

  jmp updatePPUFinished