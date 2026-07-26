# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 연도제 원설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`  
> 최신 시간 계약: `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`  
> 확장 마스터 설계: `docs/superpowers/specs/2026-07-26-annual-expansion-master-design.md`  
> ANNUAL-MVP-002 상세 설계: `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md`  
> 최신 구현 계획: `docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md`  
> 벤치마크 권장안: `docs/planning/ANNUAL_BENCHMARK_RECOMMENDATIONS.md`

이 문서는 구현, 자동 검증, 렌더링·입력 QA, 신규 플레이어 검증을 분리한다. 자동 회귀와 화면 검증은 `POC_PASSED`, 연간 루프 통과, 제작 확대 승인을 뜻하지 않는다.

## 현재 기준

| 항목 | 현재 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| ANNUAL PoC 저장 | `annual-mvp-001-save-v1` 유지 |
| 엔진 | Godot 4.7.1 / GDScript |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 주인공 | 권나래 고정 |
| 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 사건 코어 main 통합 | PR #55 / commit `8d0bf91a2e31538d3c0f142c800a84e8e3693889` |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| 정본 전환 | `COMPLETE` — PR #61 |
| ANNUAL-MVP-001 원 구현 | `BUILD_READY` — PR #62 / commit `88522ce08f261bce6d61a8043c64caa3b982bd47` |
| 렌더링·입력 QA 통합 | `RENDERED_QA_PASSED` — PR #65 / commit `b4f2e224bf7a2a6ee511c83bbbd45cd9e0b8570a` |
| 그래픽 포인터 QA·모듈 토글 수정 | `PASSED` — PR #67 / commit `0f24efa204a04cca62a58e55628e6b831b9bef2d` |
| 4주 월간 보정 | `MERGED / AUTOMATED_QA_PASSED` — PR #70 / commit `20a0d052e4d48863481af7c3acc53805105d6a01` |
| PROJECT_CORE·GDD 4주 동기화 | `COMPLETE` — Issue #72 / PR #73 / commit `932bc39300bb6ba7f3169b98c25d910f0e01413a` |
| 7일 주간·가변 일정 계약 | `APPROVED / COMPLETE` — Issue #75 |
| 7일 주간 구현 | `MERGED / AUTOMATED_QA_PASSED` — PR #76 / commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478` |
| 7일 문서 계약 | `PASSED` — run #273 |
| 7일 ANNUAL 자동 검증 | `PASSED` — run #121 |
| 7일 시각·입력 QA | `PASSED` — run #51 |
| 확장 순서·임시 데이터 기준선 | `APPROVED_SEQUENCE / PROVISIONAL_BASELINE` — Issue #84 / PR #85 |
| 유사 장르 벤치마크 | `BENCHMARK_RESEARCH_COMPLETE / RECOMMENDED_FOR_REVIEW` — Issue #86 / PR #87 |
| ANNUAL-MVP-002 구현 | `MERGED / AUTOMATED_QA_PASSED` — Issue #88 / PR #89 / commit `c790bf747c0fa4f4427d9e4b49b22adbfce92824` |
| ANNUAL-MVP-002 데이터 계약 | `annual-mvp-002-v1`, base `annual-mvp-001-v3` |
| ANNUAL-MVP-002 문서 검증 | `PASSED` — run #333 |
| ANNUAL-MVP-002 자동 검증 | `PASSED` — run #167 |
| ANNUAL-MVP-002 시각·포인터 QA | `PASSED` — run #55 / artifact `8625300008` |
| GDD 버전 | v3.2 — 4주×7일 계약 반영 |
| GDD DOCX | 결정적 생성물, Git 비추적; 생성기 포맷 v5 |
| 사람 손 장시간 사용성 QA | `NOT_RUN` |
| 신규 플레이어 검증 | `NOT_RUN` |
| POC_PASSED | `NOT_DECLARED` |
| annual loop passed | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

## ANNUAL-MVP-001 활성 시간 계약

```text
1개월 = 4주 × 주당 7일 = 총 28일
→ 일정마다 1~3일 소비
→ 일정은 주차 경계를 넘지 못함
→ 남은 일수보다 긴 일정은 선택 불가
→ 7일 미만 첫 확정: 자동 휴식 경고, 편성 유지, 다시 선택 가능
→ 같은 편성으로 재확정: 남은 일수를 자동 휴식 처리
→ 직접 휴식: 1일, 피로 -25, 상태 회복 가능
→ 자동 휴식: 하루당 피로 5만 회복
→ 자동 휴식은 관계 이벤트·특수 회복·추가 보상 없음
→ 2주차 자율 출동 위험 0 또는 지연
→ 3주차 자율 출동 위험 15 또는 지연
→ 4주차 7일 결과 확인 후 긴급 강제 출동 위험 30
→ 기존 CORE-MVP-001 사건 → 연구·공용 스킬 → 월말/분기 결산 모형
```

### 활동별 소요일

| 활동 | 일수 |
|---|---:|
| 관측 훈련 | 2일 |
| 기록 분석 | 2일 |
| 현장 대응 훈련 | 3일 |
| 증언 면담 업무 | 2일 |
| 신호 현상 연구 | 3일 |
| 오현 협업 훈련 | 2일 |
| 직접 휴식 | 1일 |

### 구현된 시스템

- JSON 계약 `annual-mvp-001-v3`
- `max_weeks=4`, `days_per_week=7`, 월 28일
- 기존 3주 상태를 보존하고 활성 ANNUAL-MVP-001 Scene이 `AnnualMvp001StateV2` 사용
- 활동 일수 합계 검증과 7일 초과 불변성
- 첫 확정 경고와 같은 편성 두 번째 확정
- 자동 휴식 합산 결과 `annual001_activity_auto_rest`
- 주간 결과 `planned_days`, `used_days`, `auto_rest_days`, `activity_results`
- UI의 활동별 `N일`, `사용 X/7일`, `남은 Y일`
- 남은 일수보다 긴 활동 버튼 비활성화
- 2주차 위험 0, 3주차 위험 15, 4주차 강제 위험 30 유지
- 기존 활동·동료·스킬·장비·연구 ID 유지
- `annual-mvp-001-save-v1` payload와 본편 `mvp-039`·`mvp-038` 비침범
- CORE-MVP-001 외부 지원은 체력 회복·위험 완화만 허용
- 이해도·가설·관측 패턴·포획 표식 변경 금지
- 최신 main의 Base Skill 어댑터·자산·라이선스 기록 보존

## ANNUAL-MVP-002 수직절편 — main 병합 구현

### 구현 범위

- 독립 격리 경로 `data/poc/annual_mvp_002`, `scripts/poc/annual_mvp_002`, `scenes/poc/annual_mvp_002`
- 동료 3명 중 최대 2명 편성: 오현, 한세린, 박도윤
- 고유 스킬 3개와 공용 지원 6개
- 공용 지원의 적격 여부, 비적격 사유, 확률, 준비도, 보장 거리 공개
- 일반 확률 `기본 + 준비 일정 10%p + 업무 신뢰 0/5/10%p`, 상한 90%
- 적격 실패 준비도 +20, 실패 학습 연구 완료 시 +25, 준비도 100에서 다음 적격 발동 보장
- 장비 3개와 계열 호환 모듈 6개
- 연구 자원 4종, 연구 노드 8개, 동시 연구 최대 2개, 취소 시 예약 자원 75% 내림 반환
- 일정 결과 미리보기: 사용·남은 일수, 피로·역량·기관 영향
- 지난주 복사, 템플릿 3개, 전체 초기화, 마지막 변경 실행 취소
- 템플릿은 주차 전환 뒤에도 유지
- 주간 결과의 `무엇이 변했는가 / 왜 변했는가 / 다음 주 영향` 인과 요약
- 기존 CORE hook을 통한 피해·위험·허용 오차·회수 창 보조
- 확장 초기화·adapter 실패 시 기존 ANNUAL-MVP-001과 CORE 기본 동작으로 fallback
- save version을 올리지 않고 `state.annual_mvp_002` 선택 블록만 추가
- 구 저장은 기본 확장 상태로 복원하고 알 수 없는 ID는 `orphaned_ids`에 보존하되 효과 계산에서 제외

### 벤치마크 반영 경계

이번 수직절편에 포함:

- 일정 결과 미리보기
- 반복 편성 도구
- 동료 지원 투명성
- 주간 인과 요약

별도 후속 작업:

- 사건 징후 시계
- 관측·가설·반박 보드
- 연구·괴이 매뉴얼 전체 탐색 UI
- ANNUAL-MVP-003 분기 콘텐츠

### 자동 검증

- 문서 run #333: 기존 문서·archive·확장 기획·벤치마크 계약 PASS
- ANNUAL run #167: Python 계약, Godot 4.7.1 import, CORE focused, ANNUAL-MVP-001 focused, ANNUAL-MVP-002 focused, 전체 Godot 회귀 PASS
- Visual run #55: 기존 ANNUAL-MVP-001 키보드·포인터, 새 ANNUAL-MVP-002 실제 좌표 편성·템플릿·출동·동료 선택·사건 진입 PASS
- 1280×720·1920×1080 계획 초기, 결과 미리보기, 주간 인과 요약, 출동 편성 화면 캡처 PASS
- visual artifact `8625300008`
- 캡처 직접 검사: 한글 글리프 누락, 겹침, 잘린 핵심 정보 없음; 720p의 긴 계획 화면은 ScrollContainer로 접근 가능

## 역사적 구현·QA 증거

### 3주 구조 — HISTORICAL_REGRESSION_EVIDENCE

PR #62·#65·#67의 3주 구현과 다음 검증은 당시 실제 결과로 보존하지만 현재 시간 계약의 플레이 증거가 아니다.

- visual run #28 PASS
- ANNUAL run #94 PASS
- CORE focused 4/4
- ANNUAL focused 6/6
- 전체 Godot 회귀 49/49
- 대표 visual artifact `8617041311`
- 한국어 글리프·키보드·Esc·그래픽 포인터·모듈 toggle 수정

### 4주 × 3슬롯 구조 — HISTORICAL_REGRESSION_EVIDENCE

PR #70의 4주 구조는 달력 월 보정과 위험 0/15/30의 근거로 유지하지만, `3슬롯/주`는 최신 7일 계약으로 대체됐다.

- 문서 run #253 PASS
- ANNUAL run #101 PASS
- Visual run #34 PASS
- PROJECT_CORE·GDD 동기화 PR #73
- 문서 run #255 PASS
- ANNUAL run #103 PASS
- GDD v3.1 DOCX 11페이지 렌더 QA PASS

## 7일 계약 자동 검증

- 문서 계약 run #273: PASS
- ANNUAL run #121: Python 계약, Godot 4.7.1 import, CORE focused, ANNUAL focused, 전체 Godot 회귀 PASS
- Visual run #51: 키보드·Esc, 실제 그래픽 좌표 클릭, 자동 휴식 경고, 2·3·4주차 출동 경로와 1280×720·1920×1080 캡처 PASS
- PR #76 review thread: 0건
- PR #76 squash merge: commit `57c1f3d92e0fdae658826a23e5c2326fe9efe478`
- Issue #75: `completed`

## 충돌 해석 우선순위

1. 사용자가 승인한 ANNUAL-MVP-002 진행과 최신 벤치마크 반영 범위
2. `docs/superpowers/specs/2026-07-26-annual-mvp-002-companion-equipment-research-design.md`
3. `docs/superpowers/plans/2026-07-26-annual-mvp-002-vertical-slice-implementation-plan.md`
4. 사용자가 승인한 7일 주간·가변 일정 설계
5. `docs/superpowers/specs/2026-07-25-annual-mvp-001-seven-day-scheduling-design.md`
6. `CURRENT_STATUS`·`PROJECT_CORE`·GDD 활성 정본
7. PR #70의 4주×3슬롯 구현과 이전 3주 PoC

최신 기획을 우선하되 보호 경로, 저장 비침범, 기존 CORE 하위 호환 계약은 유지한다.

## 보호 경계

- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 `mvp-039`, `mvp-038`, `annual-mvp-001-save-v1`
- 기존 CORE 사건·ID

## 아직 구현하지 않은 범위

- 본편 1년 4분기 전체
- 실제 요일·공휴일·월별 사건 배치
- 일정이 주차 경계를 넘는 다주 일정
- 자동 휴식의 관계·특수 이벤트
- 관계·로맨스 연간 진행
- 중형·소형 일반 사건
- 신규 대표 조작형 규칙 검증 미니게임
- 사건 징후 시계와 관측·가설·반박 보드
- 전체 연구·괴이 매뉴얼 탐색 UI
- 본편 `GameState` 통합과 기존 save migration
- 연도 결산 계승 payload의 실제 다음 연도 소비
- ANNUAL-MVP-003·004 구현

## 다음 게이트

1. PR #89 changed-file·보호 경로·review thread 최종 감사와 squash merge
2. 실제 사람의 7일 편성·템플릿·동료·장비 반복 사용성 평가
3. 신규 플레이어의 2주차 조기·3주차 자율·4주차 강제 출동 플레이
4. 동료별 장점, 지원 확률·준비도·보장 발동, 육성→사건→연구 인과 설명 수집
5. 장비·동료가 사건 정답을 제공한다고 오인하지 않는지 확인
6. `KEEP / AMPLIFY / CHANGE / RETEST / HOLD` 판정
7. 별도 사용자 승인 전 ANNUAL-MVP-003과 제작 확대 시작 금지
