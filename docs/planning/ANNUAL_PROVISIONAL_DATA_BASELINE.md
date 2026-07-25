# 연도제 세부 데이터 임시 기준선

> 상태: `PROVISIONAL_BASELINE`
> 사용자 위임: 세부 데이터는 구현 준비를 위해 우선 임의 작성
> 추적: Issue #84
> 적용 원칙: 수치와 신규 ID는 플레이 검증 전 조정 가능

## 1. 사용 규칙

- 이 문서의 수치·목록·신규 ID는 `FIXED_CONTRACT`가 아니다.
- 기존 저장이나 런타임에서 사용하기 전 ID 충돌 감사를 수행한다.
- 오현과 기존 ANNUAL-MVP-001 활동·스킬·장비·연구 ID는 변경하지 않는다.
- 신규 표시명은 세계관·대사 검토에서 바꿀 수 있으나 실제 저장에 사용한 ID는 migration 없이 변경하지 않는다.
- 밸런스 조정은 `docs/DECISION_LOG.md`에 변경 근거와 supersession을 남긴다.

## 2. 기본 수치 척도

| 데이터 | 범위 | 기본값 |
|---|---:|---:|
| 역량 | 0~100 | 20 |
| 피로 | 0~100 | 15 |
| 업무 신뢰 | 0~100 | 20 |
| 개인적 유대 | 0~100 | 10 |
| 기관 평가 | -100~100 | 0 |
| 지원 준비도 | 0~100 | 0 |
| 사건 위험 | 0~100 | 사건별 |
| 피해 | 0~100 | 0 |
| 연구 자원 | 0 이상 정수 | 0 |

역량 100은 일반 캠페인 상한이며 정답 자동 공개를 의미하지 않는다. 역량은 조사 선택지의 표현, 허용 오차, 추가 확인 기회, 피해 완화에만 사용한다.

## 3. 동료 기준선

오현은 기존 데이터를 유지한다. 아래 나머지 인물은 신규 임시안이다.

| ID | 표시명 | 직무 | 주 역할 | 보조 역할 | 초기 업무 신뢰 | 초기 유대 |
|---|---|---|---|---|---:|---:|
| `companion_ohyun` | 오현 | 현장 선임 | 현장 통제 | 관측 보조 | 기존값 | 기존값 |
| `companion_han_serin` | 한세린 | 기록 분석관 | 단서 정리 | 가설 반박 | 15 | 5 |
| `companion_park_doyun` | 박도윤 | 봉쇄 요원 | 피해 완화 | 포획 준비 | 10 | 5 |
| `companion_yoon_seoa` | 윤서아 | 협력기관 연락관 | 민간인 보호 | 회복 지원 | 20 | 10 |
| `companion_choi_minjae` | 최민재 | 신호 기술관 | 전조 판독 | 장비 안정화 | 10 | 0 |

### 3.1 동료 고유 스킬

고유 스킬은 조건이 명확한 사건당 1회 확정 지원이다. 핵심 정답이나 미관측 패턴명을 직접 알려주지 않는다.

| 스킬 ID | 소유자 | 발동 조건 | 효과 | 제한 |
|---|---|---|---|---|
| `skill_unique_ohyun_field_anchor` | 오현 | 첫 현장 피해 발생 직전 | 해당 피해 10 감소, 위험 5 감소 | 사건당 1회 |
| `skill_unique_han_serin_cross_index` | 한세린 | 관련 단서 3개 이상 확보 | 이미 확보한 기록 사이의 모순 1개 강조 | 신규 단서 생성 금지 |
| `skill_unique_park_doyun_safe_perimeter` | 박도윤 | 봉쇄 또는 민간인 보호 실패 직전 | 민간 피해 15 감소, 다음 대응 허용 시간 10% 증가 | 사건당 1회 |
| `skill_unique_yoon_seoa_continuity_care` | 윤서아 | 권나래가 경상 이상 상태 | 사건 종료 후 상태 악화 1단계 방지, 피로 10 회복 | 중상 제거 금지 |
| `skill_unique_choi_minjae_signal_lock` | 최민재 | 이미 관측한 전조 패턴 재등장 | 패턴 표시 시간을 20% 연장 | 미관측 패턴에는 미발동 |

### 3.2 공용 보조 스킬

| 스킬 ID | 표시명 | 기본 발동률 | 대상 | 효과 |
|---|---|---:|---|---|
| `skill_support_observation_second_read` | 2차 판독 | 35% | 조사 | 기존 단서의 태그 1개 추가 표시 |
| `skill_support_analysis_counterexample` | 반례 검토 | 30% | 가설 | 잘못 연결한 근거의 비용 1회 면제 |
| `skill_support_field_damage_buffer` | 충격 완화 | 35% | 현장 | 피해 6 감소 |
| `skill_support_field_risk_dampening` | 위험 억제 | 30% | 현장 | 사건 위험 5 감소 |
| `skill_support_civilian_guidance` | 민간 유도 | 40% | 보호 | 민간 피해 8 감소 |
| `skill_support_recovery_breathing` | 호흡 안정 | 45% | 회복 | 피로 8 회복, 불안 악화 방지 |
| `skill_support_signal_recheck` | 신호 재검 | 35% | 전조 | 이미 관측한 패턴의 표시 시간 10% 증가 |
| `skill_support_containment_window` | 봉쇄창 연장 | 25% | 회수 | 열린 포획 창 지속 시간 10% 증가 |

### 3.3 지원 준비도와 보장 발동

- 공용 보조 스킬의 기본 발동률은 표의 값을 사용한다.
- 관련 일정으로 사전 준비하면 해당 사건 동안 발동률 +10%p, 준비도 +10으로 시작한다.
- 발동 가능한 상황에서 실패하면 준비도 +20이다.
- 발동 성공 후 준비도는 0으로 초기화한다.
- 준비도 100이면 다음 적격 상황에서 반드시 발동한다.
- 표시 확률은 `기본 + 준비 보정 + 상황 보정`을 합산해 UI에 공개한다.
- 최종 발동률 상한은 90%이며 준비도 100의 보장 발동만 100%다.
- 동일 프레임에 여러 지원이 적격이면 고유 스킬 → 보장 발동 → 현재 확률이 높은 공용 스킬 순으로 해결한다.

### 3.4 출동 편성

- 권나래 + 동료 최대 2명
- 동일 주 역할 동료 2명을 편성할 수 있으나 중복 효과는 70% 효율로 적용
- 동료 교체는 출동 시작 전만 가능
- 동료 부재가 사건 해결 불가를 만들지 않음
- 동료 2명 모두 지원 불가 상태여도 권나래의 범용 대응으로 사건 진행 가능

## 4. 장비 기준선

### 4.1 기본 장비

| ID | 표시명 | 계열 | 기본 효과 | 모듈 슬롯 |
|---|---|---|---|---:|
| `equipment_observation_echo_recorder` | 잔향 기록기 | 관측 | 단서 기록 누락 1회 방지 | 1 |
| `equipment_observation_spectral_lens` | 분광 관측경 | 관측 | 관측 허용 오차 +10% | 1 |
| `equipment_protection_field_coat` | 현장 방호복 | 보호 | 첫 피해 8 감소 | 1 |
| `equipment_protection_anchor_line` | 안전 고정선 | 보호 | 이동·낙하 계열 위험 10 감소 | 1 |
| `equipment_containment_seal_case` | 봉쇄 인장함 | 봉쇄 | 포획 창 지속 시간 +8% | 1 |
| `equipment_containment_signal_beacon` | 기준 신호기 | 봉쇄 | 이미 관측한 전조 식별 시간 +10% | 1 |

장비는 출동당 주 장비 1개를 선택한다. 연구 해금 후 모듈 슬롯을 최대 2개로 확장한다.

### 4.2 모듈

| ID | 표시명 | 계열 | 효과 | 제한 |
|---|---|---|---|---|
| `module_observation_noise_filter` | 잡음 필터 | 관측 | 기록 분석 실패 비용 1 감소 | 사건당 2회 |
| `module_observation_trace_marker` | 흔적 표식기 | 관측 | 관측 단서의 출처 UI 강조 | 수치 효과 없음 |
| `module_observation_repeat_buffer` | 반복 버퍼 | 관측 | 관측 입력 허용 시간 +12% | 미관측 정답 공개 금지 |
| `module_observation_remote_probe` | 원격 탐침 | 관측 | 첫 위험 조사 피해 5 감소 | 사건당 1회 |
| `module_protection_impact_gel` | 충격 흡수재 | 보호 | 현장 피해 5 감소 | 최대 3회 |
| `module_protection_residue_lining` | 잔향 차폐재 | 보호 | 잔향 노출 획득량 20% 감소 | 최소 1 유지 |
| `module_protection_civilian_tag` | 민간 표식등 | 보호 | 민간 보호 대응 시간 +10% | 민간인 존재 시만 |
| `module_protection_emergency_release` | 긴급 해제끈 | 보호 | 구속 상태 1회 해제 | 사건당 1회 |
| `module_containment_stable_rune` | 안정 인장 | 봉쇄 | 포획 창 요구 안정도 5 감소 | 핵심 조건 변경 금지 |
| `module_containment_echo_net` | 잔향 포집망 | 봉쇄 | 잔향 자료 +1 | 성공적 회수 시만 |
| `module_containment_pattern_memory` | 패턴 기억판 | 봉쇄 | 이미 관측한 패턴 재등장 예고 +1초 | 신규 패턴 무효 |
| `module_containment_fail_safe` | 오작동 차단기 | 봉쇄 | 잘못된 봉쇄 입력의 피해 1회 50% 감소 | 사건당 1회 |

## 5. 연구 기준선

### 5.1 연구 자원

| 자원 ID | 표시명 | 획득처 | 용도 |
|---|---|---|---|
| `research_resource_records` | 관측 기록 | 조사·공식 규칙 | 관측·분석 연구 |
| `research_resource_residue` | 잔향 자료 | 안정화·회수 | 장비·봉쇄 연구 |
| `research_resource_risk_cases` | 위험 사례 | 실패 전진·피해 분석 | 보호·회복 연구 |
| `research_resource_institution` | 기관 협력 점수 | 업무·보고·민간 보호 | 공용 스킬·지원 연구 |

### 5.2 연구 비용

- Tier 1: 주 자원 2
- Tier 2: 주 자원 4 + 보조 자원 1
- Tier 3: 주 자원 6 + 보조 자원 2 + 선행 노드 2개
- 월간 PoC에서는 동시에 진행 중인 연구 프로젝트 최대 2개
- 연구 일정은 2~3일을 소비하며 프로젝트별 진행도 2~3칸을 요구

### 5.3 관측 연구

| 노드 ID | Tier | 효과 |
|---|---:|---|
| `research_observation_1_field_notation` | 1 | 조사 기록 UI의 출처·시간 태그 표시 |
| `research_observation_1_safe_recheck` | 1 | 위험 없는 재확인 1회 |
| `research_observation_2_cross_reference` | 2 | 확보 단서 4개 이상일 때 모순 후보 1개 강조 |
| `research_observation_2_signal_window` | 2 | 관측 허용 시간 +8% |
| `research_observation_3_parallel_log` | 3 | 동료 지원 실패 시 준비도 추가 +5 |
| `research_observation_3_evidence_integrity` | 3 | 조사 실패로 이미 확보한 핵심 단서를 잃지 않음 |

### 5.4 현장 통제 연구

| 노드 ID | Tier | 효과 |
|---|---:|---|
| `research_field_1_damage_protocol` | 1 | 첫 현장 피해 4 감소 |
| `research_field_1_route_marking` | 1 | 경로형 검증의 금지 구역 표시 시간 +8% |
| `research_field_2_risk_briefing` | 2 | 출동 전 위험 구성요소 1개 공개 |
| `research_field_2_civilian_corridor` | 2 | 민간 피해 5 감소 |
| `research_field_3_layered_containment` | 3 | 포획 창 지속 시간 +8% |
| `research_field_3_failure_conversion` | 3 | 불완전 안정화에서도 위험 사례 +1 |

### 5.5 지원 운용 연구

| 노드 ID | Tier | 효과 |
|---|---:|---|
| `research_support_1_readiness_drill` | 1 | 공용 스킬 시작 준비도 +5 |
| `research_support_1_clear_conditions` | 1 | 지원 발동 조건 UI를 항상 표시 |
| `research_support_2_shared_slot` | 2 | 동료 1명의 공용 슬롯 +1 |
| `research_support_2_miss_learning` | 2 | 적격 실패 준비도 +25로 증가 |
| `research_support_3_pair_protocol` | 3 | 서로 다른 주 역할 편성 시 각 발동률 +5%p |
| `research_support_3_guarantee_carry` | 3 | 사건 종료 시 준비도 최대 40까지 다음 사건 이월 |

### 5.6 회복 연구

| 노드 ID | Tier | 효과 |
|---|---:|---|
| `research_recovery_1_rest_quality` | 1 | 직접 휴식 피로 회복 25→28 |
| `research_recovery_1_exposure_wash` | 1 | 직접 휴식 시 잔향 노출 1 감소 가능 |
| `research_recovery_2_clinic_network` | 2 | 기관 치료 일정 3일→2일 |
| `research_recovery_2_aftercare` | 2 | 사건 후 피로 증가 10% 감소 |
| `research_recovery_3_trauma_protocol` | 3 | 중상 악화 판정 1회 취소 |
| `research_recovery_3_team_debrief` | 3 | 사건 후 관련 동료 업무 신뢰 +2 추가 |

## 6. 상태·회복 기준선

| 상태 ID | 단계 | 발생 조건 예시 | 효과 | 기본 회복 |
|---|---|---|---|---|
| `condition_injury_minor` | 경상 | 피해 25 이상 | 현장 활동 피로 +5 | 직접 휴식 2일 또는 치료 1일 |
| `condition_injury_major` | 중상 | 피해 60 이상 또는 경상 악화 | 현장 일정 선택 제한 | 기관 치료 3일 |
| `condition_anxiety_1` | 불안 | 위험 사건 실패 | 검증 허용 시간 -5% | 상담 1일 |
| `condition_anxiety_2` | 공황 경향 | 불안 상태 재실패 | 첫 현장 입력 허용 시간 -15% | 상담 2일 |
| `condition_obsession_1` | 집착 | 같은 연구 3회 연속 | 연구 효율 +1, 휴식 회복 -5 | 다른 활동 2일 |
| `condition_overconfidence_1` | 과신 | 연속 무피해 성공 3회 | 위험 표시 1개 축소, 성장 +5% | 실패 경험 또는 브리핑 1일 |
| `condition_residue_exposure_1` | 잔향 노출 | 불완전 안정화 | 월말 피로 +5 | 차폐·치료 1일 |
| `condition_sleep_debt_1` | 수면 부족 | 자동 휴식 없이 2주 연속 고피로 | 모든 일정 피로 +2 | 직접 휴식 2회 |

공통 규칙:

- 상태는 핵심 단서나 범용 대응을 완전히 제거하지 않는다.
- 중상만 현장 일정 선택을 제한할 수 있으며 대체 회복 일정은 항상 제공한다.
- 상태 악화는 결과 화면에서 원인과 회복 방법을 함께 표시한다.
- 자동 휴식은 상태 회복 이벤트를 발생시키지 않는다.

## 7. 1분기 콘텐츠 기준선

### 7.1 분기 수량

| 콘텐츠 | 수량 |
|---|---:|
| 핵심 사건 | 1 |
| 중형 사건 | 2 |
| 소형 사건 | 4 |
| 기관 요청 | 6 |
| 연구 프로젝트 | 4 |
| 주요 동료 이벤트 | 동료당 2 |
| 월말 정산 | 3 |
| 분기 결산 | 1 |

### 7.2 봄 분기 사건 ID

| ID | 규모 | 임시 제목 | 기능 |
|---|---|---|---|
| `case_spring_core_01_last_platform` | 핵심 | 마지막 승강장의 호명 | CORE-MVP-001 확장 재사용 |
| `case_spring_medium_01_window_count` | 중형 | 열세 번째 창문 | 순서·관측 규칙 |
| `case_spring_medium_02_returned_voice` | 중형 | 돌아온 음성메모 | 신호·대상 식별 |
| `case_spring_small_01_wet_footprints` | 소형 | 마르지 않는 발자국 | 경로 규칙 입문 |
| `case_spring_small_02_empty_uniform` | 소형 | 빈 교복의 출석 | 대상 조건 입문 |
| `case_spring_small_03_elevator_pause` | 소형 | 4층과 5층 사이 | 타이밍 규칙 입문 |
| `case_spring_small_04_name_on_receipt` | 소형 | 영수증의 낯선 이름 | 기록 모순 입문 |

### 7.3 기관 요청

| ID | 소요일 | 보상 | 실패 전진 |
|---|---:|---|---|
| `request_spring_01_archive_cleanup` | 1 | 관측 기록 +1 | 기관 평가 -2 |
| `request_spring_02_civilian_briefing` | 2 | 기관 협력 +2 | 민간 관련 사건 위험 +3 |
| `request_spring_03_equipment_audit` | 1 | 장비 안정도 +1회 | 모듈 해금 지연 |
| `request_spring_04_joint_training` | 2 | 동료 준비도 +10 | 업무 신뢰 상승 없음 |
| `request_spring_05_residue_transport` | 2 | 잔향 자료 +1 | 잔향 노출 +1 |
| `request_spring_06_public_report` | 1 | 기관 평가 +5 | 진실 공개 성향 변화 기회 상실 |

## 8. 사건 제작 데이터 규격

모든 신규 사건은 다음 필드를 가진다.

```text
case_id
scale
season
premise
warning_start_day
deadline_day
voluntary_dispatch_day
forced_dispatch_day
risk_curve
investigation_scenes
clues
exclusion_options
hypotheses
evidence_links
unresolved_questions
validation_game
omen_patterns
universal_responses
capture_window
outcomes
research_rewards
relationship_effects
institution_effects
manual_entries
```

규모별 최소 수량:

| 필드 | 소형 | 중형 | 핵심 |
|---|---:|---:|---:|
| 조사 장면 | 2 | 4 | 6 |
| 핵심 단서 | 4 | 7 | 10 |
| 오인 단서 | 1 | 2 | 3 |
| 가설 | 2 | 2~3 | 3~4 |
| 미해결 질문 | 1 | 2 | 3 |
| 전조 패턴 | 1~2 | 3 | 4~5 |
| 범용 대응 | 모든 패턴에 1개 이상 | 모든 패턴에 1개 이상 | 모든 패턴에 1개 이상 |
| 결말 | 3 | 4 | 5 이상 |

## 9. 관계 기준선

### 9.1 두 축

- 업무 신뢰: 임무 수행, 약속, 책임, 보고, 위기 대응
- 개인적 유대: 사적 대화, 가치 공유, 상처 공개, 일상 교류

### 9.2 관계 단계

| 단계 | 필요 조건 | 기능 |
|---|---|---|
| 0 낯선 동료 | 기본 | 업무 대사만 |
| 1 협업 가능 | 업무 신뢰 20 | 공용 스킬 장착 가능 |
| 2 신뢰 형성 | 업무 40, 유대 20 | 개인 이벤트 1군 |
| 3 가치 충돌 | 업무 55, 유대 40 | 가치 선택과 관계 분기 |
| 4 깊은 관계 | 업무 70, 유대 65 | 우정·멘토·라이벌·로맨스 후보 |
| 5 연도 결산 | 분기 플래그 충족 | 관계 결산과 다음 연도 seed |

### 9.3 가치 태그

- `value_relief_priority`: 괴이 구제 우선
- `value_civilian_priority`: 민간인 보호 우선
- `value_institution_priority`: 기관 절차 우선
- `value_truth_priority`: 진실 공개 우선

동료별 선호 태그 2개와 충돌 태그 1개를 가진다. 수치가 높아도 핵심 가치 충돌을 해결하지 않으면 단계 4 이상으로 진입하지 않는다.

### 9.4 선택적 로맨스

- 임시 로맨스 가능 후보: 한세린, 윤서아
- 로맨스는 단계 4 이후 명시적 선택으로만 진입
- 미선택 시 완결된 우정 또는 전문적 동반자 결산 제공
- 로맨스 보상은 전투·조사 정답이 아니라 결산 장면, 지원 표현, 다음 연도 관계 seed다.

## 10. 조작형 규칙 검증 기준선

### 10.1 경로 봉쇄

| 난이도 | 노드 | 금지 구역 | 제한 시간 | 허용 실수 |
|---|---:|---:|---:|---:|
| 입문 | 6 | 1 | 45초 | 2 |
| 표준 | 9 | 2 | 55초 | 2 |
| 고급 | 12 | 3 | 65초 | 1 |

### 10.2 신호 동기화

| 난이도 | 입력 수 | 주기 변화 | 기본 허용 오차 | 실패 전진 |
|---|---:|---:|---:|---|
| 입문 | 4 | 없음 | ±350ms | 반응 단서 1개 |
| 표준 | 6 | 1회 | ±250ms | 위험 사례 1개 |
| 고급 | 8 | 2회 | ±180ms | 피해 + 반응 단서 |

### 10.3 대상 식별

| 난이도 | 후보 수 | 조건 수 | 오인 후보 | 제한 시간 |
|---|---:|---:|---:|---:|
| 입문 | 5 | 2 | 1 | 50초 |
| 표준 | 8 | 3 | 2 | 60초 |
| 고급 | 12 | 4 | 3 | 75초 |

성장·장비 보정 상한:

- 제한 시간 최대 +20%
- 타이밍 허용 오차 최대 +25%
- 허용 실수 최대 +1
- 정답 대상 자동 강조 금지

## 11. 1년 캠페인 기준선

| 분기 | 핵심 사건 | 중형 | 소형 | 주요 시스템 초점 |
|---|---:|---:|---:|---|
| 봄 | 1 | 2 | 4 | 적응·기초 조사·첫 관계 |
| 여름 | 1 | 2 | 4 | 전문화·도시 확산·협력기관 |
| 가을 | 1 | 3 | 3 | 가치 충돌·기관 압박·실패 누적 |
| 겨울 | 1 | 2 | 3 | 누적 회수·연도 핵심·결산 |

연간 기본량:

- 핵심 사건 4
- 중형 사건 9
- 소형 사건 14
- 기관 요청 24
- 주요 동료 이벤트 동료당 8
- 연구 분야 4, 노드 24
- 장비 6, 모듈 12
- 관계 결산 동료당 최소 3종

## 12. 연도 결산과 계승 payload

```text
schema: annual-year-end-v1
protagonist:
  competencies
  fatigue
  conditions
  values
companions:
  work_trust
  personal_bond
  relationship_stage
  ending_tag
institution:
  evaluation
  cooperation_flags
archive:
  official_rules
  risk_cases
  unresolved_questions
  manuals
cases:
  stabilized
  incomplete
  escaped
research:
  resources
  unlocked_nodes
equipment:
  owned
  installed_modules
next_year:
  mystery_seeds
  relationship_seeds
  institutional_pressure
```

계승 원칙:

- 수치 전체를 무한 누적하지 않고 전문화·결산 태그로 압축한다.
- 실패 사건도 위험 사례와 후속 사건 seed를 남긴다.
- 미해결 질문은 다음 연도에서 자동 정답이 아니라 조사 출발점으로 사용한다.
- 다음 연도 시작 시 핵심 역량은 소프트 캡을 적용하고 신규 전문화 선택지를 제공한다.

## 13. 밸런스 조정 우선순위

플레이 검증에서 문제가 발생하면 다음 순서로 조정한다.

1. UI 설명과 조건 가시성
2. 일정 비용과 회복량
3. 지원 준비도와 보장 발동 속도
4. 피해·위험 완화량
5. 연구 비용과 해금 순서
6. 콘텐츠 수량
7. 시스템 삭제 또는 재설계

핵심 정답 자동 공개나 필수 동료 지정으로 난이도를 해결하지 않는다.

## 14. 현재 판정

```text
provisional_companion_data: AUTHORED
provisional_skill_data: AUTHORED
provisional_equipment_data: AUTHORED
provisional_research_data: AUTHORED
provisional_condition_data: AUTHORED
provisional_quarter_data: AUTHORED
provisional_case_schema: AUTHORED
provisional_relationship_data: AUTHORED
provisional_validation_game_data: AUTHORED
provisional_year_end_payload: AUTHORED
implementation_binding: NOT_STARTED
play_balance_validation: NOT_RUN
```
