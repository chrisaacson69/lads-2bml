# LADS — a byte-exact reconstruction

A reconstruction of **LADS**, the memory-resident 6502 assembler from Richard Mansfield's
*The Second Book of Machine Language* (COMPUTE! Publications, 1984), rebuilt from the book's
printed source listings and **verified byte-for-byte against the published object code**.

> **Status: the C64 build assembles to the shipped object code with 0 mismatches over all
> 4986 bytes** (`dist/c64-disk/VERIFY.txt`). Rebuild it yourself: `bash tools/materialize.sh`.

## Why this is unusual

The book printed LADS's complete commented source *and* (in Appendix B) its object code. That
lets the reconstruction be **self-verifying**: transcribe the source → assemble it with a modern
cross-assembler → diff the bytes against Appendix B. Any mismatch is a located transcription
error. The object listings even carry per-line checksums (C64 MLX), so the ground-truth oracle
is itself validated (all 831 lines pass).

This is the inverse of a decompiler: the source exists; the work is faithful transcription plus
verification, and along the way the oracle catches ~20 real OCR/typo defects in the archived
listings that the eye would miss (`EOR`→`FOR`, PETSCII `$1D` cursor-rights flattened to spaces,
a `=`-for-`-` in the Apple hex, a printed dev-variant with the shipped original in a comment…).

## Forks within forks

LADS supported five machines (C64/VIC/PET/Atari/Apple) × configs (disk- vs RAM-based assembly,
I/O targets), all inlined into one listing. This repo keeps **one source of truth** and
materializes each fork as a directory:

```
src/core-ish:  src/raw_blocks/ (extracted book listings) + src/corrections/ (OCR fixes)
               + tools/phase1_manifest.txt (module order, trims)     ← the trunk (C64)
src/forks/     machine/*.delta, config/*.delta                        ← forks within forks
dist/<fork>/   lads.asm  lads.bin  lads.prg …   ← GENERATED + committed, one dir per fork
```

Nothing is duplicated: every `dist/<fork>/` is generated from core + deltas, so there is no
drift. Each is verified against its oracle where one exists (C64→Appendix B‑1, Apple→B‑5).

## Build

Requires the `cc65` toolchain (`ca65` + `ld65`). The book pages are **not** committed
(see [NOTICE.md](NOTICE.md)); fetch them first, then build:

```
bash tools/fetch_raw.sh              # pull book pages from atariarchives.org into raw/html/
bash tools/materialize.sh c64-disk   # → dist/c64-disk/ (asm, bin, prg, VERIFY.txt)
```

Pipeline (all in `tools/`): `extract_object.py` (oracle from Appendix B, checksum-validated) ·
`src_extract.py` (lift listings from raw HTML) · `lads2ca65.py` (LADS→ca65: strip BASIC line
numbers, split `:` statements, restore OCR/PETSCII, apply corrections) · `build_phase1.sh`
(assemble+link+diff) · `materialize.sh` (emit a fork's dist artifacts).

## Layout

| path | what |
|------|------|
| `raw/html/` | immutable copies of the book pages (grounding layer) |
| `src/raw_blocks/` | per-module source blocks extracted from the listings |
| `src/corrections/` | auditable OCR/typo fixes, one file per module |
| `src/forks/` | per-machine / per-config delta overlays |
| `reference/` | byte-exact object-code oracles (C64 + Apple) |
| `tools/` | the reconstruction + build pipeline |
| `dist/` | generated, committed per-fork artifacts |
| `docs/STATUS.md` | detailed engineering log |

## Provenance

Book text/scans: [atariarchives.org/2bml](https://www.atariarchives.org/2bml/) ·
[archive.org scan](https://archive.org/details/ataribooks-the-second-book-of-machine-language).
Source © 1984 Richard Mansfield / COMPUTE! Publications; reconstructed here for study and
preservation.
