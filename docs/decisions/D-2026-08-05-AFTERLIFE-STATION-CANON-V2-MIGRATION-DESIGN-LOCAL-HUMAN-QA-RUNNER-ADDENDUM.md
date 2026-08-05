# D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN — Local Human QA Runner Addendum

- Parent Decision: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`
- 사용자 승인: `2026-08-05 21:37 KST / 실제 사용자 저장 기반 Human QA 진행 승인`
- Draft PR: `#149`
- 현재 상태: `AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_PENDING / ACTUAL_USER_SAVE_NOT_AVAILABLE / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / MERGE_NOT_AUTHORIZED`
- exact-head CI 통과 후 허용 상태: `AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN`

## 결정

실제 사용자 저장은 GitHub·CI artifact·ChatGPT·repository로 업로드하지 않는다. Human QA는 사용자 Windows PC에서 원본을 읽기 전용 입력으로 삼아 QA 전용 복사본을 생성하고, 다음 3단계 runner로 실행한다.

```text
Prepare → Launch → Collect
```

### Prepare

- 원본 본편 저장과 선택적 Validation 저장 경로를 입력받는다.
- 기본 QA root는 repository 밖 Desktop timestamp 폴더다.
- QA APPDATA 아래로 `Copy-Item`만 수행한다.
- 원본과 복사본 SHA-256이 다르면 실패 폐쇄한다.
- source와 QA destination이 같은 경로면 실패한다.
- 공유 manifest에는 저장 본문과 원본 절대 경로를 기록하지 않는다.
- 원본 절대 경로는 로컬 전용 `.control` 파일에만 기록한다.

### Launch

- 격리 APPDATA를 자식 Godot 프로세스에만 적용한다.
- 호출 PowerShell의 APPDATA는 `finally`에서 복원한다.
- runner는 UI·접근성·보상 상태를 자동 PASS로 판정하지 않는다.

### Collect

- Prepare 시점 원본 SHA-256과 현재 원본 SHA-256을 재비교한다.
- 원본이 바뀌었으면 `SOURCE_MUTATED_AFTER_PREPARE`로 실패한다.
- QA 저장과 transaction artifact의 이름·크기·SHA-256만 수집한다.
- 상태는 `EVIDENCE_COLLECTED / HUMAN_REVIEW_REQUIRED`로 끝난다.

## 자동 검증

GitHub-hosted Windows runner에서는 repository 대표 fixture로 `Prepare → Collect`만 실행한다. 이 자동 결과는 runner 안전 계약만 검증한다.

자동 GREEN 상태:

```text
AUTOMATED_LOCAL_HUMAN_QA_RUNNER_PREFLIGHT_GREEN
```

자동 GREEN이 증명하지 않는 항목:

- 실제 사용자 저장 호환성
- Windows 10/11 실제 PC
- UI·포커스·컨트롤러·접근성
- OneDrive·백신·동기화 경쟁 조건
- Human QA PASS
- 병합 승인

## 권위와 증거 연결

- 구현·실행 가이드·자동 계약·증거 문서는 Draft PR `#149`의 변경 집합으로 관리한다.
- 현재 Decision은 완료 QA 파일 경로를 직접 참조하지 않고 PR 번호, exact HEAD, workflow run ID와 적대적 review ID만 권위 증거로 사용한다.
- 최종 GREEN 전환 시 이 Addendum에는 exact HEAD와 run ID만 기록한다.
- 실제 사용자 저장 본문, 로컬 절대 경로, `.control` 파일은 권위 문서나 CI artifact에 기록하지 않는다.

## 유지하는 상태 경계

```text
ACTUAL_USER_SAVE_NOT_AVAILABLE
/ HUMAN_QA_NOT_RUN
/ UI_ACCESSIBILITY_NOT_RUN
/ MERGE_NOT_AUTHORIZED
```

별도 실제 evidence 검토와 사용자 결과 승인 전 Human QA 상태를 변경하지 않는다. 별도 병합 승인 전 PR #145~#149를 Ready 또는 merge로 전환하지 않는다.