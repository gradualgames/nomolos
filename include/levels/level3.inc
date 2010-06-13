.ifndef LEVEL3_INC
LEVEL3_INC = 1

level_3_index = 2
level_3_bank = 1
level_3_patterns_bank = 3

level3_sprites_Nomolos_chr_index = 0
level3_sprites_Snail_chr_index = level3_sprites_Nomolos_chr_index+Nomolos_chr_size
level3_sprites_Explosion_chr_index = level3_sprites_Snail_chr_index+Snail_chr_size

.include "spritesheet1.inc"
.import level3_sprite_groups
.import level3_patterns
.import level3_palette
.import level3_map
.import level3_map_column_table
.import level3_attribute_column_table
.import level3_meta_tile_column_table
.import level3_meta_tile_table
.import level3_music

.endif
