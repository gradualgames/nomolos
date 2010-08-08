.include "flags.inc"
.include "ram.inc"
.include "zp.inc"
.include "ram.inc"
.include "ppu.inc"
.include "map.inc"
.include "fixed_bank_data.inc"
.include "load_level_state.inc"
.include "geotests.inc"
.include "nomolos_logic.inc"
.include "entity.inc"
.include "camera.inc"
.include "sprite.inc"
.include "sound.inc"

.segment "ROM3"

.include "spritesheet1_patterns_source.inc"

.segment "ROM2"

.include "spritesheet1_sprites_source.inc"
.include "spritesheet1_animations_source.inc"

