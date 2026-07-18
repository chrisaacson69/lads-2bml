#!/usr/bin/env python3
"""mk_d64.py -- write a single PRG onto a fresh 1541 .d64 disk image (C64/VIC/PET family).
   usage: mk_d64.py <prg> <PRGNAME> <DISKNAME> <out.d64>

Implements the standard 35-track 683-block D64 layout: BAM + directory on track 18,
file data chained through track/sector links, BAM marking allocated blocks."""
import sys

def spt(t):                      # sectors per track (1-indexed)
    return 21 if t <= 17 else 19 if t <= 24 else 18 if t <= 30 else 17

def track_start(t):
    return sum(spt(x) for x in range(1, t)) * 256

def sec(t, s):
    return track_start(t) + s * 256

def main():
    prg, name, disk, out = sys.argv[1:5]
    data = open(prg, 'rb').read()
    img = bytearray(683 * 256)

    # data blocks in track/sector order, skipping the directory track 18
    chunks = [data[i:i + 254] for i in range(0, len(data), 254)] or [b'']
    free = [(t, s) for t in range(1, 36) if t != 18 for s in range(spt(t))]
    used = free[:len(chunks)]
    for i, (t, s) in enumerate(used):
        o = sec(t, s)
        if i + 1 < len(used):
            img[o], img[o + 1] = used[i + 1]           # link to next block
        else:
            img[o], img[o + 1] = 0, len(chunks[i]) + 1  # last: 0, bytes-used+1
        img[o + 2:o + 2 + len(chunks[i])] = chunks[i]

    allocated = set(used) | {(18, 0), (18, 1)}
    bam = sec(18, 0)
    img[bam], img[bam + 1], img[bam + 2], img[bam + 3] = 18, 1, 0x41, 0
    for t in range(1, 36):
        e = bam + 4 + (t - 1) * 4
        bits = 0; cnt = 0
        for s in range(spt(t)):
            if (t, s) not in allocated:
                bits |= 1 << s; cnt += 1
        img[e] = cnt
        img[e + 1], img[e + 2], img[e + 3] = bits & 0xFF, (bits >> 8) & 0xFF, (bits >> 16) & 0xFF
    nm = disk.upper().encode('ascii')[:16].ljust(16, b'\xA0')
    img[bam + 0x90:bam + 0xA0] = nm
    img[bam + 0xA0:bam + 0xA2] = b'\xA0\xA0'
    img[bam + 0xA2:bam + 0xA4] = b'01'
    img[bam + 0xA4] = 0xA0
    img[bam + 0xA5:bam + 0xA7] = b'2A'
    img[bam + 0xA7:bam + 0xAB] = b'\xA0' * 4

    d = sec(18, 1)
    img[d], img[d + 1] = 0, 0xFF                        # only/last directory sector
    img[d + 2] = 0x82                                   # file type PRG, closed
    img[d + 3], img[d + 4] = used[0]                    # first data block T/S
    img[d + 5:d + 0x15] = name.upper().encode('ascii')[:16].ljust(16, b'\xA0')
    img[d + 0x1E], img[d + 0x1F] = len(chunks) & 0xFF, (len(chunks) >> 8) & 0xFF

    open(out, 'wb').write(img)
    blocks_free = sum(img[bam + 4 + (t - 1) * 4] for t in range(1, 36) if t != 18)
    print(f'{out}: {len(img)} bytes, "{name}" = {len(chunks)} blocks, {blocks_free} free')

if __name__ == '__main__':
    main()
