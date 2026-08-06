# 저승역 Canon v2 Human QA Plan

> **For QA operators:** 이 문서는 자동 fixture 사전검증과 사람 검증을 분리한다. 자동 검증 성공은 Human QA 성공을 의미하지 않는다.

**Goal:** 저승역 Canon v2 저장 이관이 실제 파일·실제 UI·Windows 파일 시스템 조건에서도 원본 기록, 보상, Validation 격리와 rollback을 보존하는지 재현 가능한 증거로 검증한다.

**Architecture:** repository representative fixture 4종을 먼저 headless로 검증하고, 그 다음 Windows 격리 사용자 데이터 폴더에서 실제 저장 복사본과 장애 주입을 검증한다. 모든 실행은 입력 SHA-256, exact commit, 실행 로그, migration artifact, 실행 후 저장 diff를 남긴다.

**Tech Stack:** Godot 4.7.1, GDScript, PowerShell 7 또는 Windows PowerShell 5.1, GitHub Actions, JSON, SHA-256.

## Global Constraints

- Decision: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`.
- 현재 상태: `HUMAN_QA_NOT_RUN`.
- 자동 사전검증 상태 이름: `AUTOMATED_FIXTURE_PREFLIGHT`.
- 병합 상태: `MERGE_NOT_AUTHORIZED`.
- 검증 대상 운영체제: `Windows 10/11`.
- Godot 기준 버전: `4.7.1`.
- 원본 저장 파일에서 직접 시험하지 않는다.
- 실제 저장은 복사본만 사용하며 실행 전·후 `SHA-256`을 기록한다.
- Human QA 판정은 `PASS`, `FAIL`, `BLOCKED`, `NOT_RUN` 중 하나만 사용한다.
- Scene·이미지·게임 자산 생성은 이 QA 범위가 아니다.
- PR #145, #146, #147은 별도 승인 전 Draft·미병합 상태를 유지한다.

---

## 1. 검증 패키지와 경계

### Package A — AUTOMATED_FIXTURE_PREFLIGHT

repository에 고정된 다음 대표 fixture를 실제 JSON 파일로 읽어 end-to-end 이관한다.

1. `tests/fixtures/afterlife_migration/main_mvp038_investigation.json`
   - 구형 조사 진행
   - 수집 단서와 알 수 없는 ID 포함
   - 기대: `mvp-040`, `migrated_unverified`, 빈 정답 슬롯, orphan 보존, 보상 불변, 재로드 멱등
2. `tests/fixtures/afterlife_migration/main_mvp039_recovery.json`
   - 구형 회수 전투 진행 중
   - 기대: `LEGACY_CASE_RESTART_REQUIRED`, 무페널티 안전 조사 checkpoint, 구형 pattern 비활성
3. `tests/fixtures/afterlife_migration/main_mvp039_completed.json`
   - 완료 보고서·A등급·지급 보상 포함
   - 기대: `legacy_resolution_snapshot`, 보고서·보상 불변, Canon v2 S등급 자동 승격 금지
4. `tests/fixtures/afterlife_migration/validation_v1_active_recovery.json`
   - `validation-save-v1` 진행 중 회수 상태
   - 기대: `validation-save-v2`, route/recovery 구형 의미 제거, 본편 숨은 상태 불변

실행 명령:

```bash
GODOT_BIN=godot GODOT_TEST_TMP="$(mktemp -d)" \
  bash tests/run_afterlife_canon_v2_migration_tests.sh
```

합격 기준:

```text
Afterlife canon v2 migration: 9/9 entrypoints passed
```

이 결과는 representative fixture 자동 사전검증일 뿐이며 실제 사용자 저장·실제 화면·Windows 장애 주입 Human QA를 대체하지 않는다.

### Package B — 실제 사용자 저장 복사본

대상:

- `mvp-038` 본편 저장 복사본 1개 이상
- `mvp-039` 본편 저장 복사본 1개 이상
- 가능하면 조사 중·회수 중·완료 후 상태를 각각 확보
- `validation-save-v1` 복사본 1개 이상

개인정보나 계정 식별 정보가 포함된 저장은 repository에 커밋하지 않는다. QA 증거에는 파일명 대신 익명 식별자와 SHA-256만 기록할 수 있다.

### Package C — Windows 파일 I/O 장애

- 파일 잠금
- temp 작성 후 강제 종료
- primary 승격 후 runtime apply 전 강제 종료
- 디스크 쓰기 실패 시뮬레이션
- 읽기 전용 QA 폴더
- 손상된 JSON
- source checksum 외부 변경

### Package D — UI·접근성·보상

- 안전 재시작 안내
- 구형 기록의 `migrated_unverified` 표현
- 구형 완료 보고서 표시
- 보상 중복 방지
- 1280×720, 1920×1080
- 키보드 포커스·색상 외 상태 표시·접근성 문구

---

## 2. Windows 격리 환경 준비

Godot 프로젝트 이름은 `urban-legend`이며 기본 사용자 데이터는 다음 위치에 생성된다.

```text
%APPDATA%\Godot\app_userdata\urban-legend
```

검증은 실제 `%APPDATA%` 대신 QA 전용 `APPDATA`를 사용한다.

```powershell
$Repo = "C:\projects\urban-legend"
$Commit = "검증할 exact commit SHA"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$QaRoot = Join-Path $env:USERPROFILE "Desktop\urban-legend-qa\$Stamp"
$QaAppData = Join-Path $QaRoot "AppData\Roaming"
$QaUserDir = Join-Path $QaAppData "Godot\app_userdata\urban-legend"
$EvidenceDir = Join-Path $QaRoot "evidence"

New-Item -ItemType Directory -Force -Path $QaUserDir, $EvidenceDir | Out-Null
Set-Location $Repo
git rev-parse HEAD | Tee-Object (Join-Path $EvidenceDir "exact-commit.txt")
```

검증 프로세스에서만 환경 변수를 바꾼다.

```powershell
$PreviousAppData = $env:APPDATA
$env:APPDATA = $QaAppData
```

검증 종료 후 복원한다.

```powershell
$env:APPDATA = $PreviousAppData
```

## 3. 입력 저장 복사와 해시

본편 저장 이름:

```text
urban_legend_save.json
```

Validation 저장 이름:

```text
urban_legend_validation_save.json
```

원본 위치에서 QA 폴더로 복사한다. 원본 저장 파일에서 직접 시험하지 않는다.

```powershell
$SourceMain = Join-Path $PreviousAppData "Godot\app_userdata\urban-legend\urban_legend_save.json"
$SourceValidation = Join-Path $PreviousAppData "Godot\app_userdata\urban-legend\urban_legend_validation_save.json"
$QaMain = Join-Path $QaUserDir "urban_legend_save.json"
$QaValidation = Join-Path $QaUserDir "urban_legend_validation_save.json"

Copy-Item $SourceMain $QaMain -Force
if (Test-Path $SourceValidation) {
    Copy-Item $SourceValidation $QaValidation -Force
}

Get-FileHash $SourceMain -Algorithm SHA256 | Format-List | Out-File (Join-Path $EvidenceDir "source-main-sha256.txt")
Get-FileHash $QaMain -Algorithm SHA256 | Format-List | Out-File (Join-Path $EvidenceDir "qa-main-before-sha256.txt")
if (Test-Path $QaValidation) {
    Get-FileHash $SourceValidation -Algorithm SHA256 | Format-List | Out-File (Join-Path $EvidenceDir "source-validation-sha256.txt")
    Get-FileHash $QaValidation -Algorithm SHA256 | Format-List | Out-File (Join-Path $EvidenceDir "qa-validation-before-sha256.txt")
}
```

복사 직후 원본과 QA 복사본 SHA-256이 다르면 `BLOCKED`로 종료한다.

## 4. 정상 이관 Human QA

### 4.1 실행

```powershell
Set-Location $Repo
godot --editor --path . --verbose *>&1 | Tee-Object (Join-Path $EvidenceDir "godot-normal-migration.log")
```

게임 실행 후 메인 메뉴에서 기존 저장 불러오기를 수행한다.

### 4.2 본편 저장 확인

실행 후 `urban_legend_save.json`에서 다음을 확인한다.

- `save_version == "mvp-040"`
- `content_contract_id == "afterlife-station-canon-v2"`
- `migration_history`가 정확히 한 번 증가
- 조사 단서는 `migrated_unverified`
- 매뉴얼 `filled_slots`는 비어 있음
- 미매핑 ID는 `orphan_legacy_ids`에 보존
- 진행 중 구형 회수는 조사 시작 checkpoint로 이동
- `restart_penalty == 0`
- 완료 보고서는 `legacy_resolution_snapshot.read_only == true`
- 기존 `completed_case_reports`, `granted_reward_ids`, `rewarded_resolution_grades`가 삭제·중복되지 않음

### 4.3 재실행 멱등성

게임을 완전히 종료한 뒤 같은 QA 복사본으로 다시 실행한다.

- `migration_history` 수가 증가하지 않아야 한다.
- 보상 중복이 없어야 한다.
- orphan 기록이 중복되지 않아야 한다.
- 완료 보고서가 Canon v2 첫 클리어로 승격되지 않아야 한다.

## 5. Validation 격리 Human QA

Validation 저장이 있을 때 다음을 확인한다.

- `version == "validation-save-v2"`
- `payload_schema == 2`
- 구형 route·recovery answer 의미는 비활성
- Validation 실행 전후 본편 저장 SHA-256 또는 보호 필드가 변하지 않음
- Validation 저장이 `urban_legend_save.json`을 primary로 사용하지 않음
- Validation resume·save 후에도 본편 campaign, 보상, 동료 신뢰가 변하지 않음

## 6. 장애 주입 절차

모든 장애 주입은 QA 폴더에서만 수행한다.

### 6.1 파일 잠금

별도 PowerShell 창에서 QA 본편 저장을 독점 잠금한다.

```powershell
$QaMain = Join-Path $env:APPDATA "Godot\app_userdata\urban-legend\urban_legend_save.json"
$Locked = [System.IO.File]::Open($QaMain, 'Open', 'ReadWrite', 'None')
Read-Host "파일 잠금 유지 중. 게임에서 불러오기를 실행한 뒤 Enter"
$Locked.Dispose()
```

기대 결과:

- 게임이 crash하지 않음
- 원본 bytes 보존
- 성공한 migration으로 표시하지 않음
- 오류 코드·로그가 남음
- 잠금 해제 후 재시도 가능

### 6.2 PREPARED 상태 강제 종료

다른 PowerShell 창에서 migration journal을 감시한다.

```powershell
$Journal = Join-Path $env:APPDATA "Godot\app_userdata\urban-legend\urban_legend_save.migration.journal.json"
while (-not (Test-Path $Journal)) { Start-Sleep -Milliseconds 50 }
Get-Content $Journal -Raw | Out-File (Join-Path $EvidenceDir "journal-before-kill.json")
Get-Process godot* | Stop-Process -Force
```

재실행 기대 결과:

- `PREPARED` journal은 abort
- primary는 실행 전 bytes와 동일
- temp·backup·journal 정리
- 실패를 성공으로 표시하지 않음

### 6.3 COMMITTED_PENDING_RUNTIME_APPLY 상태 강제 종료

journal 감시 중 `COMMITTED_PENDING_RUNTIME_APPLY` 문자열이 나타날 때 프로세스를 종료한다.

```powershell
while ($true) {
    if (Test-Path $Journal) {
        $JournalText = Get-Content $Journal -Raw
        if ($JournalText -match "COMMITTED_PENDING_RUNTIME_APPLY") {
            $JournalText | Out-File (Join-Path $EvidenceDir "journal-pending-before-kill.json")
            Get-Process godot* | Stop-Process -Force
            break
        }
    }
    Start-Sleep -Milliseconds 50
}
```

재실행 기대 결과:

- backup에서 구형 primary 복원
- 파일·메모리 반쪽 migration 없음
- journal·temp·backup 정리
- 다음 정상 실행에서 migration 재시도 가능

### 6.4 디스크 쓰기 실패

실제 디스크를 채우지 않고 QA 폴더 쓰기 권한을 제거해 디스크 쓰기 실패를 시뮬레이션한다.

```powershell
icacls $QaUserDir /inheritance:r
icacls $QaUserDir /grant:r "$env:USERNAME:(RX)"
```

게임에서 저장 이관을 시도한 뒤 반드시 권한을 복원한다.

```powershell
icacls $QaUserDir /reset /T
```

기대 결과:

- `WRITE_FAILED` 또는 동등한 실패
- primary bytes 보존
- 성공 상태·보상 지급 없음
- 권한 복원 후 정상 재시도 가능

### 6.5 손상 JSON

QA 복사본만 별도 보관한 뒤 마지막 바이트를 제거한다.

```powershell
$Bytes = [System.IO.File]::ReadAllBytes($QaMain)
[System.IO.File]::WriteAllBytes($QaMain, $Bytes[0..($Bytes.Length - 2)])
```

기대 결과:

- 손상 저장을 자동 정답 또는 새 저장으로 해석하지 않음
- crash 없음
- 원본 사용자 저장에는 영향 없음
- 복구 가능한 backup이 있으면 명시적으로 안내

### 6.6 source checksum 외부 변경

검사와 교체 사이에 QA 복사본에 공백 한 바이트를 추가한다. 자동화된 transaction 테스트와 함께 `SOURCE_CHANGED`가 발생해야 한다.

기대 결과:

- 외부 변경된 primary를 덮어쓰지 않음
- temp·journal 정리
- 현재 primary bytes 유지

## 7. UI·접근성 검증

각 해상도에서 정상 이관·안전 재시작·완료 기록 화면을 확인한다.

- 1280×720
- 1920×1080

확인 항목:

- 키보드만으로 불러오기·확인·재시작 가능
- 현재 포커스가 항상 시각적으로 표시됨
- 색상만으로 `migrated_unverified`, 경고, 실패를 구분하지 않음
- 구형 회수 진행은 “무페널티 조사 재시작”으로 설명됨
- 구형 완료 보고서가 Canon v2 정답·S등급으로 오인되지 않음
- 스크린 리더용 의미 텍스트 또는 동등한 접근성 라벨 확인
- 긴 한글 문구 잘림·중첩 없음
- 보상 중복이 UI와 저장 양쪽에서 없음

## 8. 판정 규칙

### PASS

- Package A 자동 fixture 9/9 통과
- 실제 사용자 저장 복사본 정상 이관 통과
- 파일 잠금·강제 종료·디스크 쓰기 실패에서 원본 bytes 보존
- 보상 중복·정답 누설·Validation 오염 없음
- 필수 UI·접근성 항목 통과
- 재현 가능한 로그·해시·스크린샷 존재

### FAIL

- 저장 손실 또는 보호 필드 변경
- 보상 중복 지급
- 구형 단서를 정답으로 자동 승격
- 진행 중 구형 회수 의미를 Canon v2 정답으로 변환
- Validation이 본편 상태를 변경
- 강제 종료 후 반쪽 migration
- 재실행 시 migration effect 중복

### BLOCKED

- 실제 사용자 저장 복사본 미확보
- Windows 10/11 실행 환경 미확보
- exact commit을 재현할 수 없음
- 필요한 빌드 또는 로그 접근 불가

### NOT_RUN

- 절차를 시작하지 않았거나 해당 항목을 실행하지 않음

하나라도 P0 또는 P1 `FAIL`이면 PR Ready 전환과 병합 검토를 중단한다.

## 9. 증거 저장

각 실행은 다음 양식을 복사해 별도 파일로 작성한다.

```text
docs/qa/templates/afterlife-canon-v2-human-qa-evidence-template.md
```

권장 증거 디렉터리:

```text
qa-evidence/afterlife-canon-v2/<exact-sha>/<run-date>/
```

실제 사용자 저장 원본은 repository에 넣지 않는다. 익명화된 실행 후 저장 또는 diff도 개인정보가 없는지 확인한 뒤 별도 승인된 경우에만 첨부한다.

## 10. 현재 Gate

- `AUTOMATED_FIXTURE_PREFLIGHT`: 실행 가능 상태
- 실제 사용자 저장 Human QA: `NOT_RUN`
- Windows 파일 I/O 장애 Human QA: `NOT_RUN`
- UI·접근성 Human QA: `NOT_RUN`
- Human QA 전체 상태: `HUMAN_QA_NOT_RUN`
- PR Ready: 승인되지 않음
- 병합: `MERGE_NOT_AUTHORIZED`
