;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.4.0 #14620 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _render_title_screen
	.globl _assets_load_title
	.globl _gfx_wait_vblank
	.globl _gfx_enable_screen
	.globl _gfx_initialize
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
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:7: int main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-5
	add	hl, sp
	ld	sp, hl
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:11: gfx_enable_screen(0);
	xor	a, a
	call	_gfx_enable_screen
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:14: gfx_initialize(ZVB_CTRL_VID_MODE_GFX_320_4BIT, &ctx);
	ld	hl, #0
	add	hl, sp
	ex	de, hl
	ld	a, #0x07
	call	_gfx_initialize
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:17: if (assets_load_title() != 0) {
	call	_assets_load_title
	or	a, a
	jr	Z, 00102$
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:18: return 1;
	ld	de, #0x0001
	jr	00106$
00102$:
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:22: render_title_screen(&ctx);
	ld	hl, #0
	add	hl, sp
	call	_render_title_screen
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:25: gfx_enable_screen(1);
	ld	a, #0x01
	call	_gfx_enable_screen
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:28: while (1) {
00104$:
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:29: gfx_wait_vblank(&ctx);
	ld	hl, #0
	add	hl, sp
	call	_gfx_wait_vblank
	jr	00104$
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:32: return 0;
00106$:
;/home/ed/work/zeal-eaglenest/zeal/src/main.c:33: }
	ld	sp, ix
	pop	ix
	ret
	.area _TEXT
	.area _INITIALIZER
	.area _CABS (ABS)
