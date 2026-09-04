# Base Rules Version

```yaml
base: alsdmlals4-eng/Base
base_version: 9.4.3
base_payload_commit: 7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8
base_trusted_evidence_commit: da33a350d61b8adc52df97fccc7001708a933370
base_pin_finalization_commit: 0b7c94f38d959efc0fc9442274c60b2e268a3c97
legacy_core_skill_index_commit: c987647d01ad2baa028a16e03d85ddfc1572a727
base_registry_sha256: 693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59
release_state: BASE_RELEASED
project: alsdmlals4-eng/urban-legend
adoption_scope: OPERATING_CONTRACT_ONLY
product_paths_changed: false
reviewed_base_main_policy_commit: 4f98f968a377f7b6a11aafa4fc94d11bddbebedc
reviewed_base_main_policy_state: POLICY_EVIDENCE_NOT_RELEASE_IDENTITY
```

`skills/PROJECT_BASE_ADAPTER.json`이 Base route와 프로젝트 분야 Skill 10개를 결합한다. 현재 프로젝트 릴리스 정체성은 Base v9.4.3이며, Base `main`의 `4f98f968a377f7b6a11aafa4fc94d11bddbebedc`는 선택적 Godot 애드온의 실제 소비 경로·검증·제거 절차를 요구하는 최신 검토 정책 증거다. 이 정책 commit을 별도 Base 릴리스로 오인하지 않는다.

## 프로젝트 보호 경계

- 괴이 기록국의 조사→기록→가설→검증→안정화·잔향 회수 루프를 변경하지 않는다.
- 새 괴이·분기·단서·플래그·대사·설정·호감도·미니게임 결과를 발명하지 않는다.
- `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot`, 특히 `data/episodes/*`와 `scripts/core/game_state.gd`는 보호 경로다.
- 보호 경로 변경은 승인 Decision, 별도 PR, test-first 증거, exact-HEAD 검증, rollback을 요구한다.
- HiGodot은 Scene·Node·Resource·Project Settings의 단일 저작 권위이고 GUT은 테스트 실행·assertion·JUnit의 검증 권위다.
- GUT 실행은 제품 정본을 수정할 수 없으며 실행 전후 보호 경로 diff가 생기면 실패한다.
- 복선·반대 근거·위험 사례·실패 경로·기존 ID·저장 호환성을 보존한다.
- Sheet는 `SHEET_GITHUB_CONFLICT / NO_AUTOMATIC_OVERWRITE`를 유지하되, 승인된 Decision과 검증 상태는 같은 ID와 exact HEAD로 동기화한다.
- 로컬 Windows·Android·사람 검증은 실제 증거가 없으면 `NOT_RUN` 또는 `HUMAN_NOT_RUN`이다.
