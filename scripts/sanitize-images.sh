#!/usr/bin/env bash
#
# sanitize-images.sh — re-encode contributed JPEGs to strip any embedded
# metadata or appended payload. Run this on the maintainer's machine when
# merging a community image PR: never commit a contributed JPEG verbatim.
#
# What it does to each JPEG:
#   - fully re-decodes and re-encodes the pixels (so any data appended after the
#     JPEG's end-of-image marker, or hidden in a comment segment, does not survive)
#   - strips ALL metadata: EXIF, IPTC, XMP, ICC profiles, comments (-strip)
#
# Usage:
#   scripts/sanitize-images.sh                 # sanitize every tracked served JPEG
#   scripts/sanitize-images.sh path/to/a.jpg   # sanitize specific files
#   QUALITY=92 scripts/sanitize-images.sh ...   # override JPEG quality (default 90)
#
# After running, ALWAYS eyeball the visual diff before committing.

set -euo pipefail

QUALITY="${QUALITY:-90}"

if command -v magick >/dev/null 2>&1; then
  MAGICK=(magick)
elif command -v convert >/dev/null 2>&1; then
  MAGICK=(convert)
else
  echo "error: ImageMagick not found. Install with: brew install imagemagick" >&2
  exit 1
fi

files=("$@")
if [ "${#files[@]}" -eq 0 ]; then
  # Default: all served JPEGs tracked by git.
  while IFS= read -r f; do
    files+=("$f")
  done < <(git ls-files 'books/*/*/images/*.jpg' 'books/*/*/cover.jpg')
fi

if [ "${#files[@]}" -eq 0 ]; then
  echo "No JPEG files to sanitize."
  exit 0
fi

count=0
for f in "${files[@]}"; do
  case "$f" in
    *.jpg|*.jpeg|*.JPG|*.JPEG) ;;
    *) echo "skip (not a jpeg): $f"; continue ;;
  esac
  if [ ! -f "$f" ]; then
    echo "skip (missing): $f"
    continue
  fi
  tmp="${f}.sanitized.$$"
  "${MAGICK[@]}" "$f" -strip -interlace none -sampling-factor 4:2:0 -quality "$QUALITY" "$tmp"
  mv "$tmp" "$f"
  echo "sanitized: $f"
  count=$((count + 1))
done

echo "Done. Re-encoded and stripped metadata from $count file(s)."
echo "Review the visual diff (git diff / GitHub) before committing."
