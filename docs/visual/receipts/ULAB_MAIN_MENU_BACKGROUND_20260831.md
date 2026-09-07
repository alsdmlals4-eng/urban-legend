# ULAB Main Menu Bureau Archive Background Receipt

- Decision: `D-2026-08-31-ULAB-MAIN-MENU-BUREAU-ARCHIVE-BACKGROUND`
- Status: `USER_APPROVED / PROJECT_ASSET_APPROVED / IMPLEMENTED / RUNTIME_VERIFIED / HUMAN_QA_NOT_RUN`
- User lock: 2026-08-31 — use the supplied research-library image as the main-menu environment and place the approved three-rail menu system over it. The layout reference guides UI structure only; its fictional names, dates, alerts, slots, and case copy are not runtime content.
- Source: user-provided Codex attachment `codex-clipboard-e2893934-18b7-424f-9dd4-557eb92db1ec.png`.
- Canonical file: `assets/backgrounds/bureau_archive_menu.png`
- SHA-256: `dab2c35a06cbce5d2a4b4b1d071ed0589e77bf801f35457ed97c329fa238a504`
- Dimensions: `1672 × 941 PNG`
- Runtime consumer: `scenes/main_menu.tscn` → `scripts/ui/main_menu.gd` → `MainMenuBackdrop`
- Native product-title lockup: `괴이기록국: 잔향 보고서` is composed in Godot from the `WorldTitle` and `WorldTitleSuffix` labels; the accompanying English subtitle is `BUREAU OF ANOMALIES: ECHO REPORT`. This is a display title, not a rename of the world-internal agency, save identity, episode IDs, or canonical terminology.
- Presentation boundary: the exact image is an environment-only background. Godot owns the readable menu, live save state, current-case data, controls, focus order, and accessibility surface.
- Rights note: this receipt records the user's supplied asset and approval scope. It is not a distribution-rights or release-clearance finding.

## Recorded runtime verification

1. `tests/test_main_menu_control_room_static_contract.py` verifies the approved texture catalog/consumer and the native two-line product title contract.
2. `tests/validation/validation_main_menu_contract_test.gd` verifies the instantiated main-menu controls, the backdrop, the product-title labels, and keyboard-focus contract at 1280×720.
3. `tests/validation/main_menu_window_breakpoint_test.gd` verifies that all action controls remain reachable at 1280×720 and at the compact 1920 desktop-client layout.
4. GPU runtime captures were recorded with the project capture scenario:
   - `docs/qa/captures/main-menu/bureau-archive-20260831/main-menu-bureau-1280x720.png`
   - `docs/qa/captures/main-menu/bureau-archive-20260831/main-menu-bureau-window-1920x1061.png` (1920×1080 window request; 1920×1061 client viewport)

These are focused machine and GPU-runtime evidence only. Human visual/accessibility review and distribution-rights review remain `NOT_RUN` / pending.
