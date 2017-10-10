.area _DATA
	;==================
	;;;PRIVATE DATA
	;==================

.area _CODE
.include "cpctelera.h.s"
.include "hero.h.s"
.include "keyboard/keyboard.s"
.include "collision.h.s"

	;==================
	; MOVIMIENTO HEROE
	;==================
no_colisiona:
	ret
moveHeroRight:
	call heroPtr
	ld 		a, 0(ix)
	cp 		#80-4 		;para comprobar colisiones con limite derecho
	ret 	z  			;hero_x = limite pantalla dcha, no mover


		inc 	0(ix)
		call 	checkCollision
		cp 		#1
		jr 		nz, no_colisiona

			dec  	0(ix)
	ret

moveHeroLeft:
	call heroPtr
	ld 		a, 0(ix)
	cp 		#0			;limite izquierda
	ret 	z			;hero_x = limite pantalla izda

		dec 	0(ix)	
		call 	checkCollision
		cp 		#1
		jr 		nz, no_colisiona

			inc 	0(ix)
	ret

moveHeroUp:
	call heroPtr
	ld 		a, 1(ix)
	cp 		#0			;limite izquierda
	ret 	z		;hero_x = limite pantalla izda

		dec 	1(ix)
		call 	checkCollision
		cp 		#1
		jr 		nz, no_colisiona

			inc 	1(ix)
	ret

moveHeroDown:
	call heroPtr
	ld 		a, 1(ix)
	cp 		#199			;limite izquierda
	ret 	z		;hero_x = limite pantalla izda

		inc 	1(ix)
		call 	checkCollision
		cp 		#1
		jr 		nz, no_colisiona

			dec 	1(ix)
	ret

	;==================
	;   EMPEZAR SALTO
	;================== 

startJump:
	ld 		a, 4(ix)
	cp      #-1		;comprobamos si el salto esta activo. Si no da 0, estara activo
	ret     nz

		;Salto inactivo, lo activamos
		;ld 		a, #0
		;ld 		4(ix), a
		ld 		4(ix), #0
	ret



	;==================
	;   SALTO HEROE
	;==================
;Comprueba si el heroe esta saltando. Si lo esta, 
;efectuara el movimiento. Despues, si ha terminado el salto, 
;lo desactiva y lo vuelve a poner a -1
;Habra que añadir la tecla w que compruebe cuando se pulse, active el salto.

;HAY QUE BORRAR TODO EL SALTO
jump_control::
	call 	heroPtr
	ld	 	a, 4(ix) ;A = hero_jump status
	cp    	#-1            ;A == -1?
	ret   	z				 ;Si A== -1, no salta

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
	ld		a, 1(ix)	;A = hero_y
	add		b 				;A = A + B
	ld		1(ix), a     ;Actualizamos hero_y 

			call	checkCollision
			cp 		#1
			jr 		z, forzar_parada
	;Incrementamos el indice de la jumptable
	;ld		a, 4(ix)  ;A = hero_jump
	
	;inc     a
	;ld		4(ix), a  ;Hero_jump++
	inc 	4(ix)

	ret

	forzar_parada:

		jr 		end_of_jump
	;Ponemos -1 en el index cuando el salto termina
	end_of_jump:
		ld 		4(ix), #-1
		;ld 		a, #-1
		;ld 		(hero_jump), a

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

	;;TECLA SPACE

	ld 		hl, #Key_Space
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, jumpNotPressed

			;ELSE MOVE UP 
			call startJump

	jumpNotPressed:


	;TECLA W
	ld 		hl, #Key_W
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, upNotPressed

			;ELSE MOVE LEFT 
			call moveHeroUp

	upNotPressed:
	;TECLA W
	ld 		hl, #Key_S
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, nothingPressed

			;ELSE MOVE LEFT 
			call moveHeroDown

	nothingPressed:

	ret