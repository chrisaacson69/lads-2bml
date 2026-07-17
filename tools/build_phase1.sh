#!/usr/bin/env bash
# Phase 1: assemble the WHOLE C64 LADS from all modules in FILE-chain order and diff
# the entire binary vs the Appendix B oracle. No stubs -- every symbol must resolve.
set -u
cd "$(dirname "$0")/.."
BIN=tools/cc65-src/bin
mkdir -p build/p1
: > build/p1/master.s
echo '.autoimport +' >> build/p1/master.s
echo '.segment "CODE"' >> build/p1/master.s

# translate each module in manifest order, append include
while read -r name blocks corr; do
  [ -z "${name:-}" ] && continue
  case "$name" in \#*) continue;; esac
  corr_arg=""
  [ -n "${corr:-}" ] && [ -f "src/corrections/$corr" ] && corr_arg="--corrections src/corrections/$corr"
  # optional @maxline suffix on the block spec trims embedded appendices
  maxarg=""
  if echo "$blocks" | grep -q '@'; then
    maxarg="--maxline ${blocks##*@}"; blocks="${blocks%@*}"
  fi
  # a module may be several comma-separated blocks (split by prose); concat in order
  infiles=$(echo "$blocks" | tr ',' ' ')
  cat $(for b in $infiles; do echo "src/raw_blocks/$b"; done) > build/p1/${name}_src.txt
  py -3 tools/lads2ca65.py build/p1/${name}_src.txt --out build/p1/${name}.s $corr_arg $maxarg >/dev/null
  echo ".include \"${name}.s\"" >> build/p1/master.s
done < <(grep -vE '^\s*#' tools/phase1_manifest.txt)

# assemble + link
"$BIN/ca65.exe" --cpu 6502 -I build/p1 -o build/p1/master.o build/p1/master.s 2>build/p1/ca65.err
if [ $? -ne 0 ]; then echo "=== ca65 errors (first 25) ==="; head -25 build/p1/ca65.err; exit 1; fi
echo "ca65 OK (all modules assembled)"

"$BIN/ld65.exe" -C tools/lads_flat.cfg -o build/p1/lads.bin build/p1/master.o 2>build/p1/ld65.err
# report unresolved externals (missing module fragments) if any
py -3 - <<'PY'
import re
e=open('build/p1/ld65.err',encoding='utf-8',errors='replace').read()
u=sorted(set(re.findall(r'Unresolved external\s*\W?([A-Za-z_][A-Za-z0-9_]*)',e)))
if u: print(f'UNRESOLVED externals ({len(u)}): '+', '.join(u[:40]))
else: print('all symbols resolved')
PY
[ -f build/p1/lads.bin ] && py -3 tools/diff_oracle.py build/p1/lads.bin reference/lads_c64.bin
