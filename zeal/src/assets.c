#include "assets.h"
#include <zos_vfs.h>
#include <zos_sys.h>

asset_t title_tiles;
asset_t title_map;
asset_t title_palette;

static char asset_buf[48];

static const char* asset_prep(const char* pre, const char* name) {
    uint8_t i = 0, j = 0;
    while (pre[i] != 0) {
        asset_buf[i] = pre[i];
        i++;
    }
    while (name[j] != 0) {
        asset_buf[i] = name[j];
        i++;
        j++;
    }
    asset_buf[i] = 0;
    return asset_buf;
}

void* asset_map_page(asset_t* a, uint8_t page) {
    if (page >= a->npages) return (void*)0;
    if (pmap(a->pages[page], ASSET_BANK_ADDR) != ERR_SUCCESS) return (void*)0;
    return ASSET_BANK_ADDR;
}

void* asset_map_off(asset_t* a, uint16_t off) {
    uint8_t page = (uint8_t)(off / ASSET_PAGE_SIZE);
    uint16_t rem = (uint16_t)(off % ASSET_PAGE_SIZE);
    char* base = (char*)asset_map_page(a, page);
    if (base == (char*)0) return (void*)0;
    return base + rem;
}

static zos_err_t asset_load(const char* name, asset_t* out) {
    zos_dev_t fd;
    zos_stat_t st;
    uint16_t total;
    uint8_t i;

    out->npages = 0;
    out->size = 0;

    fd = open(name, O_RDONLY);
    if (fd < 0) return ERR_FAILURE;
    if (dstat(fd, &st) != ERR_SUCCESS) {
        close(fd);
        return ERR_FAILURE;
    }
    
    total = (uint16_t)st.s_size;
    out->size = total;
    out->npages = (uint8_t)((total + ASSET_PAGE_SIZE - 1) / ASSET_PAGE_SIZE);
    if (out->npages == 0) out->npages = 1;
    if (out->npages > ASSET_MAX_PAGES) {
        close(fd);
        return ERR_FAILURE;
    }

    for (i = 0; i < out->npages; i++) {
        if (palloc(&out->pages[i]) != ERR_SUCCESS) {
            close(fd);
            return ERR_NO_MORE_MEMORY;
        }
    }

    for (i = 0; i < out->npages; i++) {
        uint16_t n = total;
        if (n > ASSET_PAGE_SIZE) n = ASSET_PAGE_SIZE;
        if (pmap(out->pages[i], ASSET_BANK_ADDR) != ERR_SUCCESS) {
            close(fd);
            return ERR_FAILURE;
        }
        if (read(fd, ASSET_BANK_ADDR, &n) != ERR_SUCCESS) {
            close(fd);
            return ERR_FAILURE;
        }
        total -= n;
        if (total == 0) break;
    }

    close(fd);
    return ERR_SUCCESS;
}

static zos_err_t asset_load_pair(const char* name, asset_t* out) {
    if (asset_load(asset_prep("gen/", name), out) == ERR_SUCCESS) return ERR_SUCCESS;
    return asset_load(asset_prep("H:/gen/", name), out);
}

zos_err_t assets_load_title(void) {
    if (asset_load_pair("title.zts", &title_tiles) != ERR_SUCCESS) return ERR_FAILURE;
    if (asset_load_pair("title.ztm", &title_map) != ERR_SUCCESS) return ERR_FAILURE;
    if (asset_load_pair("title.ztp", &title_palette) != ERR_SUCCESS) return ERR_FAILURE;
    return ERR_SUCCESS;
}
