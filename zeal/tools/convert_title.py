#!/usr/bin/env python3
"""Convert Amiga planar format to Zeal tileset format."""

import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
DATA = os.path.join(PROJECT_ROOT, 'data')
OUT = os.path.normpath(os.path.join(HERE, '..', 'bin', 'gen'))

os.makedirs(OUT, exist_ok=True)

def load_planar(path):
    """Load Amiga planar screen (320x200x4bp with palette header)."""
    with open(path, 'rb') as f:
        data = f.read()
    
    if len(data) < 32032:
        raise ValueError(f"Expected at least 32032 bytes, got {len(data)}")
    
    palette_data = data[0:32]
    planar_data = data[32:32032]
    
    planes = []
    for p in range(4):
        planes.append(planar_data[p * 8000:(p + 1) * 8000])
    
    return planes, palette_data

def get_pixel(planes, x, y):
    """Get pixel color index from planar data."""
    byte_offset = y * 40 + x // 8
    bit = 7 - (x % 8)
    
    color = 0
    for p in range(4):
        if byte_offset < len(planes[p]) and planes[p][byte_offset] & (1 << bit):
            color |= (1 << p)
    
    return color

def planar_to_tileset(planes):
    """Convert planar screen to Zeal tileset (16x16 tiles)."""
    tileset = bytearray()
    tilemap = bytearray()
    
    width = 320
    height = 200
    tile_w = 16
    tile_h = 16
    
    tiles_x = width // tile_w  # 20
    tiles_y = height // tile_h  # 12
    
    seen_tiles = {}
    tile_idx = 0
    
    # Create tiles
    for ty in range(tiles_y):
        for tx in range(tiles_x):
            # Extract 16x16 tile - 128 bytes (16x16 pixels in 4bpp = 2 pixels/byte)
            tile_data = bytearray(128)
            
            for py in range(tile_h):
                # Each row is 8 bytes (16 pixels / 2 pixels per byte)
                row_offset = py * 8
                
                for px in range(0, tile_w, 2):
                    # Get two consecutive pixels
                    x1 = tx * tile_w + px
                    y1 = ty * tile_h + py
                    
                    x2 = x1 + 1
                    
                    p1 = get_pixel(planes, x1, y1)
                    p2 = get_pixel(planes, x2, y1)
                    
                    # Pack into byte: high nibble = left pixel, low nibble = right pixel
                    byte_idx = row_offset + px // 2
                    tile_data[byte_idx] = (p1 << 4) | p2
            
            tile_key = bytes(tile_data)
            
            # Deduplication
            if tile_key not in seen_tiles:
                seen_tiles[tile_key] = tile_idx
                tileset.extend(tile_data)
                tile_idx += 1
            
            tilemap.append(seen_tiles[tile_key])
    
    return bytes(tileset), bytes(tilemap)

def palette_amiga_to_rgb565(pal_data):
    """Convert Amiga 12-bit palette to RGB565.
    
    Amiga format: Each word is RRRRGGGGBBBB (4 bits per channel)
    RGB565 format: RRRRRGGGGGGBBBBB
    """
    palette = bytearray()
    
    for i in range(0, len(pal_data), 2):
        # Big-endian 12-bit Amiga color
        w = (pal_data[i] << 8) | pal_data[i + 1]
        
        # Extract 4-bit components
        r4 = (w >> 8) & 0xF
        g4 = (w >> 4) & 0xF
        b4 = w & 0xF
        
        # Convert 4-bit (0-15) to 8-bit (0-255)
        r8 = r4 * 17
        g8 = g4 * 17
        b8 = b4 * 17
        
        # Convert to RGB565
        r5 = (r8 >> 3) & 0x1F
        g6 = (g8 >> 2) & 0x3F
        b5 = (b8 >> 3) & 0x1F
        
        rgb565 = (r5 << 11) | (g6 << 5) | b5
        palette.extend(struct.pack('<H', rgb565))
    
    return bytes(palette)

# Load and convert
print("Loading scrn.raw...")
scrn_path = os.path.join(DATA, 'scrn.raw')
planes, pal_header = load_planar(scrn_path)

print("Converting to tileset...")
tileset, tilemap = planar_to_tileset(planes)

print("Converting palette...")
palette = palette_amiga_to_rgb565(pal_header)

# Write files
with open(os.path.join(OUT, 'title.zts'), 'wb') as f:
    f.write(tileset)
print(f"✓ title.zts: {len(tileset)} bytes ({len(tileset)//128} tiles)")

with open(os.path.join(OUT, 'title.ztm'), 'wb') as f:
    f.write(tilemap)
print(f"✓ title.ztm: {len(tilemap)} bytes")

with open(os.path.join(OUT, 'title.ztp'), 'wb') as f:
    f.write(palette)
print(f"✓ title.ztp: {len(palette)} bytes")

print("Done!")
