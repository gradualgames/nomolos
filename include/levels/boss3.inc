.ifndef BOSS3_INC
BOSS3_INC = 1

.include "spritesheet1.inc"
.import boss3_sprite_groups
.import boss3_music
.import boss3_palette
.import boss3_map
.import boss3_map_column_table
.import boss3_attribute_column_table
.import boss3_meta_tile_column_table
.import boss3_meta_tile_table

boss3_bank = 4

boss3_sprites_Nomolos_chr_index = 0
boss3_sprites_Explosion_chr_index = boss3_sprites_Nomolos_chr_index+Nomolos_chr_size
boss3_sprites_bigfireball_chr_index = boss3_sprites_Explosion_chr_index+Explosion_chr_size
boss3_sprites_Grank_chr_index = boss3_sprites_bigfireball_chr_index+bigfireball_chr_size
boss3_sprites_GrubselimBoj_chr_index = boss3_sprites_Grank_chr_index+Grank_chr_size

.endif
