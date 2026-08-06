# 저승역 Canon v2 Human QA 증거 양식

- Decision ID: `D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN`
- PR: `#147`
- QA 상태: `PASS / FAIL / BLOCKED / NOT_RUN`
- Human QA 승인자:
- 실행 일시(KST):

## 1. 빌드·환경 식별

- Exact commit SHA:
- 브랜치:
- 빌드 종류: Editor / Debug Export / Release Export
- Godot 버전:
- 운영체제:
- CPU·메모리:
- 프로젝트 경로:
- 사용자 데이터 경로:

## 2. 입력 저장 증거

- Fixture 또는 실제 저장 복사본 파일명:
- 원본 출처: repository fixture / 사용자 제공 복사본
- Fixture SHA-256:
- 원본 파일 크기(bytes):
- 원본 bytes 보존 확인: PASS / FAIL / BLOCKED / NOT_RUN
- 개인정보·계정 정보 제거 여부:
- 원본 저장 파일 자체를 실행 경로에 두지 않았는지:

## 3. 실행 절차

재현 절차를 명령·클릭 순서대로 기록한다.

1. 격리 QA 폴더 생성
2. 저장 복사본 배치
3. 실행 전 SHA-256 기록
4. 게임 또는 테스트 실행
5. migration 결과와 화면 상태 확인
6. 실행 후 저장·backup·temp·migration journal 검사
7. 실행 후 SHA-256과 의미 필드 기록

## 4. 자동 사전검증

- Python QA 계약:
- Canon v2 focused 9/9:
- Validation Canon 활성화:
- 전체 Godot 회귀:
- CI run URL 또는 run ID:
- 로그 경로:

## 5. 저장 이관 결과

- 입력 버전: `mvp-038 / mvp-039 / validation-save-v1`
- 출력 버전: `mvp-040 / validation-save-v2`
- `content_contract_id`:
- `migration_history` 중복 여부:
- `orphan_legacy_ids` 보존 여부:
- `migrated_unverified` 유지 여부:
- 정답 슬롯 자동 완성 여부:
- 구형 회수 진행의 안전 재시작 여부:
- 완료 보고서·보상 보존 여부:
- 보상 중복 여부:
- Validation이 본편 숨은 상태를 변경했는지:

## 6. 장애 주입 결과

각 항목은 `PASS / FAIL / BLOCKED / NOT_RUN` 중 하나로 기록한다.

- 파일 잠금:
- temp 작성 직후 강제 종료:
- primary 승격 직후 강제 종료:
- 디스크 쓰기 실패:
- 읽기 전용 폴더:
- 손상된 JSON:
- 외부 수정으로 source checksum 변경:
- migration journal 복구:
- backup 원복:
- 재실행 멱등성:

## 7. UI·접근성 결과

- 1280×720:
- 1920×1080:
- 키보드만으로 진행:
- 포커스 표시:
- 스크린 리더용 의미 텍스트:
- 색상 외 상태 구분:
- 구형 저장 재시작 안내 문구:
- 피해자·기록·보상 표시 일관성:

## 8. 증거 파일

- 스크린샷 또는 로그 경로:
- 실행 전 저장 복사본 경로:
- 실행 후 저장 경로:
- backup 경로:
- temp 경로:
- migration journal 경로:
- 비교 diff 경로:

## 9. 판정

- 최종 상태: `PASS / FAIL / BLOCKED / NOT_RUN`
- 치명도: P0 / P1 / P2 / P3 / 해당 없음
- 발견 사항:
- 재현 가능 여부:
- 구현 수정 필요 여부:
- PR Ready 전환 허용 여부: 아니오 / 별도 승인 필요
- 병합 승인 여부: `MERGE_NOT_AUTHORIZED`
