# TEST_CHECKLIST

> 현재 월간 기획·Gate: `docs/CURRENT_PLANNING_CANON.md` + `docs/current-planning-canon.json`
> 문서 역할: 병합된 CORE/ANNUAL runtime의 회귀 Checklist. 새 월간 구현 권한을 부여하지 않는다.
> 상태: `docs/CURRENT_STATUS.md`  
> 코어: `docs/PROJECT_CORE.md`  
> 로드맵: `MVP_ROADMAP.md`  
> 최신 시간 설계: `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`  
> ANNUAL-MVP-002 계획: `docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md`

## 현재 기준

- 구현 기준선: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A
- 화면 버전: Ver 4.2
- 저장 Schema: `mvp-039` (`mvp-038` 이관 지원)
- ANNUAL save: `annual-mvp-001-save-v1`
- CORE-MVP-001: `POC_BUILD_READY`
- 4주 보정: `MERGED / HISTORICAL_REGRESSION_EVIDENCE` — PR #70
- 7일 주간 계약: `APPROVED / COMPLETE` — Issue #75
- 7일 주간 구현: `MERGED / AUTOMATED_QA_PASSED` — PR #76 / commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`
- ANNUAL-MVP-002 구현: `MERGED / AUTOMATED_QA_PASSED` — Issue #88 / PR #89 / commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824`
- ANNUAL-MVP-002 contract: `annual-mvp-002-v1`
- ANNUAL-MVP-002 검증: 문서 #333 / ANNUAL #167 / Visual #55 PASS
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
- [x] PR #76·commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`·run #273/#121/#51 기록
- [x] 확장 순서·임시 데이터 기준선 — Issue #84 / PR #85
- [x] 벤치마크 연구·권장안 — Issue #86 / PR #87
- [x] ANNUAL-MVP-002 결정·계획·데이터·검증 증거를 GitHub에 기록

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
- [x] Python 데이터 계약 — run #121 PASS
- [x] Godot 데이터 테스트 — run #121 PASS

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
- [x] ANNUAL 상태 테스트 — run #121 PASS

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
- [x] 세 출동 경로 자동 회귀 — run #121/#51 PASS

## 저장·복원

- [x] `annual-mvp-001-save-v1` 유지
- [x] UI 경고 대기 상태는 save payload에 추가하지 않음
- [x] 커밋된 주간 결과의 일수 필드 저장
- [x] 저장 seed 판정 재현 유지
- [x] 사건 중 저장 금지 유지
- [x] 본편 `GameState` 비사용
- [x] `mvp-039`·`mvp-038` 비침범
- [x] save test — run #121 PASS

## UI·접근성·포인터

- [x] 활성 ANNUAL-MVP-001 Scene이 `AnnualMvp001StateV2` 사용
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
- [x] Scene test — run #121 PASS
- [x] 1280×720·1920×1080 화면 확인 — run #51 PASS
- [x] 자동 휴식 경고 캡처 — run #51 PASS
- [x] 4주차 결과·강제 출동 캡처 — run #51 PASS
- [x] 실제 그래픽 포인터 경로 — run #51 PASS
- [ ] 사람 손 장시간 반복 조작

## ANNUAL-MVP-002 데이터·격리 계약

- [x] contract `annual-mvp-002-v1`
- [x] base contract `annual-mvp-001-v3`
- [x] 신규 ID `annual002_` namespace
- [x] 동료 3명
- [x] 고유 스킬 3개
- [x] 공용 지원 6개
- [x] 장비 3개
- [x] 모듈 6개
- [x] 연구 자원 4종
- [x] 연구 노드 8개
- [x] 연구 선행 그래프 순환 금지
- [x] 음수 연구 비용 금지
- [x] 신규 핵심 단서·정답 가설·미관측 패턴·필수 회수 조건 필드 금지
- [x] 기존 ANNUAL-MVP-001 데이터·Scene·State 비대체
- [x] Python 데이터 계약 — run #167 PASS
- [x] Godot import — run #167 PASS

## ANNUAL-MVP-002 일정 도구

- [x] 7일 초과 변경 거부와 상태 불변
- [x] 일정 결과 미리보기
- [x] 사용·남은 일수 표시
- [x] 피로·역량·기관 영향 합산
- [x] 지난주 복사는 `planned_activity_ids` 사용
- [x] 템플릿 슬롯 정확히 3개
- [x] 템플릿은 주차 전환 뒤 유지
- [x] 현재 데이터에서 사라진 활동이 포함된 템플릿 거부
- [x] 전체 초기화
- [x] 마지막 변경 한 단계 undo
- [x] 확정 전 사건 정답·숨은 분기 비공개
- [x] planner focused — run #167 PASS

## ANNUAL-MVP-002 동료·지원

- [x] 동료 0~2명 편성 가능
- [x] 세 번째 동료 거부와 상태 불변
- [x] 같은 동료 중복 금지
- [x] 공용 지원은 선택한 동료의 허용 목록에 있어야 함
- [x] 고유 스킬 사건당 1회 확정 발동
- [x] 일반 확률 `기본 + 준비 10%p + 신뢰 0/5/10%p`
- [x] 일반 확률 상한 90%
- [x] 준비도는 일반 확률에 직접 가산하지 않음
- [x] 적격 실패 준비도 +20
- [x] 실패 학습 연구 완료 시 +25
- [x] 준비도 100이면 다음 적격 발동 보장
- [x] 성공 뒤 준비도 0
- [x] 동일 seed·event key 재현
- [x] 같은 event key 중복 적용 금지
- [x] 적격·비적격 사유, 확률, 준비도, 보장 거리 공개
- [x] support resolver focused — run #167 PASS

## ANNUAL-MVP-002 장비·연구·저장

- [x] 주 장비 1개
- [x] 기본 모듈 슬롯 1개
- [x] 같은 모듈 중복 금지
- [x] 장비 계열 불일치 거부와 상태 불변
- [x] 동시 연구 최대 2개
- [x] 시작 시 연구 자원 예약
- [x] 완료 시 예약 자원 소비
- [x] 취소 시 예약량 75% 내림 반환
- [x] 사건 결과의 관측 기록·잔향 자료·위험 사례·기관 협력 점수 환류
- [x] save version `annual-mvp-001-save-v1` 유지
- [x] `state.annual_mvp_002` 선택 블록
- [x] 구 저장 기본 확장 상태
- [x] 알 수 없는 ID `orphaned_ids` 보존
- [x] orphaned ID 효과 계산 제외
- [x] loadout·readiness·research·template 저장 왕복
- [x] State focused — run #167 PASS

## ANNUAL-MVP-002 CORE adapter·fallback

- [x] CORE 사건 원본 직접 수정 없음
- [x] 허용 효과는 피해·위험·표시 시간·허용 오차·회수 창·연구 보상
- [x] 같은 현장 역할의 두 번째 효과 70%
- [x] 신규 답 필드 수가 CORE 정본보다 증가하지 않음
- [x] 확장 데이터 부재 시 기존 ANNUAL-MVP-001·CORE 기본 동작
- [x] 지원 로그 중복 적용 금지
- [x] 연구 보상 등급 매핑
- [x] adapter focused — run #167 PASS
- [x] CORE focused — run #167 PASS
- [x] 전체 Godot 회귀 — run #167 PASS

## ANNUAL-MVP-002 UI·시각 QA

- [x] 독립 격리 Scene
- [x] `ActivityPreviewLabel`
- [x] 지난주 복사·undo·clear·템플릿 1~3 컨트롤
- [x] 동료 카드 3개와 최대 2명 제한
- [x] 장비·모듈 계열 검증
- [x] 지원 확률·준비도·보장 거리 표시
- [x] 동료·장비의 정답 비대체 문구
- [x] `무엇이 변했는가 / 왜 변했는가 / 다음 주 영향` 요약
- [x] 직접 휴식·자동 휴식 차이 표시
- [x] Scene focused — run #167 PASS
- [x] 기존 ANNUAL-MVP-001 키보드·포인터 — run #55 PASS
- [x] 새 ANNUAL-MVP-002 실제 포인터 — run #55 PASS
- [x] 실제 좌표로 일정·undo·template·W2 출동·동료 2명·사건 진입
- [x] 1280×720·1920×1080 캡처 — run #55 PASS
- [x] 캡처 8장 직접 검사 — artifact `8625300008`
- [x] 한글 글리프 누락·겹침·핵심 정보 잘림 없음
- [ ] 사람 손 장시간 편성·동료·장비 반복 조작

## GDD·DOCX

- [x] GDD v3.2
- [x] 4주×7일·28일 계약 명시
- [x] 직접 휴식과 자동 휴식 차이 명시
- [x] 4주×3슬롯 구현을 역사적 증거로 보존
- [x] 결정적 DOCX 포맷 `urban-legend-gdd-index-v5`
- [x] 생성기 머리말·꼬리말을 4주×7일로 변경
- [x] 번호 목록 원문 번호 유지
- [x] Markdown 이미지 수와 DOCX 이미지 수 검사
- [x] 결정적 DOCX 생성기 계약 — 문서 run #273 PASS
- [x] DOCX source hash 코드 계약 — 문서 run #273 PASS
- [x] 문서 계약 — run #273 PASS

## CORE-MVP-001 보존 회귀

- [x] 조사→가설→검증→전조→회수→매뉴얼 계약 유지
- [x] 외부 지원 허용 효과는 피해·위험·허용 오차 범위로 제한
- [x] 이해도·가설·관측 패턴·포획 표식 변경 금지
- [x] 기존 CORE F1 진입 유지
- [x] CORE focused — run #167 PASS
- [x] 전체 Godot 회귀에서 CORE 경로 — run #167 PASS
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

위 항목은 회귀 근거이며 현재 7일·ANNUAL-MVP-002 계약의 사람 플레이 증거가 아니다.

## GitHub 통합

- [x] Issue #75·PR #76·상태 PR #77 완료
- [x] Issue #84·PR #85 확장 기준선 완료
- [x] Issue #86·PR #87 벤치마크 완료
- [x] Issue #88 생성
- [x] 브랜치 `agent/annual-mvp-002-vertical-slice`
- [x] draft PR #89 생성
- [x] 구현 계획·TDD·자동 검증 완료
- [x] 문서 #333 / ANNUAL #167 / Visual #55 PASS
- [x] PR #89 changed-file 감사
- [x] PR #89 review thread 0건 확인
- [x] PR #89 squash merge — commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824`
- [x] Issue #88 completed 확인

## 문서 동기화 계약

- [x] `docs/PROJECT_UPDATE_PROTOCOL.md` 생성
- [x] `docs/DECISION_LOG.md`에 핵심 설계 결정 보존
- [x] 자동 검증과 사람 검증 상태 분리
- [x] 과거 3주·4주×3슬롯 증거 보존
- [x] ANNUAL-MVP-002 구현·검증을 Status·Handoff·Roadmap·Checklist·Decision Log에 동기화
- [ ] 이후 모든 기획·구현 PR에서 영향 문서 동시 갱신

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
- [ ] 동료별 장점을 설명
- [ ] 지원 적격·확률·준비도·보장 발동 설명
- [ ] 장비·동료가 사건 정답을 제공한다고 오인하지 않음
- [ ] 일정 미리보기·템플릿·undo가 반복 조작 피로를 줄임

## 현재 상태

```text
annual_mvp_001_seven_day_contract: APPROVED
annual_mvp_001_seven_day_implementation: MERGED
annual_mvp_001_automated_verification: PASSED
annual_mvp_002_design: APPROVED_IMPLEMENTATION_BASELINE
annual_mvp_002_implementation: MERGED
annual_mvp_002_automated_verification: PASSED
annual_mvp_002_merge: COMPLETE
human_usability_qa: NOT_RUN
player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
annual_mvp_003: NOT_APPROVED
```
