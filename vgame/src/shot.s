.area _DATA
.include "shortcuts.h.s"
.include "shot.h.s"
.include "hero.h.s"
.include "cpctelera.h.s"

.area _CODE


; ======= Variables bala ============
;; Lo ponemos a 0 para luego ir modificandola
;; en funcion de la posicion del heroe
bale_x:   .db #0 
bale_y:   .db #0
alive:    .db #0 ;; (0 o 1) en funcion de si esta activada o no la bala
dir_bale: .db #0 ;; (0, 1, 2) variable que controla la direccion de la bala 

check_shot::

	;; Recogemos y guardamos el valor de a en b, que en este caso es
	;; la direcion de la bala (dir_bale)
	ld   b, a
	;;cp   #0
	;;jr   z, not_check
	ld   a, (alive)
	cp   #1
	jr   z,  not_check
 
		;; Si no hay bala, activamos la bala y asignamos la posicion
		;; del heroe a la posicion de la bala
		;;ld   a, #1
		;;ld   (alive), a

		ld   a, b
		ld   (dir_bale), a ;; Actualizamos la direccion de la bala segun lo almacenado en b
		dec   a ;; dec a
		;;cp   #1
		jp   z, correcionIzq
		dec  a ;; dec a
		;;cp   #2
		jp   z, correccionDcha

		;; Cambiamos la direccion de la bala a derecha para que empiece
		;; a disparar hacia esa direccion.
		ld   a, #2
		ld   (dir_bale), a 
		;;jr   not_check   
			
			;; Funciones que son correciones para que las posiciones de
			;; de la bala empecen en la posicion que corresponde
			correcionIzq:
				ld   a, hero_x(ix)
				dec  a
				ld   (bale_x), a
				ld   a, hero_y(ix)
				ld   (bale_y), a

				;; (Bala activa) Actualizamos la vida de la bala 
				ld   a, #1
				ld   (alive), a

				ret

			correccionDcha:
				ld   a, hero_x(ix)
				add  a, #2
				ld   (bale_x), a
				ld   a, hero_y(ix)
				ld   (bale_y), a
				;;ld   a, (hero_y)

				;; (Bala activa) Actualizamos la vida de la bala 
				ld   a, #1
				ld   (alive), a

				ret


		;;ld   a, #1
		;;ld   (alive), a ;; (Bala activa) Actualizamos la vida de la bala

		;; Actualizamos la posicion de la bala en funcion de la
		;; posicion del heroe
		;;ld   b, a
		;;ld   a, (hero_x)
		;;ld   (bale_x), a
		;;ld   b, (hero_y)
		;;ld   (bale_y), b

	not_check:

	ret

shot_update:: 

	;; Comprobar primero si esta alive la bala
	ld   a, (alive)
	cp   #0
	jr   z, not_update 
			
		;; Si la direccion es 2, se incrementa la posicion de la bala 
		;; a la derecha
		;;ld   a, (bale_x)
		call erase_bale

		call checkBorders

		call move_dir  ;; Para indicar la direcion de la bala
		call draw_bale


	not_update:

	ret

;; Funcion para comprobar las direccion de la bala e
;; incrementar su poscion en funcion de la direccion (izquierda o derecha)
move_dir: ;; Cambiar esta parte poniendo cp y comprobando que nuero es para ir a izq, o dcha
	
	ld   a, (dir_bale)
	;;cp   #0
	;;jp   z, no_move
		;;dec  a
		ld   a, (dir_bale)
		cp   #1
		jp   z, left
		;;dec  a
		;;ld   a, (dir_bale)
		cp   #2
		jp   z, right

	;;ld   a, #0
	;;ld   (dir_bale), a

		left:
			ld   a, (bale_x)
			dec  a
			ld   (bale_x), a
		ret

		right:
			ld   a, (bale_x)
			inc  a
			ld   (bale_x), a
		ret

	no_move:

	ret

erase_bale:

	ld 		de, #0xC000
	ld 		a, (bale_x)
	ld 		c, a
	ld 		a, (bale_y)
	ld 		b, a
	call 	cpct_getScreenPtr_asm

	ex		de, hl
	ld      a, #0x00  ;; color
	ld		bc, #0x0201
	call 	cpct_drawSolidBox_asm

	ret


draw_bale:

	ld 		de, #0xC000
	ld 		a, (bale_x)
	ld 		c, a
	ld 		a, (bale_y)
	ld 		b, a
	call 	cpct_getScreenPtr_asm

	ex		de, hl
	ld      a, #0xF0  ;; color
	ld		bc, #0x0201
	call 	cpct_drawSolidBox_asm

	ret


checkBorders:
	;; Comprobamos los bordes de la pantalla para que cuando la bala alcance los limites
	;; de la pantalla, se ponga la bala a 0 y se restaure su posicion x e y
	ld		a, (bale_x)
	cp 		#80-2
	jp 		z, outside

	ld		a, (bale_x)
	cp 		#0
	jp		z, outside
	
	ret	
outside:
	;; Ponemos la vida de la bala a 0, cuando ha llegado al limite de la pantalla
	ld   a, (alive)
	dec  a
	ld   (alive), a
	
	;; Borramos la bala cuando ya ha llegado al limite de la pantalla  
	call erase_bale
	ld   a, #0
	ld   (bale_x), a
	ld   a, #0
	ld   (bale_y), a
	;;ld   a, #1

	;; Dejamos la ultima direccion en la que se ha quedado la bala,
	;; para que se mantenga ahi, por lo que no la modificamos
	ret