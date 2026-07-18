#!/usr/bin/env bash
# Fetch the book's pages from atariarchives.org into raw/html/ (not committed here, to
# avoid redistributing the copyrighted text). The reconstruction pipeline reads from raw/.
# Book: "The Second Book of Machine Language", Richard Mansfield, COMPUTE! Publications, 1984.
# Hosted with permission at atariarchives.org.
set -eu
cd "$(dirname "$0")/.."
mkdir -p raw/html
base="https://www.atariarchives.org/2bml/"
pages="index chapter_1 chapter_2 chapter_3 chapter_4 chapter_5 chapter_6 chapter_7 \
chapter_8 chapter_9 chapter_10 chapter_11 appendix_a appendix_b appendix_c appendix_d appendix_e"
for p in $pages; do
  curl -fsSL "${base}${p}.php" -o "raw/html/${p}.html" && echo "  ${p}.html" || echo "  FAILED ${p}"
done
echo "done -> raw/html/ ($(ls raw/html | wc -l) pages)"
