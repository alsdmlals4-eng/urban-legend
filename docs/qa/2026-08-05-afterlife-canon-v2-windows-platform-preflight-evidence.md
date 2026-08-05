# 저승역 Canon v2 Windows 플랫폼 사전검증 증거

- Decision: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`
- Gate: `WINDOWS_PLATFORM_PREFLIGHT`
- 자동 분류: `AUTOMATED_PLATFORM_PREFLIGHT_PENDING`
- 실제 사용자 저장: `ACTUAL_USER_SAVE_NOT_AVAILABLE`
- 실제 Human QA: `HUMAN_QA_NOT_RUN`
- UI·접근성: `UI_ACCESSIBILITY_NOT_RUN`
- 병합: `MERGE_NOT_AUTHORIZED`

## 목적

GitHub-hosted `windows-latest`에서 Godot의 Windows `user://` 저장 위치를 격리된 `APPDATA` 아래에 만들고, 다음 파일 시스템 경계를 자동으로 재현한다.

1. Windows 독점 파일 잠금
2. `PREPARED` journal 기록 직후 프로세스 강제 종료
3. `COMMITTED_PENDING_RUNTIME_APPLY` 기록 직후 프로세스 강제 종료
4. source checksum 외부 변경
5. deterministic write failure
6. Windows ACL 쓰기 거부
7. 복구 후 원본 SHA-256 일치

## 벤치마크 반영

- GitHub Actions: Windows job은 `runs-on: windows-latest`로 격리 실행한다.
- PowerShell: `Get-FileHash -Algorithm SHA256`으로 원본과 복구본을 비교한다.
- Godot: Windows의 `user://`는 격리 `APPDATA` 아래 `Godot/app_userdata/urban-legend`로 해석한다.
- 파일 잠금: .NET `FileStream`을 `FileShare.None`으로 열어 다른 프로세스 접근을 차단한다.

## 자동 검증과 Human QA 경계

`AUTOMATED_PLATFORM_PREFLIGHT`은 GitHub-hosted Windows runner의 합성 fixture 검증이다. 다음을 증명하지 않는다.

- 실제 장기간 사용자 저장의 호환성
- Windows 10 실제 사용자 PC
- Windows 11 실제 사용자 PC
- OneDrive·백신·동기화 프로그램의 경쟁 조건
- 실제 디스크 용량 고갈
- 실제 화면 문구·포커스·컨트롤러 조작
- 1280×720·1920×1080 UI 가독성
- 색각·청각·스크린리더 접근성

따라서 자동 결과가 GREEN이어도 상태는 다음을 유지한다.

```text
ACTUAL_USER_SAVE_NOT_AVAILABLE
/ HUMAN_QA_NOT_RUN
/ UI_ACCESSIBILITY_NOT_RUN
/ MERGE_NOT_AUTHORIZED
```

## TDD 증거

### RED

- PR #148 초기 HEAD: `56f21e6044d8c6e1e31bcd333a16903c0d568b70`
- Migration run: `31003493733`
- 기존 Design 10, Plan 11, Runner 4, Implementation evidence 4, Human QA plan 5 tests: PASS
- Windows platform contract: `1 failure / 5 errors`
- 실패 원인: Windows workflow·PowerShell harness·phase test·locked-file test·evidence 부재

### GREEN

현재 상태: `AUTOMATED_PLATFORM_PREFLIGHT_PENDING`

GREEN 확정 시 다음을 기록한다.

- exact HEAD
- Windows workflow run ID
- Migration·ANNUAL 회귀 run ID
- SHA-256 원본·복구 일치
- 독점 잠금 결과 코드
- PREPARED 복구 결과
- COMMITTED_PENDING_RUNTIME_APPLY 복구 결과 `ROLLBACK_RESTORED`
- source race 결과 `SOURCE_CHANGED`
- 쓰기 실패 결과 `WRITE_FAILED`
- failure artifact 보존 여부

## 플랫폼 행렬

| 대상 | 상태 | 판정 |
|---|---|---|
| GitHub-hosted Windows runner | `PENDING` | 자동 플랫폼 사전검증 |
| Windows 10 실제 PC | `NOT_RUN` | Human QA 필요 |
| Windows 11 실제 PC | `NOT_RUN` | Human QA 필요 |
| 실제 사용자 저장 복사본 | `NOT_AVAILABLE` | 사용자 파일 필요 |
| UI·접근성 | `NOT_RUN` | 실제 플레이 필요 |

## 금지 범위

- 사용자 저장 원본 직접 수정 금지
- 합성 fixture를 실제 사용자 저장 검증으로 표현 금지
- Windows CI를 Windows 10·11 Human QA로 표현 금지
- 자동 플랫폼 사전검증을 UI·접근성 검증으로 표현 금지
- 별도 승인 전 PR Ready·병합 금지
