# CI 비용 최적화 및 재활성화 절차

- 상태: `ACTION_REQUIRED`
- 적용일: 2026-07-24
- 적용 대상: PR #57 / Issue #56 / CORE-MVP-001
- 비용 게이트: 저장소 Actions 변수 `CI_ENABLED`

## 1. 현재 정지 상태

GitHub Actions 사용 가능 시간이 초기화될 때까지 모든 PR 검증 job은 다음 조건으로 runner 할당을 차단한다.

```yaml
if: ${{ vars.CI_ENABLED == 'true' }}
```

`CI_ENABLED`가 없거나 `true`가 아니면 workflow run은 생성될 수 있지만 job은 즉시 `skipped`된다. runner가 할당되지 않으므로 검증 시간을 소비하지 않는다.

현재 상태에서 신규 커밋을 푸시해도 다음 작업은 실행되지 않는다.

- Python 문서 계약 검사
- CORE-MVP-001 데이터·정적 계약 검사
- Godot 4.7.1 import
- CORE-MVP-001 집중 4개 테스트
- Godot 전체 43개 회귀
- Ubuntu·Windows Python 전체 매트릭스

## 2. 최적화된 CI 계층

### 2.1 문서 전용 PR

책임 workflow:

- `.github/workflows/validate-base-operating-sync.yml`

실행 범위:

- Ubuntu 1개 runner
- Python 3.12 1개 버전
- Base/core/routing/local Skill/활성 참조 validator만 실행
- 실패할 때만 로그 artifact 업로드
- artifact 보존 7일

PR 경로 필터:

- 루트 운영 문서
- `docs/**`
- `skills/**`
- 문서 계약 Python 테스트

문서 workflow는 `push: main`을 소유하지 않는다. main 병합 검증은 full matrix가 소유해 중복 실행을 막는다.

### 2.2 코드·데이터·Scene PR

책임 workflow:

- `.github/workflows/validate-core-mvp-001.yml`

실행 범위:

1. Ubuntu runner 1개만 할당
2. Python 3.12 데이터·정적 계약
3. Godot 4.7.1 import
4. CORE-MVP-001 집중 테스트 4개
5. 기존 테스트를 포함한 Godot 전체 43개 회귀
6. 실패할 때만 로그 artifact 업로드
7. artifact 보존 7일

Python과 Godot를 서로 다른 job으로 분리하지 않는다. checkout과 runner 시작 비용을 중복 소비하지 않도록 한 Ubuntu job에서 순차 실행한다.

PR 경로 필터:

- `data/poc/core_mvp_001/**`
- `scripts/poc/core_mvp_001/**`
- `scenes/poc/core_mvp_001/**`
- CORE-MVP-001 진입 UI
- 관련 Python/Godot 테스트와 runner

### 2.3 main 병합 및 nightly

상태:

- `ACTION_REQUIRED`
- workflow 파일 추가는 현재 도구 보안 제한으로 보류
- Actions 사용 가능 확인 후 `.github/workflows/validate-full-matrix.yml`을 추가한다.

소유 범위:

- `push: main`
- 매일 03:20 KST nightly (`20 18 * * *` UTC)
- 수동 `workflow_dispatch`

권장 job:

| Job | OS | 버전 | 실행 |
|---|---|---|---|
| Python matrix | Ubuntu, Windows | 3.11, 3.12, 3.13 | `python -m unittest discover -s tests -p "test_*.py"` |
| Godot regression | Ubuntu | Godot 4.7.1 | import + 전체 Godot 회귀 |

Windows Godot까지 매일 중복 실행하지 않는다. 플랫폼 독립 계약은 Python matrix로 확인하고, Godot 전체 회귀는 Ubuntu 한 번만 실행한다. Windows Godot smoke가 실제 플랫폼 결함 때문에 필요해질 때 별도 증거를 근거로 추가한다.

## 3. 중복 실행 취소

모든 workflow에는 다음 계약을 적용한다.

```yaml
concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

같은 PR 브랜치에 새 커밋이 올라오면 이전 실행을 취소한다. 다른 workflow 또는 다른 ref의 실행은 취소하지 않는다.

## 4. 전체 매트릭스 workflow 초안

Actions 사용 가능 확인 후 아래 계약으로 신규 workflow를 추가한다.

```yaml
name: Validate full matrix

on:
  push:
    branches: [main]
  schedule:
    - cron: "20 18 * * *"
  workflow_dispatch:

concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  python-matrix:
    if: ${{ vars.CI_ENABLED == 'true' }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest]
        python-version: ["3.11", "3.12", "3.13"]
    runs-on: ${{ matrix.os }}
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: python -m unittest discover -s tests -p "test_*.py"

  godot-ubuntu:
    if: ${{ vars.CI_ENABLED == 'true' }}
    runs-on: ubuntu-latest
    timeout-minutes: 45
    steps:
      - uses: actions/checkout@v4
      - uses: chickensoft-games/setup-godot@v2
        with:
          version: 4.7.1
          use-dotnet: false
          include-templates: false
      - run: godot --headless --path . --editor --quit-after 1
      - env:
          GODOT_BIN: godot
          GODOT_TEST_TMP: ${{ runner.temp }}/full-matrix-godot
        run: bash tests/run_godot_regression.sh
      - if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: full-matrix-godot-failure-logs
          path: ${{ runner.temp }}/full-matrix-godot/logs
          retention-days: 7
```

## 5. 사용 가능 통보 후 실행 순서

사용자가 **`GitHub Actions 사용 가능`**이라고 알리면 다음 순서로 재개한다.

1. 저장소 변수 `CI_ENABLED=true` 설정 또는 workflow의 비용 게이트 제거
2. full matrix workflow 추가
3. PR #57에서 문서 validator 수동 실행
4. PR #57에서 CORE-MVP-001 코드 validator 수동 실행
5. Python 데이터·정적 계약 PASS 확인
6. CORE-MVP-001 집중 테스트 `4/4` 확인
7. Godot 전체 회귀 `43/43` 확인
8. failure artifact가 있으면 최초 실패부터 수정
9. 1280×720·1920×1080 UI·키보드·Esc·포커스 확인
10. 기존 저장 비침범과 보호 경로 diff 확인
11. PR review thread·mergeability 확인
12. `POC_BUILD_READY` 판정 여부 결정

## 6. 상태 판정 제한

Actions 재개 전 허용 상태:

- `IMPLEMENTATION_IN_PROGRESS`
- `ACTION_REQUIRED`
- `AUTOMATED_VERIFICATION_PENDING`

Actions 재개 전 금지 상태:

- `POC_BUILD_READY`
- `POC_PASSED`
- `READY_FOR_MERGE`

사용자가 전체 원문 메시지, 신규 플레이어 행동 증거, 사전 지표를 면제했으므로, 자동·Godot·UI·보호 경로 검증이 통과하면 `POC_BUILD_READY`까지 판정할 수 있다. 플레이 증거 없이 `POC_PASSED`는 계속 선언하지 않는다.

## 7. 비용 가드레일

- PR에서는 OS/Python matrix를 실행하지 않는다.
- 문서 PR에서 Godot를 실행하지 않는다.
- 코드 PR에서 Windows runner를 실행하지 않는다.
- main 병합 시 PR workflow를 다시 실행하지 않는다.
- nightly는 하루 한 번만 실행한다.
- 실패 artifact만 업로드한다.
- artifact는 7일 후 만료한다.
- 새 커밋은 이전 동일 workflow/ref 실행을 취소한다.
- 테스트 재시도는 원인 없는 반복 실행이 아니라 수정 커밋 뒤 한 번만 수행한다.
