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
defineHero 	hero, 0, 160, 3, 15, 175
defineSprite char

;color:		.db #0xFF
	;==================
	;	Jump Table
	;==================
jumptable::	.db	#-20, #-18, #-16, #-5, #-4, #-3, #-2		;datos para rellenar la tabla
			.db #-1, #00, #00, #00
			.db	#0x80 					;para marcar el final

.area _CODE
	;==================
	; 	HERO_CODE
	;==================
	;==================
	;   DIBUJA HEROE
	;==================
draw_hero::
		call 	heroPtr
		

		ld 		de, #0xC000	;beginning of screen

		ld 		c, hero_x(ix) 		; b = hero_X
		ld 		b, hero_y(ix) 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register

		ex 		de, hl 		;HL holds the screen pointer, so we swap it with de for fast change
		
		call 	spritePtr
		ld 		a, sprite_pos(iy)
		cp 		#0
		jr 		z, norm
			cp 		#1
			jr 		z, der
				cp 		#1
				jr 		z, izq
		izq:
			ld 		hl, #_sprite_hero3
			;inc 	hl
			jp 		jump
		der:
			ld 		hl, #_sprite_hero2
			;inc 	hl
			jp 		jump
		norm:
			ld 		hl, #_sprite_hero1
		
		;ALTERAR LA FORMA DE PASAR H Y W, PERO SIN CAGAR COLIS
		jump:
		ld 		a, hero_h(ix)
		inc 	a
		ld 		b, a

		ld 		a, hero_w(ix)
		inc 	a
		ld 		c, a
		;ld 		bc, #0x2010	;heigh: 8x8 pixels on mode 1 (2 bytes every 4 pixels)
		;ld 		a, (color)
		call 	cpct_drawSprite_asm ;draw box itself
	ret

	;==================
	;   BORRAR HEROE
	;==================	
erase_hero::
		call 	heroPtr
		ld 		de, #0xC000	;beginning of screen

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
heroPtr::
		ld 		ix, #hero_data
	ret
spritePtr::
		ld 		iy, #char_data
	ret

;==================
;   GRAVEDAD
; 	
;==================	
updateHero::
		call 	heroPtr
		inc 	hero_y(ix)
		inc 	hero_special_y(ix)
		;ld 		a, hero_y(ix)
		;cp 		#168
		;jr 		z, end
		;jp 		pe, end
			ld 		a, #1
			call 	checkCollision
			cp 		#1
			;COLISIONA
			jr 		z, end

				inc 	hero_y(ix)
				inc 	hero_special_y(ix)

				ld 		a, #1
				call 	checkCollision
				cp 		#1

				jr 		z, end
		
				ret
	end:
		;REINICIAR SALTO
		;ld 		hero_j(ix), #-1
		dec 	hero_y(ix)
		dec 	hero_special_y(ix)
	ret