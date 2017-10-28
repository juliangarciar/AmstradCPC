.area _DATA
	;========================
	; REQUIRED HEADERS
	;========================
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "hero.h.s"
.include "enemy.h.s"
.include "shot.h.s"

.area _CODE


checkCollision::
	call 	enemyPtrY
	;==========================================
	; 	COLLISION CODE
	;
	;	DESTROYS: A, BC, IX, IY, DE
	;	MODES:
	;		A == 2 -> Jump collision
	;		A == ?? -> Enemy collision NOT IMPLEMENTED
	;		A == 1 -> Hero bullets collision
	;	RETURNS: A
	; 		A == 1 -> Objects collide
	;		A == 0 -> Objects doesn't collide
	;===========================================

collisionBucle:
	ld 		a, obs_alive(iy)
	cp 		#0
	jr 		z, noCollision
	;Evaluamos las condiciones para que no colisione
	;en caso contrario, colisionara
	;Comprobar el eje Y primero lado SUPERIOR, ya que es más probable que colisione
	;en el eje X
	;Cargamos posicion del obstaculo_y
	;la guardamos en el almacen c
	;ld 		a, d 			;CHECK IF IT'S SPECIAL MODE ACTIVE
	;cp 		#2				;
	;jr 		z, specialMode 	;JP IF IT IS 		
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
		
						;ld 		a, #0
						;ld 		obs_alive(iy), a
						dec 	obs_alive(iy)
						call 	eraseEnemyMark
						ld 		a, #1
					ret
	;EN CASO DE NO COLISIONAR
	noCollision:
		;COMPROBAMOS SI HEMOS LLEGADO AL FINAL DE LOS OBJETOS


		ld 		a, obs_l(iy)
		cp 		#1
		jr 		nz, repeat
			;SI NO HAY MAS, CARGA NO COLISION Y NOS VAMOS
			ld 		a, #0
		ret
	;REPITE EL BUCLE SI HAY MAS OBJETOS
	repeat:
		ld 		bc, #9
		add 	iy, bc
		jr		collisionBucle
	