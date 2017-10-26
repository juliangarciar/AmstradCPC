.area _DATA
	;==================
	; CONTROL DATA
	;==================
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "hero.h.s"
.include "shot.h.s"
.include "keyboard/keyboard.s"

shotTime: .db #8

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
;MOVE SHIP RIGHT
moveHeroRight:
	call 	heroPtrX

	ld 		a, hero_x(ix)	; ld a, (heroX)
	cp 		#80-4 			;Right limit
	ret 	z  				;hero_x = limite pantalla dcha, no mover
		
		inc 	hero_x(ix)
		ld 		a, #0
		ld 		hero_sprite(ix), a
	ret
;MOVE SHIP LEFT
moveHeroLeft:
	call 	heroPtrX

	ld 		a, hero_x(ix)
	cp 		#8				;Left limit
	ret 	z				;hero_x = limite pantalla izda

		dec 	hero_x(ix)	
		ld 		a, #0
		ld 		hero_sprite(ix), a

	ret
;MOVE SHIP UP
moveHeroUp:
	call 	heroPtrX

	ld 		a, hero_y(ix)
	cp 		#20				;Upper limit
	ret 	z				;hero_x = limite pantalla izda

		ld 		a, hero_y(ix)
		add 	a, #-4
		ld 		hero_y(ix), a
		ld 		a, #1
		ld 		hero_sprite(ix), a
	ret
;MOVE SHIP DOWN
moveHeroDown:
	call 	heroPtrX

	ld 		a, hero_y(ix)
	cp 		#180			;Bottom limit
	ret 	z				;hero_x = limite pantalla izda

		ld 		a, hero_y(ix)
		add 	a, #4
		ld 		hero_y(ix), a
		ld 		a, #2
		ld 		hero_sprite(ix), a
	ret

	;================================
	;   COMPROBAR TECLAS PULSADAS
	;================================

checkUserInput::
	;TECLA D

	
	ld 		hl, #Key_D
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, rightNotPressed

			;ELSE MOVE RIGHT
			call 	moveHeroRight

	rightNotPressed:

	;TECLA A

	ld 		hl, #Key_A
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, leftNotPressed

			;ELSE MOVE LEFT 
			call 	moveHeroLeft

	leftNotPressed:

	;TECLA W

	ld 		hl, #Key_W
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, upNotPressed

			;Else move up
			call 	moveHeroUp

	upNotPressed:

	;TECLA S

	ld 		hl, #Key_S
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, downNotPressed

			;Else move down
			call 	moveHeroDown

	downNotPressed:

	;TECLA P

	ld 		hl, #Key_P
	call 	cpct_isKeyPressed_asm
	cp 		#0
	jr 		z, shotNotPressed

			;Else move down
			ld 		a, (shotTime)
			cp 		#0
			jr 		nz, shotNotPressed
			call 	checkShot
			ld 		a, #8
			ld 		(shotTime), a

	shotNotPressed:
	;call 	heroPtrX
	;ld 		a, #0
	;ld 		hero_sprite(ix), a
		ret

	checkShotTime::
		ld 		a, (shotTime)
		cp 		#0
		jr 		z, quitCheckShotTime
			dec 	a
			ld 		(shotTime), a
		quitCheckShotTime:
		ret