# Codex Shared Work Rules

이 문서는 `도시괴담 기록국` 프로젝트에서 반복해서 쓰는 Codex 작업 규칙을 GitHub에 고정해 두기 위한 참조 문서다.

Codex는 매 작업마다 긴 지시문을 다시 받지 않아도, 이 문서를 읽고 공통 규칙을 적용한다.

> 이 파일은 현재 `도시괴담 기록국` 프로젝트 전용 규칙이다. 엔진·폴더·세계관에 종속되지 않는 공용 원칙은 `docs/AI_SHARED_WORK_RULES.md`에 두며, 새 프로젝트에서는 공용 문서를 먼저 복사한 뒤 프로젝트 전용 규칙을 별도로 작성한다.

---

## 1. 기본 확인 순서

작업 시작 전 아래 순서로 확인한다.

1. `AGENTS.md`
2. `docs/DOCUMENTATION_MAP.md`
3. `docs/AI_SHARED_WORK_RULES.md`
4. `docs/AI_WORKFLOW_RULES.md`
5. `docs/CODEX_SHARED_WORK_RULES.md`
6. `docs/MVP_WORKFLOW_CHECKLIST.md`
7. `docs/BENCHMARKING_REFERENCE_GUIDE.md` - 기획 판단이나 MVP 범위 판단이 필요한 경우
8. 현재 GitHub Issue 본문
9. `README.md`
10. 실제 수정 대상 JSON / GDScript / TSCN 파일

추정하지 않는다. 실제 파일 구조를 확인한 뒤 수정한다.

---

## 2. 역할 분리

### ChatGPT가 담당하는 것

- 기획 정리
- GitHub Issue 작성/수정
- 벤치마킹 분석 작성/갱신
- 전체 흐름 HTML 대시보드 작성/수정
- Codex Goal 작성
- MVP 로드맵 정리
- 작업 시작/종료 체크리스트 관리

### Codex가 담당하는 것

- Godot 프로젝트 코드 수정
- JSON 데이터 수정
- TSCN 씬 수정
- README.md 갱신
- 구현 후 보고

### HTML 대시보드 규칙

HTML 대시보드는 ChatGPT가 별도로 관리하는 전체 흐름 확인용 문서다.

Codex가 repo 안의 HTML 파일을 직접 수정하라는 별도 요청을 받지 않았다면, HTML 대시보드는 Codex 구현 범위와 완료 기준에 넣지 않는다.

---

## 3. 문서 역할 구분

공용 규칙 문서와 프로젝트 전용 문서의 구분은 `docs/DOCUMENTATION_MAP.md`를 따른다.

새 채팅, 새 AI, 새 프로젝트에서는 이 문서를 먼저 확인해 어떤 문서가 공용이고 어떤 문서가 현재 프로젝트 전용인지 구분한다.

---

## 4. MVP 작업 체크리스트 참조 규칙

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

## 5. 벤치마킹 참조 규칙

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

## 6. Serena 사용 규칙

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

## 7. Serena 보고 형식

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

## 8. Codex Goal 작성 기준

Codex Goal은 짧은 실행 지시서다.

Issue가 전체 기준서이므로, Goal은 Issue를 다시 길게 반복하지 않는다.

Goal에 포함할 것:

- 현재 Issue 번호
- 작업 목표
- 실제 수정할 구현 범위
- 제외 범위
- 완료 기준
- 보고 형식
- 필요한 경우 Serena 사용 규칙 요약
- 필요한 경우 벤치마킹 문서 참조 한 줄

Goal에서 제외할 것:

- ChatGPT가 별도로 만든 HTML 대시보드 수정
- 긴 벤치마킹 분석 전문
- 과도한 기획 설명
- 중복된 세계관 설명
- Codex가 수정하지 않을 문서/자료

---

## 9. Godot 프로젝트 고정 규칙

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

## 10. 작업 후 보고 기준

작업 후 보고에는 긴 명령어 목록보다 사용자가 Godot에서 확인할 항목을 적는다.

필수:

- 변경 파일
- 구현 내용
- 검증 내용
- 사용자가 Godot에서 확인할 항목
- 남은 위험
- Serena 사용 여부

권장 형식:

```md
## Serena 사용 여부

- 사용 가능 여부:
- 실제 사용 여부:
- 확인한 심볼/파일:
- Serena 미사용 시 대체 확인 방법:

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

## 다음 MVP에 넘길 항목

-
```

---

## 11. 현재 반복 적용할 핵심 문장

```text
괴담은 죽이는 게 아니라, 규칙을 밝혀 봉인하는 것이다.
```

이 문장은 UI, README, 결과/기록/회수 설명에서 프로젝트 톤을 잡는 기준으로 사용한다.
