#!/usr/bin/env python3
"""align_labels.py -- propagate C64 labels onto a port by opcode-sequence alignment.

The ports (Atari/Apple) share most of their assembler LOGIC with the byte-exact C64
build; only the I/O layer differs. So wherever the port's opcode stream matches the
C64's, the routine is the same one -- and the operand at each matched instruction points
to the C64 variable in C64 and the port's equivalent variable in the port. We anchor on
unique opcode k-grams, extend the match, and copy C64 labels (routine names) + operand
labels (variables) onto the port addresses. I/O code doesn't align, so it's left alone.

  usage: align_labels.py <c64.bin> <c64.labels> <port.bin> <port_origin> <port_code_end> <out.labels>
"""
import sys, os
from collections import defaultdict, Counter
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from dis6502 import OPS, SZ

C64_ORIGIN, C64_CODE_END = 0x2AF8, 0x3C1C   # C64 code region (data/tables start $3C1C)
MEMOP = ('abs', 'abx', 'aby', 'zp', 'zpx', 'zpy', 'izx', 'izy')

def seq(mem, origin, code_end):
    out = []; addr = origin
    while addr < code_end:
        op = mem[addr - origin]; mn, md = OPS.get(op, ('.byte', 'imp'))
        n = SZ[md] if mn != '.byte' else 1
        if addr + n > code_end: break
        a = mem[addr - origin + 1] if n > 1 else 0
        w = (mem[addr - origin + 2] << 8 | a) if n > 2 else 0
        val = a if md in ('zp', 'zpx', 'zpy', 'izx', 'izy') else (
              w if md in ('abs', 'abx', 'aby', 'ind') else None)
        out.append((addr, op, md, val)); addr += n
    return out

def load_labels(path):
    d = {}
    for ln in open(path):
        p = ln.split()
        if len(p) >= 3 and p[0] == 'al':
            d[int(p[1], 16)] = p[2].lstrip('.')
    return d

def main():
    c64b, c64l, portb, porg, pend, out = sys.argv[1:7]
    c64 = seq(open(c64b, 'rb').read(), C64_ORIGIN, C64_CODE_END)
    port = seq(open(portb, 'rb').read(), int(porg, 16), int(pend, 16))
    lab = load_labels(c64l)

    K = 8
    grams = defaultdict(list)
    for i in range(len(c64) - K):
        grams[tuple(c64[j][1] for j in range(i, i + K))].append(i)
    uniq = {g: v[0] for g, v in grams.items() if len(v) == 1}   # anchor only on unique runs

    votes = defaultdict(Counter); covered = 0; i = 0   # votes[port_addr][name] += 1
    while i < len(port) - K:
        g = tuple(port[j][1] for j in range(i, i + K))
        ci = uniq.get(g)
        if ci is None:
            i += 1; continue
        pi, cj = i, ci
        while pi < len(port) and cj < len(c64) and port[pi][1] == c64[cj][1]:
            pa, ca = port[pi][0], c64[cj][0]
            if ca in lab:
                votes[pa][lab[ca]] += 1                          # routine / code label
            pv, cv, md = port[pi][3], c64[cj][3], port[pi][2]
            if pv is not None and cv in lab and md in MEMOP:
                votes[pv][lab[cv]] += 1                          # variable (operand)
            covered += 1; pi += 1; cj += 1
        i = pi
    # resolve: each address -> its top-voted name, then each name -> its best address
    # (drop conflicts so ca65 never sees a name at two addresses)
    addr_name = {a: c.most_common(1)[0][0] for a, c in votes.items()}
    best = {}
    for a, nm in addr_name.items():
        cnt = votes[a][nm]
        if nm not in best or cnt > votes[best[nm]][nm]:
            best[nm] = a
    portlab = {a: nm for a, nm in addr_name.items() if best[nm] == a}
    # write: address name, sorted
    with open(out, 'w') as f:
        f.write(f'; auto-propagated from the C64 build by align_labels.py\n')
        for a in sorted(portlab):
            f.write(f'{a:04X} {portlab[a]}\n')
    print(f'{os.path.basename(portb)}: {len(portlab)} labels propagated '
          f'({covered}/{len(port)} instrs aligned, {100*covered/len(port):.0f}%)')

if __name__ == '__main__':
    main()
