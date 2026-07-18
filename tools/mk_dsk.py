#!/usr/bin/env python3
"""mk_dsk.py -- write a binary as a DOS 3.3 'B' file onto a fresh 140K .dsk (Apple II).
   usage: mk_dsk.py <bin> <NAME> <load_addr_hex> <out.dsk>

35 tracks x 16 sectors x 256 = 143360 bytes (DOS logical sector order). VTOC + catalog on
track 17; a B file stores a 4-byte header (load addr, length) then the image, reached via a
T/S-list sector. Structurally per the DOS 3.3 spec (filename bytes carry the high bit set)."""
import sys

TRK, SEC, SS = 35, 16, 256

def main():
    src, name, addr_s, out = sys.argv[1:5]
    data = open(src, 'rb').read(); addr = int(addr_s, 16)
    img = bytearray(TRK * SEC * SS)
    def off(t, s): return (t * SEC + s) * SS

    content = bytes([addr & 0xFF, addr >> 8, len(data) & 0xFF, len(data) >> 8]) + data
    chunks = [content[i:i + SS] for i in range(0, len(content), SS)]
    free = [(t, s) for t in range(1, TRK) if t != 17 for s in range(SEC)]
    tsl = free[0]; dts = free[1:1 + len(chunks)]
    allocated = {(0, s) for s in range(SEC)} | {(17, s) for s in range(SEC)} | {tsl} | set(dts)

    for i, (t, s) in enumerate(dts):
        o = off(t, s); img[o:o + len(chunks[i])] = chunks[i]
    o = off(*tsl)                                    # T/S list sector
    for i, (t, s) in enumerate(dts):
        img[o + 0x0C + i * 2] = t; img[o + 0x0C + i * 2 + 1] = s

    v = off(17, 0)                                   # VTOC
    img[v + 0x01], img[v + 0x02], img[v + 0x03] = 17, 15, 3
    img[v + 0x06] = 254                              # volume number
    img[v + 0x27] = 122                              # T/S pairs per list sector
    img[v + 0x30], img[v + 0x31] = 17, 1
    img[v + 0x34], img[v + 0x35] = TRK, SEC
    img[v + 0x36], img[v + 0x37] = 0x00, 0x01        # 256 bytes/sector
    for t in range(TRK):                             # free bitmap: 4 bytes/track
        b0 = b1 = 0
        for s in range(SEC):
            if (t, s) not in allocated:
                if s >= 8: b0 |= 1 << (s - 8)
                else:      b1 |= 1 << s
        e = v + 0x38 + t * 4
        img[e], img[e + 1] = b0, b1

    c = off(17, 15)                                  # catalog (single sector, next = 0,0)
    e = c + 0x0B                                     # first file entry
    img[e], img[e + 1] = tsl                         # T/S list track, sector
    img[e + 0x02] = 0x04                             # type B (binary), unlocked
    fn = name.upper().encode('ascii')[:30].ljust(30, b' ')
    img[e + 0x03:e + 0x21] = bytes(x | 0x80 for x in fn)
    nsec = len(chunks) + 1
    img[e + 0x21], img[e + 0x22] = nsec & 0xFF, nsec >> 8

    open(out, 'wb').write(img)
    print(f'{out}: {len(img)} bytes, {name} (B,${addr:04X}) = {len(chunks)} data + 1 TSL sectors')

if __name__ == '__main__':
    main()
