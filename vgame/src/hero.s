.area _DATA
	;==================
	; HERO DATA
	;==================
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "collision.h.s"
.include "buffer.h.s"
.include "control.h.s"
.globl	_sprite_hero11
.globl	_sprite_hero12

defineHero 	hero, 0, 160, 8, 16

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
		ld 		a, (buffer_start)
		ld 		d, a
		ld 		e, #0x00

		ld 		c, hero_x(ix) 			; b = hero_X
		ld 		b, hero_y(ix) 			; c = hero_y
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 					;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		a, hero_sprite(ix)		;Load the sprite to load
		cp 		#0
		jr 		z, drawHero1
			cp 		#1
			jr 		z, drawHero2

		drawHero1:
			ld 		hl, #_sprite_hero11
			jp 		continue
		drawHero2:
			ld 		hl, #_sprite_hero12
		continue:
		ld 		b, hero_h(ix)
		ld 		c, hero_w(ix)

		call 	cpct_drawSprite_asm 
	ret

	;==================
	;   BORRAR HEROE
	;==================	
eraseHero::
		ld 		ix, #hero_data 		;Load hero data
		ld 		a, (buffer_start)
		ld 		d, a
		ld 		e, #0x00
		continueErase:
		
		
		ld 		c, hero_SX(ix) 		; b = hero_X
		ld 		b, hero_SY(ix) 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm
		ex 		de, hl 

		
		ld 		b, hero_h(ix)
		ld 		c, hero_w(ix)


		ld 		a, #0x00
		call 	cpct_drawSolidBox_asm

	ret
updateHero::
		ld 		ix, #hero_data
		call 	checkCollision
		ld 		a, hero_sprite(ix)
		cp 		#1
		jr 		z, swapHeroSprite
			inc 	enemy_sprite(ix)
			jr 		quitUpdateHero
		swapHeroSprite:
		ld 		a, #0
		ld 		hero_sprite(ix), a
	quitUpdateHero:
	ld 		a, hero_x(ix)
	ld 		hero_SX(ix), a
	ld 		a, hero_y(ix)
	ld 		hero_SY(ix), a
	ret
heroPtrX::
		ld 		ix, #hero_data
	ret
heroPtrY::
		ld 		iy, #hero_data
	ret

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