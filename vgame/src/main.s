.area _DATA
	;==================
	;;;PRIVATE DATA
	;==================

	;==================
	;;;PUBLIC DATA
	;==================

.area _CODE
	;==================
	;;;INCLUDE FUNCIONS
	;==================
	.include "cpctelera.h.s"


	initialize:
		ret

	_main:
		_main_bucle:
			jr		_main_bucle

