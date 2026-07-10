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

## 0. 최우선 고정 규칙

모든 작업은 실제 수정, Issue 작성, HTML 갱신, Codex Goal 작성, 검수 보고 전에 아래 순서를 먼저 따른다.

1. **GitHub Base 공용 규칙 원본 확인**
   - 먼저 `alsdmlals4-eng/Base`의 관련 공용 규칙을 확인한다.
   - 특히 `docs/MVP_WORKFLOW_CHECKLIST.md`, `docs/AI_WORKFLOW_RULES.md`를 우선 확인한다.
   - Base 원본과 프로젝트 로컬 사본이 충돌하면 차이를 기록하고, 프로젝트 적용은 로컬 사본과 전용 규칙을 함께 보고 판단한다.
2. **프로젝트 로컬 Base 사본 확인**
   - `docs/BASE_RULES_VERSION.md`
   - `docs/AI_SHARED_WORK_RULES.md`
   - `docs/AI_WORKFLOW_RULES.md`
   - `docs/MVP_WORKFLOW_CHECKLIST.md`
   - `docs/BENCHMARKING_REFERENCE_GUIDE.md`
3. **프로젝트 전용 규칙 확인**
   - `AGENTS.md`
   - `docs/CODEX_SHARED_WORK_RULES.md`
   - `docs/DOCUMENTATION_MAP.md`
   - 현재 Issue / MVP 기준선
4. **사용자 요청을 좋은 프롬프트로 변환**
   - 사용자의 짧은 요청을 그대로 실행하지 않는다.
   - 작업 전 반드시 목표, 배경, 사용자 의도, 플레이어 경험, 구현 범위, 제외 범위, 데이터 요구사항, Godot 영향, 완료 기준, 테스트 방법, 결과물 형식을 정리한다.
5. **변환된 작업 범위를 기준으로 진행**
   - Issue, HTML, Goal, 문서, 구현 검수는 변환된 작업 범위와 제외 범위에 맞춰 진행한다.

이 규칙은 일반 작업 속도보다 우선한다. 사용자가 “바로 해줘”라고 해도 Base 확인과 좋은 프롬프트 변환을 생략하지 않는다.

---

## 1. ChatGPT 표준 작업 순서

기획, Issue 작성, HTML 대시보드 작성, Codex Goal 작성 전에는 다음 순서를 따른다.

1. 작업 유형 분류
2. 사용자 최신 지시 확인
3. GitHub Base 공용 규칙 원본 확인
4. 프로젝트의 Base 로컬 사본 확인
5. 프로젝트 전용 규칙 확인
6. 현재 MVP / Issue 기준선 확인
7. 좋은 프롬프트 변환
8. 작업 준비 상태 체크
9. Definition of Ready 확인
10. 벤치마킹 필요 여부 판단
11. 벤치마킹 분석 및 반영/제외 결론
12. 구현 범위 / 제외 범위 확정
13. 위험 분석 / 영향 파일 예상
14. GitHub Issue 작성 또는 수정
15. HTML 전체 흐름 대시보드 갱신
16. Codex Goal 작성
17. Codex 구현 결과 검수
18. Godot 확인 항목 정리
19. 결과 보고 / 회고
20. Base 승격 후보 여부 판단
21. 필요한 경우 GitHub 공동 규칙 갱신

세부 체크리스트는 `docs/MVP_WORKFLOW_CHECKLIST.md`를 따른다.

---

## 2. 좋은 프롬프트 변환 규칙

사용자의 짧은 요청을 그대로 처리하지 않는다.

작업 시작 전 반드시 다음을 보강한다.

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

좋은 프롬프트 변환 결과는 내부 판단으로만 끝내지 않는다. MVP 작업, Issue 작성, Goal 작성, 검수 작업에서는 결과 보고의 `지침 준수 / 작업과정`에 요약해서 표시한다.

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

Codex가 HTML 파일을 직접 수정하라는 별도 요청을 받지 않았다면, HTML 대시보드는 Codex 구현 범위에 넣지 않는다.

### HTML 파일 제공 방식

HTML 대시보드의 목적은 사용자와 ChatGPT가 프로젝트 전체 흐름을 가독성 좋게 확인하는 것이다.

따라서 기본 방식은 **GitHub 소스 관리가 아니라 로컬 HTML 파일 제공**이다.

기본 파일명:

```text
urban-legend-database-dashboard.html
```

사용자 로컬 기준 기본 확인 경로:

```text
file:///C:/Users/user/Downloads/urban-legend-database-dashboard.html
```

작업 원칙:

1. ChatGPT는 HTML 대시보드를 만들거나 갱신할 때 다운로드 가능한 `.html` 파일을 제공한다.
2. 사용자는 해당 파일을 `C:/Users/user/Downloads/urban-legend-database-dashboard.html`로 저장해 브라우저에서 연다.
3. 결과 보고에는 로컬 확인 경로와 다운로드 링크를 함께 제공한다.
4. GitHub에는 HTML 대시보드 소스를 반드시 올릴 필요가 없다.
5. GitHub 소스 링크는 사용하지 않는 것이 기본이며, 사용자가 명시적으로 GitHub 보관을 요청할 때만 별도로 처리한다.
6. 기존 GitHub에 남아 있는 HTML 파일은 과거 기록으로 취급하고, 앞으로의 기본 전달 방식으로 사용하지 않는다.

보고 형식:

```md
## 갱신한 HTML 대시보드

- 로컬 확인 경로: file:///C:/Users/user/Downloads/urban-legend-database-dashboard.html
- 다운로드 파일: [urban-legend-database-dashboard.html](sandbox:/mnt/data/urban-legend-database-dashboard.html)
```

---

## 5. 결과 보고 규칙

MVP 작업 결과 보고에는 아래 항목을 포함한다.

```md
## 지침 준수 / 작업과정

1. 사용자 최신 지시 확인
2. GitHub Base 공용 규칙 원본 확인
3. 프로젝트 Base 로컬 사본 확인
4. 프로젝트 전용 규칙 확인
5. 좋은 프롬프트 변환
6. 현재 MVP / Issue 기준선 확인
7. 구현 범위 / 제외 범위 확정
8. Issue 작성 또는 갱신
9. 전체 흐름 HTML 대시보드 갱신 또는 로컬 HTML 파일 생성
10. Codex Goal 작성
11. 로드맵 / 체크리스트 / 상태 감사 문서 갱신
12. Base 승격 후보 여부 판단

## 좋은 프롬프트 변환 요약

- 목표:
- 배경:
- 사용자 의도:
- 플레이어 경험:
- 구현 범위:
- 제외 범위:
- Godot 영향:
- 완료 기준:
- 결과물 형식:

## 갱신한 HTML 대시보드

- 로컬 확인 경로: file:///C:/Users/user/Downloads/urban-legend-database-dashboard.html
- 다운로드 파일:

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

HTML을 갱신하지 않은 작업이라도, 현재 기준 대시보드 파일 이름과 로컬 확인 경로를 함께 제공한다.

---

## 6. Codex Goal 규칙

- Codex Goal은 항상 마지막 섹션에 둔다.
- HTML 안내는 Codex Goal 바로 앞에 둔다.
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
