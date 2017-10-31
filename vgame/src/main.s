.area _DATA
;==================
; INCLUDE FUNCIONS
;==================
.include "cpctelera.h.s"
.include "control.h.s"
.include "hero.h.s"
.include "shot.h.s"
.include "enemy.h.s"
.include "map.h.s"
.include "buffer.h.s"
.include "hud.h.s"
.include "mainMode.h.s"
.include "boss.h.s"
.include "shortcuts.h.s"
.include "bomb.h.s"
.globl 	_sprite_palette
.globl _song_ingame

unavariable: .db #12
gameMode:: 	 .db #-1
totalKills:: .db #0
totalLeaks:: .db #9
.area _CODE
;WEIRD THING
restartGame::
	jp 		startGame
;========================
; 	INTERRUPTS
;
;========================
	isr:   
		ld 		a, (unavariable)
		dec 	a
		ld 		(unavariable), a
		jr 		nz, return

		ex 		af, af'
		exx
		push 	af
		push 	bc
		push 	de
		push 	hl
		push 	iy
		
			call 	cpct_akp_musicPlay_asm
			ld 		a, #12
			ld 		(unavariable), a
		
		pop 	iy
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		exx
		ex 		af, af'
		;=============
		; CHECKS
		;=============
		call 	cpct_scanKeyboard_if_asm
		
		call 	checkShotTime
		call 	checkBomb

		ld 		a, (gameMode)
		cp 		#0
		jr 		z, GameMode0
			cp 		#1
			jr 		z, GameMode1
			 	jr 		return
		GameMode0:
			call 	checkEnemy
			call 	checkTimer
			jr 		return
		GameMode1:
			call 	checkBossTimer
			call 	checkBossAnimationTimer
	return:
	ret
;========================
; 	INIT THE GAME
;
;========================
	init:

		call 	cpct_disableFirmware_asm	;disable firmware so we can set another options
		
		ld 		c, #0 						;load video mode 0 on screen
		call 	cpct_setVideoMode_asm
		ld 		hl, #_sprite_palette
		ld 		de, #16
		call 	cpct_setPalette_asm

		ld 		l, #16
		ld 		h, #0
		call 	cpct_setPALColour_asm
		ld 		de, #_song_ingame
		call 	cpct_akp_musicInit_asm


	ret
;========================
; 	INIT THE GAME DATA
;
;========================
	initData:
		call 	initHero
		call 	initShots
		call 	initEnemies

		ld 		a, #0
		ld 		(gameMode), a
		call 	updateLifes
		call 	updateLeaks
		call 	updateBomb
		call 	initBoss
		call 	initHUD
		call 	waitLoad
	ret
;========================
; 	WAIT 
;
;========================
	waitLoad:
		ld 		a, #256
		waitBucle:
		cp  	#1
		jr 		z, quitWait
			dec 	a
			jr 		waitBucle
	quitWait:
	ret
;========================
; 	SWAP THE GAME MODE
;
;========================
	swapGameMode::
		ld 		a, (gameMode)
		cp 		#0
		jr 		z, swapMode0
		swapMode1:
			ld 		a, #0
			ld 		(gameMode), a
			call 	swapShotMode
			ld 		a, #0
 			ld 		(totalKills), a
 			call 	heroPtrX

 			ld 		a, hero_lives(ix)
 			cp 		#9
 			jr 		z, jumpIncLives
 				inc 	hero_lives(ix)
 			jumpIncLives:
 			ld 		a, hero_bombs(ix)
 			cp 		#9
 			jr 		z, jumpIncBombs
 				inc 	hero_bombs(ix)
 			jumpIncBombs:
 			ld 		a, #9
 			ld 		(totalLeaks), a
 			call 	updateLifes
 			call 	updateBomb
 			call 	updateLeaks
 			jp 		mode0
		swapMode0:
			call 	killAll
			ld 		a, #1
			ld 		(gameMode), a
			call 	swapShotMode
			call 	initBoss
			jp		mode1
 	quitSwapMode:
 		
 	ret
;========================
; 	MAIN PROGRAM
;
;========================
	_main::
		
		;=============
		; STACK LIMIT 
		;=============
		ld 		sp, #0x8000
		
		;=============
		; INIT CFG 
		;=============
		call 	init
		;=============
		; INTERRUPTS
		;=============
		ld 		hl, #isr
		call 	cpct_setInterruptHandler_asm
		
		;=============
		;INIT INTERFACE
		;=============
		startGame:
		call 	initializeVideoMemory
		call 	drawMap1 ;; COOO
		call 	drawMap2 ;; 8000
		call 	initData
		
		
			main_bucle:
			;=============
			; NORMAL MODE 
			;=============
				mode0:
				;=============
				; ERASE 
				;=============
				call 	eraseEnemy
				call 	eraseShot
				call 	eraseHero

				;=============
				; UPDATE 
				;=============
				call 	updateEnemy
				call   	updateShot
				call 	updateHeroMode0
					call 	checkUserInput
				
				
				;===================
				; SWAP TO BOSS MODE
				;===================s
				ld 		a, (totalKills)
				cp 		#40
				jp 		m, notChangeBoss
					call 	shotPtrX
					ld 		a, shot_x(ix)
					ld 		shot_SX(ix), a
					call 	eraseShotMark
					call 	heroPtrX
					ld 		a, hero_x(ix)
					ld 		hero_SX(ix), a
					call 	eraseHero
					call 	swapGameMode

				notChangeBoss:
				;=============
				; DRAW 
				;=============
				call 	drawEnemy
				call 	drawShot
				call 	drawHero

				call 	cpct_waitVSYNC_asm
				call	toggleVideoMemory

				ld 		a, (gameMode)
				cp 		#3

				jr 		nz, mode0
					jp 		restartGame
			;=============
			; BOSS MODE 
			;=============
				mode1:
				;=============
				; ERASE 
				;=============
				call 	eraseBoss
				call 	eraseShot
				call 	eraseHero
				;=============
				; UPDATE 
				;=============
				call 	updateBoss
				call   	updateShot
				call 	updateHeroMode1
					call 	checkUserInput

				notChangeNormal:
				;=============
				; DRAW 
				;=============
				call 	drawBoss
				call 	drawShot
				call 	drawHero
				;=============
				; VIDEO CALLS
				;=============
				call 	cpct_waitVSYNC_asm
				call	toggleVideoMemory
				ld 		a, (gameMode)
				cp 		#3

				jr 		nz, mode1
					jp 		restartGame
		ret

