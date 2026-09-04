업그레이드 전 백업/Git 복구 경로를 유지한다.

---

## 22. Windows·Android Shared Core

게임 로직과 데이터를 플랫폼별로 복제하지 않는다.

```text
SINGLE GAME LOGIC / DATA CORE
├─ Windows adapter
│  ├─ keyboard/mouse
│  ├─ gamepad
│  └─ desktop delivery
└─ Android adapter
   ├─ touch
   ├─ android back
   ├─ lifecycle
   └─ mobile delivery
```

분리할 것:

- input
- UI layout/responsive
- platform integration
- export/delivery
- performance profile

공유할 것:

- 게임 규칙
- 상태 모델
- 핵심 데이터
- 세이브 의미
- 보상/경제의 기본 의미

---

## 23. Build Size·체감 품질

각각 따로 측정한다.

```yaml
size:
  download:
  installed:
  runtime_memory:
  patch_delta:
```

최적화는 다음을 보호한다.

- 핵심 화면 품질
- 오디오 식별성
- 텍스트 가독성
- CJK/emoji/fallback
- startup latency
- 모바일 발열
- patch size

금지:

```text
모든 texture 동일 해상도
모든 audio 동일 압축
font 파일 하나로 강제
설치 크기만 줄이고 first-session download/runtime 악화
```

---

## 24. 구현 준비 Gate

BUILD 전에:

```yaml
implementation_ready:
  approved_scope:
  approval_reference:
  protected_items:
  exact_baseline_sha:
  existing_solution_disposition:
  acceptance_criteria:
  rollback:
  affected_consumers:
  test_plan:
  applicable_human_or_player_evidence:
  godot_authoring_route:
```

불완전하면 BUILD로 넘어가지 않는다.

---

## 25. 구현 원칙·Test First

### 25.1 격리 작업

- 최신 `origin/main` 또는 current remote main을 기준으로 별도 branch/worktree를 사용한다.
- Base와 프로젝트 변경을 같은 PR에 섞지 않는다.
- 동일 Goal PR이 있으면 중복 PR을 만들지 않는다.
- 예상 파일과 실제 changed files를 계속 대조한다.
- 관련 없는 BOM/format/file-mode cleanup을 기능 변경에 섞지 않는다.

### 25.2 작업마다 TDD 항상 적용

모든 작업은 TDD 또는 그 작업 유형에 맞는 **test-first 증거**를 먼저 만든다.

| 작업 유형 | 먼저 만드는 실패 증거·수용 기준 |
|---|---|
| 코드·게임 로직 | 실패 단위·통합·회귀 |
| 데이터·밸런스 | schema·범위·불변식·시뮬레이션 실패 |
| Scene·Resource | 로드·참조·signal·state transition |
| UI·입력 | state·focus·resolution·input scenario |
