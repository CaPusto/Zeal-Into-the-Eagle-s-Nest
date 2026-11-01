#include "render.h"
#include "assets.h"
#include <zvb_gfx.h>
#include <string.h>

void render_title_screen(gfx_context* ctx) {
    uint8_t y, line[20];
    gfx_tileset_options opts;
    uint8_t* data;
    
    /* Загружаем палитру с диска */
    data = (uint8_t*)asset_map_off(&title_palette, 0);
    if (data) {
        const size_t palette_size = title_palette.size;
        if (palette_size > 0) {
            gfx_palette_load(ctx, data, palette_size, 0);
        }
    }
    
    /* Загружаем тайлсет (4-bit tiles) */
    opts.compression = 0;  /* TILESET_COMP_NONE */
    opts.from_byte = 0;
    opts.pal_offset = 0;
    opts.opacity = 0;
    
    data = (uint8_t*)asset_map_page(&title_tiles, 0);
    if (data && title_tiles.size > 0) {
        gfx_tileset_load(ctx, data, 
                        title_tiles.size > 32768 ? 32768 : title_tiles.size,
                        &opts);
    }
    
    /* Загружаем тайлмап - LAYER 0 (tile indices)
     * Amiga: 20x12 тайлов
     * Zeal: 20x15 тайлов (добавляем 3 пустых ряда внизу)
     */
    data = (uint8_t*)asset_map_page(&title_map, 0);
    if (data) {
        /* Первые 12 рядов из файла */
        for (y = 0; y < 12 && y * 20 < title_map.size; y++) {
            memcpy(line, data + y * 20, 20);
            gfx_tilemap_load(ctx, line, 20, 0, 0, y);  /* layer 0 */
        }
        
        /* 3 дополнительных ряда - черные тайлы */
        memset(line, 0, 20);
        for (y = 12; y < 15; y++) {
            gfx_tilemap_load(ctx, line, 20, 0, 0, y);  /* layer 0 */
        }
    }
    
    /* Загружаем LAYER 1 (attributes) - все нули */
    memset(line, 0, 20);
    for (y = 0; y < 15; y++) {
        gfx_tilemap_load(ctx, line, 20, 1, 0, y);  /* layer 1 */
    }
}
