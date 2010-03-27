.include "structs.inc"
.include "constants.inc"
.include "macros.inc"
.include "flags.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "famitracker.inc"
.include "zp.inc"
.include "gameOverState.inc"
.include "levelInState.inc"

.segment "CODE"

.export level_out_state_update
.proc level_out_state_update
  rts
.endproc
  
.export level_out_state_update_ppu
.proc level_out_state_update_ppu
  lda state_control_params+levelOutStateControl::state
  cmp #LEVELOUTSTATE_INIT
  beq levelOutStateInit
  cmp #LEVELOUTSTATE_FADEOUT
  beq levelOutStateFadeOut
  jmp stateCommandComplete
    
  ;************************************************************
  ;init state
  ;************************************************************
levelOutStateInit:

  lda #5
  sta frame_counter
  lda #0
  sta palette_step
  lda #LEVELOUTSTATE_FADEOUT
  sta state_control_params+levelOutStateControl::state
  
  lda #( ( 1 << PPU0_EXECUTE_NMI ) | ( 0 << PPU0_ADDRESS_INCREMENT ) | ( 1 << PPU0_SPRITE_PATTERN_TABLE_ADDRESS ) )
  sta $2000
  
  jmp stateCommandComplete

  ;************************************************************
  ;fade out state
  ;************************************************************
levelOutStateFadeOut:

  dec frame_counter
  beq :+
  jmp skipIncPaletteStep
:
  
  lda #5
  sta frame_counter
  
  lda palette_step
  cmp #6
  bmi :+ 
  
  ;this is the end condition of the fade out. Instead of skipping the step
  ;we want to actually switch to the level in state.
  
  lda nomolos_status_lives
  
  bmi livesNegativeMeansGameOver
  
  lda #LEVELINSTATE_INIT
  sta state_control_params+levelOutStateControl::state
  switchState level_in_state_update, level_in_state_update_ppu
  jmp skipIncPaletteStep
  
livesNegativeMeansGameOver:

  lda #GAMEOVERSTATE_INIT
  sta state_control_params+gameOverStateControl::state
  switchState game_over_state_update, game_over_state_update_ppu
  jmp skipIncPaletteStep

:
  
  inc palette_step

  ;************************************************************
  ;Load palette_step, decide how to modify the current palette
  ;based on that step. 
  ;************************************************************
  lda palette_step
  cmp #3
  bpl stepGreaterThanOrEqualToFour
stepLessThanFour:

  ;load the address of the current palette in ROM
  ldy #ROMDefinitionTableStruct::palette
  lda (base_address_rom_definition_table),y
  sta w0
  iny
  lda (base_address_rom_definition_table),y
  sta w0+1
  ldy #0
  lda #$3F
  sta $2006
  lda #$00
  sta $2006  
  ldx #$00
: 

  ;save x
  txa
  pha

  ;load palette entry
  lda (w0),y
  
  ;load the current palette step
  ldx palette_step
darkenPaletteLoop:
  cmp #$10
  bmi paletteEntryLessThan16

  ;subtract 16 from the palette entry
  sec
  sbc #$10
  
paletteEntryLessThan16:
  
  dex
  bne darkenPaletteLoop
  
  ;store new palette value 
  sta $2007
  
  ;restore x
  pla
  tax

  inx
  iny
  cpx #$20
  bne :-
  
  jmp stateCommandComplete
  
stepGreaterThanOrEqualToFour:
  
dropOutAllColorsToBlack:
  ;drop out all colors to black
  lda #$3F
  sta $2006
  lda #$00
  sta $2006  
  ldx #$00
: lda #$3f
  sta $2007
  inx
  cpx #$20
  bne :-
  
skipIncPaletteStep:
  
stateCommandComplete:

  lda name_table_to_view
  sta $2006
  lda #$00
  sta $2006

  lda camera_scroll_x
  sta $2005
  lda #0
  sta $2005
  
  .ifdef MUSIC_ENABLE
  ;switch to the level and music bank
  ldy #ROMDefinitionTableStruct::LevelAndMusicBank
  lda (base_address_rom_definition_table),y
  sta mapper_bank_next
  jsr mapper_switch_bank
  jsr ft_music_play
  .endif

  rts
.endproc