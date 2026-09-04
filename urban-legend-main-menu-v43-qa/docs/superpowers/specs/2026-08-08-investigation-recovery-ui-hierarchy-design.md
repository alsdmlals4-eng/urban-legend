# Investigation / Recovery UI Hierarchy Design

> 상태: `SPEC_APPROVED / IMPLEMENTATION_PLAN_READY / IMPLEMENTATION_NOT_STARTED`
> 날짜: 2026-08-08
> 명세서 승인: 2026-08-08 20:31 KST
> Decision: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
> 기준 main: `09c187bf7bd4eb69fa19558d069d46f411d93951`
> Project-adopted Base baseline: `fa69a77a14f923a756064f6ae151d34cadb374f7`
> Current Base remote main observed at approval: `eee98a930219065e30b4d7d14d99d5ac7db44c60`
> Work Mode: `PLAN → REVIEW`
> 주 프로젝트 Skill: `urban-legend-ux-ui-accessibility / architecture + interaction-review`
> Base 지원 Skill: `auditing-and-refining-ui-art`, `running-adversarial-review-and-refinement`
> 구현 권위: `HiGodot only for persistent Godot mutation`
> 구현 계획: `docs/superpowers/plans/2026-08-08-investigation-recovery-ui-hierarchy-implementation-plan.md`

## 1. 문제 정의

현재 main의 시스템 의미는 승인된 Canon v2와 조사/회수 기준선을 대체로 보존하지만, 실제 Human QA 화면에서는 **표현 계층이 플레이 흐름을 압도하는 문제**가 드러났다.

조사 화면의 실제 관찰:

- 상단 Canon v2 rule strip과 큰 수동 정보 패널이 현장보다 먼저 읽힌다.
- 저승역 전용 `ManualPanel`이 우측 큰 면적을 상시 점유한다.
- 플레이어가 `괴이 매뉴얼 열기` 외의 상호작용을 찾기 어렵다고 보고했다.
- 배경·현장·인물·행동보다 검증용 정보 패널이 우선되는 인상이 강하다.

현재 구조에서 확인된 관련 노드·책임:

```text
investigation_scene.tscn
├─ TopHud
├─ LogBar
├─ Workspace
│  ├─ PointMethodDock
│  ├─ DialogueDock
│  └─ ManualPanel        # afterlife에서 상시 visible
├─ RecordDrawer
└─ Result/Confirm UI

CanonV2RuntimeBridge
└─ CanonV2OperationOverlay
   ├─ RuleStripPanel
   ├─ ManualDetailPanel
   ├─ ObligationPanel
   ├─ TerminationPreviewPanel
   └─ FollowUpPanel
```

회수 화면은 이미 `RecoveryHud + CinematicStage + ActionDock`이라는 좋은 골격을 갖고 있으나, 기준선과 비교하면 persistent `RepresentativeVisual`과 공용 overlay의 정보 점유를 다시 정리할 필요가 있다.

## 2. 설계 목표

### Investigation screen question

> “이 현장에서 지금 무엇이 이상하며, 어떤 행동으로 다음 근거를 확보할 수 있는가?”

### Investigation first attention

1. 현장 공간과 이상 징후
2. 짧은 상황 서술 / 현재 화자
3. 지금 가능한 조사 행동
4. 키워드와 가설 진행
5. 전체 기록·매뉴얼 상세

### Recovery screen question

> “괴이가 다음에 무엇을 하며, 지금 어떤 행동이 안정화·보호·봉쇄에 가장 적절한가?”

### Recovery first attention

1. 중앙 괴이 현상과 전조
2. 현재 안정도·위험·보호 의무
3. 행동 선택
4. 아군 상태와 지원
5. 규칙·로그·상세 근거

## 3. 선택한 접근

세 가지 가능한 접근을 검토했다.

### A. Current overlay 유지 + 스타일만 정리

장점:
- 구현량이 작다.
- 현재 Canon v2 컴포넌트를 거의 그대로 유지한다.

문제:
- 화면을 가리는 구조 자체가 남는다.
- Human QA에서 발견된 상호작용 발견성 문제를 해결하기 어렵다.
- 조사와 회수의 역할 차이가 약하다.

판정: `REJECT`

### B. 레퍼런스 화면을 새 씬으로 전면 재작성

장점:
- 빠르게 목표 구도에 가까워질 수 있다.

문제:
- 기존 조사 지점·방법·대사·결과·Canon v2 흐름을 중복 구현할 위험이 크다.
- 저장·행동 ID·focus·회귀 범위가 불필요하게 커진다.
- 레퍼런스의 픽셀 구조를 프로젝트 Canon보다 우선할 위험이 있다.

판정: `REJECT`

### C. 기존 Scene/데이터를 유지하고 presentation hierarchy만 재구성

장점:
- 기존 도메인 상태와 테스트를 보존한다.
- 현재 UI 컴포넌트의 재사용이 가능하다.
- 레퍼런스는 정보 위계와 구도만 취하고 프로젝트 고유 구조를 유지할 수 있다.
- 변경 위험을 `Control / Container / Theme / presentation bridge`에 집중할 수 있다.

판정: **`ADOPT / 권장안`**

## 4. Investigation 정보 아키텍처

### 4.1 화면 구역

1920×1080 기준 개념 비율이며 고정 픽셀 계약이 아니다.

```text
┌──────────────────────────────────────────────────────────────┐
│ Top Status Bar                                               │
├──────────┬───────────────────────────────────┬───────────────┤
│ Case Rail│                                   │ Keyword Rail  │
│          │       Environment / Scene         ├───────────────┤
│          │                                   │ Hypothesis    │
│          │   short scene prose overlay       │ Progress      │
│          │                                   │               │
├──────────┴───────────────┬───────────────────┴───────────────┤
│ Primary speaker/support │ Investigation Action Cards         │
│ dialogue                │ observe / talk / check / support   │
└──────────────────────────┴───────────────────────────────────┘
                         [Record / Manual drawer]
```

### 4.2 Top Status Bar

상시 값:

- 사건 식별
- 현장 이해도 / 조사 진척
- 위험도
- 획득 키워드
- 설정

비상시 값:

- 긴 규칙 전문
- protection obligation 상세
- follow-up 상세
- 사건 결과 상세

### 4.3 Case Rail

표시:

- 조사 단계
- CASE 번호
- 사건명
- 현재 위치
- 사건 개요

행동:

- 사건 개요 열기
- 현재 위치 정보 확인

금지:

- 행동 선택 카드 중복
- 매뉴얼 전문 중복

### 4.4 Environment Stage

표시:

- 배경
- 괴이 흔적
- 필요한 경우 환경 hotspot 시각 신호
- 3~6줄 scene prose

scene prose는 데이터에서 읽은 현재 상황을 요약·배치하며 새로운 진실을 발명하지 않는다.

### 4.5 Keyword Rail

표시 상태:

- 획득됨
- 새로 획득됨
- 잠긴 슬롯
- 관련 기록 존재

금지:

- 미획득 키워드 실제 이름 노출
- 색상만으로 새/잠김 구분

### 4.6 Hypothesis Progress

목적은 ‘정답 표시’가 아니라 플레이어가 현재 추론의 **단계와 빈칸**을 이해하는 것이다.

예시 구조:

```text
1. 확인한 현상     [근거 있음]
2. 현재 후보 가설  [미확정]
3. 다음 검증       [아직 필요]
```

기존 괴이 매뉴얼의 후보/확인/위험/미해결 의미를 침범하지 않는다.

### 4.7 Dialogue / Support

Primary slot:
- 현재 화자
- 표정/초상 폴백
- 1~3문장 대사

Support slot:
- 지원 인물
- 현재 관찰/지원 가능성
- 선택지 조건과 연결되는 짧은 힌트

동료는 핵심 정답을 직접 말하지 않는다.

### 4.8 Investigation Action Cards

행동 카드 표시 모델:

```yaml
action_id: existing_id
kind: observe | dialogue | skill | tag | check | support
title:
description:
requirement_text:
lock_reason:
risk_or_cost:
clue_potential:
difficulty_if_applicable:
state: normal | focused | selected | disabled | locked
```

UI는 `action_id`를 반환하며 결과 계산을 하지 않는다.

카드 정보 위계:

1. 행동 이름
2. 행동 유형
3. 조건/잠금 이유
4. 필요한 경우 난이도·비용·위험
5. 추가 단서 가능성

카드 내부에서 성공 확률이나 정답을 과장하지 않는다.

## 5. Manual / Canon v2 조사 통합

현재 문제는 `괴이 매뉴얼` 자체가 아니라 **상시 점유와 공용 overlay의 모드 부적합**이다.

### Investigation mode target

상시:
- compact rule continuity strip 또는 우측 hypothesis context의 짧은 요약

요청 시:
- 전체 괴이 매뉴얼 drawer/modal

숨김/비상시:
- recovery 전용 protection obligation 상세
- termination preview
- follow-up 상세

따라서 Canon v2의 데이터와 API를 삭제하지 않고 **mode-specific presentation adapter**로 재배치한다.

### Drawer behavior

- `기록/매뉴얼` 버튼 또는 단축키로 연다.
- drawer가 열리면 focus는 drawer 첫 의미 컨트롤로 이동한다.
- Esc/닫기 시 직전 의미 있는 조사 행동으로 돌아간다.
- backdrop 또는 panel이 필요 이상으로 전체 scene pointer를 차단하지 않도록 mouse filter를 검증한다.
- drawer를 닫지 않아도 배경 정보가 시각적으로 유지되지만, modal형으로 선택했다면 입력 차단 이유가 명확해야 한다.

## 6. Recovery 정보 아키텍처

### 6.1 기본 구조

```text
┌──────────────────────────────────────────────────────────────┐
│ Thin Recovery HUD: 안정 / 위험 / 핵심 상태 / 근거          │
├───────────────────────────────────────────┬──────────────────┤
│                                           │ Rules / Log /    │
│          Anomaly Confrontation            │ Objective Rail   │
│          telegraph / target               │ collapsible      │
│                                           │                  │
├───────────────────────────────────────────┴──────────────────┤
│ Ally status HUD / brief cut-in                                │
├──────────────────────────────────────────────────────────────┤
│ Action Strip: 보호 관찰 대응 공격 장비 봉쇄 철수            │
└──────────────────────────────────────────────────────────────┘
```

### 6.2 Anomaly Confrontation

- 중앙 괴이만 상시 전장 시각 주체다.
- 전조와 위험 대상은 텍스트/아이콘/형태를 함께 사용한다.
- stable/unstable/critical 등 의미가 있으면 색상 외 라벨을 동반한다.

### 6.3 Ally HUD

- 아군은 하단 카드로 표시한다.
- 상태·행동 가능·대표 역할을 빠르게 비교한다.
- 스킬 사용 시 필요한 경우만 짧은 컷인을 사용한다.
- persistent `RepresentativeVisual`은 제거 또는 숨김이 아니라 **컷인 역할로 재해석**하는 것을 기본 구현 가설로 둔다.

### 6.4 Action Strip

기존 행동 의미를 유지한다.

- 보호
- 관찰
- 대응
- 공격
- 장비
- 봉쇄
- 철수/후퇴가 현재 Canon에서 선택 가능할 때 표시

행동 선택 → 필요 시 preview/confirmation → commit 흐름을 유지한다.

### 6.5 Rules / Log / Objective Rail

상시 최소:
- 현재 현행 규칙 요약
- 현재 목표
- 가장 최근 전조/결과

펼치기:
- 전체 근거
- 로그 전문
- obligation 상세
- termination preview 상세

정보 전문을 상시 펼치지 않는다.

## 7. Responsive layout

### 1920×1080

- 기준 full composition
- case rail + scene + right rail + lower dialogue/action 모두 동시 표현 가능

### 1280×720

우선 축소 순서:

1. 장식 프레임·여백 감소
2. support portrait 축소 또는 compact card
3. right rail을 tab/accordion으로 병합
4. prose 줄수/보조 설명 요약
5. log/manual 상세 drawer 이동

유지해야 하는 것:

- 현재 사건/위치
- 핵심 위험 상태
- 첫 활성 행동
- 행동 잠금 이유
- 현재 획득 키워드/가설 상태에 접근하는 경로
- Esc/뒤로가기

## 8. Component contract

### Investigation

가능한 재사용 단위:

- 기존 TopHud 스타일/Theme
- `ActionChoiceCard`
- 현재 dialogue labels / support data
- PointsBox / MethodButtonBox 데이터 바인딩
- RecordDrawer의 기록 데이터
- 기존 AfterlifeManualCatalog 데이터

새 presentation container 후보:

- `CaseRail`
- `EnvironmentStage`
- `ContextRail`
- `DialogueSupportDock`
- `InvestigationActionDock`

이 이름은 구현 시 HiGodot에서 기존 scene 구조와 충돌 여부를 확인하고 최종 결정한다.

### Recovery

재사용:

- `RecoveryHud`
- `CinematicStage`
- `AnomalyVisual`
- `TeamStrip`
- `ActionDock`
- `ResponseGrid`
- `ClueDrawer`
- Canon v2 confirmation APIs

조정:

- persistent RepresentativeVisual → contextual cut-in
- obligation/termination/follow-up persistent detail → context rail/drawer/confirmation

## 9. Signal / state ownership

UI가 반환할 수 있는 것:

- investigation action selected
- point selected
- method selected
- manual opened/closed
- evidence selected
- response selected
- confirmation confirmed/cancelled
- drawer/tab visibility intent

UI가 소유하면 안 되는 것:

- keyword awarded
- clue truth
- hypothesis correctness
- obligation status
- stability calculation
- recovery outcome
- reward
- save state

## 10. Accessibility / input contract

### Mouse

- pointer target가 보이는 카드/버튼과 일치해야 한다.
- overlay의 투명 영역이 하위 컨트롤을 불필요하게 막지 않아야 한다.

### Keyboard

- 첫 활성 행동 focus
- 방향키/Tab 순서가 시각 순서와 일치
- Enter/Space confirm
- Esc close/back

### Gamepad

Human QA에서 별도 검증:
- D-pad/left stick focus
- confirm/cancel
- drawer 복귀 focus
- lower action strip 순환

### Non-color cues

- 위험: 아이콘 + 텍스트
- locked: 자물쇠/형태 + 이유 텍스트
- selected: border/shape + label
- new keyword: marker + text
- obligation priority: priority name + icon/shape

## 11. Error / fallback states

- 배경 누락: 단색/기존 fallback + 위치·사건 텍스트 유지
- 캐릭터 초상 누락: 이름·역할·대사 유지
- 키워드 없음: 빈 상태 문구 + 조사 행동 유지
- 가설 없음: 후보 미확정 문구 + 다음 검증 행동 유지
- 매뉴얼 데이터 없음: 오류 팝업 대신 안전한 빈 상태
- action list 없음: 다음 진행/복귀 경로를 fail-closed로 표시
- overlay mount 실패: 도메인 상태를 조작하지 않고 기본 scene UI 유지

## 12. Visual reference handling

사용자 제공 조사/회수 reference set은 다음만 추출한다.

- value hierarchy
- spatial grouping
- environment-first composition
- character/support relationship
- action-card discoverability
- compact top status
- right-side contextual information
- anomaly-centered recovery composition

복제하지 않는다.

- 개별 캐릭터 디자인
- 특정 프레임 장식
- 이미지 속 로고/문양
- 구체 폰트/텍스처
- 이미지에 구워진 UI 텍스트
- 특정 색 조합의 1:1 복제

`.asset-vault/` reference는 제품 파일로 이동하지 않는다. `PROJECT_ASSET_APPROVED` 전 root `ASSET_MANIFEST.yml`에는 추가하지 않는다.

## 13. Implementation slices

승인된 Spec의 구현은 다음 최소 slice로 분리한다. 상세 TDD 순서와 파일·명령은 구현 계획 문서가 책임진다.

### Slice 1 — Interaction blocker correction

목적:
- 조사 화면에서 실제 행동을 찾고 누를 수 있게 한다.

대상 가설:
- investigation mode Canon overlay 축소
- manual 상시 점유 제거
- focus/mouse filter 확인

검증:
- 기존 investigation path 자동 회귀
- pointer/keyboard smoke

### Slice 2 — Investigation hierarchy

목적:
- environment-first + case/context/action 구조

검증:
- 1920×1080 render
- 1280×720 render
- long Korean
- action lock reason

### Slice 3 — Recovery hierarchy

목적:
- anomaly-centered stage + bottom ally/action + contextual right rail

검증:
- telegraph/hypothesis/evidence/response 흐름
- obligation/confirmation
- termination preview
- retreat fallback

### Slice 4 — Human QA

- actual Windows save
- 18 checklist
- 720p/1080p
- keyboard/gamepad
- accessibility

## 14. Acceptance matrix

| 항목 | 자동 | 실제 화면 | 사람 |
|---|---|---|---|
| 기존 scene load/import | REQUIRED | - | - |
| 조사 action signal | REQUIRED | smoke | REQUIRED |
| keyword/manual data continuity | REQUIRED | - | REQUIRED |
| Canon v2 rule continuity | REQUIRED | REQUIRED | REQUIRED |
| confirmation/termination preview | REQUIRED | REQUIRED | REQUIRED |
| 1920×1080 overlap | optional static | REQUIRED | REQUIRED |
| 1280×720 overlap | optional static | REQUIRED | REQUIRED |
| Korean wrapping | automated candidate | REQUIRED | REQUIRED |
| mouse/keyboard | automated smoke | REQUIRED | REQUIRED |
| gamepad | limited automated | REQUIRED | REQUIRED |
| non-color cues | contract | REQUIRED | REQUIRED |
| actual save restart | existing runner | REQUIRED | REQUIRED |

Human 항목은 실행 전 `NOT_RUN`을 유지한다.

## 15. Adversarial review summary

### MUST_FIX

- current investigation overlay/persistent manual can obscure primary actions
- action discovery and focus need explicit first-action contract
- recovery persistent representative character conflicts with anomaly-only battlefield baseline
- 720p must collapse secondary information rather than primary actions

### SHOULD_FIX

- merge keyword/hypothesis/right-side context responsively
- move detailed log/manual/protection content to progressive disclosure
- preserve background and character readability before decoration

### DEFER

- final art asset replacement
- animation polish
- final typography tuning
- Android adaptation

### BLOCKED_UNVERIFIED

- vault local file provenance/runtime usage
- final product asset approval
- new runtime renders
- Human/UI/gamepad validation

## 16. Out of scope

- new investigation rules or clues
- new recovery balance
- save schema changes
- new episode IDs
- asset generation/replacement/deletion/promotion
- mobile UI
- production-wide screen rewrite

## 17. Approval / execution gate

이 문서는 승인된 방향을 구현 가능한 계약으로 세분화한 **approved written design spec**이다.

사용자는 2026-08-08 20:31 KST에 권장안대로 명세서를 승인했다. 이 승인은 구현 계획 작성까지 허용하며, Godot persistent mutation을 이 문서 PR에 섞거나 Human QA를 자동 통과시키는 승인이 아니다.

```text
spec approved
→ implementation plan review / exact-head docs CI
→ planning/canon merge gate
→ latest main + Base + Sheet fresh-read
→ separate HiGodot implementation PR
→ TDD RED/GREEN
→ GUT + full regression + exact-head CI
→ actual Windows Human/UI QA
```

구현 계획은 `docs/superpowers/plans/2026-08-08-investigation-recovery-ui-hierarchy-implementation-plan.md`가 책임진다.

HiGodot 권위가 없는 환경에서는 Scene·Node·Resource·Project Settings의 persistent mutation을 시작하지 않는다.
