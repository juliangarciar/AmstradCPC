.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "hero.h.s"
.include "collision.h.s"
.include "buffer.h.s"

.globl	_sprite_hero1
.globl	_sprite_hero2

defineShot shot , 3, 5, 0
defineShot shot2, 3, 5, 0
defineShot shot3, 3, 5, 0
defineShot shot4, 3, 5, 0
defineShot shot5, 3, 5, 1
defineShot shot6, 3, 5, 0

.globl _sprite_def1
.globl _sprite_def2
.globl _sprite_def3

.area _CODE

drawShot::
	ld 		ix, #shot_data
	drawShotBucle:
		ld 		a, shot_alive(ix) 			;Check if the shot is alive
		cp 		#0
		jr		z, jumpNextShotDraw
			ld 		a, (buffer_start)
			ld 		d, a
			ld 		e, #0x00
			ld 		c, shot_x(ix)
			ld 		b, shot_y(ix)
			call 	cpct_getScreenPtr_asm

			ex 		de, hl
			ld 		a, shot_sprite(ix)
			cp 		#0
			jr 		z, Shot1Draw
				cp 		#1
				jr 		z, Shot2Draw
					cp 		#2
					jr 		z, Shot3Draw
			Shot1Draw:
				ld 		hl, #_sprite_def1
				jp 		continueShotDraw
			Shot2Draw:
				ld 		hl, #_sprite_def2
				jp 		continueShotDraw
			Shot3Draw:
				ld 		hl, #_sprite_def3
			continueShotDraw:
				ld 		b, shot_h(ix)
				ld 		c, shot_w(ix)

				call 	cpct_drawSprite_asm 
		jumpNextShotDraw:
			ld 		a, shot_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #9
				add 	ix, bc
				jr 		drawShotBucle
		ret
eraseShot::
	ld 		ix, #shot_data
	eraseShotBucle:
		ld 		a, shot_alive(ix) 			;Check if the shot is alive
		cp 		#0
		jr		z, jumpNextShotErase
			ld 		a, (buffer_start)
			ld 		d, a
			ld 		e, #0x00
			ld 		c, shot_SX(ix)
			ld 		b, shot_y(ix)
			call 	cpct_getScreenPtr_asm

			ex 		de, hl

			ld 		b, shot_h(ix)
			ld 		c, shot_w(ix)

			ld 		a, #0x00
			call 	cpct_drawSolidBox_asm

		jumpNextShotErase:
			ld 		a, shot_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #9
				add 	ix, bc
				jr 		eraseShotBucle
		ret
updateShot::
	ld 		ix, #shot_data
	updateShotBucle:
		ld 		a, shot_alive(ix)
		cp 		#0
		jr 		z, jumpNextShotUpdate
			;Haz cosas
			ld 		a, shot_x(ix)
			cp 		#80-4
			jr 		z, destroyShot
			cp 		#80-3
			jr 		z, destroyShot

			call 	checkCollision		;Check collisions
			cp 		#1					;
			jr 		z, destroyShot		;

				ld 		a, shot_x(ix)
				ld 		shot_SX(ix), a
				inc 	shot_x(ix)
				inc 	shot_x(ix)
				ld 		a, shot_sprite(ix)
				cp 		#2
				jr 		z, swap1
					inc 	a
					ld 		shot_sprite(ix), a
					jr 		jumpNextShotUpdate
				swap1:
				ld 		a, #0
				ld 		shot_sprite(ix), a
				jr 		jumpNextShotUpdate
			destroyShot:
			ld 		a, #0
			ld 		shot_alive(ix), a
			ld 		a, enemy_x(ix)
			ld 		enemy_SX(ix), a
			call 	eraseShotMark
		jumpNextShotUpdate:
			ld 		a, shot_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #9
				add 	ix, bc
				jr 		updateShotBucle
		ret
checkShot::
	ld 		ix, #shot_data
	checkShotBucle:
		ld 		a, shot_alive(ix)
		cp 		#1
		jr 		z, jumpNextShotCheck
			;haz cosas
			call 	heroPtrY
			ld 		a, #1
			ld 		shot_alive(ix), #1

			ld 		a, hero_x(iy)
			ld 		shot_x(ix), a
			ld 		shot_SX(ix), a
			ld 		a, hero_y(iy)
			ld 		shot_SY(ix), a
			add 	a, #4
			ld 		shot_y(ix), a
			
			ret
		jumpNextShotCheck:
			ld 		a, shot_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #9
				add 	ix, bc
				jr 		checkShotBucle
	ret
shotPtrX::
	ld 		ix, #shot_data
	ret
shotPtrY::
	ld 		iy, #shot_data
	ret
eraseShotMark::
		ld 		a, (buffer_start)
		cp 		#0xC0
		jr 		z, erase80
			ld 		d, #0xC0
			jr 		continueEraseMark
		erase80:
		ld 		d, #0x80
		continueEraseMark:
		ld 		e, #0x00
		ld 		c, shot_SX(ix)
		ld 		b, shot_y(ix)

		call 	cpct_getScreenPtr_asm

		ex 		de, hl

		ld 		b, shot_h(ix)
		ld 		c, shot_w(ix)

		ld 		a, #0x00
		call 	cpct_drawSolidBox_asm
	ret