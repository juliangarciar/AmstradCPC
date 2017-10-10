.area _DATA
.include "shortcuts.h.s"
	;==================
	; OBS DATA
	;==================
obj1_data: 		
	obj1_x: 	.db #12
	obj1_y: 	.db #160
	obj1_w: 	.db #3
	obj1_h: 	.db #15

obj2_data:		
	obj2_x: 	.db #50
	obj2_y: 	.db #152
	obj2_w: 	.db #3
	obj2_h: 	.db #15

obj3_data: 		
	obj3_x: 	.db #33
	obj3_y: 	.db #140
	obj3_w: 	.db #3
	obj3_h: 	.db #15

obs_n:: 		.db #0x03
actual_ptr::	.db #0x00
color: 			.db #0xF0
.area _CODE
.include "cpctelera.h.s"

drawObstacles::
	drawBucle:
		call obsPtr

		;PINTA EL OBSTACULO
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
		;EVALUA SI TERMINA EL BUCLE O NO
		ld 		a, (obs_n)
		cp 		#1

		jr 		nz, redo
		;TERMINA EL BUCLE Y REASIGNA EL VALOR DE N_OBS Y EL PUNTERO
			ld 		a, #3
			ld 		(obs_n), a
			ld 		a, #0
			ld 		(actual_ptr), a 
	ret

	;REASIGNA EL PUNTERO
	redo:
		ld 		a, (obs_n)
		dec 	a
		ld 		(obs_n), a

		call 	obsPtrNext
	jr		drawBucle
;DEVUELVE UN PUNTERO AL OBJ AL QUE APUNTA ACTUALMENTE
obsPtr::
		ld 		a, (actual_ptr)
		cp 		#0
		jr		z, ld1
			ld 		a, (actual_ptr)
			cp 		#1
			jr		z, ld2
				ld 		a, (actual_ptr)
				cp 		#2
				jr		z, ld3

	ld1:
		ld 		iy, #obj1_data
	ret
	ld2:
		ld 		iy, #obj2_data
	ret
	ld3:
		ld 		iy, #obj3_data
	ret
;REASIGNA EL VALOR DEL OBJETO AL QUE APUNTA POR EL SIGUIENTE OBJETO
obsPtrNext::
		ld 		a, (actual_ptr)
		cp 		#2
		jr 		z, resetPtr
			ld 		a, (actual_ptr)
			inc 	a
			ld 		(actual_ptr), a
	ret
	resetPtr:
		ld 		a, #0
		ld 		(actual_ptr), a
	ret