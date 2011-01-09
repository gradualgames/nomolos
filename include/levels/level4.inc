.ifndef LEVEL4_INC
LEVEL4_INC = 1

level_4_bank = 2
level_4_patterns_bank = 9

level4_sprites_Nomolos_chr_index = 0
level4_sprites_Explosion_chr_index = level4_sprites_Nomolos_chr_index+Nomolos_chr_size
level4_sprites_Phoenix_chr_index = level4_sprites_Explosion_chr_index+Explosion_chr_size
level4_sprites_Fireball_chr_index = level4_sprites_Phoenix_chr_index+Phoenix_chr_size

.include "spritesheet1.inc"
.import level4_sprite_groups
.import level4_patterns
.import level4_palette
.import level4_map
.import level4_map_column_table
.import level4_attribute_column_table
.import level4_meta_tile_column_table
.import level4_meta_tile_table
.import level4_music

.endif
