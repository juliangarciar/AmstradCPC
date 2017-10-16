.area _DATA
.include "shortcuts.h.s"
	;==================
	;;;PRIVATE DATA
	;==================
;color: .db #0x00
time:		.db #200	;controla el tiempo de regeneracion de enemigos
velocidadT:	.db #5
velocidadV:	.db #5
;.equ	enemy_x, 0
;.equ	enemy_y, 1
;.equ	enemy_w, 2
;.equ	enemy_h, 3
;.equ	enemy_j, 4


	;;ENEMIGOS TERRESTRES
defineEnemy enemy1, 0, 160, 3, 15, 0, #0xFF, 0, 0, 0
defineEnemy enemy2, 76, 160, 3, 15, 1, #0xF0, 0, 0, 0
; defineEnemy enemy3, 0, 160, 3, 15, 1, #0xFF, 0
; defineEnemy enemy4, 15, 160, 3, 15, 1, #0x0F, 0
; defineEnemy enemy5, 20, 160, 3, 15, 1, #0xF0, 0
; defineEnemy enemy6, 25, 160, 3, 15, 1, #0xFF, 0
; defineEnemy enemy7, 30, 160, 3, 15, 1, #0x0F, 0
; defineEnemy enemy8, 35, 160, 3, 15, 1, #0xF0, 0
; defineEnemy enemy9, 40, 160, 3, 15, 1, #0xFF, 0
; defineEnemy enemy10, 45, 160, 3, 15, 1, #0xF0, 0


	;ENEMIGOS VOLADORES
defineEnemy enemyV1, 0, 80, 3, 15, 0, #0x0F, 0, 1, 0
defineEnemy enemyV2, 76, 80, 3, 15, 1, #0xF0, 0, 1, 1


;enemy_data:		
;	enemyX: 	.db #0 
;	enemyY: 	.db #160
;	enemyW: 	.db #0x03
;	enemyH: 	.db #0x0F
;	enemyJ: 	.db #0

.area _CODE

.include "cpctelera.h.s"


;====================
;   DIBUJA ENEMIGOS
;====================
draw_enemy::

	call enemyPtr
	
	repetimos_draw:
	;comprobamos si el enemigo esta activado o no
		ld 		a, enemy_a(ix)
		cp 		#0
		jr 		nz, dibujar
		 	jr siguiente_draw

		dibujar:
		ld 		de, #0xC000	;beginning of screen

		ld 		c, enemy_x(ix) 		; b = enemy_X
		ld 		b, enemy_y(ix) 		; c = enemy_y
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register

		ex 		de, hl 		;HL holds the screen pointer, so we swap it with de for fast change
		;ALTERAR LA FORMA DE PASAR H Y W, PERO SIN CAGAR COLIS
		ld 		bc, #0x1004	;heigh: 8x8 pixels on mode 1 (2 bytes every 4 pixels)
		ld 		a, enemy_c(ix)
		call 	cpct_drawSolidBox_asm ;draw box itself

		;comprobamos si hay mas enemigos que pintar
		siguiente_draw:
		ld 		a, enemy_l(ix)
		cp 		#1
		ret 	z
		
		;sumamos posiciones de memoria hasta ir al siguiente enemigo
		ld 		bc, #9 ;porque es el numero de variables
		add 	ix, bc
		jr 		repetimos_draw ;volvemos a comprobar si el siguiente esta activo o no



;===================
;   BORRA ENEMIGOS
;===================
erase_enemy::
	
	call enemyPtr

	repetimos_borrar:
	;comprobamos si el enemigo esta activado o no
		ld 		a, enemy_a(ix)
		cp 		#0
		jr 		nz, borrar
			jr 	siguiente_borrar

		borrar:
		ld 		de, #0xC000	;beginning of screen

		ld 		c, enemy_x(ix) 		; b = hero_X
		ld 		b, enemy_y(ix) 		; c = hero_y
		
		call 	cpct_getScreenPtr_asm
		ex 		de, hl 

		ld 		a, enemy_h(ix)
		inc 	a
		ld 		b, a

		ld 		a, enemy_w(ix)
		inc 	a
		ld 		c, a

		ld 		a, #0x00
		call 	cpct_drawSolidBox_asm

		;comprobamos si hay mas enemigos que pintar
		siguiente_borrar:
		ld 		a, enemy_l(ix)
		cp 		#1
		ret 	z
		
		;sumamos posiciones de memoria hasta ir al siguiente enemigo
		ld 		bc, #9 ;porque es el numero de variables
		add 	ix, bc
		jr 		repetimos_borrar ;volvemos a comprobar si el siguiente esta activo o no



;=======================
;   ACTIVAMOS ENEMIGOS
;=======================
activateEnemy::
	call 	enemyPtr

	ld 		a, (time)
	cp 		#0
	jr 		z, comprobar
		;EDITAR PARA MAS ENEMIGOS (DIFERENTES TIEMPOS)
		dec a
		ld 	(time), a
		ret

	comprobar:
	ld 	a, enemy_a(ix)
	cp 	#0
	jr 	nz, comprobamos_siguiente ;ya esta activado
		inc a
		ld enemy_a(ix), a
		call actualizar_time
		ret
	comprobamos_siguiente:
	ld		a, enemy_l(ix)
	cp 		#0
	jr 		z, siguiente_activar 

		;;Es el ultimo, salimos.
		ret

	siguiente_activar:
	;sumamos posiciones de memoria hasta ir al siguiente enemigo
	ld 		bc, #9 ;porque es el numero de variables
	add 	ix, bc
	jr 		comprobar ;volvemos a comprobar si el siguiente esta activo o no


;======================================================
;   REINICIAR TEMPORIZADOR DE REGENERACION DE ENEMIGOS
;======================================================
actualizar_time:
	ld 	a, #200
	ld 	(time), a

	ret

;===========================================
;   REINICIAR VELOCIDAD ENEMIGOS TERRESTRES
;===========================================
actualizarV_terrestres:
	ld 	a, #5
	ld 	(velocidadT), a

	ret

;==========================================
;   REINICIAR VELOCIDAD ENEMIGOS VOLADORES
;==========================================
actualizarV_voladores:
	ld 	a, #5
	ld 	(velocidadV), a

	ret

	
;==================
;   UPDATE ENEMIGO
;==================
updateEnemy::

	call enemyPtr

	repetimos_update:

	;comprobamos si el enemigo esta activado o no
	ld 		a, enemy_a(ix)
	cp 		#0
	jr 		nz, seguir
		jr 		siguiente_update

	seguir:
	;COMPROBAMOS SI ES TERRESTRE O VOLADOR
	ld 		a, enemy_t(ix)
	cp 		#0
	jr 		z, es_terrestre

		;es volador
		ld 		a, (velocidadV)
		cp 		#0
		jr 		z, actualizarV
			dec a
			ld 	(velocidadV), a
			call moveEnemy
			jr 	siguiente_update
			;ret

		actualizarV:
		call actualizarV_voladores

	es_terrestre:
		ld 		a, (velocidadT)
		cp 		#0
		jr 		z, actualizarT
			dec a
			ld 	(velocidadT), a
			call moveEnemy
			jr 	siguiente_update
			;ret

		actualizarT:
		call actualizarV_terrestres


	;comprobamos si hay mas enemigos que pintar
		siguiente_update:
		ld 		a, enemy_l(ix)
		cp 		#1
		ret 	z
		
			;sumamos posiciones de memoria hasta ir al siguiente enemigo
			ld 		bc, #9 ;porque es el numero de variables
			add 	ix, bc
			jr 		repetimos_update ;volvemos a comprobar si el siguiente esta activo o no
			
		;ret

enemyPtr::
	ld 		ix, #enemy1_data
ret


	;====================
	; MOVIMIENTO ENEMIGO
	;====================

salir:
	ret


moveEnemy:

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
