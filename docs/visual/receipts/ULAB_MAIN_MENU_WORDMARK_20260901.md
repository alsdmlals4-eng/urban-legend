# ULAB Main Menu Wordmark 2026-09-01

## Status

`USER_LOCKED → PROJECT_ASSET_APPROVED → IMPLEMENTED → RUNTIME_VERIFIED`.

## Selection and scope

- User lock: `아니 워드타이포도 확정한다고` on 2026-09-01.
- Scope: the same wide Korean word-typography candidate for the main-menu title presentation, used together with the separately locked compact bureau emblem.
- Excludes: a new game name, a new emblem, a case-specific visual, or automatic approval of a replacement title treatment elsewhere in the game.

## Source and derivative

- Locked source: `assets/source/wordmarks/ULAB-MAIN-MENU-WORDMARK-001-locked-source.png`
- Locked source SHA-256: `36c20c3538486d4423a907652153c741149de980c73ef18375d455b984699dfc`
- Runtime derivative: `assets/ui/bureau_archive_wordmark.png`
- Runtime derivative SHA-256: `ac49625f3f5febac55837ac3dc6624dbd514d3e3ea2bae8f03c36210d8157225`
- Size: `1969 × 799`
- Cleanup: the source's opaque neutral checkerboard pixels only (`minimum RGB ≥ 240`, `maximum RGB - minimum RGB ≤ 5`) were converted to alpha `0`; no source file was overwritten and non-matching pixels retain their original values.

## Consumer and evidence boundary

- Consumer: `scripts/ui/main_menu.gd → WorldTitleLockup/WorldTitleWordmark`.
- The visual wordmark replaces duplicate visible Korean title labels. `WorldTitle` and `WorldTitleSuffix` keep their established node IDs and exact text values for compatibility and semantic fallback.
- Current 1280×720 runtime capture after the approved three-zone menu layout: `docs/qa/captures/main-menu/reference-layout-20260901/main-menu-reference-layout-1280x720.png`.
- Machine/runtime verification is recorded only after the Godot import and main-menu contract run. Human visual review, accessibility observation, distribution-rights clearance, and release approval remain `NOT_RUN`.
