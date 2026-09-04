# Documentation Archive

> 문서 위치: `docs/archive/README.md` | 현행 문서 라우터: `docs/DOCUMENTATION_MAP.md`

이 폴더는 현재 작업의 기본 읽기 대상이 아닌 과거 기록을 보존한다. 과거 근거가 필요한 경우에만 이 인덱스에서 파일 하나를 선택한다. `docs/archive/**`를 일괄 탐색하거나 매 작업마다 읽지 않는다.

## 현재 권한과 보존 계약

- 아카이브 자료는 현재 정본이 아니며 구현 권한이 없다.
- 원문을 비우지 않는다. 경로만 남기고 본문을 삭제하는 방식은 금지한다.
- 새 아카이브 항목은 `MANIFEST.json`에 classification, 원래·현재 경로, SHA-256, 대체 정본, 사유, rollback ref와 검증 상태를 기록한다.
- archive record는 `active_authority: false`, `implementation_authority: NONE`을 사용한다.
- 비밀키·API token·자격증명·private key는 아카이브하지 않는다.
- Base 공용 절차는 `skills/BASE_SHARED_SKILL_ROUTES.json`과 `ARCHIVE_RETENTION_ADAPTER.json`으로 선택하며 SKILL.md 본문을 이 프로젝트에 복제하지 않는다.
- 이번 정책 채택은 기존 백업 자료를 재이동·삭제·재작성하지 않는다.

## 현재 백업 묶음

| 보관일 | 보관 위치 | 내용 | 현행 대체 문서 |
|---|---|---|---|
| 2026-07-16 | `backup/2026-07-16/README.md` | 문서 정리 백업 인덱스 | `docs/DOCUMENTATION_MAP.md` |
| 2026-07-16 | `backup/2026-07-16/PROJECT_STATUS_AND_ROADMAP_BACKUP.md` | 정리 전 README·로드맵·프로젝트 브리프·디자인 의도·컨텍스트의 오래된 상태 | `docs/CURRENT_STATUS.md`, `MVP_ROADMAP.md`, `docs/PROJECT_CONTEXT.md` |
| 2026-07-16 | `backup/2026-07-16/CONTENT_DIRECTION_V09_BACKUP.md` | v0.9 공식 용어·첫 10분·저승역 승인 설계 | `docs/GAME_DESIGN_DOCUMENT.md`, `docs/PROJECT_CONTEXT.md` |
| 2026-07-16 | `backup/2026-07-16/COMPLETED_QA_RULES_HANDOFF_BACKUP.md` | 완료 QA·Base 후보·이전 handoff | `TEST_CHECKLIST.md`, `docs/BASE_RULES_VERSION.md`, `docs/CURRENT_HANDOFF.md` |
| 2026-07-16 | `backup/2026-07-16/DOCUMENT_CLEANUP_MANIFEST.md` | 축약·리디렉션·백업 이동 내역 | `docs/DOCUMENT_LIFECYCLE.md` |

## 기존 보관 기록

| 보관일 | 이전 위치 | 보관 위치 | 이유 | 현행 대체 문서 |
|---|---|---|---|---|
| 2026-07-14 | `README.md`의 전체 MVP 구현 일지 | `history/README_MVP001_038_PRE_GDD.md` | 현재 소개와 역사 기록 분리 | `README.md`, `docs/CURRENT_STATUS.md` |
| 2026-07-14 | `MVP_ROADMAP.md`의 과거 중심 구성 | `history/MVP_ROADMAP_PRE_LIVING_GDD.md` | 현재 로드맵과 과거 계획 분리 | `MVP_ROADMAP.md` |
| 2026-07-14 | `TEST_CHECKLIST.md`의 누적 체크리스트 | `history/TEST_CHECKLIST_PRE_LIVING_GDD.md` | 현재 회귀 검수와 과거 체크 분리 | `TEST_CHECKLIST.md` |
| 2026-07-14 | `docs/MVP_STATUS_AUDIT.md` 본문 | `reports/MVP_STATUS_AUDIT_2026-07-11.md` | MVP-029~030 시점 감사 | `docs/CURRENT_STATUS.md` |
| 2026-07-14 | `docs/PROJECT_COMPACT_AUDIT.md` | `reports/PROJECT_COMPACT_AUDIT_2026-07-11.md` | 완료된 문서 압축 감사 | `docs/DOCUMENTATION_MAP.md` |
| 2026-07-14 | `docs/UI_UX_REDESIGN_R1_REPORT.md` | `reports/UI_UX_REDESIGN_R1_REPORT_2026-07-13.md` | Ver 3.1 구현 증거 | `docs/GAME_DESIGN_DOCUMENT.md` |
| 2026-07-14 | `docs/urban_legend_flow_dashboard.html` | `legacy/urban_legend_flow_dashboard.html` | 비활성 산출물 | `docs/GAME_DESIGN_DOCUMENT.md` |

## 현재 위치에 남아 있는 역사 증거

참조 파손 위험이 큰 완료 Goal·QA·벤치마크는 현재 경로에 남아 있을 수 있지만 기본 읽기 대상이 아니다.

- 완료된 `docs/CODEX_GOAL_*`
- `docs/qa/*`
- `docs/benchmarks/*`
- `docs/superpowers/*`

현재 작업이 해당 결정·검증을 직접 변경할 때만 읽는다. 문서가 자주 검색을 방해하면 다음 정리 주기에 날짜별 `backup/`으로 이동하고 리디렉션 또는 인덱스를 남긴다.

## 전체 과거 버전 찾기

백업 요약보다 정확한 정리 전 원문이 필요하면 기준 커밋을 사용한다.

```bash
git show 130466e66d3115876a85ba06f47b7661fae3f304:<원래_경로>
```

백업 내용과 현재 코드가 충돌하면 현재 `main`의 코드·데이터·테스트와 `docs/CURRENT_STATUS.md`를 우선한다.
