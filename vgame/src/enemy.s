.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "buffer.h.s"
.include "mainMode.h.s"
.include "hud.h.s"

defineEnemy enemy , 8, 16, 0, 2
defineEnemy enemy2, 8, 16, 0, 1
defineEnemy enemy3, 8, 16, 0, 2
defineEnemy enemy4, 8, 16, 0, 1
defineEnemy enemy5, 8, 16, 1, 2
;defineEnemy enemy6, 8, 16, 0, 1

enemyTime: .db #10
enemyHigh: .db #0

.globl _sprite_enemy31
.globl _sprite_enemy32
.globl _sprite_enemy33
.globl _sprite_enemy34

.globl _sprite_enemy21
.globl _sprite_enemy22
.globl _sprite_enemy23
.globl _sprite_enemy24

.area _CODE
drawEnemy::
	ld 		ix, #enemy_data
	drawEnemyBucle:
		ld 		a, enemy_alive(ix) 			
		cp 		#0
		jp		z, jumpNextEnemyDraw
			ld 		a, (buffer_start)
			ld 		d, a
			ld 		e, #0x00
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
						cp 		#3
						jr 		z, Enemy4Draw
							;cp 		#4
							;jr 		z, Enemy5Draw
			Enemy5Draw:
				ld 		a, enemy_max(ix)
				cp 		#1
				jr   	z, Draw5Type1
					ld 		hl, #_sprite_enemy34
					jr 		continueEnemyDraw
				Draw5Type1:
				ld 		hl, #_sprite_enemy24
				jr 		continueEnemyDraw

			Enemy1Draw:
				ld 		a, enemy_max(ix)
				cp 		#1
				jr   	z, Draw1Type1
					ld 		hl, #_sprite_enemy31
					jr 		continueEnemyDraw
				Draw1Type1:
				ld 		hl, #_sprite_enemy21
				jr 		continueEnemyDraw

			Enemy2Draw:
				ld 		a, enemy_max(ix)
				cp 		#1
				jr   	z, Draw2Type1
					ld 		hl, #_sprite_enemy32
					jr 		continueEnemyDraw
				Draw2Type1:
				ld 		hl, #_sprite_enemy22
				jr 		continueEnemyDraw

			Enemy3Draw:
				ld 		a, enemy_max(ix)
				cp 		#1
				jr   	z, Draw3Type1
					ld 		hl, #_sprite_enemy33
					jr 		continueEnemyDraw
				Draw3Type1:
				ld 		hl, #_sprite_enemy23
				jr 		continueEnemyDraw

			Enemy4Draw:
				ld 		a, enemy_max(ix)
				cp 		#1
				jr   	z, Draw4Type1
					ld 		hl, #_sprite_enemy32
					jr 		continueEnemyDraw
				Draw4Type1:
				ld 		hl, #_sprite_enemy22
				;jr 		continueEnemyDraw
			
			continueEnemyDraw:
				ld 		b, enemy_h(ix)
				ld 		c, enemy_w(ix)

				call 	cpct_drawSprite_asm 
		jumpNextEnemyDraw:
			ld 		a, enemy_last(ix)
			cp 		#1
			ret 	z
				ld 		bc, #11
				add 	ix, bc
				jp 		drawEnemyBucle
eraseEnemy::
	ld 		ix, #enemy_data
	eraseEnemyBucle:
		ld 		a, enemy_alive(ix) 			
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
				ld 		bc, #11
				add 	ix, bc
				jr 		eraseEnemyBucle
updateEnemy::
	ld 		iy, #enemy_data
	updateEnemyBucle:
		ld 		a, enemy_alive(iy)			;Check if the enemy is alive
		cp 		#0							;if(yes) then continue update
		jr 		z, jumpNextEnemyUpdate		;else load next enemy

			ld 		a, enemy_x(iy)			;Check if the enemy is on the limit screen
			cp 		#4						;if(yes) then continue update
			jp 		m, destroyEnemy			;else detroy it

			ld 		a, enemy_x(iy)
			ld 		enemy_SX(iy), a

			ld 		a, enemy_timer(iy) 		;Check if the enemy timer is active
			cp 		#0  					;if(yes) then continue update
			jr 		z, updateContinue 		;else load next enemy
				dec 	enemy_timer(iy)
				jr 		jumpNextEnemyUpdate
			updateContinue:
				inc 	enemy_timer(iy)
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
				ld 		a, (totalLeaks)
				dec 	a
				ld 		(totalLeaks), a
				call 	updateLeaks
				call 	eraseEnemyMark
		jumpNextEnemyUpdate:
			ld 		a, enemy_last(iy)
			cp 		#1
			ret 	z
				ld 		bc, #11
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
		cp 		#0
		jr 		nz, jumpNextEnemyCheck
			ld 		a, enemy_max(ix)
			ld 		enemy_alive(ix), a
			ld 		a, #72
			ld 		enemy_x(ix), a
			ld 		a, (enemyHigh)
			ld 		enemy_y(ix), a
			;NECESARIO?¿
			;ld 		enemy_SY(ix), a
			ld 		a, #10
			ld 		(enemyTime), a
			jr 		quitCheckEnemy
		jumpNextEnemyCheck:
			ld 		a, enemy_last(ix)
			cp 		#1
			jr 		z, forceRestart
				ld 		bc, #11
				add 	ix, bc
				jr 		activateBucle
		forceRestart:
			ld 		a, #10
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
	ld 		a, #4
	ld 		b, a
	ld 		a, (enemyHigh)
	add 	a, b
	cp 		#200-64
	jr 		nz, quitTimer
		ld 		a, #0
	quitTimer:
	ld 		(enemyHigh), a
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

killAll::
	call 	enemyPtrY
	killBucle:
	ld 		a, enemy_alive(iy)
	cp 		#0
	jr 		z, nextEnemyKill
		
		ld 		a, #0
		ld 		enemy_alive(iy), a
		call 	eraseEnemyMark
		ld 		a, (totalKills)
		cp 		#40
		jr 		z, nextEnemyKill
			inc 	a
			ld 		(totalKills), a
	nextEnemyKill:
		ld 		a, obs_l(iy)
		cp 		#1
		jr 		nz, repeatKill
		ld 		a, #80
		ld 		(enemyTime), a
	ret

	repeatKill:
		ld 		bc, #11
		add 	iy, bc
		jr		killBucle
	
initEnemies::
	ld 		ix, #enemy_data
	initEnemiesBucle:
	ld 		a, #0
	ld 		enemy_alive(ix), a
	ld 		(enemyHigh), a
	ld 		a, #10
	ld 		(enemyTime), a
	ld 		a, enemy_last(ix)
	cp 		#0
	jr 		z, quitInitEnemies
		ld 		bc, #11
		add 	iy, bc
		jr		initEnemiesBucle
	quitInitEnemies:
	ret