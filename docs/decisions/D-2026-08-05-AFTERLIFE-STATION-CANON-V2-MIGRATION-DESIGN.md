# D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN

- 제목: 저승역 Canon v2 콘텐츠·ID·저장 이관 아키텍처
- 상태: `APPROVED_SPEC / IMPLEMENTATION_AUTHORIZED / IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN / HUMAN_QA_NOT_RUN / MERGE_NOT_AUTHORIZED`
- 설계 방향 승인: `2026-08-05 00:04 KST`
- 문서 승인: `2026-08-05 00:28 KST`
- 구현 승인: `2026-08-05 KST / 사용자 명시 승인`
- 기준 main: `55721e905bf24fc3deb0de061a529ecb992aee80`
- Design·Plan Draft PR: `#145`
- Draft PR: `#146`
- 검증된 제품 구현 HEAD: `1e2473889b68b4a714300133da180f1eb1a08414`
- Human QA: `HUMAN_QA_NOT_RUN`
- Runtime implementation: `IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN`
- Merge: `MERGE_NOT_AUTHORIZED`

## 승인 전이

사용자는 Design Spec·ID Migration Matrix에 `문서승인`을 부여한 뒤, 9개 Task 구현 계획과 적대적 Addendum에도 별도 `승인`을 부여했다.

이전 상태는 다음과 같이 역사화한다.

```text
REVIEW_READY / DESIGN_ONLY
→ APPROVED_SPEC / IMPLEMENTATION_PLAN_READY / IMPLEMENTATION_NOT_AUTHORIZED
→ IMPLEMENTATION_AUTHORIZED
→ IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN
```

현재 권위 상태는 다음과 같다.

```text
APPROVED_SPEC
/ IMPLEMENTATION_AUTHORIZED
/ IMPLEMENTATION_COMPLETE
/ AUTOMATED_QA_GREEN
/ HUMAN_QA_NOT_RUN
/ MERGE_NOT_AUTHORIZED
```

구현 승인은 제품 코드·JSON·저장 이관 작업을 TDD로 수행하도록 허가했다. 자동 검증 통과는 Human QA나 PR 병합 승인으로 해석하지 않는다.

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
- 운영 정책: `docs/decisions/D-2026-08-05-WORKFLOW-BENCHMARK-TDD-AND-CHECKPOINT-POLICY.md`

검증된 제품 구현 HEAD `1e2473889b68b4a714300133da180f1eb1a08414`:

- Canon v2 Migration `30973078497`: SUCCESS
- CORE-MVP-001 `30973078429`: SUCCESS
- ANNUAL-MVP-001 `30973078408`: SUCCESS
- Canon v2 focused `8/8`: PASS
- full Godot regression: PASS

## TDD Gate

Task 1~9는 각각 RED → 최소 구현 → GREEN → focused 검증 → 전체 회귀 순서로 진행했다. 고위험 런타임 호환 충돌도 먼저 실패 계약을 추가한 뒤 Canon v2 전용 projection으로 GREEN 전환했다.

## 다음 Gate

1. 구현 결과 적대적 PR 검토
2. Google Sheet exact HEAD 동기화
3. 사용자 구현 결과 검토
4. Human QA 별도 승인·실행
5. PR #145·#146 통합 순서 확정
6. 별도 merge approval

`AUTOMATED_QA_GREEN`은 출시·Human QA·병합 완료를 의미하지 않는다. 별도 병합 승인 전 Draft 해제·auto-merge·merge를 수행하지 않는다.

## 변경하지 않은 범위

- Scene 구조
- 이미지·게임 자산
- 기존 Episode·PoC·Core Validation 파일 삭제
- Human QA 판정
- PR 병합
