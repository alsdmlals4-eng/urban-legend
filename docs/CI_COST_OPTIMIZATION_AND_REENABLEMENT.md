# CI 비용 최적화 및 운영 상태

- 상태: `ACTIVE`
- 재활성화일: 2026-07-24
- 적용 대상: PR #57 / Issue #56 / CORE-MVP-001
- 최신 검증: 문서 run #195 PASS / 코드 run #69 PASS

## 1. 재활성화 결과

GitHub Actions 사용 가능 통보 뒤 PR workflow의 job-level 비용 게이트를 제거했다. 현재 신규 커밋은 실제 runner를 할당받아 검증된다.

완료된 작업:

- `.github/workflows/validate-base-operating-sync.yml` 재활성화
- `.github/workflows/validate-core-mvp-001.yml` 재활성화
- `.github/workflows/validate-full-matrix.yml` 추가
- 모든 workflow의 ref별 `concurrency` 유지
- 실패 artifact만 7일 보존
- Godot import를 완료 대기 명령 `--import`로 교체

## 2. 최적화된 CI 계층

### 2.1 문서 전용 PR

책임 workflow:

- `.github/workflows/validate-base-operating-sync.yml`

실행 범위:

- Ubuntu runner 1개
- Python 3.12
- Base/core/routing/local Skill/활성 참조 validator
- 실패할 때만 로그 artifact 업로드
- artifact 보존 7일

문서 workflow는 `push: main`을 소유하지 않는다. main 병합 검증은 full matrix가 소유한다.

### 2.2 코드·데이터·Scene PR

책임 workflow:

- `.github/workflows/validate-core-mvp-001.yml`

실행 순서:

1. Ubuntu runner 1개
2. Python 3.12 데이터·정적 계약
3. Godot 4.7.1 `--import`
4. CORE-MVP-001 집중 테스트 4개
5. 기존 테스트를 포함한 Godot 전체 43개 회귀
6. 실패할 때만 로그 artifact 업로드
7. artifact 보존 7일

Python과 Godot를 한 job에서 순차 실행해 checkout과 runner 시작 비용을 중복하지 않는다.

### 2.3 main 병합 및 nightly

책임 workflow:

- `.github/workflows/validate-full-matrix.yml`

Trigger:

- `push: main`
- 매일 03:20 KST nightly (`20 18 * * *` UTC)
- 수동 `workflow_dispatch`

| Job | OS | 버전 | 실행 |
|---|---|---|---|
| Python matrix | Ubuntu, Windows | 3.11, 3.12, 3.13 | 전체 `test_*.py` |
| Godot regression | Ubuntu | Godot 4.7.1 | `--import` + 전체 Godot 회귀 |

Windows Godot는 중복 실행하지 않는다. 플랫폼 독립 계약은 Python matrix로 확인하고 Godot 전체 회귀는 Ubuntu에서 한 번만 실행한다.

## 3. 중복 실행 취소

모든 workflow는 다음 계약을 사용한다.

```yaml
concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

같은 PR 브랜치에 새 커밋이 올라오면 이전 동일 workflow 실행을 취소한다. 다른 workflow 또는 다른 ref의 실행은 취소하지 않는다.

## 4. Godot import 실패와 수정

첫 재활성화 코드 run #66에서 Python 계약, Godot 설치, 프로젝트 import, 집중 테스트는 통과했지만 전체 회귀가 실패했다.

원인:

- `godot --headless --path . --editor --quit-after 1`이 자산 import 완료 전에 종료
- 여러 `.ctex`가 생성되지 않음
- 기존 노선 미니게임의 PNG hard preload가 컴파일 실패

수정:

```text
godot --headless --path . --import
```

Godot 4.7.1의 `--import`는 모든 리소스 import가 끝날 때까지 기다린 뒤 종료한다. 수정 뒤 run #68과 최종 run #69에서 전체 43개 회귀가 통과했다.

## 5. 최신 검증 증거

- 문서 계약 run #195: PASS
- Python 데이터·정적 계약 run #69: PASS
- Godot 4.7.1 import run #69: PASS
- 집중 테스트 run #69: 4/4 PASS
- 전체 Godot 회귀 run #69: 43/43 PASS
- 1280×720·1920×1080 viewport, Esc, 포커스, 저장 비침범 계약: PASS
- 보호 경로 diff: PASS
- PR review thread 0, mergeable true

## 6. 상태 판정

허용 상태:

- `POC_BUILD_READY`
- PR 리뷰·병합 결정 대기

미선언 상태:

- `POC_PASSED` — 플레이 증거 없음
- 제작 확대 승인 — 별도 사용자 승인 필요

사용자가 전체 원문 메시지, 신규 플레이어 행동 증거, 사전 지표를 `POC_BUILD_READY` 차단 조건에서 제외했다. 플레이 증거 없이 `POC_PASSED`는 선언하지 않는다.

## 7. 비용 가드레일

- PR에서는 OS/Python matrix를 실행하지 않는다.
- 문서 PR에서 Godot를 실행하지 않는다.
- 코드 PR에서 Windows runner를 실행하지 않는다.
- main 병합 시 PR workflow를 중복 실행하지 않는다.
- nightly는 하루 한 번만 실행한다.
- 실패 artifact만 업로드한다.
- artifact는 7일 후 만료한다.
- 새 커밋은 이전 동일 workflow/ref 실행을 취소한다.
- 테스트 재시도는 원인 없는 반복이 아니라 수정 커밋 뒤 한 번만 수행한다.

## 8. 다음 확인

- PR #57 병합 뒤 최초 main full matrix 결과 확인
- nightly 첫 실행 결과 확인
- 실제 플랫폼 결함 증거가 생길 때만 Windows Godot smoke 추가
