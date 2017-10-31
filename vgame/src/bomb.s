.area _DATA
.include "enemy.h.s"
.include "hero.h.s"
.include "hud.h.s"
.include "cpctelera.h.s"
.include "shortcuts.h.s"

bomb_timer: 	.db #5
.area _CODE

useBomb::
	call 	heroPtrX
	ld 		a, hero_bombs(ix)
	cp 		#0
	jr 		z, quitUseBomb
		ld 		a, (bomb_timer)
		cp 		#0
		jr 		nz, quitUseBomb
			ld 		a, #5
			ld 		(bomb_timer), a
			dec 	hero_bombs(ix)
			call 	updateBomb
			call 	killAll
	quitUseBomb:
	ret

checkBomb::
	ld 		a, (bomb_timer)
	cp 		#0
	jr 		z, quitCheckBomb
		dec 	a
		ld 		(bomb_timer), a
	quitCheckBomb:
	ret
