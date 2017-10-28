;==========================================
; 	HERO CREATION
;
;	VARIABLES:
;		x -> OX
;		y -> OY
;		w -> WIDTH
;		h -> HEIGHT
; 	*name -> define a name for this entity
;==========================================
.macro defineHero name, x, y, w, h
	name'_data:
		name'X: 	.db x
		name'Y: 	.db y
		name'W: 	.db w
		name'H: 	.db h
		name'Spr: 	.db #0
		name'SX: 	.db x
		name'SY: 	.db y
.endm
	.equ	hero_x, 0
	.equ	hero_y, 1
	.equ	hero_w, 2
	.equ	hero_h, 3
	.equ 	hero_sprite, 4
	.equ 	hero_SX, 5
	.equ 	hero_SY, 6
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
;==========================================
.macro defineShot name, w, h, l
	name'_data:
		name'X: 	.db #0
		name'Y: 	.db #0
		name'W: 	.db w
		name'H: 	.db h
		name'Spr: 	.db #0
		name'A:	    .db #0
		name'Last: 	.db l
		name'SX: 	.db #0
		name'SY: 	.db #0
.endm
	.equ	shot_x, 0
	.equ	shot_y, 1
	.equ	shot_w, 2
	.equ	shot_h, 3
	.equ 	shot_sprite, 4
	.equ	shot_alive, 5
	.equ 	shot_last, 6
	.equ 	shot_SX, 7
	.equ 	shot_SY, 8
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
;==========================================
;.macro defineObs name, x, y, w, h, l
;	name'_data:
;		name'X: 	.db x
;		name'Y: 	.db y
;		name'W: 	.db w
;		name'H: 	.db h
;		name'L:		.db l
;.endm
	.equ	obs_x, 0
	.equ	obs_y, 1
	.equ	obs_w, 2
	.equ	obs_h, 3
	.equ 	obs_alive, 5
	.equ 	obs_l, 6
;==========================================
; 	ENEMY CREATION
;
;	VARIABLES:
;		x -> OX
;		y -> OY
;		w -> WIDTH
;		h -> HEIGHT
;		d -> DEFINE IF IT'S THE DIR
;		c -> DEFINE ITS COLOUR
;		a -> DEFINE IF IT'S ACTIVE
; 			== 1 -> YES
;			== 0 -> NO
;		t -> TIPE
;			== 0 -> TERRESTRE
;			== 1 -> VOLADOR
;		l -> DEFINE IF IT'S THE LAST ONE
; 			== 1 -> NO
;			== 0 -> YES
; 	*name -> define a name for this entity
;==========================================
.macro defineEnemy name, w, h, l
	name'_data:
		name'X: 	.db #0
		name'Y: 	.db #0
		name'W: 	.db w
		name'H: 	.db h
		name'Spr: 	.db #0
		name'A:	    .db #0
		name'Last: 	.db l
		name'SX: 	.db #0
		name'SY: 	.db #0
		
.endm
;MODIFICAR
	.equ	enemy_x, 0
	.equ	enemy_y, 1
	.equ	enemy_w, 2
	.equ	enemy_h, 3
	.equ 	enemy_sprite, 4
	.equ	enemy_alive, 5
	.equ 	enemy_last, 6
	.equ 	enemy_SX, 7
	.equ 	enemy_SY, 8
	
;==========================================
; 	SPRITE HERO
;
;	VARIABLES:
;		x -> OX
;		y -> OY
;		w -> WIDTH
;		h -> HEIGHT
; 	*name -> define a name for this entity
;==========================================
;.macro defineSprite name
;	name'_data:
;		name'_sprite_normal:	.dw _sprite_hero1
;		name'_sprite_right:		.dw _sprite_hero2
;		name'_sprite_left:		.dw _sprite_hero3
;		name'_pos: 				.db #0
;.endm
;	.equ	sprite_1, 0
;	.equ	sprite_2, 1
;	.equ	sprite_3, 2
;	.equ 	sprite_pos, 3
;=========================================
; 	USEFULL MACROS
;=========================================
;==========================================
; 	DESCRIPTION: Load data to 'D'
;	DESTROYS: A, D
;	VARIABLES:
;		x -> Data to save
;==========================================
.macro saveD x
	ld 		a, x
	ld 		d, a
.endm
;==========================================
; 	DESCRIPTION: Load data to 'C'
;	DESTROYS: A, C
;	VARIABLES:
;		x -> Data to save
;==========================================
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
