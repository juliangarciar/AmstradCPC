.area _DATA
	;==================
	;;;PRIVATE DATA
	;==================

.area _CODE
.include "cpctelera.h.s"
.include "hero.h.s"
.include "keyboard/keyboard.s"

checkUserInput::
	
	;Move right
	call 	cpct_scanKeyboard_asm
	ld 		hl, #Key_D
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, rightNotPressed

			;ELSE MOVE RIGHT
			ld 		a, (hero_x)
			inc 	a
			ld 		(hero_x), a
	rightNotPressed:
	ld 		hl, #Key_A
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, leftNotPressed

			;ELSE MOVE LEFT 
			ld 		a, (hero_x)
			dec 	a
			ld 		(hero_x), a

	leftNotPressed:

	ret