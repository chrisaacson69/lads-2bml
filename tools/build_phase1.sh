#!/usr/bin/env bash
# Assemble a whole LADS fork from its module manifest (FILE-chain order) and diff the
# binary vs that fork's oracle. No stubs -- every symbol must resolve.
#   $1 manifest  (default tools/phase1_manifest.txt = C64)
#   $2 build dir (default build/p1)
#   $3 oracle    (default reference/lads_c64.bin)
set -u
cd "$(dirname "$0")/.."
BIN=tools/cc65-src/bin
MANIFEST="${1:-tools/phase1_manifest.txt}"
OUT="${2:-build/p1}"
ORACLE="${3:-reference/lads_c64.bin}"
mkdir -p "$OUT"
: > "$OUT/master.s"
echo '.autoimport +' >> "$OUT/master.s"
echo '.segment "CODE"' >> "$OUT/master.s"

# translate each module in manifest order, append include
while read -r name blocks corr; do
  [ -z "${name:-}" ] && continue
  case "$name" in \#*) continue;; esac
  # corrections field may be a comma-separated list (universal OCR + per-fork deltas)
  corr_arg=""
  if [ -n "${corr:-}" ]; then
    paths=""
    for p in ${corr//,/ }; do paths="${paths:+$paths,}src/corrections/$p"; done
    corr_arg="--corrections $paths"
  fi
  # optional @maxline suffix on the block spec trims embedded appendices
  maxarg=""
  if echo "$blocks" | grep -q '@'; then
    maxarg="--maxline ${blocks##*@}"; blocks="${blocks%@*}"
  fi
  # a module may be several comma-separated blocks (split by prose); concat in order
  infiles=$(echo "$blocks" | tr ',' ' ')
  cat $(for b in $infiles; do echo "src/raw_blocks/$b"; done) > "$OUT/${name}_src.txt"
  py -3 tools/lads2ca65.py "$OUT/${name}_src.txt" --out "$OUT/${name}.s" $corr_arg $maxarg >/dev/null
  echo ".include \"${name}.s\"" >> "$OUT/master.s"
done < <(grep -vE '^\s*#' "$MANIFEST")

# assemble + link
"$BIN/ca65.exe" --cpu 6502 -I "$OUT" -o "$OUT/master.o" "$OUT/master.s" 2>"$OUT/ca65.err"
if [ $? -ne 0 ]; then echo "=== ca65 errors (first 25) ==="; head -25 "$OUT/ca65.err"; exit 1; fi
echo "ca65 OK (all modules assembled)"

"$BIN/ld65.exe" -C tools/lads_flat.cfg -o "$OUT/lads.bin" "$OUT/master.o" 2>"$OUT/ld65.err"
OUT="$OUT" py -3 - <<'PY'
import re, os
o=os.environ['OUT']
e=open(f'{o}/ld65.err',encoding='utf-8',errors='replace').read()
u=sorted(set(re.findall(r'Unresolved external\s*\W?([A-Za-z_][A-Za-z0-9_]*)',e)))
print(f'UNRESOLVED externals ({len(u)}): '+', '.join(u[:40]) if u else 'all symbols resolved')
PY
[ -f "$OUT/lads.bin" ] && py -3 tools/diff_oracle.py "$OUT/lads.bin" "$ORACLE"
