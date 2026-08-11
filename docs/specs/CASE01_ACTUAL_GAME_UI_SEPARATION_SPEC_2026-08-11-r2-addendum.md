# CASE-01 실제 게임 UI 분리 명세서 — r2 Correction Addendum

> 상태: `CURRENT_CORRECTION_OVERLAY / USER_APPROVED_DECISIONS_PRESERVED / PLANNING_ONLY`
> 기준 Spec: `docs/specs/CASE01_ACTUAL_GAME_UI_SEPARATION_SPEC_2026-08-11.md`
> 관련 Decision: `D-2026-08-11-LUME-INTEGRATED-COMPANION-NO-LOG-TAB`, `D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING`
> 우선순위: 이 addendum과 위 Decision이 기준 Spec의 충돌 문구보다 우선한다.

## 1. 목적

2026-08-11 연속 검토에서 발견된 두 개의 planning drift를 교정한다. 이 문서는 새 기능을 추가하지 않으며 기존 사용자 승인 방향을 정확히 보존한다.

## 2. 루메 외형 고정

기준 Spec Section 8.4의 다음 취지 문구는 **대체됨**이다.

- 후속 사건에서 사건별 외형 콘셉트가 달라질 수 있다는 해석

현재 정본은 다음이다.

- CASE-01은 사용자가 고정한 현재 루메 디자인을 사용한다.
- 루메의 캐릭터 정체성·복장·얼굴·실루엣·포즈 계열은 명시적인 새 사용자 승인 없이는 변경하지 않는다.
- 후속 사건이라는 이유만으로 사건별 테마 변형 권한이 자동으로 생기지 않는다.
- 제품 이미지 바인딩은 별도의 Visual Requirement Gate를 통과해야 한다.

## 3. 후보 변조 계보의 비노출

내부 ID와 provenance는 변조 계보를 보존할 수 있다. 그러나 정답 공개 전 플레이어-facing 화면에서는 다음을 지킨다.

- display label에 `[변조]` 접두를 표시하지 않는다.
- 변조/정상 여부를 색, 테두리, 아이콘, 배지, 정렬, 검색 필터, 루메 코멘트로 구분하지 않는다.
- 모든 후보는 동일한 정보 해상도와 카드 문법을 사용한다.
- `mutated`가 포함된 stable internal ID는 presentation에 직접 노출하지 않는다.

이 교정은 기존 `자동 정답 금지`, `세션 중 정답 비공개`, `변조 후보 식별 금지` 계약을 강화하며 새로운 사건 truth를 만들지 않는다.

## 4. CASE-01 루메와 기존 AGENTS 안내자 규칙의 범위

현재 `AGENTS.md`에는 전역 기본 안내자를 `기록관 아카`로 정의한 문구가 있다. 최신 사용자 승인 Decision은 **CASE-01 조사 디바이스와 현장 조사 보조 캐릭터 범위에서 루메를 사용**한다.

따라서 현재 planning authority는 다음처럼 해석한다.

```text
전역 일반 안내자 기본값: 기록관 아카
CASE-01 조사 디바이스/현장 보조 캐릭터: 루메 — 최신 사용자 승인에 따른 scoped exception
```

이 addendum은 전역 아카 정책을 모든 화면에서 폐기하지 않는다. `AGENTS.md` 자체 문구의 정본 전파는 partial-patch 안전 경로가 확보될 때 별도 freshness 수정으로 수행한다.

## 5. 이동 계약 해석

지도와 현장 `[이동]`은 동일 location dataset과 동일 shared travel handler를 사용한다. Gate A의 현재 구현 범위에서는 새 `field_node_id`나 save key를 만들지 않고, 현재 field session 안에서 장소와 표시되는 기존 investigation point 집합을 전환한다.

- 지도에서 장소 선택만으로 즉시 이동하지 않는다.
- 장소 상세 확인 후 명시적 `[이동]` 요청으로 전환한다.
- 현장 `[이동]`도 같은 handler를 호출한다.
- 기존 point condition/locked text를 우회하지 않는다.
- field-session 밖의 위치 영속성은 별도 승인 없이 발명하지 않는다.

## 6. Phase C gate

사용자의 `권장안 승인,연속작업 진행해`는 Gate A와 연속 planning 진행 승인이다. 현행 v4.5-r2에서 요구하는 정확한 `기획 완료` 선언은 아직 수신되지 않았다.

따라서 이 addendum 이후에도:

```text
planning Decision / Spec / Plan / review / PR 검증·병합 준비: 진행 가능
persistent product .gd/.tscn/test BUILD: 정확한 `기획 완료` 전 시작 금지
```
