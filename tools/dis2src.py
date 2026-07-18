#!/usr/bin/env python3
"""dis2src.py -- disassemble a LADS object image into ca65 source that reassembles
BYTE-EXACT. Labels every in-image target; forces operand widths (a:) so ca65 can't
re-optimize abs->zp; emits the tables/variables region as labeled .byte data.

  usage: dis2src.py <bin> <origin_hex> <code_end_hex> <out.s>

Byte-exactness is the contract; readability (meaningful labels from the C64 template)
is layered on afterward. Verify with: assemble out.s and diff vs the input image.
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from dis6502 import OPS, SZ

def main():
    binf, org_s, cend_s, out = sys.argv[1:5]
    mem = open(binf, 'rb').read()
    origin = int(org_s, 16); code_end = int(cend_s, 16); end = origin + len(mem)

    # ---- pass 1: linear decode of the code region; collect instruction starts + targets
    starts = set(); targets = set(); addr = origin
    decode = {}
    while addr < code_end:
        op = mem[addr - origin]; mn, md = OPS.get(op, ('.byte', 'imp'))
        n = SZ[md] if mn != '.byte' else 1
        if addr + n > code_end:      # would straddle the data boundary -> stop as code
            break
        starts.add(addr); decode[addr] = (op, mn, md, n)
        a = mem[addr - origin + 1] if n > 1 else 0
        w = (mem[addr - origin + 2] << 8 | a) if n > 2 else 0
        tgt = None
        if md == 'rel':
            tgt = addr + 2 + ((a ^ 0x80) - 0x80)
        elif md in ('abs', 'abx', 'aby', 'ind') and mn != '.byte':
            tgt = w
        if tgt is not None and origin <= tgt < end:
            targets.add(tgt)
        addr += n
    data_start = addr  # where code decoding stopped

    # Only label targets we can actually place: an instruction start, or anywhere in the
    # data region (labels can split a .byte row). Targets that land mid-instruction (data
    # misdecoded as code) fall back to literal operands -- still byte-exact, just less pretty.
    placeable = starts | set(range(data_start, end))
    lbl = {a: f'L{a:04X}' for a in targets if a in placeable}

    def operand(md, a, w, iaddr=0):
        if md == 'imm': return f'#${a:02X}'
        if md == 'zp':  return f'${a:02X}'
        if md == 'zpx': return f'${a:02X},X'
        if md == 'zpy': return f'${a:02X},Y'
        if md == 'izx': return f'(${a:02X},X)'
        if md == 'izy': return f'(${a:02X}),Y'
        if md == 'acc': return 'A'
        if md == 'imp': return ''
        # absolute family: use a label if in-image, else literal; force a: when <$100
        def ref(v, idx=''):
            if v in lbl: return lbl[v] + idx
            pre = 'a:' if v < 0x100 else ''
            return f'{pre}${v:04X}{idx}'
        if md == 'abs': return ref(w)
        if md == 'abx': return ref(w, ',X')
        if md == 'aby': return ref(w, ',Y')
        if md == 'ind':  # JMP (ind) is always 16-bit on NMOS -> no a: needed
            return f'({lbl[w]})' if w in lbl else f'(${w:04X})'
        if md == 'rel':
            tgt = iaddr + 2 + ((a ^ 0x80) - 0x80)
            return lbl.get(tgt, f'${tgt:04X}')
        return ''

    lines = [f'; disassembled from {os.path.basename(binf)} by dis2src.py -- reassembles byte-exact',
             '.setcpu "6502"', f'.org ${origin:04X}', '']
    # ---- pass 2: emit code
    addr = origin
    while addr < data_start:
        op, mn, md, n = decode[addr]
        if addr in lbl: lines.append(f'{lbl[addr]}:')
        if mn == '.byte':
            lines.append(f'    .byte ${op:02X}')
            addr += 1; continue
        a = mem[addr - origin + 1] if n > 1 else 0
        w = (mem[addr - origin + 2] << 8 | a) if n > 2 else 0
        lines.append(f'    {mn.lower()} {operand(md, a, w, addr)}'.rstrip())
        addr += n
    # ---- emit data region as labeled .byte rows of 8
    lines.append('; ---- data / tables / variables ----')
    a = data_start
    while a < end:
        if a in lbl: lines.append(f'{lbl[a]}:')
        row = mem[a - origin:min(a - origin + 8, len(mem))]
        # split row if a label falls inside it
        cut = next((x for x in range(1, len(row)) if a + x in lbl), len(row))
        row = row[:cut]
        lines.append('    .byte ' + ','.join(f'${x:02X}' for x in row))
        a += len(row)

    open(out, 'w').write('\n'.join(lines) + '\n')
    print(f'{os.path.basename(binf)}: {len(starts)} instrs, {len(lbl)} labels, '
          f'code ${origin:04X}..${data_start:04X}, data ..${end:04X} -> {out}')

if __name__ == '__main__':
    main()
