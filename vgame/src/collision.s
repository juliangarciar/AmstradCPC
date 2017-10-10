.area _DATA
.include "shortcuts.h.s"
.area _CODE
.include "cpctelera.h.s"
.include "hero.h.s"
.include "obstacle.h.s"
checkCollision::
	collisionBucle:
	call 	heroPtr
	call 	obsPtr
	;Evaluamos las condiciones para que no colisione
	;en caso contrario, colisionara
	;Comprobar el eje Y primero lado SUPERIOR, ya que es más probable que colisione
	;en el eje X

	;Cargamos posicion del obstaculo_y
	;la guardamos en el almacen c
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
	jp 		m, no_collision

		;Comprobamos colision por el otro lado ABAJO
		;posY_1 + sizeY_1 - hero_y <=0
		ld 		c, hero_y(ix)
		ld 		b, obs_y(iy)
		ld 		a, obs_h(iy)
		add 	a, b
		sub 	c

		jp 		m, no_collision

			;Si llegamos aqui, es porque colisiona en el eje Y
			;comprobamos ahora que ocurre en el eje X
			;lado IZQUIERDO
			;hero_x + hero_x_size - posX_1 <= 0
			ld 		c, obs_x(iy)
			ld 		b, hero_x(ix)
			ld 		a, hero_w(ix)
			add 	a, b
			sub 	c

			jp 		m, no_collision

				;Comprobamos lado DERECHO en el eje X
				;posX_1 + sizeX_1 - hero_x <= 0
				ld 		c, hero_x(ix)
				ld 		b, obs_x(iy)
				ld 		a, obs_w(iy)
				add 	a, b
				sub 	c

				jp 		m, no_collision

					;Sillega aqui es porque colisiona,
					;cargamos en el registro A un valor
					; para poder evaluar desde fuera si colisiona
					ld 		a, #1
					ld 		hl, #0xC050
					ld 		(hl), #0xF0
					jp 		end


	no_collision:
		
		ld 		hl, #0xC050
		ld 		(hl), #0xFF

		;DE AQUI PARA ABAJO ES UN POCO LOCURA PERO ES NECESARIO DE MOMENTO
		ld 		a, (obs_n)
		cp 		#1

		jr 		nz, redo2
		;TERMINA EL BUCLE Y REASIGNA EL VALOR DE N_OBS Y EL PUNTERO
			ld 		a, #3
			ld 		(obs_n), a
			ld 		a, #0
			ld 		(actual_ptr), a 

		;VALOR NECESARIO PARA SABER SI HA COLISIONADO
		ld 		a, #0
	ret

	;REASIGNA EL PUNTERO
	redo2:
		ld 		a, (obs_n)
		dec 	a
		ld 		(obs_n), a

		call 	obsPtrNext
		jr		collisionBucle

	end:
	ret