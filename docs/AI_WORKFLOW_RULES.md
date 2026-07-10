# AI Workflow Rules

> **Base 기반 로컬 사본 + 도시괴담 기록국 확장**: 공용 흐름의 원본은 [`alsdmlals4-eng/Base`](https://github.com/alsdmlals4-eng/Base)이며, 이 문서는 현재 프로젝트의 ChatGPT, HTML, Goal 작업 규칙을 덧붙인다. 기준 커밋은 `docs/BASE_RULES_VERSION.md`에 기록한다.

이 문서는 `도시괴담 기록국` 프로젝트에서 ChatGPT, Codex, 기타 코딩 에이전트가 공통으로 따라야 할 보조 작업 규칙을 정리한다.

`AGENTS.md`의 기본 규칙이 항상 우선한다.

반복 규칙은 아래 문서에 나누어 둔다.

- `docs/CODEX_SHARED_WORK_RULES.md`: Codex 공통 구현 규칙, Serena, 보고 형식
- `docs/AI_SHARED_WORK_RULES.md`: 새 프로젝트에도 복사 가능한 공용 AI 작업 원칙과 DoR/DoD
- `docs/MVP_WORKFLOW_CHECKLIST.md`: 작업 순서, 시작/종료 체크리스트, 좋은 프롬프트 변환, HTML/Issue/Goal 체크리스트
- `docs/BENCHMARKING_REFERENCE_GUIDE.md`: 벤치마킹 기준과 표 형식

---

## 1. ChatGPT 표준 작업 순서

기획, Issue 작성, HTML 대시보드 작성, Codex Goal 작성 전에는 다음 순서를 따른다.

1. 작업 유형 분류
2. 사용자 최신 지시 확인
3. GitHub 기준 문서 확인
4. 현재 MVP / Issue 기준선 확인
5. 작업 준비 상태 체크
6. Definition of Ready 확인
7. 벤치마킹 필요 여부 판단
8. 벤치마킹 분석 및 반영/제외 결론
9. 구현 범위 / 제외 범위 확정
10. 위험 분석 / 영향 파일 예상
11. GitHub Issue 작성 또는 수정
12. HTML 전체 흐름 대시보드 갱신
13. Codex Goal 작성
14. Codex 구현 결과 검수
15. Godot 확인 항목 정리
16. 결과 보고 / 회고
17. 필요한 경우 GitHub 공동 규칙 갱신

세부 체크리스트는 `docs/MVP_WORKFLOW_CHECKLIST.md`를 따른다.

---

## 2. 좋은 프롬프트 변환 규칙

사용자의 짧은 요청을 그대로 처리하지 않는다.

먼저 다음을 보강한다.

- 목표
- 배경
- 사용자의 의도
- 플레이어 경험
- 구현 범위
- 제외 범위
- 데이터 요구사항
- Godot 씬/노드 영향
- 완료 기준
- 테스트 방법
- 결과물 형식

---

## 3. 벤치마킹 규칙

벤치마킹이 필요한 작업에는 `docs/BENCHMARKING_REFERENCE_GUIDE.md`의 표 형식을 따른다.

표 형식:

```md
| # | 게임/사례 | 관찰포인트 | 반응 | 기록국 적용(+사유) |
|---:|---|---|---|---|
```

Codex Goal에는 긴 벤치마킹 전문을 넣지 않는다. 필요한 경우 문서 참조 한 줄만 넣는다.

---

## 4. HTML 대시보드 규칙

HTML 대시보드는 현재 MVP만 보여주는 파일이 아니다.

항상 프로젝트 전체 흐름을 확인할 수 있게 작성한다.

포함:

- 프로젝트 핵심 문장
- 현재 MVP 위치
- 이전/다음 MVP 연결
- 전체 로드맵
- 핵심 루프
- 주요 시스템 관계
- 현재 작업 상세
- 관련 캐릭터 / 요원 / 장비 / 기록물 카드
- 필요한 경우 벤치마킹 3~5개 요약
- 사용자가 수정 가능한 설명 영역

Codex가 repo 안의 HTML 파일을 직접 수정하라는 별도 요청을 받지 않았다면, HTML 대시보드는 Codex 구현 범위에 넣지 않는다.

### HTML 링크 보고 규칙

MVP 작업에서 HTML 대시보드를 만들거나 갱신했다면 결과 보고에 반드시 HTML 링크를 포함한다.

보고 순서:

1. **HTML 미리보기 링크**: 사용자가 바로 렌더링된 화면을 확인할 수 있는 링크를 먼저 제공한다.
2. **GitHub 소스 링크**: 파일 내용을 확인하거나 수정할 수 있는 `github.com/.../blob/...` 링크를 보조로 제공한다.
3. **변경 파일 경로**: 예: `docs/urban_legend_flow_dashboard.html`.

`github.com/.../blob/...html` 링크만 단독으로 보내지 않는다. 이 링크는 렌더링 화면이 아니라 소스 보기 링크다.

현재 프로젝트의 기본 HTML 링크 형식:

```text
HTML 미리보기:
https://htmlpreview.github.io/?https://github.com/alsdmlals4-eng/urban-legend/blob/main/docs/urban_legend_flow_dashboard.html

GitHub 소스:
https://github.com/alsdmlals4-eng/urban-legend/blob/main/docs/urban_legend_flow_dashboard.html
```

GitHub Pages 배포가 별도로 확인되면 GitHub Pages URL을 미리보기 링크로 우선 사용하고, 위 `htmlpreview.github.io` 링크는 보조 링크로 둔다.

---

## 5. 결과 보고 규칙

MVP 작업 결과 보고에는 아래 항목을 포함한다.

```md
## 지침 준수 / 작업과정

1. 사용자 최신 지시 확인
2. Base 공용 규칙 확인
3. 프로젝트 로컬 규칙 확인
4. 현재 MVP / Issue 기준선 확인
5. 구현 범위 / 제외 범위 확정
6. Issue 작성 또는 갱신
7. 전체 흐름 HTML 대시보드 갱신
8. Codex Goal 작성
9. 로드맵 / 체크리스트 / 상태 감사 문서 갱신
10. Base 승격 후보 여부 판단

## 갱신한 HTML 링크

- HTML 미리보기:
- GitHub 소스:

## 변경 파일

-

## 현재 MVP 상태

-

## Base 승격 후보 / 프로젝트 전용 유지

-

## Codex 복사용 Goal

/goal
...
```

HTML을 갱신하지 않은 작업이라도, 현재 기준 대시보드 링크를 함께 제공한다.

---

## 6. Codex Goal 규칙

- Codex Goal은 항상 마지막 섹션에 둔다.
- HTML은 Codex Goal 바로 앞에 둔다.
- Codex Goal 뒤에는 아무 문장도 쓰지 않는다.
- Issue는 전체 기준서, Codex Goal은 실행 지시서로 작성한다.
- Goal은 Issue와 `docs/CODEX_SHARED_WORK_RULES.md`를 참조하되 짧게 쓴다.
- Goal에는 구현 범위, 제외 범위, 완료 기준, 보고 형식을 포함한다.
- Goal에는 HTML 대시보드 수정이나 긴 벤치마킹 전문을 넣지 않는다.

---

## 7. Codex 작업 전 확인 순서

Codex는 작업 시작 전 다음을 확인한다.

1. `AGENTS.md`
2. `docs/AI_WORKFLOW_RULES.md`
3. `docs/CODEX_SHARED_WORK_RULES.md`
4. `docs/MVP_WORKFLOW_CHECKLIST.md`
5. 현재 Issue 본문
6. `README.md`
7. 실제 수정 대상 파일

---

## 8. 우선순위

규칙 충돌 시 우선순위는 다음과 같다.

1. 사용자 최신 지시
2. `AGENTS.md`
3. 현재 GitHub Issue 본문
4. `/goal`
5. `docs/CODEX_SHARED_WORK_RULES.md`
6. `docs/MVP_WORKFLOW_CHECKLIST.md`
7. `docs/BENCHMARKING_REFERENCE_GUIDE.md`
8. 이 문서
9. 과거 대화 요약
