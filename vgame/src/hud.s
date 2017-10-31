.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "hero.h.s"
.include "mainMode.h.s"
.include "buffer.h.s"
.include "enemy.h.s"

.globl _sprite_bomb
.globl _sprite_outEnemy
.globl _sprite_gameover

backgroundColor: 	.db #0
characterColor:		.db #15
lifes: 				.db #4
bombs: 				.db #1
leaks: 				.db #0
.area _CODE

initHUD::
		;DRAW BOMB ICON ON BOTH SCREENS
		ld 		d, #0xC0
		ld 		e, #0x00

		ld 		a, #22
		ld 		c, a
		ld 		a, #200-30			
		ld 		b, a			
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 					;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		hl, #_sprite_bomb

		ld 		a, #16
		ld 		b, a
		ld 		a, #8
		ld 		c, a

		call 	cpct_drawSprite_asm 

		ld 		d, #0x80
		ld 		e, #0x00

		ld 		a, #22
		ld 		c, a
		ld 		a, #200-30 			
		ld 		b, a			
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 					;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		hl, #_sprite_bomb
		
		ld 		a, #16
		ld 		b, a
		ld 		a, #8
		ld 		c, a

		call 	cpct_drawSprite_asm 
		;END
		;DRAW HERO ICON ON BOTH SCREENS
		call 	heroPtrX
		ld 		d, #0xC0
		ld 		e, #0x00

		ld 		a, #4
		ld 		c, a
		ld 		a, #200-28			
		ld 		b, a			
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 					;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		hl, #_sprite_hero11
		
		ld 		b, hero_h(ix)
		ld 		c, hero_w(ix)

		call 	cpct_drawSprite_asm 

		ld 		d, #0x80
		ld 		e, #0x00

		ld 		a, #4
		ld 		c, a
		ld 		a, #200-28 			
		ld 		b, a			
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 					;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		hl, #_sprite_hero11
		
		ld 		b, hero_h(ix)
		ld 		c, hero_w(ix)

		call 	cpct_drawSprite_asm 
		;END DRAW
		;DRAW OUT ICON ON BOTH SCREENS
		ld 		d, #0xC0
		ld 		e, #0x00

		ld 		a, #39
		ld 		c, a
		ld 		a, #200-28			
		ld 		b, a			
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 					;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		hl, #_sprite_outEnemy
		
		ld 		b, hero_h(ix)
		ld 		c, hero_w(ix)

		call 	cpct_drawSprite_asm 

		ld 		d, #0x80
		ld 		e, #0x00

		ld 		a, #39
		ld 		c, a
		ld 		a, #200-28 			
		ld 		b, a			
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 					;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		hl, #_sprite_outEnemy
		
		ld 		b, hero_h(ix)
		ld 		c, hero_w(ix)

		call 	cpct_drawSprite_asm 
		;END DRAW

		;DRAW X ON BOTH SCREENS
		ld 		de, #0xC000
		ld 		a, #12
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, #120
		call 	cpct_drawCharM0_asm

		ld 		de, #0x8000
		ld 		a, #12
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, #120
		call 	cpct_drawCharM0_asm

		ld 		de, #0xC000
		ld 		a, #30
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, #120
		call 	cpct_drawCharM0_asm

		ld 		de, #0x8000
		ld 		a, #30
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, #120
		call 	cpct_drawCharM0_asm

		ld 		de, #0xC000
		ld 		a, #48
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, #120
		call 	cpct_drawCharM0_asm

		ld 		de, #0x8000
		ld 		a, #48
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, #120
		call 	cpct_drawCharM0_asm
		;END DRAW
		;DRAW NUMBERS
		call 	heroPtrX
		ld 		a, hero_lives(ix)
		ld 		(lifes), a
		ld 		a, hero_bombs(ix)
		ld 		(bombs), a
		call 	updateLifes
		call 	updateBomb
		call 	updateLeaks
		;END
	ret

updateLifes::
		call 	heroPtrX
		ld 		a, #48
		ld 		b, a
		ld  	a, hero_lives(ix)
		ld 		(lifes), a
		cp 		#0
		jp 		z, 	gameOver
			;jp 	gameOver
		continueUpdateLifes:
		ld 		a, #48
		ld 		b, a
		ld  	a, hero_lives(ix)
		add 	a, b
		ld 		(lifes), a
		ld 		de, #0x8000
		ld 		a, #16
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, (lifes)
		call 	cpct_drawCharM0_asm

		ld 		de, #0xC000
		ld 		a, #16
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, (lifes)
		call 	cpct_drawCharM0_asm
	ret
updateLeaks::
		ld 		a, #48
		ld 		b, a
		ld 		a, (totalLeaks)
		ld 		(leaks), a
		cp 		#0
		jr 		nz, continueUpdateLeaks
			jp 	gameOver
		continueUpdateLeaks:
		add 	a, b
		ld 		(leaks), a

		ld 		de, #0x8000
		ld 		a, #52
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, (leaks)
		call 	cpct_drawCharM0_asm

		ld 		de, #0xC000
		ld 		a, #52
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, (leaks)
		call 	cpct_drawCharM0_asm
	ret
updateBomb::
		call 	heroPtrX
		ld 		a, #48
		ld 		b, a
		ld 		a, hero_bombs(ix)
		add 	a, b
		ld 		(bombs), a

		ld 		de, #0x8000
		ld 		a, #34
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, (bombs)
		call 	cpct_drawCharM0_asm

		ld 		de, #0xC000
		ld 		a, #34
		ld 		c, a
		ld 		a, #200-24			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		a, (characterColor)
		ld 		c, a
		ld 		a, (backgroundColor)
		ld 		b, a
		ld 		a, (bombs)
		call 	cpct_drawCharM0_asm
	ret
gameOver:
	call 	killAll

		;LIMPIAR PUTA PANTALLA
		ld 		hl, #0xC000
		working:
		ld 		a, #0x00
		ld 		(hl), a
		inc 	hl
		ld 		a, h
		cp 	 	#0xFF
		jr 		nz, working
		ld 		a, l
		cp  	#0xFF
		jr 		nz, working

		ld 		hl, #0x8000
		working2:
		ld 		a, #0x00
		ld 		(hl), a
		inc 	hl
		ld 		a, h
		cp 	#0xC0
		jr 		nz, working2
		ld 		a, l
		cp 	#0x00
		jr 		nz, working2
		;call 	loadHud
		;jr 		_main_bucle
		;ret
	;ld 		a, (buffer_start)
	ld 		d, #0xC0
	ld 		e, #0x00
		ld 		a, #24
		ld 		c, a
		ld 		a, #68		
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		hl, #_sprite_gameover
		ld 		a, #64
		ld 		b, a
		ld 		a, #32
		ld 		c, a

		call 	cpct_drawSprite_asm 

	;ld 		a, (buffer_start)
	ld 		d, #0x80
	ld 		e, #0x00
		ld 		a, #24
		ld 		c, a
		ld 		a, #68			
		ld 		b, a
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register
		ex 		de, hl 
		ld 		hl, #_sprite_gameover
		ld 		a, #64
		ld 		b, a
		ld 		a, #32
		ld 		c, a

		call 	cpct_drawSprite_asm 

		ld 		a, #3
		ld 		(gameMode), a
		infinite:
		jr 		infinite
ret