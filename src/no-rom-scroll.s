INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]
EntryPoint:
	nop
	jp Main

SECTION "Title", ROM0[$134]
	db "NO-ROM"

SECTION "Tileset", ROM0
Tileset:
INCBIN "no-rom-scroll.2bpp"

SECTION "Tilemap", ROM0
Tilemap:
	db $40, $41, $42, $43, $44, $45, $46, $42, $42, $42, $47, $45, $42, $48
	db $49, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $53, $54, $55, $56
	db $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $61, $62, $63, $64

SECTION "Main", ROM0[$150]
Main:
	nop
	di

.stopLCDWait
	ldh a, [rLY]
	cp 144
	jr c, .stopLCDWait

	ld hl, rLCDC
	res 7, [hl]
	
	ld bc, $8400
	ld de, $8700
	ld hl, Tileset

.readTileset
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, b
	cp a, d
	jr c, .readTileset

	ld hl, Tilemap
	ld bc, $9A43
	ld de, $9A51

.readTilemap
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, c
	cp a, e
	jr c, .readTilemap

	add $12
	ld c, a
	ld a, e
	add $20
	ld e, a
	ld a, e

	cp a, 91
	jr nc, .readTilemap

	ld hl, _OAMRAM

.clearOAM
	ld [hl], 0
	inc hl
	ld a, l
	cp a, $F0
	jr nz, .clearOAM

.enableLCD
	ld hl, rLCDC
	set 7, [hl]

.loop
	ld a, [rSCY]
	cp a, 32
	jr nc, .loop

	ldh a, [rDIV]
	cp a, 255
	jp z, .move
	jr .loop

.move
	ld hl, rSCY
	inc [hl]

	ldh [rDIV], a
	jr .loop
