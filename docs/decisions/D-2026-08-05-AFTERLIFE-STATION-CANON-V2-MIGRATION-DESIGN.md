# D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN

- 제목: 저승역 Canon v2 콘텐츠·ID·저장 이관 아키텍처
- 상태: `APPROVED_SPEC / IMPLEMENTATION_PLAN_READY / IMPLEMENTATION_NOT_AUTHORIZED`
- 설계 방향 승인: `2026-08-05 00:04 KST`
- 문서 승인: `2026-08-05 00:28 KST`
- 기준 main: `55721e905bf24fc3deb0de061a529ecb992aee80`
- Draft PR: `#145`
- Human QA: `NOT_RUN`
- Runtime implementation: `NOT_RUN`

## 승인 전이

사용자가 작성된 Design Spec과 ID Migration Matrix를 검토하고 `문서승인`했다.

기존 Spec 머리말의 `REVIEW_READY / DESIGN_ONLY`는 문서 승인 전 역사 상태다. 현재 권위 상태는 이 Decision의 다음 값이 우선한다.

```text
APPROVED_SPEC
/ IMPLEMENTATION_PLAN_READY
/ IMPLEMENTATION_NOT_AUTHORIZED
```

문서 승인은 implementation plan 작성을 허가하지만 게임 코드·Scene·JSON·저장 Schema 변경을 허가하지 않는다. 실제 구현은 별도 구현 승인, PR 통합은 별도 병합 승인을 요구한다.

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
- 예정 sidecar: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- 활성화는 manifest·명시적 loader 요청으로만 수행
- 구형 `recovery_patterns`와 Canon v2 패턴 혼합 금지

### ID 이관

구형 ID는 다음 분류 중 하나를 가져야 한다.

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
- 원본 파일 bytes를 먼저 backup
- 실패 시 파일과 메모리 모두 롤백
- Legacy 저장 fallback 금지
- 동일 migration 재적용 시 중복 효과 금지

진행 중 구형 구출·회수 전투는 직접 의미 변환하지 않고 `LEGACY_CASE_RESTART_REQUIRED`로 안전 조사 checkpoint에서 무페널티 재시작한다.

## 현업 비교 반영

구현 계획에는 다음 비교 결론을 반영한다.

- Godot: 프로젝트별 저장과 단계적 복원
- Unreal Engine: 책임별 SaveGame·slot 분리
- Unity Cloud Save: write lock과 충돌 감지
- Flyway: versioned migration·checksum·history·apply-once

프로젝트 채택안은 기존 `effect_id / backup-first`에 `source_checksum`, `migration_history`, `atomic replace` 검증을 추가하는 것이다.

## 책임 문서

- Design Spec: `docs/superpowers/specs/2026-08-05-afterlife-station-canon-v2-migration-design.md`
- ID Matrix: `docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md`
- Implementation Plan: `docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-implementation-plan.md`
- 운영 정책: `docs/decisions/D-2026-08-05-WORKFLOW-BENCHMARK-TDD-AND-CHECKPOINT-POLICY.md`

## TDD Gate

구현 계획 작성 자체도 문서 계약 테스트를 먼저 작성하고 RED를 확인한 뒤 GREEN으로 전환한다. 실제 제품 구현의 각 Task 역시 독립 RED·최소 구현·GREEN·focused·회귀·커밋으로 닫는다.

## 다음 Gate

1. 구현 계획 문서 작성과 적대적 검토
2. 사용자 구현 계획 검토
3. 별도 구현 승인
4. 승인 후 Codex TDD 구현
5. 구현 결과 승인
6. 별도 병합 승인

별도 구현 승인 전에는 제품 코드·JSON·Schema를 변경하지 않는다. 별도 병합 승인 전에는 Draft 해제·auto-merge·merge를 수행하지 않는다.

## 변경 금지 범위

- 게임 코드
- Scene
- Episode·PoC·Core Validation JSON
- 실제 저장 Schema
- 이미지·게임 자산
- Human QA 상태
- PR 병합
