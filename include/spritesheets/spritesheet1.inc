.ifndef SPRITESHEET1_INC
SPRITESHEET1_INC = 1

sprite_sheet_1_bank = 2
sprite_sheet_1_patterns_bank = 3

Nomolos_chr_size = 131
Deentle_chr_size = 8
Explosion_chr_size = 12
Beedie_chr_size = 8
Grank_chr_size = 8
Bat_chr_size = 4
Batree_chr_size = 18
Owl_chr_size = 34
Snuffer_chr_size = 30
Skelekin_chr_size = 12
Snail_chr_size = 12

level1_sprites_Nomolos_chr_index = 0
level1_sprites_Deentle_chr_index = level1_sprites_Nomolos_chr_index+Nomolos_chr_size
level1_sprites_Explosion_chr_index = level1_sprites_Deentle_chr_index+Deentle_chr_size
level1_sprites_Beedie_chr_index = level1_sprites_Explosion_chr_index+Explosion_chr_size
level1_sprites_Grank_chr_index = level1_sprites_Beedie_chr_index+Beedie_chr_size
level1_sprites_Bat_chr_index = level1_sprites_Grank_chr_index+Grank_chr_size
level1_sprites_Batree_chr_index = level1_sprites_Bat_chr_index+Bat_chr_size
level1_sprites_Owl_chr_index = level1_sprites_Batree_chr_index+Batree_chr_size
level1_sprites_Snuffer_chr_index = level1_sprites_Owl_chr_index+Owl_chr_size

level2_sprites_Nomolos_chr_index = 0
level2_sprites_Deentle_chr_index = level2_sprites_Nomolos_chr_index+Nomolos_chr_size
level2_sprites_Explosion_chr_index = level2_sprites_Deentle_chr_index+Deentle_chr_size
level2_sprites_Beedie_chr_index = level2_sprites_Explosion_chr_index+Explosion_chr_size
level2_sprites_Grank_chr_index = level2_sprites_Beedie_chr_index+Beedie_chr_size
level2_sprites_Skelekin_chr_index = level2_sprites_Grank_chr_index+Grank_chr_size
level2_sprites_Bat_chr_index = level2_sprites_Skelekin_chr_index+Skelekin_chr_size

level3_sprites_Nomolos_chr_index = 0
level3_sprites_Snail_chr_index = level3_sprites_Nomolos_chr_index+Nomolos_chr_size

.include "spritesheet1_sprites_imports.inc"
.include "spritesheet1_animations_imports.inc"
.import level1_sprite_groups
.import level2_sprite_groups
.import level3_sprite_groups

.endif
