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

`skills/PROJECT_BASE_ADAPTER.json`이 Base route와 프로젝트 분야 Skill 10개를 결합한다. 위 값은 Base v9.4.4의 released identity와 기존 validator 재현 기준이다. 과거 policy commit을 현재 원격 main이라고 부르지 않는다.

## 2026-09-20 선택 적용: Base #883·#885

- 최신 원격 확인: `23ecad5a3084f97c4e5d1e39a9a6d70d1eeb37ef`. #883 경량화와 #885 경험→표현·재미 검증 방법을 사용자 승인으로 선택 적용한다. 릴리스/엔진/저장/자산 잠금은 바꾸지 않는다.
- 적용 기준·exact source·원문 hash는 정본 adapter의 `shared_overrides.managing-game-project-operating-system.selective_policy_adoption`이 소유한다. 사람 실행 계약은 `docs/OPERATING_MODEL.md`, 전문 선택은 `docs/WORK_MODE_AND_SKILL_ROUTING.md`, 재미 검증은 `docs/UX_UI_SYSTEM.md#experience-verification`로 연결한다.
- 최신 main은 매 새 채택/갱신 판단 시 fetch하여 비교한다. 위 SHA는 이번 검토·재현 기준이지 영구적인 “최신”이 아니다. 변경분의 영향·승인을 확인한 뒤 그 범위만 갱신한다.
- 나열하지 않은 Base 스킬은 기존 released package를 유지한다. 선택 정책이 과거 포괄적 스킬 문구보다 해당 승인 범위에서 우선하지만 보안·권한·저장 보호를 완화하지 않는다.
- 생성된 `skills/PROJECT_PATH_ADAPTER.json` 등의 옛 경로는 호환 이력이다. 새 실행의 owner는 정본 adapter `current_authority`다. 생성물/보존된 legacy input은 수동 교정하지 않는다.
- 이번 migration의 보호 기준은 승인된 PR #362 병합을 확인한 프로젝트 main `78c10b86c4ac445a43bfb166088d01df02ed5530`로 재결합한다. 최초 조사 기준 `c82291101bf0a2bb4d821a12bca9f14070ee2886`의 helper 회귀가 정상 교정된 후의 기준이며, 기존 게임 브랜치의 44커밋을 흡수하지 않는다. 보호 경로 목록·정책 hash는 그대로다.
- `MACHINE`의 계약·라우팅 통과는 `RUNTIME / HUMAN / FUN_PASS`가 아니다. 원래 브랜치·다른 PR·설치 플러그인·전역 설정·승인 자산은 보호한다.

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
