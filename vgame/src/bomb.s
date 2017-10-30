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
		call 	killAll
		jr 		bombAnimation
bombAnimation:
	ret