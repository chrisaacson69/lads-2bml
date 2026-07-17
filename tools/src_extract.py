#!/usr/bin/env python3
"""
src_extract.py -- lift LADS source listings out of the 2BML chapter HTML.

Listings live inside <tt> monospace blocks, interleaved with prose. A chapter can
contain several blocks with different ROLES:
  * canonical    -- the real module source (line-numbered asm, ends with FILE/.FILE)
  * example      -- teaching snippets: usually <b>bold</b> and/or an assembled
                    listing with 'addr  hexbytes  source' columns
  * variant      -- platform-modification blocks (Apple/Atari), a wedge/SETUP
                    fragment, or a block whose *= origin is Apple($79FD)/Atari($8000)

Rather than guess roles silently, this tool INVENTORIES every block with metadata
(origin from *=, header comment, first/last BASIC line numbers, bold?, ends-with-FILE?,
platform hint, column-listing?) and writes each block's decoded text to a file. Role
classification is then a reviewable step over hard evidence, per grounding discipline.
"""
import sys, os, re, json, html, glob, argparse

TT_RE = re.compile(r'<tt>(.*?)</tt>', re.S | re.I)

def block_spans(raw):
    """Yield (start_char, is_bold, inner_html) for each <tt> block. is_bold is true
    if a <b> tag opens immediately before/around the <tt> (teaching-example marker)."""
    for m in TT_RE.finditer(raw):
        pre = raw[max(0, m.start()-40):m.start()]
        is_bold = bool(re.search(r'<b>\s*(<font[^>]*>\s*)?$', pre, re.I)) or \
                  bool(re.search(r'<b>', m.group(1)[:40], re.I))
        yield m.start(), is_bold, m.group(1)

def decode(inner):
    t = re.sub(r'<br\s*/?>', '\n', inner, flags=re.I)
    t = re.sub(r'<[^>]+>', '', t)
    t = html.unescape(t).replace('\xa0', ' ')
    lines = [ln.rstrip() for ln in t.split('\n')]
    # drop leading/trailing blank lines
    while lines and not lines[0].strip():
        lines.pop(0)
    while lines and not lines[-1].strip():
        lines.pop()
    return lines

LINENUM_RE = re.compile(r'^\s*(\d+)\s+(.*)$')
# an assembled-listing example line looks like:  "100 1000 A0 00   START LDA.."
#   basicline  hexaddr  hexbytes...  source     -> two+ hex tokens after the line number
COLLISTING_RE = re.compile(r'^\s*\d+\s+[0-9A-F]{3,4}\s+([0-9A-F]{2}\s+){1,4}')
STAR_RE = re.compile(r'\*=\s*(\$?[0-9A-Fa-f]+)')

PLATFORM_HINTS = re.compile(r'\b(APPLE|ATARI|VIC|PET|CBM|WEDGE)\b', re.I)

def origin_of(lines):
    for ln in lines[:5]:
        m = STAR_RE.search(ln)
        if m:
            v = m.group(1)
            return int(v[1:], 16) if v.startswith('$') else int(v)
    return None

def linenums(lines):
    nums = []
    for ln in lines:
        m = LINENUM_RE.match(ln)
        if m:
            nums.append(int(m.group(1)))
    return nums

def classify(lines, is_bold):
    nums = linenums(lines)
    col = sum(bool(COLLISTING_RE.match(ln)) for ln in lines)
    header = next((ln for ln in lines if ';' in ln), '') or (lines[0] if lines else '')
    # Scan the first few CODE lines only (module-identity/version header). Bounded
    # to avoid a stray APPLE/ATARI mention deep in a long canonical listing flipping
    # the role; the version header (e.g. "40 ; VIC VERSION") sits within the top lines.
    plat = PLATFORM_HINTS.search('\n'.join(lines[:8]))
    origin = origin_of(lines)
    ends_file = bool(lines) and re.search(r'\bFILE\b', lines[-1])
    if is_bold or col >= max(2, len(nums)//2):
        role = 'example'
    elif plat or origin in (0x79FD, 0x8000):
        role = 'variant'
    elif nums and ends_file:
        role = 'canonical'
    else:
        role = 'unknown'
    return {
        'role': role, 'bold': is_bold, 'code_lines': len(nums),
        'first_ln': nums[0] if nums else None, 'last_ln': nums[-1] if nums else None,
        'origin': f'${origin:04X}' if origin is not None else None,
        'ends_file': lines[-1] if ends_file else None,
        'col_listing_lines': col,
        'platform_hint': plat.group(0).upper() if plat else None,
        'header': header.strip()[:70],
    }

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('html', nargs='+', help='chapter html file(s)')
    ap.add_argument('--outdir', default='src/raw_blocks')
    args = ap.parse_args()
    os.makedirs(args.outdir, exist_ok=True)
    inventory = []
    for path in args.html:
        chap = re.sub(r'\.html$', '', os.path.basename(path))
        raw = open(path, encoding='utf-8', errors='replace').read()
        for bi, (start, is_bold, inner) in enumerate(block_spans(raw)):
            lines = decode(inner)
            if not lines:
                continue
            meta = classify(lines, is_bold)
            outname = f'{chap}_b{bi:02d}_{meta["role"]}.txt'
            with open(os.path.join(args.outdir, outname), 'w', encoding='utf-8') as f:
                f.write('\n'.join(lines) + '\n')
            meta.update({'chapter': chap, 'block': bi, 'file': outname})
            inventory.append(meta)
    with open(os.path.join(args.outdir, 'inventory.json'), 'w') as f:
        json.dump(inventory, f, indent=2)
    # print a compact table
    print(f'{"chapter":<12}{"blk":<4}{"role":<10}{"lines":<6}{"ln-range":<14}{"origin":<8}{"plat":<7}header')
    for m in inventory:
        rng = f'{m["first_ln"]}-{m["last_ln"]}' if m['first_ln'] is not None else '-'
        print(f'{m["chapter"]:<12}{m["block"]:<4}{m["role"]:<10}{m["code_lines"]:<6}'
              f'{rng:<14}{str(m["origin"]):<8}{str(m["platform_hint"]):<7}{m["header"]}')

if __name__ == '__main__':
    main()
