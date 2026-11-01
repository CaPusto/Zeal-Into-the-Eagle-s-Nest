;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.4.0 #14620 (Linux)
;--------------------------------------------------------
	.module assets
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _pmap
	.globl _palloc
	.globl _dstat
	.globl _close
	.globl _open
	.globl _read
	.globl _title_palette
	.globl _title_map
	.globl _title_tiles
	.globl _asset_map_page
	.globl _asset_map_off
	.globl _assets_load_title
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_title_tiles::
	.ds 8
_title_map::
	.ds 8
_title_palette::
	.ds 8
_asset_buf:
	.ds 48
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _TEXT
;/home/ed/work/sdk/Zeal-8-bit-OS/sdk/sdcc/include/zos_sys.h:168: static inline const zos_config_t* kernel_config(void)
;	---------------------------------
; Function kernel_config
; ---------------------------------
_kernel_config:
;/home/ed/work/sdk/Zeal-8-bit-OS/sdk/sdcc/include/zos_sys.h:170: return *((zos_config_t**) 0x0004);
	ld	de, (#0x0004)
;/home/ed/work/sdk/Zeal-8-bit-OS/sdk/sdcc/include/zos_sys.h:171: }
	ret
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:11: static const char* asset_prep(const char* pre, const char* name) {
;	---------------------------------
; Function asset_prep
; ---------------------------------
_asset_prep:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	dec	sp
	ld	c, l
	ld	b, h
	ld	-3 (ix), e
	ld	-2 (ix), d
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:13: while (pre[i] != 0) {
	ld	-1 (ix), #0x00
00101$:
	ld	l, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	e, (hl)
	ld	a, e
	or	a, a
	jr	Z, 00112$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:14: asset_buf[i] = pre[i];
	ld	a, #<(_asset_buf)
	add	a, -1 (ix)
	ld	-5 (ix), a
	ld	a, #>(_asset_buf)
	adc	a, #0x00
	ld	-4 (ix), a
	pop	hl
	push	hl
	ld	(hl), e
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:15: i++;
	inc	-1 (ix)
	jr	00101$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:17: while (name[j] != 0) {
00112$:
	ld	e, -1 (ix)
	ld	c, #0x00
00104$:
	ld	a, c
	add	a, -3 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #0x00
	adc	a, -2 (ix)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	b, (hl)
	ld	a, b
	or	a, a
	jr	Z, 00106$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:18: asset_buf[i] = name[j];
	ld	hl, #_asset_buf
	ld	d, #0x00
	add	hl, de
	ld	(hl), b
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:19: i++;
	inc	e
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:20: j++;
	inc	c
	jr	00104$
00106$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:22: asset_buf[i] = 0;
	ld	hl, #_asset_buf
	ld	d, #0x00
	add	hl, de
	ld	(hl), #0x00
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:23: return asset_buf;
	ld	de, #_asset_buf
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:24: }
	ld	sp, ix
	pop	ix
	ret
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:26: void* asset_map_page(asset_t* a, uint8_t page) {
;	---------------------------------
; Function asset_map_page
; ---------------------------------
_asset_map_page::
	ex	de, hl
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:27: if (page >= a->npages) return (void*)0;
	ld	a, (de)
	ld	c, a
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	sub	a, c
	jr	C, 00102$
	ld	de, #0x0000
	jr	00105$
00102$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:28: if (pmap(a->pages[page], ASSET_BANK_ADDR) != ERR_SUCCESS) return (void*)0;
	inc	de
	ld	iy, #2
	add	iy, sp
	ld	l, 0 (iy)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	ld	a, (hl)
	ld	de, #0x8000
	call	_pmap
	or	a, a
	jr	Z, 00104$
	ld	de, #0x0000
	jr	00105$
00104$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:29: return ASSET_BANK_ADDR;
	ld	de, #0x8000
00105$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:30: }
	pop	hl
	inc	sp
	jp	(hl)
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:32: void* asset_map_off(asset_t* a, uint16_t off) {
;	---------------------------------
; Function asset_map_off
; ---------------------------------
_asset_map_off::
	ld	c, e
	ld	b, d
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:33: uint8_t page = (uint8_t)(off / ASSET_PAGE_SIZE);
	ld	a, b
	rlca
	rlca
	and	a, #0x03
	ld	e, a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:34: uint16_t rem = (uint16_t)(off % ASSET_PAGE_SIZE);
	ld	a, b
	and	a, #0x3f
	ld	b, a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:35: char* base = (char*)asset_map_page(a, page);
	push	bc
	ld	a, e
	push	af
	inc	sp
	call	_asset_map_page
	pop	bc
	ld	l, e
	ld	h, d
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:36: if (base == (char*)0) return (void*)0;
	ld	a, h
	or	a, l
	jr	NZ, 00102$
	ld	de, #0x0000
	ret
00102$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:37: return base + rem;
	ex	de, hl
	add	hl, bc
	ex	de, hl
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:38: }
	ret
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:40: static zos_err_t asset_load(const char* name, asset_t* out) {
;	---------------------------------
; Function asset_load
; ---------------------------------
_asset_load:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	iy, #-41
	add	iy, sp
	ld	sp, iy
	ld	c, l
	ld	b, h
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:46: out->npages = 0;
	ld	-5 (ix), e
	ld	-4 (ix), d
	ex	de,hl
	ld	(hl), #0x00
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:47: out->size = 0;
	ld	a, -5 (ix)
	add	a, #0x06
	ld	-7 (ix), a
	ld	a, -4 (ix)
	adc	a, #0x00
	ld	-6 (ix), a
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:49: fd = open(name, O_RDONLY);
	xor	a, a
	push	af
	inc	sp
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	call	_open
	ld	-10 (ix), a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:50: if (fd < 0) return ERR_FAILURE;
	bit	7, -10 (ix)
	jr	Z, 00102$
	ld	a, #0x01
	jp	00127$
00102$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:51: if (dstat(fd, &st) != ERR_SUCCESS) {
	ld	hl, #0
	add	hl, sp
	ex	de, hl
	ld	a, -10 (ix)
	call	_dstat
	or	a, a
	jr	Z, 00104$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:52: close(fd);
	ld	a, -10 (ix)
	call	_close
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:53: return ERR_FAILURE;
	ld	a, #0x01
	jp	00127$
00104$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:56: total = (uint16_t)st.s_size;
	ld	a, -40 (ix)
	ld	-3 (ix), a
	ld	a, -39 (ix)
	ld	-2 (ix), a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:57: out->size = total;
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	ld	a, -3 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -2 (ix)
	ld	(hl), a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:58: out->npages = (uint8_t)((total + ASSET_PAGE_SIZE - 1) / ASSET_PAGE_SIZE);
	ld	a, -3 (ix)
	ld	-9 (ix), a
	ld	a, -2 (ix)
	ld	-8 (ix), a
	ld	a, -9 (ix)
	add	a, #0xff
	ld	-7 (ix), a
	ld	a, -8 (ix)
	adc	a, #0x3f
	ld	-6 (ix), a
	rlca
	rlca
	and	a, #0x03
	ld	-7 (ix), a
	ld	-6 (ix), #0x00
	ld	b, -7 (ix)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:59: if (out->npages == 0) out->npages = 1;
	ld	a,b
	ld	(hl),a
	or	a, a
	jr	NZ, 00106$
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x01
00106$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:60: if (out->npages > ASSET_MAX_PAGES) {
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	c, (hl)
	ld	a, #0x05
	sub	a, c
	jr	NC, 00135$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:61: close(fd);
	ld	a, -10 (ix)
	call	_close
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:62: return ERR_FAILURE;
	ld	a, #0x01
	jp	00127$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:65: for (i = 0; i < out->npages; i++) {
00135$:
	ld	a, -5 (ix)
	add	a, #0x01
	ld	-7 (ix), a
	ld	a, -4 (ix)
	adc	a, #0x00
	ld	-6 (ix), a
	ld	-1 (ix), #0x00
00122$:
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a,-1 (ix)
	sub	a,(hl)
	jr	NC, 00141$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:66: if (palloc(&out->pages[i]) != ERR_SUCCESS) {
	ld	a, -7 (ix)
	add	a, -1 (ix)
	ld	-9 (ix), a
	ld	a, -6 (ix)
	adc	a, #0x00
	ld	-8 (ix), a
	ld	l, -9 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -8 (ix)
;	spillPairReg hl
;	spillPairReg hl
	call	_palloc
	or	a, a
	jr	Z, 00123$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:67: close(fd);
	ld	a, -10 (ix)
	call	_close
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:68: return ERR_NO_MORE_MEMORY;
	ld	a, #0x16
	jp	00127$
00123$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:65: for (i = 0; i < out->npages; i++) {
	inc	-1 (ix)
	jr	00122$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:72: for (i = 0; i < out->npages; i++) {
00141$:
	ld	a, -7 (ix)
	ld	-9 (ix), a
	ld	a, -6 (ix)
	ld	-8 (ix), a
	ld	-1 (ix), #0x00
00125$:
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a,-1 (ix)
	sub	a,(hl)
	jp	NC, 00120$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:73: uint16_t n = total;
	ld	a, -3 (ix)
	ld	-12 (ix), a
	ld	a, -2 (ix)
	ld	-11 (ix), a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:74: if (n > ASSET_PAGE_SIZE) n = ASSET_PAGE_SIZE;
	ld	a, -3 (ix)
	ld	-7 (ix), a
	ld	a, -2 (ix)
	ld	-6 (ix), a
	xor	a, a
	cp	a, -7 (ix)
	ld	a, #0x40
	sbc	a, -6 (ix)
	jr	NC, 00113$
	ld	-12 (ix), #0x00
	ld	-11 (ix), #0x40
00113$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:75: if (pmap(out->pages[i], ASSET_BANK_ADDR) != ERR_SUCCESS) {
	ld	a, -9 (ix)
	add	a, -1 (ix)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, -8 (ix)
	adc	a, #0x00
	ld	h, a
	ld	a, (hl)
	ld	de, #0x8000
	call	_pmap
	or	a, a
	jr	Z, 00115$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:76: close(fd);
	ld	a, -10 (ix)
	call	_close
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:77: return ERR_FAILURE;
	ld	a, #0x01
	jr	00127$
00115$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:79: if (read(fd, ASSET_BANK_ADDR, &n) != ERR_SUCCESS) {
	ld	hl, #29
	add	hl, sp
	push	hl
	ld	de, #0x8000
	ld	a, -10 (ix)
	call	_read
	or	a, a
	jr	Z, 00117$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:80: close(fd);
	ld	a, -10 (ix)
	call	_close
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:81: return ERR_FAILURE;
	ld	a, #0x01
	jr	00127$
00117$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:83: total -= n;
	ld	a, -3 (ix)
	sub	a, -12 (ix)
	ld	-3 (ix), a
	ld	a, -2 (ix)
	sbc	a, -11 (ix)
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:84: if (total == 0) break;
	ld	-2 (ix), a
	or	a, -3 (ix)
	jr	Z, 00120$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:72: for (i = 0; i < out->npages; i++) {
	inc	-1 (ix)
	jp	00125$
00120$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:87: close(fd);
	ld	a, -10 (ix)
	call	_close
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:88: return ERR_SUCCESS;
	xor	a, a
00127$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:89: }
	ld	sp, ix
	pop	ix
	ret
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:91: static zos_err_t asset_load_pair(const char* name, asset_t* out) {
;	---------------------------------
; Function asset_load_pair
; ---------------------------------
_asset_load_pair:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	ld	c, l
	ld	b, h
	inc	sp
	inc	sp
	push	de
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:92: if (asset_load(asset_prep("gen/", name), out) == ERR_SUCCESS) return ERR_SUCCESS;
	push	bc
	ld	e, c
	ld	d, b
	ld	hl, #___str_0
	call	_asset_prep
	ex	de, hl
	ld	e, -2 (ix)
	ld	d, -1 (ix)
	call	_asset_load
	pop	bc
	or	a,a
	jr	Z, 00103$
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:93: return asset_load(asset_prep("H:/gen/", name), out);
	ld	e, c
	ld	d, b
	ld	hl, #___str_1
	call	_asset_prep
	ex	de, hl
	pop	de
	push	de
	call	_asset_load
00103$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:94: }
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "gen/"
	.db 0x00
___str_1:
	.ascii "H:/gen/"
	.db 0x00
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:96: zos_err_t assets_load_title(void) {
;	---------------------------------
; Function assets_load_title
; ---------------------------------
_assets_load_title::
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:97: if (asset_load_pair("title.zts", &title_tiles) != ERR_SUCCESS) return ERR_FAILURE;
	ld	de, #_title_tiles
	ld	hl, #___str_2
	call	_asset_load_pair
	or	a, a
	jr	Z, 00102$
	ld	a, #0x01
	ret
00102$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:98: if (asset_load_pair("title.ztm", &title_map) != ERR_SUCCESS) return ERR_FAILURE;
	ld	de, #_title_map
	ld	hl, #___str_3
	call	_asset_load_pair
	or	a, a
	jr	Z, 00104$
	ld	a, #0x01
	ret
00104$:
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:99: if (asset_load_pair("title.ztp", &title_palette) != ERR_SUCCESS) return ERR_FAILURE;
	ld	de, #_title_palette
	ld	hl, #___str_4
	call	_asset_load_pair
	or	a, a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:100: return ERR_SUCCESS;
	ld	a, #0x01
	ret	NZ
	xor	a, a
;/home/ed/work/zeal-eaglenest/zeal/src/assets.c:101: }
	ret
___str_2:
	.ascii "title.zts"
	.db 0x00
___str_3:
	.ascii "title.ztm"
	.db 0x00
___str_4:
	.ascii "title.ztp"
	.db 0x00
	.area _TEXT
	.area _INITIALIZER
	.area _CABS (ABS)
