.area _DATA
	;==================
	;;;PRIVATE DATA
	;==================
color: .db #0xFF
	;==================
	;;;PUBLIC DATA
	;==================

	;;Hero Data
hero_data:		.db #0, #160, #0x03, #0x0F, #-1

	;;Jump Table
jumptable::	.db	#-8, #-7, #-6, #-5, #-4, #-3, #-2		;datos para rellenar la tabla
			.db #-1, #00, #00, #00
			.db	#01, #02, #03, #04, #05, #06, #07, #08
			.db	#0x80 					;para marcar el final


.area _CODE

.include "cpctelera.h.s"


	;==================
	;   DIBUJA HEROE
	;==================

draw_hero::
		call 	heroPtr
		ld 		de, #0xC000	;beginning of screen

		ld 		a, 0(ix)
		ld 		c, a 		; b = hero_X

		ld 		a, 1(ix)
		ld 		b, a 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register

		ex 		de, hl 		;HL holds the screen pointer, so we swap it with de for fast change
		ld 		bc, #0x1004	;heigh: 8x8 pixels on mode 1 (2 bytes every 4 pixels)
		ld 		a, (color)
		call 	cpct_drawSolidBox_asm ;draw box itself
	ret


	;==================
	;   BORRAR HEROE
	;==================	

erase_hero::
		ld 		a, #0x00
		ld 		(color), a
		call 	draw_hero
		ld 		a, #0xFF
		ld		(color), a
	ret
heroPtr::
		ld 		ix, #hero_data
	ret
