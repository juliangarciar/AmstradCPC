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

.globl 	_sprite_palette

;unavariable: .db #0x10

.area _CODE

;.globl  _g_tileset
;.globl 	_level1
;========================
; 	INTERRUPTS
;
;========================
	isr:
		;ld 		l, #16
		;ld  	a, (unavariable)
		;ld 		h, a
		;
		;call 	cpct_setPALColour_asm
;
;		;ld  	a, (unavariable)
;		;inc 	a
;		;cp 		#0x16
;		;jr 		nz, continue
;
;		;	ld 		a, #0x10
;		;	
;		;continue:
		;	ld 		(unavariable), a
		
		call 	cpct_scanKeyboard_if_asm

		
		;call cpct_setInterruptHandler_asm
		
	ret
;========================
; 	INIT THE GAME
;
;========================
	init:
		call 	cpct_disableFirmware_asm	;disable firmware so we can set another options
		
		;ld a, (0x0039) 					;saves data from firmware location
		ld 		c, #0 						;load video mode 0 on screen
		call 	cpct_setVideoMode_asm
		ld 		hl, #_sprite_palette
		ld 		de, #16
		call 	cpct_setPalette_asm
			;==================
			;  DIBUJAR NIVEL
			;==================
		;ld 		hl, #_g_tileset
		;call 	cpct_etm_setTileset2x4_asm
		;ld 		hl, #_level1
		;push	hl
		;ld 		hl, #0xC000
		;push 	hl
		;ld 		bc, #0000
		;ld    	de, #3113
		;ld 		a, 	#19
		;call cpct_etm_drawTileBox2x4_asm	
	ret
;========================
; 	MAIN PROGRAM
;
;========================
	_main::
		call init
		ld sp, #0x8000
		;INTERRUPTS
		ld 		hl, #isr
		call 	cpct_setInterruptHandler_asm
		call 	initializeVideoMemory

		call drawMap1 ;; COOO

		call drawMap2 ;; 8000

			main_bucle:
			
			call 	eraseEnemy
			call 	eraseShot
			
			call 	eraseHero
			;HACER UN UPDATE DE CONTROL
			

			call 	checkTimer
			;call 	checkAnimationTimer
			call 	checkShotTime
			call 	checkEnemy
			
			call 	updateEnemy
			call   	updateShot
			
			call 	updateHero
			call 	checkUserInput
			
			call 	drawEnemy
			call 	drawShot
			
			call 	drawHero

			
			call 	cpct_waitVSYNC_asm
			call	toggleVideoMemory
			jr		main_bucle

		ret

