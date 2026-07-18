#!/usr/bin/env python3
"""
lads2ca65.py -- translate an extracted LADS source module into ca65 assembly.

LADS source is 6502 asm typed into a BASIC-style editor, so it carries:
  * leading BASIC line numbers          -> stripped (kept in a sidecar .map)
  * blank lines between every statement  -> dropped
  * comment lines that WRAP onto a numberless continuation line -> merged back
  * ':' as a BASIC statement separator (e.g. multi-equate lines) -> split
  * output/control pseudo-ops that emit no bytes (.NO .D .O .S .P .FILE .MEM ..)
  * '*=' program-counter set (origin handled by the ld65 config, so -> comment)
  * bare labels with no trailing ':'     -> ca65 '.feature labels_without_colons'

OCR errors in the printed source (e.g. 'imp' for 'JMP') are NOT silently guessed:
they surface as ca65 errors and are fixed via an explicit, auditable corrections
file (tools/corrections/<module>.txt), each a deliberate, oracle-verified change.
"""
import sys, os, re, argparse

MNEMONICS = set("""
ADC AND ASL BCC BCS BEQ BIT BMI BNE BPL BRK BVC BVS CLC CLD CLI CLV CMP CPX CPY
DEC DEX DEY EOR INC INX INY JMP JSR LDA LDX LDY LSR NOP ORA PHA PHP PLA PLP ROL
ROR RTI RTS SBC SEC SED SEI STA STX STY TAX TAY TSX TXA TXS TYA
""".split())

# LADS pseudo-ops that produce NO object bytes (destination / listing / chain control).
# These always carry a leading dot (.NO .D .O .S .P .MEM ...); matching them WITHOUT
# the dot would wrongly eat bare labels named P, D, S, O, H, END, etc. The sole
# dotless form seen is the module-chain terminator 'FILE' (handled separately).
NOBYTE_PSEUDO = re.compile(r'^(\.(NO|NH|D|O|S|P|MEM|H|BANK|END)|\.?FILE)\b', re.I)
STAR_PC       = re.compile(r'^\*\s*=')              # *= origin
BYTE_PSEUDO   = re.compile(r'^\.?(BYTE|BY)\b', re.I)
LINENUM       = re.compile(r'^\s*(\d+)\s?(.*)$')

def emit_stmt(piece, comment):
    """Format one LADS statement as ca65: pass through instructions/equates, but
    turn a leading label (first token that is NOT a mnemonic/pseudo-op/equate) into
    an explicit 'LABEL:' so ca65 accepts it regardless of indentation."""
    s = piece.strip()
    if not s:
        return f'    {comment}'.rstrip()
    # systematic OCR: the digit '1' in offset expressions ('+1') is rendered as the
    # letter 'l' or 'I' (e.g. PARRAY+l, WORK+I). Restore it (only standalone +l/+I).
    s = re.sub(r'\+[lI](?![A-Za-z0-9_])', '+1', s)
    if NOBYTE_PSEUDO.match(s):
        # exception: bare 'FILE <mnemonic>' is a code LABEL (the runtime F-pseudo-op
        # handler), NOT the module-chain directive. '.FILE ...' / 'FILE <modulename>'
        # remain the chain (no bytes).
        mf = re.match(r'^FILE\s+(\S+)', s, re.I)
        if not (mf and not s.startswith('.') and mf.group(1).upper() in MNEMONICS):
            return f'    ; [LADS {s}] {comment}'.rstrip()
    if STAR_PC.match(s):
        return f'    ; [LADS *=] {s}  {comment}'.rstrip()
    toks = s.split(None, 1)
    first = toks[0].upper()
    # equate:  NAME = value  (rename A/X/Y variable definitions too)
    if len(toks) > 1 and toks[1].lstrip().startswith('='):
        if toks[0] in ('A', 'X', 'Y'):
            s = 'VAR' + s
        return f'    {s}  {comment}'.rstrip()
    # a "first token" made entirely of punctuation (e.g. a "----" separator whose
    # leading ';' was dropped by OCR) is a comment, not a label
    if not any(c.isalnum() for c in toks[0]):
        return f'    ; {s}  {comment}'.rstrip()
    # instruction / directive (.byte, mnemonic, .pseudo)
    if first in MNEMONICS or first.startswith('.') or BYTE_PSEUDO.match(s):
        return f'    {normalize_stmt(s)}  {comment}'.rstrip()
    # otherwise the first token is a label; the remainder (if any) is an instruction.
    # A/X/Y label DEFINITIONS (the register-save vars, e.g. 'A .BYTE 0' in Tables) are
    # renamed to match their renamed operand uses (VARA/VARX/VARY).
    label = 'VAR' + toks[0] if toks[0] in ('A', 'X', 'Y') else toks[0]
    rest = toks[1].strip() if len(toks) > 1 else ''
    if rest:
        return f'{label}: {normalize_stmt(rest)}  {comment}'.rstrip()
    return f'{label}:  {comment}'.rstrip()

SHIFT_ACC = {'ASL', 'LSR', 'ROL', 'ROR'}  # legit accumulator-mode operand 'A'

def load_corrections(path):
    """corrections: one or more comma-separated files of global 'old => new' replacements
    applied to the RAW module text (so OCR'd delimiters/glyphs can be matched). Multiple
    files let a fork layer its own deltas over the universal OCR fixes. A line is a
    correction iff it contains '=>'; everything else is a comment."""
    corr = []
    for p in (path or '').split(','):
        p = p.strip()
        if not p or not os.path.exists(p):
            continue
        for ln in open(p, encoding='utf-8'):
            ln = ln.rstrip('\n')
            # a correction is any line containing '=>' (old-strings may start with '#',
            # so we key off the arrow, not a leading-char comment rule); all others ignored
            if '=>' in ln:
                old, new = ln.split('=>', 1)
                corr.append((old.strip(), new.strip()))
    return corr

def normalize_stmt(text):
    """Normalize one statement for ca65:
      - .BYTE / .BY data: LADS separates values by spaces (e.g. '.BYTE 0 0 0'); ca65
        wants commas -> rewrite to '.byte 0,0,0'.
      - rename standalone LADS variables A/X/Y (a register-save area) to VARA/VARX/VARY
        so ca65 doesn't parse them as the accumulator/index registers. Shift/rotate
        ops legitimately take 'A' (accumulator mode) and are left alone."""
    m = re.match(r'^\.?(BYTE|BY)\b(.*)$', text, re.I)
    if m:
        data = m.group(2).strip()
        if '"' in data:
            # string data (e.g. LADS mnemonic/message tables): LADS reads to end of line
            # with no closing quote; ca65 needs a balanced quoted string. Keep content
            # intact (do NOT split -- messages contain spaces). For A-Z and space, ASCII
            # == PETSCII so the bytes match; the oracle diff flags any encoding mismatch.
            if data.count('"') % 2 == 1:
                data += '"'
            return '.byte ' + data
        vals = [v for v in re.split(r'[,\s]+', data) if v != '']
        return '.byte ' + ','.join(vals)
    parts = text.split(None, 1)
    if len(parts) < 2:
        return text
    mnem, operand = parts[0].upper(), parts[1].strip()
    if operand in ('A', 'X', 'Y') and mnem not in SHIFT_ACC:
        return f'{parts[0]} VAR{operand}'
    return text

def merge_continuations(raw_lines):
    """Merge wrapped-comment continuations back into their statement. A real BASIC
    line number always INCREASES; a line whose leading number is <= the previous one
    (or has no number) is a wrapped continuation -- OCR sometimes even prefixes a
    spurious small number to the wrap (e.g. '17 TYPE ERRORS)'). Such lines are appended
    to the previous logical line rather than starting a new statement."""
    logical, last = [], -1
    for ln in raw_lines:
        if not ln.strip():
            continue
        m = LINENUM.match(ln)
        if m and int(m.group(1)) > last:
            logical.append(ln.rstrip())
            last = int(m.group(1))
        elif logical:
            logical[-1] = logical[-1] + ' ' + ln.strip()
        else:
            logical.append(ln.rstrip())   # stray leading text before any number
            if m:
                last = int(m.group(1))
    return logical

def split_code_comment(body):
    """Split 'code ; comment' -> (code, comment_including_semicolon or '')."""
    i = body.find(';')
    if i < 0:
        return body, ''
    return body[:i], body[i:]

def translate_line(basicnum, body):
    """Return a list of ca65 lines for one LADS logical line."""
    code, comment = split_code_comment(body)
    if not code.strip():
        return [f'    {comment}'.rstrip()]
    # BASIC ':' statement separator: split the CODE part into multiple statements.
    # (comment, which followed the last ';', re-attaches to the final piece)
    pieces = [p for p in code.split(':') if p.strip()]
    out = []
    for k, piece in enumerate(pieces):
        tail = comment if k == len(pieces) - 1 else ''
        out.append(emit_stmt(piece, tail))
    return out or [f'    {comment}'.rstrip()]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('infile', help='extracted LADS module (src/raw_blocks/*.txt)')
    ap.add_argument('--out', required=True, help='output .s')
    ap.add_argument('--corrections', help='corrections file for this module')
    ap.add_argument('--maxline', type=int, default=None,
                    help='keep only BASIC lines <= this (trims embedded appendices)')
    ap.add_argument('--module', default=None, help='module label for the .map')
    args = ap.parse_args()

    corr = load_corrections(args.corrections)
    raw = open(args.infile, encoding='utf-8', errors='replace').read()
    # apply auditable OCR corrections to the raw text FIRST (so OCR'd glyphs/delimiters
    # can be matched), then sanitize any remaining non-ASCII glyphs to spaces
    applied = 0
    for old, new in corr:
        if old in raw:
            raw = raw.replace(old, new)
            applied += 1
    raw = ''.join(c if ord(c) < 128 else ' ' for c in raw)
    logical = merge_continuations(raw.splitlines())

    out_lines, mapping = [], []
    for lg in logical:
        m = LINENUM.match(lg)
        if not m:
            out_lines.append('    ; ' + lg.strip())
            continue
        bnum, body = int(m.group(1)), m.group(2)
        if args.maxline is not None and bnum > args.maxline:
            continue
        ca_lines = translate_line(bnum, body)
        for cl in ca_lines:
            mapping.append((len(out_lines) + 1, bnum))
            out_lines.append(cl)

    header = [
        f'; ==== auto-translated from {os.path.basename(args.infile)} by lads2ca65.py ====',
        '.feature pc_assignment',
        '.setcpu "6502"',
        '',
    ]
    with open(args.out, 'w', encoding='utf-8') as f:
        f.write('\n'.join(header + out_lines) + '\n')
    with open(args.out + '.map', 'w', encoding='utf-8') as f:
        f.write('# ca65_line\tbasic_line\n')
        for ca, bn in mapping:
            f.write(f'{ca+len(header)}\t{bn}\n')

    print(f'{os.path.basename(args.infile)} -> {args.out}')
    print(f'  logical lines: {len(logical)}   ca65 lines: {len(out_lines)}   corrections applied: {applied}')

if __name__ == '__main__':
    main()
