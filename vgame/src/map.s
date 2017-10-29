.area _DATA

.include "map.h.s"
.include "buffer.h.s"
.include "cpctelera.h.s"

.globl _map1
.globl _g_tileset

.area _CODE

drawMap1::
	;; Establecemos el tileset con esta funcion.
	;; Le pasa en HL el puntero al array de tiles, ese array 
	;; de punteros a tiles que nos ha generado.
	;; Con estas dos lineas establecemos que vamos a utilizar
	;; este conjunto de tiles, y a continuacion ya podria 
	;; dubujar mapas en pantalla.
	ld   hl, #_g_tileset
	call cpct_etm_setTileset2x4_asm

	;; Ahora dibujamos el tilemap
	ld   hl, #_map1   ;; cargamos en HL el tilemap
	push hl 		  ;; mete el valor en la pila para pasarselo a la funcion
	ld 	 hl, #0xC000  ;; puntero a la memoria de video donde vamos a pintar el mapa
	push hl
	
	ld 	 bc, #0000    ;; y e x del tilemap. Util para indicar 
					  ;; la coordenada a pintar del tilemap
	ld   de, #0x3228  ;; d(altura) x e(anchura)
	ld    a, #40      ;; define el ancho completo del mapa en tileds
	call cpct_etm_drawTileBox2x4_asm

ret


drawMap2::
	;; Establecemos el tileset con esta funcion.
	;; Le pasa en HL el puntero al array de tiles, ese array 
	;; de punteros a tiles que nos ha generado.
	;; Con estas dos lineas establecemos que vamos a utilizar
	;; este conjunto de tiles, y a continuacion ya podria 
	;; dubujar mapas en pantalla.
	ld   hl, #_g_tileset
	call cpct_etm_setTileset2x4_asm

	;; Ahora dibujamos el tilemap
	ld   hl, #_map1   ;; cargamos en HL el tilemap
	push hl 		  ;; mete el valor en la pila para pasarselo a la funcion
	ld 	 hl, #0x8000  ;; puntero a la memoria de video donde vamos a pintar el mapa
	push hl
	
	ld 	 bc, #0000    ;; y e x del tilemap. Util para indicar 
					  ;; la coordenada a pintar del tilemap
	ld   de, #0x3228  ;; d(altura) x e(anchura)
	ld    a, #40      ;; define el ancho completo del mapa en tileds
	call cpct_etm_drawTileBox2x4_asm

ret