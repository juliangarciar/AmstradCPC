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
	ret 	z  ;hero_x = limite pantalla dcha, no mover

		;MOVE RIGHT (no esta en el limite)
		inc 	a
		ld 		(hero_x), a
	ret


moveHeroLeft:
	ld 		a, (hero_x)
	cp 		#0			;limite izquierda
	ret 	z	;hero_x = limite pantalla izda

		;MOVE LEFT (no esta en le limite)
		dec 	a
		ld 		(hero_x), a
	ret




	;==================
	;   EMPEZAR SALTO
	;================== 

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


	;Comprobar si ha terminado el salto
	ld		a, (hl)
	cp 		#0x80 ;Jump value = 0x80
	jr 		z, end_of_jump

	;Jump movement
	ld		b, a		;B = Jump movement
	ld		a, (hero_y) 	;A = hero_y
	add		b 				;A = A + B
	ld		(hero_y), a     ;Actualizamos hero_y 

	;Incrementamos el indice de la jumptable
	ld		a, (hero_jump)  ;A = hero_jump
	
	inc     a
	ld		(hero_jump), a  ;Hero_jump++


	ret

	;Ponemos -1 en el index cuando el salto termina
	end_of_jump:
		ld 		a, #-1
		ld 		(hero_jump), a

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