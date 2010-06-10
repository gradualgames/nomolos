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

spritesheet1_Nomolos_chr_index = 0
spritesheet1_Deentle_chr_index = spritesheet1_Nomolos_chr_index+Nomolos_chr_size
spritesheet1_Explosion_chr_index = spritesheet1_Deentle_chr_index+Deentle_chr_size
spritesheet1_Beedie_chr_index = spritesheet1_Explosion_chr_index+Explosion_chr_size
spritesheet1_Grank_chr_index = spritesheet1_Beedie_chr_index+Beedie_chr_size
spritesheet1_Bat_chr_index = spritesheet1_Grank_chr_index+Grank_chr_size
spritesheet1_Batree_chr_index = spritesheet1_Bat_chr_index+Bat_chr_size
spritesheet1_Owl_chr_index = spritesheet1_Batree_chr_index+Batree_chr_size
spritesheet1_Snuffer_chr_index = spritesheet1_Owl_chr_index+Owl_chr_size

spritesheet2_Nomolos_chr_index = 0
spritesheet2_Deentle_chr_index = spritesheet2_Nomolos_chr_index+Nomolos_chr_size
spritesheet2_Explosion_chr_index = spritesheet2_Deentle_chr_index+Deentle_chr_size
spritesheet2_Beedie_chr_index = spritesheet2_Explosion_chr_index+Explosion_chr_size
spritesheet2_Grank_chr_index = spritesheet2_Beedie_chr_index+Beedie_chr_size
spritesheet2_Skelekin_chr_index = spritesheet2_Grank_chr_index+Grank_chr_size
spritesheet2_Bat_chr_index = spritesheet2_Skelekin_chr_index+Skelekin_chr_size

.include "spritesheet1_sprites_imports.inc"
.include "spritesheet1_animations_imports.inc"
;.import spritesheet1_PatternTable
.import level1_sprite_groups
.import level2_sprite_groups

.endif
