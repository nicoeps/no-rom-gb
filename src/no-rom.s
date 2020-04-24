INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]
EntryPoint:
	nop
	jp Main

SECTION "Title", ROM0[$134]
	db "NO-ROM"

SECTION "Tileset", ROM0
Tileset:
INCBIN "no-rom.2bpp"

SECTION "Tilemap", ROM0
Tilemap:
INCBIN "no-rom.tilemap"

SECTION "Main", ROM0[$150]
Main:
	nop
	di
	
	ld hl, rSCY
	ld [hl], $30
	inc hl
	ld [hl], $30

.stopLCDWait
	ldh a, [rLY]
	cp 144
	jr c, .stopLCDWait

	ld hl, rLCDC
	res 7, [hl]
	
	ld bc, _VRAM
	ld de, $84B0
	ld hl, Tileset

.readTileset
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, b
	cp a, d
	jr nz, .readTileset
	ld a, c
	cp a, e
	jr nz, .readTileset

	ld bc, _SCRN0
	ld de, _SCRN1
	ld hl, Tilemap

.readTilemap
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, b
	cp a, d
	jr nz, .readTilemap
	ld a, c
	cp a, e
	jr nz, .readTilemap

	ld hl, _OAMRAM

.clearOAM
	ld [hl], 0
	inc hl
	ld a, l
	cp a, $F0
	jr nz, .clearOAM

.enableLCD
	ld a, %11100100
    ldh [rBGP], a
	ld hl, rLCDC
    set 7, [hl]

.loop
	ldh a, [rDIV]
	cp 170
	call nc, Controls
	jr .loop

Controls:
	ld hl, rP1
	set 5, [hl]
	ld a, [hl]

	bit 3, a
	call z, .up

	bit 2, a
	call z, .down

	bit 1, a
	call z, .left

	bit 0, a
	call z, .right

	ldh [rDIV], a
	ret

.up
	ld hl, rSCY
	inc [hl]
	ret

.down
	ld hl, rSCY
	dec [hl]
	ret

.left
	ld hl, rSCX
	dec [hl]
	ret

.right
	ld hl, rSCX
	inc [hl]
	ret
