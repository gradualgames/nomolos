;The following is the entity pool. All entities are treated as chunks of
;16 bytes from this pool with the following schema:
;entity schema:
;0  .dsb alive = 1
;1  .dsb index = definition index (this is a parameter)
;2  .dsw spawnPositionX = initialXOffset + x
;4  .dsb spawnPositionY = initialYOffset + y
;5  .dsb positionXFine  = unknown, this is expected to be used (or not used) by the entity
;6  .dsw positionX      = x (this is a parameter)
;8  .dsb positionYFine  = unknown, this is expected to be used (or not used) by the entity
;9  .dsb positionY      = y (this is a parameter)
;10 .dsb state          = initialState
;11 .dsw animationObject  = unknown, this expected to be set by the entity
;13 .dsb 3 ;padding to 16 bytes


.struct entityRAM
  alive .byte
  index .byte
  spawnPositionX .word
  spawnPositionY .byte
  positionXFine .byte
  positionX .word
  positionYFine .byte
  positionY .byte
  state .byte
  animationObject .word
  extra .byte 3
.endstruct