# MVP-035 Log AI Companion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 괴담기록국 AI `로그`를 이미지·표정·접속 시그니처와 함께 주요 화면 및 현장 대화에 참여하는 Ver 3.5 등장인물로 구현한다.

**Architecture:** `GameState`는 확인한 튜토리얼 ID만 저장하고, `LogTutorialCatalog`는 공개 가능한 안내 문장을 소유한다. `LogGuide`는 로그 전용 초상·대사·표정·접속 연출을 담당하며 기존 화면은 이 컴포넌트를 배치하거나 기존 `field_nodes`의 `speaker: "로그"`를 전달한다.

**Tech Stack:** Godot 4.7 stable, GDScript, JSON episode data, generated PNG assets, procedural `AudioStreamWAV`, PowerShell/Git.

## Global Constraints

- 화면·문서·저장 버전은 `Ver 3.5 / MVP-035 / mvp-035`다.
- 로그는 확보한 단서와 현재 공개 상태만 말하며 정답·미확보 단서를 누설하지 않는다.
- 전체 접속 연출은 첫 등장과 중요한 상태 변화에만 실행하고 연속 대사에서는 반복하지 않는다.
- 알림음 없이도 화자명·표정·점등·색 변화로 상태를 이해할 수 있어야 한다.
- 기존 `field_nodes`, 저장 데이터, 요원 대화, 시장, 회수 흐름을 보존하고 범용 대화 프레임워크를 새로 만들지 않는다.
- 제공된 참고 이미지에서는 전자 화면의 픽셀 얼굴 원리만 재해석하며 고유 외형을 복제하지 않는다.
- `.superpowers/brainstorm/` 런타임 파일과 Godot가 자동 변경한 `.import` 메타데이터는 제품 커밋에서 제외한다.

---

### Task 1: Benchmark packet and isolated baseline

**Files:**
- Create: `docs/benchmarks/MVP-035_LOG_AI_COMPANION.md`
- Modify: `docs/BENCHMARKING_REFERENCE_GUIDE.md`

**Interfaces:**
- Consumes: approved design `docs/superpowers/specs/2026-07-13-log-ai-companion-design.md`
- Produces: 구현 판단표와 제외 기준

- [ ] **Step 1: Create an isolated worktree**

Run:

```powershell
git check-ignore .worktrees
git worktree add .worktrees/mvp-035-log-ai -b codex/mvp-035-log-ai
```

Expected: `.worktrees/mvp-035-log-ai`가 `origin/main`과 같은 기준에서 생성된다.

- [ ] **Step 2: Verify the baseline**

Run:

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path .worktrees/mvp-035-log-ai --scene res://tests/test_agent_system.tscn
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path .worktrees/mvp-035-log-ai --scene res://tests/test_mvp033_unified_recovery.tscn
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path .worktrees/mvp-035-log-ai --scene res://tests/test_mvp034_faction_market.tscn
```

Expected: `15/15`, `36/36`, `52/52` 통과.

- [ ] **Step 3: Produce the benchmark improvement packet**

최소 5개 사례에서 다음 표를 작성한다.

```markdown
| 사례 | 공개 근거·확인일 | 플레이어 효과 | 부정 반응·주의 | 로그식 재해석 | 복제하지 않을 요소 |
|---|---|---|---|---|---|
```

조사 범위는 다이제틱 AI 동료, 서사형 튜토리얼, 반복 안내 억제, 경고음 접근성이다. 각 도입안은 `채택/보류/제외`와 반대 검토를 포함한다.

- [ ] **Step 4: Commit the packet**

```powershell
git add docs/benchmarks/MVP-035_LOG_AI_COMPANION.md docs/BENCHMARKING_REFERENCE_GUIDE.md
git commit -m "docs: benchmark Log AI companion"
```

### Task 2: Tutorial state and save migration

**Files:**
- Modify: `scripts/core/game_state.gd`
- Create: `tests/test_mvp035_log_companion.gd`
- Create: `tests/test_mvp035_log_companion.tscn`

**Interfaces:**
- Produces: `has_seen_log_tutorial(id: String) -> bool`, `claim_log_tutorial(id: String, save_after: bool = true) -> bool`, `get_seen_log_tutorial_ids() -> Array`

- [ ] **Step 1: Write failing state tests**

```gdscript
GameState.reset_run_state()
_check(not GameState.has_seen_log_tutorial("main_welcome"), "tutorial starts unseen")
_check(GameState.claim_log_tutorial("main_welcome", false), "first claim succeeds")
_check(not GameState.claim_log_tutorial("main_welcome", false), "duplicate claim is rejected")
GameState.save_game()
GameState.reset_run_state()
_check(GameState.load_game(), "mvp035 save loads")
_check(GameState.has_seen_log_tutorial("main_welcome"), "tutorial state round trip")
```

- [ ] **Step 2: Run and verify RED**

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --scene res://tests/test_mvp035_log_companion.tscn
```

Expected: FAIL because `has_seen_log_tutorial` is missing.

- [ ] **Step 3: Implement minimal state API and migration**

```gdscript
const SAVE_VERSION := "mvp-035"
var seen_log_tutorial_ids: Array = []

func has_seen_log_tutorial(tutorial_id: String) -> bool:
	return seen_log_tutorial_ids.has(tutorial_id)

func claim_log_tutorial(tutorial_id: String, save_after: bool = true) -> bool:
	if tutorial_id.is_empty() or has_seen_log_tutorial(tutorial_id):
		return false
	seen_log_tutorial_ids.append(tutorial_id)
	if save_after:
		save_game()
	return true
```

`reset_run_state()`, `load_game()`, `_make_save_data()`에 배열 초기화·마이그레이션·직렬화를 추가한다.

- [ ] **Step 4: Verify GREEN and regressions**

Run MVP-035과 기존 3개 테스트. Expected: 신규 상태 테스트와 `15/36/52` 모두 통과.

- [ ] **Step 5: Commit**

```powershell
git add scripts/core/game_state.gd tests/test_mvp035_log_companion.gd tests/test_mvp035_log_companion.tscn
git commit -m "feat: persist Log tutorial state"
```

### Task 3: Log assets, catalog, and presentation component

**Files:**
- Create: `assets/log/log_normal.png`
- Create: `assets/log/log_focus.png`
- Create: `assets/log/log_warning.png`
- Create: `scripts/ui/log_tutorial_catalog.gd`
- Create: `scripts/ui/log_guide.gd`
- Modify: `scripts/ui/ui_asset_catalog.gd`
- Modify: `tests/test_mvp035_log_companion.gd`

**Interfaces:**
- `LogTutorialCatalog.get_entry(id: String) -> Dictionary`
- `LogGuide.present_lines(lines: Array, signature_mode: String = "normal", play_intro: bool = true) -> void`
- `LogGuide.present_tutorial(id: String, play_intro: bool = true) -> void`
- `LogGuide.advance() -> void`
- `LogGuide.get_current_text() -> String`
- `LogGuide.get_current_expression() -> String`
- `LogGuide.make_signature_stream(mode: String) -> AudioStreamWAV`

- [ ] **Step 1: Write failing component tests**

```gdscript
var guide := LogGuide.new()
add_child(guide)
guide.present_lines([{"text":"접속 완료", "expression":"normal"}], "normal", false)
_check(guide.get_current_text() == "접속 완료", "guide presents text")
_check(guide.get_current_expression() == "normal", "guide presents expression")
_check(guide.make_signature_stream("warning").data.size() > 0, "signature waveform exists")
_check(not LogTutorialCatalog.get_entry("main_welcome").is_empty(), "catalog entry exists")
```

- [ ] **Step 2: Verify RED**

Expected: preload or class resolution fails because the component files do not exist.

- [ ] **Step 3: Generate three original images**

Use the provided image only as a reference for a pixel face inside an electronic display. Generate original `normal`, `focus`, `warning` variants with the same terminal body and camera framing. Copy final PNGs into `assets/log/` and inspect all three.

- [ ] **Step 4: Implement catalog and guide**

`LogTutorialCatalog.TUTORIALS` contains only player-known system guidance. `LogGuide` builds a compact `HBoxContainer` with portrait, speaker name `로그`, dialogue label and next button. It changes portrait through `UiAssetCatalog.get_log_expression(expression)`.

The procedural signature uses signed 16-bit mono PCM at 22050 Hz. All modes share three pitch intervals; `focus` adds deterministic low-amplitude scan noise and `warning` shortens note spacing and lowers the base pitch.

- [ ] **Step 5: Verify GREEN**

Expected: assets resolve, three expressions differ by path, sequence advances, waveform data exists, unknown tutorial IDs return an empty dictionary.

- [ ] **Step 6: Commit**

```powershell
git add assets/log scripts/ui/log_tutorial_catalog.gd scripts/ui/log_guide.gd scripts/ui/ui_asset_catalog.gd tests/test_mvp035_log_companion.gd
git commit -m "feat: add Log portrait and connection signature"
```

### Task 4: Natural field dialogue and recovery participation

**Files:**
- Modify: `scripts/scenes/investigation_scene.gd`
- Modify: `scripts/scenes/battle_scene.gd`
- Modify: `data/episodes/episode_001_afterlife_station.json`
- Modify: `data/episodes/episode_002_red_umbrella_alley.json`
- Modify: `tests/test_mvp035_log_companion.gd`

**Interfaces:**
- Consumes: `LogGuide`, `GameState.claim_log_tutorial()` and episode dialogue entries with `speaker`, `text`, `expression`

- [ ] **Step 1: Add failing content and scene tests**

```gdscript
_check(_episode_has_log_speaker(GameState.DEFAULT_EPISODE_PATH), "afterlife has Log dialogue")
_check(_episode_has_log_speaker(GameState.RED_UMBRELLA_ALLEY_EPISODE_PATH), "umbrella has Log dialogue")
```

Instantiate `investigation_scene.tscn` and assert a `LogGuide` appears when a line uses `speaker: "로그"`. Instantiate `battle_scene.tscn` and assert its Log panel has a warning line for a telegraph without exposing `correct_response_id`.

- [ ] **Step 2: Verify RED**

Expected: afterlife content lacks Log speaker and scenes lack `LogGuide` nodes.

- [ ] **Step 3: Implement field speaker integration**

In `_show_field_line_or_choices()`:

```gdscript
var speaker := String(line.get("speaker", "현장 기록"))
if speaker == "로그":
	_log_guide.present_lines([line], String(line.get("expression", "normal")), true)
	_log_guide.visible = true
else:
	_log_guide.visible = false
```

Add short Log lines to both cases at opening, clue comparison, and pre-recovery transitions. Lines may refer only to already presented situation text or clue IDs gated by existing conditions.

- [ ] **Step 4: Implement recovery participation**

Add a compact `LogGuide` near telegraph information. Claim `recovery_first_telegraph` for the first `warning`, present `focus` after the first successful prediction, and claim `recovery_first_learning` after the first wrong response. Do not include hidden response IDs or numeric effects.

- [ ] **Step 5: Verify GREEN**

Expected: both episodes include Log; field dialogue continues normally; recovery guide uses public telegraph/prediction/learning text only.

- [ ] **Step 6: Commit**

```powershell
git add scripts/scenes/investigation_scene.gd scripts/scenes/battle_scene.gd data/episodes tests/test_mvp035_log_companion.gd
git commit -m "feat: let Log join field and recovery dialogue"
```

### Task 5: First-time guidance across primary screens

**Files:**
- Modify: `scripts/ui/main_menu.gd`
- Modify: `scripts/scenes/preparation_scene.gd`
- Modify: `scripts/scenes/market_scene.gd`
- Modify: `scripts/scenes/result_scene.gd`
- Modify: `scripts/ui/database_view.gd`
- Modify: `tests/test_mvp035_log_companion.gd`

**Interfaces:**
- Consumes: `LogGuide.present_tutorial()`, `GameState.claim_log_tutorial()`

- [ ] **Step 1: Write failing screen tests**

For each scene, instantiate it under `TestSaveGuard`, search recursively for `LogGuide`, and verify the expected first tutorial ID is claimed once. Re-enter the scene and assert the same guide does not auto-open again.

- [ ] **Step 2: Verify RED**

Expected: primary scenes do not contain `LogGuide`.

- [ ] **Step 3: Add minimal screen-specific guides**

Use one guide per screen:

```gdscript
func _show_log_tutorial(id: String) -> void:
	if GameState.claim_log_tutorial(id):
		_log_guide.present_tutorial(id)
	else:
		_log_guide.show_compact_hint(LogTutorialCatalog.get_repeat_hint(id))
```

Main uses `main_welcome` or `main_continue`; preparation uses `preparation_agents` on first entry and `preparation_contacts` when the external-contact section is first used; market uses `market_first_visit`; result uses `result_first_case`; DB uses `database_first_visit`. Investigation claims `field_first_choice` before its first choice, `field_first_record_drawer` when the drawer first opens, and `field_first_clue` immediately after the first newly collected clue. Existing preparation log lines become a sequence inside `LogGuide`, not duplicate bullet labels.

- [ ] **Step 4: Verify GREEN**

Expected: each screen shows one full first guide, repeated entry uses a non-blocking compact hint, and existing buttons remain reachable.

- [ ] **Step 5: Commit**

```powershell
git add scripts/ui/main_menu.gd scripts/scenes/preparation_scene.gd scripts/scenes/market_scene.gd scripts/scenes/result_scene.gd scripts/ui/database_view.gd tests/test_mvp035_log_companion.gd
git commit -m "feat: add Log guidance across primary screens"
```

### Task 6: Version, documentation, and Base promotion

**Files:**
- Modify: `scripts/ui/main_menu.gd`
- Modify: `README.md`
- Modify: `MVP_ROADMAP.md`
- Modify: `TEST_CHECKLIST.md`
- Modify: `docs/BASE_RULES_VERSION.md`
- Modify: `C:/Users/user/Documents/GitHub/Base/docs/AI_SHARED_WORK_RULES.md`
- Modify: `C:/Users/user/Documents/GitHub/Base/docs/MVP_WORKFLOW_CHECKLIST.md`
- Modify: `C:/Users/user/Documents/GitHub/Base/docs/CHANGELOG.md`

**Interfaces:**
- Produces: `Ver 3.5 / MVP-035 / mvp-035` documentation and Base before/after record

- [ ] **Step 1: Update project versions and player checks**

Document the Log AI role, three expressions, connection signature, first-only tutorial state, scene coverage and save migration.

- [ ] **Step 2: Clone or update common Base**

```powershell
git -C C:\Users\user\Documents\GitHub\Base pull --ff-only
```

If it exists, run `git pull --ff-only`. Read its `AGENTS.md` and documentation map before editing.

- [ ] **Step 3: Apply only common principles**

Add these generic rules without project names, dialogue, sound pitches or asset details:

```text
Diegetic tutorial characters must have an in-world role matching their system responsibility.
Separate first detailed guidance from repeat compact guidance and persist acknowledgement state.
Pair audio cues with equivalent visual or textual cues.
Guides must not reveal information the player has not earned.
```

- [ ] **Step 4: Commit Base separately**

```powershell
git add docs/AI_SHARED_WORK_RULES.md docs/MVP_WORKFLOW_CHECKLIST.md docs/CHANGELOG.md
git commit -m "docs: add diegetic tutorial guide principles"
```

### Task 7: Full verification, review, integration, and push

**Files:**
- Modify only if verification reveals an in-scope defect

- [ ] **Step 1: Run all automated checks**

```powershell
git diff --check
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --quit
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --scene res://tests/test_agent_system.tscn
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --scene res://tests/test_mvp033_unified_recovery.tscn
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --scene res://tests/test_mvp034_faction_market.tscn
& 'C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path . --scene res://tests/test_mvp035_log_companion.tscn
```

Expected: parse exit `0`, prior counts `15/36/52`, MVP-035 `0 failed`.

- [ ] **Step 2: Run scene smoke tests**

Run main, preparation, market, investigation, battle, result and database scenes with `--quit-after 2`. Expected: every command exits `0` without script errors.

- [ ] **Step 3: Perform visual and audio QA**

Capture 1280×720 and 1920×1080. Verify all three expressions, first intro versus repeat hint, scene visibility, button reachability, warning color, and muted-audio equivalence. Listen once to normal/focus/warning signatures and confirm they share a motif without repetitive playback.

- [ ] **Step 4: Review actual diff**

Compare against the approved design, benchmark packet, protected paths, save migration and information-leak rules. Fix all Critical/Important review findings and rerun checks.

- [ ] **Step 5: Commit project and fast-forward main**

```powershell
git add docs/benchmarks/MVP-035_LOG_AI_COMPANION.md docs/BENCHMARKING_REFERENCE_GUIDE.md assets/log scripts/core/game_state.gd scripts/ui/log_tutorial_catalog.gd scripts/ui/log_guide.gd scripts/ui/ui_asset_catalog.gd scripts/ui/main_menu.gd scripts/ui/database_view.gd scripts/scenes/preparation_scene.gd scripts/scenes/market_scene.gd scripts/scenes/investigation_scene.gd scripts/scenes/battle_scene.gd scripts/scenes/result_scene.gd data/episodes/episode_001_afterlife_station.json data/episodes/episode_002_red_umbrella_alley.json tests/test_mvp035_log_companion.gd tests/test_mvp035_log_companion.tscn README.md MVP_ROADMAP.md TEST_CHECKLIST.md docs/BASE_RULES_VERSION.md
git commit -m "feat: add Ver 3.5 Log AI companion"
git -C C:\Users\user\Documents\GitHub\urban-legend merge --ff-only codex/mvp-035-log-ai
```

- [ ] **Step 6: Push both repositories**

```powershell
git -C C:\Users\user\Documents\GitHub\urban-legend push origin main
git -C C:\Users\user\Documents\GitHub\Base push origin main
```

Expected: both remotes advance to the verified local commits.
