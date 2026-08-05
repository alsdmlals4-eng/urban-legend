# D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN

- 제목: 저승역 Canon v2 콘텐츠·ID·저장 이관 아키텍처
- 상태: `APPROVED_SPEC / IMPLEMENTATION_AUTHORIZED / IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN / AUTOMATED_FIXTURE_PREFLIGHT_GREEN / HUMAN_QA_NOT_RUN / MERGE_NOT_AUTHORIZED`
- 설계 방향 승인: `2026-08-05 00:04 KST`
- 문서 승인: `2026-08-05 00:28 KST`
- 구현 승인: `2026-08-05 KST / 사용자 명시 승인`
- Human QA 계획 진행 승인: `2026-08-05 13:01 KST / 사용자 진행 지시`
- 기준 main: `55721e905bf24fc3deb0de061a529ecb992aee80`
- Design·Plan Draft PR: `#145`
- Implementation Draft PR: `#146`
- Human QA Fixture Draft PR: `#147`
- 검증된 구현 HEAD: `e8d48024de0c335d5856dbaf9b2a0ac892d1a3b4`
- 검증된 fixture preflight HEAD: `f422b61eac9bb1f97da01ab4900fd5714431c0f1`
- Human QA: `HUMAN_QA_NOT_RUN`
- Runtime implementation: `IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN`
- Fixture preflight: `AUTOMATED_FIXTURE_PREFLIGHT_GREEN`
- Merge: `MERGE_NOT_AUTHORIZED`

## 승인 전이

사용자는 Design Spec·ID Migration Matrix에 `문서승인`을 부여한 뒤, 9개 Task 구현 계획과 적대적 Addendum에도 별도 `승인`을 부여했다. 구현 완료 보고 후에는 Human QA 계획과 대표 저장 fixture 사전검증 진행을 지시했다.

이전 상태는 다음과 같이 역사화한다.

```text
REVIEW_READY / DESIGN_ONLY
→ APPROVED_SPEC / IMPLEMENTATION_PLAN_READY / IMPLEMENTATION_NOT_AUTHORIZED
→ IMPLEMENTATION_AUTHORIZED
→ IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN
→ AUTOMATED_FIXTURE_PREFLIGHT_GREEN / HUMAN_QA_NOT_RUN
```

현재 권위 상태는 다음과 같다.

```text
APPROVED_SPEC
/ IMPLEMENTATION_AUTHORIZED
/ IMPLEMENTATION_COMPLETE
/ AUTOMATED_QA_GREEN
/ AUTOMATED_FIXTURE_PREFLIGHT_GREEN
/ HUMAN_QA_NOT_RUN
/ MERGE_NOT_AUTHORIZED
```

구현 승인은 제품 코드·JSON·저장 이관 작업을 TDD로 수행하도록 허가했다. 자동 검증과 대표 fixture 통과는 실제 사용자 저장, Windows 파일 I/O, UI·접근성 Human QA나 PR 병합 승인으로 해석하지 않는다.

## 결정

저승역 Batch 4 정본을 구현으로 이관할 때 기존 사건을 즉시 덮어쓰거나 새 사건 ID로 복제하지 않는다.

```text
동일 episode·victim stable ID 유지
+ afterlife-station-canon-v2 sidecar
+ 명시적 layer allowlist
+ ID Migration Registry
+ mvp-040 / validation-save-v2
+ backup-first·fail-closed transaction
= 구형 저장·회귀와 새 정본 동시 보호
```

### 유지하는 정체성

- Episode ID: `episode_001_afterlife_station`
- victim stable ID: `victim_afterlife_station_001`
- victim 표시 정본: `이하린`

새 사건 ID를 만들지 않는다.

### 새 콘텐츠 계약

- `content_contract_id: afterlife-station-canon-v2`
- `content_schema: 2`
- 권위 sidecar: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- 활성화는 명시적 loader 요청으로만 수행
- 권위 Canon v2 구조: `investigation_manual`, `rescue_protocol`, `recovery_encounters`, `result_contract`
- 기존 전투 UI용 `clues`·`recovery_patterns`는 Canon v2 ID에서만 생성한 `canonical_v2_projection`
- projected IDs: `record_afterlife_*`, `pattern_afterlife_*`, `response_afterlife_*`
- 구형 `pattern_station_*`·`clue_*` 실행 혼합 금지
- 구형 Core Validation 내용은 `legacy_content_snapshot`에만 보존

### ID 이관

구형 ID는 다음 분류 중 하나를 가진다.

- `KEEP_ID`
- `ALIAS`
- `SPLIT`
- `MERGE`
- `HISTORICAL_ONLY`
- `DISCARD_SEMANTICS`

미매핑 ID는 `orphan_legacy_ids`에 보존하되 런타임에는 적용하지 않는다. 검은 승차권 접촉·파괴 해법과 `같은 시각` 초기화 의미는 자동 정답으로 변환하지 않는다.

### 저장 이관

- 본편 readable: `mvp-038`, `mvp-039`
- 본편 new write: `mvp-040`
- Validation readable: `validation-save-v1`
- Validation new write: `validation-save-v2`
- 원본 bytes backup-first
- inspect·commit 직전 `source_checksum` 비교
- temp write·readback·validator·backup·promote 분리
- 파일 교체 후 runtime apply가 성공해야 `FINALIZED`
- 실패 시 파일과 메모리 모두 rollback
- Legacy 저장 fallback 금지
- 동일 migration·effect 재적용 시 중복 효과 금지

진행 중 구형 구출·회수 전투는 직접 의미 변환하지 않고 `LEGACY_CASE_RESTART_REQUIRED`로 안전 조사 checkpoint에서 무페널티 재시작한다.

## 현업 비교 반영

- Godot: 프로젝트별 저장과 단계적 복원
- Unreal Engine: 책임별 SaveGame·slot 분리
- Unity Cloud Save: write lock과 충돌 감지
- Flyway: versioned migration·checksum·history·apply-once

프로젝트 채택안은 `effect_id / backup-first / source_checksum / migration_history / two-phase atomic replace`다.

## 구현·검증 증거

- Implementation evidence: `docs/implementation/2026-08-05-afterlife-station-canon-v2-migration-implementation-evidence.md`
- Design Spec: `docs/superpowers/specs/2026-08-05-afterlife-station-canon-v2-migration-design.md`
- ID Matrix: `docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md`
- Implementation Plan: `docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-implementation-plan.md`
- Adversarial Addendum: `docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-plan-adversarial-review-addendum.md`
- Human QA Plan: `docs/qa/2026-08-05-afterlife-canon-v2-human-qa-plan.md`
- Automated fixture evidence: `docs/qa/2026-08-05-afterlife-canon-v2-automated-fixture-preflight-evidence.md`
- Human QA evidence template: `docs/qa/templates/afterlife-canon-v2-human-qa-evidence-template.md`
- 운영 정책: `docs/decisions/D-2026-08-05-WORKFLOW-BENCHMARK-TDD-AND-CHECKPOINT-POLICY.md`

검증된 구현 HEAD `e8d48024de0c335d5856dbaf9b2a0ac892d1a3b4`:

- Documentation `30973449735`: SUCCESS
- Canon v2 Migration `30973449470`: SUCCESS
- CORE-MVP-001 `30973449472`: SUCCESS
- ANNUAL-MVP-001 `30973449460`: SUCCESS
- Canon v2 focused `8/8`: PASS
- full Godot regression: PASS

검증된 fixture preflight HEAD `f422b61eac9bb1f97da01ab4900fd5714431c0f1`:

- Documentation `30974616333`: SUCCESS
- Canon v2 Migration `30974616329`: SUCCESS
- ANNUAL-MVP-001 `30974616351`: SUCCESS
- Canon v2 representative fixture focused `9/9`: PASS
- full Godot regression: PASS

## 대표 fixture 범위

다음 정적 JSON을 실제 파일로 복사해 wrapper load 경로를 검증한다.

- `main_mvp038_investigation.json`
- `main_mvp039_recovery.json`
- `main_mvp039_completed.json`
- `validation_v1_active_recovery.json`

검증 속성은 버전 전환, 정답 비공개, orphan 보존, 안전 재시작, 완료 보고서·보상 불변, 재실행 멱등, Validation 격리다.

이 fixture는 승인된 schema를 기반으로 만든 합성 데이터다. 실제 장기간 사용자 저장의 예상 밖 조합, Windows 파일 잠금, 동기화 프로그램, 강제 종료 타이밍, 실제 권한·디스크 오류를 대체하지 않는다.

## TDD Gate

Task 1~9는 각각 RED → 최소 구현 → GREEN → focused 검증 → 전체 회귀 순서로 진행했다. Human QA 준비도 QA 계획·fixture 부재를 먼저 RED로 확인한 뒤 대표 fixture 4종과 9번째 focused entrypoint를 추가해 GREEN으로 전환했다.

## 다음 Gate

1. 실제 사용자 저장 복사본 확보와 SHA-256 기록
2. Windows 10/11 격리 APPDATA 정상 이관
3. 파일 잠금·강제 종료·디스크 쓰기 실패 Human QA
4. 보상 중복·Validation 격리 확인
5. UI·접근성 Human QA
6. Human QA 결과 승인
7. PR #145·#146·#147 통합 순서 확정
8. 별도 merge approval

`AUTOMATED_QA_GREEN`과 `AUTOMATED_FIXTURE_PREFLIGHT_GREEN`은 출시·Human QA·병합 완료를 의미하지 않는다. 별도 병합 승인 전 Draft 해제·auto-merge·merge를 수행하지 않는다.

## 변경하지 않은 범위

- Scene 구조
- 이미지·게임 자산
- 기존 Episode·PoC·Core Validation 파일 삭제
- 실제 사용자 저장 원본
- Human QA 판정
- PR 병합
