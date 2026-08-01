# Base Rules Version

이 문서는 urban-legend가 현재 사용하는 Base 운영선과 적용 경계의 단일 사람용 원본이다.

## 1. 현재 운영 기준

| 항목 | 현재 값 |
|---|---|
| Base 저장소 | `alsdmlals4-eng/Base` |
| 현재 프로젝트 운영 Adapter | Base v9.1 |
| release commit | `3c158f52cfdad889970aef4d6ce6650a6fea0645` |
| evidence commit | `dd20ad3852e264d7e337e34d2cb963f71053a6cb` |
| canonical project adapter | `skills/PROJECT_BASE_ADAPTER.json` |
| Base route | 27개 |
| 프로젝트 분야 route | 10개 |
| 프로젝트 로컬 전문 Skill | `urban-legend-investigation-case-authoring` 1개 |
| 프로젝트 Sheet | `PROJECT_SHEET_CONFIGURED / SYNCED_PENDING_MAIN` |
| 확인일 | 2026-08-01 |
| 현재 상태 | `BASE_V9_1_KEEP_CURRENT / BASE_V9_3_DRAFT_HOLD` |

현재 Base 버전 권위는 `skills/PROJECT_BASE_ADAPTER.json`의 v9.1 release다.

## 2. Legacy BCA 입력

다음은 2026-07-29 BCA v8 도입 당시의 고정 입력이며 현재 Base release 권위를 대체하지 않는다.

- core Registry commit: `c987647d01ad2baa028a16e03d85ddfc1572a727`
- Registry blob: `0f749dca51423ff3ea3e6db6a712a2b5bee800a8`
- 당시 core 활성 Skill: 25개
- Prompt: `templates/prompts/VERTICAL_SLICE_INTEGRATED_EXECUTION_PROMPT_v8.md`

해당 값은 다음 경로의 호환·생성 입력에 남아 있다.

- `skills/SKILL_REGISTRY.json`
- `skills/BASE_SKILL_INDEX.json`
- `skills/BASE_SKILL_COVERAGE.json`
- `skills/PROJECT_PATH_ADAPTER.json`

판정:

```text
role: LEGACY_COMPATIBILITY_INPUT
current_base_release_authority: NO
manual_delete_or_rewrite: PROHIBITED
future_resolution: Base v9.3 migration re-generation
```

## 3. 현재 적용 구조

```text
skills/PROJECT_BASE_ADAPTER.json — Base v9.1 운영 권위
→ 27개 Base route 선택
→ 10개 프로젝트 분야 route 보존
→ 필요 시 프로젝트 로컬 전문 Skill 1개 선택
→ CURRENT_CONFIRMED_DECISIONS
→ VALIDATION_TARGET_CANON
→ 현재 구현·실제 파일
→ 검증·실행 보고
```

- 공용 Skill 본문 전체를 프로젝트에 복제하지 않는다.
- 프로젝트 고유 세계관·수치·저장·경로·실제 구현은 urban-legend가 소유한다.
- 현재 승인 Decision과 Validation Target은 Base보다 높은 프로젝트 기획 권위다.

## 4. Base v9.3 상태

Base 원격 최신 확인:

| 항목 | 값 |
|---|---|
| version | 9.3.0 |
| release candidate commit | `30ca6c7b5f93521f0eb0eed42d01437cd43c50ae` |
| evidence commit | `462a86db192d23d0f386281a1eb54b0a8cbad62e` |
| 활성 Skill | 27개 |
| 프로젝트 이관 PR | #120 |
| 상태 | `DRAFT_HOLD` |

승인된 순서:

```text
Validation Canon Pass
→ reference·상태·Sheet 검증
→ PR #120을 최신 main 기준으로 재평가
→ 필요 시 재작성·generator·validator·전체 회귀
→ 별도 승인 뒤 이관
```

금지:

- Canon Pass 전 PR #120 병합
- 구형 branch cherry-pick
- 새 중복 Base migration PR 생성
- generated adapter 수동 편집

연결 Decision:

- `D-2026-08-01-LEGACY-PR-DISPOSITION`
- `D-2026-08-01-RECOMMENDED-BATCH-APPROVAL`
- `D-2026-08-01-VALIDATION-PLANNING-FINAL-APPROVAL`

## 5. Sheet 상태 경계

현재 Google GDD Sheet는 승인 Decision·관련 기획·이미지·테스트·변경이력까지 동기화됐다.

`skills/PROJECT_BASE_ADAPTER.json`에 남은 과거:

```text
gdd_sheet.declared_sync_status = SHEET_GITHUB_CONFLICT
gdd_sheet.sync_status = BLOCKED
```

판정:

- 실제 현재 Sheet 상태가 아님
- Base v9.1 생성 당시의 stale generated field
- generated artifact이므로 이번 기획 Canon Pass에서 수동 수정하지 않음
- Base v9.3 재평가 시 generator로 재생성·검증

현재 실제 Sheet 상태는 다음이 소유한다.

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- Google Sheet `00_프로젝트_허브`
- `02_현재_확정결정`
- `99_변경이력`

## 6. Archive governance

현재 채택:

- `governing-legacy-retention-and-archives`
- `skills/BASE_SHARED_SKILL_ROUTES.json`
- `skills/PROJECT_BASE_SKILL_ADAPTER.json`
- `docs/archive/ARCHIVE_RETENTION_ADAPTER.json`
- `docs/archive/MANIFEST.json`

경계:

- 기존 backup/history/reports 이동·삭제: `NOT_IN_THIS_ADOPTION`
- branch/tag 삭제: `NOT_RUN`
- 공용 SKILL.md 로컬 복제: 금지
- 현재 승인 Target과 Legacy 구현은 삭제가 아니라 권위 분리

## 7. urban-legend 적용 경계

### Base 소유

- Work Mode·Skill 라우팅 원리
- 승인 Decision 동기화 절차
- 적대적 검토 루프
- 운영체계 감사·보존·검증 방법
- 프로젝트 Sheet 역할 계약

### 프로젝트 소유

- 현재 승인 Decision: `CURRENT_CONFIRMED_DECISIONS.md`
- Validation 상세 Target: `VALIDATION_TARGET_CANON.md`
- 세계관·캐릭터·사건 규칙
- 실제 Godot Scene·Script·Resource·JSON
- Save Schema·ID·호환성
- 실제 QA·캡처·사람 플레이 결과

## 8. 현재 문서 라우팅

```text
START_HERE
→ AGENTS
→ OPERATING_MODEL
→ WORK_MODE_AND_SKILL_ROUTING
→ CURRENT_CONFIRMED_DECISIONS
→ VALIDATION_TARGET_CANON
→ CURRENT_STATUS
→ PROJECT_CORE
→ DOCUMENTATION_MAP_CURRENT
→ Skill Registry·Adapter
→ 실제 파일
```

Legacy `DOCUMENTATION_MAP.md`와 BCA v8 입력은 호환 자료로 보존한다.

## 9. 검증

Base·운영체계 변경 시:

```text
python tools/check_archive_governance.py
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py tests/test_archive_retention_governance.py
```

Base v9.3 이관 시 추가:

- generator·adapter schema·semantic validation
- generated view byte equality
- 27 Base route·10 project route·local Skill 보존
- protected path diff 0
- Documentation·BCA·전체 Python 회귀
- 필요 범위의 Godot import·focused·full regression

실행하지 않은 Runtime·기기·사람 검증은 `NOT_RUN`으로 기록한다.

## 10. 현재 판정

```yaml
current_base_adapter: V9_1
legacy_bca_input: PRESERVED
base_v9_3: DRAFT_HOLD
sheet_actual: SYNCED_PENDING_MAIN
adapter_sheet_field: STALE_GENERATED_FIELD
product_runtime_change: NONE
next_base_gate: AFTER_CANON_PASS_VERIFICATION
```
