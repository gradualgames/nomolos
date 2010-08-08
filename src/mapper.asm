.include "zp.inc"
.include "fixedBankData.inc"

.segment "CODE"

;bankswitches using UnROM.
;mapper_bank_next - the bank to switch to
.export mapper_switch_bank
.proc mapper_switch_bank
  txa
  pha

  ldx mapper_bank_next
  lda banktable,x        ;read a byte from the banktable
  sta banktable,x        ;and write it back, switching banks at $8000
  sta mapper_bank_current        ;store off the current bank

  pla
  tax
  rts
.endproc

