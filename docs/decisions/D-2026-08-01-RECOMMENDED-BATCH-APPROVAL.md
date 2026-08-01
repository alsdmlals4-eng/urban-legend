# D-2026-08-01-RECOMMENDED-BATCH-APPROVAL — 현재 기획 작업 권장안 일괄 승인

> 상태: `CURRENT_APPROVED_GOVERNANCE`
> 승인일: 2026-08-01
> 사용자 승인 원문: “작업 진행 중 승인 필요한 사항은 일괄 승인 할테니 권장안대로 진행해”
> 적용 범위: Issue #121 / Draft PR #122의 기획·감사·시각화·정본 동기화
> 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`

## 1. 결정

현재 기획 작업에서 이미 제시된 권장안과, 동일한 프로젝트 코어·범위·위험 경계 안에서 새로 발견되는 기술적 최소 안전 권장안을 별도 반복 질문 없이 승인 처리한다.

```text
정본·실제 파일·Sheet에서 사실 확인
→ 적대적 검토
→ 권장 최소안 선택
→ 같은 Decision ID로 GitHub·Sheet 동기화
→ 재조회·검증
→ 다음 작업 진행
```

## 2. 이번 승인으로 확정된 운영 판단

### Base v9.3 이관 시점

- 현재 프로젝트 Base v9.1 Adapter와 생성 운영 뷰를 유지한다.
- PR #120은 `Draft / HOLD`를 유지한다.
- PR #122의 비주얼 검수·최종 기획 승인·상위 정본 Canon Pass 전에는 PR #120을 병합·cherry-pick·재구현하지 않는다.
- 새 Base 이관 PR을 만들지 않는다.
- Canon Pass 완료 뒤 최신 main을 기준으로 PR #120의 재작성·폐기·재검증을 판정한다.

판정: `RECOMMENDED_SEQUENCE_APPROVED`

### 적대적 감사 보정

다음은 질문 없이 최소 수정한다.

- 승인 상태·대체 관계 누락
- GitHub·Sheet의 stale 상태·경로·Commit
- 같은 책임의 중복·구형 표현
- 실행하지 않은 검증의 PASS 오표기
- CURRENT 구현과 APPROVED Target의 혼합
- 이미지 검수·플레이테스트 소비처 누락

### 다음 작업 순서

```text
승인 동기화·stale 상태 보정
→ SCREEN 보드 A·B
→ SIT 보드 C1~C4
→ 이미지 적대적 중간점검
→ 플레이테스트 패키지
→ 사용자 기획 최종 승인 상태 기록
→ 상위 정본 단일 Canon Pass
→ Base v9.3 PR #120 재평가
→ writing-plans
→ 마지막에 Codex Goal
```

## 3. 승인 범위 밖

이 일괄 승인은 다음을 자동 허용하지 않는다.

- Godot 제품 코드·Scene·Resource·JSON 수정
- Save Schema 변경·자동 마이그레이션
- 보호 경로 삭제·대규모 이동·역사 자료 폐기
- PR 병합·main 직접 제품 변경
- 새 프로젝트 코어·장르·플랫폼·출시 범위 변경
- 새 사실이 기존 승인 전제를 무너뜨리는 경우의 임의 확정

이 항목은 기존 Gate와 권한을 따른다.

## 4. 중단 조건

다음이 발생하면 자동 권장안 진행을 중단하고 `BLOCKED_UNVERIFIED` 또는 `CHANGE_PROPOSAL`로 기록한다.

- 프로젝트 코어와 승인된 플레이어 경험이 양립하지 않음
- 저장 호환성 파괴가 불가피함
- 권리·라이선스·보안·개인정보 위험
- 기존 사용자 승인과 직접 충돌하는 새 근거
- 제품 구현 없이는 기획 판정 자체가 불가능함

## 5. 연결 문서

- `docs/planning/BASE_PROJECT_SHEET_OPERATING_AUDIT_2026-08-01.md`
- `docs/decisions/D-2026-08-01-LEGACY-PR-DISPOSITION.md`
- `docs/planning/CANON_MIGRATION_BUNDLE_2026-08-01.md`
- `docs/decisions/D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE.md`
- `docs/PROJECT_UPDATE_PROTOCOL.md`

## 6. 검증

- GitHub Decision 기록: 이 문서
- Google Sheet: `02_현재_확정결정`, `01_작업순서`, `04_누락_충돌_감사`, `99_변경이력`
- PR #122 본문·Issue #121 댓글에 승인 범위와 Commit·Sheet 위치 기록
- 제품 Runtime·사람 플레이: `NOT_RUN`
