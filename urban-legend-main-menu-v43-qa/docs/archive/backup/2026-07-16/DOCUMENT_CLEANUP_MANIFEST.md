# 2026-07-16 문서 정리 매니페스트

> 문서 위치: `docs/archive/backup/2026-07-16/DOCUMENT_CLEANUP_MANIFEST.md` | 현행 보존 규칙: `docs/DOCUMENT_LIFECYCLE.md`

## 목적

현재 상태와 다음 구현에 필요한 문서만 기본 읽기에 남기고, 오래된 상태·완료 이력·저사용 규칙을 백업으로 분리했다. 기존 경로가 외부 링크에 사용될 가능성이 있는 문서는 삭제하지 않고 짧은 리디렉션으로 전환했다.

## 변경 내역

| 원래 경로 | 처리 | 현행 역할 | 백업·대체 위치 |
|---|---|---|---|
| `README.md` | 최신 상태로 축약·갱신 | 실행·소개·핵심 상태 요약 | 과거 상태: `PROJECT_STATUS_AND_ROADMAP_BACKUP.md` |
| `MVP_ROADMAP.md` | 완료 이력 제거·MVP-044~046 계획 갱신 | 현재 구현 순서 | 과거 완료선: `PROJECT_STATUS_AND_ROADMAP_BACKUP.md` |
| `docs/PROJECT_CONTEXT.md` | v0.9 미반영 문구 제거·공식 기준 갱신 | 용어·세계관·표현·호환성 | 과거 방향: `CONTENT_DIRECTION_V09_BACKUP.md` |
| `TEST_CHECKLIST.md` | 완료 체크 제거·현재 회귀 계약으로 축약 | 활성 검증 체크리스트 | 완료 QA: `COMPLETED_QA_RULES_HANDOFF_BACKUP.md`, `docs/qa/` |
| `AGENTS.md` | 기본 읽기 순서 축소 | 저장소 작업 불변 규칙 | 과거 규칙: Git history·백업 인덱스 |
| `docs/DOCUMENTATION_MAP.md` | 현행 원본·조건부 라우팅 재정의 | 최소 문서 라우터 | 보존 정책: `docs/DOCUMENT_LIFECYCLE.md` |
| `docs/MVP_WORKFLOW_CHECKLIST.md` | 과거 멀티모델·MVP-038 반복 항목 제거 | 현재 MVP 시작·종료 절차 | 정리 전 원문: 기준 커밋의 Git history |
| `docs/BASE_RULES_VERSION.md` | 과거 승격 후보 제거·현재 동기화 정보만 유지 | Base 동기화 전용 | `COMPLETED_QA_RULES_HANDOFF_BACKUP.md` |
| `docs/CURRENT_HANDOFF.md` | MVP-043 이후 상태로 갱신 | 현재 계정 인수 | `COMPLETED_QA_RULES_HANDOFF_BACKUP.md` |
| `DESIGN_INTENT.md` | 리디렉션으로 전환 | 기존 링크 보존 | 현행 GDD / 과거 상태 백업 |
| `PROJECT_BRIEF.md` | 리디렉션으로 전환 | 기존 링크 보존 | 현행 CURRENT_STATUS / 과거 상태 백업 |
| `docs/CONTENT_DIRECTION_V09.md` | 리디렉션으로 전환 | 기존 링크 보존 | `CONTENT_DIRECTION_V09_BACKUP.md` |
| `docs/archive/README.md` | 2026-07-16 백업 인덱스 추가 | 과거 자료 검색 입구 | 날짜별 backup 폴더 |

## 신규 현행 파일

| 파일 | 역할 |
|---|---|
| `docs/CURRENT_STATUS.md` | 구현 완료와 승인 계획을 구분하는 단일 상태 원본 |
| `docs/DOCUMENT_LIFECYCLE.md` | 현행 1원본·리디렉션·날짜별 백업 규칙 |

## 기본 읽기에서 제외한 범위

- 완료된 `docs/CODEX_GOAL_*`
- 완료된 `docs/qa/*`
- `docs/benchmarks/*`
- `docs/superpowers/*`
- `docs/archive/*`
- 리디렉션 문서 3종
- Base 동기화 작업이 아닌 경우 `docs/BASE_RULES_VERSION.md`

이 파일들은 삭제한 것이 아니다. 현재 작업 조건이 실제로 요구할 때만 `docs/archive/README.md` 또는 `docs/DOCUMENTATION_MAP.md`를 통해 선택한다.

## 정리 전 원문 기준

정리 전 기준 커밋은 다음과 같다.

```text
130466e66d3115876a85ba06f47b7661fae3f304
```

정확한 원문이 필요하면 `git show <commit>:<path>`를 사용한다.
