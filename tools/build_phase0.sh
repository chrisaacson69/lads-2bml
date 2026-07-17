#!/usr/bin/env bash
# Phase 0 build: assemble Defs + Eval, stub externals, diff bytes vs the C64 oracle.
set -u
cd "$(dirname "$0")/.."
BIN=tools/cc65-src/bin
mkdir -p build

# 1. translate the two LADS modules to ca65
py -3 tools/lads2ca65.py src/raw_blocks/chapter_2_b00_canonical.txt --out build/defs.s
py -3 tools/lads2ca65.py src/raw_blocks/chapter_3_b02_canonical.txt --out build/eval.s --corrections src/corrections/eval.txt

# 2. master file: origin segment, defs (equates), eval (code)
cat > build/master.s <<'EOF'
.autoimport +
.segment "CODE"
.include "defs.s"
.include "eval.s"
EOF

# 3. assemble
"$BIN/ca65.exe" --cpu 6502 -I build -o build/master.o build/master.s 2>build/ca65.err
if [ $? -ne 0 ]; then echo "=== ca65 errors ==="; cat build/ca65.err; exit 1; fi
echo "ca65 OK"

# 4. discover undefined externals from a trial link, generate stubs, relink.
#    Externals (cross-module labels/vars) are stubbed to a scratch area so the
#    internal-only bytes can be diffed; instructions referencing a stub will differ.
"$BIN/ld65.exe" -C tools/lads_flat.cfg -o build/lads.bin build/master.o 2>build/ld65.err
STUB_BASE="${STUB_BASE:-\$C000}"
STUB_BASE="$STUB_BASE" py -3 - <<'PY'
import re, os
base = os.environ['STUB_BASE']
errs = open('build/ld65.err', encoding='utf-8', errors='replace').read()
syms = sorted(set(re.findall(r'Unresolved external\s*\W?([A-Za-z_][A-Za-z0-9_]*)\W?', errs)))
open('build/externals.txt','w').write('\n'.join(syms)+'\n' if syms else '')
with open('build/stubs.s','w') as f:
    f.write('; auto-generated stubs for cross-module externals (Phase 0 only)\n')
    for i,s in enumerate(syms):
        f.write(f'{s} = {base} + {i*2}\n')   # distinct scratch addresses
print(f'external symbols stubbed: {len(syms)}  (base {base})')
open('build/master.s','w').write('.autoimport +\n.segment "CODE"\n.include "stubs.s"\n.include "defs.s"\n.include "eval.s"\n')
PY
if [ -s build/stubs.s ]; then
  "$BIN/ca65.exe" --cpu 6502 -I build -o build/master.o build/master.s 2>build/ca65.err || { cat build/ca65.err; exit 1; }
  "$BIN/ld65.exe" -C tools/lads_flat.cfg -o build/lads.bin build/master.o 2>build/ld65.err
fi
[ -f build/lads.bin ] || { echo "NO BINARY PRODUCED"; cat build/ld65.err; exit 1; }
echo "ld65 -> build/lads.bin ($(wc -c < build/lads.bin) bytes)"

# 5. diff vs oracle prefix
py -3 tools/diff_oracle.py build/lads.bin reference/lads_c64.bin build/externals.txt build/master.o 2>/dev/null || \
py -3 tools/diff_oracle.py build/lads.bin reference/lads_c64.bin
