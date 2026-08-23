# Project Notes

## Scope rules
- UI/layout changes must NOT touch the embedded Rust scraper (`rust_builder/`, `lib/src/rust/`) or its generated Dart bindings unless explicitly requested or absolutely necessary. The app is a Flutter frontend over a Rust VTOP scraper; treat the scraper as a stable backend.

## Theme
- Monochrome only (black & white). All color themes were removed; do not reintroduce seed colors.
- Fonts: **Outfit** is the primary font (all headings/titles/body, varying weights 300–700). **Inter** is for small details (captions, timestamps, metadata, labels).

## Timetable design decisions
- Only Morning and Afternoon sections (no Evening; classes at/after 12:00 go under Afternoon).
- Lab vs Theory: labs run ~2 hours (e.g. 8:00–9:50), theory runs 50 min (e.g. 2:00–2:50). Detect by `courseType` containing "lab", falling back to session duration >= 90 minutes.
- Days with no classes are hidden from the day strip entirely.
- Class rows show minimal info only (name, LAB/THEORY pill, time, room in Inter). Full details appear in a centered popup box with a blurred background when a class is tapped; tap anywhere outside to dismiss.
