#include <stdint.h>
#include <zvb_gfx.h>

#include "assets.h"
#include "render.h"

int main(void) {
    gfx_context ctx;
    
    /* Отключаем экран перед загрузкой */
    gfx_enable_screen(0);
    
    /* Инициализация видеорежима */
    gfx_initialize(ZVB_CTRL_VID_MODE_GFX_320_4BIT, &ctx);
    
    /* Загружаем ассеты заставки с диска */
    if (assets_load_title() != 0) {
        return 1;
    }
    
    /* Отображаем заставку */
    render_title_screen(&ctx);
    
    /* Включаем экран для отображения */
    gfx_enable_screen(1);
    
    /* Основной цикл */
    while (1) {
        gfx_wait_vblank(&ctx);
    }
    
    return 0;
}
