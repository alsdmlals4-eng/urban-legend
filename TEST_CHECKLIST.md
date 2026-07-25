# TEST_CHECKLIST

> 상태: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 로드맵: `MVP_ROADMAP.md`  
> 최신 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`

## 현재 기준

- 구현 기준선: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A
- 화면 버전: Ver 4.2
- 저장 Schema: `mvp-039` (`mvp-038` 이관 지원)
- ANNUAL save: `annual-mvp-001-save-v1`
- CORE-MVP-001: `POC_BUILD_READY`
- 4주 보정: `MERGED / HISTORICAL_REGRESSION_EVIDENCE` — PR #70
- 7일 주간 계약: `APPROVED` — Issue #75
- 7일 주간 구현: `ON_BRANCH / CI_PENDING`
- GDD: v3.2
- 사람 사용성 QA: `NOT_RUN`
- 신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`

## 기획 데이터 무손실

- [x] 7일 주간 승인 설계 생성
- [x] 상세 TDD 구현 계획 생성
- [x] Issue #75 생성
- [x] 기존 활동 7개 ID 유지
- [x] 기존 동료·스킬·장비·연구 ID 유지
- [x] 기존 위험 수치 0·15·30 유지
- [x] 기존 렌더링·한글·키보드·포인터 수정 유지
- [x] 기존 3주 및 4주×3슬롯 QA를 삭제하지 않고 `HISTORICAL_REGRESSION_EVIDENCE`로 보존
- [x] PROJECT_CORE와 GDD 원문 구조 유지
- [x] `CURRENT_STATUS`·Handoff·Roadmap·Checklist를 7일 계약으로 정렬
- [ ] PR·commit·CI 최종 증거 기록

## 7일 데이터 계약

- [x] `contract_version = annual-mvp-001-v3`
- [x] `max_weeks = 4`
- [x] `days_per_week = 7`
- [x] 총 28일
- [x] `slots_per_week` 제거
- [x] 자동 휴식 피로 회복 1일당 5
- [x] 관측 훈련 2일
- [x] 기록 분석 2일
- [x] 현장 대응 훈련 3일
- [x] 증언 면담 업무 2일
- [x] 신호 현상 연구 3일
- [x] 오현 협업 훈련 2일
- [x] 직접 휴식 1일·피로 -25·상태 회복 가능
- [x] 활동별 일수 범위 1..3 검증
- [ ] Python 데이터 계약 PASS
- [ ] Godot 데이터 테스트 PASS

## 주간 상태 머신

- [x] 일정 일수 합계를 데이터에서 계산
- [x] 알 수 없는 활동 거부와 상태 불변
- [x] 7일 초과 거부와 상태 불변
- [x] 일정의 주차 경계 초과 금지
- [x] 정확히 7일이면 즉시 `WEEK_RESULT`
- [x] 7일 미만 첫 확정은 상태 변경 없이 경고
- [x] 첫 경고가 `planned_days`, `remaining_days` 제공
- [x] 같은 편성 재확정은 `commit_week_with_auto_rest`
- [x] 주간 결과 `planned_days`, `used_days`, `auto_rest_days`, `activity_results`
- [x] 회귀 호환 `slot_results` alias 유지
- [x] 자동 휴식 합산 ID `annual001_activity_auto_rest`
- [x] 자동 휴식은 피로 외 수치 변경 금지
- [x] 자동 휴식의 상태·관계·특수 회복·보너스 자격 금지
- [x] 직접 휴식이 자동 휴식보다 강함
- [ ] ANNUAL 상태 테스트 PASS

## 4주 출동 회귀

- [x] 1주차 결과 후 2주차 계획
- [x] 2주차 자율 출동 위험 0
- [x] 2주차 지연 후 3주차 계획
- [x] 3주차 자율 출동 위험 15
- [x] 3주차 지연 후 4주차 계획
- [x] 4주차 7일 결과 확인 전 `WEEK_RESULT`
- [x] 결과 확인 후 `annual_forced_deployment`
- [x] 강제 출동 `PREPARATION`, 위험 30
- [x] 강제 경로 결산 `weeks_used=4`
- [ ] 세 출동 경로 자동 회귀 PASS

## 저장·복원

- [x] `annual-mvp-001-save-v1` 유지
- [x] UI 경고 대기 상태는 save payload에 추가하지 않음
- [x] 커밋된 주간 결과의 일수 필드 저장
- [x] 저장 seed 판정 재현 유지
- [x] 사건 중 저장 금지 유지
- [x] 본편 `GameState` 비사용
- [x] `mvp-039`·`mvp-038` 비침범
- [ ] save test PASS

## UI·접근성·포인터

- [x] 활성 Scene이 `AnnualMvp001StateV2` 사용
- [x] 주차 표시 `/4`
- [x] 활동 버튼에 `N일` 표시
- [x] `사용 X/7일 · 남은 Y일` 표시
- [x] 남은 일수보다 긴 활동 버튼 비활성화
- [x] 첫 확정 경고 뒤 선택 유지
- [x] 두 번째 확정 버튼 `자동 휴식 후 확정`
- [x] 활동 추가·제거·불러오기·상태 전환 시 경고 대기 해제
- [x] 주간 결과에 직접 일정과 자동 휴식 구분
- [x] 3주차 안내에 4주차 7일과 위험 30 명시
- [x] 공용 Theme·한글 글꼴·내부 ID 현지화 유지
- [x] embedded CORE 확장 유지
- [x] 키보드 포커스·`ui_accept`·Esc 유지
- [x] 모듈 toggle typed append 수정 유지
- [ ] Scene test PASS
- [ ] 1280×720·1920×1080 화면 확인
- [ ] 자동 휴식 경고 캡처 PASS
- [ ] 4주차 결과·강제 출동 캡처 PASS
- [ ] 실제 그래픽 포인터 경로 PASS
- [ ] 사람 손 장시간 반복 조작

## GDD·DOCX

- [x] GDD v3.2
- [x] 4주×7일·28일 계약 명시
- [x] 직접 휴식과 자동 휴식 차이 명시
- [x] 4주×3슬롯 구현을 역사적 증거로 보존
- [x] 결정적 DOCX 포맷 `urban-legend-gdd-index-v5`
- [x] 생성기 머리말·꼬리말을 4주×7일로 변경
- [x] 번호 목록 원문 번호 유지
- [x] Markdown 이미지 수와 DOCX 이미지 수 검사
- [ ] DOCX build PASS
- [ ] DOCX source hash check PASS
- [ ] 문서 계약 PASS

## CORE-MVP-001 보존 회귀

- [x] 조사→가설→검증→전조→회수→매뉴얼 계약 유지
- [x] 외부 지원 허용 효과는 체력 회복·위험 완화뿐
- [x] 이해도·가설·관측 패턴·포획 표식 변경 금지
- [x] 기존 CORE F1 진입 유지
- [ ] CORE focused PASS
- [ ] 전체 Godot 회귀에서 CORE 경로 PASS
- [ ] 신규 플레이어 사건 인과 설명

## HISTORICAL QA — 보존 증거

- [x] PR #65 렌더링·입력 QA
- [x] PR #67 그래픽 포인터 QA
- [x] PR #70 4주×3슬롯 구현
- [x] visual run #28/#34
- [x] ANNUAL run #94/#101/#103
- [x] 문서 run #253/#255
- [x] 전체 Godot 회귀 49/49
- [x] 대표 visual artifact `8617041311`

위 항목은 회귀 근거이며 현재 7일 계약의 사람 플레이 증거가 아니다.

## GitHub 통합

- [x] Issue #75 생성
- [x] 브랜치 `agent/annual-mvp-001-seven-day-scheduling`
- [ ] PR 생성
- [ ] changed-file 감사
- [ ] review thread 0건 확인
- [ ] required CI 성공
- [ ] squash merge
- [ ] Issue #75 completed
- [ ] main 상태 문서에 PR·commit·run 기록

## 사람 플레이 검증 — 미실행

- [ ] 7일 안에서 1~3일 일정 조합의 재미와 가독성
- [ ] 주차 경계 초과 금지 이해
- [ ] 첫 경고 뒤 일정으로 돌아가 수정
- [ ] 같은 편성 재확정 후 자동 휴식 이해
- [ ] 직접 휴식과 자동 휴식의 효과 차이 이해
- [ ] 2주차 조기 출동 위험 0
- [ ] 3주차 자율 출동 위험 15
- [ ] 4주차 긴급 강제 출동 위험 30
- [ ] 육성 선택이 사건 정보·위험·피해 관리에 연결됨을 설명
- [ ] 사건 결과가 연구·스킬·결산으로 환류함을 설명
- [ ] 동료 지원 조건·확률·준비도가 공정하다고 인식
- [ ] 반복 일정 피로도 확인

## 현재 상태

```text
annual_mvp_001_seven_day_contract: APPROVED
annual_mvp_001_seven_day_implementation: ON_BRANCH
automated_verification: PENDING
human_usability_qa: NOT_RUN
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
