#!/usr/bin/env python3
"""
extract_object.py -- extract LADS reference object code from Appendix B HTML.

Appendix B contains several separately-formatted object-code programs:
  B-1  Commodore 64 LADS   -- MLX format:  ADDR :b1,b2,...,b6,checksum   (decimal)
  B-4  Atari LADS          -- MLX format:  ADDR :b1,b2,...,b6,checksum   (decimal)
  B-5  Apple LADS          -- monitor hex: AAAA- HH HH HH ...            (hex)

For MLX programs the leading number IS the load address (increments by 6, one
line = 6 data bytes + 1 checksum byte). For the Apple monitor format the leading
4-hex field is the load address and the rest are space-separated hex bytes.

Output: a raw .bin (bytes placed at their stated addresses, gaps zero-filled) plus
a .meta.json describing origin, length, address span, and any discontinuities.

This is a deterministic extractor over the immutable raw/ HTML -- reproducible,
no hand-copying. It is the ground-truth ("oracle") side of the verification loop.
"""
import sys, os, re, json, html, argparse

def clean_html_to_lines(raw):
    # Convert <br> to newlines FIRST, then strip remaining tags, then unescape.
    t = re.sub(r'<br\s*/?>', '\n', raw, flags=re.I)
    t = re.sub(r'<[^>]+>', '', t)
    t = html.unescape(t)
    t = t.replace('\xa0', ' ')  # residual nbsp
    return t

def split_programs(text):
    """Split cleaned text into {program_label: body_text} by 'Program B-x' headers."""
    # Header lines look like: "Program B-1. Commodore 64 LADS: MLX Format"
    parts = re.split(r'(Program\s+B-\d+[a-z]?[.,][^\n]*)', text)
    progs = {}
    # parts = [pre, header1, body1, header2, body2, ...]
    for i in range(1, len(parts), 2):
        header = parts[i].strip()
        body = parts[i+1] if i+1 < len(parts) else ''
        progs[header] = body
    return progs

# Tolerant MLX matcher: the atariarchives OCR sometimes renders the byte
# separators (',') as '.' or '-', and occasionally emits a stray comma between
# the line number and the colon ("15644,:..."). We accept the line number, an
# optional stray separator, the colon, then a payload of 3-digit groups joined by
# ANY non-digit run. Every repaired line is logged so archive defects are audited.
MLX_RE   = re.compile(r'^\s*(\d+)\s*[,.\-]?\s*:\s*([0-9][0-9,.\-\s]*?)\s*$')
# Apple monitor format 'AAAA- HH HH ...'. The archive OCR'd one line's '-' as '=' at
# $8270, which silently dropped 8 bytes; accept '-' or '=' as the address separator.
APPLE_RE = re.compile(r'^\s*([0-9A-Fa-f]{4})\s*[-=]\s*([0-9A-Fa-f\s]+?)\s*$')

REPAIRS = []  # (addr, raw_payload) for lines whose separators were corrupted

def parse_mlx(body):
    """Return list of (addr, [data_bytes], checksum). Tolerates OCR separator rot."""
    rows = []
    for line in body.splitlines():
        m = MLX_RE.match(line)
        if not m:
            continue
        addr = int(m.group(1))
        payload = m.group(2).strip()
        # Any run of non-digits is a separator (recovers ',' rendered as '.'/'-').
        nums = [int(x) for x in re.split(r'\D+', payload) if x != '']
        if len(nums) < 2:
            continue
        if re.search(r'[.\-]', payload) or line.lstrip()[:20].count(',:'):
            REPAIRS.append((addr, payload))
        data, chk = nums[:-1], nums[-1]
        rows.append((addr, data, chk))
    return rows

def parse_apple(body):
    rows = []
    for line in body.splitlines():
        m = APPLE_RE.match(line)
        if not m:
            continue
        addr = int(m.group(1), 16)
        toks = [t for t in re.split(r'\s+', m.group(2).strip()) if t != '']
        # every token must be two hex digits, else this line isn't real data
        if not toks or not all(re.fullmatch(r'[0-9A-Fa-f]{2}', t) for t in toks):
            continue
        data = [int(t, 16) for t in toks]
        rows.append((addr, data, None))
    return rows

def verify_mlx_checksums(rows):
    """COMPUTE! 1984 MLX line checksum = (sum(6 data bytes) + low byte of address) & 255.
    Recomputing it independently validates the archive transcription of every line and,
    for OCR-repaired lines, proves the recovered bytes are correct."""
    bad = []
    for addr, data, chk in rows:
        if chk is None:
            continue
        if (sum(data) + (addr & 0xFF)) & 0xFF != chk:
            bad.append({'addr': addr, 'addr_hex': f'${addr:04X}',
                        'printed_chk': chk, 'computed': (sum(data) + (addr & 0xFF)) & 0xFF})
    return bad

def assemble_blob(rows):
    """Place rows at their addresses; verify contiguity; return (origin, bytes, gaps)."""
    if not rows:
        raise SystemExit('no data rows parsed')
    # Size the blob to the FULL address span (a corrupted/out-of-order address must not
    # crash or index out of range); origin is the true minimum, end the true maximum.
    origin = min(a for a, _, _ in rows)
    end = max(a + len(d) for a, d, _ in rows)
    blob = bytearray(end - origin)
    filled = bytearray(len(blob))  # 1 where a byte was written
    gaps = []
    expect = rows[0][0]
    for addr, data, _ in rows:
        if addr != expect:
            gaps.append({'expected': expect, 'got': addr, 'delta': addr - expect})
        for i, b in enumerate(data):
            off = addr - origin + i
            if 0 <= off < len(blob) and 0 <= b < 256:
                blob[off] = b
                filled[off] = 1
        expect = addr + len(data)
    holes = filled.count(0)
    return origin, bytes(blob), gaps, holes

def assemble_contiguous(rows):
    """For a fully-contiguous memory dump (e.g. Apple monitor format), trust byte
    ORDER, not the printed addresses -- the archive OCR corrupts some address
    fields (digit transposition), scattering bytes to impossible locations. We lay
    bytes sequentially from the first (clean) printed origin and, where a printed
    address disagrees with the running position, log it as an address repair."""
    origin = rows[0][0]
    out = bytearray()
    addr_repairs = []
    pos = origin
    for addr, data, _ in rows:
        if addr != pos:
            addr_repairs.append({'printed': f'${addr:04X}', 'actual': f'${pos:04X}'})
        out.extend(data)
        pos += len(data)
    return origin, bytes(out), addr_repairs

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('html', help='path to appendix_b.html')
    ap.add_argument('--program', required=True, help="substring to match program header, e.g. 'B-1' or 'B-5'")
    ap.add_argument('--format', choices=['mlx', 'apple'], required=True)
    ap.add_argument('--out', required=True, help='output .bin path (writes .meta.json alongside)')
    args = ap.parse_args()

    raw = open(args.html, 'r', encoding='utf-8', errors='replace').read()
    text = clean_html_to_lines(raw)
    progs = split_programs(text)

    # A program label can appear both in intro prose ("...see Program B-5.") and
    # as the real data header. Among all sections matching the substring, keep the
    # one that actually yields the most parseable data rows.
    candidates = [k for k in progs if args.program.lower() in k.lower()]
    if not candidates:
        print('Available program headers:')
        for k in progs:
            print('   ', k[:70])
        raise SystemExit(f'no program header matched {args.program!r}')

    parse = parse_mlx if args.format == 'mlx' else parse_apple
    match_key, rows = max(
        ((k, parse(progs[k])) for k in candidates),
        key=lambda kv: len(kv[1]),
    )
    csum_bad = []
    if args.format == 'apple':
        origin, blob, addr_repairs = assemble_contiguous(rows)
        gaps, holes = [], 0
    else:
        origin, blob, gaps, holes = assemble_blob(rows)
        addr_repairs = []
        csum_bad = verify_mlx_checksums(rows)

    with open(args.out, 'wb') as f:
        f.write(blob)
    meta = {
        'program': match_key.strip(),
        'format': args.format,
        'origin_dec': origin,
        'origin_hex': f'${origin:04X}',
        'length': len(blob),
        'end_hex': f'${origin+len(blob):04X}',
        'rows': len(rows),
        'gaps': gaps,
        'unfilled_bytes': holes,
        'first16': ' '.join(f'{b:02X}' for b in blob[:16]),
        'ocr_repairs': [{'addr': a, 'addr_hex': f'${a:04X}', 'raw': p}
                        for a, p in dict((a, p) for a, p in REPAIRS).items()],
        'addr_repairs': addr_repairs,
    }
    with open(args.out + '.meta.json', 'w') as f:
        json.dump(meta, f, indent=2)

    print(f"program : {meta['program']}")
    print(f"format  : {args.format}")
    print(f"origin  : {meta['origin_hex']} ({origin} dec)")
    print(f"length  : {len(blob)} bytes  -> end {meta['end_hex']}")
    print(f"rows    : {len(rows)}")
    print(f"gaps    : {len(gaps)}  unfilled: {holes}")
    if args.format == 'mlx':
        if csum_bad:
            print(f"CHECKSUM: {len(csum_bad)} line(s) FAIL MLX checksum -> undetected byte error:")
            for b in csum_bad[:10]:
                print(f"          {b['addr_hex']}: printed {b['printed_chk']} != computed {b['computed']}")
        else:
            print(f"checksum: ALL {len(rows)} lines pass MLX checksum (oracle independently validated)")
    print(f"repairs : {len(meta['ocr_repairs'])} OCR-corrupted line(s) recovered")
    for r in meta['ocr_repairs']:
        print(f"          {r['addr_hex']} ({r['addr']}): {r['raw']}")
    if addr_repairs:
        print(f"addr fix: {len(addr_repairs)} printed address(es) != running position")
        for r in addr_repairs[:8]:
            print(f"          printed {r['printed']} -> pos {r['actual']}")
        if len(addr_repairs) > 8:
            print(f"          ... (+{len(addr_repairs)-8} more)")
        if len(addr_repairs) > 20:
            print("  WARNING: large drift => a data line is likely MISSING from the")
            print("           archive transcription. This oracle is PROVISIONAL until")
            print("           the hole is located and recovered (Phase 2 / cross-check).")
    print(f"first16 : {meta['first16']}")
    if gaps:
        print("GAP DETAIL:")
        for g in gaps[:10]:
            print('  ', g)

if __name__ == '__main__':
    main()
