# 괴이기록국 Canon Migration Bundle — 2026-08-01

> 상태: `CANON_ALIGNMENT_ACTIVE / PRODUCT_IMPLEMENTATION_BLOCKED`
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Codex: `HOLD`
> Runtime / Human QA: `NOT_RUN`

## 1. 목적

최근 승인된 기획 기준선과 기존 main 구현·상위 문서·테스트·Google GDD Sheet를 삭제 없이 정렬한다.

이 Bundle은 다음을 구분한다.

```text
CURRENT_IMPLEMENTATION_LEGACY
= 현재 main에서 실제 동작하는 과거 계약

APPROVED_TARGET_NOT_IMPLEMENTED
= 사용자 승인 완료, 제품 구현 전 계약

HISTORICAL_EVIDENCE
= 과거 PoC·테스트·PR의 당시 유효 증거

HOLD
= Validation 검증 전 실행·확장 금지
```

## 2. 기획 단계 권위 순서

Draft PR #122가 병합되기 전과 제품 구현 전에는 다음 순서를 사용한다.

1. 2026-08-01 승인 Decision 문서
2. 2026-07-31 승인 Decision 문서의 최신 개정
3. `docs/planning/PLANNING_PROGRESS_2026-08-01.md`
4. `docs/planning/FULL_PROJECT_ADVERSARIAL_AUDIT_2026-08-01.md`
5. Google Sheet의 동일 Decision / Review ID 행
6. 기존 `PROJECT_CORE`·GDD·CURRENT_STATUS·DOCUMENTATION_MAP
7. 과거 MVP·PoC·PR 문서

상위 기존 문서는 현재 구현을 설명하는 책임을 유지하지만, 새 제품 목표와 충돌할 때 `CURRENT_IMPLEMENTATION_LEGACY`로 해석한다.

제품 구현·저장·테스트 이관이 완료되기 전에는 기존 문서의 `IMPLEMENTED`를 새 승인 목표의 구현 완료로 해석하지 않는다.

## 3. 승인된 목표 계약

### 제품 흐름

```text
무인 메인
→ 저승역 콜드 오픈
→ 기록국 브리핑
→ 축약 준비
→ 텍스트 노벨 조사
→ 사건 원인 가설 보드
→ 시간순 증거 비교
→ 안전 노선 복원
→ 회수 2패턴
→ 결과 4축·보고서
→ 사후 정산·다음 일정 영향
```

### 기준 화면

1. SCREEN-01 메인
2. SCREEN-02 텍스트 노벨 조사
3. SCREEN-03 축약 준비
4. SCREEN-04 결과·보고서·사후 정산
5. SCREEN-05 일정·운영
6. SCREEN-06 연구
7. SCREEN-07 기록국 보급실

### 일정

```text
하루 주요 활동 1개
+ 자동 기본 휴식
```

- 2~3일 주요 활동은 같은 주의 연속 날짜를 점유한다.
- 전일 회복·치료는 주요 활동이다.
- 오전·오후 반일 슬롯과 주간 일괄 편성은 제품 목표가 아니다.

### 준비·조달

- SCREEN-03은 출동 직전 요원·장비·지원·조사 우선순위만 담당한다.
- SCREEN-07의 정식 권위는 기록국 보급실이다.
- 소문시장은 외부 접점 선택 콘텐츠로 보존한다.

### 사건

- 사건 가설 보드는 전체 원인을 판단한다.
- 노선 복원은 안전 운용 규칙을 검증한다.
- 회수 화면은 새 전조의 패턴 분류·관련 기록·중립 행동을 담당한다.
- 현장 행동 성공과 원인·규칙 검증은 별도 결과다.

## 4. 정본 대체·보존 매트릭스

| 기존 계약 | 현재 분류 | 승인 목표 | 처리 |
|---|---|---|---|
| 4주×7일 주간 일괄 편성 PoC | `HISTORICAL_EVIDENCE` | 일일 주요 활동 편성 | 상태·수치 참고만 유지 |
| preparation_scene 오전·오후 반일 | `CURRENT_IMPLEMENTATION_LEGACY` | 축약 출동 준비 | 일정 책임 제거 예정 |
| 자동 휴식 / 직접 휴식 | `HISTORICAL_EVIDENCE` | 기본 휴식 / 전일 회복 | 의미 매핑 후 수치 재검증 |
| 회수 4패턴 | `CURRENT_IMPLEMENTATION_LEGACY` | Validation 2패턴 | 패턴 3·4 HOLD |
| 회수 가설→근거→대응 | `CURRENT_IMPLEMENTATION_LEGACY` | 분류→기록→중립 행동 | 역할 변경 필요 |
| 단서 수집률 40% 회수 진입 | `CURRENT_IMPLEMENTATION_LEGACY` | 필수 의미 Gate | 제품 직접 진입 차단 필요 |
| 단일 회수·안정화 등급 | `CURRENT_IMPLEMENTATION_LEGACY` | 결과 4축 | 별도 판정 계약 필요 |
| 소문시장 상점 | `CURRENT_IMPLEMENTATION_LEGACY / OPTIONAL_EXTERNAL_CONTACT` | 기록국 보급실 | 제품 권위 분리 |
| ANNUAL 연구 PoC 패널 | `HISTORICAL_EVIDENCE` | SCREEN-06 연구 | 상태·resolver 재사용 후보 |
| 랜덤 이벤트·세력 의뢰·일상 에피소드 | `PRESERVED / HIDDEN_IN_VALIDATION` | Showcase 후보 | Validation 판정·로그 금지 |

## 5. 상위 문서 이관 책임

### docs/PROJECT_CORE.md

다음 최종 승인 후 갱신한다.

- Validation 제품 흐름
- 일일 일정과 기본 휴식
- 원인 가설 / 안전 규칙 / 회수 패턴 책임 분리
- 결과 4축

현재 파일은 `CURRENT_IMPLEMENTATION_LEGACY + APPROVED_ANNUAL_DIRECTION`으로 해석한다.

### docs/GAME_DESIGN_DOCUMENT.md

다음 항목을 구현 전 Canon Pass에서 갱신한다.

- 주간 계획·중요 반일 표현
- SCREEN-01~07
- 기록국 보급실
- Validation 노출 범위
- 회수 2패턴과 결과 4축

기존 세부 수치와 구현 상태는 역사 기록으로 보존한다.

### docs/CURRENT_STATUS.md

제품 구현 착수 전에는 다음을 명시해야 한다.

- 기존 main 흐름은 Legacy
- 승인 Target은 Not Implemented
- Godot runtime·사람 검증 Not Run
- Codex Hold

### docs/DOCUMENTATION_MAP.md

다음 책임 문서를 활성 기획 정본으로 등록한다.

- `docs/decisions/D-2026-08-01-SCHEDULE-REST-SEMANTICS.md`
- `docs/decisions/D-2026-08-01-PROVISIONING-AUTHORITY.md`
- `docs/decisions/D-2026-08-01-VALIDATION-SCOPE-FILTER.md`
- `docs/decisions/D-2026-08-01-LEGACY-PR-DISPOSITION.md`
- `docs/benchmarks/SCREEN_07_PROCUREMENT_TARGETED_BENCHMARK_2026-08-01.md`
- 본 Canon Migration Bundle

상위 문서의 실제 내용 교체는 SCREEN/SIT·저장·테스트 계획과 사용자 최종 승인을 받은 단일 Canon Pass에서 수행한다.

## 6. Google Sheet 상태 정렬

기존 행은 삭제하지 않는다.

### 변경할 상태 어휘

- 기존 주간·반일·시장·회수 4패턴: `CURRENT_IMPLEMENTATION_LEGACY`
- 신규 일일 일정·기본 휴식·보급실·Validation 필터: `APPROVED_TARGET_NOT_IMPLEMENTED`
- 사람 검증: `NOT_RUN`
- 제작 확대: `NOT_APPROVED`

### 동일 ID 연결

각 승인 Decision은 다음 탭에 동일 ID로 연결한다.

- `02_현재_확정결정`
- `04_누락_충돌_감사`
- `40_핵심시스템_메인콘텐츠`
- `41_성장_경제`
- `50_메인콘텐츠`
- `60_UX_UI_접근성`
- `80_데모_버티컬슬라이스_플레이테스트`
- `99_변경이력`

## 7. 테스트 책임 이관

테스트 코드는 이번 Bundle에서 변경하지 않는다.

### 보존

- 기존 ANNUAL PoC 주간 계약 테스트
- 기존 반일 준비·저장 회귀
- 기존 회수 4패턴 ID·행동 결과 테스트

보존 테스트는 `LEGACY_POC_REGRESSION`으로 분류한다.

### 신규 제품 계약 테스트 후보

- 일일 날짜 선택과 다일 연속 점유
- 기본 휴식과 전일 회복 중복·정산
- 메인→콜드 오픈→준비→조사 전문 화면 순서
- 가설 보드·시간순 증거·노선 복원 필수 Gate
- 회수 2패턴과 중립 행동
- 현장 성공 / 추론 검증 분리
- 결과 4축 상한
- 결과→연구·보급·다음 일정 환류
- 숨긴 시스템의 판정·난수·로그·상태 변경 금지
- 저장 복귀와 Legacy 데이터 정화

신규 테스트 구현은 저장·화면 계약 최종 승인 뒤 Codex Goal에 포함한다.

## 8. PR 정렬

- PR #122: 현재 기획·감사·정본 정렬의 주 PR, Draft 유지
- PR #120: Base v9.3 이관, HOLD
- PR #54: 개념 일부 보존 후 종료
- PR #26: 개념 일부 보존 후 종료

오래된 PR의 diff를 현재 구현 증거나 승인 상태로 사용하지 않는다.

## 9. 다음 P0

```text
SCREEN-01~07 CURRENT / INFERRED / PROPOSED 정본
→ SIT-001~008 시퀀스와 전체 전환도
→ 회수 2패턴 중립 문구 최종 승인
→ 결과 4축·등급 상한·연구 환류 승인
→ 저장·테스트 마이그레이션 계획
→ 플레이테스트 패키지 적대적 검토
→ 사용자 기획 최종 승인
→ 상위 문서 단일 Canon Pass
→ 마지막에 Codex Goal
```

## 10. Gate 상태

```yaml
schedule_rest_semantics: APPROVED_PLANNING_BASELINE
procurement_authority: APPROVED_PLANNING_BASELINE
validation_scope_filter: APPROVED_PLANNING_BASELINE
legacy_pr_disposition: APPROVED_OPERATIONAL_DECISION
screen_07_benchmark: PASSED
canon_authority_hierarchy: ACTIVE
upper_canon_content_rewrite: HOLD_UNTIL_FINAL_DESIGN_APPROVAL
product_implementation: NOT_STARTED
save_test_migration: NOT_STARTED
human_validation: NOT_RUN
production_expansion: NOT_APPROVED
codex: HOLD
```
