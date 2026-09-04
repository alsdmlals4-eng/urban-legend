# 저승역 Canon v2 로컬 Human QA Runner 사전검증 증거

- Parent Decision: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`
- Gate: `LOCAL_HUMAN_QA_RUNNER_PREFLIGHT`
- 현재 자동 상태: `AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN`
- 검증된 구현 HEAD: `652efecbb9e4dfbd7a388bc894983cd8f0cc08a9`
- 실제 사용자 저장: `ACTUAL_USER_SAVE_NOT_AVAILABLE`
- 실제 Human QA: `HUMAN_QA_NOT_RUN`
- UI·접근성: `UI_ACCESSIBILITY_NOT_RUN`
- 병합: `MERGE_NOT_AUTHORIZED`

## 목적

실제 사용자 저장을 외부에 업로드하지 않고 로컬 Windows PC에서 안전한 복사본을 만들고, SHA-256·격리 APPDATA·Godot 실행·증거 수집을 재현 가능하게 한다.

## 개인정보·원본 보호 계약

- 저장 본문은 manifest·문서·CI artifact에 포함하지 않는다.
- 공유 가능한 manifest에는 익명 ID·크기·SHA-256·상대 QA 경로만 기록한다.
- 원본 절대 경로는 `<QA_ROOT>/.control/source-map.local.json`에만 기록하며 외부 공유를 금지한다.
- 원본은 copy-only이며 이동·삭제·덮어쓰기를 수행하지 않는다.
- Prepare와 Collect에서 원본 SHA-256을 비교한다.
- source/destination 경로가 같으면 `SOURCE_AND_QA_PATH_COLLISION`으로 중단한다.
- source가 QA root 안에 있으면 `SOURCE_INSIDE_QA_ROOT`로 중단한다.
- 원본이 Prepare 이후 변경되면 `SOURCE_MUTATED_AFTER_PREPARE`로 중단한다.

## TDD RED

### RED 1 — runner 산출물 부재

- Draft PR: `#149`
- RED exact HEAD: `fe9ea53011fd61c3e7bd9801182d15c24d1e1120`
- Migration run: `31007255047`
- 기존 Design 10, Plan 11, Runner 4, Implementation evidence 4, Human QA plan 5, Windows platform 8 tests: PASS
- 신규 local runner contract: `2 failures / 5 errors`
- 실패 원인: runner·전용 guide/evidence/addendum 부재와 독립 Windows workflow 미연결
- 기존 제품 runtime·migration 회귀 실패가 아니라 새 산출물 부재만 검출

### RED 2 — GREEN 결과 기록 부재

- 상태 계약 HEAD: `3a1f94888957c6ada49d65994003eead3bec2070`
- Migration run: `31008963222`
- 기존 runner·Windows 실행 계약은 통과했으나 evidence와 Addendum에 검증 HEAD·run ID·현재 GREEN 상태가 없어 신규 결과 계약 1건만 FAIL

## 구현 계약

### Prepare

- 입력: `SourceMain`, 선택적 `SourceValidation`, 선택적 `QaRoot`
- 기본 QA root: Desktop의 timestamp 폴더
- 격리 경로: `<QA_ROOT>/AppData/Roaming/Godot/app_userdata/urban-legend`
- 원본과 복사본 SHA-256 일치 필수
- `manifest.json`과 로컬 전용 `.control/source-map.local.json` 분리
- 공유 manifest privacy boundary: `ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED`

### Launch

- 기존 manifest·control 존재 필수
- 호출 PowerShell의 `APPDATA`를 저장
- QA APPDATA를 자식 Godot 프로세스에 상속
- `finally`에서 호출 PowerShell의 `APPDATA` 복원
- 로그는 QA root의 `logs`에 기록

### Collect

- 원본 SHA-256 재확인
- QA 저장·transaction artifact의 이름·크기·SHA-256 기록
- 저장 본문 미기록
- 자동 출력은 `EVIDENCE_COLLECTED / HUMAN_REVIEW_REQUIRED`
- 실제 Human QA를 자동 PASS로 전환하지 않음

## GREEN 증거

검증된 구현 HEAD:

`652efecbb9e4dfbd7a388bc894983cd8f0cc08a9`

- Documentation `31008696028`: SUCCESS
- Independent Windows `31008696020`: SUCCESS
- Migration Ubuntu+Windows `31008696047`: SUCCESS
- ANNUAL/Godot `31008696037`: SUCCESS
- Canon v2 focused suite: PASS
- full Godot regression: PASS
- failure artifact: 생성되지 않음 — GREEN 실행에 실패 단계 없음

Windows 두 job에서 repository 대표 fixture를 사용해 실제 PowerShell runner `Prepare → Collect`를 수행했다.

검증된 출력 마커:

```text
PREPARED
EVIDENCE_COLLECTED
HUMAN_REVIEW_REQUIRED
ACTUAL_USER_SAVE_CONTENT_NOT_RECORDED
LOCAL HUMAN QA RUNNER PREFLIGHT: PASS
```

검증 결과:

- Prepare 전후 source SHA-256 불변
- QA 복사본 SHA-256이 source와 일치
- Collect 시 source SHA-256 재확인 통과
- manifest 상태 `EVIDENCE_COLLECTED`
- manifest 분류 `AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN`
- 공유 manifest에 저장 본문·원본 절대 경로 없음
- 기존 Windows lock/crash/ACL preflight와 전체 Godot 회귀 유지

## 경계

자동 runner preflight는 합성 fixture를 사용한다. 다음을 증명하지 않는다.

- 실제 장기간 사용자 저장 호환성
- Windows 10 실제 사용자 PC
- Windows 11 실제 사용자 PC
- OneDrive·백신·동기화 경쟁 조건
- 실제 UI·포커스·컨트롤러·접근성
- Human QA PASS
- 병합 승인

현재 상태:

```text
AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN
/ ACTUAL_USER_SAVE_NOT_AVAILABLE
/ HUMAN_QA_NOT_RUN
/ UI_ACCESSIBILITY_NOT_RUN
/ MERGE_NOT_AUTHORIZED
```