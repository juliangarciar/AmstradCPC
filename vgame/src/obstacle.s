.area _DATA
posX_1: .db #16
posY_1: .db #152
sizeX_1: .db #0x04
sizeY_1: .db #0x10

posX_2: .db #50
posY_2: .db #152
sizeX_2: .db #0x04
sizeY_2: .db #0x10

posX_3: .db #33
posY_3: .db #140
sizeX_3: .db #0x04
sizeY_3: .db #0x10

color: .db #0xFF
.area _CODE
.include "cpctelera.h.s"

drawObstacles::
		ld 		de, #0xC000
		ld 		a, (posX_1)
		ld 		c, a 		; b = hero_X

		ld 		a, (posY_1)
		ld 		b, a 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm

		ex 		de, hl 		;HL holds the screen pointer, so we swap it with de for fast change
		ld 		bc, #0x1004	;heigh: 8x8 pixels on mode 1 (2 bytes every 4 pixels)
		ld 		a, (color)
		call 	cpct_drawSolidBox_asm ;draw box itself

		ld 		de, #0xC000
		ld 		a, (posX_2)
		ld 		c, a 		; b = hero_X

		ld 		a, (posY_2)
		ld 		b, a 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm

		ex 		de, hl 		;HL holds the screen pointer, so we swap it with de for fast change
		ld 		bc, #0x1004	;heigh: 8x8 pixels on mode 1 (2 bytes every 4 pixels)
		ld 		a, (color)
		call 	cpct_drawSolidBox_asm ;draw box itself

		ld 		de, #0xC000
		ld 		a, (posX_3)
		ld 		c, a 		; b = hero_X

		ld 		a, (posY_3)
		ld 		b, a 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm

		ex 		de, hl 		;HL holds the screen pointer, so we swap it with de for fast change
		ld 		bc, #0x1004	;heigh: 8x8 pixels on mode 1 (2 bytes every 4 pixels)
		ld 		a, (color)
		call 	cpct_drawSolidBox_asm ;draw box itself

	ret

getObstaclePtr::
		ld 		hl, #posX_1
	ret