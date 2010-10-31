.include "soundengine.inc"

.ifndef RESTARTENTITY_INC
RESTARTENTITY_INC = 1

RESTARTENTITY_WIDTH = $10
RESTARTENTITY_HEIGHT = $ff

restart_update:

  ;load the restart point and screen from the map, store it in the restart point variables
  ldy #level_data_struct::nomolos_restart_x
  lda (base_address_rom_definition_table),y
  sta restart_x
  ldy #level_data_struct::nomolos_restart_y
  lda (base_address_rom_definition_table),y
  sta restart_y
  ldy #level_data_struct::restart_screen
  lda (base_address_rom_definition_table),y
  sta restart_screen
  
  ;kill the entity
  lda #0
  sta entity_instances+entity_instance::alive,x

  rts

.endif
