.include "cpctelera.h.s"
buffer_start:: .db #0xC0

initializeVideoMemory::
    ld  hl, #0x8000
    ld  de, #0x8001
    ld  (hl), #00
    ld  bc, #0x4000
    ldir
ret

toggleVideoMemory::
    ld      a, (buffer_start)
    cp      #0xC0
    jr      nz, video_in_80
        ;;Video en C0
        ld      a, #0x80
        ld      (buffer_start), a 
        ld      l, #0x30
        call    cpct_setVideoMemoryPage_asm
ret
    video_in_80:
        ld      a, #0xC0
        ld      (buffer_start), a 
        ld      l, #0x20
        call    cpct_setVideoMemoryPage_asm
ret
