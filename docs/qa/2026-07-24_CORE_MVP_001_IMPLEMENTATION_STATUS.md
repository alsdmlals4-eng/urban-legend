# CORE-MVP-001 구현 상태 보고서

- 대상: Issue #56 / Draft PR #57
- 브랜치: `agent/core-mvp-001-poc-20260724`
- 판정: `IMPLEMENTATION_IN_PROGRESS / ACTION_REQUIRED / AUTOMATED_VERIFICATION_PENDING`

## 구현

- 조사 장면 3, 단서 6, 매뉴얼 3, 선택지 4, 가설 2
- 현장 검증, 이해도, 핵심 질문 해소, 전조 해석
- 회수 패턴 3, 행동 8, 고정 5턴, 포획 결과 3
- 결과 3축과 `RESULT_COMPARE → MANUAL_PROMOTION → COMPLETE`
- 단계별 단일 패널, ScrollContainer, 고정 Footer, 읽기 전용 이전 단계, 포커스 복구
- JSONL 로그와 F1 개발 패널 진입

## 정적 수정

1. 고정 ID drift 정렬
2. 런타임 참조 검증 보강
3. 미해결 질문 해소와 매뉴얼 승격 연결
4. 단계별 UI와 명시적 회수 진행
5. 중복 세션 시작 방지
6. 정적 테스트 자기 오탐 제거

## TDD 증거

- 데이터 Red run #1: 예상 실패
- Python 데이터 계약: 과거 PASS
- Godot Red run #8: 예상 실패
- 집중 run #16: 로더·로그 PASS, 상태 타입 경고 실패
- 타입 수정과 강화 계약: 코드·테스트 반영, 최신 실행 대기

## 보호 경계

기존 GameState, 사건 데이터, 조사·회수 Scene, `project.godot`, 저장 Schema는 변경하지 않는다. 기존 런타임 변경은 메인 메뉴의 F1 개발 버튼 추가뿐이다.

## Actions 재개 뒤

1. `CI_ENABLED=true`
2. full matrix workflow 추가
3. 문서·Python 계약
4. Godot import
5. 집중 `4/4`
6. 전체 `43/43`
7. UI·저장·보호 경로 검증
8. `POC_BUILD_READY` 판정

`POC_BUILD_READY`, `POC_PASSED`, `READY_FOR_MERGE`는 아직 선언하지 않는다.
