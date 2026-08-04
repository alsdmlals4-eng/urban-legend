# D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN

- 제목: 저승역 Canon v2 콘텐츠·ID·저장 이관 아키텍처
- 상태: `APPROVED_DESIGN_DIRECTION / SPEC_REVIEW_READY / IMPLEMENTATION_NOT_AUTHORIZED`
- 사용자 승인: `2026-08-05 00:04 KST`
- 기준 main: `55721e905bf24fc3deb0de061a529ecb992aee80`
- Draft PR: `#145`
- Human QA: `NOT_RUN`

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

## 책임 문서

- `docs/superpowers/specs/2026-08-05-afterlife-station-canon-v2-migration-design.md`
- `docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md`

## Gate

이번 승인은 설계 방향 승인이다. 작성된 Spec과 Matrix는 `REVIEW_READY`이며 사용자 문서 검토 승인이 별도로 필요하다.

문서 검토 승인 뒤에만 implementation plan을 작성한다. 구현 계획 승인과 Codex 실행 승인은 다시 별도로 받아야 한다.

## 변경 금지 범위

- 게임 코드
- Scene
- Episode·PoC·Core Validation JSON
- 실제 저장 Schema
- 이미지·게임 자산
- Human QA 상태
- PR 병합
