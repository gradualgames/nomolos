.segment "ZEROPAGE"

.exportzp b0
b0:       .res 1

.exportzp b1
b1:       .res 1

.exportzp b2
b2:       .res 1

.exportzp b3
b3:       .res 1

.exportzp b4
b4:       .res 1

.exportzp b5
b5:       .res 1

.exportzp b6
b6:       .res 1

.exportzp b7
b7:       .res 1

.exportzp b8
b8:       .res 1

.exportzp b9
b9:       .res 1

.exportzp w0
w0:       .res 2

.exportzp w1
w1:       .res 2

.exportzp w2
w2:       .res 2

.exportzp w3
w3:       .res 2

.exportzp w4
w4:       .res 2

.exportzp w5
w5:       .res 2

.exportzp w6
w6:       .res 2

.exportzp w7
w7:       .res 2

.exportzp w8
w8:       .res 2

.exportzp w9
w9:       .res 2

.exportzp entityScreenX
entityScreenX: .res 2

.exportzp entityScreenY
entityScreenY: .res 2

.exportzp currentBank
currentBank: .res 1

.exportzp nextBank
nextBank: .res 1

.exportzp stringBuffer
stringBuffer: .res 8

.exportzp vblankDone
vblankDone:  .res 1

.exportzp update
update:     .res 2

.exportzp updatePPU
updatePPU:  .res 2

.exportzp stateControl
stateControl: .res 16

.exportzp nomolosX
nomolosX: .res 3  ;24 bit x (16 bit coord + 8 bit fine movement)

.exportzp nomolosY
nomolosY: .res 3  ;24 bit y (16 bit coord + 8 bit fine movement)

.exportzp nomolosXSpeed
nomolosXSpeed: .res 2

.exportzp nomolosYSpeed
nomolosYSpeed: .res 2

.exportzp nomolosScreenX
nomolosScreenX: .res 2

.exportzp nomolosScreenY
nomolosScreenY: .res 2

.exportzp nomolosHitboxX
nomolosHitboxX: .res 2

.exportzp nomolosHitboxY
nomolosHitboxY: .res 2

.exportzp nomolosHitboxWidth
nomolosHitboxWidth: .res 1

.exportzp nomolosHitboxHeight
nomolosHitboxHeight: .res 1

.exportzp nomolosScaredyCatX
nomolosScaredyCatX: .res 2

.exportzp nomolosScaredyCatY
nomolosScaredyCatY: .res 2

.exportzp nomolosBelowPenetrationDistance
nomolosBelowPenetrationDistance: .res 1

.exportzp nomolosAbovePenetrationDistance
nomolosAbovePenetrationDistance: .res 1

.exportzp nomolosAnim
nomolosAnim: .res 2

.exportzp nomolosWeaponAnim
nomolosWeaponAnim: .res 2

.exportzp nomolosBlinkCounter
nomolosBlinkCounter: .res 1

.exportzp nomolosHitboxCounter
nomolosHitboxCounter: .res 1

.exportzp nomolosState
nomolosState: .res 1

.exportzp nomolosSubState
nomolosSubState: .res 1

.exportzp nomolosHealth
nomolosHealth: .res 1

.exportzp nomolosLives
nomolosLives: .res 1

.exportzp scrollX
scrollX:                           .res 2

.exportzp nextScrollX
nextScrollX:                       .res 2

.exportzp levelBaseAddress
levelBaseAddress:                  .res 2

.exportzp metametaTileTableBaseAddress
metametaTileTableBaseAddress:      .res 2

.exportzp metaTileTableBaseAddress
metaTileTableBaseAddress:          .res 2

.exportzp entityDefinitionTableBaseAddress
entityDefinitionTableBaseAddress:  .res 2

.exportzp romDefinitionTableBaseAddress
romDefinitionTableBaseAddress: .res 2

.exportzp currentLevel
currentLevel:                      .res 1

.exportzp attributeBuffer
attributeBuffer: .res 8

.exportzp attributeColumnToUpdate
attributeColumnToUpdate: .res 1

.exportzp columnTileBuffer
columnTileBuffer:  .res 60

.exportzp metaTileBuffer
metaTileBuffer:    .res 4

.exportzp columnToUpdate
columnToUpdate:    .res 1

.exportzp nametableToUpdate
nametableToUpdate: .res 1

.exportzp spriteAddress
spriteAddress: .res 1

.exportzp controllerBuffer
controllerBuffer: .res 8

.exportzp soundAddr
soundAddr: .res 2

.exportzp soundOff
soundOff: .res 1

.exportzp ft_music_addr
ft_music_addr: .res 2

;variables specific to level out state
.exportzp paletteStep
paletteStep: .res 1

.exportzp frameCounter
frameCounter: .res 1
