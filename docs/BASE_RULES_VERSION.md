# Base Rules Version

```yaml
base: alsdmlals4-eng/Base
base_version: 9.4.4
base_payload_commit: 210ec78292fa12ed7563ba743b322dd36103ae4a
base_trusted_evidence_commit: bb61e68dc3028421b60c11b87ba2abd297ee6f78
base_pin_finalization_commit: 5adc196c0185951f50e49ab5e51586eff8d60886
legacy_core_skill_index_commit: bb61e68dc3028421b60c11b87ba2abd297ee6f78
base_registry_sha256: 08f882d0c77339e8f7ff187c35b79501e0a2958ab1ff1c7aaa1c0ef8dbee45d6
release_state: BASE_RELEASED
project: alsdmlals4-eng/urban-legend
adoption_scope: OPERATING_CONTRACT_ONLY
product_paths_changed: false
reviewed_base_main_policy_commit: 19355b7ef065a21d0f2b685c7d9be64a4a3970f8
reviewed_base_main_policy_state: POLICY_EVIDENCE_NOT_RELEASE_IDENTITY
```

`skills/PROJECT_BASE_ADAPTER.json`이 Base route와 프로젝트 분야 Skill 10개를 결합한다. 현재 프로젝트 릴리스 정체성은 Base v9.4.4이며, Base `main`의 `19355b7ef065a21d0f2b685c7d9be64a4a3970f8`는 작업 영수증 validator와 운영 artifact generator를 제공하는 최신 정책 증거다. 이 정책 commit을 별도 Base 릴리스로 오인하지 않는다.

## 프로젝트 보호 경계

- 괴이 기록국의 조사→기록→가설→검증→안정화·잔향 회수 루프를 변경하지 않는다.
- 새 괴이·분기·단서·플래그·대사·설정·호감도·미니게임 결과를 발명하지 않는다.
- `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot`, 특히 `data/episodes/*`와 `scripts/core/game_state.gd`는 보호 경로다.
- 보호 경로 변경은 승인 Decision, 별도 PR, test-first 증거, exact-HEAD 검증, rollback을 요구한다.
- HiGodot은 Scene·Node·Resource·Project Settings의 단일 저작 권위이고 GUT은 테스트 실행·assertion·JUnit의 검증 권위다.
- GUT 실행은 제품 정본을 수정할 수 없으며 실행 전후 보호 경로 diff가 생기면 실패한다.
- 복선·반대 근거·위험 사례·실패 경로·기존 ID·저장 호환성을 보존한다.
- 프로젝트 workspace는 Repository의 사람용·구조화 정본 + 구현·테스트·evidence 정본으로 운영한다. Notion과 과거 Sheet는 `HISTORICAL_READ_ONLY_NO_WRITE` / migration-only로 보존하고 새 작업에 사용하지 않는다.
- 로컬 Windows·Android·사람 검증은 실제 증거가 없으면 `NOT_RUN` 또는 `HUMAN_NOT_RUN`이다.
