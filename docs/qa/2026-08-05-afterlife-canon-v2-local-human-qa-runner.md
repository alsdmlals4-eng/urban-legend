# 저승역 Canon v2 로컬 Human QA Runner

## 일반 사용자는 원클릭 경로 사용

`main`을 pull한 뒤 저장소 루트의 `START_HUMAN_QA.cmd`를 실행한다. 이 진입점은 Godot과 저장을 자동 탐색하고 아래의 전문가용 `-Stage Prepare`, `-Stage Launch`, `-Stage Collect` 절차를 안전하게 연결한다.

자세한 일반 사용자 문서:

```text
docs/qa/2026-08-06-one-click-human-qa-package.md
```

아래 내용은 자동 탐색 실패, 재현 조사, 단계별 복구처럼 세 단계를 직접 제어해야 할 때 사용하는 전문가 경로다.

- Parent Decision: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`
- 자동 runner 목표 상태: `AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN`
- 실제 사용자 저장 업로드 상태: `ACTUAL_USER_SAVE_NOT_AVAILABLE`
- 실제 Human QA: `HUMAN_QA_NOT_RUN`
- UI·접근성: `UI_ACCESSIBILITY_NOT_RUN`
- 병합: `MERGE_NOT_AUTHORIZED`

이 runner는 실제 사용자 저장을 GitHub, CI artifact, ChatGPT 또는 repository에 업로드하지 않고 사용자 Windows PC 안에서만 복사·해시·격리 실행·증거 수집을 수행한다.

## 안전 경계

- 원본 저장은 읽기 전용 입력으로 취급한다.
- `Move-Item`, 원본 삭제, 원본 덮어쓰기를 수행하지 않는다.
- 기본 QA 폴더는 Desktop의 `urban-legend-qa/<timestamp>` 아래에 생성한다.
- 공유 가능한 증거는 `evidence` 폴더뿐이다.
- `.control/source-map.local.json`에는 원본 절대 경로가 있으므로 외부 공유·업로드·커밋을 금지한다.
- `manifest.json`에는 저장 본문을 기록하지 않고 익명 ID, 크기, SHA-256, 상대 QA 경로만 기록한다.
- 자동 runner 성공은 실제 UI·접근성·Windows 10/11 Human QA 성공을 의미하지 않는다.

## 준비

PowerShell에서 repository 루트로 이동한다.

```powershell
Set-Location "C:\projects\urban-legend"
git rev-parse HEAD
```

검증하려는 stacked PR exact HEAD를 checkout한 뒤, 원본 저장 경로를 확인한다.

기본 본편 저장 위치:

```text
%APPDATA%\Godot\app_userdata\urban-legend\urban_legend_save.json
```

Validation 저장이 있다면:

```text
%APPDATA%\Godot\app_userdata\urban-legend\urban_legend_validation_save.json
```

## 1. Prepare

본편 저장만 준비:

```powershell
$SourceMain = Join-Path $env:APPDATA "Godot\app_userdata\urban-legend\urban_legend_save.json"
$Runner = ".\tools\qa\run_afterlife_canon_v2_human_qa.ps1"

& $Runner -Stage Prepare -SourceMain $SourceMain
```

본편과 Validation 저장을 함께 준비:

```powershell
$SourceMain = Join-Path $env:APPDATA "Godot\app_userdata\urban-legend\urban_legend_save.json"
$SourceValidation = Join-Path $env:APPDATA "Godot\app_userdata\urban-legend\urban_legend_validation_save.json"
$Runner = ".\tools\qa\run_afterlife_canon_v2_human_qa.ps1"

& $Runner -Stage Prepare `
  -SourceMain $SourceMain `
  -SourceValidation $SourceValidation
```

출력의 `QA_ROOT=...` 값을 보관한다. 복사 직후 SHA-256이 다르면 runner는 `SOURCE_COPY_HASH_MISMATCH`로 중단한다. 원본과 QA destination이 같은 경로면 `SOURCE_AND_QA_PATH_COLLISION`으로 중단한다.

## 2. Launch

Prepare에서 출력된 QA root를 사용한다.

```powershell
$QaRoot = "C:\Users\<user>\Desktop\urban-legend-qa\<timestamp>"
$Runner = ".\tools\qa\run_afterlife_canon_v2_human_qa.ps1"

& $Runner -Stage Launch `
  -QaRoot $QaRoot `
  -GodotBinary "godot" `
  -RepoRoot (Get-Location).Path
```

runner는 자식 Godot 프로세스에만 격리된 `APPDATA`를 상속시키고 호출 PowerShell의 `APPDATA`는 `finally`에서 복원한다.

게임에서 다음 Human QA를 수행한다.

- 기존 저장 불러오기
- 안전 재시작 안내
- `migrated_unverified` 표시
- 완료 보고서·보상 불변
- Validation 격리
- 1280×720·1920×1080
- 키보드 포커스·컨트롤러
- 색상 외 상태 표현·접근성 문구

자동 runner는 이 항목을 PASS로 판정하지 않는다.

## 3. Collect

게임을 완전히 종료한 뒤 실행한다.

```powershell
$QaRoot = "C:\Users\<user>\Desktop\urban-legend-qa\<timestamp>"
$Runner = ".\tools\qa\run_afterlife_canon_v2_human_qa.ps1"

& $Runner -Stage Collect -QaRoot $QaRoot
```

Collect는 다음을 수행한다.

- Prepare 때 기록한 원본 SHA-256 재확인
- 원본 변경 시 `SOURCE_MUTATED_AFTER_PREPARE`로 실패
- QA 저장의 현재 SHA-256 기록
- transaction artifact 이름·크기·SHA-256 기록
- `collection-summary.json` 생성
- 상태를 `EVIDENCE_COLLECTED / HUMAN_REVIEW_REQUIRED`로 기록

## 증거 공유 규칙

공유 가능:

```text
<QA_ROOT>\evidence\manifest.json
<QA_ROOT>\evidence\collection-summary.json
<QA_ROOT>\evidence\godot-process-id.txt
<QA_ROOT>\logs\godot-launch.stdout.log
<QA_ROOT>\logs\godot-launch.stderr.log
```

공유 금지:

```text
<QA_ROOT>\.control\source-map.local.json
<QA_ROOT>\AppData\Roaming\Godot\app_userdata\urban-legend\*.json
실제 사용자 저장 원본
```

로그에 개인정보가 포함됐는지 사용자가 직접 확인한 후 공유한다.

## 판정

자동 preflight가 통과해도 최종 상태는 다음과 같다.

```text
AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN
/ ACTUAL_USER_SAVE_NOT_AVAILABLE
/ HUMAN_QA_NOT_RUN
/ UI_ACCESSIBILITY_NOT_RUN
/ MERGE_NOT_AUTHORIZED
```

실제 사용자 PC에서 evidence를 검토하고 별도 결과 승인을 받아야만 Human QA 상태를 변경할 수 있다.
