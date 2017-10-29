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

unavariable: .db #0x12

.area _CODE
;========================
; 	INTERRUPTS
;
;========================
	isr:
		ex 		af, af'
		exx
		push 	af
		push 	bc
		push 	de
		push 	hl
		push 	iy

		ld 		a, (unavariable)
		dec 	a
		ld 		(unavariable), a
		jr 		nz, return
			;call 	cpct_akp_musicPlay_asm
			ld 		a, #12
			ld 		(unavariable), a
		return:
		
		
		pop 	iy
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		exx
		ex 		af, af'
		call 	cpct_scanKeyboard_if_asm
				
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
	ret

;========================
; 	MAIN PROGRAM
;
;========================
	_main::
		
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
			call 	checkTimer
			;call 	checkAnimationTimer
			call 	checkShotTime
			call 	checkEnemy
			
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

