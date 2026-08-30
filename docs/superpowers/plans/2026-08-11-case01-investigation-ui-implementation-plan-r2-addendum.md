# CASE-01 Investigation Device UI Implementation Plan — r2 Addendum

> 상태: `CURRENT_EXECUTION_OVERRIDE / PLANNING_ONLY / PHASE_C_NOT_STARTED`
> 기준 Plan: `docs/superpowers/plans/2026-08-11-case01-investigation-ui-implementation-plan.md`
> 적용 Decision: `D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING`
> Spec correction: `docs/specs/CASE01_ACTUAL_GAME_UI_SEPARATION_SPEC_2026-08-11-r2-addendum.md`
> 우선순위: 기준 Plan과 충돌하면 이 addendum이 우선한다.

## 1. Gate A 상태 변경

기준 Plan의 Pre-code Gate A는 2026-08-11 KST 사용자 문구 `권장안 승인,연속작업 진행해`로 승인됐다.

따라서 실행 시 Gate A 매핑을 다시 선택하거나 질문하지 않는다. 다음 Decision을 그대로 소비한다.

`D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING`

## 2. Candidate display correction

기준 Plan A2의 내부 변조 후보 예시에 붙은 `[변조]` 접두는 **내부 정본 설명 표기**로만 해석한다. 정답 공개 전 실제 플레이어-facing label은 접두를 제거한다.

예:

```text
internal id: kw_afterlife_p01_mutated_start_silence
pre-reveal display label: 방송 시작 구간의 무음 공백

internal id: kw_afterlife_p02_mutated_after_announcement_end
pre-reveal display label: 안내 종료 후

internal id: kw_afterlife_p03_mutated_victim_solo_boarding
pre-reveal display label: 피해자 단독 탑승
```

구현 테스트는 다음을 반드시 포함한다.

- candidate visible text에 `[변조]` badge/prefix 없음
- normal/mutated ancestry에 따른 style class 차이 없음
- slot fitness/correctness 정렬 없음
- Lume comment가 변조 후보를 식별하지 않음

## 3. Lume identity and scenario-specific costume

기준 Plan에서 Lume 컴포넌트 구현 시 사용할 visual contract는 다음으로 고정한다.

- 사용자가 고정한 현재 루메 디자인이 identity reference다. 귀여운 소형 치비 비율,
  은빛 웨이브 머리, 큰 호박빛 눈의 정체성은 유지한다.
- 사건별 복장은 사용자 지시에 따라 바뀔 수 있다. 다만 무작위 자동 변형이 아니라,
  사건 ID가 명시된 별도 후보·별도 승인 product asset으로만 추가한다. `CASE-01`
  저승역 복장은 다른 시나리오의 전역 기본 복장이 아니다.
- approved product asset이 없으면 텍스트 helper shell까지만 구현하고 이미지 바인딩은 `BLOCKED_ASSET_APPROVAL`로 남긴다.
- Visual Requirement Gate 승인 전 placeholder를 제품 최종 자산처럼 승격하지 않는다.

## 4. Shared travel handler scope

기준 Plan의 `Case01TravelSession`은 단순 탭 로컬 선택기가 아니라 **지도와 현장 [이동]이 함께 호출하는 단일 shared travel handler**다.

현재 승인 범위:

```text
location dataset
→ selectable/locked/current presentation state
→ explicit travel_requested(location_id)
→ same field-session location update
→ existing investigation point filtering
→ focus/selection refresh
```

금지:

- 지도와 현장에 별도 이동 로직 복제
- 새 field node 생성
- 기존 point condition 우회
- 새 save key 또는 save version 추가
- 이동만으로 investigation truth/flag 생성

field-session 밖 위치 영속성은 이 slice에서 약속하지 않는다.

## 5. CASE-01 Lume / Aca authority conflict

현재 `AGENTS.md`의 전역 기본 안내자 `기록관 아카`와 이번 CASE-01 루메 승인 사이에 scope conflict가 있다.

실행자는 다음 우선순위를 사용한다.

```text
latest user-approved CASE-01 Decision
→ CASE-01 Spec r2 correction
→ existing global Aca default
```

즉, CASE-01 조사 디바이스/현장 보조는 루메다. 다른 전역 화면의 아카를 이 구현에서 임의 제거·개명하지 않는다.

`AGENTS.md` text propagation은 현재 connector의 안전한 partial patch 부재 때문에 이 planning PR에서 직접 대형 파일 교체로 수행하지 않는다. 구현 직전 freshness check에서 동일 conflict가 남아 있으면 기록하고, 별도 safe patch가 가능할 때 current router를 교정한다.

## 6. Phase C entry gate

기준 Plan Task 1의 test-only RED도 Phase C persistent repository BUILD에 포함한다.

현행 v4.5-r2 규칙에 따라 정확한 사용자 선언 `기획 완료`가 수신되기 전에는 다음을 시작하지 않는다.

- `tests/case01_ui/**` 생성
- production `.gd` 생성/수정
- `.tscn`/Node/Resource persistent authoring
- implementation branch의 product/test commit

그 전까지 허용되는 연속 작업:

- Decision/Sheet sync
- Spec/Plan refinement
- adversarial review
- PR exact-head CI
- planning PR merge readiness/merge preparation
- Visual Requirement Gate planning

## 7. Runtime execution order after exact gate

정확한 `기획 완료`가 수신되면 기준 Plan을 다음 순서로 실행한다.

```text
fresh startup re-read
→ isolated implementation branch from latest main
→ TDD RED tests/case01_ui
→ verify intended RED through exact-head CI/local Godot authority
→ minimal non-Scene model/adapter GREEN
→ shared travel handler GREEN
→ DeviceShell component logic GREEN
→ HiGodot-authorized Scene/Node wiring
→ Records/Manual/Map/Lume integration
→ 1280×720 / 1920×1080 / landscape wide regression
→ full maintained regression + exact-head CI
→ Windows Human QA remains separate
```
