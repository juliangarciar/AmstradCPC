.area _DATA
.include "shortcuts.h.s"
.include "cpctelera.h.s"
.include "buffer.h.s"
.include "mainMode.h.s"

defineBoss boss 62, 50, 16, 32, 1

.globl _sprite_boss1
.globl _sprite_boss2

boss_life:  		 .db #50
boss_mov: 			 .db #0
boss_time_animation: .db #5
boss_time_action:	 .db #10
action: 			 .db #0
.area _CODE
drawBoss::
	ld 		ix, #boss_data
	ld 		a, boss_alive(ix)
	cp 		#0
	jr 		z, quitDrawBoss
		ld 		a, (buffer_start)
		ld 		d, a
		ld 		e, #0x00
		ld 		c, boss_x(ix)
		ld 		b, boss_y(ix)
		call 	cpct_getScreenPtr_asm

		ex 		de, hl
		ld 		a, boss_sprite(ix)
		cp 		#0
		jr 		z, drawBoss1
			ld 		hl, #_sprite_boss2
			jr 		continueBossDraw
		drawBoss1:
		ld 		hl, #_sprite_boss1
		;SELECT SPRITE
		continueBossDraw:
		ld 		b, boss_h(ix)
		ld 		c, boss_w(ix)
		call 	cpct_drawSprite_asm
	quitDrawBoss:
	ret
eraseBoss::
	ld 		ix, #boss_data
	eraseBossBucle:
		ld 		a, (buffer_start)
		ld 		d, a
		ld 		e, #0x00
		ld 		c, boss_SX(ix)
		ld 		b, boss_SY(ix)
		call 	cpct_getScreenPtr_asm

		ex 		de, hl

		ld 		b, boss_h(ix)
		ld 		c, boss_w(ix)

		ld 		a, #0x00
		call 	cpct_drawSolidBox_asm
	ret
	
updateBoss::
	ld 		ix, #boss_data
	ld 		a, boss_x(ix)
	ld 		boss_SX(ix), a
	ld 		a, boss_y(ix)
	ld 		boss_SY(ix), a
	;ld 		a, (action)
	;cp 		#4
	;jr 		z, jumpAction
	;	doAction:
	;	ld 		a, boss_x(ix)
	;	cp 		#0
	;	jr 		nz, continueAction
;
;	;		continueAction:
;	;		;THINGS
;	;		dec 	boss_x(ix)
	;		jr 		quitUpdateBoss
		jumpAction:
		ld 		a, (boss_mov)
		cp 		#0
		jr 		z, moveTop
		moveBot:
		inc 	boss_y(ix)
		jr 		continueBossUpdate
		moveTop:
		dec		boss_y(ix)
		continueBossUpdate:
		ld 		a, boss_y(ix)
		cp 		#0
		jr 		z, swapModeBoss
			cp 		#120
			jr 		z, swapModeBoss
			ret
		swapModeBoss:
		ld 		a, (boss_mov)
		cp 		#0
		jr 		nz, swapTo0
			ld 		a, #1
			ld 		(boss_mov), a
			jr 		quitUpdateBoss
		swapTo0:
		ld 		a, #0
		ld 		(boss_mov), a
		quitUpdateBoss:
	ret

bossPtrX::
	ld 		ix, #boss_data
	ret
bossPtrY::
	ld 		iy, #boss_data
	ret

eraseBossMark::
		ld 		a, (buffer_start)
		cp 		#0xC0
		jr 		z, eraseBoss80
			ld 		d, #0xC0
			jr 		continueEraseBossMark
		eraseBoss80:
		ld 		d, #0x80
		continueEraseBossMark:
		ld 		e, #0x00
		ld 		c, boss_SX(iy)
		ld 		b, boss_SY(iy)

		call 	cpct_getScreenPtr_asm

		ex 		de, hl

		ld 		b, boss_h(iy)
		ld 		c, boss_w(iy)

		ld 		a, #0x00
		call 	cpct_drawSolidBox_asm

		call 	swapGameMode

	ret
checkBossAnimationTimer::
	ld 		ix, #boss_data
	ld 		a, (boss_time_animation)
	dec 	a
	cp 		#0
	jr 		z, swapBossAnimation
		ld 		(boss_time_animation), a
		jr 		quitAnimationTimer
	swapBossAnimation:
		ld 		a, boss_sprite(ix)
		cp 		#0
		jr 		z, swapBoss1
		swapBoss0:
			dec 	boss_sprite(ix)
			ld 		a, #5
			ld 		(boss_time_animation), a
			jr 		quitAnimationTimer
		swapBoss1:	
			inc 	boss_sprite(ix)
			ld 		a, #5
			ld 		(boss_time_animation), a
	quitAnimationTimer:
	ret
checkBossTimer::
ld 		a, (action)
cp 		#0
jr 		nz, quitBossTimer
	ld 		a, (boss_time_action)
	dec 	a
	cp 		#0
	jr 		z, activateActionBoss
		ld 		(boss_time_action), a
		jr 		quitBossTimer
	activateActionBoss:
		;ld 		a, #10
		;ld 		(boss_time_action), a
		ld 		a, #1
		ld 		(action), a
	quitBossTimer:
	ret
initBoss::
		ld 		ix, #boss_data
		ld 		a, #10
		ld 		boss_alive(ix), a
	ret
killBoss::
	ret