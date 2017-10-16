.area _DATA
.include "shortcuts.h.s"
.include "control.h.s"
	;==================
	;;;PRIVATE DATA
	;==================
;color: .db #0x00
time:		.db #200	;controla el tiempo de regeneracion de enemigos
velocidadT:	.db #5
velocidadV:	.db #1
;.equ	enemy_x, 0
;.equ	enemy_y, 1
;.equ	enemy_w, 2
;.equ	enemy_h, 3
;.equ	enemy_j, 4


	;;ENEMIGOS TERRESTRES
defineEnemy enemy1, 0, 160, 3, 15, 0, #0xFF, 0, 0, 0
;defineEnemy enemy2, 76, 160, 3, 15, 1, #0xF0, 0
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
defineEnemy enemyV2, 76, 80, 3, 15, 1, #0xF0, 0, 1, 0


;enemy_data:		
;	enemyX: 	.db #0 
;	enemyY: 	.db #160
;	enemyW: 	.db #0x03
;	enemyH: 	.db #0x0F
;	enemyJ: 	.db #0

.area _CODE

.include "cpctelera.h.s"


	;==================
	;   DIBUJA enemyE
	;==================

stop:
	ret

draw_enemy::
	
	;comprobamos si el enemigo esta activado o no
		ld 		a, enemy_a(ix)
		cp 		#0
		jr 		z, stop
		;ret 	nz

		ld 		de, #0xC000	;beginning of screen

		ld 		c, enemy_x(ix) 		; b = enemy_X
		ld 		b, enemy_y(ix) 		; c = enemy_y
		
		call 	cpct_getScreenPtr_asm	;gets pointer in HL with the data passed on the register

		ex 		de, hl 		;HL holds the screen pointer, so we swap it with de for fast change
		;ALTERAR LA FORMA DE PASAR H Y W, PERO SIN CAGAR COLIS
		ld 		bc, #0x1004	;heigh: 8x8 pixels on mode 1 (2 bytes every 4 pixels)
		ld 		a, enemy_c(ix)
		call 	cpct_drawSolidBox_asm ;draw box itself
	ret


	;==================
	;   BORRAR enemyE
	;==================	

close:
	ret

erase_enemy::

	;comprobamos si el enemigo esta activado o no
		ld 		a, enemy_a(ix)
		cp 		#0
		jr 		z, close
		;ret 	nz


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

	ret


;;ANCIVAMOS ENEMIGOS TERRESTRES

activateEnemy::
	

	ld 		a, (time)
	cp 		#0
	jr 		z, comprobar1
		dec a
		ld 	(time), a
		ret

	comprobar1:

	call 	enemy1Ptr

	ld 	a, enemy_a(ix)
	cp 	#0
	jr 	nz, salirT
		inc a
		ld enemy_a(ix), a
		call actualizar_time
		ret

	; comprobar2:

	; call 	enemy2Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; jr 	nz, comprobar3
	; 	inc a
	; 	ld enemy_a(ix), a
	; 	call actualizar_time
	; 	ret

	;comprobar3:

	; call 	enemy3Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; jr 	nz, salirT
	; 	inc a
	; 	ld enemy_a(ix), a
	; 	call actualizar_time
	; 	ret

	salirT:
	ret

	; comprobar4:
	; call 	enemy4Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; jr 	nz, comprobar5
	; 	inc a
	; 	ld enemy_a(ix), a
	; 	call actualizar_time
	; 	ret

	; comprobar5:
	; call 	enemy5Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; jr 	nz, comprobar6
	; 	inc a
	; 	ld enemy_a(ix), a
	; 	call actualizar_time
	; 	ret

	; comprobar6:
	; call 	enemy6Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; jr 	nz, comprobar7
	; 	inc a
	; 	ld enemy_a(ix), a
	; 	call actualizar_time
	; 	ret

	; comprobar7:
	; call 	enemy7Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; jr 	nz, comprobar8
	; 	inc a
	; 	ld enemy_a(ix), a
	; 	call actualizar_time
	; 	ret

	; comprobar8:
	; call 	enemy8Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; jr 	nz, comprobar9
	; 	inc a
	; 	ld enemy_a(ix), a
	; 	call actualizar_time
	; 	ret		

	; comprobar9:
	; call 	enemy9Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; jr 	nz, comprobar10
	; 	inc a
	; 	ld enemy_a(ix), a
	; 	call actualizar_time
	; 	ret

	; comprobar10:
	; call 	enemy10Ptr

	; ld 	a, enemy_a(ix)
	; cp 	#0
	; ret nz
	
	; inc a
	; ld enemy_a(ix), a

	; call actualizar_time
	; ret


;;ACTIVAMOS ENEMIGOS VOLADORES

activateEnemyV::
	

	ld 		a, (time)
	cp 		#0
	jr 		z, comprobarV1
		dec a
		ld 	(time), a
		ret

	comprobarV1:

	call 	enemyV1Ptr

	ld 	a, enemy_a(ix)
	cp 	#0
	jr 	nz, comprobarV2
		inc a
		ld enemy_a(ix), a
		call actualizar_time
		ret

	comprobarV2:

	call 	enemyV2Ptr

	ld 	a, enemy_a(ix)
	cp 	#0
	jr 	nz, salirV
		inc a
		ld enemy_a(ix), a
		call actualizar_time
		ret

	salirV:
	ret



actualizar_time:
	ld 	a, #200
	ld 	(time), a

	ret

actualizarV_terrestres:
	ld 	a, #5
	ld 	(velocidadT), a

	ret


actualizarV_voladores:
	ld 	a, #1
	ld 	(velocidadV), a

	ret




	
updateEnemy::

;comprobamos si el enemigo esta activado o no
	ld 		a, enemy_a(ix)
	cp 		#0
	jr 		nz, seguir
		ret

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
			ret

		actualizarV:
		call actualizarV_voladores

	es_terrestre:
		ld 		a, (velocidadT)
		cp 		#0
		jr 		z, actualizarT
			dec a
			ld 	(velocidadT), a
			call moveEnemy
			ret

		actualizarT:
		call actualizarV_terrestres



enemyV1Ptr::
	ld 		ix, #enemyV1_data
	ret

enemyV2Ptr::
	ld 		ix, #enemyV2_data
	ret


enemy1Ptr::
		ld 		ix, #enemy1_data
	ret

;enemy2Ptr::
;		ld 		ix, #enemy2_data
;	ret

;enemy3Ptr::
;		ld 		ix, #enemy3_data
;	ret

; enemy4Ptr::
; 		ld 		ix, #enemy4_data
; 	ret

; enemy5Ptr::
; 		ld 		ix, #enemy5_data
; 	ret

; enemy6Ptr::
; 		ld 		ix, #enemy6_data
; 	ret

; enemy7Ptr::
; 		ld 		ix, #enemy7_data
; 	ret

; enemy8Ptr::
; 		ld 		ix, #enemy8_data
; 	ret

; enemy9Ptr::
; 		ld 		ix, #enemy9_data
; 	ret

; enemy10Ptr::
; 		ld 		ix, #enemy10_data
; 	ret

