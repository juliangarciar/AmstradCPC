.area _DATA
	;========================
	; ENCABEZADOS REQUERIDOS
	;========================
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "hero.h.s"
.include "obstacle.h.s"

.area _CODE
	;==========================================
	; 	COLLISION CODE
	;
	;	DESTROYS: A, BC, IX, IY, DE
	;	MODES:
	;		A == 1 -> Jump collision
	;		A == 2 -> Enemy collision
	;		A == 3 -> Hero bullets collision
	;	RETURNS: A
	; 		A == 1 -> Objects collide
	;		A == 0 -> Objects doesn't collide
	;===========================================

checkCollision::
	ld 		d, a 					;ALMACENAMOS EN 'D' EL MODO
	;cp 		#1						;
	;jr 		z, enemyMode			;
	;	cp 		#1					;
	;	jr 		z, bulletMode		;	
			cp 		#1				;
			jr 		z, jumpMode		;
									;EN FUNCION DEL MODO, CARGAMOS LOS REGISTROS
	enemyMode:						;'IY', 'IX'
		;call 	heroPtr
		;call 	enemyPtr
	;jr 		collisionBucle
	bulletMode:

		;call 	bulletPtr
		;call 	enemyPtr
	;jr 		collisionBucle
	jumpMode:
		call 	obsPtr				;CARGAMOS EN 'IY' EL PUNTERO OBS (Obstaculo)
		call 	heroPtr				;CARGAMOS EN 'IX' EL PUNTERO HERO
	jr 		collisionBucle
	specialMode:
		ld 		c, obs_y(iy)
		ld 		b, hero_special_y(ix)
		ld 		a, hero_special_h(ix)
		add 	a, b
		sub 	c
		jp 		m, noCollision
			ld 		c, hero_special_y(ix)
			ld 		b, obs_y(iy)
			ld 		a, obs_h(iy)
			add 	a, b
			sub 	c
			jp 		m, noCollision
				jp 		checkX
	ret
	collisionBucle:
	;Evaluamos las condiciones para que no colisione
	;en caso contrario, colisionara
	;Comprobar el eje Y primero lado SUPERIOR, ya que es más probable que colisione
	;en el eje X
	;Cargamos posicion del obstaculo_y
	;la guardamos en el almacen c
	ld 		a, d 			;CHECK IF IT'S SPECIAL MODE ACTIVE
	cp 		#1				;
	jr 		z, specialMode 	;JP IF IT IS 		
	checkY:
	ld 		c, obs_y(iy)
	;Cargamos posicion del heroe_y
	;la guardamos en el almacen b
	ld 		b, hero_y(ix)
	;Cargamos el ancho 
	ld 		a, hero_h(ix)
	;Hacemos la operacion siguiente
	;hero_y + hero_y_size - posY_1 <= 0
	add 	a, b
	sub 	c
	;Hacemos las condiciones
	jp 		m, noCollision
		;Comprobamos colision por el otro lado ABAJO
		;posY_1 + sizeY_1 - hero_y <=0
		ld 		c, hero_y(ix)
		ld 		b, obs_y(iy)
		ld 		a, obs_h(iy)
		add 	a, b
		sub 	c

		jp 		m, noCollision
			;Si llegamos aqui, es porque colisiona en el eje Y
			;comprobamos ahora que ocurre en el eje X
			;lado IZQUIERDO
			;hero_x + hero_x_size - posX_1 <= 0
			checkX:
			ld 		c, obs_x(iy)
			ld 		b, hero_x(ix)
			ld 		a, hero_w(ix)
			add 	a, b
			sub 	c

			jp 		m, noCollision
				;Comprobamos lado DERECHO en el eje X
				;posX_1 + sizeX_1 - hero_x <= 0
				ld 		c, hero_x(ix)
				ld 		b, obs_x(iy)
				ld 		a, obs_w(iy)
				add 	a, b
				sub 	c

				jp 		m, noCollision
						;Sillega aqui es porque colisiona,
						;cargamos en el registro A un valor
						; para poder evaluar desde fuera si colisiona
						ld 		hl, #0xC050
						ld 		(hl), #0xF0

						ld 		a, #1
					ret
	;EN CASO DE NO COLISIONAR
	noCollision:
		;COMPROBAMOS SI HEMOS LLEGADO AL FINAL DE LOS OBJETOS
		ld 		a, obs_l(iy)
		cp 		#1
		jr 		z, repeat
			;SI NO HAY MAS, CARGA NO COLISION Y NOS VAMOS
			ld 		hl, #0xC050
			ld 		(hl), #0xFF

			ld 		a, #0
	ret
	;REPITE EL BUCLE SI HAY MAS OBJETOS
	repeat:
		ld 		bc, #5
		add 	iy, bc
		jr		collisionBucle