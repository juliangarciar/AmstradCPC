.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "shot.h.s"
.include "hero.h.s"
<<<<<<< HEAD
.include "cpctelera.h.s"

.area _CODE

=======

defineBale bale, 0, 0, 0, 2  
;defineBale bale
>>>>>>> 4ce86099fc91bc12d3cd41cbc840d09c4bd6b085

; ======= Variables bala ============
;; Lo ponemos a 0 para luego ir modificandola
;; en funcion de la posicion del heroe
;bale_x:   .db #0 
;bale_y:   .db #0
;alive:    .db #0 ;; (0 o 1) en funcion de si esta activada o no la bala
;dir_bale: .db #0 ;; (0, 1, 2) variable que controla la direccion de la bala 

<<<<<<< HEAD
check_shot::

=======
check_shot:
	call balePtr
	
>>>>>>> 4ce86099fc91bc12d3cd41cbc840d09c4bd6b085
	;; Recogemos y guardamos el valor de a en b, que en este caso es
	;; la direcion de la bala (dir_bale)
	;ld   b, a
	;;cp   #0
	;;jr   z, not_check
	ld   a, bale_a(ix) 
	cp   #1
	jr   z,  not_check
 		
 		;;CARGAMOS POSCIONES DEL HEROE EN LA BALA
 		call heroPtrY
		;ld 	b, hero_x(iy)
		;ld 	c, hero_y(iy)

		;ld 	bale_x(ix), hero_x(iy)
		;ld 	bale_y(ix), hero_y(iy)
		ld 	a, hero_dir(iy)
		ld  bale_bd(ix), a
		;; Si no hay bala, activamos la bala y asignamos la posicion
		;; del heroe a la posicion de la bala
		;;ld   a, #1
		;;ld   (alive), a

		;ld   bale_bd(ix), a ;; Actualizamos la direccion de la bala segun lo almacenado en b
		ld 	  a, bale_bd(ix)
		dec   a ;; dec a
		;;cp   #1
		jp   z, correcionIzq
		dec  a ;; dec a
		;;cp   #2
		jp   z, correccionDcha

		;; Cambiamos la direccion de la bala a derecha para que empiece
		;; a disparar hacia esa direccion.

		;;jr   not_check   
			
			;; Funciones que son correciones para que las posiciones de
			;; de la bala empecen en la posicion que corresponde
			correcionIzq:
				ld   a, hero_x(iy)
				dec  a
				ld   bale_x(ix), a
				ld   a, hero_y(iy)
				ld   bale_y(ix), a

				;; (Bala activa) Actualizamos la vida de la bala 
				ld   a, #1
				ld   bale_a(ix), a

				ret

			correccionDcha:
				ld   a, hero_x(iy)
				add  a, #2
				ld   bale_x(ix), a
				ld   a, hero_y(iy)
				ld   bale_y(ix), a
				;;ld   a, (hero_y)

				;; (Bala activa) Actualizamos la vida de la bala 
				ld   a, #1
				ld   bale_a(ix), a

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
	call balePtr
	;; Comprobar primero si esta alive la bala
	ld   a, bale_a(ix)
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
	call balePtr

	ld   a, bale_bd(ix)
	;;cp   #0
	;;jp   z, no_move
		;;dec  a
		ld   a, bale_bd(ix)
		cp   #1
		jp   z, left
		;;dec  a
		;;ld   a, (dir_bale)
		cp   #2
		jp   z, right

		cp   #3
		jp   z, top

	;;ld   a, #0
	;;ld   (dir_bale), a

		left:
			dec bale_x(ix)

		ret

		right:
			inc bale_x(ix)

		ret

		top:
			dec bale_y(ix)

		ret

	no_move:

	ret

erase_bale:
	call balePtr

	ld 		de, #0xC000
	ld 		a, bale_x(ix)
	ld 		c, a
	ld 		a, bale_y(ix)
	ld 		b, a
	call 	cpct_getScreenPtr_asm

	ex		de, hl
	ld      a, #0x00  ;; color
	ld		bc, #0x0201
	call 	cpct_drawSolidBox_asm

	ret


draw_bale:
	call balePtr
	ld   a, bale_a(ix)
	cp   #0
	jr   z, not_draw

		ld 		de, #0xC000
		ld 		a, bale_x(ix)
		ld 		c, a
		ld 		a, bale_y(ix)
		ld 		b, a
		call 	cpct_getScreenPtr_asm

		ex		de, hl
		ld      a, #0xF0  ;; color
		ld		bc, #0x0201
		call 	cpct_drawSolidBox_asm
	not_draw:
	ret


checkBorders:
	call balePtr

	;; Comprobamos los bordes de la pantalla para que cuando la bala alcance los limites
	;; de la pantalla, se ponga la bala a 0 y se restaure su posicion x e y
	ld		a, bale_x(ix)
	cp 		#80-2
	jp 		z, outside

	ld		a, bale_x(ix)
	cp 		#0
	jp		z, outside
	
	ld		a, bale_y(ix)
	cp 		#0
	jp		z, outside
	
	ret

outside:
	call balePtr

	;; Ponemos la vida de la bala a 0, cuando ha llegado al limite de la pantalla
	ld   a, bale_a(ix)
	dec  a
	ld   bale_a(ix), a
	
	;; Borramos la bala cuando ya ha llegado al limite de la pantalla  
	call erase_bale
	ld   a, #0
	ld   bale_x(ix), a
	ld   a, #0
	ld   bale_y(ix), a
	;;ld   a, #1

	;; Dejamos la ultima direccion en la que se ha quedado la bala,
	;; para que se mantenga ahi, por lo que no la modificamos
	ret

balePtr::
		ld   ix, #bale_data
	ret

