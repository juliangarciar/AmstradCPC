.area _DATA
	;==================
	; HERO DATA
	;==================
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "collision.h.s"
.include "buffer.h.s"
.include "control.h.s"
.include "hero.h.s"
.include "hud.h.s"

defineHero 	hero, 10, 100, 8, 16

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
		cp 		#0
		jr 		z, continueUpdateHero
			ld 		a, hero_lives(ix)
			cp 		#0
			jr 		z, gameOver
			dec 	hero_lives(ix)
			call 	updateLifes
		continueUpdateHero:
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

gameOver:
	ld 		hl, (#0x004)
	jp 		(hl)
	ret