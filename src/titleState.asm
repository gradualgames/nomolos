.include "structs.inc"
.include "constants.inc"
.include "flags.inc"
.include "famitracker.inc"
.include "macros.inc"
.include "controller.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "gameUIData.inc"
.include "sprite.inc"
.include "levelInState.inc"
.include "zp.inc"

.segment "CODE"

.export title_state_update
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
  
  ;turn sprite and background visibility off
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  lda #( ( 0 << PPU1_SPRITE_VISIBILITY ) | ( 0 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  ;initialize music driver as NTSC and track #0.
.ifdef MUSIC_ENABLE
  ; lda #<title_music
  ; sta ft_music_addr
  ; lda #>title_music
  ; sta ft_music_addr+1
  ; lda #0
  ; ldx #0
  ; jsr ft_music_init
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
  jsr ppu_load_chr
  
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
  
  ;turn on NMI
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 1 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  ;turn sprite and background visibility on
  lda #( ( 1 << PPU1_SPRITE_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_VISIBILITY ) | ( 1 << PPU1_BACKGROUND_CLIPPING ) | ( 1 << PPU1_SPRITE_CLIPPING ) )
  sta $2001
  
  lda #TITLESTATE_DONE
  sta state_control_params+titleStateControl::state
  
  jmp stateCommandComplete
  
titleStateDone:

  jsr controller_read
  lda buffer_controller+buttons::_start
  and #1
  beq :+
  
  ; .ifdef MUSIC_ENABLE
  ; lda #<haltmusic
  ; sta ft_music_addr
  ; lda #>haltmusic
  ; sta ft_music_addr+1
  ; jsr ft_music_init
  ; .endif
  
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
  
.export title_state_update_ppu
.proc title_state_update_ppu

  ; .ifdef MUSIC_ENABLE
  ; jsr ft_music_play
  ; .endif

  rts
.endproc
  