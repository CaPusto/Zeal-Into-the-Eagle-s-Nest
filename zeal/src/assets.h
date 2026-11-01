#ifndef EAGLENEST_ASSETS_H
#define EAGLENEST_ASSETS_H

#include <stdint.h>
#include <zos_errors.h>

#define ASSET_PAGE_SIZE  16384
#define ASSET_MAX_PAGES  5
#define ASSET_BANK_ADDR  ((void*)0x8000)

typedef struct {
    uint8_t  npages;
    uint8_t  pages[ASSET_MAX_PAGES];
    uint16_t size;
} asset_t;

extern asset_t title_tiles;
extern asset_t title_map;
extern asset_t title_palette;

void* asset_map_page(asset_t* a, uint8_t page);
void* asset_map_off(asset_t* a, uint16_t off);
zos_err_t assets_load_title(void);

#endif
