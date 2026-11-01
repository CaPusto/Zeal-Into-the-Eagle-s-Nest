#!/usr/bin/env python3
"""Decode Into The Eagle's Nest (Amiga) assets: gfx/blocks/maps/font/panel."""
import zlib, struct, sys, os
from collections import Counter

DATA = os.path.join(os.path.dirname(__file__), '..', 'data')
OUT = os.path.join(os.path.dirname(__file__), 'out')
os.makedirs(OUT, exist_ok=True)

# Amiga palette from eagle.asm (COLS)
COLS = [0x000,0x444,0x777,0x330,0x760,0x020,0x040,0x232,
        0x077,0x110,0x743,0x773,0x017,0x730,0x300,0x710]

def rgb(c):
    return ((c >> 8 & 0xF) * 17, (c >> 4 & 0xF) * 17, (c & 0xF) * 17)

def write_png(path, w, h, pix):
    """pix: bytes of length w*h*3"""
    def chunk(t, d):
        return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xffffffff)
    raw = b''.join(b'\x00' + pix[y*w*3:(y+1)*w*3] for y in range(h))
    png = (b'\x89PNG\r\n\x1a\n'
           + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0))
           + chunk(b'IDAT', zlib.compress(raw, 9))
           + chunk(b'IEND', b''))
    open(path, 'wb').write(png)
    print('wrote', path, w, 'x', h)

def decode_tile16x8(t):
    """64 bytes -> list[64] color indices, 16 wide x 8 high.
    Layout: for each row: 4 words (planes 0..3), MSB = leftmost pixel."""
    px = [0] * (16 * 8)
    for row in range(8):
        for p in range(4):
            word = (t[(row*4 + p)*2] << 8) | t[(row*4 + p)*2 + 1]
            for b in range(16):
                if word & (0x8000 >> b):
                    px[row*16 + b] |= (1 << p)
    return px

def load(fn):
    return open(os.path.join(DATA, fn), 'rb').read()

def build_image(w, h, get_px, scale=1, palette=COLS):
    cols = [rgb(c) for c in palette]
    W, H = w*scale, h*scale
    out = bytearray(W*H*3)
    for y in range(h):
        for x in range(w):
            c = cols[get_px(x, y)]
            for sy in range(scale):
                for sx in range(scale):
                    o = ((y*scale+sy)*W + (x*scale+sx))*3
                    out[o:o+3] = bytes(c)
    return bytes(out)

def save(name, w, h, get_px, scale=1, palette=COLS):
    write_png(os.path.join(OUT, name), w*scale, h*scale,
              build_image(w, h, get_px, scale, palette))

# ---------- gfx: 256 tiles x 16x8 ----------
gfx = load('gfx')
TILES = [decode_tile16x8(gfx[i*64:(i+1)*64]) for i in range(256)]

def gfx_sheet():
    # 16x16 tiles, tile i at (i%16, i//16), cell 16x8, scale 2
    scale = 2
    W, H = 16*16*scale, 16*8*scale
    out = bytearray(W*H*3)
    cols = [rgb(c) for c in COLS]
    for i, t in enumerate(TILES):
        tx, ty = (i % 16)*16, (i // 16)*8
        for y in range(8):
            for x in range(16):
                c = cols[t[y*16+x]]
                for sy in range(scale):
                    for sx in range(scale):
                        o = ((ty+y)*scale+sy)*W*scale + ((tx+x)*scale+sx)*3
                        # o computed below properly
                        oy = ((ty+y)*scale+sy)
                        ox = ((tx+x)*scale+sx)
                        o = (oy*W + ox)*3
                        out[o:o+3] = bytes(c)
    write_png(os.path.join(OUT, 'gfx_sheet.png'), W, H, bytes(out))

# ---------- blocks: 128 x 16 bytes (4x4 tile indices) ----------
blocks = load('blocks')
NBLK = len(blocks)//16
BLOCKS = [[blocks[i*16+j] for j in range(16)] for i in range(NBLK)]

# ---------- maps: 2 files x 4 levels, stride 1024, 24x42 cells ----------
def load_levels(fn):
    d = load(fn)
    lv = []
    for L in range(4):
        base = L*1024
        cells = []          # [y][x] of 24x42, value=block idx, -1=enemy marker
        enemies = []
        for cy in range(42):
            row = []
            for cx in range(24):
                v = d[base + cy*24 + cx]
                if v == 0xFF:
                    enemies.append((cx, cy))
                    row.append(0)
                else:
                    row.append(v if v < NBLK else 0)
            cells.append(row)
        lv.append({'cells': cells, 'enemies': enemies})
    return lv

LEVELS = load_levels('maps') + load_levels('maps2')

def expand_cells(cells):
    """24x42 block cells -> 96x168 tile cells"""
    grid = [[0]*96 for _ in range(168)]
    for cy in range(42):
        for cx in range(24):
            b = BLOCKS[cells[cy][cx]]
            for by in range(4):
                for bx in range(4):
                    grid[cy*4+by][cx*4+bx] = b[by*4+bx]
    return grid

def level_image(idx, scale=1):
    lv = LEVELS[idx]
    g = expand_cells(lv['cells'])
    W, H = 96 * 16, 168 * 8
    cols = [rgb(c) for c in COLS]
    out = bytearray(W * H * 3)
    for cy in range(168):
        for cx in range(96):
            t = TILES[g[cy][cx]]
            for y in range(8):
                row = ((cy * 8 + y) * W + cx * 16) * 3
                for x in range(16):
                    c = cols[t[y * 16 + x]]
                    out[row + x * 3:row + x * 3 + 3] = bytes(c)
    # enemy spawn markers ($FF in the map): a red plus centered in the
    # 64x32-px block, so the map art stays readable underneath.
    RED = b'\xff\x00\x00'
    for (ex, ey) in lv['enemies']:
        bx, by = ex * 64 + 31, ey * 32 + 15
        for k in range(-6, 7):
            for j in range(-1, 2):
                px, py = bx + j, by + k
                if 0 <= px < W and 0 <= py < H:
                    o = (py * W + px) * 3
                    out[o:o + 3] = RED
                px, py = bx + k, by + j
                if 0 <= px < W and 0 <= py < H:
                    o = (py * W + px) * 3
                    out[o:o + 3] = RED
    if scale != 1:
        W2, H2 = W*scale, H*scale
        out2 = bytearray(W2*H2*3)
        for y in range(H2):
            sy = y//scale
            row = out[sy*W*3:(sy+1)*W*3]
            for x in range(W2):
                sx3 = (x//scale)*3
                out2[y*W2*3+x*3:y*W2*3+x*3+3] = row[sx3:sx3+3]
        out, W, H = out2, W2, H2
    write_png(os.path.join(OUT, f'level{idx}.png'), W, H, bytes(out))

def stats():
    all_tiles = set()
    per_level_pairs = []
    all_pairs = set()
    for i, lv in enumerate(LEVELS):
        g = expand_cells(lv['cells'])
        tiles = set()
        pairs = set()
        for cy in range(0, 168, 2):
            for cx in range(96):
                a, b = g[cy][cx], g[cy+1][cx]
                pairs.add((a, b))
                tiles.add(a); tiles.add(b)
        per_level_pairs.append(len(pairs))
        all_tiles |= tiles
        all_pairs |= pairs
    print('unique tiles used by maps:', len(all_tiles))
    print('unique vertical pairs per level:', per_level_pairs)
    print('unique vertical pairs all 8 levels:', len(all_pairs))
    # tiles referenced but outside gfx range
    bad = [t for t in all_tiles if t >= 256]
    print('out-of-range tile refs:', bad[:10])

# ---------- font ----------
def font_sheet():
    font = load('font')
    n = len(font)//64
    print('font glyphs:', n)
    scale = 3
    W, H = n*16*scale, 8*scale
    out = bytearray(W*H*3)
    cols = [rgb(c) for c in COLS]
    for i in range(n):
        t = decode_tile16x8(font[i*64:(i+1)*64])
        for y in range(8):
            for x in range(16):
                c = cols[t[y*16+x]]
                for sy in range(scale):
                    for sx in range(scale):
                        o = (((y*scale+sy))*W + (i*16*scale + x*scale+sx))*3
                        out[o:o+3] = bytes(c)
    write_png(os.path.join(OUT, 'font_sheet.png'), W, H, bytes(out))

# ---------- raw screens: 32 byte palette + 4 planes x 8000 ----------
def raw_screen(fn, outname, scale=1):
    d = load(fn)
    pal = [struct.unpack('>H', d[i*2:i*2+2])[0] & 0xFFF for i in range(16)]
    img = d[32:]
    W, H = 320, 200
    cols = [rgb(c) for c in pal]
    out = bytearray(W*H*3)
    for y in range(H):
        for x in range(W):
            b = x // 8
            bit = 7 - (x % 8)
            v = 0
            for p in range(4):
                if img[p*8000 + y*40 + b] & (1 << bit):
                    v |= 1 << p
            o = (y*W + x)*3
            out[o:o+3] = bytes(cols[v])
    if scale != 1:
        W2, H2 = W*scale, H*scale
        o2 = bytearray(W2*H2*3)
        for y in range(H2):
            row = out[(y//scale)*W*3:((y//scale)+1)*W*3]
            for x in range(W2):
                o2[y*W2*3+x*3:y*W2*3+x*3+3] = row[(x//scale)*3:(x//scale)*3+3]
        out, W, H = o2, W2, H2
    write_png(os.path.join(OUT, outname), W, H, bytes(out))

# ---------- panel.raw: same format ----------
def panel():
    d = load('panel.raw')
    pal = [struct.unpack('>H', d[i*2:i*2+2])[0] & 0xFFF for i in range(16)]
    print('panel palette:', [hex(c) for c in pal])
    img = d[32:] if len(d) == 32032 else d
    print('panel size', len(d))

if __name__ == '__main__':
    what = sys.argv[1] if len(sys.argv) > 1 else 'all'
    if what in ('all', 'gfx'):
        gfx_sheet()
        font_sheet()
    if what in ('all', 'stats'):
        stats()
    if what in ('all', 'levels'):
        for i in range(8):
            level_image(i, scale=1)
    if what in ('all', 'screens'):
        raw_screen('scrn.raw', 'scrn.png', scale=1)
        raw_screen('ms.raw', 'ms.png', scale=1)
        panel()
