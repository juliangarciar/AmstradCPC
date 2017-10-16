.area _DATA
	;==================
	;;;PRIVATE DATA
	;==================

	;==================
	;;;PUBLIC DATA
	;==================

.area _CODE
.include "cpctelera.h.s"
.include "control.h.s"
.include "obstacle.h.s"
.include "hero.h.s"
.include "shot.h.s"
.include "collision.h.s"
.include "enemy.h.s"
.globl 	_sprite_palette
;.globl  _g_tileset
;.globl 	_level1
	;==================
	;;;INCLUDE FUNCIONS
	;==================
	init:
		call 	cpct_disableFirmware_asm	;disable firmware so we can set another options
		;ld a, (0x0039) 					;saves data from firmware location
		ld 		c, #0 						;load video mode 0 on screen
		call 	cpct_setVideoMode_asm
		ld 		hl, #_sprite_palette
		ld 		de, #16
		call 	cpct_setPalette_asm
		call 	drawObstacles	
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
	_main::
		call init
	
			main_bucle:
			call 	erase_hero

			;;BORRAMOS VOLADORES
			;EnemyV1
			call	enemyV1Ptr
			call 	erase_enemy
			;EnemyV2
			call	enemyV2Ptr
			call 	erase_enemy	 


			;;BORRAMOS TERRESTRES
			;Enemy1
			call	enemy1Ptr
			call 	erase_enemy
			;Enemy2
			;call	enemy2Ptr
			;call 	erase_enemy	
			;Enemy3
			;call	enemy3Ptr
			;call 	erase_enemy

			; call	enemy4Ptr
			; call 	erase_enemy

			; call	enemy5Ptr
			; call 	erase_enemy

			; call	enemy6Ptr
			; call 	erase_enemy

			; call	enemy7Ptr
			; call 	erase_enemy

			; call	enemy8Ptr
			; call 	erase_enemy

			; call	enemy9Ptr
			; call 	erase_enemy

			; call	enemy10Ptr
			; call 	erase_enemy

			;HACER UN UPDATE DE CONTROL
			call	jump_control
			call    shot_update
			call 	checkUserInput
			;call 	drawObstacles
			;DOBLE EFECTO DOBLE DIVERSION
			call 	updateHero
			call 	updateHero
			call 	draw_hero

			call 	activateEnemy	;comprobamos si el enemigo esta activo o no
			call	activateEnemyV

			call 	enemy1Ptr
			call	updateEnemy
			call 	enemyV1Ptr
			call	updateEnemy
			call 	enemyV2Ptr
			call	updateEnemy

			;Dibujamos todos los enemigos

			;;VOLADORES
			call 	enemyV1Ptr
			call	draw_enemy

			call 	enemyV2Ptr
			call	draw_enemy


			;;TERRESTRES

			call 	enemy1Ptr
			call	draw_enemy

			;call 	enemy2Ptr
			;call	draw_enemy

			;call 	enemy3Ptr
			;call	draw_enemy

			; call 	enemy4Ptr
			; call	draw_enemy

			; call 	enemy5Ptr
			; call	draw_enemy
			
			; call 	enemy6Ptr
			; call	draw_enemy

			; call 	enemy7Ptr
			; call	draw_enemy
			
			; call 	enemy8Ptr
			; call	draw_enemy

			; call 	enemy9Ptr
			; call	draw_enemy
			
			; call 	enemy10Ptr
			; call	draw_enemy

			call 	cpct_waitVSYNC_asm
			jr		main_bucle

		ret

