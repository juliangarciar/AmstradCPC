.area _DATA
	;==================
	; OBS DATA
	;==================
	obj1: 	.db #12, #160, #0x03, #0x0F

posX_2: .db #50
posY_2: .db #152
sizeX_2: .db #0x04
sizeY_2: .db #0x10

posX_3: .db #33
posY_3: .db #140
sizeX_3: .db #0x04
sizeY_3: .db #0x10

color: .db #0xF0
.area _CODE
.include "cpctelera.h.s"

drawObstacles::
	call obsPtr
	ld 		de, #0xC000
	ld 		a, 0(iy)
	ld 		c, a 		; b = hero_X

	ld 		a, 1(iy)
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

obsPtr::
		ld 		iy, #obj1
	ret