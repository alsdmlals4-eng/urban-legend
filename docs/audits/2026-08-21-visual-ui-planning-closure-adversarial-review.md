# Visual/UI Planning Closure — 5회 Whole-Scope Adversarial Review

Status: `FIVE_LOOPS_COMPLETE / P0_0 / P1_0 / PLAN_LOCK`
Scope: PR #221 Visual/UI planning closure only
Runtime/Product asset/Human evidence: unchanged

## Baseline

Goal:
- Visual/UI/Flow planning을 구현 handoff 가능한 수준으로 closure-ready로 만든다.
- concrete product-reference 이미지·runtime·Human QA를 완료로 과장하지 않는다.
- M01 First Session과 M04 release-near Vertical Slice의 서로 다른 검증 책임을 유지한다.

Protected paths:
- `data/`
- `scripts/`
- `scenes/`
- `assets/`
- `addons/`
- `project.godot`
- save schema / existing Episode·report·ANNUAL IDs

## Loop 1 — Authority / propagation / predecessor freshness

### Attack
- `WAITING_USER_DRAFT`와 `overall_plan: OPEN`이 current authority에 남아 closure를 되돌리는가?
- 역사 Ledger를 직접 잘라내면서 고유 구현·QA evidence를 잃는가?
- cold-start stable heading/contract를 깨뜨리는가?

### Finding
1. `CURRENT_STATUS.md`는 큰 역사 구현 Ledger라 상단 predecessor Overlay만 고치려고 전체 파일을 재작성하면 보존 위험이 컸다.
2. 최초 START_HERE 최소화 시도에서 기존 freshness regression이 사용하는 stable heading을 제거했다.

### Refinement
- `CURRENT_STATUS.md`를 삭제/축약하지 않고 `conditional_history_ledgers`로 내렸다.
- cold-start active entrypoint에서는 제거하고 current Gate는 `CURRENT_PLANNING_CANON` + machine canon + `CURRENT_DECISION_OVERLAY`가 소유한다.
- START_HERE의 기존 `현재 제품·Gate Snapshot / Verified successor / Validation Router` stable 구조를 복구하면서 새 Gate만 반영한다.

### Verify
- 기존 current-authority regression이 stable heading과 successor state를 다시 검증한다.
- 역사 Ledger 원문은 보존한다.

Result: corrected, no remaining P0/P1.

## Loop 2 — Evidence ceiling / false completion

### Attack
- Visual planning closure가 이미지 승인으로 오해되는가?
- 문서/자동 CI가 runtime/Human PASS를 만들어내는가?
- 기존 visual reference가 product asset 승인으로 승격되는가?

### Decision
세 Gate를 분리한다.

```yaml
visual_planning: CLOSURE_READY
product_reference_asset: PENDING
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
```

- `SOFT_ANIME_NOIR_LOCKED`는 treatment 결정이다.
- concrete 이미지·레이어·권리·해상도 검증은 `PRODUCT_REFERENCE_ASSET_PENDING`이다.
- Human/runtime/new-player/POC evidence는 실제 실행 전 승격하지 않는다.

Result: no remaining P0/P1.

## Loop 3 — Player value / serial exam fatigue

### Attack
M01의 `조사 → 추리 → 구출 → 회수`가 네 번 연속 다른 정답 시험처럼 느껴질 위험이 있는가?

### Finding
Investigation/Deduction/Rescue Packet은 존재했지만 current M01 Recovery Packet이 빠져 있어, 마지막 Phase가 별도 전투/퀴즈처럼 해석될 여지가 있었다.

### Refinement
`M01_RECOVERY_SCENE_PACKET.md`를 추가하고 `SERIAL_EXAM_FATIGUE_GUARD`를 고정했다.

- 조사: 관측한다.
- 추리: 같은 관측을 해석한다.
- 구출: 같은 규칙을 피해자 분리에 적용한다.
- 회수: 같은 규칙을 telegraph-first 실행으로 사용한다.
- Phase 전환마다 새 정답 체계를 만들지 않는다.
- 추리는 현장 복귀 가능, 구출은 독립 퀴즈가 아니며 첫 회수 패턴은 telegraph→response를 가르친다.

M01 회수 패턴:
- 목적지 합창
- 회귀 승강장
- 무정차 환송

Result: test-required Human risk remains, but planning-level P0/P1 is closed.

## Loop 4 — Visual coherence / benchmark collage risk

### Attack
- 소프트 애니 누아르와 Korean Urban Occult Dossier Hybrid가 서로 다른 ‘메인 화풍’으로 경쟁하는가?
- PARANORMASIGHT / Golden Idol / Obra Dinn / Into the Breach 참고가 콜라주 UI를 만드는가?
- pixel/dot가 메인 화면을 다시 지배하는가?

### Finding
Notion M04 Visual Decision에 `픽셀 / 저프레임 / 페인터리 / 하이브리드 매체 미확정` predecessor 문구가 남아, 이미 승인된 soft-anime-noir direction과 충돌했다.

### Refinement
- `SOFT_ANIME_NOIR_LOCKED` = character/key narrative art treatment.
- `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM` = field terminal / case file / anomaly manual UI language.
- pixel/dot = CCTV·sensor·log·map·interference supporting observation language only.
- benchmark는 외형이 아니라 원리 하나씩만 ADAPT한다.

Result: no remaining P0/P1.

## Loop 5 — Implementation handoff / legacy / role separation

### Attack
- 기획 closure가 즉시 runtime 구현 권한으로 오해되는가?
- M01과 M04가 같은 Vertical Slice 책임으로 합쳐지는가?
- 과거 S/A/B 결과가 current composite result를 다시 덮어쓰는가?
- save/ID migration이 계획 closure에 섞이는가?

### Refinement / Decision
- `overall_plan: CLOSURE_READY`, `user_final_planning_declaration: PENDING`, `PLAN_LOCK: ACTIVE`.
- 사용자의 최종 `기획 완료` 선언 뒤에도 fresh-main Reality Gate → migration/save matrix → 단일 구현 계약이 필요하다.
- M01 = First Session / onboarding / regression.
- M04 = 30~45m release-near player-experience validation.
- `LEGACY_SINGLE_GRADE_SUPERSEDED`: 과거 S/A/B는 역사/회귀 evidence로만 보존하며 current 결과는 `COMPOSITE_RESULT`가 소유한다.
- 기존 Episode/save/report/ANNUAL ID는 rename하지 않는다.

Result: no remaining P0/P1.

## Final decision

```yaml
full_scope_loops_completed: 5
p0: 0
p1: 0
visual_planning: CLOSURE_READY
product_reference_asset: PENDING
overall_plan: CLOSURE_READY
user_final_planning_declaration: PENDING
plan_lock: ACTIVE
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
```

Planning closure is ready for final user declaration. This audit does not authorize runtime implementation or claim product-reference/Human evidence.
