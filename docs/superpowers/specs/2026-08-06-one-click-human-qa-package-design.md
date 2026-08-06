# One-click Windows Human QA Package Design

- Date: 2026-08-06
- Status: APPROVED_DIRECTION / SPEC_REVIEW_PENDING
- Repository: `alsdmlals4-eng/urban-legend`
- Target base: `main`
- Parent decision: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`
- Related integration: `MERGE-20260806-PR157-CANON-V2-RUNTIME-UX-MAIN`
- User approval: `2026-08-06 15:49 KST / 권장안대로 진행해`

## 1. Purpose

현재 `main`에는 Canon v2 런타임·저장 이관·공용 UX와 안전한 `Prepare → Launch → Collect` PowerShell runner가 포함되어 있다. 그러나 사용자가 저장 경로, Godot 실행 파일, QA root와 각 단계를 직접 입력해야 하므로 실제 Human QA 진입 비용이 높다.

이 작업은 사용자가 저장소의 `main`을 pull한 뒤 저장소 루트의 `START_HUMAN_QA.cmd`를 실행하는 것만으로 다음 흐름을 수행할 수 있게 한다.

1. 환경과 저장 파일을 사전 점검한다.
2. 적합한 Godot 실행 파일을 자동 탐색한다.
3. 실제 저장 원본을 읽기 전용 입력으로 취급하고 격리 복사본을 준비한다.
4. 격리 APPDATA로 Godot 에디터를 실행한다.
5. 사용자가 실제 화면·조작·저장 동작을 검토한다.
6. Godot 종료 후 원본 불변성과 QA 산출물을 수집한다.
7. 저장 본문이나 절대 경로를 노출하지 않는 Human QA 결과 요약을 생성한다.

이 패키지는 실제 화면을 자동으로 PASS 판정하지 않는다. 사람의 관찰이 필요한 항목은 사용자가 직접 `PASS / FAIL / BLOCKED / NOT_RUN`으로 기록한다.

## 2. Selected Approach

### 2.1 Recommended architecture

기존 `tools/qa/run_afterlife_canon_v2_human_qa.ps1`을 안전 경계와 저장 처리의 단일 권위 구현으로 유지한다. 새 패키지는 기존 runner를 복제하거나 재작성하지 않고, 다음 두 개의 얇은 진입 계층만 추가한다.

- `START_HUMAN_QA.cmd`
  - 저장소 루트에서 더블클릭 가능한 Windows 진입점
  - PowerShell 실행 정책과 UTF-8 콘솔 설정을 안전하게 구성
  - 실제 오케스트레이터를 호출하고 종료 코드를 보존
- `tools/qa/start_afterlife_canon_v2_human_qa.ps1`
  - 환경 탐색, 사용자 안내, 기존 runner 단계 연결, Human checklist 기록 담당
  - 원본 저장 복사·해시·격리 APPDATA 로직은 직접 구현하지 않고 기존 runner에 위임

이 구조를 선택하는 이유는 기존 검증된 저장 안전 계약을 유지하면서 사용자 경험만 단순화할 수 있기 때문이다.

### 2.2 Rejected alternatives

#### 기존 runner에 모든 기능을 직접 추가

단일 파일은 편하지만 저장 안전 로직과 대화형 UI가 결합되어 회귀 위험과 테스트 복잡도가 커진다. 기존 runner는 자동화 가능한 순수 단계 엔진으로 유지한다.

#### Godot을 자동 다운로드하고 설치

사용자 개입이 줄지만 외부 네트워크·실행 파일 신뢰·백신·다운로드 무결성·설치 위치 문제를 새로 만든다. 이번 범위에서는 자동 다운로드하지 않는다.

#### 실제 Human QA를 완전 자동 판정

패널 겹침, 텍스트 가독성, 게임패드 포커스와 체감은 자동 테스트만으로 확정할 수 없다. 자동화 결과와 사람 판정을 명시적으로 분리한다.

## 3. User Experience

### 3.1 Normal path

사용자는 `main`을 pull한 뒤 저장소 루트에서 `START_HUMAN_QA.cmd`를 실행한다.

정상 환경에서는 별도 경로 입력 없이 다음 순서로 진행된다.

1. 저장소 및 `project.godot` 확인
2. 브랜치·HEAD·dirty working tree 표시
3. 본편 저장과 선택적 Validation 저장 탐색
4. Godot 4.7.1 탐색 및 버전 확인
5. Desktop 아래 timestamp 기반 QA root 생성
6. 기존 runner의 `Prepare` 실행
7. 기존 runner의 `Launch -WaitForExit` 실행
8. 콘솔에 Human checklist 표시
9. Godot 종료 뒤 항목별 상태 입력
10. 기존 runner의 `Collect` 실행
11. 개인정보 비포함 결과 요약 생성
12. evidence 폴더 위치와 다음 조치 표시

### 3.2 Interaction rules

- 정상 경로에서 사용자는 파일 경로를 직접 입력하지 않는다.
- Godot 후보가 여러 개이면 4.7.1을 우선 자동 선택한다.
- 동일 우선순위 후보가 여러 개이면 번호 선택만 요청한다.
- Godot을 찾지 못하면 전체 경로를 붙여넣을 기회를 제공하고, 취소하면 아무 저장도 변경하지 않고 종료한다.
- 본편 저장이 없으면 QA를 시작하지 않고 새 게임 저장을 먼저 만들라는 안내만 출력한다.
- Validation 저장은 없어도 정상 진행한다.
- dirty working tree는 경고하되 제품 파일을 수정하지 않으므로 기본적으로 진행 가능하다. 단, runner·project 파일이 변경된 경우에는 명확히 경고하고 재확인을 요구한다.

## 4. Godot Discovery and Compatibility

탐색 순서는 결정적이어야 한다.

1. 명시적 `-GodotBinary` 매개변수
2. `GODOT_BINARY` 환경변수
3. `Get-Command godot`, `godot4`, `Godot`
4. 저장소의 허용된 로컬 도구 경로
5. Windows App Paths registry의 사용자·시스템 항목
6. 일반적인 설치 위치와 사용자의 Downloads/Desktop에 있는 `Godot*.exe`

재귀 검색 범위는 제한하여 긴 전체 디스크 검색을 피한다.

발견된 실행 파일은 `--version`으로 검증한다.

- 기본 허용: `4.7.1.stable`
- 다른 4.7.x: 경고 후 명시적 사용자 승인 필요
- 4.7 미만 또는 5.x 이상: 기본 차단
- 테스트에서는 `-AllowVersionMismatch`를 명시해야만 우회 가능

자동 다운로드, 설치, PATH 영구 변경은 수행하지 않는다.

## 5. Data and Privacy Boundaries

### 5.1 Original saves

기존 runner 계약을 그대로 유지한다.

- 원본 저장은 읽기 전용 입력으로 취급한다.
- 원본과 QA destination이 같으면 즉시 중단한다.
- QA root 내부의 파일을 원본으로 지정할 수 없다.
- Prepare 직후 복사본 SHA-256이 원본과 다르면 중단한다.
- Collect 시 원본 SHA-256을 다시 확인한다.
- 원본이 바뀌었으면 `SOURCE_MUTATED_AFTER_PREPARE`로 실패한다.

### 5.2 Local-only files

다음은 외부 공유와 Git 커밋을 금지한다.

- `<QA_ROOT>/.control/**`
- `<QA_ROOT>/AppData/**`
- 실제 저장 원본
- 저장 본문을 포함하는 모든 파일

### 5.3 Shareable evidence

기본 공유 가능 범위는 다음으로 제한한다.

- 익명 ID
- 파일 크기
- SHA-256
- 상대 QA 경로
- 프로세스 종료 코드
- checklist 상태
- 오류 코드
- 검증한 repository HEAD

로그는 자동으로 공유 가능 판정하지 않는다. 결과 화면에서 개인정보 검토가 필요하다고 표시한다.

## 6. Human QA Checklist

checklist는 코드에 흩어진 문자열이 아니라 별도 권위 데이터로 둔다.

권장 파일:

- `tools/qa/afterlife_canon_v2_human_qa_checklist.json`

필수 항목:

1. 기존 저장 불러오기
2. 안전 재시작 또는 이관 안내
3. `migrated_unverified`의 의미가 과장 없이 표시됨
4. Canon v2 규칙 스트립 표시
5. 보호 의무의 `critical / urgent / watch` 상태 구분
6. 관찰·증거 보존 행동은 불필요한 확인 없이 진행
7. 위험·책임 행동은 의미·위험·대안 확인 후 진행
8. 회수 확정 전 종결 미리보기 표시
9. 결과 화면의 현상 통제·보호 책임·증거 무결성·후속 실행·숙련 평가 분리
10. 완료 보고서와 기존 보상 불변
11. 동일 비용·의무·후속·보상의 중복 적용 없음
12. Validation 저장과 본편 저장 격리
13. 1280×720 화면 겹침·잘림 없음
14. 1920×1080 화면 겹침·잘림 없음
15. 키보드 포커스 이동 가능
16. 게임패드 포커스와 확인·취소 가능
17. 색상 외 텍스트·아이콘으로 상태 식별 가능
18. 게임 종료·재실행 뒤 저장 복원 정상

각 항목은 다음 값만 허용한다.

- `PASS`
- `FAIL`
- `BLOCKED`
- `NOT_RUN`

선택적 메모는 로컬 파일에만 기록하며, 저장 본문이나 개인정보를 붙여넣지 말라는 경고를 함께 표시한다.

## 7. State Machine

오케스트레이터는 다음 상태만 사용한다.

```text
PREFLIGHT
→ READY
→ PREPARED
→ LAUNCHED
→ HUMAN_REVIEW_RECORDED
→ EVIDENCE_COLLECTED
→ COMPLETE
```

실패 상태:

```text
BLOCKED_NO_MAIN_SAVE
BLOCKED_GODOT_NOT_FOUND
BLOCKED_GODOT_VERSION
PREPARE_FAILED
LAUNCH_FAILED
SOURCE_MUTATED
COLLECT_FAILED
USER_CANCELLED
```

중간 상태는 `<QA_ROOT>/.control/launcher-state.local.json`에 저장한다. 이 파일은 절대 경로를 포함할 수 있으므로 공유·커밋 금지 대상이다.

재실행 시 기존 미완료 QA root를 자동으로 덮어쓰지 않는다. 새 timestamp root를 만들거나 사용자가 명시적으로 기존 root 재개를 선택해야 한다.

## 8. Result Summary

최종 결과는 `<QA_ROOT>/evidence/human-qa-summary.json`과 사람이 읽는 `<QA_ROOT>/evidence/HUMAN_QA_SUMMARY.md`로 생성한다.

필수 내용:

- repository와 exact HEAD
- 실행 시각
- Godot 버전
- 원본 불변 확인 상태
- 자동 runner 상태
- checklist별 상태
- PASS/FAIL/BLOCKED/NOT_RUN 집계
- 개인정보 검토 필요 경고
- 전체 분류

전체 분류 규칙:

- 모든 항목 PASS: `HUMAN_QA_REVIEW_COMPLETE_PASS`
- 하나 이상의 FAIL: `HUMAN_QA_REVIEW_COMPLETE_FAIL`
- FAIL은 없지만 BLOCKED 존재: `HUMAN_QA_REVIEW_BLOCKED`
- NOT_RUN 존재: `HUMAN_QA_INCOMPLETE`
- 자동 수집 실패: 사람 판정과 별도로 `AUTOMATED_EVIDENCE_COLLECTION_FAILED`

이 분류는 GitHub PR merge 승인이나 제품 출시 승인을 자동으로 부여하지 않는다.

## 9. Error Handling

- 모든 종료 경로에서 호출 PowerShell의 원래 `APPDATA`를 복원한다.
- `.cmd`는 PowerShell 종료 코드를 그대로 반환한다.
- 기존 runner 오류 코드는 감추지 않고 사용자 친화적 설명과 함께 출력한다.
- Godot 프로세스가 비정상 종료해도 가능한 경우 Collect를 제안하되, 자동으로 PASS 처리하지 않는다.
- 콘솔이 닫히기 전에 결과와 로그 위치를 표시하고 사용자의 확인 입력을 기다린다.
- 예외 발생 시 실제 저장 내용, 절대 원본 경로와 `.control` 내용은 콘솔 요약에 출력하지 않는다.

## 10. Implementation Scope

예상 변경 파일:

- `START_HUMAN_QA.cmd`
- `tools/qa/start_afterlife_canon_v2_human_qa.ps1`
- `tools/qa/afterlife_canon_v2_human_qa_checklist.json`
- `tools/qa/run_afterlife_canon_v2_human_qa.ps1`
  - 기존 안전 계약을 유지하는 최소 확장만 허용
- `docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner.md`
- `docs/qa/2026-08-06-one-click-human-qa-package.md`
- `tests/test_afterlife_canon_v2_one_click_human_qa.py`
- `tests/windows/run_afterlife_canon_v2_one_click_preflight.ps1`
- 기존 Windows QA workflow 또는 별도 focused workflow

기존 runner를 변경해야 하는 경우 공개 매개변수 호환성을 유지한다.

## 11. Test Strategy

### 11.1 TDD contract tests

먼저 실패하는 계약 테스트를 추가한다.

- `.cmd` 진입점 존재와 올바른 PowerShell 호출
- 오케스트레이터와 checklist 파일 존재
- 기존 runner 위임 계약
- 공유 금지 경로와 privacy 문구
- 상태·오류 코드 집합
- 결과 분류 규칙
- 문서와 실제 파일 경로 일치

### 11.2 Windows integration tests

GitHub-hosted Windows에서 실제 PowerShell 5.1 및 PowerShell 7 호환성을 검증한다.

테스트용 임시 저장과 fake Godot executable을 사용해 다음을 확인한다.

- 정상 Godot 탐색
- 다중 후보 우선순위
- 버전 불일치 차단
- 본편 저장 없음 차단
- Prepare → fake Launch → Collect 흐름
- 원본 SHA-256 불변
- Validation 저장 선택 처리
- 사용자 취소
- 실패 시 APPDATA 복원
- 결과 요약에 절대 원본 경로와 저장 본문이 없음

### 11.3 Regression

- 기존 local runner 계약 전체
- Canon v2 migration focused suite
- Canon v2 runtime UX suite
- full Godot regression
- Project Base Adapter
- Windows·Ubuntu Python matrix

## 12. Acceptance Criteria

다음 조건을 모두 충족해야 구현 완료로 본다.

1. 사용자는 최신 `main`을 pull한 뒤 `START_HUMAN_QA.cmd`를 실행할 수 있다.
2. 정상적인 Godot 4.7.1 설치와 기존 본편 저장이 있으면 저장·Godot 경로를 직접 입력하지 않고 QA를 시작할 수 있다.
3. 원본 저장은 Prepare 전후와 Collect 시점에 SHA-256 불변이 검증된다.
4. Godot은 격리 APPDATA에서 실행된다.
5. 사용자가 Human checklist를 기록하기 전에는 Human QA가 PASS로 표시되지 않는다.
6. 결과 요약에는 저장 본문과 원본 절대 경로가 없다.
7. Windows PowerShell 5.1과 PowerShell 7 테스트가 통과한다.
8. 기존 runner의 공개 사용법과 저장 안전 계약이 깨지지 않는다.
9. full Godot regression과 Project Base Adapter가 통과한다.
10. PR은 검증 증거와 exact HEAD를 기록하며, 별도 승인 전에는 `main`에 병합하지 않는다.

## 13. Out of Scope

- Godot 자동 다운로드·설치·업데이트
- 실제 사용자 저장을 GitHub, CI, ChatGPT 또는 repository에 업로드
- 화면 이미지 자동 판독으로 Human QA를 대체
- Windows 10/11 실제 기기 판정을 GitHub-hosted runner 결과로 대체
- 제품 런타임·게임 밸런스·기획 내용 변경
- Human QA 결과에 따른 자동 PR merge 또는 출시 승인
- 기존 저장 삭제·정리·복구를 위한 범용 도구

## 14. Delivery Workflow

1. 이 설계 문서를 별도 브랜치와 Draft PR에 커밋한다.
2. 사용자 문서 검토 승인을 받는다.
3. 상세 구현 계획을 작성하고 커밋한다.
4. TDD RED를 먼저 기록한다.
5. 구현과 Windows integration test를 진행한다.
6. 적대적 검토로 경로·개인정보·원본 변경·버전 오탐을 재감사한다.
7. 전체 CI GREEN과 exact HEAD를 기록한다.
8. 별도 main 병합 승인 후 병합한다.
9. 사용자는 로컬 `main`에서 `git pull --ff-only origin main`만 수행한다.
