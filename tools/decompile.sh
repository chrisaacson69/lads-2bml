#!/usr/bin/env bash
# Regenerate a PORT's byte-exact decompiled source (dis2src) and verify it reassembles
# to the object oracle. Ports (Atari/Apple) shipped as object code, not printed source;
# this reconstructs an assemblable listing that round-trips byte-exact.
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
LABELS="src/forks/${PORT}.labels"; [ -f "$LABELS" ] || LABELS=""
py -3 tools/dis2src.py "$ORACLE" "$ORIGIN" "$CEND" "$OUT/lads.asm" $LABELS
"$BIN/ca65.exe" --cpu 6502 -o "build/$PORT/lads.o" "$OUT/lads.asm" 2>"build/$PORT/ca65.err"
"$BIN/ld65.exe" -C "$CFG" -o "build/$PORT/rt.bin" "build/$PORT/lads.o" 2>"build/$PORT/ld65.err"
py -3 tools/diff_oracle.py "build/$PORT/rt.bin" "$ORACLE" | grep -E 'mismatches|MATCH'
