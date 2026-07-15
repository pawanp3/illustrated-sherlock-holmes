# Contributing

Thanks for helping improve the illustrations! This project accepts community
pull requests **to fix images only**.

## What you may change

A community PR may change **only** these files:

- `books/<style>/<book>/images/*.jpg` — a scene illustration the site renders
- `books/<style>/<book>/cover.jpg` — a book cover

A PR that touches anything else (an `index.html` page, an `.epub`, workflows,
config, docs) is automatically blocked by the `pr-guard` check. Those changes
are made by the maintainer. If you think a non-image file needs fixing, open an
**issue** describing it instead of a PR.

## How to submit an image fix

1. Fork the repo and edit the single `*.jpg` you want to fix (match the existing
   image's dimensions).
2. Open a PR. GitHub renders image diffs side-by-side, so the fix is reviewed
   visually.
3. The maintainer reviews and merges.

## What happens to your image on merge

Every contributed JPEG is **re-encoded and stripped of all metadata** before it
lands on the live site — it is never committed verbatim. This is a security
measure (it removes any EXIF/XMP metadata and any data hidden or appended inside
the file) and is run by the maintainer with:

```
scripts/sanitize-images.sh path/to/your-image.jpg
```

The re-encode is lossy, so submit the cleanest image you can; small quality
differences from the final re-encode are expected.

## Notes

- The live site renders from `images/*.jpg` and `cover.jpg`. High-resolution
  source PNGs are **not** in this repo.
- `main` is protected: all changes go through a reviewed PR with the `pr-guard`
  check passing.

<!-- pr-guard verification, will be reverted -->
