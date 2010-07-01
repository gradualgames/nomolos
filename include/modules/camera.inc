.ifndef CAMERA_INC
CAMERA_INC = 1

.include "nomolosLogic.inc"

.global camera_to_screen_coords
.global camera_reset
.global camera_scroll_right
.global camera_scroll_left

scrollReactRight = 128-(nomolosWidth>>1)
scrollReactLeft = 128-(nomolosWidth>>1)

.endif
