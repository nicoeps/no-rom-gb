INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]
EntryPoint:
	nop
	jp Main

SECTION "Title", ROM0[$134]
	db "NO-ROM"

SECTION "Tileset", ROM0
Tileset:
INCBIN "no-rom-pb.2bpp"

SECTION "Tilemap", ROM0
Tilemap:
	db $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D
	db $4E, $4F, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B

SECTION "Main", ROM0[$150]
Main:
	nop
	di
	jp .setup


.waitVBlank
	ldh a, [rLY]
	cp 144
	jr c, .waitVBlank
	ret

.setup
	ld hl, rLCDC
	set 6, [hl]
	set 5, [hl]
	ld hl, rWY
	ld [hl], 144
	inc hl
	ld [hl], 33
	
	ld bc, $8400
	ld de, $8700
	ld hl, Tileset

.readTileset
	call .waitVBlank
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, b
	cp a, d
	jr c, .readTileset

	ld hl, Tilemap
	ld bc, $9C00
	ld de, $9C0E

.readTilemap
	call .waitVBlank
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

	cp a, $2F
	jr c, .readTilemap

	ld hl, _OAMRAM

.clearOAM
	call .waitVBlank
	ld [hl], 0
	inc hl
	ld a, l
	cp a, $F0
	jr nz, .clearOAM

	ld b, 0

.loop
	ld a, [rWY]
	cp a, 90
	jr c, .loop

	ldh a, [rDIV]
	cp a, 255
	jp z, .move
	jr .loop

.move
	inc b
	ld a, 3
	cp a, b
	jr nc, .loop
	ld b, 0
	ld hl, rWY
	dec [hl]

	ldh [rDIV], a
	jr .loop
