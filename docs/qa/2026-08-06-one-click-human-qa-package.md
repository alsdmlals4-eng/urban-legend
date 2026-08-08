# Canon v2 원클릭 Windows Human QA

## 일반 사용 경로

1. GitHub의 `main`을 pull한다.
2. 실행 중인 Godot을 완전히 종료한다.
3. 저장소 루트의 `START_HUMAN_QA.cmd`를 더블클릭한다.
4. 화면에 먼저 표시되는 18개 검사항목을 확인한다.
5. 격리된 Godot 에디터에서 실제 저장·화면·조작을 검토한다.
6. Godot을 종료한 뒤 각 항목을 `PASS`, `FAIL`, `BLOCKED`, `NOT_RUN`으로 기록한다.
7. Desktop의 `urban-legend-qa/<timestamp>/evidence` 결과를 확인한다.

정상 사용에서는 저장 경로, QA 경로, PowerShell 명령을 직접 입력할 필요가 없다. `START_HUMAN_QA.cmd`는 PowerShell 7의 `pwsh.exe`를 우선 사용하고, 없으면 Windows PowerShell 5.1의 `powershell.exe`를 사용한다.

## 자동으로 수행되는 작업

- 현재 저장소와 `project.godot` 확인
- 본편 저장 자동 탐색
- 선택적 Validation 저장 자동 탐색
- Godot 후보 탐색 및 `4.7.1` 버전 확인
- 원본 저장 SHA-256 계산
- Desktop 아래 격리 QA root 생성
- 기존 안전 runner의 `Prepare` 실행
- 격리 `APPDATA`에서 Godot 실행
- Godot 종료 후 사람 판정 입력
- 기존 안전 runner의 `Collect` 실행
- 개인정보 비포함 Human QA 요약 생성

Godot은 자동 다운로드하거나 설치하지 않는다. PATH를 영구 변경하지 않으며 전체 디스크를 재귀 검색하지 않는다.

## 저장이 없을 때

본편 저장이 없으면 `BLOCKED_NO_MAIN_SAVE`로 종료한다. 일반 게임을 한 번 실행해 저장을 만든 뒤 다시 `START_HUMAN_QA.cmd`를 실행한다.

Validation 저장은 선택 사항이다. Validation 저장이 없어도 본편 Human QA는 진행된다.

## Godot 탐색

다음 순서로 후보를 찾는다.

1. 명시적으로 전달한 `-GodotBinary`
2. `GODOT_BINARY` 환경변수
3. `godot`, `godot4`, `Godot` 명령
4. Windows App Paths registry
5. 저장소 `.tools/godot`, `%LOCALAPPDATA%\Programs`, Downloads, Desktop의 제한된 범위

기본 허용 버전은 `4.7.1`이다. 다른 버전은 기본 차단되며 전문가가 `-AllowVersionMismatch`를 명시한 경우에만 진행된다.

## Human QA 상태

각 항목은 다음 네 값만 사용한다.

- `PASS`: 실제 확인을 완료했고 문제가 없다.
- `FAIL`: 재현 가능한 문제가 있다.
- `BLOCKED`: 환경이나 선행 조건 때문에 판정할 수 없다.
- `NOT_RUN`: 확인하지 않았다.

빈 입력은 `NOT_RUN`으로 기록된다. CI와 자동 runner는 항목을 자동으로 `PASS` 처리하지 않는다.

## 전체 분류

- 모든 항목 PASS: `HUMAN_QA_REVIEW_COMPLETE_PASS`
- 하나 이상의 FAIL: `HUMAN_QA_REVIEW_COMPLETE_FAIL`
- FAIL은 없지만 BLOCKED 존재: `HUMAN_QA_REVIEW_BLOCKED`
- NOT_RUN 존재: `HUMAN_QA_INCOMPLETE`
- 자동 수집 실패: `AUTOMATED_EVIDENCE_COLLECTION_FAILED`

이 분류는 GitHub 병합이나 출시를 자동 승인하지 않는다.

## 검사항목 범위

- 기존 저장 불러오기
- 안전 재시작 또는 이관 안내
- `migrated_unverified` 의미
- Canon v2 규칙 스트립
- 보호 의무 `critical / urgent / watch`
- 관찰·증거 보존 행동의 불필요한 확인 제거
- 위험·책임 행동의 의미·위험·대안 확인
- 회수 확정 전 종결 미리보기
- 독립 결과 축
- 완료 보고서·보상 불변
- 중복 비용·의무·후속·보상 차단
- Validation 저장 격리
- 1280x720 레이아웃
- 1920x1080 레이아웃
- 키보드 포커스
- 게임패드 포커스
- 색상 외 상태 단서
- 종료·재실행 뒤 저장 복원

## 생성 파일

공유 전 검토 가능한 기본 evidence:

```text
<QA_ROOT>\evidence\manifest.json
<QA_ROOT>\evidence\collection-summary.json
<QA_ROOT>\evidence\human-qa-summary.json
<QA_ROOT>\evidence\HUMAN_QA_SUMMARY.md
```

로그는 개인정보가 포함되지 않았는지 사용자가 직접 확인한 뒤에만 공유한다.

공유·업로드·커밋 금지:

```text
<QA_ROOT>\.control\**
<QA_ROOT>\AppData\**
실제 사용자 저장 원본
저장 본문을 포함한 모든 파일
검토하지 않은 logs\**
```

`.control`에는 원본 절대 경로가 포함될 수 있다. `AppData`에는 실제 저장 복사본이 있으므로 외부로 전달하면 안 된다.

## 실패와 재시도

- `BLOCKED_GODOT_NOT_FOUND`: Godot 실행 파일을 찾을 수 없다.
- `BLOCKED_GODOT_VERSION`: 허용 버전이 아니다.
- `PREPARE_FAILED`: 안전 복사·해시 검증에 실패했다.
- `LAUNCH_FAILED`: Godot 실행이 실패했다.
- `SOURCE_MUTATED`: QA 중 원본 저장의 SHA-256이 바뀌었다.
- `COLLECT_FAILED`: 결과 수집이 실패했다.
- `USER_CANCELLED`: 사용자가 실행 전 취소했다.

미완료 QA root를 자동으로 덮어쓰지 않는다. 기본적으로 새 timestamp 폴더를 만들고 다시 실행한다.

## 전문가·복구 경로

세 단계를 직접 제어해야 하는 경우 기존 문서를 사용한다.

```text
docs/qa/2026-08-05-afterlife-canon-v2-local-human-qa-runner.md
```

그 문서에는 `-Stage Prepare`, `-Stage Launch`, `-Stage Collect`의 수동 실행법이 유지된다.

## 2026-08-08 current-main 자동 사전검증

이 절은 원클릭 Human QA 패키지를 최신 통합 상태에서 다시 검증하기 위한 **자동 사전검증 기록**이다. 사람 판정을 대체하지 않는다.

```yaml
base_main: fa69a77a14f923a756064f6ae151d34cadb374f7
project_main_baseline: 068f5da111d963afd244c4fd3319dda768f785c2
pr: 174
first_verified_head: 37057ae2b7c28f8a615ce5c8c9333ca7225c93bd
automated_windows_preflight: PASS
windows_platform_run_31252327145: PASS
canon_v2_migration_run_31252327156: PASS
core_docs_run_31252327162: PASS
documentation_run_31252327150: PASS
base_adapter_run_31252327141: PASS
bca_run_31252327139: PASS
final_exact_head_evidence: PR_174_AND_GOOGLE_SHEET
human_qa: NOT_RUN
ui_human_validation: NOT_RUN
android_validation: NOT_RUN
product_asset_approved_count: 0
image_product_promotion: BLOCKED
```

검증 대상은 기존 workflow `.github/workflows/validate-afterlife-station-canon-v2-windows-platform-qa.yml`이다. Windows runner에서 runner Prepare/Collect, 원본 SHA 불변, privacy boundary, PowerShell 7·Windows PowerShell 5.1 원클릭 preflight, Godot 4.7.1 import, 파일 잠금·강제 종료·source race·write failure 경로를 확인했다.

첫 exact head `37057ae2b7c28f8a615ce5c8c9333ca7225c93bd`에서 위 6개 workflow가 모두 PASS했다. 결과 기록 이후의 최종 병합 후보 head도 동일 Windows·migration·문서·core 계약을 통과해야 하며, 그 exact SHA와 run ID는 PR #174 및 프로젝트 Google Sheet 변경이력에 남긴다.

자동 workflow가 성공해도 18개 사람 검사항목은 자동 `PASS`로 승격하지 않는다. 실제 로컬 사용자가 `START_HUMAN_QA.cmd`를 실행하고 저장·화면·조작을 직접 판정하기 전까지 `HUMAN_QA_NOT_RUN`을 유지한다.
