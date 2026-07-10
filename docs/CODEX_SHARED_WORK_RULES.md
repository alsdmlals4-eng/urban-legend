# Codex Shared Work Rules

이 문서는 `도시괴담 기록국` 프로젝트에서 반복해서 쓰는 Codex 작업 규칙을 GitHub에 고정해 두기 위한 참조 문서다.

Codex는 매 작업마다 긴 지시문을 다시 받지 않아도, 이 문서를 읽고 공통 규칙을 적용한다.

> 이 파일은 현재 `도시괴담 기록국` 프로젝트 전용 규칙이다. 엔진·폴더·세계관에 종속되지 않는 공용 원칙은 `docs/AI_SHARED_WORK_RULES.md`에 두며, 새 프로젝트에서는 공용 문서를 먼저 복사한 뒤 프로젝트 전용 규칙을 별도로 작성한다.

---

## 1. 기본 확인 순서

작업 시작 전 아래 순서로 확인한다.

1. 최신 사용자 지시
2. `AGENTS.md`
3. `docs/BASE_RULES_VERSION.md`
4. `docs/DOCUMENTATION_MAP.md`
5. `docs/AI_SHARED_WORK_RULES.md`
6. `docs/AI_WORKFLOW_RULES.md`
7. `docs/CODEX_SHARED_WORK_RULES.md`
8. `docs/MVP_WORKFLOW_CHECKLIST.md`
9. `docs/BENCHMARKING_REFERENCE_GUIDE.md` - 기획 판단이나 MVP 범위 판단이 필요한 경우
10. 현재 GitHub Issue 본문
11. 현재 Codex Goal
12. `README.md`
13. 실제 수정 대상 JSON / GDScript / TSCN 파일

Base 원격 저장소는 일상 작업마다 직접 읽지 않는다. 먼저 이 저장소에 동기화된 로컬 Base 사본을 기준으로 삼고, Base 동기화나 공용 규칙 승격 작업에서만 원격 Base와 비교한다.

추정하지 않는다. 실제 파일 구조를 확인한 뒤 수정한다.

---

## 2. Superpowers 호출 및 설치 확인

Codex에서 `@Superpowers` 호출이 가능한 것이 확인된 환경에서는 Codex 작업 지시문을 `@Superpowers`로 시작한다.

기본 시작 문구:

```text
@Superpowers Use this repository's spec-first workflow.
Do not edit files immediately.
First read AGENTS.md, docs/BASE_RULES_VERSION.md, docs/DOCUMENTATION_MAP.md, docs/AI_SHARED_WORK_RULES.md, docs/AI_WORKFLOW_RULES.md, docs/CODEX_SHARED_WORK_RULES.md, the current Issue/Goal, and relevant files.
Then summarize the goal, player/user experience, implementation scope, excluded scope, likely changed files, risks, completion criteria, and test checklist.
Proceed only within the confirmed scope.
At the end, run the Compound Review process and report mistakes, lessons, prevention rules, and Base-promotion candidates.
```

Superpowers는 보조 워크플로우이며 다음을 덮어쓸 수 없다.

- 최신 사용자 지시
- `AGENTS.md`
- 현재 Issue 또는 Goal
- 프로젝트 문서
- 실제 파일 상태
- 확정된 ChatGPT 기획/프롬프트

Superpowers는 사용하는 실행 환경마다 별도로 설치되어야 한다. Codex App에서는 Codex 플러그인 목록에서 `Superpowers`를 설치한다. Codex CLI에서는 `/plugins`를 열고 `superpowers`를 검색한 뒤 `Install Plugin`을 선택한다.

Codex는 다음을 명확히 보고한다.

- `@Superpowers` 호출 가능 여부
- 실제 호출 여부
- 플러그인이 자동 적용되었는지, 명시 호출로 적용했는지
- 호출이 불가능했다면 대체로 적용한 저장소 규칙

설치되지 않았거나 호출되지 않은 상태를 성공으로 보고하지 않는다.

---

## 3. 역할 분리

### ChatGPT가 담당하는 것

- 기획 정리
- 플레이어 경험 정의
- 시스템 구조 설계
- 데이터 구조 설계
- GitHub Issue 작성/수정
- 벤치마킹 분석 작성/갱신
- 전체 흐름 HTML 대시보드 작성/수정
- Codex Goal 작성
- Codex 작업 결과 검토
- 테스트 체크리스트 작성
- MVP 로드맵 정리
- 작업 시작/종료 체크리스트 관리

ChatGPT는 실제 구현 완료를 단정하지 않는다. 구현 여부는 Codex의 변경 파일, diff, 실행 결과, 테스트 보고를 확인한 뒤 판단한다.

### Codex가 담당하는 것

- Godot 프로젝트 코드 수정
- JSON 데이터 수정
- TSCN 씬 수정
- 문서 수정
- README.md 갱신
- 구현 후 보고
- Compound Review 결과 정리
- 검증 가능한 테스트 결과 보고

Codex는 확정된 Goal 없이 임의로 기획 방향을 바꾸지 않는다.

### GitHub가 담당하는 것

- Issue 기준서 저장
- Codex Goal 저장 또는 참조
- 변경 파일 기록
- 완료 기준 기록
- 테스트 결과 기록
- 후속 Issue 후보 기록
- Base 승격 후보와 프로젝트 전용 규칙 후보 기록

### HTML 대시보드 규칙

HTML 대시보드는 ChatGPT가 별도로 관리하는 전체 흐름 확인용 문서다.

Codex가 repo 안의 HTML 파일을 직접 수정하라는 별도 요청을 받지 않았다면, HTML 대시보드는 Codex 구현 범위와 완료 기준에 넣지 않는다.

---

## 4. 문서 역할 구분

공용 규칙 문서와 프로젝트 전용 문서의 구분은 `docs/DOCUMENTATION_MAP.md`를 따른다.

새 채팅, 새 AI, 새 프로젝트에서는 이 문서를 먼저 확인해 어떤 문서가 공용이고 어떤 문서가 현재 프로젝트 전용인지 구분한다.

---

## 5. MVP 작업 체크리스트 참조 규칙

MVP 또는 주요 기능 작업은 `docs/MVP_WORKFLOW_CHECKLIST.md`의 순서와 체크리스트를 따른다.

해당 문서는 다음을 고정한다.

- ChatGPT / Codex / 사용자 역할 분리
- 표준 작업 순서
- 좋은 프롬프트 변환 기준
- ChatGPT 자체 Goal 루프
- 벤치마킹 체크리스트
- Issue 체크리스트
- HTML 대시보드 체크리스트
- Codex Goal 체크리스트
- Codex 결과 검수 체크리스트
- 새 프로젝트 시작 절차
- 도구 역할 분리
- 스테이지/맵 작업 아이디어 처리 규칙

---

## 6. 벤치마킹 참조 규칙

벤치마킹 세부 기준은 `docs/BENCHMARKING_REFERENCE_GUIDE.md`를 따른다.

기획, MVP 범위 설정, 신규 시스템 추가, UI/UX 판단이 필요한 경우에는 해당 문서를 먼저 확인한다.

벤치마킹 표는 다음 형식을 쓴다.

```md
| # | 게임/사례 | 관찰포인트 | 반응 | 기록국 적용(+사유) |
|---:|---|---|---|---|
```

Codex Goal에는 긴 벤치마킹 분석을 넣지 않는다. 필요한 경우 다음 한 줄만 넣는다.

```md
벤치마킹 세부 기준은 `docs/BENCHMARKING_REFERENCE_GUIDE.md`를 참고한다.
```

Codex가 단순 구현만 하는 경우에는 벤치마킹을 새로 하지 않아도 된다.

---

## 7. Serena 사용 규칙

Serena는 항상 쓰는 도구가 아니다.

Serena는 코드 구조 확인이 필요한 경우에만 사용한다.

### Serena를 사용할 작업

- 여러 GDScript 파일이 연결된 기능 수정
- GameState / EpisodeLoader / CaseData / Scene 전환이 얽힌 작업
- JSON 데이터 id가 여러 파일에서 참조되는 작업
- 저장/불러오기와 UI 표시가 같이 바뀌는 작업
- 함수 호출 위치와 영향 범위를 확인해야 하는 버그 수정
- 기존 구현과 중복될 위험이 있는 작업

### Serena를 사용하지 않아도 되는 작업

- 문서 작성
- GitHub Issue 정리
- ChatGPT용 HTML 대시보드 작성
- 단순 README 문구 수정
- 단일 JSON 텍스트 추가
- 단순 오탈자 수정
- 사용자가 명시적으로 Serena를 쓰지 말라고 한 작업

### Serena 사용 시 확인할 것

- 수정 대상 씬과 연결된 스크립트
- `GameState`, `UrbanLegendState`, `CaseData`, `EpisodeLoader`
- 수정하려는 함수의 호출 위치
- 수정하려는 데이터 id가 참조되는 위치
- 기존 구현과 중복되는 함수 또는 상태값
- 변경 시 깨질 수 있는 씬 이동 / 저장 / 결과 표시 흐름

### Serena가 불가능한 경우

Serena가 표시되지 않거나 사용할 수 없으면 다음으로 대체한다.

1. `AGENTS.md` 확인
2. `docs/DOCUMENTATION_MAP.md` 확인
3. `docs/AI_WORKFLOW_RULES.md` 확인
4. `docs/CODEX_SHARED_WORK_RULES.md` 확인
5. `docs/MVP_WORKFLOW_CHECKLIST.md` 확인
6. 현재 Issue 본문 확인
7. `README.md` 확인
8. `rg`로 관련 키워드 검색
9. 관련 JSON / GDScript / TSCN 직접 확인

금지:

- Serena를 사용하지 않았는데 사용했다고 보고하지 않는다.
- Serena 결과만 믿고 실제 파일 확인을 생략하지 않는다.
- 의미 없는 대규모 리팩터링을 Serena 작업이라는 이유로 진행하지 않는다.

---

## 8. Serena 보고 형식

작업 후 보고에는 아래 항목을 포함한다.

```md
## Serena 사용 여부

- 사용 가능 여부:
- 실제 사용 여부:
- 확인한 심볼/파일:
- Serena 미사용 시 대체 확인 방법:
```

Serena를 사용하지 않은 경우에도 `사용하지 않음`이라고 명시한다.

---

## 9. Codex Goal 작성 기준

Codex Goal은 짧은 실행 지시서다.

Issue가 전체 기준서이므로, Goal은 Issue를 다시 길게 반복하지 않는다.

Goal에 포함할 것:

- 사용 가능한 경우에만 `@Superpowers`, Harness, 또는 기타 플러그인 호출 시작 문구
- 현재 Issue 번호
- 작업 목표
- 실제 수정할 구현 범위
- 제외 범위
- 완료 기준
- 보고 형식
- Compound Review 요구
- 필요한 경우 Serena 사용 규칙 요약
- 필요한 경우 벤치마킹 문서 참조 한 줄

Goal에서 제외할 것:

- ChatGPT가 별도로 만든 HTML 대시보드 수정
- 긴 벤치마킹 분석 전문
- 과도한 기획 설명
- 중복된 세계관 설명
- Codex가 수정하지 않을 문서/자료

---

## 10. Compound Review Process

모든 실행-검토 사이클의 마지막에는 Compound Review를 수행한다.

목적은 이번 작업에서 발생한 실수, 누락, 착각, 검증 실패, 좋은 수정 패턴을 다음 작업에서 반복하지 않도록 누적하는 것이다.

Codex는 최종 보고 전에 다음을 정리한다.

- 이번 작업에서 발생한 실수 또는 near-miss
- 원인: 요구사항 오해, 파일 미확인, 테스트 부족, 범위 초과, 용어 혼동, 중복 구현, 저장 호환성 위험, UI 레이아웃 위험, 도구 한계 등
- 다음 작업에서 더 빨리 확인해야 할 항목
- 다음 Codex 프롬프트에 추가할 예방 문장
- 프로젝트 전용 규칙으로 남길 항목
- Base 공용 규칙으로 승격할 후보
- 실제 문서 업데이트가 필요한 위치

최종 보고에는 다음 섹션을 포함한다.

```md
## Compound Review

- 실수 또는 near-miss:
- 교훈:
- 다음 작업 예방 체크리스트:
- 다음 Codex 프롬프트에 추가할 문장:
- Base 승격 후보:
- 프로젝트 전용 규칙 후보:
```

---

## 11. Godot 프로젝트 고정 규칙

- Godot 4.7 stable + GDScript 기준으로 작업한다.
- Unity, C#, MonoBehaviour, Prefab 기준 구조를 사용하지 않는다.
- `battle_scene`은 전통 RPG 전투가 아니라 `괴이 안정화 / 회수 페이즈`다.
- `HP`, `damage`, `kill`, `death` 중심 표현을 새로 늘리지 않는다.
- 괴이는 죽이는 대상이 아니라 규칙을 밝혀 봉인/회수하는 대상이다.
- 기존 사용자 변경사항을 되돌리거나 덮어쓰지 않는다.
- 큰 리팩터링을 하지 않는다.
- 정상 작동하는 이전 MVP 흐름을 깨지 않는다.
- 새 GDScript 파일을 만들 경우 첫 줄에 한국어 역할 주석을 넣는다.

---

## 12. 작업 후 보고 기준

작업 후 보고에는 긴 명령어 목록보다 사용자가 Godot에서 확인할 항목을 적는다.

필수:

- 변경 파일
- 구현 내용
- 검증 내용
- 사용자가 Godot에서 확인할 항목
- 남은 위험
- Serena 사용 여부
- Superpowers / Harness / 기타 플러그인 사용 여부
- Compound Review

권장 형식:

```md
## 플러그인 사용 여부

- Superpowers 호출 가능 여부:
- Harness 사용 가능 여부:
- Serena 사용 가능 여부:
- 실제 사용한 도구:
- 미사용 시 대체 적용한 규칙:

## 변경 파일

-

## 변경 이유

-

## 구현 내용

-

## 검증 내용

-

## Godot 확인 순서

1.
2.
3.

## 남은 위험

-

## Compound Review

- 실수 또는 near-miss:
- 교훈:
- 다음 작업 예방 체크리스트:
- 다음 Codex 프롬프트에 추가할 문장:
- Base 승격 후보:
- 프로젝트 전용 규칙 후보:

## 다음 MVP에 넘길 항목

-
```

---

## 13. 현재 반복 적용할 핵심 문장

```text
괴담은 죽이는 게 아니라, 규칙을 밝혀 봉인하는 것이다.
```

이 문장은 UI, README, 결과/기록/회수 설명에서 프로젝트 톤을 잡는 기준으로 사용한다.

---

## 14. Harness 실패 시 GPT + Codex + GitHub 대체 규칙

Harness, Claude Code 플러그인, Superpowers, Serena, 또는 외부 멀티에이전트 도구를 설치할 수 없는 경우에도 작업은 중단하지 않는다.

이때 기준은 다음이다.

1. `AGENTS.md`와 이 문서가 최상위 작업 규칙이다.
2. GitHub Issue는 공식 작업 기준서다.
3. Codex Goal은 짧은 실행 지시서다.
4. ChatGPT는 기획, 범위 정리, Goal 작성, 검토, 테스트 체크리스트를 담당한다.
5. Codex는 실제 파일 수정, 검증, 보고를 담당한다.
6. GitHub는 결정, 변경, 테스트, 후속 작업을 남기는 단일 기록 저장소다.

### 14.1 Plan → Work → Review → Ship

플러그인 없이도 아래 4단계로 작업한다.

#### Plan

작업 전 다음을 정리한다.

- 해결하려는 문제
- 플레이어 경험 목표
- 작업 범위
- 제외 범위
- 예상 수정 파일
- 저장/데이터 호환성 위험
- UI/UX 위험
- 완료 기준
- 테스트 방법

#### Work

Codex는 Goal에 적힌 범위 안에서만 작업한다.

- 기존 기획을 삭제하지 않는다.
- 정상 작동하는 이전 MVP 흐름을 깨지 않는다.
- 임의의 대규모 리팩터링을 하지 않는다.
- 문서와 실제 파일 상태가 다르면 실제 파일을 먼저 확인하고 차이를 보고한다.
- 구현 편의보다 플레이어 경험과 유지보수성을 우선한다.

#### Review

작업 후 다음을 검토한다.

- Goal과 실제 변경이 일치하는가
- 완료 기준을 충족하는가
- 기존 기능을 깨뜨리지 않았는가
- 문서와 구현이 서로 맞는가
- 테스트 방법이 실제로 수행 가능한가
- 확인하지 못한 항목을 숨기지 않았는가

#### Ship

최종 보고에는 다음을 포함한다.

- 변경 파일
- 변경 이유
- 플레이어 경험에 주는 영향
- 검증 결과
- 확인하지 못한 항목
- 남은 위험
- 후속 Issue 후보
- Base 승격 후보
- 프로젝트 전용 규칙 후보

### 14.2 파일 변경 보고 규칙

파일을 생성, 삭제, 이름 변경, 크게 수정한 경우 반드시 다음 형식으로 보고한다.

```md
## 파일 변경 보고

### 변경 파일
- `파일 경로`

### 변경 이유
-

### 연결 영향
-

### 후속 동기화 필요 여부
-

### 확인하지 못한 항목
-
```

### 14.3 Base 승격 판단

여러 프로젝트에서 재사용할 수 있는 규칙은 Base 승격 후보로 적는다.

Base 승격 후보 예시:

- GPT와 Codex의 역할 분리
- Goal 작성 형식
- 작업 보고 형식
- 문서 우선순위 규칙
- 테스트 체크리스트 구조
- 파일 변경 보고 규칙
- 완료 기준 작성 방식

프로젝트 전용으로 남길 예시:

- 도시괴담 기록국 세계관
- 괴담 회수/봉인 용어
- 특정 MVP 번호와 Issue
- Godot 씬/스크립트 경로
- 현재 데이터 테이블 이름
- 프로젝트 전용 UI 구조

플러그인 설치 실패는 작업 실패가 아니다. 규칙 문서와 Goal이 명확하면 GPT + Codex + GitHub만으로도 작업을 계속 진행한다.
