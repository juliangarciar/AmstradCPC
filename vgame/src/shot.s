.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "hero.h.s"
.include "collision.h.s"
.include "buffer.h.s"

defineShot shot , 3, 5, 0
defineShot shot2, 3, 5, 0
defineShot shot3, 3, 5, 0
defineShot shot4, 3, 5, 0
defineShot shot5, 3, 5, 1
defineShot shot6, 3, 5, 0

.globl _sprite_def1
.globl _sprite_def2
.globl _sprite_def3

shot_mode: .db #0
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

			Shot3Draw:
				ld 		hl, #_sprite_def3
				jr 		continueShotDraw
			Shot1Draw:
				ld 		hl, #_sprite_def1
				jr 		continueShotDraw
			Shot2Draw:
				ld 		hl, #_sprite_def2
				
			continueShotDraw:
				ld 		b, shot_h(ix)
				ld 		c, shot_w(ix)

				call 	cpct_drawSprite_asm 
		jumpNextShotDraw:
			ld 		a, shot_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #10
				add 	ix, bc
				jr 		drawShotBucle
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
				ld 		bc, #10
				add 	ix, bc
				jr 		eraseShotBucle
updateShot::
	ld 		ix, #shot_data
	updateShotBucle:
		ld 		a, shot_alive(ix) 			;Check if the shot is alive
		cp 		#0							;if(yes) then continue update
		jr 		z, jumpNextShotUpdate 		;else load next shot

			;WTF
			ld 		a, shot_x(ix) 			;Load shot position in X
			cp 		#80-4					;check if the shot is in the screen limit
			jp 		m, checkCollisions		;if(yes) then destroy it
				jr 		destroyShot		 	;else continue update

			checkCollisions:
				ld 		a, (shot_mode)
				cp 		#0 
				jr 		z, shot0
				shot1:
					call 	checkCollisionMode1
					jr 		collisionChecked
 			shot0:
 				call 	checkCollisionMode0		;Check if the shot collides with an enemy

 			collisionChecked:
			cp 		#1						;if(yes) then destroy the shot
			jr 		z, destroyShot			;else continue update 

				ld 		a, shot_x(ix) 			;Update last position
				ld 		shot_SX(ix), a 			;^

				ld 		a, shot_timer(ix) 		;Check if the timer is active
				cp 		#0 						;if(yes) then continue update 
				jr 		z, continueUpdateShot 	;else load next shot
 											
					dec 	shot_timer(ix) 			;Update shot timer
					jr 		jumpNextShotUpdate  	;load next shot
			continueUpdateShot:
				inc 	shot_timer(ix)
				ld 		a, shot_x(ix)
				add 	a, #4
				ld  	shot_x(ix), a

				ld 		a, shot_sprite(ix)
				cp 		#2
				jr 		z, swap1
					
					inc 	shot_sprite(ix)
					jr 		jumpNextShotUpdate
			swap1:
				ld 		a, #0
				ld 		shot_sprite(ix), a
				jr 		jumpNextShotUpdate
			
			destroyShot:
				dec 	shot_alive(ix)
				ld 		a, enemy_x(ix)
				ld 		enemy_SX(ix), a
				call 	eraseShotMark
		jumpNextShotUpdate:
			ld 		a, shot_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #10
				add 	ix, bc
				jr 		updateShotBucle
checkShot::
	ld 		ix, #shot_data
	checkShotBucle:
		ld 		a, shot_alive(ix)
		cp 		#1
		jr 		z, jumpNextShotCheck
			;haz cosas
			call 	heroPtrY
			
			inc 	shot_alive(ix)

			ld 		a, hero_x(iy)
			ld 		shot_x(ix), a
			ld 		shot_SX(ix), a

			ld 		a, hero_y(iy)
			add 	a, #4
			ld 		shot_y(ix), a
			
		ret
		jumpNextShotCheck:
			ld 		a, shot_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #10
				add 	ix, bc
				jr 		checkShotBucle
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
swapShotMode::
		ld 		a, (shot_mode)
		cp 		#0
		jr 		z, changeMode
			dec 	a
			ld 		(shot_mode), a
		ret
		changeMode:
			inc 	a
			ld 		(shot_mode), a
		ret

initShots::
	ld 		ix, #shot_data
	initShotsBucle:
	call 	eraseShot
	ld 		a, #0
	ld 		shot_alive(ix), a
	ld 		(shot_mode), a
	ld 		a, shot_last(ix)
	cp 		#1
	jr 		z, quitInitShot
		ld 		bc, #10
		add 	ix, bc
		jr 		initShotsBucle
	quitInitShot:
	ret