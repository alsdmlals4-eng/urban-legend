# AGENTS.md

Codex와 다른 코딩 에이전트는 이 저장소에서 작업할 때 이 파일을 먼저 읽고 따라야 한다.

## Project

- Project name: `urban-legend`
- Engine: Godot 4.7 stable
- Language: GDScript

## Rule Scope

- 공용 규칙의 원본 저장소: [`alsdmlals4-eng/Base`](https://github.com/alsdmlals4-eng/Base)
- Base 기준 커밋과 동기화 날짜: `docs/BASE_RULES_VERSION.md`
- 작업 시 먼저 읽는 공용 로컬 사본: `docs/AI_SHARED_WORK_RULES.md`, `docs/AI_WORKFLOW_RULES.md`, `docs/MVP_WORKFLOW_CHECKLIST.md`, `docs/BENCHMARKING_REFERENCE_GUIDE.md`, `docs/DOCUMENTATION_MAP.md`
- 이 프로젝트에만 적용되는 Godot/도시괴담 기록국 규칙: 이 파일과 `docs/CODEX_SHARED_WORK_RULES.md`
- Base 링크만 직접 읽어 작업하지 않는다. 일반 작업은 프로젝트 안의 동기화된 로컬 사본을 기준으로 하고, Base 원격 저장소는 명시적 동기화 또는 기준 차이 확인 때만 사용한다.
- 공용 원칙과 프로젝트 전용 규칙이 충돌하면 이 프로젝트의 최신 사용자 지시와 이 파일을 우선한다.
- Genre: 현대 괴담 미스터리 비주얼 노벨 / 조사 어드벤처

이 프로젝트는 HTML 기반 `도시괴담 기록국` 데이터 편집기의 구조를 Godot 프로젝트로 옮겨, 대화·조사·미니게임·해결/회수·결과 보상이 연결되는 데이터 기반 게임 골격을 만드는 프로젝트다.

목표는 웹 페이지를 그대로 복사하는 것이 아니라, 도시괴담 기록국의 제작 데이터 구조와 플레이 흐름을 Godot에서 실제로 작동하는 비주얼 노벨/조사 어드벤처 기반으로 변환하는 것이다.

## Source References

- `C:\Users\user\Downloads\도시괴이담\urban-legend-database.html`
- `C:\Users\user\Downloads\도시괴이담\agent-workflow-report-v28.md`

기존 HTML 도구나 작업 보고서에 의존하는 기능을 구현할 때는 관련 원본 파일을 먼저 확인한다.

## Core Direction

- 현대 괴담 미스터리 비주얼 노벨 기반을 만든다.
- 핵심 경험은 `사건 이해`, `대화 선택`, `조사 방법 선택`, `단서 획득`, `미니게임 결과`, `괴담 약화`, `회수`, `기록/연구 보상`이다.
- 원본 콘셉트인 도시괴담 기록국, 기관 기록, 세력, 요원, 장비, 기술, 타임라인, 분기, 대화, 미니게임, 제작 체크를 보존한다.
- 분위기는 조사적이고, 불길하며, 읽기 쉽고, 데이터 기반이어야 한다.
- UI는 모바일 세로 화면을 우선하되, PC 마우스 입력도 사용할 수 있어야 한다.
- 의미 없는 선택지, 결과 차이가 없는 분기, 데이터화되지 않은 하드코딩 분기를 피한다.

## Work Preparation Rule

작업을 시작할 때는 Base 원격 링크가 아니라 이 저장소에 동기화된 공용 로컬 사본을 먼저 기준으로 삼는다. 다음 순서를 따른다.

1. `AGENTS.md`
2. `docs/BASE_RULES_VERSION.md`
3. `docs/DOCUMENTATION_MAP.md`
4. `docs/AI_SHARED_WORK_RULES.md`
5. `docs/AI_WORKFLOW_RULES.md`
6. `docs/MVP_WORKFLOW_CHECKLIST.md`
7. `docs/BENCHMARKING_REFERENCE_GUIDE.md`
8. `docs/CODEX_SHARED_WORK_RULES.md`
9. `README.md`
10. `PROJECT_BRIEF.md`
11. `DESIGN_INTENT.md`
12. `MVP_ROADMAP.md`
13. `TEST_CHECKLIST.md`
14. 현재 GitHub Issue
15. 실제 수정 대상 파일

10~13번 문서가 아직 없으면 부재 사실을 기록하고, 현재 작업 범위와 무관하게 내용을 추정하거나 새 문서를 만들지 않는다. 관련 씬, 스크립트, JSON은 실제로 열어 현재 구현을 확인한 뒤 수정한다. Base 원격은 동기화가 필요한 경우에만 이 순서 뒤에 확인한다.

## Battle / Recovery Direction

이 프로젝트에는 `battle_scene`이 존재하지만, 전통적인 RPG 전투를 목표로 하지 않는다.

- `battle_scene`은 괴이를 죽이는 전투가 아니라 `괴이 안정화 / 회수 페이즈`다.
- 괴담은 처치하지 않고 약화·안정화한 뒤 기록국 방식으로 회수한다.
- `HP`, `damage`, `death`, `kill` 같은 RPG 전투 중심 표현은 피한다.
- 필요한 경우 다음 용어를 우선한다.
  - 체력 → 괴이 안정도
  - 공격 → 안정화 조치 또는 공격형 지원
  - 방어 → 위험 억제 또는 보호형 지원
  - 피해/데미지 → 안정도 변화 또는 위험도 변화
  - 처치 → 회수
  - 전투 승리 → 회수 성공
- 단, `battle_scene.tscn`처럼 이미 존재하는 파일명이나 씬명은 당장 바꾸지 않는다. 기능명과 UI 문구부터 회수 중심으로 정리한다.
- 랭킹, 광고, 결제, 온라인 시스템은 명시 요청 없이는 추가하지 않는다.

## Current MVP Baseline

현재 구현 기준선은 MVP-018이다. 세부 상태는 `MVP_ROADMAP.md`, 수동 검수는 `TEST_CHECKLIST.md`, 문서 정합성 점검은 `docs/MVP_STATUS_AUDIT.md`를 함께 확인한다.

- MVP-001~009: 기본 씬, 사건 데이터, 힌트/단서, 해결·회수, 저장, 데이터 기반 대화/조사, 미니게임 결과 연결
- MVP-010~012: 3성향 요원 편성, 조사 방법과 성향 지원, 괴이 상태·예측·랜덤 이벤트
- MVP-013~015: 기록물·연구 보상·장비, 사건 준비, 두 번째 사건 준비 골격
- MVP-016: 선택 요원만 적용되는 수사 파트너 신뢰도와 1회 요원 이벤트
- MVP-017: 결과 화면 사건 보고서와 요원 신뢰도 결산
- MVP-018: 완료 사건 보고서 저장과 기록국 DB 재확인

새 작업은 현재 MVP 흐름을 유지하고, 다음 목표가 명시된 Issue/Goal 범위에서만 작게 확장한다.

## Version And User Guidance

- 표시 버전은 현재 MVP 번호를 소수점으로 반영한다. 예: MVP-018은 `Ver 1.8`, MVP-020은 `Ver 2.0`이다.
- 작업으로 플레이어가 확인할 내용이 달라지면, 게임 시작 화면에 이번 변경사항과 확인할 항목을 짧고 명확하게 표시한다.
- 작업 후 구현 방식은 중학생도 이해할 수 있는 쉬운 한국어로 간결하게 설명한다.

## Agent Temperament Direction

요원 성향은 반드시 아래 3개 중 하나만 사용한다.

- `analytical` / 분석형
- `empathetic` / 공감형
- `breakthrough` / 돌파형

별도 성향으로 `protective`, `stable`, `observer` 등을 만들지 않는다.
보호, 안정, 관찰 같은 개념은 위 3성향의 역할 설명이나 지원 효과로 처리한다.

### analytical / 분석형

- 핵심 가치: 괴담의 규칙, 기록, 조건, 패턴을 해석한다.
- 조사 특화: 분석, 기록 판독, 조건 해석, 숨은 규칙 발견.
- 미니게임 역할: 미니게임 보조 특화. 정답 후보, 패턴 힌트, 실패 완화, 제한 시간 보정 등으로 확장한다.
- 회수/전투 페이즈 역할: 관찰. 괴이의 행동 패턴을 예측하고 안정도 변화 흐름을 읽는다.
- 대화 톤: 증거, 로그, 반복 패턴, 조건을 중심으로 말한다.

### empathetic / 공감형

- 핵심 가치: 피해자 보호, 기억 복원, 현장 안정, 심리적 안전을 우선한다.
- 조사 특화: 관찰, 피해자 이해, 기억/감정 단서 파악.
- 미니게임 역할: 실패 리스크 완화, 피해자 관련 힌트 보정.
- 회수/전투 페이즈 역할: 방어. 피해자와 플레이어의 위험을 낮추고 회수 실패의 부작용을 완화한다.
- 대화 톤: 피해자 감정, 기억 공백, 후유증 위험을 중심으로 말한다.

### breakthrough / 돌파형

- 핵심 가치: 위험을 감수하더라도 괴이를 빠르게 해결한다.
- 조사 특화: 파괴, 강행 돌입, 잠긴 경로 돌파.
- 미니게임 역할: 일부 절차 우회 또는 위험 감수 강행 선택지.
- 회수/전투 페이즈 역할: 공격. 괴이 안정도를 빠르게 낮추거나 회수 조건을 앞당긴다.
- 대화 톤: 시간 부족, 현장 진입, 빠른 결단을 중심으로 말한다.

## Investigation Method Direction

조사 방법은 고정된 정답/오답 구조가 아니다.

- `파괴`, `관찰`, `분석`은 상황에 따라 좋은 선택이 달라져야 한다.
- 어떤 방법도 항상 정답이거나 항상 손해여서는 안 된다.
- 조사 방법은 결과뿐 아니라 위험도, 단서 종류, 미니게임 연결, 요원 반응, 신뢰도 변화에 영향을 줄 수 있다.

권장 방향:

- 파괴
  - 빠르게 잠긴 경로를 열거나 시간을 단축한다.
  - 돌파형 요원은 선호할 수 있다.
  - 분석형은 증거 훼손이나 조건 오판 때문에 반대할 수 있다.
  - 공감형은 피해자 위험이 커질 경우 반대할 수 있다.
  - 실패 시 위험도, 괴이 경계, 회수 난이도가 오를 수 있다.

- 관찰
  - 현장 이해도, 피해자 이해도, 단서 수집률을 안정적으로 올린다.
  - 공감형 요원이 가장 선호한다.
  - 분석형도 패턴 예측에 필요한 관찰이라면 긍정할 수 있다.
  - 즉시 돌파가 필요한 상황에서는 느리거나 기회를 놓칠 수 있다.

- 분석
  - 고가치 힌트, 조건 해석, 미니게임 완화, 숨은 규칙 발견에 강하다.
  - 분석형 요원이 가장 선호한다.
  - 돌파형은 긴급 상황에서 분석을 답답하게 볼 수 있다.
  - 실패 시 기억 오염, 공포도 상승, 잘못된 해석 플래그가 생길 수 있다.

요원 신뢰도는 단순히 특정 방법을 고정 선호하는 구조가 아니라, `상황 태그 + 선택 방법 + 성공/실패 + 요원 성향`을 함께 보고 변화해야 한다.

## Agent Direction

- 선택 요원만 대화, 조사, 회수 지원, 신뢰도 변화의 대상이 된다.
- 모든 요원은 `analytical`, `empathetic`, `breakthrough` 중 하나의 성향만 가진다.
- 요원 성향은 대화 톤, 선호 행동, 싫어하는 행동, 조사/회수 지원 방식에 영향을 준다.
- 요원 신뢰도는 연애 호감도가 아니라 `수사 파트너로서의 신뢰`다.
- 신뢰도는 플레이어가 어떤 방식으로 사건을 해결하는지에 대한 요원의 평가로 작동한다.
- 선택되지 않은 요원의 반응이나 신뢰도 변화는 기본적으로 발생하지 않아야 한다.
- MVP-010에서는 요원 편성과 3성향 대화에 집중한다.
- MVP-011에서는 조사 방법, 미니게임 보조, 관찰/방어/공격 지원, 상황별 신뢰도 반응을 연결한다.
- 전체 신뢰도 성장, 요원 이벤트, 장기 관계 보상은 별도 Issue가 있을 때만 구현한다.

## MVP-011 Scope Guard

MVP-011은 모든 조사 포인트를 완성 데이터화하는 단계가 아니다.

- 최소 1개 조사 포인트에서 `파괴 / 관찰 / 분석` 전체 흐름이 작동하면 MVP-011의 핵심은 충족된다.
- 각 성향별 지원 효과는 최소 1개씩만 먼저 구현한다.
- 조사 결과 요약 패널에는 선택 방법, 참여 요원, 판정 결과, 변화한 상태값, 요원 반응을 보여준다.
- 성향 지원 효과는 반복 중첩되지 않게 한다. 필요하면 `used_agent_supports` 같은 상태값을 둔다.
- 위험도와 괴이 안정도는 분리한다.
  - `investigation_risk`: 조사 중 위험도
  - `anomaly_stability`: 회수 페이즈의 괴이 안정도
- 이해도는 가능하면 사건 이해도와 피해자 이해도로 분리한다.
  - `case_understanding`
  - `victim_understanding`
- 분석형의 강점을 살리기 위해 일반 힌트와 고가치 힌트를 구분할 수 있게 한다.

## Benchmark Direction

참고작을 그대로 복사하지 말고, 기능 단위로만 흡수한다.

- `Disco Elysium`: 스킬이 대화 속 인격처럼 조언하고 판정에 영향을 주는 구조를 참고한다. 단, 24스킬처럼 복잡하게 늘리지 않고 3성향 요원 반응으로 단순화한다.
- `PARANORMASIGHT`: 플로우차트, 저주 조건, 실패 후 되돌아가 다른 선택을 찾는 구조를 참고한다. 단, 즉사 반복보다 기록국식 회수/봉인 흐름을 우선한다.
- `World of Horror`: 누적 위험도와 조사 선택의 대가를 참고한다. 단, 전투 RPG화하지 않고 위험도/공포도/괴이 안정도 중심으로 변환한다.
- `The Case of the Golden Idol`: 단서 수집과 사고 정리의 만족감을 참고한다. 단, 빈칸 추리 퍼즐을 그대로 만들지 않고 기록국 보고서/사건 이해도 UI로 변환한다.

## Work Style

- 실제 파일을 확인한 뒤 수정한다. `rg`로 관련 씬, 스크립트, 데이터 파일, 원본 참조를 찾는다.
- 작은 변경으로 목표를 달성한다.
- 기존 사용자 변경사항을 되돌리거나 덮어쓰지 않는다.
- 요청 범위 밖 리팩터링을 하지 않는다.
- 정상 작동하는 구조를 임의로 바꾸지 않는다.
- 추측성 프레임워크 작업은 구체적인 기능 요구가 있을 때만 한다.
- 초보자도 이해할 수 있도록 구조와 이름을 단순하게 유지한다.
- 설정, 씬 흐름, 테스트 방법, 프로젝트 범위가 바뀌면 `README.md`를 갱신한다.
- 프로젝트 의도나 로드맵이 바뀌면 해당 문서가 있을 경우 `PROJECT_BRIEF.md`, `DESIGN_INTENT.md`, `MVP_ROADMAP.md`, `TEST_CHECKLIST.md`도 함께 갱신한다.

## Godot Rules

- Godot 4.7 stable을 사용한다.
- 명시 요청이 없으면 GDScript를 사용한다.
- 씬과 노드 구조는 단순하게 유지한다.
- 명확한 이름을 사용한다. 예: `GameState`, `EpisodeLoader`, `InvestigationScene`, `DialogueScene`, `MinigameScene`, `BattleScene`, `ResultScene`.
- 새 GDScript 파일 첫 줄에는 한국어 역할 주석을 추가한다.

예시:

```gdscript
# 데이터베이스 화면의 섹션 선택과 상세 표시를 관리한다.
extends Control
```

## Data Priorities

HTML 개념은 Godot로 옮길 때 다음 순서를 우선한다.

1. 프로젝트 개요와 씬 이동 구조
2. 저승역 에피소드 데이터
3. 힌트, 단서, 해결 단계, 회수 결과
4. 플래그, 조건, 저장/불러오기
5. 데이터 기반 대화와 조사 포인트
6. 미니게임 성공/실패 결과와 사건 진행 연결
7. 요원 데이터, 편성, 3성향 대화
8. 조사 방법, 판정, 요원 지원, 신뢰도 반응
9. 장비, 기록물, 연구 보상, 다중 에피소드
10. 제작 품질 체크와 데이터 검증 도구

## Verification

코드, 씬, 프로젝트 설정이 바뀌면 가장 작은 유효 Godot 검증을 실행한다.

```powershell
godot --headless --path . --quit
godot --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
```

Windows 로컬 fallback:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --quit
```

씬을 수정했다면 관련 씬 단독 실행도 확인한다.

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/dialogue_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/investigation_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/minigame_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/battle_scene.tscn" --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --scene "res://scenes/result_scene.tscn" --quit-after 1
```

## Final Report Rule

작업 후 최종 보고에는 반드시 다음을 포함한다.

- 변경 파일
- 구현 내용
- 기획 의도 반영 여부
- 검증 내용
- 사용자가 Godot에서 확인할 항목
- 개선점 / 추가 제안
- 남은 위험
