#!/usr/bin/env python3
"""diff_oracle.py -- compare assembled LADS bytes against the reference oracle.

Reports the longest matching prefix and a summary of mismatches. With external
labels stubbed (Phase 0), mismatches are expected exactly at the operand bytes of
cross-module JSR/JMP/refs; the matching prefix proves the toolchain + transcription
of the internal-only region byte-for-byte."""
import sys

def main():
    got = open(sys.argv[1], 'rb').read()
    ref = open(sys.argv[2], 'rb').read()
    n = min(len(got), len(ref))
    # longest common prefix
    pfx = 0
    while pfx < n and got[pfx] == ref[pfx]:
        pfx += 1
    mism = [i for i in range(n) if got[i] != ref[i]]
    print(f'assembled : {len(got)} bytes')
    print(f'oracle    : {len(ref)} bytes  (comparing first {n})')
    print(f'MATCHING PREFIX : {pfx} bytes  ($2AF8..${0x2AF8+pfx:04X})')
    print(f'total mismatches in overlap : {len(mism)} / {n}  ({100*(n-len(mism))/n:.1f}% match)')
    if mism:
        print('first 12 mismatch offsets (addr: got vs ref):')
        for i in mism[:12]:
            print(f'  +{i:04X} (${0x2AF8+i:04X}): {got[i]:02X} vs {ref[i]:02X}')
    else:
        print('*** FULL BYTE-EXACT MATCH over overlap ***')

if __name__ == '__main__':
    main()
