.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "buffer.h.s"

defineEnemy enemy , 8, 16, 0
defineEnemy enemy2, 8, 16, 0
defineEnemy enemy3, 8, 16, 0
defineEnemy enemy4, 8, 16, 1

enemyTime: .db #40
enemyHigh: .db #13
enemyAnimation: .db #0
enemyAnimationTimer: .db #0

.globl _sprite_enemy31
.globl _sprite_enemy32
.globl _sprite_enemy33
.globl _sprite_enemy34

.area _CODE
drawEnemy::
	ld 		ix, #enemy_data
	drawEnemyBucle:
		ld 		a, enemy_alive(ix) 			;Check if the shot is alive
		cp 		#0
		jr		z, jumpNextEnemyDraw
			ld 		a, (buffer_start)
			ld 		d, a
			ld 		e, #0x00
			ld 		c, enemy_x(ix)
			ld 		b, enemy_y(ix)
			call 	cpct_getScreenPtr_asm

			ex 		de, hl
			;ld 		a, (enemyAnimation)
			ld 		a, enemy_sprite(ix)
			cp 		#0
			jr 		z, Enemy1Draw
				cp 		#1
				jr 		z, Enemy2Draw
					cp 		#2
					jr 		z, Enemy3Draw
						cp 		#3
						jr 		z, Enemy4Draw
							cp 		#4
							jr 		z, Enemy5Draw
			Enemy1Draw:
				ld 		hl, #_sprite_enemy31
				jp 		continueEnemyDraw
			Enemy2Draw:
				ld 		hl, #_sprite_enemy32
				jp 		continueEnemyDraw
			Enemy3Draw:
				ld 		hl, #_sprite_enemy33
				jp 		continueEnemyDraw
			Enemy4Draw:
				ld 		hl, #_sprite_enemy32
				jp 		continueEnemyDraw
			Enemy5Draw:
				ld 		hl, #_sprite_enemy34
			continueEnemyDraw:
				ld 		b, enemy_h(ix)
				ld 		c, enemy_w(ix)

				call 	cpct_drawSprite_asm 
		jumpNextEnemyDraw:
			ld 		a, enemy_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #9
				add 	ix, bc
				jr 		drawEnemyBucle
eraseEnemy::
	ld 		ix, #enemy_data
	eraseEnemyBucle:
		ld 		a, enemy_alive(ix) 			;Check if the shot is alive
		cp 		#0
		jr		z, jumpNextEnemyErase
			ld 		a, (buffer_start)
			ld 		d, a
			ld 		e, #0x00
			ld 		c, enemy_SX(ix)
			ld 		b, enemy_y(ix)
			call 	cpct_getScreenPtr_asm

			ex 		de, hl

			ld 		b, enemy_h(ix)
			ld 		c, enemy_w(ix)

			ld 		a, #0x00
			call 	cpct_drawSolidBox_asm

		jumpNextEnemyErase:
			ld 		a, enemy_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #9
				add 	ix, bc
				jr 		eraseEnemyBucle
updateEnemy::
	ld 		iy, #enemy_data
	updateEnemyBucle:
		ld 		a, enemy_alive(iy)
		cp 		#0
		jr 		z, jumpNextEnemyUpdate
			;Haz cosas
			ld 		a, enemy_x(iy)
			cp 		#4
			jr 		z, destroyEnemy

				ld 		enemy_SX(iy), a
				dec 	enemy_x(iy)
				;jr 		jumpNextEnemyUpdate
				ld 		a, enemy_sprite(iy)
				cp 		#4
				jr 		z, swap1
					inc 	enemy_sprite(iy)
					jr 		jumpNextEnemyUpdate
				swap1:
				ld 		a, #0
				ld 		enemy_sprite(iy), a
				jr 		jumpNextEnemyUpdate
			destroyEnemy:
			ld 		a, #0
			ld 		enemy_alive(iy), a
			ld 		a, enemy_x(iy)
			ld 		enemy_SX(iy), a
			call 	eraseEnemyMark
		jumpNextEnemyUpdate:
			ld 		a, enemy_last(iy)
			cp 		#1
			ret 	z
				ld 		bc, #9
				add 	iy, bc
				jr 		updateEnemyBucle
checkEnemy::
	ld 		a, (enemyTime)
	dec 	a
	cp 		#0
	jr 		z, activateEnemy
		ld 		(enemyTime), a
		jr 		quitCheckEnemy
		activateEnemy:
		ld 		ix, #enemy_data
		activateBucle:
		ld 		a, enemy_alive(ix)
		cp 		#1
		jr 		z, jumpNextEnemyCheck
			ld 		a, #1
			ld 		enemy_alive(ix), a
			ld 		a, #72
			ld 		enemy_x(ix), a
			ld 		a, (enemyHigh)
			ld 		enemy_y(ix), a
			;NECESARIO?¿
			ld 		enemy_SY(ix), a
			ld 		a, #40
			ld 		(enemyTime), a
			jr 		quitCheckEnemy
		jumpNextEnemyCheck:
			ld 		a, enemy_last(ix)
			cp 		#1
			jr 		z, forceRestart
				ld 		bc, #9
				add 	ix, bc
				jr 		activateBucle
		forceRestart:
			ld 		a, #40
			ld 		(enemyTime), a
	quitCheckEnemy:
	ret
enemyPtrX::
	ld 		ix, #enemy_data
	ret
enemyPtrY::
	ld 		iy, #enemy_data
	ret
checkTimer::
	ld 		a, (enemyHigh)
	inc 	a
	cp 		#200-64
	jr 		nz, quitTimer
		ld 		a, #13
	
	quitTimer:
	ld 		(enemyHigh), a
	ret
checkAnimationTimer::
	ld 		a, (enemyAnimationTimer)
	inc 	a
	cp 		#5
	jr 		nz, quitAnimationTimer
		ld 		a, (enemyAnimation)
		inc 	a
		ld 		(enemyAnimation), a
		ld 		a, #0
	quitAnimationTimer:
		ld 		(enemyAnimationTimer), a
	ret

eraseEnemyMark::
		ld 		a, (buffer_start)
		cp 		#0xC0
		jr 		z, erase80
			ld 		d, #0xC0
			jr 		continueEraseMark
		erase80:
		ld 		d, #0x80
		continueEraseMark:
		ld 		e, #0x00
		ld 		c, enemy_SX(iy)
		ld 		b, enemy_y(iy)

		call 	cpct_getScreenPtr_asm

		ex 		de, hl

		ld 		b, enemy_h(iy)
		ld 		c, enemy_w(iy)

		ld 		a, #0x00
		call 	cpct_drawSolidBox_asm
	ret