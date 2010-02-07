.include "zp.inc"
.include "gameUIData.inc"

.segment "CODE"

;bankswitches using UnROM.
;b0 - the bank to switch to
.export bankswitch
.proc bankswitch
  txa
  pha

  ldx b0
  lda banktable,x        ;read a byte from the banktable
  sta banktable,x        ;and write it back, switching banks at $8000
  sta currentBank        ;store off the current bank
 
  pla
  tax 
  rts
.endproc
  
