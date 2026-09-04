# 2026-07-16 문서 백업 인덱스

> 문서 위치: `docs/archive/backup/2026-07-16/README.md` | 현행 문서 라우터: `docs/DOCUMENTATION_MAP.md`

이 폴더는 2026-07-16 문서 정리에서 기본 읽기 대상에서 제외한 과거 상태·완료 기록·중복 설명을 보존한다. 현재 작업자는 이 폴더를 자동으로 읽지 않으며, 과거 판단 근거가 필요한 경우에만 아래 파일을 선택한다.

| 백업 파일 | 보존 내용 | 현행 대체 문서 |
|---|---|---|
| `PROJECT_STATUS_AND_ROADMAP_BACKUP.md` | 정리 전 README·로드맵·프로젝트 브리프·디자인 의도·프로젝트 컨텍스트의 구상과 오래된 다음 작업 | `docs/CURRENT_STATUS.md`, `MVP_ROADMAP.md`, `docs/PROJECT_CONTEXT.md` |
| `CONTENT_DIRECTION_V09_BACKUP.md` | v0.9 승인 설계의 핵심 내용과 통합 상태 | `docs/GAME_DESIGN_DOCUMENT.md`, `docs/PROJECT_CONTEXT.md` |
| `COMPLETED_QA_RULES_HANDOFF_BACKUP.md` | 완료된 MVP-040~043 QA, 과거 Base 승격 후보, 이전 Codex handoff | `TEST_CHECKLIST.md`, `docs/BASE_RULES_VERSION.md`, `docs/CURRENT_HANDOFF.md` |
| `DOCUMENT_CLEANUP_MANIFEST.md` | 변경·축약·리디렉션된 문서와 백업 위치 | `docs/DOCUMENT_LIFECYCLE.md` |

정리 전 전체 파일이 그대로 필요하면 다음 기준 커밋에서 확인한다.

```bash
git show 130466e66d3115876a85ba06f47b7661fae3f304:<원래_경로>
```

이 백업은 구현 기준이 아니다. 현재 사실은 `docs/CURRENT_STATUS.md`, 상세 설계는 `docs/GAME_DESIGN_DOCUMENT.md`, 검증 항목은 `TEST_CHECKLIST.md`를 우선한다.
