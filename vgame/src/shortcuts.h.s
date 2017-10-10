.equ	hero_x, 0
.equ	hero_y, 1
.equ	hero_w, 2
.equ	hero_h, 3
.equ	hero_j, 4

.equ	obs_x, 0
.equ	obs_y, 1
.equ	obs_w, 2
.equ	obs_h, 3

.macro defineHero name, x, y, w, h 
	name'_data:
		name'X: 	.db x
		name'Y: 	.db y
		name'W: 	.db w
		name'H: 	.db h
		name'J:		.db #-1
.endm

.macro defineObs name, x, y, w, h 
	name'_data:
		name'X: 	.db x
		name'Y: 	.db y
		name'W: 	.db w
		name'H: 	.db h
.endm

