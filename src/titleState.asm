.include "flags.inc"
.include "soundengine.inc"
.include "controller.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "fixedBankData.inc"
.include "sprite.inc"
.include "levelInState.inc"
.include "zp.inc"
.include "ram.inc"
.include "nomolosLogic.inc"
.include "titleState.inc"
.include "statemanager.inc"

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

  ;****************************************************************
  ;Wait for vblank, then turn off nmi and all graphics.
  ;****************************************************************

  ;this init state should be similar to the level in state, only we won't be
  ;clearing the nametable, we'll be loading it from a particular location.
  waitVBlank
  
  ;turn off nmi
  clear_ppu_2000_bit PPU0_EXECUTE_NMI
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
  
  lda #TITLESTATE_RUN
  sta state_control_params+titleStateControl::state

  jmp stateCommandComplete
  
titleStateRun:

  ;****************************************************************
  ;Clear sprite memory, load title graphics, load faded out palette
  ;****************************************************************

  ;clear the sprites
  jsr sprite_clear_all
  ;update sprites
  jsr sprite_update_all

  ;load the title nametable and attribute table.
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006
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
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006
  
  jsr ppu_load_chr_amount
  
  ;write some important strings onto the title screen!
  set_ppu_2006 $20, 19, 10
  lda #<press_start_string
  sta w0
  lda #>press_start_string
  sta w0+1
  
  jsr ppu_display_string
  
  set_ppu_2006 $20, 22, 10
  lda #<lda_games_string
  sta w0
  lda #>lda_games_string
  sta w0+1
  
  jsr ppu_display_string
  
  set_ppu_2006 $20, 23, 10
  
  lda #<copyright_c_2010_string
  sta w0
  lda #>copyright_c_2010_string
  sta w0+1
  
  jsr ppu_display_string
  
  ;now that nametable loaded, load the new palette faded out
  lda titleDef+title::paletteAddress
  sta w0
  lda titleDef+title::paletteAddress+1
  sta w0+1
  
  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness
  
  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1
  
  waitVBlank
  jsr ppu_load_palette
  
  ;****************************************************************
  ;Set VRAM and scroll registers to point to first nametable and
  ;scroll to 0, 0. Then switch on nmi and all graphics and fade in
  ;the palette using the dynamic palette upload nmi routine in
  ;the state manager module.
  ;Start title music playing.
  ;****************************************************************
  
  ;reset scroll
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006
  upload_ppu_2006
  
  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005
  
  ;turn on nmi
  set_ppu_2000_bit PPU0_EXECUTE_NMI
  upload_ppu_2000
  
  ;turn sprite and background visibility on
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001
  
  lda titleDef+title::paletteAddress
  sta w0
  lda titleDef+title::paletteAddress+1
  sta w0+1
  
  jsr fade_in_palette
  
  ;load title screen music
.ifdef MUSIC_ENABLE
  lda #<title_music
  sta sound_param_word_1
  lda #>title_music
  sta sound_param_word_1+1
  jsr song_initialize
.endif
  
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
  
  ;create dynamic palette from rom palette
  lda titleDef+title::paletteAddress
  sta w0
  lda titleDef+title::paletteAddress+1
  sta w0+1
  
  jsr fade_out_palette
  
  ;****************************************************************
  ;Set initial game state, such as what level to start on and
  ;how many lives Nomolos has. Switch to the level in state.
  ;****************************************************************
  
  ;start was pressed, now we want to switch to level in state
  ;set current level and switch to "level in" state
  ;start out Nomolos with 3 lives.
  lda #nomolosStartingLives
  sta nomolos_status_lives
  lda #startingLevel
  sta level_current
  lda #LEVELINSTATE_INIT
  sta state_control_params+levelInStateControl::state
  ldx #index_level_in_state
  jsr switch_state
  
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
  
  lda #1
  sta vblank_done

  rts
.endproc
  