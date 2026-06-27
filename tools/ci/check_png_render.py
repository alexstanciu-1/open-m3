#!/usr/bin/env python3
import argparse
import struct
import sys
import zlib
from pathlib import Path


def decode_png(path: Path):
    data = path.read_bytes()
    if data[:8] != b'\x89PNG\r\n\x1a\n':
        raise ValueError('not a PNG file')

    pos = 8
    width = height = bit_depth = color_type = None
    raw = b''
    palette = []
    while pos < len(data):
        length = struct.unpack('>I', data[pos:pos + 4])[0]
        pos += 4
        chunk_type = data[pos:pos + 4]
        pos += 4
        chunk = data[pos:pos + length]
        pos += length + 4
        if chunk_type == b'IHDR':
            width, height, bit_depth, color_type, compression, filter_method, interlace = struct.unpack('>IIBBBBB', chunk)
            if compression != 0 or filter_method != 0 or interlace != 0:
                raise ValueError('unsupported PNG compression/filter/interlace settings')
        elif chunk_type == b'PLTE':
            palette = [tuple(chunk[index:index + 3]) for index in range(0, len(chunk), 3)]
        elif chunk_type == b'IDAT':
            raw += chunk
        elif chunk_type == b'IEND':
            break

    if width is None or height is None:
        raise ValueError('missing PNG header')

    if color_type == 0 and bit_depth == 1:
        return width, height, read_grayscale_1bit(zlib.decompress(raw), width, height)
    if color_type == 3 and bit_depth in (1, 2, 4, 8):
        return width, height, read_indexed(zlib.decompress(raw), width, height, bit_depth, palette)
    if color_type in (2, 6) and bit_depth == 8:
        channels = 3 if color_type == 2 else 4
        return width, height, read_rgb_8bit(zlib.decompress(raw), width, height, channels)

    raise ValueError(f'unsupported PNG format: bit_depth={bit_depth}, color_type={color_type}')


def unfilter_scanline(filter_type: int, scanline: bytearray, previous: bytearray, bytes_per_pixel: int) -> bytearray:
    for index, value in enumerate(scanline):
        left = scanline[index - bytes_per_pixel] if index >= bytes_per_pixel else 0
        up = previous[index]
        upper_left = previous[index - bytes_per_pixel] if index >= bytes_per_pixel else 0
        if filter_type == 1:
            scanline[index] = (value + left) & 0xFF
        elif filter_type == 2:
            scanline[index] = (value + up) & 0xFF
        elif filter_type == 3:
            scanline[index] = (value + ((left + up) // 2)) & 0xFF
        elif filter_type == 4:
            prediction = left + up - upper_left
            left_distance = abs(prediction - left)
            up_distance = abs(prediction - up)
            upper_left_distance = abs(prediction - upper_left)
            predictor = left if left_distance <= up_distance and left_distance <= upper_left_distance else up if up_distance <= upper_left_distance else upper_left
            scanline[index] = (value + predictor) & 0xFF
        elif filter_type != 0:
            raise ValueError(f'unsupported PNG row filter: {filter_type}')
    return scanline


def read_indexed(data: bytes, width: int, height: int, bit_depth: int, palette):
    if not palette:
        raise ValueError('indexed PNG is missing a palette')
    row_bytes = (width * bit_depth + 7) // 8
    previous = bytearray(row_bytes)
    offset = 0
    pixels = []
    mask = (1 << bit_depth) - 1
    for _ in range(height):
        filter_type = data[offset]
        offset += 1
        scanline = bytearray(data[offset:offset + row_bytes])
        offset += row_bytes
        scanline = unfilter_scanline(filter_type, scanline, previous, 1)
        for x in range(width):
            bit_offset = x * bit_depth
            byte = scanline[bit_offset // 8]
            shift = 8 - bit_depth - (bit_offset % 8)
            index = (byte >> shift) & mask
            pixels.append(palette[index] if index < len(palette) else (0, 0, 0))
        previous = scanline
    return pixels


def read_rgb_8bit(data: bytes, width: int, height: int, channels: int):
    stride = width * channels
    previous = bytearray(stride)
    offset = 0
    pixels = []
    for _ in range(height):
        filter_type = data[offset]
        offset += 1
        scanline = bytearray(data[offset:offset + stride])
        offset += stride
        scanline = unfilter_scanline(filter_type, scanline, previous, channels)
        for x in range(width):
            start = x * channels
            pixels.append(tuple(scanline[start:start + 3]))
        previous = scanline
    return pixels


def read_grayscale_1bit(data: bytes, width: int, height: int):
    row_bytes = (width + 7) // 8
    previous = bytearray(row_bytes)
    offset = 0
    pixels = []
    for _ in range(height):
        filter_type = data[offset]
        offset += 1
        scanline = bytearray(data[offset:offset + row_bytes])
        offset += row_bytes
        scanline = unfilter_scanline(filter_type, scanline, previous, 1)
        for x in range(width):
            byte = scanline[x // 8]
            bit = 7 - (x % 8)
            value = 255 if ((byte >> bit) & 1) else 0
            pixels.append((value, value, value))
        previous = scanline
    return pixels


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('path')
    parser.add_argument('--min-width', type=int, default=300)
    parser.add_argument('--min-height', type=int, default=300)
    parser.add_argument('--min-mean', type=float, default=110.0)
    parser.add_argument('--min-unique', type=int, default=24)
    parser.add_argument('--require-openm3-ui', action='store_true')
    parser.add_argument('--require-smoke-action', action='store_true')
    args = parser.parse_args()

    path = Path(args.path)
    width, height, pixels = decode_png(path)
    if width < args.min_width or height < args.min_height:
        print(f'{path}: too small: {width}x{height}', file=sys.stderr)
        return 1

    step = max(1, len(pixels) // 12000)
    sample = pixels[::step]
    mean = sum((r + g + b) / 3 for r, g, b in sample) / len(sample)
    unique = len({(r // 8, g // 8, b // 8) for r, g, b in sample})
    center = pixels[(height // 2) * width + (width // 2)]
    openm3_ui_pixels = sum(
        1 for r, g, b in pixels
        if (20 <= r <= 45 and 70 <= g <= 95 and 80 <= b <= 105)
        or (10 <= r <= 35 and 45 <= g <= 75 and 50 <= b <= 85)
    )
    smoke_pixels = sum(
        1 for r, g, b in pixels
        if 35 <= r <= 65 and 110 <= g <= 140 and 40 <= b <= 65
    )
    print(f'{path}: {width}x{height}, mean={mean:.1f}, unique={unique}, center={center}, openm3_ui_pixels={openm3_ui_pixels}, smoke_pixels={smoke_pixels}')

    if mean < args.min_mean:
        print(f'{path}: image is too dark or blank', file=sys.stderr)
        return 1
    if unique < args.min_unique:
        print(f'{path}: image has too little visual variation', file=sys.stderr)
        return 1
    if args.require_openm3_ui and openm3_ui_pixels < 6:
        print(f'{path}: OpenM3 UI color signal was not found', file=sys.stderr)
        return 1
    if args.require_smoke_action and smoke_pixels < 6:
        print(f'{path}: runtime smoke action marker was not found', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
