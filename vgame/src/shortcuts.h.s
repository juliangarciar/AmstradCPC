;==========================================
; 	HERO CREATION
;
;	VARIABLES:
;		x -> OX
;		y -> OY
;		w -> WIDTH
;		h -> HEIGHT
; 	*name -> define a name for this entity
;===========================================
.macro defineHero name, x, y, w, h, sy
	name'_data:
		name'X: 	.db x
		name'Y: 	.db y
		name'W: 	.db w
		name'H: 	.db h
		name'J:		.db #-1
		name'SY: 	.db sy 
		name'SH: 	.db #1
.endm
	.equ	hero_x, 0
	.equ	hero_y, 1
	.equ	hero_w, 2
	.equ	hero_h, 3
	.equ	hero_j, 4
	.equ 	hero_special_y, 5
	.equ 	hero_special_h, 6
;==========================================
; 	SHOT CREATION
;
;	VARIABLES:
;		x -> OX
;		y -> OY
;		h -> ALIVE
;		h -> BALE_DIR
;		
; 	*name -> define a name for this entity
;===========================================
.macro defineBale name, x, y, a, bd
	name'_data:
		name'X: 	.db x
		name'Y: 	.db y
		name'A:	    .db a
		name'BD: 	.db bd
.endm
	.equ	bale_x, 0
	.equ	bale_y, 1
	.equ	bale_a, 2
	.equ 	bale_bd, 3
;==========================================
; 	OBSTACLE CREATION
;
;	VARIABLES:
;		x -> OX
;		y -> OY
;		w -> WIDTH
;		h -> HEIGHT
;		L -> DEFINE IF IT'S THE LAST ONE 
; 			== 1 -> NO
;			== 0 -> YES
; 	*name -> define a name for this entity
;===========================================
.macro defineObs name, x, y, w, h, l
	name'_data:
		name'X: 	.db x
		name'Y: 	.db y
		name'W: 	.db w
		name'H: 	.db h
		name'L:		.db l
.endm
	.equ	obs_x, 0
	.equ	obs_y, 1
	.equ	obs_w, 2
	.equ	obs_h, 3
	.equ 	obs_l, 4
;==========================================
; 	ENEMY CREATION
;
;	VARIABLES:
;		x -> OX
;		y -> OY
;		w -> WIDTH
;		h -> HEIGHT
;		d -> DEFINE IF IT'S THE LAST ONE 
;		c -> DEFINE ITS COLOUR
;		a -> DEFINE IF IT'S ACTIVE
; 			== 1 -> NO
;			== 0 -> YES
; 	*name -> define a name for this entity
;===========================================
.macro defineEnemy name, x, y, w, h, d, c, a
	name'_data:
		name'X: 	.db x
		name'Y: 	.db y
		name'W: 	.db w
		name'H: 	.db h
		name'D: 	.db d
		name'C:		.db c
		name'A:		.db a
.endm
	.equ	enemy_x, 0
	.equ	enemy_y, 1
	.equ	enemy_w, 2
	.equ	enemy_h, 3
	.equ	enemy_d, 4
	.equ	enemy_c, 5
	.equ	enemy_a, 6
;==========================================
; 	SPRITE HERO
;
;	VARIABLES:
;		x -> OX
;		y -> OY
;		w -> WIDTH
;		h -> HEIGHT
; 	*name -> define a name for this entity
;===========================================
.macro defineSprite name
	name'_data:
		name'_sprite_normal:	.dw _sprite_hero1
		name'_sprite_right:		.dw _sprite_hero2
		name'_sprite_left:		.dw _sprite_hero3
		name'_pos: 				.db #0
.endm
	.equ	sprite_1, 0
	.equ	sprite_2, 1
	.equ	sprite_3, 2
	.equ 	sprite_pos, 3
;=========================================
; 	USEFULL MACROS
;=========================================
;==========================================
; 	DESCRIPTION: Load data to 'D'
;	DESTROYS: A, D
;	VARIABLES:
;		x -> Data to save
;===========================================
.macro saveD x
	ld 		a, x
	ld 		d, a
.endm
;==========================================
; 	DESCRIPTION: Load data to 'C'
;	DESTROYS: A, C
;	VARIABLES:
;		x -> Data to save
;===========================================
.macro saveC x
	ld 		a, x
	ld 		c, a
.endm
;=========================================
; 	ADVANCED MACROS
;
;=========================================

;=========================================
; 	ULTRA ADVANCED MACROS
;	
;=========================================
