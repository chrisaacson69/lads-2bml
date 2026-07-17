# Forks

Delta overlays that turn the C64 trunk into the other machine/config variants. Each fork is
**generated from core + these deltas**, never hand-duplicated, so the shared ~90% never drifts.

The fork matrix is **machine × config**:

- `machine/` — `apple`, `atari`, `vic`, `pet`. Mansfield isolated most of these as per-module
  modification blocks; `src_extract.py` already pulled them out (e.g. `chapter_3_b04` = the
  Atari EVAL modifications, `chapter_2_b03` = the Apple DEFS at `*= $79FD`).
- `config/` — `ram` (the "NEW CHARIN" RAM-based-assembly variant embedded in the GETSA listing;
  source in memory, object to memory, no disk — the target for the in-browser self-hosting demo).

A delta is expressed the same way the C64 build is: a manifest fragment (which variant block
replaces which core module, plus line-range trims) and a corrections file. `materialize.sh
<machine>-<config>` applies core + the named deltas, assembles, and verifies against that fork's
oracle where one exists (Apple → Appendix B-5, byte-exact).

Status: baseline `c64-disk` is byte-exact. Other forks are queued — the delta blocks exist in
`src/raw_blocks/`, they need wiring into fork manifests + their own OCR corrections.
