.area _DATA
	;==================
	; HERO DATA
	;==================
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "collision.h.s"

.globl	_sprite_hero1
.globl	_sprite_hero2
.globl	_sprite_hero3

.globl  _sprite_mierda
.globl  _sprite_astro
defineHero 	hero, 0, 160, 3, 15

;==================
;	Jump Table
;==================
;jumptable::	.db	#-20, #-18, #-16, #-5, #-4, #-3, #-2		;datos para rellenar la tabla
;			.db #-1, #00, #00, #00
;			.db	#0x80 					;para marcar el final

.area _CODE
	;==================
	; 	HERO_CODE
	;==================
	;==================
	;   DIBUJA HEROE
	;==================
drawHero::
		ld 		ix, #hero_data			;Load hero data
		ld 		de, #0xC000				;beginning of screen

		ld 		c, hero_x(ix) 			; b = hero_X
		ld 		b, hero_y(ix) 			; c = hero_y
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register

		ex 		de, hl 					;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		a, hero_sprite(ix)		;Load the sprite to load
		cp 		#0
		jr 		z, norm
			cp 		#1
			jr 		z, up
				cp 		#2
				jr 		z, down
		up:
			ld 		hl, #_sprite_hero3
			jp 		continue
		down:
			ld 		hl, #_sprite_hero2
			jp 		continue
		norm:
			;ld 		hl, #_sprite_hero1
			ld 		hl, #_sprite_hero1
		continue:
		ld 		a, hero_h(ix)
		inc 	a
		ld 		b, a

		ld 		a, hero_w(ix)
		inc 	a
		ld 		c, a

		call 	cpct_drawSprite_asm 
	ret

	;==================
	;   BORRAR HEROE
	;==================	
eraseHero::
		ld 		ix, #hero_data 		;Load hero data
		ld 		de, #0xC000			;beginning of screen

		ld 		c, hero_x(ix) 		; b = hero_X
		ld 		b, hero_y(ix) 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm
		ex 		de, hl 

		ld 		a, hero_h(ix)
		inc 	a
		ld 		b, a

		ld 		a, hero_w(ix)
		inc 	a
		ld 		c, a

		ld 		a, #0x00
		call 	cpct_drawSolidBox_asm

	ret
updateHero::
		ld 		ix, #hero_data
		call 	checkCollision
	ret
heroPtrX::
		ld 		ix, #hero_data
	ret
heroPtrY::
		ld 		iy, #hero_data
	ret
;spritePtr::
;		ld 		iy, #char_data
;	ret
;
;==================
;   GRAVEDAD
; 	
;==================	
;updateHero::
;		call 	heroPtr
;		inc 	hero_y(ix)
;		inc 	hero_special_y(ix)
;
;			call 	jumpCollision
;			cp 		#1
;			;COLISIONA
;			jr 		z, end
;
;				inc 	hero_y(ix)
;				inc 	hero_special_y(ix)
;
;				call 	jumpCollision
;				cp 		#1
;
;				jr 		z, end
;		
;				ret
;	end:
;		;REINICIAR SALTO
;		;ld 		hero_j(ix), #-1
;		dec 	hero_y(ix)
;		dec 	hero_special_y(ix)
;	ret