#!/usr/bin/env bash
# Reconstruct a PORT (Atari/Apple) as readable, byte-exact ca65 source:
#   1. build the C64 template + its label map    (the shared-logic Rosetta stone)
#   2. align_labels: propagate C64 routine/variable names onto the port by opcode match
#   3. merge with hand labels (src/forks/<port>.labels -- I/O routines the C64 lacks)
#   4. dis2src -> dist/<port>/lads.asm ; reassemble and diff vs the object oracle
#   usage: decompile.sh atari|apple
set -eu
cd "$(dirname "$0")/.."
PORT="$1"
case "$PORT" in
  atari) ORACLE=reference/lads_atari.bin; ORIGIN=0x8000; CEND=0x9868; CFG=tools/lads_atari.cfg;;
  apple) ORACLE=reference/lads_apple.bin; ORIGIN=0x79FD; CEND=0x8CC9; CFG=tools/lads_apple.cfg;;
  *) echo "usage: decompile.sh atari|apple"; exit 1;;
esac
BIN=tools/cc65-src/bin; OUT="dist/${PORT}-disk"; mkdir -p "build/$PORT" "$OUT"

# 1. C64 template + label map
[ -f build/p1/master.s ] || bash tools/build_phase1.sh >/dev/null 2>&1
"$BIN/ca65.exe" -g --cpu 6502 -I build/p1 -o build/p1/master.o build/p1/master.s 2>/dev/null
"$BIN/ld65.exe" -C tools/lads_flat.cfg -o build/p1/lads.bin -Ln build/p1/c64.labels build/p1/master.o 2>/dev/null

# 2. align C64 labels onto the port
py -3 tools/align_labels.py build/p1/lads.bin build/p1/c64.labels "$ORACLE" "$ORIGIN" "$CEND" "build/$PORT/aligned.labels"

# 3. merge (hand labels last so they win on conflicts)
cat "build/$PORT/aligned.labels" > "build/$PORT/labels.txt"
[ -f "src/forks/$PORT.labels" ] && cat "src/forks/$PORT.labels" >> "build/$PORT/labels.txt"

# 4. decompile + verify byte-exact
py -3 tools/dis2src.py "$ORACLE" "$ORIGIN" "$CEND" "$OUT/lads.asm" "build/$PORT/labels.txt"
"$BIN/ca65.exe" --cpu 6502 -o "build/$PORT/lads.o" "$OUT/lads.asm" 2>"build/$PORT/ca65.err"
"$BIN/ld65.exe" -C "$CFG" -o "build/$PORT/rt.bin" "build/$PORT/lads.o" 2>"build/$PORT/ld65.err"
py -3 tools/diff_oracle.py "build/$PORT/rt.bin" "$ORACLE" | grep -E 'mismatches|MATCH'
