#!/usr/bin/env bash
# Rigorous Phase-0 proof: assemble Eval twice with DIFFERENT external-stub bases.
# A byte that is identical across both builds does not depend on any stubbed
# external, so it must equal the oracle. Any such byte that differs from the oracle
# is a genuine transcription defect. Bytes that differ between the two builds are
# external-operand artifacts (expected) and are excluded from the correctness claim.
set -eu
cd "$(dirname "$0")/.."
# The two stub bases must differ in BOTH bytes (and be non-page-aligned) so that a
# stubbed external's low byte AND high byte both change between builds -- otherwise a
# page-aligned base leaves external low bytes identical and they masquerade as internal.
STUB_BASE='$C000' bash tools/build_phase0.sh >/dev/null 2>&1; cp build/lads.bin build/lads_A.bin
STUB_BASE='$8441' bash tools/build_phase0.sh >/dev/null 2>&1; cp build/lads.bin build/lads_B.bin
py -3 - <<'PY'
a=open('build/lads_A.bin','rb').read(); b=open('build/lads_B.bin','rb').read()
ref=open('reference/lads_c64.bin','rb').read()
n=min(len(a),len(b),len(ref))
internal=ext=bad=0; bad_list=[]
for i in range(n):
    if a[i]==b[i]:                       # external-independent byte
        internal+=1
        if a[i]!=ref[i]:
            bad+=1; bad_list.append((i,a[i],ref[i]))
    else:
        ext+=1                           # depends on a stubbed external
print(f'overlap bytes           : {n}')
print(f'external-independent     : {internal}  ({100*internal/n:.1f}%)')
print(f'  matching oracle        : {internal-bad}')
print(f'  MISMATCH (real defects) : {bad}')
print(f'external-operand bytes   : {ext}  (excluded; verified in later phases)')
if bad==0:
    print('\n*** PHASE 0 PROVEN: every external-independent byte of EVAL is BYTE-EXACT vs the Appendix B oracle ***')
else:
    print('\nremaining real defects (offset: got vs ref):')
    for i,g,r in bad_list[:30]:
        print(f'  +{i:04X} (${0x2AF8+i:04X}): {g:02X} vs {r:02X}')
PY
