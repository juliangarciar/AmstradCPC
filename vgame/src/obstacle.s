.area _DATA
	;==================
	; OBS DATA
	;==================
.include "shortcuts.h.s"
.include "cpctelera.h.s"

defineObs	obj1, 15, 130, 7, 2, 1
defineObs	obj2, 58, 130, 7, 2, 1
defineObs	obj3, 37, 115, 7, 2, 1
defineObs	obj4, 0, 183, 40, 7, 1
defineObs	obj5, 40, 183, 39, 7, 0
color: 		.db #0xF0

.area _CODE
	;==================
	; OBS CODE
	;==================
	;======================
	;   DIBUJAR OBSTACULOS
	;======================
drawObstacles::
	call 	obsPtr
	drawBucle:
		ld 		de, #0xC000
		ld 		c, obs_x(iy) 		; b = hero_X
		ld 		b, obs_y(iy) 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm

		ex 		de, hl 		;HL holds the screen pointer, so we swap it with de for fast change
		
		ld 		a, obs_h(iy)
		inc 	a
		ld 		b, a
		
		ld 		a, obs_w(iy)
		inc 	a
		ld 		c, a
		;heigh: 8x8 pixels on mode 1 (2 bytes every 4 pixels)
		ld 		a, (color)
		call 	cpct_drawSolidBox_asm ;draw box itself
		;EVALUA SI TERMINA EL BUCLE O NO
		ld 		a, obs_l(iy)
		cp 		#1
		jr 		z, redo
	ret
	;SALTA AL SIGUIENTE OBJETO
	redo:
		ld 		de, #5
		add 	iy, de
		jr 		drawBucle
;DEVUELVE UN PUNTERO AL OBJ AL QUE APUNTA ACTUALMENTE
obsPtr::
	ld 		iy, #obj1_data
ret