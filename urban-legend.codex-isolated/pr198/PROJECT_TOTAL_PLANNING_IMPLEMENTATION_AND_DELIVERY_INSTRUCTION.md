# PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION — Canonical Entry

- contract version: `4.5`
- revision: `2026-08-11-r2`
- Decision ID: `D-2026-08-11-PROJECT-WORK-INSTRUCTION-V4-5-R2-CANON`
- status: `CURRENT_CANONICAL_WORK_INSTRUCTION / THIN_ADAPTER`
- logical source bytes: `77734`
- logical source SHA-256: `3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4`
- logical full Git blob SHA-1: `de7c6f818a4c96d2a02edea5eaff33bb1c39e8da`

## Canonical source packaging

The attached `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md` is the logical canonical source.

The current GitHub connector could not safely transfer the 77,734-byte source as one opaque payload without byte drift, so the source is stored as **47 line-bounded exact UTF-8 parts**:

`docs/canon/work-instruction/v4.5-r2/part-00.md` through `part-46.md`.

Concatenate those files in numeric order with **no inserted separator** to reconstruct the logical canonical source exactly.

Every canonical part was accepted only after its Git blob SHA-1 matched the SHA recomputed directly from the attached source. Before commit, local reconstruction of the exact 47 parts produced:

```text
bytes 77734
SHA-256 3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4
Git blob SHA-1 de7c6f818a4c96d2a02edea5eaff33bb1c39e8da
```

## Authority and migration

- v4.5-r2 supersedes v4.4 and earlier work-instruction revisions for current project work-instruction authority.
- The source is a thin adapter. Base-owned procedures must be re-read from current Base and are not frozen by this document.
- The source's observed Base SHA `7ce3fb64...` is historical only. Live Base main at this canon-promotion task start was `315c66eea9614c284b9c11c4d522141065dfa4b0`.
- This canon promotion does **not** itself equal the source-defined exact planning-completion declaration `기획 완료`.
- This canon promotion does **not** authorize persistent product Godot BUILD.

## Preserved source-internal conflict

Section 4 of the exact source contains `Switchy-Express-Cargo-Puzzle` local paths, while the current urban-legend project contract uses `C:/Users/user/Documents/GitHub/Ninza/urban-legend`.

The exact source is intentionally not silently rewritten. This is tracked as `SOURCE_INTERNAL_PROJECT_INPUT_CONFLICT` and requires a separate explicit correction/revision if the source itself is to change.

## Scope of this canon replacement

- instruction canon + governance metadata only
- no product runtime GDScript
- no Scene/Resource/project.godot mutation
- no gameplay data/assets/workflow mutation
- no Human/Android validation claim
