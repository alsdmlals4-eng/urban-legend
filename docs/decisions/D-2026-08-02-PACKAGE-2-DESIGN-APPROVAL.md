# D-2026-08-02-PACKAGE-2-DESIGN-APPROVAL

> 상태: `APPROVED`
> 승인 시각: 2026-08-02 16:07 KST
> 승인 방식: 사용자 `권장안대로 진행`
> 추적 PR: #129
> 상위 제품 Decision: `D-2026-08-02-PACKAGE-2-MAIN-MENU-MODE-HIERARCHY`
> 구현 권한: `NOT_AUTHORIZED`

## 결정

Package 2의 SCREEN-01 메인 메뉴 진입·이어하기·저장 상태·라우팅 Design을 승인한다.

승인 범위:

- Legacy `기존 진행`과 Validation `Validation 기록` 독립 병렬 카드
- Validation 저장의 read-only 상태 요약
- active·suspended·completed lifecycle별 기본 행동
- 기존 Validation 기록 교체의 명시적 확인
- corrupt·incompatible·recoverable 상태 무덮어쓰기
- flow-stage allowlist 기반 fail-closed 라우팅
- 메뉴 mutation single-flight 잠금
- Validation 전용 whitelist 런타임 초기화
- Legacy 파일·메모리 무부작용 검증
- 1280×720·1920×1080, 키보드 포커스·Esc 취소 검증 계약

## 핵심 보정

기존 `restart_afterlife_station_flow()`와 `reset_run_state()`는 campaign·관계·보상·경제 등 숨은 Legacy 상태를 초기화하므로 Validation 시작 경로에서 재사용하지 않는다.

Validation 시작은 Package 1 whitelist 필드만 초기화하는 좁은 adapter를 사용한다.

## 명시적 제외

- 제품 코드 구현
- Scene·JSON·Save Schema·workflow 변경
- Validation 전용 준비·추론·결과 Scene의 상세 게임 디자인
- 전체 게임 시스템·콘텐츠 기획
- 자동 복구·마이그레이션
- 모바일 UI
- POC 통과 선언

## Grill Me 카운터

이 승인은 앞서 Grill Me로 승인된 메뉴 위계 Decision을 상세 Design으로 확정한 후속 Gate다. 별도의 Grill Me 질문이 아니므로 카운터를 추가하지 않는다.

```yaml
previous: 1 / 10
current: 1 / 10
merge_batch_triggered: false
```

## 다음 Gate

승인 Design을 `docs/superpowers/specs/2026-08-02-package-2-main-menu-entry-routing-design.md`에 정본화하고 self-review한다.

사용자가 작성된 Spec을 승인하기 전에는 implementation plan 또는 제품 코드를 작성하지 않는다.
