# Godot Live-Editor Pilot Adoption

## Status

```yaml
adoption_mode: TEMPORARY_COPY_ONLY
legacy_source_policy: LEGACY_GODOT_AI_SOURCE_PRESERVED
legacy_workspace_policy: LEGACY_DISABLED_IN_DISPOSABLE_COPY_ONLY
mutation_authority_policy: DUAL_MUTATION_AUTHORITY_FORBIDDEN
main_scene_policy: MAIN_SCENE_READ_ONLY
mutation_policy: SCRATCH_SCENE_MUTATION_ONLY
source_integrity: SOURCE_TREE_UNCHANGED
base_pilot_commit: 2b595570bd237174b2b962a1eb54588b5ecc508d
evidence_bundle: SELF_CONTAINED_EVIDENCE_BUNDLE
expected_platform: PC
PRODUCTION_ADAPTER_READY: NOT_READY
```

이 저장소는 Base C0.1 Pilot의 immutable commit `2b595570bd237174b2b962a1eb54588b5ecc508d`를 네 개 채택 파일로만 연결합니다.

## Legacy 공존 경계

원본 저장소의 Godot AI Plugin과 `_mcp_game_helper`는 유지합니다. Base runner는 임시 복사본에서 선언된 Plugin·Autoload만 비활성화하며, 기존 `UrbanLegendState`, `ValidationSession`, `GameState` Autoload는 보존합니다.

`DUAL_MUTATION_AUTHORITY_FORBIDDEN`에 따라 Godot AI와 Base transaction adapter는 Pilot 작업공간에서 동시에 편집 권한을 갖지 않습니다.

## Pilot 실행

Godot 4.7.1로 임시 프로젝트를 Import·Parse한 뒤, 다음 영역을 대표하는 기존 GDScript 12개를 같은 작업공간에서 실행합니다.

- CORE-MVP-001 상태·Scene
- Validation 저장소·Session·GameState Adapter·저장 격리
- ANNUAL-MVP-001 상태·Scene
- MVP-043 회수 루프
- 미니게임 Pipeline
- Runtime UI Editor Scene
- 접근성 설정

프로젝트의 권위 전체 회귀는 기존 `tests/run_godot_regression.sh`와 `Validate ANNUAL-MVP-001` Workflow의 58개 엔트리포인트가 계속 담당합니다. Pilot은 그 권위를 대체하거나 축소하지 않습니다.

실제 메인 Scene `res://scenes/main_menu.tscn`은 `MAIN_SCENE_READ_ONLY`로만 검사합니다. Rename·Editor Undo·Save·물리 SHA-256 검증은 runner 소유 `res://.godot-live-editor-pilot/scratch.tscn`에서만 수행합니다.

원본 Git tracked 바이트는 실행 전후 인벤토리를 비교하며, 변경이 있으면 실패합니다.

## Evidence bundle

Artifact는 다음 세 파일을 포함해야 합니다.

```text
project-pilot-evidence.json
runtime-result.json
scratch.tscn
```

다운로드 후 `runtime-result.json`과 `scratch.tscn`을 독립 재해시해 Evidence JSON의 SHA-256과 대조합니다.

## 플랫폼·제품 보호 경계

`expected_platform: PC`는 Ubuntu desktop headless Pilot의 경계입니다. Android 기기·Export·터치·Safe Area·성능을 검증하지 않습니다.

조사·가설·회수·저장·연도제·UI·데이터·에셋·기획 정본·Decision·Registry·Google Sheet·제품 Scene·Resource·GDScript는 이 채택으로 변경하지 않습니다.

Program B authenticated local STDIO MCP transport와 Program C opt-in runtime debugger는 구현하지 않습니다.

```yaml
android_device: NOT_RUN
android_export: NOT_RUN
physical_input: NOT_RUN
human_editor_usability: HUMAN_NOT_RUN
windows_production_operation: NOT_RUN
PRODUCTION_ADAPTER_READY: NOT_READY
```

## 제거

Rollback은 다음 네 파일의 단일 revert입니다.

```text
.godot-live-editor/project-pilot.json
docs/GODOT_LIVE_EDITOR_ADOPTION.md
tests/test_godot_live_editor_adoption.py
.github/workflows/validate-godot-live-editor-pilot.yml
```
