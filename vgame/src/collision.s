.area _DATA
.area _CODE
.include "cpctelera.h.s"
.include "hero.h.s"
.include "obstacle.h.s"

checkCollision::
	;Evaluamos las condiciones para que no colisione
	;en caso contrario, colisionara
	;Comprobar el eje Y primero lado SUPERIOR, ya que es más probable que colisione
	;en el eje X

	;Cargamos posicion del obstaculo_y
	;la guardamos en el almacen c
	ld 		a, (posY_1)
	ld 		c, a

	;Cargamos posicion del heroe_y
	;la guardamos en el almacen b
	ld 		a, (hero_y)
	ld 		b, a

	;Cargamos el ancho 
	ld 		a, (hero_y_size)

	;Hacemos la operacion siguiente
	;hero_y + hero_y_size - posY_1 <= 0
	add 	a, b
	sub 	c
	;Hacemos las condiciones
	;jr 		z, no_collision
	;jr		c, no_collision
	jp 		m, no_collision

		;Comprobamos colision por el otro lado ABAJO
		;posY_1 + sizeY_1 - hero_y <=0
		ld 		a, (hero_y)
		ld 		c, a

		ld 		a, (posY_1)
		ld 		b, a

		ld 		a, (sizeY_1)

		add 	a, b
		sub 	c

		;jr 		z, no_collision
		;jr		c, no_collision
		jp 		m, no_collision

			;Si llegamos aqui, es porque colisiona en el eje Y
			;comprobamos ahora que ocurre en el eje X
			;lado IZQUIERDO
			;hero_x + hero_x_size - posX_1 <= 0
			ld 		a, (posX_1)
			ld 		c, a

			ld 		a, (hero_x)
			ld 		b, a

			ld 		a, (hero_x_size)

			add 	a, b
			sub 	c

			;jr 		z, no_collision
			;jr		c, no_collision
			jp 		m, no_collision

				;Comprobamos lado DERECHO en el eje X
				;posX_1 + sizeX_1 - hero_x <= 0
				ld 		a, (hero_x)
				ld 		c, a

				ld 		a, (posX_1)
				ld 		b, a

				ld 		a, (sizeX_1)
				add 	a, b
				sub 	c

				;jr 		z, no_collision
				;jr		c, no_collision
				jp 		m, no_collision

					;Sillega aqui es porque colisiona,
					;cargamos en el registro A un valor
					; para poder evaluar desde fuera si colisiona
					ld 		a, #1
					ld 		hl, #0xC050
					ld 		(hl), #0xF0
					jp 		end


	no_collision:
		ld 		a, #0
		ld 		hl, #0xC050
		ld 		(hl), #0xFF

	end:
	ret