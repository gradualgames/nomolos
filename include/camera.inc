.ifndef CAMERA_INC
CAMERA_INC = 1

.include "nomolos_logic.inc"

.global camera_to_screen_coords
.global camera_reset
.global camera_scroll_right
.global camera_scroll_left

scrollReactRight = 128-(nomolos_width>>1)
scrollReactLeft = 128-(nomolos_width>>1)

.endif
