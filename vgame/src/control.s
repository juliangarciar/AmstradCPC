.area _DATA
	;==================
	; CONTROL DATA
	;==================
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "hero.h.s"
.include "shot.h.s"
.include "keyboard/keyboard.s"
.include "collision.h.s"

;defineBale bale, 0, 0, 0, 0

.area _CODE
	;==================
	; CONTROL CODE
	;==================

;; ======= Variables bala ============
;;alive:    .db #0 ;; (0 o 1) en funcion de si esta activada o no la bala
;;dir_bale: .db #0 ;; (0, 1, 2) variable que controla la direccion de la bala 

;SI NO COLISION, ME VOY
no_colisiona:
	ret
;MOVER HEROE A LA DERECHA
moveHeroRight:
	call 	heroPtr
	call 	spritePtr
	;call    balePtr

	ld 		a, hero_x(ix)	; ld a, (heroX)
	cp 		#80-4 		;para comprobar colisiones con limite derecho
	ret 	z  			;hero_x = limite pantalla dcha, no mover


		inc 	hero_x(ix)
		;ld 		a, #1
		ld 		sprite_pos(iy), #1
		ld 		hero_dir(ix), #2
		;ld 		a, #2
		;call 	checkCollision
		;cp 		#1
		;jr 		nz, no_colisiona

			;dec  	0(ix)
			;call balePtr
		;; Cambiamos la direccion de la bala si la bala esta muerta,
		;; si esta viva, no hacemos nada
		;ld   a, bale_a(ix)
		;cp   #1
		;jr   z, alive_bale1

			;; Si la bala esta muerta, entonces ponemos su nueva direccion
			;ld   a, #2
  			;ld   bale_bd(ix), a      ;; Ponemos la nueva direccion de la bala

  		;alive_bale1:

	ret
;MOVER HEROE A LA IZQUIERDA
moveHeroLeft:
	call 	heroPtr
	call 	spritePtr
	;call    balePtr

	ld 		a, hero_x(ix)
	cp 		#0			;limite izquierda
	ret 	z			;hero_x = limite pantalla izda

		dec 	hero_x(ix)	
		;ld 		a, #2
		ld 		sprite_pos(iy), #2
		ld 		hero_dir(ix), #1
		;ld 		a, #2
		;call 	checkCollision
		;cp 		#1
		;jr 		nz, no_colisiona

			;inc 	0(ix)

			;call balePtr
		;; Cambiamos la direccion de la bala si la bala esta muerta,
		;; si esta viva, no hacemos nada
		;ld   a, bale_a(ix)
		;cp   #1
		;jr   z, alive_bale2

			;; Si la bala esta muerta, entonces ponemos su nueva direccion
			;ld   a, #1
  			;ld   bale_bd(ix), #1      ;; Ponemos la nueva direccion de la bala

  		;alive_bale2:

	ret

shootUp:
	call 	heroPtr
	;call 	spritePtr
	;call    balePtr

		;ld 		sprite_pos(iy), #2
		ld 		hero_dir(ix), #3
	ret

;moveHeroDown:
;	call heroPtr
;	ld 		a, 1(ix)
;	cp 		#184			;limite izquierda
;	ret 	z		;hero_x = limite pantalla izda

;		inc 	1(ix)
		;ld 		a, #2
		;call 	checkCollision
		;cp 		#1
		;jr 		nz, no_colisiona

		;	dec 	1(ix)
;	ret



;====================
	; MOVIMIENTO ENEMIGO
	;====================

salir:
	ret


moveEnemy::

	;comprobamos si el enemigo esta activado o no
	ld 		a, enemy_a(ix)
	cp 		#0
	jr 		z, salir
	;ret 	nz

	;call 	enemyPtr		;carga el puntero de enemigo
	ld 		a, enemy_d(ix)		;carga enemy_d
	cp 		#1				;compara con 1
	jr 		z, moveRight 	;enemy_d = 0??? Si es 0, se mueve a la derecha, si no, a la izda


		;Se mueve a la izda

		ld 		a, enemy_x(ix)		;a = enemy_x
		cp 		#0 				;para comprobar colisiones con limite izdo
		jr 		z, chocaLeft	;enemy_x = limite pantalla izda, no mover

			; Si no choca, entonces movemos
			dec  	a
			ld 		enemy_x(ix), a
			ret 
		
		;Si choca, acutalizamos enemy_d para que cambie de sentido a la derecha
		chocaLeft:
		ld 		a, #1
		ld 		enemy_d(ix), a
		
		ret

	;Se mueve a la derecha
	moveRight:

		ld 		a, enemy_x(ix)		;a = enemy_x
		cp 		#80-4 			;para comprobar colisiones con limite dcho
		jr 		z, chocaRight 	;enemy_x = limite pantalla dcha, no mover

			; Si no choca, entonces movemos
			inc  	a
			ld 		enemy_x(ix), a
			ret 
		
		;Si choca, acutalizamos enemy_d para que cambie de sentido a la izquierda
		chocaRight:
		ld 		a, #0
		ld 		enemy_d(ix), a

	ret


	;==================
	;   EMPEZAR SALTO
	;================== 

startJump:
	call 	heroPtr
	ld 		a, hero_j(ix)
	cp      #-1		;comprobamos si el salto esta activo. Si no da 0, estara activo
	ret     nz

		;Salto inactivo, lo activamos
		ld 		hero_j(ix), #0
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
	ld	 	a, hero_j(ix) ;A = hero_jump status
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
	ld		a, hero_y(ix)	;A = hero_y
	add		b 				;A = A + B
	ld		hero_y(ix), a     ;Actualizamos hero_y 

	ld		a, hero_special_y(ix)	;A = hero_y
	add		b 				;A = A + B
	ld		hero_special_y(ix), a     ;Actualizamos hero_y 
			;call	checkCollision
			;cp 		#1
			;jr 		z, forzar_parada
	;Incrementamos el indice de la jumptable
	;ld		a, 4(ix)  ;A = hero_jump
	
	;inc     a
	;ld		4(ix), a  ;Hero_jump++
	inc 	hero_j(ix)

	ret

	forzar_parada:
		jr 		end_of_jump
	;Ponemos -1 en el index cuando el salto termina
	end_of_jump:
		ld 		hero_j(ix), #-1
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

	;; Check for key 'P' being pressed. Para el disparo
	ld     hl, #Key_P              ;; HL = Key_W_Keycode
	call   cpct_isKeyPressed_asm   ;; Check if Key_W is presset 
  	cp     #0                      ;; Check A == 0
  	jr     z, p_not_pressed       ;; Jump if A == 0 ('W' not pressed) 


  		;; P is pressed
  		;ld   a, bale_bd(ix)
  		call check_shot

	p_not_pressed:

	;TECLA W

	ld 		hl, #Key_W
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, nothingPressed

			;ELSE MOVE LEFT 
			call shootUp

	upNotPressed:

	;TECLA S

	;ld 		hl, #Key_S
	;call 	cpct_isKeyPressed_asm
	;cp 		#0
	;jr 		z, nothingPressed

			;ELSE MOVE LEFT 
	;		call moveHeroDown

	nothingPressed:

	ret