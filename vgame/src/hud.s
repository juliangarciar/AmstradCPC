.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "hero.h.s"

.globl _sprite_bomb
backgroundColor: 	.db #0
characterColor:		.db #15
lifes: 				.db #3
bombs: 				.db #1
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
		;END DRAW
		;DRAW NUMBERS
		call 	updateLifes
		call 	updateBomb
		;END
	ret

updateLifes::
		call 	heroPtrX
		ld 		a, hero_lives(ix)
		cp 		#3
		jr 		z, draw3L
			cp 		#2
			jr 		z, draw2L
				cp 		#1
				jr 		z, draw1L
					cp 		#0
					jr 		z, draw0L
		draw3L:
			ld 		a, #51
			ld 		(lifes), a
			jr 		continueUpdateLifes
		draw2L:
			ld 		a, #50
			ld 		(lifes), a
			jr 		continueUpdateLifes
		draw1L:
			ld 		a, #49
			ld 		(lifes), a
			jr 		continueUpdateLifes
		draw0L:
			ld 		a, #48
			ld 		(lifes), a
		continueUpdateLifes:
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
updateBomb::
		call 	heroPtrX
		ld 		a, hero_bombs(ix)
		cp 		#0
		jr 		z, draw0B
			cp 		#1
			jr 		z, draw1B
				cp 		#2
				jr 		z, draw2B
					cp 		#3
					jr 		z, draw3B
		draw3B:
			ld 		a, #51
			ld 		(bombs), a
			jr 		continueUpdateBombs
		draw2B:
			ld 		a, #50
			ld 		(bombs), a
			jr 		continueUpdateBombs
		draw1B:
			ld 		a, #49
			ld 		(bombs), a
			jr 		continueUpdateBombs
		draw0B:
			ld 		a, #48
			ld 		(bombs), a
		continueUpdateBombs:
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
updateScore::
	ret