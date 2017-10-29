.area _DATA
.include "enemy.h.s"
.include "hero.h.s"
.include "hud.h.s"
.include "cpctelera.h.s"
.include "shortcuts.h.s"
.area _CODE

useBomb::
	call 	heroPtrX
	ld 		a, hero_bombs(ix)
	cp 		#0
	ret 	z
		dec 	hero_bombs(ix)
		call 	updateBomb
		call 	enemyPtrY
	bombBucle:
	ld 		a, enemy_alive(iy)
	cp 		#0
	jr 		z, nextEnemy
		
		ld 		a, #0
		ld 		enemy_alive(iy), a
		call 	eraseEnemyMark
		
	nextEnemy:
		ld 		a, obs_l(iy)
		cp 		#1
		jr 		nz, repeatBomb
	ret

	repeatBomb:
		ld 		bc, #9
		add 	iy, bc
		jr		bombBucle