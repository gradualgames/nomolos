.include "flags.inc"
.include "structs.inc"
.include "macros.inc"

;rom labels
.import Heart0
;famitracker module
.import ft_music_play
;load level state labels
.import loadLevelUpdate, loadLevelUpdatePPU
;sound module
.import playSound
;level out state labels
.import levelOutUpdate, levelOutPPUUpdate
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
  lda stateControl+playLevelStateControl::levelNum
  sta stateControl+loadLevelStateControl::levelToLoad
  lda #LOADLEVELSTATE_INIT
  sta stateControl+loadLevelStateControl::state
  
  switchState loadLevelUpdate, loadLevelUpdatePPU
  
  jmp stateCommandComplete
  
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
    
  rts
  
playLevelUpdatePPU:

  jsr updateSprites
  jsr updateColumnPPU
  jsr updateAttributePPU
  jsr updateScrollPPU
  
  .ifdef MUSIC_ENABLE
  jsr ft_music_play
  .endif
  jsr playSound
  
  lda #1
  sta vblankDone
  rts
  