.include "flags.inc"
.include "soundengine.inc"
.include "macros.inc"
.include "controller.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixedBankData.inc"
.include "sprite.inc"
.include "levelInState.inc"
.include "zp.inc"
.include "nomolosLogic.inc"
.include "levelOutState.inc"
.include "titleState.inc"

.segment "CODE"

.proc title_state_update

  lda state_control_params+titleStateControl::state
  cmp #TITLESTATE_INIT
  bne :+
  jmp  titleStateInit
:
  cmp #TITLESTATE_RUN
  bne :+
  jmp titleStateRun
:
  cmp #TITLESTATE_DONE
  bne :+
  jmp titleStateDone
:
  
titleStateInit:

  ;this init state should be similar to the level in state, only we won't be
  ;clearing the nametable, we'll be loading it from a particular location.
  waitVBlank
  
  ;keep nmi on
  set_ppu_2000_bit PPU0_EXECUTE_NMI
  ;turn off inc32, we're just loading a nametable in this state
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  ;load sprite pattern table from $1000
  set_ppu_2000_bit PPU0_SPRITE_PATTERN_TABLE_ADDRESS
  upload_ppu_2000
  
  ;turn off sprite visibility
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  ;turn off background visibility
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001
  
  ;load title screen music
.ifdef MUSIC_ENABLE
  lda #<title_music
  sta sound_param_word_1
  lda #>title_music
  sta sound_param_word_1+1
  jsr song_initialize
.endif
  
  lda #TITLESTATE_RUN
  sta state_control_params+titleStateControl::state

  jmp stateCommandComplete
  
titleStateRun:

  ;clear the sprites
  jsr sprite_clear_all
  ;update sprites
  jsr sprite_update_all

  ;load the title nametable and attribute table.
  lda #$20
  sta $2006
  lda #$00
  sta $2006
  lda titleDef+title::nametableAddress
  sta w0
  lda titleDef+title::nametableAddress+1
  sta w0+1
  jsr ppu_load_name_table
  
  ;now switch to the prg bank containing the chr data of the title screen.
  lda titleDef+title::chrPrgRomBank
  sta mapper_bank_next
  jsr mapper_switch_bank
  
  ;now load the chr data
  lda titleDef+title::chrAddress
  sta w0
  lda titleDef+title::chrAddress+1
  sta w0+1
  
  lda #$00
  sta $2006
  sta $2006
  
  jsr ppu_load_chr_amount
  
  ;now that nametable loaded, load the new palette.
  lda titleDef+title::paletteAddress
  sta w0
  lda titleDef+title::paletteAddress+1
  sta w0+1
  waitVBlank
  jsr ppu_load_palette_bg
  
  ;reset scroll
  lda #0
  sta $2005
  sta $2005
  
  ;turn on nmi
  set_ppu_2000_bit PPU0_EXECUTE_NMI
  upload_ppu_2000
  
  ;turn sprite and background visibility on
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001
  
  lda #TITLESTATE_DONE
  sta state_control_params+titleStateControl::state
  
  jmp stateCommandComplete
  
titleStateDone:

  jsr controller_read
  lda buffer_controller+buttons::_start
  and #1
  beq :+
  
  .ifdef MUSIC_ENABLE
  jsr sound_stop
  jsr sound_upload
  .endif
  
  ;start was pressed, now we want to switch to level in state
  ;set current level and switch to "level in" state
  ;start out Nomolos with 3 lives.
  lda #nomolosStartingLives
  sta nomolos_status_lives
  lda #startingLevel
  sta level_current
  lda #LEVELINSTATE_INIT
  sta state_control_params+levelOutStateControl::state
  switchState level_in_state_update, level_in_state_update_ppu
  
:

  jmp stateCommandComplete
  
stateCommandComplete:

  rts
.endproc
  
.proc title_state_update_ppu

  .ifdef MUSIC_ENABLE
  jsr sound_update
  jsr sound_upload
  .endif

  rts
.endproc
  