# AI Workflow Rules

이 문서는 `도시괴담 기록국` 프로젝트에서 ChatGPT, Codex, 기타 코딩 에이전트가 공통으로 따라야 할 보조 작업 규칙을 정리한다.

`AGENTS.md`의 기본 규칙이 항상 우선하며, 이 문서는 Serena와 Playwright 관련 보조 규칙을 추가로 정의한다.

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

## 2. Serena 사용 규칙

Serena 또는 Serena MCP가 사용 가능한 작업 환경이라면, 코드 수정 전에 Serena로 관련 파일, 심볼, 참조 관계, 영향 범위를 먼저 확인한다.

Serena를 사용할 때 우선 확인할 것:

- 수정 대상 씬과 연결된 스크립트
- `GameState`, `UrbanLegendState`, `CaseData`, `EpisodeLoader` 등 공통 상태/데이터 파일
- 수정하려는 함수의 호출 위치
- 수정하려는 데이터 id가 참조되는 위치
- 기존 구현과 중복되는 함수 또는 상태값
- 변경 시 깨질 수 있는 씬 이동, 저장, 결과 표시 흐름

Serena가 사용 불가능하다면 다음 순서로 대체한다.

1. `AGENTS.md` 확인
2. 현재 Issue 본문 확인
3. `README.md` 확인
4. `rg`로 관련 키워드 검색
5. 관련 JSON / GDScript / TSCN 파일 직접 확인

금지:

- Serena를 사용하지 않았는데 사용한 것처럼 보고하지 않는다.
- Serena 결과만 믿고 실제 파일 확인을 생략하지 않는다.
- 의미 없는 대규모 리팩터링을 Serena 작업이라는 이유로 진행하지 않는다.

작업 후 보고에는 다음을 명시한다.

```md
## Serena 사용 여부

- 사용 가능 여부:
- 실제 사용 여부:
- 확인한 심볼/파일:
- Serena 미사용 시 대체 확인 방법:
```

---

## 3. ChatGPT 작업 규칙

ChatGPT는 기획, GitHub Issue 작성, HTML 대시보드 작성, Codex Goal 작성 시 다음을 지킨다.

- HTML 작업에는 Playwright 대응 구조를 포함한다.
- Godot/Codex 작업에는 Serena 사용 규칙을 포함한다.
- Serena가 실제로 연결되어 있지 않은 상태에서는 Serena를 사용했다고 말하지 않는다.
- Codex Goal에는 Serena 사용 가능 시 확인할 항목과 미사용 시 대체 확인 방법을 포함한다.
- Codex Goal만 복사해도 Codex가 작업할 수 있도록 모든 작업 기준을 Goal 안에 포함한다.

---

## 4. Codex 작업 규칙

Codex는 GitHub Issue 또는 `/goal`에 Serena 관련 지시가 있을 경우 다음을 따른다.

- 작업 환경에서 Serena MCP가 사용 가능한지 먼저 확인한다.
- 사용 가능하면 관련 심볼, 참조, 호출 위치, 영향 범위를 확인한 뒤 수정한다.
- 사용 불가능하면 `rg`와 실제 파일 확인으로 대체한다.
- 작업 후 Serena 사용 여부와 대체 확인 방법을 보고한다.

---

## 5. 우선순위

규칙 충돌 시 우선순위는 다음과 같다.

1. 사용자 최신 지시
2. `AGENTS.md`
3. 현재 GitHub Issue 본문
4. `/goal`
5. 이 문서
6. 과거 대화 요약
