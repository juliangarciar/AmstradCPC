.area _DATA
	;==================
	;;;PRIVATE DATA
	;==================

.area _CODE
.include "cpctelera.h.s"
.include "hero.h.s"
.include "keyboard/keyboard.s"


	;==================
	;   MOVIMIENTO
	;==================

moveHeroRight:
	ld 		a, (hero_x)
	cp 		#80-4 		;para comprobar colisiones con limite derecho
	jr 		z, dont_move_right  ;hero_x = limite pantalla dcha, no mover

		;MOVE RIGHT (no esta en el limite)
		inc 	a
		ld 		(hero_x), a
	dont_move_right:
	ret


moveHeroLeft:
	ld 		a, (hero_x)
	cp 		#0			;limite izquierda
	jr		z, dont_move_left	;hero_x = limite pantalla izda

		;MOVE LEFT (no esta en le limite)
		dec 	a
		ld 		(hero_x), a
	dont_move_left:
	ret


startJump:
	ld 		a, (hero_jump)
	cp      #-1		;comprobamos si el salto esta activo. Si no da 0, estara activo
	ret     nz

	;Salto inactivo, lo activamos
	ld 		a, #0
	ld 		(hero_jump), a


	ret



	;==================
	;   SALTO HEROE
	;==================
;Comprueba si el heroe esta saltando. Si lo esta, 
;efectuara el movimiento. Despues, si ha terminado el salto, 
;lo desactiva y lo vuelve a poner a -1
;Habra que añadir la tecla w que compruebe cuando se pulse, active el salto.

jump_control::

	ld	  a, (hero_jump) ;A = hero_jump status
	cp    #-1            ;A == -1?
	ret   z				 ;Si A== -1, no salta

	;Si A!=0
	;MOVE HEROE

	ld		hl, #jumptable 	;HL apunta al inicio de la jumptable
	ld		c, a
	ld		b, #0			;BC = A
	add		hl, bc 			;HL = HL+BC

	;Jump movement
	ld		a, (hl) 		;A = Jump movement
	ld		a, (hero_y) 	;A = hero_y
	add		b 				;A = A + B
	ld		(hero_y), a     ;Actualizamos hero_y 

	;Incrementamos el indice de la jumptable
	ld		a, (hero_jump)  ;A = hero_jump
	cp      #0x80			;comprobamos si es el ultimo valor de la jumptable
	jr 		nz, continue_jump  ;no es el ultimo, continua
	
		;Terminar salto
		ld		a, #-2

	continue_jump:
	inc     a
	ld		(hero_jump), a  ;Hero_jump++


	ret



	;================================
	;   COMPROBAR TECLAS PULSADAS
	;================================

checkUserInput::
	
	;TECLA D

	;Move right
	call 	cpct_scanKeyboard_asm
	ld 		hl, #Key_D
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, rightNotPressed

			;ELSE MOVE RIGHT
			call moveHeroRight


	rightNotPressed:

	;TECLA A

	ld 		hl, #Key_A
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, leftNotPressed

			;ELSE MOVE LEFT 
			call moveHeroLeft

	leftNotPressed:

	;;TECLA W

	ld 		hl, #Key_W
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, jumpNotPressed

			;ELSE MOVE UP 
			call startJump

	jumpNotPressed:

	ret