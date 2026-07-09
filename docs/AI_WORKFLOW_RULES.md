# AI Workflow Rules

이 문서는 `도시괴담 기록국` 프로젝트에서 ChatGPT, Codex, 기타 코딩 에이전트가 공통으로 따라야 할 보조 작업 규칙을 정리한다.

`AGENTS.md`의 기본 규칙이 항상 우선한다.

반복 규칙은 아래 문서에 나누어 둔다.

- `docs/CODEX_SHARED_WORK_RULES.md`: Codex 공통 구현 규칙, Serena, 보고 형식
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
6. 벤치마킹 필요 여부 판단
7. 벤치마킹 분석 및 반영/제외 결론
8. 구현 범위 / 제외 범위 확정
9. 위험 분석 / 영향 파일 예상
10. GitHub Issue 작성 또는 수정
11. HTML 전체 흐름 대시보드 갱신
12. Codex Goal 작성
13. Codex 구현 결과 검수
14. Godot 확인 항목 정리
15. 결과 보고 / 회고
16. 필요한 경우 GitHub 공동 규칙 갱신

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

---

## 5. Codex Goal 규칙

- Codex Goal은 항상 마지막 섹션에 둔다.
- HTML은 Codex Goal 바로 앞에 둔다.
- Codex Goal 뒤에는 아무 문장도 쓰지 않는다.
- Issue는 전체 기준서, Codex Goal은 실행 지시서로 작성한다.
- Goal은 Issue와 `docs/CODEX_SHARED_WORK_RULES.md`를 참조하되 짧게 쓴다.
- Goal에는 구현 범위, 제외 범위, 완료 기준, 보고 형식을 포함한다.
- Goal에는 HTML 대시보드 수정이나 긴 벤치마킹 전문을 넣지 않는다.

---

## 6. Codex 작업 전 확인 순서

Codex는 작업 시작 전 다음을 확인한다.

1. `AGENTS.md`
2. `docs/AI_WORKFLOW_RULES.md`
3. `docs/CODEX_SHARED_WORK_RULES.md`
4. `docs/MVP_WORKFLOW_CHECKLIST.md`
5. 현재 Issue 본문
6. `README.md`
7. 실제 수정 대상 파일

---

## 7. 우선순위

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
