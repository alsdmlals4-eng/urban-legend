# UX-PD-001 2B 조사 정보 위계 검증 기록

> 책임 기획서: `docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md` | 이전 단계: `docs/qa/PROGRESSIVE_DISCLOSURE_SLICE_001.md`

## 목표

저승역 조사 화면에서 현재 관측·대화·선택을 우선 표시하고, 괴이 매뉴얼과 과거 현장 기록을 필요할 때만 여는 보조 계층으로 분리한다.

## 구현 파일

- `scripts/ui/investigation_progressive_disclosure.gd`
  - 조사 씬에 지연 설치되는 상태 비소유 helper
  - 기본 매뉴얼 접힘
  - 매뉴얼·현장 기록 상호 배타 표시
- `scripts/ui/scene_presentation.gd`
  - 기존 `investigation` 역할에서 helper 설치
  - 다른 역할·배경·에셋 로직 유지
- `tests/progressive_disclosure_investigation_test.gd`
  - 현재 관측·선택 기본 표시
  - 두 보조 패널 기본 접힘
  - 명시적 열기와 상호 배타 동작 검증

## 보호 계약

- `investigation_scene.gd`의 진행·단서·선택·위험·결과 로직 미변경
- 씬 노드·사건·단서·선택 ID 미변경
- 저장 Schema `mvp-039` 유지
- 새 저장 필드 없음
- 다른 두 사건의 기존 직접 조사 레이아웃 유지
- 매뉴얼·기록이 미확보 정보·정답·최적 요원을 추가하지 않음

## 자동 검증

- Godot 4.7.1 project import: PASS
- `progressive_disclosure_investigation_test.gd`: PASS
- 현재 관측·대화 기본 표시: PASS
- 현재 선택 기본 표시: PASS
- 매뉴얼·현장 기록 기본 접힘: PASS
- 매뉴얼·현장 기록 동시 열림 방지: PASS
- 전체 회귀 러너 진입점: 40개로 갱신

## 적대적 검토

- 조사 씬 전체 상속 교체안은 상태 결합 위험 때문에 폐기했다.
- 공용 프레젠테이션이 작은 helper만 지연 설치하므로 게임 상태를 중복 소유하지 않는다.
- 보조 패널은 동시에 열리지 않아 720p의 현재 선택 공간을 압박하지 않는다.
- 매뉴얼을 닫아도 확보 규칙 데이터는 삭제되지 않는다.
- 현장 기록을 닫아도 단서·힌트·학습 기록은 유지된다.

## 알려진 비차단 항목

- 일부 기존 UI 테스트 종료 시 RID/ObjectDB 경고: 기능 assertion과 별도 기술 부채
- 신규 플레이어 5~8명 외부 관찰 테스트: NOT_RUN

## 다음 단계

`UX-PD-001 2C`에서 결과 화면의 현장 결과·다음 행동을 우선 표시하고 상세 통계·장기 기록을 보조 계층으로 분리한다.
