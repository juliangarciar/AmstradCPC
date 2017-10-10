.area _DATA
.include "shortcuts.h.s"
	;==================
	;;;PRIVATE DATA
	;==================
color: .db #0xFF
;.equ	hero_x, 0
;.equ	hero_y, 1
;.equ	hero_w, 2
;.equ	hero_h, 3
;.equ	hero_j, 4
	;;Hero Data
defineHero hero, 0, 160, 3, 15
;hero_data:		
;	heroX: 	.db #0 
;	heroY: 	.db #160
;	heroW: 	.db #0x03
;	heroH: 	.db #0x0F
;	heroJ: 	.db #-1
	;==================
	;;;PUBLIC DATA
	;==================
	;;Jump Table
jumptable::	.db	#-8, #-7, #-6, #-5, #-4, #-3, #-2		;datos para rellenar la tabla
			.db #-1, #00, #00, #00
			;.db	#01, #02, #03, #04, #05, #06, #07, #08
			.db	#0x80 					;para marcar el final

.area _CODE

.include "cpctelera.h.s"


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
		;ALTERAR LA FORMA DE PASAR H Y W, PERO SIN CAGAR COLIS
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

	;==================
	;   GRAVEDAD
	;==================	
gravityHero::

	ret