# TEST_CHECKLIST

> 상태: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 로드맵: `MVP_ROADMAP.md`  
> 최신 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-four-week-month-design.md`

## 현재 기준

- 구현 기준선: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A
- 화면 버전: Ver 4.2
- 저장 Schema: `mvp-039` (`mvp-038` 이관 지원)
- ANNUAL save: `annual-mvp-001-save-v1`
- CORE-MVP-001: `POC_BUILD_READY`
- 4주 월간 계약: `APPROVED` — Issue #69
- 4주 구현: `ON_BRANCH / CI_PENDING`
- 사람 사용성 QA: `NOT_RUN`
- 신규 플레이어 검증: `NOT_RUN`
- `POC_PASSED`: `NOT_DECLARED`
- 제작 확대: `NOT_APPROVED`

## 기획 데이터 무손실

- [x] 승인 설계 문서 생성
- [x] 상세 구현 계획 생성
- [x] Codex Goal 생성
- [x] Issue #69 생성
- [x] 기존 활동 7개 ID 유지
- [x] 기존 동료·스킬·장비·연구 ID 유지
- [x] 기존 위험 수치 0·15·30 유지
- [x] 기존 렌더링·한글·포인터 수정 유지
- [x] 기존 3주 QA를 삭제하지 않고 `HISTORICAL`로 보존
- [x] `CURRENT_STATUS`·Handoff·Roadmap 동기화
- [ ] PROJECT_CORE 최신 구현 상태·참조 동기화
- [ ] GDD와 GDD DOCX 동기화
- [ ] 병합 후 PR·commit·CI 증거 기록

## CORE-MVP-001 보존 회귀

- [x] 조사→가설→검증→전조→회수→매뉴얼 계약 유지
- [x] 외부 지원 허용 효과는 체력 회복·위험 완화뿐
- [x] 이해도·가설·관측 패턴·포획 표식 변경 금지
- [x] 기존 CORE F1 진입 유지
- [ ] CORE focused 4/4 재실행
- [ ] 전체 회귀에서 CORE 경로 통과
- [ ] 신규 플레이어 사건 인과 설명

## 4주 데이터 계약

- [x] `contract_version = annual-mvp-001-v2`
- [x] `max_weeks = 4`
- [x] `slots_per_week = 3`
- [x] `voluntary_entry_week = 2`
- [x] `deadline_week = 4`
- [x] 총 12슬롯
- [x] 3주차 자율 출동 위험 15
- [x] 4주차 강제 출동 위험 30
- [x] Python 계약 테스트 갱신
- [x] Godot 데이터 검증기 갱신
- [ ] Python 계약 실행 PASS
- [ ] Godot 데이터 테스트 PASS

## 4주 상태 머신

- [x] 기존 State 보존
- [x] `AnnualMvp001StateV2` 추가
- [x] 1주차 결과 후 2주차 계획
- [x] 2주차 결과 후 출동 결정
- [x] 2주차 자율 출동 위험 0
- [x] 2주차 지연 후 3주차 계획
- [x] 3주차 자율 출동 위험 15
- [x] 3주차 지연 후 4주차 계획
- [x] 4주차 활동 정확히 3개 요구
- [x] 4주차 결과 확인 전 `WEEK_RESULT` 유지
- [x] 4주차 결과 확인 후 `annual_forced_deployment`
- [x] 강제 출동 `PREPARATION`, 위험 30
- [x] 강제 경로 결산 `weeks_used=4`
- [x] 잘못된 명령의 상태 불변
- [ ] ANNUAL state test 실행 PASS

## 저장·복원

- [x] `annual-mvp-001-save-v1` 유지
- [x] payload 필드 추가 없음
- [x] 2·3주차 기존 저장 복원 가능
- [x] 기존 강제 출동 준비 상태를 되돌리지 않음
- [x] 저장 seed 판정 재현 유지
- [x] 사건 중 저장 금지 유지
- [x] 본편 `GameState` 비사용
- [x] `mvp-039`·`mvp-038` 비침범
- [ ] save test 실행 PASS

## UI·접근성·포인터 보존

- [x] 활성 Scene이 StateV2 사용
- [x] 주차 표시 `/4`
- [x] 3주차 안내에 4주차 3슬롯 명시
- [x] 4주차 강제 출동 피드백 명시
- [x] 공용 Theme 유지
- [x] 한글 시스템 글꼴 후보 유지
- [x] 내부 ID 현지화 유지
- [x] embedded CORE 확장 유지
- [x] 키보드 포커스·`ui_accept`·Esc 유지
- [x] 모듈 toggle typed append 수정 유지
- [x] 사건 중 Save 버튼 비활성 유지
- [ ] Scene test 실행 PASS
- [ ] 1280×720·1920×1080 렌더링 재확인
- [ ] 4주차 포인터 경로 재확인
- [ ] 사람 손 장시간 반복 조작

## HISTORICAL QA — 보존 증거

다음은 3주 구현 당시 실제 통과 증거다. 4주차 강제 출동의 신규 증거로 재해석하지 않는다.

- [x] PR #65 렌더링·입력 QA
- [x] PR #67 그래픽 포인터 QA
- [x] visual run #28
- [x] ANNUAL run #94
- [x] CORE focused 4/4
- [x] ANNUAL focused 6/6
- [x] 전체 Godot 회귀 49/49
- [x] 대표 visual artifact id `8617041311`

## 신규 자동 검증

- [ ] Python 데이터 계약
- [ ] Python 정적 계약
- [ ] 활성 문서 참조 계약
- [ ] Godot 4.7.1 import
- [ ] CORE-MVP-001 focused
- [ ] ANNUAL-MVP-001 focused
- [ ] 전체 Godot 회귀
- [ ] 현재형 3주 월간 참조 감사
- [ ] protected paths diff 없음

## GitHub 통합

- [x] 브랜치 `agent/annual-mvp-001-four-week-month`
- [x] Issue #69
- [x] PR #70 생성
- [x] changed-file 감사
- [x] review thread 0건
- [ ] required CI 성공
- [ ] squash merge
- [ ] Issue #69 완료 처리
- [ ] main 상태 문서에 최종 PR·commit·run 기록

## 사람 플레이 검증 — 미실행

- [ ] 2주차 조기 출동 위험 0
- [ ] 3주차 자율 출동 위험 15
- [ ] 4주차 긴급 강제 출동 위험 30
- [ ] 마지막 3슬롯과 강제 위험의 교환을 설명
- [ ] 육성 선택이 사건 정보·위험·피해 관리에 연결됨을 설명
- [ ] 사건 결과가 연구·스킬·결산으로 환류함을 설명
- [ ] 동료 지원 조건·확률·준비도가 공정하다고 인식
- [ ] 반복 일정 피로도 확인

## 최종 상태

```text
annual_mvp_001_four_week_contract: APPROVED
annual_mvp_001_four_week_implementation: ON_BRANCH
automated_verification: PENDING
historical_rendered_visual_review: PASSED
historical_graphical_pointer_event_qa: PASSED
human_usability_qa: NOT_RUN
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```
