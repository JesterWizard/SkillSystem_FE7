"""Convert a 16x16 indexed skill icon PNG into GBA 4bpp tile data (.dmp)."""
import struct, zlib, sys


def read_indexed(path):
    d = open(path, 'rb').read()
    assert d[:8] == b'\x89PNG\r\n\x1a\n', 'not a PNG'
    idat = b''
    depth = None
    i = 8
    while i < len(d):
        ln = struct.unpack('>I', d[i:i+4])[0]
        typ = d[i+4:i+8]
        body = d[i+8:i+8+ln]
        if typ == b'IHDR':
            w, h, depth, ctype, _, _, interlace = struct.unpack('>IIBBBBB', body)
            assert (w, h, ctype, interlace) == (16, 16, 3, 0), \
                'icon must be 16x16 indexed non-interlaced; got %r' % (
                    (w, h, ctype, interlace),)
            assert depth in (4, 8), 'depth must be 4 or 8, got %r' % depth
        elif typ == b'IDAT':
            idat += body
        i += 12 + ln
    raw = zlib.decompress(idat)

    stride = 8 if depth == 4 else 16
    px = [[0]*16 for _ in range(16)]
    prev = bytearray(stride)
    pos = 0
    for y in range(16):
        f = raw[pos]; pos += 1
        line = bytearray(raw[pos:pos+stride]); pos += stride
        # PNG filters work on bytes; the filter unit rounds up to 1 byte here.
        for x in range(stride):
            a = line[x-1] if x >= 1 else 0
            b = prev[x]
            c = prev[x-1] if x >= 1 else 0
            if f == 1:   line[x] = (line[x] + a) & 0xFF
            elif f == 2: line[x] = (line[x] + b) & 0xFF
            elif f == 3: line[x] = (line[x] + (a + b) // 2) & 0xFF
            elif f == 4:
                p = a + b - c
                pa, pb, pc = abs(p-a), abs(p-b), abs(p-c)
                pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                line[x] = (line[x] + pr) & 0xFF
            elif f != 0:
                raise ValueError('bad filter %d' % f)
        prev = line
        for x in range(16):
            if depth == 4:
                byte = line[x >> 1]
                px[y][x] = (byte >> 4) if (x & 1) == 0 else (byte & 0xF)
            else:
                px[y][x] = line[x]
    return px


def to_dmp(px):
    """GBA 4bpp: four 8x8 tiles in reading order, low nibble = left pixel."""
    out = bytearray()
    for ty in (0, 8):
        for tx in (0, 8):
            for y in range(8):
                for x in range(0, 8, 2):
                    out.append((px[ty+y][tx+x+1] << 4) | px[ty+y][tx+x])
    return bytes(out)


if __name__ == '__main__':
    data = to_dmp(read_indexed(sys.argv[1]))
    assert len(data) == 128, len(data)
    open(sys.argv[2], 'wb').write(data)
    print('wrote %s (%d bytes)' % (sys.argv[2], len(data)))
