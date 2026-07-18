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

def load_labels(path):
    """label map: 'ADDR name  [; comment]' per line, ADDR in hex (with/without $).
    Names in-image addresses (code labels / data vars) and out-of-image ones
    (zero-page vars, ROM routines) alike. Byte-exact is preserved because a name is
    just an alias for its real address value."""
    names = {}
    if path and os.path.exists(path):
        for ln in open(path, encoding='utf-8'):
            ln = ln.split(';', 1)[0].strip()
            if not ln:
                continue
            parts = ln.split()
            if len(parts) >= 2:
                names[int(parts[0].lstrip('$'), 16)] = parts[1]
    return names

def main():
    binf, org_s, cend_s, out = sys.argv[1:5]
    labels_file = sys.argv[5] if len(sys.argv) > 5 else None
    mem = open(binf, 'rb').read()
    origin = int(org_s, 16); code_end = int(cend_s, 16); end = origin + len(mem)
    names = load_labels(labels_file)

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
    for a in list(names):                        # place named in-image addresses too
        if origin <= a < end and a in placeable:
            targets.add(a)
    lbl = {a: names.get(a, f'L{a:04X}') for a in targets if a in placeable}

    def zpname(a):
        return names.get(a, f'${a:02X}')

    def operand(md, a, w, iaddr=0):
        if md == 'imm': return f'#${a:02X}'
        if md == 'zp':  return zpname(a)
        if md == 'zpx': return zpname(a) + ',X'
        if md == 'zpy': return zpname(a) + ',Y'
        if md == 'izx': return f'({zpname(a)},X)'
        if md == 'izy': return f'({zpname(a)}),Y'
        if md == 'acc': return 'A'
        if md == 'imp': return ''
        # absolute family: name (in-image label or ROM equate) else auto-label else literal
        def ref(v, idx=''):
            if v in names:
                pre = 'a:' if v < 0x100 else ''
                return f'{pre}{names[v]}{idx}'
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
             '.setcpu "6502"', '']
    ext = sorted((a, n) for a, n in names.items() if not (origin <= a < end))
    if ext:
        lines.append('; ---- equates: zero-page variables & ROM routines ----')
        for a, n in ext:
            lines.append(f'{n:<12} = ${a:02X}' if a < 0x100 else f'{n:<12} = ${a:04X}')
        lines.append('')
    lines += [f'.org ${origin:04X}', '']
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
