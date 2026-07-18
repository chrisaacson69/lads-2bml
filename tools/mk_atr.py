#!/usr/bin/env python3
"""mk_atr.py -- write a file onto a fresh Atari DOS 2.0S single-density .atr disk.
   usage: mk_atr.py <file> <NAME> <EXT> <out.atr>

Single density: 720 sectors x 128 bytes. Boot 1-3, VTOC sector 360, directory 361-368,
file data on the rest. Each data sector's last 3 bytes: file#<<2|next_hi, next_lo, bytes_used."""
import sys

NSEC, SS = 720, 128

def main():
    src, name, ext, out = sys.argv[1:5]
    data = open(src, 'rb').read()
    img = bytearray(NSEC * SS)                       # sector N at (N-1)*SS
    def put(n, off, b): img[(n - 1) * SS + off] = b

    chunks = [data[i:i + 125] for i in range(0, len(data), 125)] or [b'']
    free = [n for n in range(4, NSEC + 1) if not (360 <= n <= 368)]
    used = free[:len(chunks)]
    for i, sn in enumerate(used):
        o = (sn - 1) * SS
        img[o:o + len(chunks[i])] = chunks[i]
        nxt = used[i + 1] if i + 1 < len(used) else 0
        img[o + 125] = (0 << 2) | ((nxt >> 8) & 0x03)   # file #0
        img[o + 126] = nxt & 0xFF
        img[o + 127] = len(chunks[i])

    # VTOC (sector 360): DOS code, total available, free count, allocation bitmap
    allocated = set(range(1, 4)) | {360} | set(range(361, 369)) | set(used)
    v = (360 - 1) * SS
    img[v] = 2
    img[v + 1], img[v + 2] = 707 & 0xFF, 707 >> 8         # total available sectors
    freecnt = 0
    for n in range(NSEC):                                 # bitmap bytes $0A..; bit7=sector0
        if n in allocated:
            continue
        img[v + 10 + n // 8] |= 1 << (7 - n % 8)
        if n >= 4:
            freecnt += 1
    img[v + 3], img[v + 4] = freecnt & 0xFF, freecnt >> 8

    # directory (sector 361), first 16-byte entry
    d = (361 - 1) * SS
    img[d] = 0x42                                          # flag: in-use, DOS2-created
    img[d + 1], img[d + 2] = len(chunks) & 0xFF, len(chunks) >> 8
    img[d + 3], img[d + 4] = used[0] & 0xFF, used[0] >> 8
    img[d + 5:d + 13] = name.upper().encode('ascii')[:8].ljust(8, b' ')
    img[d + 13:d + 16] = ext.upper().encode('ascii')[:3].ljust(3, b' ')

    para = NSEC * SS // 16
    header = bytes([0x96, 0x02, para & 0xFF, (para >> 8) & 0xFF, SS & 0xFF, (SS >> 8) & 0xFF]) + bytes(10)
    open(out, 'wb').write(header + img)
    print(f'{out}: {len(header)+len(img)} bytes, {name}.{ext} = {len(chunks)} sectors, {freecnt} free')

if __name__ == '__main__':
    main()
