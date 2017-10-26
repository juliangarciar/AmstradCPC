.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"

defineEnemy enemy, 8, 16, 0
defineEnemy enemy2, 8, 16, 0
defineEnemy enemy3, 8, 16, 0
defineEnemy enemy4, 8, 16, 1

enemyTime: .db #40
enemyHigh: .db #13

.globl _sprite_enemy1
.area _CODE
drawEnemy::
	ld 		ix, #enemy_data
	drawEnemyBucle:
		ld 		a, enemy_alive(ix) 			;Check if the shot is alive
		cp 		#0
		jr		z, jumpNextEnemyDraw
			ld 		de, #0xC000
			ld 		c, enemy_x(ix)
			ld 		b, enemy_y(ix)
			call 	cpct_getScreenPtr_asm

			ex 		de, hl
			ld 		a, enemy_sprite(ix)
			cp 		#0
			jr 		z, Enemy1Draw
				cp 		#1
				jr 		z, Enemy2Draw
					cp 		#2
					jr 		z, Enemy3Draw
			Enemy1Draw:
				ld 		hl, #_sprite_enemy1
				jp 		continueEnemyDraw
			Enemy2Draw:
				ld 		hl, #_sprite_enemy1
				jp 		continueEnemyDraw
			Enemy3Draw:
				ld 		hl, #_sprite_enemy1
			continueEnemyDraw:
				ld 		b, enemy_h(ix)
				ld 		c, enemy_w(ix)

				call 	cpct_drawSprite_asm 
		jumpNextEnemyDraw:
			ld 		a, enemy_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #7
				add 	ix, bc
				jr 		drawEnemyBucle
eraseEnemy::
	ld 		ix, #enemy_data
	eraseEnemyBucle:
		ld 		a, enemy_alive(ix) 			;Check if the shot is alive
		cp 		#0
		jr		z, jumpNextEnemyErase
			ld 		de, #0xC000
			ld 		c, enemy_x(ix)
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
				ld 		bc, #7
				add 	ix, bc
				jr 		eraseEnemyBucle
updateEnemy::
	ld 		ix, #enemy_data
	updateEnemyBucle:
		ld 		a, enemy_alive(ix)
		cp 		#0
		jr 		z, jumpNextEnemyUpdate
			;Haz cosas
			ld 		a, enemy_x(ix)
			cp 		#4
			jr 		z, destroyEnemy

				dec 	enemy_x(ix)
				ld 		a, enemy_sprite(ix)
				cp 		#2
				jr 		z, swap1
					inc 	enemy_sprite(ix)
					jr 		jumpNextEnemyUpdate
				swap1:
				ld 		a, #0
				ld 		enemy_sprite(ix), a
				jr 		jumpNextEnemyUpdate
			destroyEnemy:
			ld 		a, #0
			ld 		enemy_alive(ix), a
		jumpNextEnemyUpdate:
			ld 		a, enemy_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #7
				add 	ix, bc
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
			ld 		a, #40
			ld 		(enemyTime), a
			jr 		quitCheckEnemy
		jumpNextEnemyCheck:
			ld 		a, enemy_last(ix)
			cp 		#1
			jr 		z, forceRestart
				ld 		bc, #7
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
	cp 		#180
	jr 		nz, quitTimer
		ld 		a, #13
	
	quitTimer:
	ld 		(enemyHigh), a
	ret