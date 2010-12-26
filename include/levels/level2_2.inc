.ifndef LEVEL2_2_INC
LEVEL2_2_INC = 1

level2_2bank = 1
level2_2patterns_bank = 8

level2_2sprites_Nomolos_chr_index = 0
level2_2sprites_Deentle_chr_index = level2_2sprites_Nomolos_chr_index+Nomolos_chr_size
level2_2sprites_Explosion_chr_index = level2_2sprites_Deentle_chr_index+Deentle_chr_size
level2_2sprites_Beedie_chr_index = level2_2sprites_Explosion_chr_index+Explosion_chr_size
level2_2sprites_Grank_chr_index = level2_2sprites_Beedie_chr_index+Beedie_chr_size
level2_2sprites_Skelekin_chr_index = level2_2sprites_Grank_chr_index+Grank_chr_size
level2_2sprites_Bat_chr_index = level2_2sprites_Skelekin_chr_index+Skelekin_chr_size

.include "spritesheet1.inc"
.import level2_2patterns
.import level2_2palette
.import level2_2cycling_palettes
.import level2_2map
.import level2_2map_column_table
.import level2_2attribute_column_table
.import level2_2meta_tile_column_table
.import level2_2meta_tile_table
.import level2_2music

.endif
