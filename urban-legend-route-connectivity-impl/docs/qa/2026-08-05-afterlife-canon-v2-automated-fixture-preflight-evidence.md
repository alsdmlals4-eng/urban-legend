# 저승역 Canon v2 Automated Fixture Preflight Evidence

- Decision ID: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`
- 상태: `AUTOMATED_FIXTURE_PREFLIGHT_GREEN / HUMAN_QA_NOT_RUN / MERGE_NOT_AUTHORIZED`
- Draft PR: `#147`
- Base Draft PR: `#146`
- 검증된 fixture 구현 HEAD: `f422b61eac9bb1f97da01ab4900fd5714431c0f1`
- 실행 환경: GitHub Actions Ubuntu 24.04, Godot 4.7.1, Python 3.12

## 목적

실제 사용자 저장을 받기 전에 repository에 고정된 대표 JSON fixture를 사용해 저승역 Canon v2 본편·Validation 이관 경로를 파일 단위로 사전검증한다.

이 증거는 다음을 의미하지 않는다.

- 실제 사용자 저장 Human QA 완료
- Windows 10/11 파일 잠금·강제 종료·권한 오류 검증 완료
- 실제 UI·접근성 검증 완료
- 출시 또는 병합 승인

## RED 증거

Run `30974305854`:

- 기존 Design 10 tests: PASS
- Implementation Plan 11 tests: PASS
- Runner contract 4 tests: PASS
- Implementation evidence 4 tests: PASS
- Human QA plan contract: `2 failures / 3 errors`
- 실패 원인: QA 계획·증거 양식·대표 fixture 4개 부재
- Godot focused·전체 회귀는 문서 계약 RED로 인해 실행되지 않음

의도한 산출물 부재만 검출했으며 기존 구현 회귀를 실패 원인으로 오인하지 않았다.

## 추가한 대표 fixture

1. `tests/fixtures/afterlife_migration/main_mvp038_investigation.json`
   - 조사 진행·구형 단서·알 수 없는 ID
   - 검증: `mvp-040`, Canon v2 contract, `migrated_unverified`, 빈 답 슬롯, orphan 보존, 보상 불변, migration history 멱등
2. `tests/fixtures/afterlife_migration/main_mvp039_recovery.json`
   - 구형 회수 전투 진행 중
   - 검증: `legacy_case_restart_required`, 무페널티 안전 조사 checkpoint, 구형 pattern·forced recovery 제거
3. `tests/fixtures/afterlife_migration/main_mvp039_completed.json`
   - 완료 보고서·A등급·기지급 보상
   - 검증: read-only legacy snapshot, 보고서·보상 불변, Canon v2 첫 클리어·S등급 자동 승격 금지
4. `tests/fixtures/afterlife_migration/validation_v1_active_recovery.json`
   - 진행 중 `validation-save-v1`
   - 검증: `validation-save-v2`, 구형 route/recovery 비활성, 본편 숨은 상태 불변, resume 가능

## GREEN 증거

검증된 fixture 구현 HEAD `f422b61eac9bb1f97da01ab4900fd5714431c0f1`:

### Documentation

Run `30974616333`: SUCCESS

- archive governance
- active references
- planning synchronization
- 기존 프로젝트 문서 계약

### Canon v2 Migration

Run `30974616329`: SUCCESS

- Design·Plan·Implementation evidence·Human QA plan Python contracts: PASS
- Godot import: PASS
- Validation Canon 활성화: PASS
- Canon v2 focused: `9/9` PASS
- full Godot regression: PASS

### ANNUAL-MVP-001

Run `30974616351`: SUCCESS

- annual·active-document Python contracts: PASS
- Validation Package 1·2: PASS
- CORE-MVP-001: PASS
- ANNUAL-MVP-001·002: PASS
- Canon v2 focused `9/9`: PASS
- full Godot regression: PASS

## 검증된 자동 속성

- fixture 파일을 `user://` QA 경로로 byte copy한 뒤 wrapper를 통해 실제 load
- `mvp-038`, `mvp-039`, `validation-save-v1` 입력 인식
- `mvp-040`, `validation-save-v2` 출력
- `content_contract_id: afterlife-station-canon-v2`
- 답 슬롯 자동 채움 없음
- 구형 evidence correctness 누설 없음
- orphan ID 보존
- 구형 회수의 무페널티 안전 재시작
- 완료 보고서·보상 불변
- migration history 재로드 중복 없음
- Validation route/recovery 구형 의미 제거
- Validation이 본편 숨은 상태를 변경하지 않음
- 기존 전체 Godot 회귀 유지

## 적대적 한계

대표 fixture는 현재 코드와 승인된 구형 schema를 바탕으로 만든 합성 저장이다. 실제 장기간 플레이에서 생성된 예상 밖의 필드 조합, 사용자 수동 편집, 운영체제별 파일 잠금, 백신·동기화 프로그램 개입, 강제 종료 타이밍, 실제 디스크 오류를 재현하지 않는다.

따라서 자동 사전검증 결과는 `AUTOMATED_FIXTURE_PREFLIGHT_GREEN`으로만 기록하고 Human QA는 계속 `HUMAN_QA_NOT_RUN`으로 유지한다.

## Human QA 실행 문서

- 계획: `docs/qa/2026-08-05-afterlife-canon-v2-human-qa-plan.md`
- 증거 양식: `docs/qa/templates/afterlife-canon-v2-human-qa-evidence-template.md`

## 다음 Gate

1. 실제 사용자 저장 복사본 확보와 SHA-256 기록
2. Windows 10/11 격리 APPDATA에서 정상 이관
3. 파일 잠금·강제 종료·디스크 쓰기 실패
4. 보상 중복·Validation 격리 확인
5. UI·접근성 검증
6. Human QA 결과 승인
7. PR #145·#146·#147 통합 순서 결정
8. 별도 병합 승인
