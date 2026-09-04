# D-2026-08-11-CASE01-UI-SEPARATION-SPEC-APPROVED

> 상태: `USER_APPROVED_CONSOLIDATED_SPEC / IMPLEMENTATION_PLANNING_AUTHORIZED / PLANNING_COMPLETE_RECEIVED / PHASE_C_READY`
> 승인 시각: 2026-08-11 KST
> Phase C 진입 선언: 2026-08-11 KST `기획 완료`
> 대상: `docs/specs/CASE01_ACTUAL_GAME_UI_SEPARATION_SPEC_2026-08-11.md`
> Human/UI 검증: `NOT_RUN`

## 결정

사용자는 2026-08-11 대화에서 CASE-01 저승역의 실제 게임 UI 분리 통합 Spec 방향을 승인하고 다음 단계 진행을 요청했다.

따라서 다음을 승인한다.

1. `LocationInvestigationSurface`와 공통 `InvestigativeDeviceShell`의 책임 분리.
2. Shell 상단 플레이어-facing 탭은 `[기록] [괴이 매뉴얼] [지도]`만 사용하며 독립 `[로그]`/`AI 로그` 탭을 만들지 않는다.
3. 루메는 독립 탭이 아니라 화면 문맥에 통합되는 보조 컴포넌트다.
4. 기록은 텍스트 중심 조사 아카이브이며 실제 음성 파일·재생기·waveform을 사용하지 않는다.
5. 괴이 매뉴얼은 5개 플레이어-facing 섹션을 사용하되 기존 3장 로직·14개 슬롯·장별 후보 규모·최종장→구출 흐름을 보존한다.
6. 키워드 배치는 클릭/탭만으로 완결되고 드래그는 선택적 보조 입력이다.
7. PC·태블릿·휴대폰은 가로형에서 같은 화면 구성 의미와 순서를 유지한다.
8. 지도 이동과 현장 `[이동]`은 같은 장소 데이터와 같은 travel 판정을 사용한다.
9. 탭 전환과 Shell 열기/닫기는 자체적으로 시간·판정·저장·조사 진행을 발생시키지 않으며 UI 문맥을 보존한다.

## 초기 Spec 승인으로 허용한 것

- 실제 현재 main/Canon v2/runtime 구조를 읽고 구현 영향 범위를 감사한다.
- TDD 중심 구현 계획을 작성한다.
- Visual Requirement Gate, HiGodot authoring gate, protected-path gate, exact-head regression 순서를 구현 계획에 포함한다.
- 구현용 별도 branch/PR의 파일·테스트·커밋 단위를 설계한다.

## 초기 Spec 승인만으로 허용하지 않았던 것

- `scripts/`, `scenes/`, `data/episodes/**`, `project.godot`, 자산 파일의 제품 runtime 변경.
- save schema 또는 사건 규칙 변경.
- 아직 승인되지 않은 이미지의 제품 자산 승격.
- Android Project Settings 변경.
- Canon v2의 정답/오답을 UI가 판정하거나 노출하는 기능.

위 제한은 **정확한 `기획 완료` 선언 수신 전의 Phase B 경계**였다. 2026-08-11 KST 사용자가 정확히 `기획 완료`라고 선언했으므로, 아래 Phase C 승인 범위가 그 이전 실행 차단을 대체한다.

## Phase C 진입 승인

2026-08-11 KST 사용자의 정확한 `기획 완료` 선언을 `USER_EXPLICIT_PLANNING_COMPLETE_DECLARATION`으로 기록한다.

Phase C에서 허용되는 구현 범위:

- 최신 `main`에서 분기한 격리 implementation branch 사용.
- `docs/superpowers/plans/2026-08-11-case01-investigation-ui-implementation-plan.md`와 r2 addendum 순서의 TDD RED→GREEN 실행.
- 계획에 명시된 CASE-01 test·thin adapter·shared travel·device shell·tab controller 구현.
- Scene/Node/Resource persistent authoring은 HiGodot-authorized 경로를 사용할 때만 수행.
- `scripts/core/game_state.gd`, `project.godot`, `data/episodes/**`, save version은 현재 승인 범위에서 변경하지 않음.
- 제품 이미지 바인딩은 Visual Requirement Gate가 `PROJECT_ASSET_APPROVED`에 도달하기 전까지 금지.
- 자동 검증은 Human/UI/Android PASS로 승격하지 않음.

현재 실행 기준선은 fresh startup audit에서 확인한 `main@6f84b68ee2c9e34c207f44d56aa251d0287e78a7`이다. Base remote 이동은 기록만 하고 자동 채택하지 않는다.

## 구현 계획 필수 경계

- 현재 main을 기준으로 이미 병합된 UI hierarchy runtime을 재사용하고 중복 구현하지 않는다.
- 보호 경로를 기본적으로 변경하지 않는 thin-adapter 설계를 우선한다.
- Canon v2의 기존 ID와 저장 계약을 우선 소비한다.
- `71_이미지기획_생성목록 → 72_이미지검수_승인로그 → PROJECT_ASSET_APPROVED → ASSET_MANIFEST.yml`을 통과하지 않은 이미지 바이트를 제품에 넣지 않는다.
- 1280×720, 1920×1080, 휴대폰 가로, 마우스, 키보드, 게임패드, 터치 동등 입력을 검증 계획에 포함한다.
- 자동 검증과 Human/UI 검증을 구분하며 미실행은 `NOT_RUN`으로 남긴다.

## 관련 Decision

- `D-2026-08-11-LUME-INTEGRATED-COMPANION-NO-LOG-TAB`
- `D-2026-08-11-CASE01-RECORDS-TAB-ARCHIVE-IA`
- `D-2026-08-11-CASE01-MANUAL-KEYWORD-INPUT-CONTRACT`
- `D-2026-08-11-CASE01-LANDSCAPE-SAME-COMPOSITION-UI`
- `D-2026-08-11-CASE01-SHARED-LOCATION-TRAVEL-CONTRACT`
- `D-2026-08-11-CASE01-FIELD-INVESTIGATION-SURFACE-CONTRACT`
- `D-2026-08-11-CASE01-MANUAL-FIVE-SECTION-THREE-CHAPTER-MAPPING`
- `D-2026-08-11-CASE01-UI-RUNTIME-PROJECTION-MAPPING`
