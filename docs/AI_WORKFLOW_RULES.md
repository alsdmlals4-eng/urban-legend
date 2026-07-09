# AI Workflow Rules

이 문서는 `도시괴담 기록국` 프로젝트에서 ChatGPT, Codex, 기타 코딩 에이전트가 공통으로 따라야 할 보조 작업 규칙을 정리한다.

`AGENTS.md`의 기본 규칙이 항상 우선하며, 이 문서는 Serena, Playwright, HTML 대시보드, 작업 순서 관련 보조 규칙을 추가로 정의한다.

반복되는 Codex 작업 규칙은 `docs/CODEX_SHARED_WORK_RULES.md`에 별도 고정한다.

벤치마킹 기준과 표 형식은 `docs/BENCHMARKING_REFERENCE_GUIDE.md`에 고정한다.

---

## 0. 작업 순서 확인 규칙

ChatGPT는 기획, Issue 작성, HTML 대시보드 작성, Codex Goal 작성 전 반드시 작업 지침과 순서를 먼저 확인한다.

표준 순서:

1. 좋은 프롬프트 변환
2. 의도 분석 + 확인 작업
3. GitHub 기준선 확인 결과
4. 벤치마킹 분석 및 반영/제외 결론
5. 누락 데이터 / 개선점 / 위험 분석 후 해결해서 적용
6. GitHub Issue 반영 결과
7. HTML
8. Codex Goal

규칙:

- Codex Goal은 항상 마지막 섹션에 둔다.
- HTML은 Codex Goal 바로 앞에 둔다.
- Codex Goal 뒤에는 아무 문장도 쓰지 않는다.
- Issue는 전체 기준서, Codex Goal은 실행 지시서로 작성한다.
- Codex Goal은 Issue와 `docs/CODEX_SHARED_WORK_RULES.md`를 참조하되, 필요한 실행 조건만 명확하게 요약한다.
- 벤치마킹은 `게임/사례`, `관찰포인트`, `반응`, `기록국 적용(+사유)` 형식으로 정리한다.
- 불필요하게 길게 쓰지 않는다.
- 반복 설명보다 수정 대상, 구현 범위, 완료 기준, 보고 형식을 우선한다.

---

## 1. Playwright 대응 HTML 작성 규칙

현재 프로젝트에서는 Playwright를 별도로 설치하거나 실행하지 않는다.

다만 HTML 대시보드 작업은 나중에 Playwright로 테스트하기 쉽도록 작성한다.

필수 규칙:

- 주요 메인 탭에 `data-testid`를 추가한다.
- 주요 서브탭에 `data-testid`를 추가한다.
- MVP 섹션 루트에 `data-testid`를 추가한다.
- 요원 카드, 장비 카드, 기술 카드, 상세 패널에 `data-testid`를 추가한다.
- 버튼 클릭으로 표시되는 영역은 명확한 `id` 또는 `data-testid`를 가진다.
- 텍스트만으로 테스트해야 하는 구조를 피한다.
- 기존 탭 전환 구조를 깨지 않는다.
- 콘솔 에러가 나기 쉬운 미정의 함수 호출을 만들지 않는다.
- 실제 Playwright 실행은 요구하지 않는다.

권장 예시:

```html
<button data-testid="tab-system">시스템</button>
<button data-testid="subtab-mvp13-rewards">MVP-013 보상 구조</button>
<section data-testid="system-mvp13-rewards">...</section>
<button data-testid="agent-equipment-card">폐주파수 필터</button>
<div data-testid="agent-equipment-detail">...</div>
```

---

## 2. HTML 대시보드 전체 흐름 규칙

HTML 대시보드는 현재 MVP만 보여주는 파일이 아니다.

항상 프로젝트 전체 흐름을 확인할 수 있게 작성한다.

필수 포함:

- 프로젝트 핵심 문장
- 현재 MVP 위치
- 이전 MVP와의 연결
- 다음 MVP와의 연결
- 전체 로드맵
- 핵심 루프
- 주요 시스템 관계
- 현재 작업 상세
- 관련 캐릭터 / 요원 / 장비 / 기록물 카드
- 사용자가 수정 가능한 설명 영역

규칙:

- HTML은 매 MVP 작업 시 함께 갱신한다.
- `현재 버전만` 별도로 보여주는 HTML을 만들지 않는다.
- 새 HTML을 만들더라도 전체 흐름 탭을 반드시 포함한다.
- 기존 4탭 기준을 유지하거나, 그 이상의 구조를 쓰더라도 전체 흐름을 첫 탭에서 볼 수 있게 한다.
- MVP별 대시보드는 전체 로드맵 안에서 해당 MVP가 어디에 있는지 보여줘야 한다.
- Codex가 repo 안의 HTML 파일을 직접 수정하라는 별도 요청을 받지 않았다면, HTML 대시보드는 Codex 구현 범위에 넣지 않는다.

권장 기본 탭:

1. 전체 흐름
2. 시스템
3. 세계관 / 세력 / 요원
4. 에피소드
5. 현재 MVP 상세
6. 로드맵

---

## 3. Serena 사용 규칙

Serena 세부 규칙은 `docs/CODEX_SHARED_WORK_RULES.md`를 우선 참조한다.

요약:

- Serena는 항상 쓰는 도구가 아니다.
- 코드 구조 확인이 필요한 경우에만 사용한다.
- 문서, Issue, ChatGPT용 HTML 대시보드, 단순 오탈자 수정에는 사용하지 않아도 된다.
- 사용하지 않았는데 사용한 것처럼 보고하지 않는다.
- 사용 가능 여부와 실제 사용 여부를 작업 후 보고한다.

Serena를 사용할 때 우선 확인할 것:

- 수정 대상 씬과 연결된 스크립트
- `GameState`, `UrbanLegendState`, `CaseData`, `EpisodeLoader` 등 공통 상태/데이터 파일
- 수정하려는 함수의 호출 위치
- 수정하려는 데이터 id가 참조되는 위치
- 기존 구현과 중복되는 함수 또는 상태값
- 변경 시 깨질 수 있는 씬 이동, 저장, 결과 표시 흐름

Serena가 사용 불가능하다면 다음 순서로 대체한다.

1. `AGENTS.md` 확인
2. `docs/AI_WORKFLOW_RULES.md` 확인
3. `docs/CODEX_SHARED_WORK_RULES.md` 확인
4. 현재 Issue 본문 확인
5. `README.md` 확인
6. `rg`로 관련 키워드 검색
7. 관련 JSON / GDScript / TSCN 파일 직접 확인

---

## 4. ChatGPT 작업 규칙

ChatGPT는 기획, GitHub Issue 작성, HTML 대시보드 작성, Codex Goal 작성 시 다음을 지킨다.

- 작업 전 항상 이 문서의 작업 순서와 사용자 최신 지시를 확인한다.
- HTML 작업에는 Playwright 대응 구조를 포함한다.
- HTML은 항상 전체 흐름을 포함한다.
- Godot/Codex 작업에는 `docs/CODEX_SHARED_WORK_RULES.md` 참조 지시를 포함한다.
- 벤치마킹이 필요한 작업에는 `docs/BENCHMARKING_REFERENCE_GUIDE.md`의 표 형식을 따른다.
- Serena가 실제로 연결되어 있지 않은 상태에서는 Serena를 사용했다고 말하지 않는다.
- Codex Goal에는 필요한 경우 Serena 사용 조건과 미사용 시 대체 확인 방법을 짧게 포함한다.
- Issue는 전체 기준서로 작성한다.
- Codex Goal은 Issue를 참조하는 짧은 실행 지시서로 작성한다.
- Codex Goal만 복사해도 Codex가 최소 실행 조건을 이해할 수 있어야 한다.

---

## 5. Codex 작업 규칙

Codex는 작업 시작 전 다음을 확인한다.

1. `AGENTS.md`
2. `docs/AI_WORKFLOW_RULES.md`
3. `docs/CODEX_SHARED_WORK_RULES.md`
4. 현재 Issue 본문
5. `README.md`
6. 실제 수정 대상 파일

Codex는 GitHub Issue 또는 `/goal`에 Serena 관련 지시가 있을 경우 다음을 따른다.

- 작업 환경에서 Serena MCP가 사용 가능한지 먼저 확인한다.
- 필요한 작업이면 관련 심볼, 참조, 호출 위치, 영향 범위를 확인한 뒤 수정한다.
- 사용 불가능하면 `rg`와 실제 파일 확인으로 대체한다.
- 작업 후 Serena 사용 여부와 대체 확인 방법을 보고한다.
- Issue와 `/goal`이 충돌하면 사용자 최신 지시와 Issue를 우선한다.

---

## 6. 우선순위

규칙 충돌 시 우선순위는 다음과 같다.

1. 사용자 최신 지시
2. `AGENTS.md`
3. 현재 GitHub Issue 본문
4. `/goal`
5. `docs/CODEX_SHARED_WORK_RULES.md`
6. `docs/BENCHMARKING_REFERENCE_GUIDE.md`
7. 이 문서
8. 과거 대화 요약
