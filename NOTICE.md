# Notice & attribution

LADS and its printed source/object code originate in ***The Second Book of Machine
Language*** by **Richard Mansfield**, © 1984 **COMPUTE! Publications, Inc.** The book is
hosted online with permission at
[atariarchives.org/2bml](https://www.atariarchives.org/2bml/).

This repository is a **reconstruction and preservation** effort for study and historical
interest. It contains:

- **Tools** (original work) that extract, transcribe, translate, assemble, and verify.
- **Reconstructed source** (`src/`, `dist/*/lads.asm`) derived from the book's listings,
  corrected against the book's own published object code.
- **Object-code images** (`dist/*/lads.bin` etc.) derived from Appendix B.

The **raw book pages are intentionally NOT included** here. Run `tools/fetch_raw.sh` to pull
them from atariarchives.org on demand; the pipeline reads from `raw/html/`.

All rights to the original work remain with the copyright holder(s). If you are a rights
holder and would like anything changed or removed, please open an issue.

The **tooling** in `tools/` is released under the MIT License (see `LICENSE`).
