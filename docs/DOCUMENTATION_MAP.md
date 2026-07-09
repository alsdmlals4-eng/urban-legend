# Documentation Map

이 문서는 저장소의 문서 역할을 `공용 규칙`과 `프로젝트 전용 문서`로 구분한다.

---

## 공용 규칙 문서

| 파일 | 역할 |
|---|---|
| `AGENTS.md` | 최상위 프로젝트 규칙 |
| `docs/AI_WORKFLOW_RULES.md` | ChatGPT 작업 순서, HTML 대시보드, Codex Goal 작성 규칙 |
| `docs/CODEX_SHARED_WORK_RULES.md` | Codex 공통 구현 규칙, Serena 사용 규칙, 보고 형식 |
| `docs/BENCHMARKING_REFERENCE_GUIDE.md` | 벤치마킹 표 형식과 사례 목록 |
| `docs/MVP_WORKFLOW_CHECKLIST.md` | 실제 작업 시작/종료 체크리스트 |
| `docs/DOCUMENTATION_MAP.md` | 문서 역할표와 공용/프로젝트 전용 문서 구분 |

---

## 프로젝트 전용 문서

| 파일 | 역할 |
|---|---|
| `README.md` | 프로젝트 소개, 실행 방법, 현재 MVP 상태 |
| `PROJECT_BRIEF.md` | 프로젝트 한 줄 설명, 장르, 플레이어 역할, 핵심 경험, 차별점 |
| `DESIGN_INTENT.md` | 기획 의도, 핵심 루프, 플레이어 감정, 선택지 설계 원칙 |
| `MVP_ROADMAP.md` | MVP 목록, Issue 번호, 상태, 완료 기준, 다음 작업 |
| `TEST_CHECKLIST.md` | Godot 테스트 순서, MVP별 체크리스트, 오류 기록 방식 |
| `.serena/project.yml` | 현재 프로젝트의 Serena 설정 |
| `data/` | 에피소드, 요원, 장비, 기록물 등 게임 데이터 |
| `scripts/` | Godot GDScript 구현 파일 |
| `scenes/` | Godot TSCN 씬 파일 |

---

## 새 채팅 또는 새 작업자가 읽는 순서

```text
1. AGENTS.md
2. docs/DOCUMENTATION_MAP.md
3. docs/AI_WORKFLOW_RULES.md
4. docs/CODEX_SHARED_WORK_RULES.md
5. docs/MVP_WORKFLOW_CHECKLIST.md
6. docs/BENCHMARKING_REFERENCE_GUIDE.md
7. README.md
8. PROJECT_BRIEF.md
9. DESIGN_INTENT.md
10. MVP_ROADMAP.md
11. TEST_CHECKLIST.md
12. 현재 GitHub Issue
13. 실제 수정 대상 파일
```

---

## 새 프로젝트에 재사용할 문서

- `AGENTS.md`
- `docs/AI_WORKFLOW_RULES.md`
- `docs/CODEX_SHARED_WORK_RULES.md`
- `docs/BENCHMARKING_REFERENCE_GUIDE.md`
- `docs/MVP_WORKFLOW_CHECKLIST.md`
- `docs/DOCUMENTATION_MAP.md`

단, 프로젝트 전용 문서 목록은 새 프로젝트에 맞게 수정한다.

---

## 새 프로젝트에서 새로 작성할 문서

- `README.md`
- `PROJECT_BRIEF.md`
- `DESIGN_INTENT.md`
- `MVP_ROADMAP.md`
- `TEST_CHECKLIST.md`

---

## 관리 원칙

- 같은 규칙을 여러 문서에 장문으로 중복 작성하지 않는다.
- 반복 규칙은 공용 문서에 둔다.
- 세계관, 데이터, MVP 상태는 프로젝트 전용 문서에 둔다.
- Issue는 현재 작업 기준서다.
- Goal은 구현 실행 지시서다.
- HTML 대시보드는 ChatGPT와 사용자가 보는 시각화 작업 공간이다.
