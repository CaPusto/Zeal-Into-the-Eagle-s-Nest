;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.4.0 #14620 (Linux)
;--------------------------------------------------------
	.module render
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _asset_map_off
	.globl _asset_map_page
	.globl _gfx_tilemap_load
	.globl _gfx_tileset_load
	.globl _gfx_palette_load
	.globl _render_title_screen
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_zvb_config_ver_rev	=	0x0080
_zvb_config_ver_min	=	0x0081
_zvb_config_ver_maj	=	0x0082
_zvb_config_dev_idx	=	0x008e
_zvb_config_phys_addr	=	0x008f
_zvb_ctrl_vpos_low	=	0x0090
_zvb_ctrl_vpos_high	=	0x0091
_zvb_ctrl_hpos_low	=	0x0092
_zvb_ctrl_hpos_high	=	0x0093
_zvb_ctrl_l0_scr_y_low	=	0x0094
_zvb_ctrl_l0_scr_y_high	=	0x0095
_zvb_ctrl_l0_scr_x_low	=	0x0096
_zvb_ctrl_l0_scr_x_high	=	0x0097
_zvb_ctrl_l1_scr_y_low	=	0x0098
_zvb_ctrl_l1_scr_y_high	=	0x0099
_zvb_ctrl_l1_scr_x_low	=	0x009a
_zvb_ctrl_l1_scr_x_high	=	0x009b
_zvb_ctrl_video_mode	=	0x009c
_zvb_ctrl_status	=	0x009d
_zvb_peri_text_print_char	=	0x00a0
_zvb_peri_text_curs_y	=	0x00a1
_zvb_peri_text_curs_x	=	0x00a2
_zvb_peri_text_scroll_y	=	0x00a3
_zvb_peri_text_scroll_x	=	0x00a4
_zvb_peri_text_color	=	0x00a5
_zvb_peri_text_curs_time	=	0x00a6
_zvb_peri_text_curs_char	=	0x00a7
_zvb_peri_text_curs_color	=	0x00a8
_zvb_peri_text_ctrl	=	0x00a9
_zvb_peri_spi_ctrl	=	0x00a1
_zvb_peri_spi_clk_div	=	0x00a2
_zvb_peri_spi_ram_len	=	0x00a3
_zvb_peri_spi_fifo	=	0x00a7
_zvb_peri_spi_array_0	=	0x00a8
_zvb_peri_spi_array_1	=	0x00a9
_zvb_peri_spi_array_2	=	0x00aa
_zvb_peri_spi_array_3	=	0x00ab
_zvb_peri_spi_array_4	=	0x00ac
_zvb_peri_spi_array_5	=	0x00ad
_zvb_peri_spi_array_6	=	0x00ae
_zvb_peri_spi_array_7	=	0x00af
_zvb_peri_crc_ctrl	=	0x00a0
_zvb_peri_crc_data_in	=	0x00a1
_zvb_peri_crc_byte0	=	0x00a4
_zvb_peri_crc_byte1	=	0x00a5
_zvb_peri_crc_byte2	=	0x00a6
_zvb_peri_crc_byte3	=	0x00a7
_zvb_peri_sound_freq_low	=	0x00a0
_zvb_peri_sound_freq_high	=	0x00a1
_zvb_peri_sound_wave	=	0x00a2
_zvb_peri_sound_volume	=	0x00a3
_zvb_peri_sound_sample_fifo	=	0x00a0
_zvb_peri_sound_sample_div	=	0x00a1
_zvb_peri_sound_sample_conf	=	0x00a2
_zvb_peri_sound_left_channel	=	0x00ab
_zvb_peri_sound_right_channel	=	0x00ac
_zvb_peri_sound_hold	=	0x00ad
_zvb_peri_sound_master_vol	=	0x00ae
_zvb_peri_sound_select	=	0x00af
_zvb_peri_dma_ctrl	=	0x00a0
_zvb_peri_dma_addr0	=	0x00a1
_zvb_peri_dma_addr1	=	0x00a2
_zvb_peri_dma_addr2	=	0x00a3
_zvb_peri_dma_clk_div	=	0x00a9
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
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
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:6: void render_title_screen(gfx_context* ctx) {
;	---------------------------------
; Function render_title_screen
; ---------------------------------
_render_title_screen::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	iy, #-33
	add	iy, sp
	ld	sp, iy
	ld	-2 (ix), l
	ld	-1 (ix), h
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:12: data = (uint8_t*)asset_map_off(&title_palette, 0);
	ld	de, #0x0000
	ld	hl, #_title_palette
	call	_asset_map_off
	ld	-4 (ix), e
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:13: if (data) {
	ld	-3 (ix), d
	ld	a, d
	or	a, -4 (ix)
	jr	Z, 00104$
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:14: const size_t palette_size = title_palette.size;
	ld	hl, #_title_palette + 6
	ld	a, (hl)
	ld	-6 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-5 (ix), a
	ld	a, -6 (ix)
	ld	-33 (ix), a
	ld	a, -5 (ix)
	ld	-32 (ix), a
	ld	a, -33 (ix)
	ld	-6 (ix), a
	ld	a, -32 (ix)
	ld	-5 (ix), a
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:15: if (palette_size > 0) {
	ld	a, -32 (ix)
	or	a, -33 (ix)
	jr	Z, 00104$
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:16: gfx_palette_load(ctx, data, palette_size, 0);
	xor	a, a
	push	af
	inc	sp
	ld	l, -6 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	e, -4 (ix)
	ld	d, -3 (ix)
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	call	_gfx_palette_load
00104$:
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:21: opts.compression = 0;  /* TILESET_COMP_NONE */
	ld	-11 (ix), #0x00
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:22: opts.from_byte = 0;
	xor	a, a
	ld	-10 (ix), a
	ld	-9 (ix), a
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:23: opts.pal_offset = 0;
	ld	-8 (ix), #0x00
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:24: opts.opacity = 0;
	ld	-7 (ix), #0x00
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:26: data = (uint8_t*)asset_map_page(&title_tiles, 0);
	xor	a, a
	push	af
	inc	sp
	ld	hl, #_title_tiles
	call	_asset_map_page
	ld	-4 (ix), e
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:27: if (data && title_tiles.size > 0) {
	ld	-3 (ix), d
	ld	a, d
	or	a, -4 (ix)
	jr	Z, 00106$
	ld	hl, #_title_tiles + 6
	ld	a, (hl)
	ld	-6 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-5 (ix), a
	or	a, -6 (ix)
	jr	Z, 00106$
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:30: &opts);
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:29: title_tiles.size > 32768 ? 32768 : title_tiles.size,
	xor	a, a
	cp	a, -6 (ix)
	ld	a, #0x80
	sbc	a, -5 (ix)
	jr	NC, 00123$
	ld	-6 (ix), #0x00
	ld	-5 (ix), #0x80
00123$:
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:28: gfx_tileset_load(ctx, data, 
	ld	hl, #22
	add	hl, sp
	push	hl
	ld	l, -6 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	e, -4 (ix)
	ld	d, -3 (ix)
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	call	_gfx_tileset_load
00106$:
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:37: data = (uint8_t*)asset_map_page(&title_map, 0);
	xor	a, a
	push	af
	inc	sp
	ld	hl, #_title_map
	call	_asset_map_page
	ld	-4 (ix), e
	ld	-3 (ix), d
	ld	a, -4 (ix)
	ld	-6 (ix), a
	ld	a, -3 (ix)
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:38: if (data) {
	ld	-5 (ix), a
	or	a, -6 (ix)
	jp	Z, 00111$
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:40: for (y = 0; y < 12 && y * 20 < title_map.size; y++) {
	ld	b, #0x00
00115$:
	ld	a, b
	sub	a, #0x0c
	jr	NC, 00108$
	ld	e, b
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	hl, (#_title_map + 6)
	ld	-4 (ix), e
	ld	-3 (ix), d
	ld	a, -4 (ix)
	sub	a, l
	ld	a, -3 (ix)
	sbc	a, h
	jr	NC, 00108$
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:41: memcpy(line, data + y * 20, 20);
	ld	l, -6 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -5 (ix)
;	spillPairReg hl
;	spillPairReg hl
	add	hl, de
	push	bc
	ex	de, hl
	ld	hl, #4
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0014
	ldir
	pop	bc
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:42: gfx_tilemap_load(ctx, line, 20, 0, 0, y);  /* layer 0 */
	push	bc
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	hl, #0x14
	push	hl
	ld	hl, #8
	add	hl, sp
	ex	de, hl
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	call	_gfx_tilemap_load
	pop	bc
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:40: for (y = 0; y < 12 && y * 20 < title_map.size; y++) {
	inc	b
	jr	00115$
00108$:
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:46: memset(line, 0, 20);
	ld	hl, #2
	add	hl, sp
	ld	b, #0x14
00205$:
	ld	(hl), #0x00
	inc	hl
	djnz	00205$
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:47: for (y = 12; y < 15; y++) {
	ld	-3 (ix), #0x0c
00117$:
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:48: gfx_tilemap_load(ctx, line, 20, 0, 0, y);  /* layer 0 */
	ld	h, -3 (ix)
	ld	l, #0x00
	push	hl
	ld	hl, #0x14
	push	hl
	ld	hl, #6
	add	hl, sp
	ex	de, hl
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	call	_gfx_tilemap_load
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:47: for (y = 12; y < 15; y++) {
	inc	-3 (ix)
	ld	a, -3 (ix)
	sub	a, #0x0f
	jr	C, 00117$
00111$:
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:53: memset(line, 0, 20);
	ld	hl, #2
	add	hl, sp
	ld	b, #0x14
00207$:
	ld	(hl), #0x00
	inc	hl
	djnz	00207$
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:54: for (y = 0; y < 15; y++) {
	ld	-3 (ix), #0x00
00119$:
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:55: gfx_tilemap_load(ctx, line, 20, 1, 0, y);  /* layer 1 */
	ld	a, -3 (ix)
	push	af
	inc	sp
	xor	a, a
	ld	h, a
	ld	l, #0x01
	push	hl
	ld	a, #0x14
	push	af
	inc	sp
	ld	hl, #6
	add	hl, sp
	ex	de, hl
	ld	l, -2 (ix)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, -1 (ix)
;	spillPairReg hl
;	spillPairReg hl
	call	_gfx_tilemap_load
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:54: for (y = 0; y < 15; y++) {
	inc	-3 (ix)
	ld	a, -3 (ix)
	sub	a, #0x0f
	jr	C, 00119$
;/home/ed/work/zeal-eaglenest/zeal/src/render.c:57: }
	ld	sp, ix
	pop	ix
	ret
	.area _TEXT
	.area _INITIALIZER
	.area _CABS (ABS)
