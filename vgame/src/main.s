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
.globl 	_sprite_palette
;.globl _song_ingame

unavariable: .db #12
gameMode:: 	 .db #0
totalKills:: .db #0
totalLeaks:: .db #9
.area _CODE
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
		
			;call 	cpct_akp_musicPlay_asm
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
		call 	checkTimer
		call 	checkShotTime

		ld 		a, (gameMode)
		cp 		#0
		jr 		nz, checkBoss
			call 	checkEnemy
		checkBoss:
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
		ld 		h, #5
		call 	cpct_setPALColour_asm
		;ld 		de, #_song_ingame
		;call 	cpct_akp_musicInit_asm


	ret
;========================
; 	INIT THE GAME DATA
;
;========================
	initData:
		;
		;call 	initEnemies
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

 			jr 		mode0
		swapMode0:
			ld 		a, #1
			ld 		(gameMode), a
			call 	swapShotMode
			call 	initBoss
			jr 		mode1
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
		startGame::
		;=============
		;INIT INTERFACE
		;=============
		call 	initializeVideoMemory
		call 	drawMap1 ;; COOO
		call 	drawMap2 ;; 8000
		call 	initHUD
		
		;call 	waitLoad
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
				;===================
				ld 		a, (totalKills)
				cp 		#10
				jr 		nz, notChangeBoss	
					call 	killAll
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
				jr 		mode0
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

				;====================
				; SWAP TO NORMAL MODE
				;====================
				;ld 		a, (totalKills)
				;cp 		#10
				;jr 		nz, notChangeBoss
				;	ld 		a, #0
				;	ld 		(gameMode), a
				;	call 	killAll
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
				jr 		mode1
		ret

