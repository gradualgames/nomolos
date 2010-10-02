.ifndef LEVEL2_INC
LEVEL2_INC = 1

level_2_index = 1
level_2_bank = 1
level_2_patterns_bank = 4

level2_sprites_Nomolos_chr_index = 0
level2_sprites_Deentle_chr_index = level2_sprites_Nomolos_chr_index+Nomolos_chr_size
level2_sprites_Explosion_chr_index = level2_sprites_Deentle_chr_index+Deentle_chr_size
level2_sprites_Beedie_chr_index = level2_sprites_Explosion_chr_index+Explosion_chr_size
level2_sprites_Grank_chr_index = level2_sprites_Beedie_chr_index+Beedie_chr_size
level2_sprites_Skelekin_chr_index = level2_sprites_Grank_chr_index+Grank_chr_size
level2_sprites_Bat_chr_index = level2_sprites_Skelekin_chr_index+Skelekin_chr_size

.include "spritesheet1.inc"
.import level2_sprite_groups
.import level2_patterns
.import level2_palette
.import level2_cycling_palettes
.import level2_map
.import level2_map_column_table
.import level2_attribute_column_table
.import level2_meta_tile_column_table
.import level2_meta_tile_table
.import level2_music

.endif
