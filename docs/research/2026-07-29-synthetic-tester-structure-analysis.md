# 괴이기록국 합성 테스터 적용 구조 분석

```yaml
analysis_id: URBAN-LEGEND-SYNTH-STRUCTURE-001
repository: alsdmlals4-eng/urban-legend
baseline_branch: main
baseline_commit: 4ca854dba4926ebb6da3f445dd494dd82d6f3d80
work_mode: PLAN_AND_REVIEW
validation_method: SYNTHETIC_TESTER_SIMULATION
evidence_tier: T6_AI_INFERENCE
base_governance_commit: 9c4071c5ecefe28769b512d426442338ceb7acdd
human_validation: NOT_RUN
implementation_authority: NONE
```

## 1. 분석 목적

저승역 가설 보드의 4→2 배제, 지지·반박·미해결 연결, 최종 증명과 실패 복기를 AI 가상 페르소나로 공격하기 전에 현재 분석·사건 작성·QA Skill과 사건 정본을 복원한다. 합성 결과는 신규 플레이어의 실제 추리 행동이나 사건 공정성 통과 증거가 아니다.

## 2. 콜드 스타트 구조

```text
START_HERE.md
→ docs/CURRENT_STATUS.md
→ 문서 지도·Skill Registry
→ 프로젝트 코어·사건 정본
→ afterlife_station_poc.json
→ Evidence Pack
→ 사람 검증 Artifact
→ analytics-user-research
→ investigation-case-authoring/fairness-review
→ urban-legend-qa·Base 적대적 검토
```

## 3. current_skill_registry

### selected_project_skills

| Skill | Mode | 책임 |
|---|---|---|
| `urban-legend-analytics-user-research` | `playtest-analysis` | 첫 시도·교정 후 시도·정보 조건·오해 가설 분리 |
| `urban-legend-analytics-user-research` | `synthesis` | 합성 Finding을 실제 사람·telemetry·runtime 증거와 분리 |
| `urban-legend-investigation-case-authoring` | `fairness-review` | 관측 사실·가설·반례·미해결 관계의 사건 공정성 공격 |
| `urban-legend-qa` | evidence / regression review | 사건 ID·상태·문서·보호 경로 일치 확인 |

### selected_base_skills

| Skill | Mode | 책임 |
|---|---|---|
| `governing-game-user-research-coverage` | `plan-evidence` | 합성 페르소나와 실제 신규 플레이어 표본 분리 |
| `running-adversarial-review-and-refinement` | `attack` | 정답 자동조립·진행자 교육 효과·보드 최소 노동 악용 공격 |
| `running-adversarial-review-and-refinement` | `validate-critique` | 실제 저승역 JSON·관측 사실과 비판 대조 |
| `reviewing-and-validating-project-changes` | `evidence-report` | 자동 QA·사람·합성 상태 분리 |

## 4. canonical_sources

| 책임 | 경로 |
|---|---|
| 시작 경로 | `START_HERE.md` |
| 현재 상태 | `docs/CURRENT_STATUS.md` |
| Skill Registry | `skills/SKILL_REGISTRY.json` |
| 프로젝트 코어 | `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md` |
| 저승역 사건 데이터 | `data/poc/core_mvp_001/afterlife_station_poc.json` |
| Evidence Pack | `docs/research/2026-07-29-fair-play-hypothesis-board-evidence-pack.md` |
| 사람 검증 패킷 | `docs/superpowers/plans/2026-07-29-hypothesis-board-human-validation-artifact.md` |
| 실제 상태·로그 | `scripts/core/game_state.gd`, 현재 JSONL·Save 계약 |

## 5. protected_paths

```yaml
protected_paths:
  - data/poc/core_mvp_001/afterlife_station_poc.json
  - scripts/core/game_state.gd
  - data/episodes/**
  - investigation and combat scenes
  - save schema
  - existing JSONL event contract
```

거짓 전조·비관측 규칙·신규 정답 단서를 추가하지 않는다.

## 6. validation_routes

| 증거 | 상태 |
|---|---|
| 문서 계약·자동 QA | 기존 PASS 이력, 이번 PR 재검증 |
| 저승역 runtime | 기존 PoC 존재, 이번 작업 `NOT_RUN` |
| 신규 플레이어 추리 | `NOT_RUN` |
| 장기 사용·접근성 | `NOT_RUN` |
| 합성 사건·UX 위험 검토 | `T6_AI_INFERENCE` |

## 7. 분석 대상

- 4개 선택지에서 기록을 근거로 2개 배제.
- 관측 단서 6개와 경쟁 가설 2개.
- `지지 / 반박 / 미해결` 관계 편집.
- 원문 장면 복귀.
- 최종 가설과 근거 묶음 제출.
- 결과 뒤 오독한 근거·다음 조사 질문 작성.
- `BY_SCENE / ALL_AT_ONCE` 정보 조건.

## 8. 페르소나 렌즈

| ID | 공격 목적 |
|---|---|
| `MYSTERY_NOVICE` | 관측 사실·해석·가설 관계 혼동 |
| `MYSTERY_EXPERT` | 정답 단서 강도·사건 공정성·대안 가설 생존성 |
| `ANSWER_SEEKER` | 시스템 제안·진행자 교정을 정답으로 사용 |
| `MINIMAL_LABOR_OPTIMIZER` | 결정적 단서만 연결하고 보드 작업 최소화 |
| `CONFIDENCE_MAPPER` | 지지/반박/미해결을 확신도 척도로 오해 |
| `IMPATIENT_READER` | 원문 복귀 없이 요약 카드만 사용 |
| `LOW_WORKING_MEMORY` | 6단서·2가설·3관계·원문 왕복 부담 |

## 9. 산출물

```yaml
structure_analysis: COMPLETED
simulation_report: docs/research/2026-07-29-hypothesis-board-synthetic-tester-report.md
human_session_packet_changed: false
case_data_changed: false
save_schema_changed: false
human_validation: NOT_RUN
implementation_authority: NONE
```
