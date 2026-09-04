# D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY

> 상태: `APPROVED`
> 승인 시각: 2026-08-02 15:56 KST
> 승인 방식: Grill Me 권장안 A
> 추적 PR: #129
> 상위 계약: `D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY`

## 결정

SCREEN-01 메인 메뉴에서 Legacy 본편과 Validation 기록을 **서로 독립된 병렬 카드**로 표시한다.

```text
기존 진행
- 새 캠페인
- 이어하기
- Legacy 저장 상태

Validation 기록
- 새 기록 시작
- 이어하기
- 완료 기록 보기
- 오류·호환 상태
```

두 저장은 동시에 존재할 수 있으며, 어느 한쪽의 손상·호환 오류·진행 상태가 다른 쪽 행동을 비활성화하거나 덮어쓰지 않는다.

## 승인 이유

- Package 1에서 승인·구현된 완전 독립 저장 경계를 UI 정보 구조에서도 그대로 보존한다.
- 단일 `이어하기`가 어느 기록을 여는지 모호해지는 문제를 제거한다.
- Validation 오류가 Legacy 접근을 막거나 Legacy 저장을 삭제하는 실패를 차단한다.
- Validation을 본편처럼 과도하게 전면화하지 않는다.

## 필수 계약

1. Validation 시작은 `GameState.clear_save_file()`을 호출하지 않는다.
2. 메뉴 상태 조회는 read-only이며 `ValidationSession.load()`를 사용하지 않는다.
3. active/suspended Validation은 `이어하기`, completed는 `완료 기록 보기`를 기본 행동으로 한다.
4. 기존 Validation 기록 교체는 사건명·단계 표시와 명시적 확인 없이는 수행하지 않는다.
5. corrupt/incompatible/recoverable 기록은 자동 삭제·덮어쓰기·백업 승격하지 않는다.
6. Legacy와 Validation 행동은 독립적으로 활성화한다.
7. 저장된 `scene_path` 직접 이동 대신 flow-stage allowlist mapper를 사용한다.
8. 로딩·생성·불러오기 중 mutation 입력은 single-flight로 잠근다.
9. 1280×720에서 두 카드의 주 행동이 첫 화면 또는 한 번의 자연스러운 스크롤 안에 노출되어야 한다.

## 제외

- Validation 전용 준비·추론·결과 Scene의 상세 설계
- 전체 게임 시스템·콘텐츠 기획
- 모바일 UI
- 자동 저장 복구·마이그레이션 구현
- 제품 코드 구현 승인

## Grill Me 카운터

이 Decision은 미래 Grill Me 승인 1건으로 집계한다.

```yaml
previous: 0 / 10
current: 1 / 10
merge_batch_triggered: false
```

## 다음 Gate

Package 2 Design을 제시하고 사용자 승인을 받은 뒤 Design Spec을 작성한다. 구현·테스트·Scene 변경은 별도 승인 전까지 금지한다.
