.include "slides.inc"

.segment "ROM11"

.include "gradual_games_logo.inc"

.segment "ROM05"

;ONCE UPON A TIME, SOLOMON       AND SNOW WERE ENJOYING          A BEAUTIFUL DAY TOGETHER.
solomon_snow_watching_birds_caption:
  .byte $59,$0e,$0d,$02,$04,$1a,$14,$0f,$0e,$0d,$1a,$00,$1a,$13,$08,$0c,$04,$25,$1a,$12,$0e,$0b,$0e,$0c,$0e,$0d,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$00,$0d,$03,$1a,$12,$0d,$0e,$16,$1a,$16,$04,$11,$04,$1a,$04,$0d,$09,$0e,$18,$08,$0d,$06,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$00,$1a,$01,$04,$00,$14,$13,$08,$05,$14,$0b,$1a,$03,$00,$18,$1a,$13,$0e,$06,$04,$13,$07,$04,$11,$27

;WHEN SUDDENLY,                  A MYSTERIOUS PORTAL             APPEARED BEFORE THEM!
portal_appears_caption:
  .byte $55,$16,$07,$04,$0d,$1a,$12,$14,$03,$03,$04,$0d,$0b,$18,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$00,$1a,$0c,$18,$12,$13,$04,$11,$08,$0e,$14,$12,$1a,$0f,$0e,$11,$13,$00,$0b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$00,$0f,$0f,$04,$00,$11,$04,$03,$1a,$01,$04,$05,$0e,$11,$04,$1a,$13,$07,$04,$0c,$28

;BEFORE SOLOMON COULD            REACT, A HUGE PURPLE            ARM SNATCHED SNOW AWAY!!
arm_snatches_snow_caption:
  .byte $58,$01,$04,$05,$0e,$11,$04,$1a,$12,$0e,$0b,$0e,$0c,$0e,$0d,$1a,$02,$0e,$14,$0b,$03,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$11,$04,$00,$02,$13,$25,$1a,$00,$1a,$07,$14,$06,$04,$1a,$0f,$14,$11,$0f,$0b,$04,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$00,$11,$0c,$1a,$12,$0d,$00,$13,$02,$07,$04,$03,$1a,$12,$0d,$0e,$16,$1a,$00,$16,$00,$18,$28,$28

;ONCE HE COMPOSED HIMSELF,       SOLOMON LEAPT THROUGH           THE PORTAL AS IT BEGAN          TO CLOSE!
leapt_through_portal_caption:
  .byte $69,$0e,$0d,$02,$04,$1a,$07,$04,$1a,$02,$0e,$0c,$0f,$0e,$12,$04,$03,$1a,$07,$08,$0c,$12,$04,$0b,$05,$25,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$12,$0e,$0b,$0e,$0c,$0e,$0d,$1a,$0b,$04,$00,$0f,$13,$1a,$13,$07,$11,$0e,$14,$06,$07,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$13,$07,$04,$1a,$0f,$0e,$11,$13,$00,$0b,$1a,$00,$12,$1a,$08,$13,$1a,$01,$04,$06,$00,$0d,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$13,$0e,$1a,$02,$0b,$0e,$12,$04,$28

;UPON REACHING THE OTHER         SIDE, HE TRANSFORMED            INTO NOMOLOS,                   THE FIERCE FELINE WARRIOR!
became_nomolos_caption:
  .byte $7a,$14,$0f,$0e,$0d,$1a,$11,$04,$00,$02,$07,$08,$0d,$06,$1a,$13,$07,$04,$1a,$0e,$13,$07,$04,$11,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$12,$08,$03,$04,$25,$1a,$07,$04,$1a,$13,$11,$00,$0d,$12,$05,$0e,$11,$0c,$04,$03,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$08,$0d,$13,$0e,$1a,$0d,$0e,$0c,$0e,$0b,$0e,$12,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$13,$07,$04,$1a,$05,$08,$04,$11,$02,$04,$1a,$05,$04,$0b,$08,$0d,$04,$1a,$16,$00,$11,$11,$08,$0e,$11,$28

;FINDING HIMSELF EQUIPPED        WITH ARMOR AND A SWORD,         NOMOLOS SET OUT TO SAVE         SNOW!!!
nomolos_sets_out_caption:
  .byte $67,$05,$08,$0d,$03,$08,$0d,$06,$1a,$07,$08,$0c,$12,$04,$0b,$05,$1a,$04,$10,$14,$08,$0f,$0f,$04,$03,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$16,$08,$13,$07,$1a,$00,$11,$0c,$0e,$11,$1a,$00,$0d,$03,$1a,$00,$1a,$12,$16,$0e,$11,$03,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0d,$0e,$0c,$0e,$0b,$0e,$12,$1a,$12,$04,$13,$1a,$0e,$14,$13,$1a,$13,$0e,$1a,$12,$00,$15,$04,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$12,$0d,$0e,$16,$28,$28,$28

secret_message_caption:
;YOU ARE VERY TALENTED.          AT TITLE HOLD SELECT,           A, B, THEN HIT UP OR DOWN       TO SELECT START LEVEL
  .byte $75,$18,$0e,$14,$1a,$00,$11,$04,$1a,$15,$04,$11,$18,$1a,$13,$00,$0b,$04,$0d,$13,$04,$03,$27,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$00,$13,$1a,$13,$08,$13,$0b,$04,$1a,$07,$0e,$0b,$03,$1a,$12,$04,$0b,$04,$02,$13,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$00,$25,$1a,$01,$25,$1a,$13,$07,$04,$0d,$1a,$07,$08,$13,$1a,$14,$0f,$1a,$0e,$11,$1a,$03,$0e,$16,$0d,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$13,$0e,$1a,$12,$04,$0b,$04,$02,$13,$1a,$12,$13,$00,$11,$13,$1a,$0b,$04,$15,$04,$0b

;SNOW: "SOLOMON! I KNEW          YOU WOULD COME TO               RESCUE ME!"
nomolos_and_snow_reunited_caption:
  .byte $4b,$12,$0d,$0e,$16,$2b,$1a,$26,$12,$0e,$0b,$0e,$0c,$0e,$0d,$28,$1a,$08,$1a,$0a,$0d,$04,$16,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$18,$0e,$14,$1a,$16,$0e,$14,$0b,$03,$1a,$02,$0e,$0c,$04,$1a,$13,$0e,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$11,$04,$12,$02,$14,$04,$1a,$0c,$04,$28,$26

;SNOW: "LOOK! A PORTAL           IS APPEARING ABOVE THE          SCEPTER!"
portal_appears_above_scepter_caption:
  .byte $49,$12,$0d,$0e,$16,$2b,$1a,$26,$0b,$0e,$0e,$0a,$28,$1a,$00,$1a,$0f,$0e,$11,$13,$00,$0b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$08,$12,$1a,$00,$0f,$0f,$04,$00,$11,$08,$0d,$06,$1a,$00,$01,$0e,$15,$04,$1a,$13,$07,$04,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$12,$02,$04,$0f,$13,$04,$11,$28,$26

;NOMOLOS AND SNOW LEAPT          THROUGH  THE PORTAL             TOGETHER.
leapt_through_ending_portal_caption:
  .byte $49,$0d,$0e,$0c,$0e,$0b,$0e,$12,$1a,$00,$0d,$03,$1a,$12,$0d,$0e,$16,$1a,$0b,$04,$00,$0f,$13,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$13,$07,$11,$0e,$14,$06,$07,$1a,$1a,$13,$07,$04,$1a,$0f,$0e,$11,$13,$00,$0b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$13,$0e,$06,$04,$13,$07,$04,$11,$27

;THANK YOU FOR PLAYING                                           NOMOLOS:                        STORMING THE CATSLE
thanks_for_playing_caption:
  .byte $53,$13,$07,$00,$0d,$0a,$1a,$18,$0e,$14,$1a,$05,$0e,$11,$1a,$0f,$0b,$00,$18,$08,$0d,$06,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0d,$0e,$0c,$0e,$0b,$0e,$12,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$12,$13,$0e,$11,$0c,$08,$0d,$06,$1a,$13,$07,$04,$1a,$02,$00,$13,$12,$0b,$04

;BY GRADUAL GAMES
by_gradual_games_caption:
  .byte $10,$01,$18,$1a,$06,$11,$00,$03,$14,$00,$0b,$1a,$06,$00,$0c,$04,$12

;PROGRAMMER,                     LEVEL DESIGNER,                 ARRANGER:                                                       DEREK ANDREWS
derek_andrews_caption:
  .byte $8d,$0f,$11,$0e,$06,$11,$00,$0c,$0c,$04,$11,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0b,$04,$15,$04,$0b,$1a,$03,$04,$12,$08,$06,$0d,$04,$11,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$00,$11,$11,$00,$0d,$06,$04,$11,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$03,$04,$11,$04,$0a,$1a,$00,$0d,$03,$11,$04,$16,$12

;CONCEPT ARTIST,                 PIXEL ARTIST,                   GRAPHIC DESIGNER:                                               LAURIE ANDREWS
laurie_andrews_caption:
  .byte $8e,$02,$0e,$0d,$02,$04,$0f,$13,$1a,$00,$11,$13,$08,$12,$13,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0f,$08,$17,$04,$0b,$1a,$00,$11,$13,$08,$12,$13,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$06,$11,$00,$0f,$07,$08,$02,$1a,$03,$04,$12,$08,$06,$0d,$04,$11,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0b,$00,$14,$11,$08,$04,$1a,$00,$0d,$03,$11,$04,$16,$12

;GAMEPLAY CONSULTANT,            CHIEF BETA TESTER,              LEVEL REVIEWER:                                                 DANIEL HWOZDEK
daniel_hwozdek_caption:
  .byte $8e,$06,$00,$0c,$04,$0f,$0b,$00,$18,$1a,$02,$0e,$0d,$12,$14,$0b,$13,$00,$0d,$13,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$02,$07,$08,$04,$05,$1a,$01,$04,$13,$00,$1a,$13,$04,$12,$13,$04,$11,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0b,$04,$15,$04,$0b,$1a,$11,$04,$15,$08,$04,$16,$04,$11,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$03,$00,$0d,$08,$04,$0b,$1a,$07,$16,$0e,$19,$03,$04,$0a

;MUSIC BY:                                                       SCARLATTI,                      BACH,                           RAMEAU,                         ROYER,                          SOLER,                          COUPERIN
music_by_caption:
  .byte $e8,$0c,$14,$12,$08,$02,$1a,$01,$18,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$12,$02,$00,$11,$0b,$00,$13,$13,$08,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$01,$00,$02,$07,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$11,$00,$0c,$04,$00,$14,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$11,$0e,$18,$04,$11,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$12,$0e,$0b,$04,$11,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$02,$0e,$14,$0f,$04,$11,$08,$0d

;BETA TESTERS:                                                   JOSEPH MORGAN,                  FRED ST. LOUIS,                 JOHN WHITE,                     CHRIS HWOZDEK,                  NATHAN GILLESPIE
beta_testers_caption:
  .byte $d0,$01,$04,$13,$00,$1a,$13,$04,$12,$13,$04,$11,$12,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$09,$0e,$12,$04,$0f,$07,$1a,$0c,$0e,$11,$06,$00,$0d,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$05,$11,$04,$03,$1a,$12,$13,$27,$1a,$0b,$0e,$14,$08,$12,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$09,$0e,$07,$0d,$1a,$16,$07,$08,$13,$04,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$02,$07,$11,$08,$12,$1a,$07,$16,$0e,$19,$03,$04,$0a,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0d,$00,$13,$07,$00,$0d,$1a,$06,$08,$0b,$0b,$04,$12,$0f,$08,$04

;CART PRODUCTION:                                                RETROZONE
production_caption:
  .byte $49,$02,$00,$11,$13,$1a,$0f,$11,$0e,$03,$14,$02,$13,$08,$0e,$0d,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$11,$04,$13,$11,$0e,$19,$0e,$0d,$04

;PRINTED MATERIALS:                                              UNCLE TUSK
printed_materials_caption:
  .byte $4a,$0f,$11,$08,$0d,$13,$04,$03,$1a,$0c,$00,$13,$04,$11,$08,$00,$0b,$12,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$14,$0d,$02,$0b,$04,$1a,$13,$14,$12,$0a

;PROMOTION,                      SOCIAL MEDIA:                                                   JOSEPH MORGAN
promotion_social_media_caption:
  .byte $6d,$0f,$11,$0e,$0c,$0e,$13,$08,$0e,$0d,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$12,$0e,$02,$08,$00,$0b,$1a,$0c,$04,$03,$08,$00,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$09,$0e,$12,$04,$0f,$07,$1a,$0c,$0e,$11,$06,$00,$0d

;SPECIAL THANKS TO:                                              JOHN WHITE,                     JSR,                            MOTZILLA,                       METALSLIME,                     CRUCIVERBO
special_thanks_caption:
  .byte $ca,$12,$0f,$04,$02,$08,$00,$0b,$1a,$13,$07,$00,$0d,$0a,$12,$1a,$13,$0e,$2b,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$09,$0e,$07,$0d,$1a,$16,$07,$08,$13,$04,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$09,$12,$11,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0c,$0e,$13,$19,$08,$0b,$0b,$00,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$0c,$04,$13,$00,$0b,$12,$0b,$08,$0c,$04,$25,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a,$1a
  .byte $1a,$02,$11,$14,$02,$08,$15,$04,$11,$01,$0e

;EVERYONE AT NESDEV
nesdev_caption:
  .byte $12,$04,$15,$04,$11,$18,$0e,$0d,$04,$1a,$00,$13,$1a,$0d,$04,$12,$03,$04,$15

;EVERYONE AT NINTENDOAGE
nintendoage_caption:
  .byte $17,$04,$15,$04,$11,$18,$0e,$0d,$04,$1a,$00,$13,$1a,$0d,$08,$0d,$13,$04,$0d,$03,$0e,$00,$06,$04

.segment "ROM10"

.include "title_nametable_source.inc"

title_palette:
  .byte $3f,$20,$3f,$3f,$3f,$16,$20,$10,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
  .byte $3f,$20,$3f,$3f,$3f,$16,$20,$10,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f

.include "slide3.inc"

.segment "ROM07"

.include "slide4.inc"

.include "slide5.inc"

.include "ending_slide1.inc"

.segment "ROM12"

.include "ending_slide2.inc"

.segment "ROM15"

.include "ending_slide3.inc"

.include "slide1.inc"

.include "slide2.inc"
