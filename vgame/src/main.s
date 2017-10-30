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

.globl 	_sprite_palette
.globl _song_ingame

unavariable: .db #12

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
		call 	cpct_scanKeyboard_if_asm
		call 	checkTimer
		call 	checkShotTime
		call 	checkEnemy
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

		ld 		de, #_song_ingame
		call cpct_akp_musicInit_asm

	ret
;========================
; 	INIT THE GAME
;
;========================
	waitLoad:
		ld 		a, #255
		waitBucle:
		dec 	a
		cp 		#0
		jr 		nz, waitBucle
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
		call 	initializeVideoMemory
		call 	drawMap1 ;; COOO
		call 	drawMap2 ;; 8000
		call 	initHUD
		call 	waitLoad
			main_bucle:
			;=============
			; ERASE 
			;=============
			call 	eraseEnemy
			call 	eraseShot
			call 	eraseHero
			;HACER UN UPDATE DE CONTROL
			
			;=============
			; CHECKS
			;=============
			

			;=============
			; UPDATE 
			;=============
			call 	updateEnemy
			call   	updateShot
			call 	updateHero
				;KEYBOARD CONTROL
				call 	checkUserInput
			
			;=============
			; UPDATE 
			;=============
			call 	drawEnemy
			call 	drawShot
			call 	drawHero

			;=============
			; VIDEO CALLS
			;=============
			call 	cpct_waitVSYNC_asm
			call	toggleVideoMemory
			jr		main_bucle

		ret

