# UX-PD-001 2A 검증 기록

> 책임 기획서: `docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md`

## 범위

사건 준비 화면의 핵심 결정과 보조 시스템 노출 순서를 분리한다. 기능·데이터·가격·효과·저장 Schema는 변경하지 않는다.

## 구현

- `scripts/scenes/preparation_progressive_disclosure.gd`
  - 기존 준비 화면을 상속한다.
  - 장비·외부 접점·기록 탭의 표시 상태만 관리한다.
  - 기존 `seen_hint_ids`에 공개 선택을 기록한다.
- `scenes/preparation_scene.tscn`
  - 상태 소유자 대신 표시 확장 스크립트를 진입점으로 사용한다.
- `tests/progressive_disclosure_preparation_test.gd`
  - 신규 상태 접힘, 핵심 탭 유지, 공개 후 전체 복원과 저장 기록을 검증한다.

## 자동 검증

- Godot 4.7.1 프로젝트 import: PASS
- 점진적 공개 전용 테스트: PASS
- 사건·편성 항상 표시: PASS
- 장비·외부 접점·기록 최초 접힘: PASS
- 한 번의 선택으로 전체 복원: PASS
- 기존 힌트 저장에 공개 상태 기록: PASS
- 저장 Schema 변경 없음: PASS

## 적대적 검토

- 기능 잠금이 아니라 같은 화면의 표시 순서만 변경한다.
- 기존 `preparation_scene.gd`를 직접 수정하지 않아 경제·편성·일정 회귀 범위를 줄였다.
- 진행 저장에 이미 보조 콘텐츠가 있으면 자동 공개해 기존 사용자를 신규 상태로 오인하지 않는다.
- 미확보 장비·기록·의뢰를 새로 생성하지 않는다.
- 정답·최적 요원·대응을 추천하지 않는다.

## 미실행

- 신규 플레이어 5~8명 외부 관찰 테스트: NOT_RUN

## 다음 단계

`UX-PD-001 2B`에서 조사 화면의 현재 관측·선택을 1차 정보로, 과거 기록·상세 상태를 보조 정보로 분리한다.
