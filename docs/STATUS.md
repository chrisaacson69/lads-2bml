# LADS / 2BML Reconstruction — Project Status

**Project:** Verified reconstruction of LADS (the memory-resident 6502 assembler from
Richard Mansfield's *The Second Book of Machine Language*, COMPUTE! Publications, 1984).
**Destination:** byte-exact verified reconstruction, centered on the **Apple II** variant.
**Method class:** source-available *literate reconstruction* with a byte-exact oracle —
the inverse of the ROM-decompiler projects (source exists; we transcribe + verify, not RE).

## The verification loop (the whole point)
```
extract source (chapters) -> preprocess (strip BASIC line #s, normalize pseudo-ops)
  -> assemble (modern 6502 cross-assembler) -> DIFF bytes vs published object code
```
Any mismatch is a located transcription error. This is verification independence by
dropping to a lower artifact (bytes), not by asking a second model.

## Sources (all downloaded, immutable, in `raw/html/`)
Full book text from https://www.atariarchives.org/2bml/ — 11 chapters + 5 appendices.
Listings are machine-readable text (inside `<tt>` blocks), interleaved with prose.
Hardcopy/scan backup: https://archive.org/details/ataribooks-the-second-book-of-machine-language

## Book structure (source is chapter-by-chapter)
- Ch2 `Defs` (equates) · Ch3 `Eval` (main loop) · Ch4 `Equate`/`Array` (symbol table)
- Ch5 `Open1`/`Findmn`/`Getsa`/`Valdec` · Ch6 `Indisk` (input) · Ch7 `Math`/`Printops`
- Ch8 `Pseudo` (pseudo-ops + linked files) · Ch9 `Tables` · Ch11 modifications
- Modules chain via the `FILE` pseudo-op (e.g. Eval ends `5910 FILE EQUATE`) —
  **the build/concatenation order is encoded in the source itself.**
- Each chapter also carries platform-modification `<tt>` blocks (ATARI/APPLE) — these
  are the Apple II delta layer, pre-isolated by Mansfield. Teaching examples are the
  **bold** `<tt>` blocks with address+hex columns (skip them).

## The two oracles (Appendix B) — both extracted by `tools/extract_object.py`
| Prog | Machine | Format | Origin | Length | Status |
|------|---------|--------|--------|--------|--------|
| B-1  | C64     | MLX (decimal `addr:b1..b6,cksum`) | `$2AF8` (11000) | 4986 B → `$3E72` | **CLEAN** ✓ |
| B-4  | Atari   | MLX | `$8000` | ~5K | not yet extracted |
| B-5  | Apple   | monitor hex (`AAAA- HH..`) | `$79FD` | 5749 B → `$9072` | **CLEAN** ✓ |

The C64 origin was confirmed two ways: predicted `$2AF8` from MLX line numbers, and the
first bytes `A9 00 A0 30 99 71 3E ..` decode to `LDA #0 / LDY #48 / STA $3E71,Y ..` =
Eval source lines 30–70 exactly (with `OP = $3E71`, top of LADS). Oracle hand-verified.

## Archive defects found (byte-exact discipline caught these)
- **C64 B-1:** 2 OCR-corrupted lines — separators `,` rendered as `.`/`-` (line addr
  `$2CBA`) and a stray comma `15644,:` (`$3D1C`). Digits intact → recovered + logged.
  Result: 831 rows, **0 gaps, 0 unfilled**.
- **Apple B-5:** RESOLVED (2026-07-17, via Chris reading the scan). The "missing" line was
  never missing — line `8270= 37 AD 01 02 C9 53 D0 30` had its address separator OCR'd as
  `=` instead of `-`, so the strict parser dropped it. Accepting `[-=]` recovered it; blob now
  ends `$9072` (matches printed final `9070- 00 01`), 0 gaps. The old 460-line drift collapsed
  to 19 isolated printed-address OCR errors (8↔B / 6↔8 / 0↔C), all placed correctly by position.
  Apple oracle is now byte-exact — ready as the Phase-2 Apple target. B-5's sibling Tables b01
  (ch9) is the APPLE variant (ProDOS/CIO DOS control blocks at lines 830+), confirming b00 is
  the correct C64 Tables.

## Toolchain
- `tools/extract_object.py` — deterministic oracle extractor (MLX + Apple formats),
  OCR-tolerant, logs every repair. Reproducible over immutable `raw/`.
- Outputs: `reference/lads_c64.bin` (+`.meta.json`), `reference/lads_apple.bin` (provisional).

## Source inventory (tools/src_extract.py -> src/raw_blocks/inventory.json)
Every `<tt>` block classified canonical/example/variant from hard evidence
(origin, header, line-range, bold, column-listing, platform hint).

**C64 canonical build chain** (module -> next via FILE pseudo-op):
DEFS64 -> EVAL -> EQUATE -> ARRAY -> OPEN1 -> FINDMN -> GETSA -> VALDEC
-> INDISK -> MATH -> PRINTOPS -> PSEUDO -> TABLES
- Clean single blocks: DEFS64 (ch2 b0), EVAL (ch3 b2, 601 lines), INDISK (ch6 b3,
  433 lines), PSEUDO (ch8 b0, 287 lines).
- Split across multiple blocks (prose interrupts listing -> concatenate by BASIC
  line number, dedupe/overlap-check): OPEN1 (ch5), PRINTOPS (ch7), TABLES (ch9),
  and trailing `.FILE` lines that split off as tiny blocks.

**Platform variants present:** every module has an "ATARI MODIFICATIONS" block;
Defs additionally has VIC, PET/CBM, APPLE ($79FD), and Atari ($8000) full variants.

### OPEN QUESTION (Phase 2, Apple): where do Apple *code* deltas live?
The per-chapter modification blocks are ATARI-only. Yet B-5 Apple object differs
from C64 in code, not just equates (e.g. Eval clears 50 flags `LDY #$32` vs C64's
48 `LDY #48`). Apple deltas beyond the Apple Defs are NOT in per-chapter blocks.
Candidates: Appendix A, chapter 11 (Modifying LADS), or DERIVE by disassembling
B-5 and diffing vs assembled C64 (a mini decompile-with-reference). TBD.

### More archive OCR defects logged (consistent with B-1/B-5)
`OPENI`->OPEN1, `MODIFICATTONS`->MODIFICATIONS, `PRINTOPS, SRC`->`.SRC` (comma/period),
`:ATARI`->`;ATARI` (colon/semicolon). None affect Phase 0 (Eval+Defs are clean).

## Open decisions / next steps
1. **Choose 6502 cross-assembler** (ACME / 64tass / cc65-ca65) — none installed yet.
2. Build `tools/src_extract.py` (source-listing extractor; task #3).
3. Phase 0: assemble Eval(+Defs) → diff vs `reference/lads_c64.bin` at offset 0.
4. Phase 1: full C64 build byte-exact vs B-1. Phase 2: Apple deltas → vs B-5 (after #5).

## PHASE 0 — PROVEN (2026-07-17)
The full verification loop is closed and byte-exact on EVAL:
```
extract oracle -> extract source -> lads2ca65 translate -> ca65 assemble
  -> ld65 link (flat @ $2AF8) -> diff vs reference/lads_c64.bin  =>  966/966 external-
  independent bytes BYTE-EXACT, 0 defects. (358 external-operand bytes excluded, resolved in P1.)
```
- Toolchain: **cc65 V2.19 built from source** (git clone + MSBuild VS2022, `/p:PlatformToolset=v143`)
  in `tools/cc65-src/bin/`. SourceForge gated scripted downloads; GitHub had no binaries.
- Pipeline tools: `tools/lads2ca65.py` (LADS->ca65: strip line #s, merge wrapped comments,
  split ':' statements, add label colons, rename A/X/Y register-save VARS -> VARA/VARX/VARY,
  comment no-byte pseudo-ops, apply OCR corrections), `tools/lads_flat.cfg`, `tools/diff_oracle.py`.
- Rigorous proof method: `tools/verify_phase0.sh` builds TWICE with different (non-page-aligned!)
  external-stub bases; a byte identical across both builds is external-independent and must equal
  the oracle. (Page-aligned bases were a verifier bug: external low bytes coincided.)
- **9 OCR defects in the printed EVAL source found+fixed via the oracle** (`src/corrections/eval.txt`):
  `imp`->JMP, `FOR`->EOR (oracle disproved an ORA guess — flip-bit not set-bit), `;`->`,`/`:`
  comment delimiters, `""`->degree-signs char literal, and 3 mangled label defs
  (`STARRTINE`->STARTLINE, `EVXl`->EVX1, `MCALl`->MCAL1). The EOR fix was pinpointed to one byte.

## Oracle hardening (2026-07-17)
- **MLX line checksum derived: `(sum(6 data bytes) + (address & 0xFF)) & 0xFF`.** All 831
  C64 rows pass -> the entire B-1 oracle is independently validated, and it PROVES the two
  OCR-repaired lines ($2CBA, $3D1C) were recovered byte-correct. Wired into extract_object.py.

## PHASE 1 — started (whole-program assembly)
`tools/build_phase1.sh` + `tools/phase1_manifest.txt` translate all 13 modules in FILE-chain
order and diff the whole binary vs B-1. All modules translate + assemble together; second-wave
work remaining (per module, same oracle-diff loop as P0):
- **Block boundary trimming**: extracted blocks include OPTIONAL variant sections not in the
  standard oracle build. E.g. GETSA (ch5 b05) carries a "NEW CHARIN" RAM-based-assembly section
  (Ch11 material) that redefines CHARIN/CHKIN; the book says to remove the Defs versions for that
  mode. Standard disk build must exclude it. Likewise pick C64 (bare `.FILE X`) over Atari
  (`.FILE D:X.SRC`) / PET / VIC variants per module.
- **Tables string data**: `MNEMONICS .BYTE "LDALDYJSR...` (open-ended LADS string, reads to line
  end). Needs the exact LADS string->byte encoding (PETSCII vs screen code) — most delicate for
  byte-exactness; Tables also defines the vars EVAL references (OP/BUFFER/ENDFLAG/ARGSIZE/...).
- **More OCR**: additional EOR->FOR (equate), dropped operand commas, ';'->',' / ':' delimiters.
- **All-or-nothing addressing**: module lengths cascade; one wrong length shifts every downstream
  module and breaks forward-refs. Track via matching-prefix growth against the oracle.
- Efficient path: fan out one agent per chapter/module (Chris's "fan out agents" rule), each
  running the proven translate->assemble->diff loop against the shared oracle.

### PHASE 1 COMPLETE — 100.0% BYTE-EXACT (2026-07-17)
The full C64 LADS (all 13 modules) assembles via ca65+ld65 to the shipped Appendix B object
code with **0 mismatches over all 4986 bytes** ($2AF8..$3E72). The 46-byte tail past $3E72 is
all-zero startup-cleared BSS the MLX didn't ship. Reproduce: `bash tools/build_phase1.sh`.
Last two fixes that closed it:
- Tables error messages: restored the PETSCII `$1D` (cursor-right) formatting bytes the
  transcription flattened to spaces (NOARG=9, MDISER/MDUPLAB/MERROR=5 each) -> reclaimed the
  delta-12 shift (91.4% -> 99.9%).
- INDISK line 1325 book/object fork: the book printed a dev-variant `LDA #$18:JSR PRINT` with
  the ORIGINAL `LDA PASS:BEQ STARN` commented out just above (lines 1310-1320); the shipped
  binary used the original. `BEQ +$0B` == the 11-byte '*'+label print block skipped on pass 1.
  Oracle byte $3E8A == PASS confirmed it. (99.9% -> 100.0%)
Total reconstruction corrections: ~20 auditable OCR/fork fixes across src/corrections/*.txt.
Next: self-hosting (run rebuilt LADS in a 6502 sim on its own source), then the Apple II build.

### (earlier) FIRST FULL ASSEMBLY: 91.4% whole-program byte-exact (2026-07-17)
All 13 modules assemble + link, every symbol resolved; `build/p1/lads.bin` = 5020 B vs
oracle 4986 B, **4556/4986 bytes match (91.4%)**. Second-wave OCR/structure fixes applied:
- Preprocessor: monotonic-line-# continuation merge (wrapped comments w/ spurious numbers);
  `.byte` string data kept intact + balanced quotes; `+l`/`+I` -> `+1` (digit-1 OCR);
  A/X/Y label DEFINITIONS renamed (VARA/VARX/VARY); bare `FILE <mnemonic>` = code label
  (the runtime F-pseudo-op handler) not the `.FILE` chain directive; `--maxline` trims
  embedded appendices (GETSA @210 drops the "NEW CHARIN" RAM-assembly section).
- Corrections: EOR<-FOR (equate), label-def OCR ADONEI->ADONE1, F01->FO1, PPRINTER/PRINNTER
  ->PRINTER, SMORE->STORE (pass-2 re-entry), SCREEN .S-handler label renamed SCRNOP (collides
  with Defs SCREEN=$0400 equate), ';'->',' delimiters.
- **Remaining gap is layout drift, not scattered errors**: 313/430 mismatches are exactly
  delta-12 (address operands whose targets sit 12 B higher in the oracle). The opcode stream
  stays aligned for 1000+ instructions => code transcription is essentially right. The shift
  originates in TABLES data encoding (mnemonic/opcode/message tables + var reservations set
  where OP/BUFFER/... land, which hundreds of operands reference). Next: make TABLES byte-exact
  (string->byte encoding, table lengths, terminators), then chase the ~117 smaller deltas.

## FORKS (multi-machine) — 2026-07-17
Fork model: one source of truth (core + deltas), materialized per fork into `dist/<fork>/`.
Build any fork: `bash tools/build_phase1.sh <manifest> <builddir> <oracle>`; package:
`bash tools/materialize.sh <fork>`. Fork = C64 core with the Defs block swapped (+ deltas).

| fork | source delta | oracle | result |
|------|--------------|--------|--------|
| c64-disk | (trunk) | B-1 | **100% byte-exact** ✓ imaged (asm/bin/prg) |
| vic-disk | VIC Defs (ch2 b1) | B-1+B-2 (18 lines) | **100% byte-exact** ✓ imaged |
| pet-disk | PET Defs (ch2 b2) | B-1+B-3a (byte patches) | 99.6% (19 B) — see below |
| atari    | Atari Defs + per-module CIO code mods | B-4 | pending (big delta) |
| apple    | Apple Defs ($79FD) + derived code deltas | B-5 (byte-exact) | pending (big delta) |

**VIC/PET are Defs-only forks** (no per-module code mods; B-2/B-3 changes fall out of the ROM
equate differences). VIC needed ZERO extra corrections. **Atari/Apple are code-delta forks**
(CIO/ProDOS vs KERNAL I/O) — the machine-mod blocks are partial module RE-LISTINGS keyed by
matching BASIC line numbers (line-overlay merge), with heavier OCR; each has a full oracle.

### Architecture finding: corrections need a per-fork layer
PET's 19 mismatches revealed a genuine per-machine fork: INDISK line 1325 ships as
`LDA PASS:BEQ STARN` on C64/VIC but `LDA #$18:JSR PRINT` (the printed source) on PET-4.0
(B-3a patches $3496-$349A). So that "correction" is really a C64/VIC delta, not core. Next:
split corrections into universal (core OCR) + per-fork (`src/corrections/<fork>-*.txt`), let the
manifest list multiple correction files per module, and PET closes to 100%. Also: fix the
3-column Address/Byte parser for B-3a/B-3b, and the B-4 MLX has a >255 byte (merged separator).

## ALL 5 MACHINE IMAGES DELIVERED — 2026-07-17
| fork | image | source (labeled asm) |
|------|-------|----------------------|
| c64  | prg/bin, byte-exact | **byte-exact from source** ✓ |
| vic  | prg/bin, byte-exact | **byte-exact from source** ✓ |
| pet  | prg/bin, byte-exact | **byte-exact by construction** ✓ |
| atari| xex/bin, byte-exact minus 2 corrupt lines | decompile pending (~1300 B Atari-only CIO code not printed in book) |
| apple| bin, byte-exact as-extracted (no checksum in Apple format) | decompile pending (book printed no Apple module source, only Defs) |

The C64 was Mansfield's primary target (full printed source -> byte-exact reconstruction).
VIC/PET are Defs-only forks off it. Atari/Apple were PORTS: the book shipped their object
code (+ Atari partial mod-blocks / Apple Defs) but not full source, so their IMAGES come
straight from the (repaired) object oracles while a labeled SOURCE requires a decompile.
Reusable pipeline for other MLX type-ins: extract_object (+ --resync), src_extract, lads2ca65,
dis6502, materialize.

## Phase plan
- **P0** prove loop on Eval (C64) — **DONE, byte-exact**
- **P1** full verified C64 core
- **P2** apply Apple deltas → verified Apple II LADS (needs B-5 cleanup, task #5)
- **P3** literate cross-linking + vault research pages
