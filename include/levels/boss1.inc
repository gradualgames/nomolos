.ifndef boss1_INC
boss1_INC = 1

.include "spritesheet1.inc"
.import boss1_sprite_groups
.import boss1_patterns
.import boss1_palette
.import boss1_cycling_palettes
.import boss1_map
.import boss1_map_column_table
.import boss1_attribute_column_table
.import boss1_meta_tile_column_table
.import boss1_meta_tile_table
.import boss1_music

boss_1_bank = 3
boss_1_patterns_bank = 8

boss1_sprites_Nomolos_chr_index = 0
boss1_sprites_Explosion_chr_index = boss1_sprites_Nomolos_chr_index+Nomolos_chr_size
boss1_sprites_IceBall_chr_index = boss1_sprites_Explosion_chr_index+Explosion_chr_size
boss1_sprites_Stalactite_chr_index = boss1_sprites_IceBall_chr_index+IceBall_chr_size
boss1_sprites_DragonFace_chr_index = boss1_sprites_Stalactite_chr_index+Stalactite_chr_size

.endif
