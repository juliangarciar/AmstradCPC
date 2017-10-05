.area _DATA
	;==================
	;;;PRIVATE DATA
	;==================

	;==================
	;;;PUBLIC DATA
	;==================

.area _CODE
.include "cpctelera.h.s"
.include "control.h.s"
.include "obstacle.h.s"
.include "hero.h.s"
	;==================
	;;;INCLUDE FUNCIONS
	;==================
	
	_main::

		main_bucle:
		call 	erase_hero


		;HACER UN UPDATE DE CONTROL
		call	jump_control
		call 	checkUserInput

		call 	drawObstacles
		call 	draw_hero

		call 	cpct_waitVSYNC_asm
		jr		main_bucle

