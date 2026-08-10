# Display Resolution and Window Mode Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let PC players choose 1280×720, 1600×900, or 1920×1080 and switch between windowed and fullscreen from the existing main-menu settings surface, with the choice restored on the next launch.

**Architecture:** Add a focused `DisplaySettings` owner that persists normalized display values and applies them through `DisplayServer`; keep accessibility effect persistence separate. Stack the UI integration on PR183 because `scripts/ui/main_menu.gd` is already owned by the Ver 4.3 control-room work, and validate all three sizes against that responsive menu.

**Tech Stack:** Godot 4.7.1, GDScript, ConfigFile, DisplayServer, existing SceneTree/static contract tests. Persistent `.gd` authoring MUST be performed through HiGodot MCP; GUT remains non-authoring test authority.

## Global Constraints

- Decision: `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE`.
- Implementation base is PR183 exact remote HEAD `42e4f378ef10aebfcd812f737bcdae33cfe8dd3f`, not project main, because both changes touch `scripts/ui/main_menu.gd`.
- Do not base product implementation on the unpushed local visual-only candidate `757df80b...`; preserve that candidate as Human-QA evidence only unless separately promoted.
- Allowed resolutions are exactly `1280x720`, `1600x900`, `1920x1080`.
- Allowed display modes are exactly `windowed`, `fullscreen`.
- Default is `windowed` + `1280x720`.
- Fullscreen preserves the last selected windowed resolution and does not force a pixel window size while fullscreen.
- Do not modify viewport/stretch configuration in `project.godot`.
- Do not add VSync, FPS cap, render scale, HDR, monitor selection, borderless variants, or Android settings.
- `AccessibilitySettings` remains the owner only for screen shake, flash, and horror distortion.
- All persistent `.gd` writes, including test `.gd` files, go through HiGodot MCP.

---

### Task 1: RED tests for display-setting normalization and persistence

**Files:**
- Create: `tests/display_settings_test.gd`
- Create later: `scripts/ui/display_settings.gd`
- Reference: `tests/accessibility_settings_test.gd`

**Interfaces:**
- Produces expected API for `DisplaySettings`:
  - `get_display_mode() -> String`
  - `get_resolution_id() -> String`
  - `set_display_mode(mode: String) -> Error`
  - `set_resolution_id(resolution_id: String) -> Error`
  - `get_resolution_size(resolution_id: String = "") -> Vector2i`
  - `apply_saved() -> Error`
- For deterministic tests, the owner must support `configure_path_for_test(path: String) -> void` before loading/saving test config so tests do not mutate the real user profile.

- [ ] **Step 1: Author the failing SceneTree test through HiGodot MCP**

Create `tests/display_settings_test.gd` with a temporary `user://test_runs/display_settings_test.cfg` path. Verify:

```gdscript
const Settings = preload("res://scripts/ui/display_settings.gd")

var settings := Settings.new()
settings.configure_path_for_test("user://test_runs/display_settings_test.cfg")
assert(settings.get_display_mode() == "windowed")
assert(settings.get_resolution_id() == "1280x720")
assert(settings.get_resolution_size("1280x720") == Vector2i(1280, 720))
assert(settings.get_resolution_size("1600x900") == Vector2i(1600, 900))
assert(settings.get_resolution_size("1920x1080") == Vector2i(1920, 1080))
assert(settings.set_display_mode("invalid") == ERR_INVALID_PARAMETER)
assert(settings.set_resolution_id("1024x768") == ERR_INVALID_PARAMETER)
```

Then save a valid mode/resolution, construct a second owner against the same test path, and assert the values reload. Also write corrupt values through `ConfigFile` and assert a fresh owner normalizes them to `windowed` and `1280x720`.

- [ ] **Step 2: Run and verify RED**

```powershell
& $godot --headless --path $repo -s tests/display_settings_test.gd
```

Expected: FAIL because `res://scripts/ui/display_settings.gd` does not exist.

- [ ] **Step 3: Record RED evidence**

Record exact HEAD, command, exit code, and missing-script failure before product authoring.

- [ ] **Step 4: Commit the RED test**

```bash
git add tests/display_settings_test.gd
git commit -m "test: define display settings persistence contract"
```

---

### Task 2: Implement the dedicated DisplaySettings owner

**Files:**
- Create: `scripts/ui/display_settings.gd`
- Test: `tests/display_settings_test.gd`

**Interfaces:**
- `PATH := "user://display.cfg"`
- `SECTION := "display"`
- `RESOLUTIONS := {"1280x720": Vector2i(1280,720), "1600x900": Vector2i(1600,900), "1920x1080": Vector2i(1920,1080)}`
- `MODES := ["windowed", "fullscreen"]`

- [ ] **Step 1: Author the minimal owner through HiGodot MCP**

Implement the exact public API defined in Task 1. Load config on initialization, normalize unknown values, and persist corrected values. `set_display_mode()` and `set_resolution_id()` reject unsupported values with `ERR_INVALID_PARAMETER`; valid values save immediately.

`apply_saved()` uses:

```gdscript
if get_display_mode() == "fullscreen":
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
else:
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    DisplayServer.window_set_size(get_resolution_size())
```

If a platform call cannot produce the requested state, return a non-OK error only when the API reports one; otherwise the UI will read back the actual mode/size after application. Do not touch `ProjectSettings` or viewport/stretch values.

- [ ] **Step 2: Run the focused persistence test**

```powershell
& $godot --headless --path $repo -s tests/display_settings_test.gd
```

Expected: PASS for normalization, validation, and persistence. If headless display application itself is unavailable, separate pure persistence assertions from runtime DisplayServer assertions rather than weakening validation.

- [ ] **Step 3: Run the existing accessibility settings test**

```powershell
& $godot --headless --path $repo -s tests/accessibility_settings_test.gd
```

Expected: PASS, proving display persistence did not alter accessibility ownership.

- [ ] **Step 4: Commit the owner**

```bash
git add scripts/ui/display_settings.gd tests/display_settings_test.gd
git commit -m "feat: add persistent display settings owner"
```

---

### Task 3: RED contract for the settings UI

**Files:**
- Modify: `tests/validation/validation_main_menu_contract_test.gd` or create `tests/main_menu_display_settings_test.gd` if the existing validation test would become overly broad.
- Modify later: `scripts/ui/main_menu.gd`

**Interfaces:**
- Main-menu settings surface exposes named focusable controls:
  - `DisplayModeOption`
  - `ResolutionOption`
- Existing `SettingsButton` continues to toggle the panel.

- [ ] **Step 1: Author the failing UI test through HiGodot MCP**

Instantiate `res://scenes/main_menu.tscn`, await UI build, open or inspect the settings panel, and assert the named controls exist, are `OptionButton` instances, have `FOCUS_ALL`, and contain the required labels/options:

```text
표시 모드: 창 모드 / 전체화면
해상도: 1280×720 / 1600×900 / 1920×1080
```

Also assert the existing accessibility sliders remain present/functional through the current contract.

- [ ] **Step 2: Run and verify RED**

Expected: FAIL because `DisplayModeOption` and `ResolutionOption` do not exist yet.

- [ ] **Step 3: Commit the RED UI contract**

```bash
git add tests/validation/validation_main_menu_contract_test.gd
git commit -m "test: require display controls in menu settings"
```

---

### Task 4: Integrate display controls into the PR183 settings panel

**Files:**
- Modify: `scripts/ui/main_menu.gd`
- Consume: `scripts/ui/display_settings.gd`
- Test: Task 3 UI contract

**Interfaces:**
- Add `const DisplaySettingsScript = preload("res://scripts/ui/display_settings.gd")`.
- Add one `_display_settings` instance.
- Add named option buttons `_display_mode_option` and `_resolution_option`.

- [ ] **Step 1: Author UI integration through HiGodot MCP**

In the existing `설정 / 접근성` panel, add a `화면` subsection before the effect sliders. Populate the mode option in this order:

```text
창 모드
전체화면
```

Populate resolution in this order:

```text
1280×720
1600×900
1920×1080
```

Initialize selections from `DisplaySettings`, not literals detached from persisted state.

- [ ] **Step 2: Wire application behavior**

On resolution selection:
1. call `set_resolution_id(...)`;
2. if current mode is windowed, call `apply_saved()`;
3. refresh option selection from actual saved state.

On mode selection:
1. call `set_display_mode(...)`;
2. call `apply_saved()`;
3. when returning to windowed, the stored last window resolution is applied;
4. refresh responsive layout after the window size settles, using the existing root `size_changed` path.

On `_ready()`, call `apply_saved()` early enough that the menu responsive layout sees the restored size, but do not interfere with test/headless environments. Keep existing settings/accessibility discoverability and focus chain behavior.

- [ ] **Step 3: Run the focused UI and settings tests**

```powershell
& $godot --headless --path $repo -s tests/display_settings_test.gd
& $godot --headless --path $repo -s tests/validation/validation_main_menu_contract_test.gd
& $godot --headless --path $repo -s tests/accessibility_settings_test.gd
```

Expected: PASS.

- [ ] **Step 4: Run PR183 maintained menu regressions**

Run the same main-menu contract/static tests used by PR183 exact-head CI, including the Python static contract and the existing validation menu contract. Expected: no regression to ProductVersion, Legacy/Validation separation, focus, or responsive intelligence behavior.

- [ ] **Step 5: Commit the menu integration**

```bash
git add scripts/ui/main_menu.gd scripts/ui/display_settings.gd tests/display_settings_test.gd tests/validation/validation_main_menu_contract_test.gd
git commit -m "feat: add display size and fullscreen settings"
```

---

### Task 5: Exact-head runtime verification at all supported sizes

**Files:**
- No product file changes unless a failed test starts a new TDD cycle.

**Interfaces:**
- Produces exact-head automated + Human QA evidence for the display Decision.

- [ ] **Step 1: Godot 4.7.1 import**

```powershell
& $godot --headless --path $repo --import
```

Expected: exit 0.

- [ ] **Step 2: Verify windowed 1280×720**

From in-game settings choose `창 모드` + `1280×720`. Verify the actual game window resizes and the compact PR183 menu layout remains usable.

- [ ] **Step 3: Verify windowed 1600×900**

Choose `1600×900`; verify actual resize, no clipped settings controls, primary focus still meaningful, and responsive content remains stable.

- [ ] **Step 4: Verify windowed 1920×1080**

Choose `1920×1080`; verify expanded right-side intelligence appears when available and no overlap/clipping occurs.

- [ ] **Step 5: Verify fullscreen and restore**

Choose `전체화면`, then return to `창 모드`. Verify the last selected window resolution is restored. Quit and relaunch exact HEAD and verify the selected mode/resolution persist.

- [ ] **Step 6: Keyboard/gamepad focus QA**

Navigate into settings without a mouse, move between display mode, resolution, and existing accessibility controls, and confirm current choices are indicated by text/selection state rather than color only.

- [ ] **Step 7: Verify diff boundary**

Compare against PR183 base `42e4f378ef10aebfcd812f737bcdae33cfe8dd3f`. Expected product changes are only the display owner, menu integration, and focused tests/evidence docs; no `project.godot`, scenes, assets, data, or PR180 changes.

- [ ] **Step 8: Update Decision/GitHub/Sheet with exact implementation HEAD**

Use `D-2026-08-10-DISPLAY-RESOLUTION-WINDOW-MODE` in both GitHub and Google Sheet. Keep this stacked change Draft/not merge-ready until its exact-head checks and Human QA are green and the dependency on PR183 is explicit.
