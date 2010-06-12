.ifndef LEVEL1_INC
LEVEL1_INC = 1

level_1_index = 0
level_1_bank = 0
level_1_patterns_bank = 3

level1_sprites_Nomolos_chr_index = 0
level1_sprites_Deentle_chr_index = level1_sprites_Nomolos_chr_index+Nomolos_chr_size
level1_sprites_Explosion_chr_index = level1_sprites_Deentle_chr_index+Deentle_chr_size
level1_sprites_Beedie_chr_index = level1_sprites_Explosion_chr_index+Explosion_chr_size
level1_sprites_Grank_chr_index = level1_sprites_Beedie_chr_index+Beedie_chr_size
level1_sprites_Bat_chr_index = level1_sprites_Grank_chr_index+Grank_chr_size
level1_sprites_Batree_chr_index = level1_sprites_Bat_chr_index+Bat_chr_size
level1_sprites_Owl_chr_index = level1_sprites_Batree_chr_index+Batree_chr_size
level1_sprites_Snuffer_chr_index = level1_sprites_Owl_chr_index+Owl_chr_size

.include "spritesheet1.inc"
.import level1_sprite_groups
.import level1_patterns
.import level1_palette
.import level1_map
.import level1_map_column_table
.import level1_attribute_column_table
.import level1_meta_tile_column_table
.import level1_meta_tile_table
.import level1_music

.endif
