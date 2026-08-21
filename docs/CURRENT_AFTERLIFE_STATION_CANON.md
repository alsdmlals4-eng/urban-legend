# 저승역 현재 정본

> 문서 역할: `CURRENT_AFTERLIFE_STATION_CANON`
> 상태: `MERGED_CANON / PLANNING_COMPLETE / IMPLEMENTATION_HANDOFF_READY / RUNTIME_MUTATION_NOT_AUTHORIZED`
> 원 기획 병합 PR: `#143`
> 정본 Source Map: `docs/planning/2026-08-04-afterlife-station-canonical-source-map-and-legacy-disposition.md`
> 현재 M01 회수/첫 세션 적용: `docs/M01_RECOVERY_SCENE_PACKET.md`
> current implementation handoff: `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`

저승역 관련 current 제품 의미는 이 문서에서 시작한다. 역사 Ledger, 구형 Episode·PoC·CORE-VALIDATION 문서가 이 문서와 충돌하면 current Planning Canon과 이 문서를 우선한다.

## 현재 제품 흐름

```text
Opening Record / 기록국 첫 업무 / 제한된 첫 일정
→ 현장 단서 [기록] 조사
→ 경쟁 가설·근거망·괴이 매뉴얼
→ 피해자 구출
→ 전조형 회수
→ COMPOSITE_RESULT
→ 남은 주 후일담·연구·관계
```

빈칸이나 추론문 완료는 정답 확인 그 자체가 아니다. 구출·회수에서 규칙을 실제로 적용하고, 세션 종료 뒤 복합 결과와 확인된 규칙 범위에서 판정한다.

## 승인 Decision 1~10

1. `D-2026-08-04-AFTERLIFE-STATION-PERSONAL-DESTINATION-PROJECTION`
2. `D-2026-08-04-AFTERLIFE-STATION-DESTINATION-BOUNDARY-RESET`
3. `D-2026-08-04-AFTERLIFE-STATION-OFFICIAL-ROUTE-TICKET-AND-CORRECT-DISEMBARKATION`
4. `D-2026-08-04-AFTERLIFE-STATION-NONSTOP-FAREWELL-TICKET-COUNTER`
5. `D-2026-08-04-AFTERLIFE-STATION-RECURRING-PLATFORM-PERSISTENT-TRACE-ANCHOR`
6. `D-2026-08-04-AFTERLIFE-STATION-DESTINATION-CHORUS-SILENCE-COUNTER`
7. `D-2026-08-04-AFTERLIFE-STATION-THREE-CHAPTER-MANUAL-AND-CANDIDATE-POOLS`
8. `D-2026-08-04-AFTERLIFE-STATION-FIRST-TEN-MINUTES-INVESTIGATION-PACING`
9. `D-2026-08-04-AFTERLIFE-STATION-OUTCOME-GRADE-AND-REINVESTIGATION`
10. `D-2026-08-04-AFTERLIFE-STATION-VISUAL-ART-AND-INFORMATION-LANGUAGE`

Decision 9의 후속 재조사·기록 재현·승인 철수 같은 고유 의미는 보존한다. 단일 S/A/B/S-rank가 current 제품 결과 전체를 소유한다는 과거 의미는 successor `COMPOSITE_RESULT`로 대체된다.

## 핵심 규칙

- 방송 목적지 공백은 듣는 사람의 귀환 기억으로 채워진다.
- 안내 종료 전 자신이 들은 목적지를 향해 경계를 넘으면 시간·기록은 유지되고 위치만 초기화된다.
- 피해자의 현실 귀환 경로와 일치하는 공식 승차권을 회수하고 지정 역에서 함께 하차한다.
- 회수는 조사 기록을 다시 사용한다.
  - `[목적지 합창]`
  - `[회귀 승강장]`
  - `[무정차 환송]`
- 세 패턴의 전조·대응·첫 세션 teaching order는 `docs/M01_RECOVERY_SCENE_PACKET.md`가 소유한다.
- 매뉴얼·접근성 기능은 정답 대응·좌표·타이밍을 자동 표시하지 않는다.
- `SERIAL_EXAM_FATIGUE_GUARD`: 각 Phase가 새 정답 체계를 추가하지 않고 동일 규칙을 관측→해석→적용→실행으로 재사용한다.

## 현재 결과 계약

`LEGACY_SINGLE_GRADE_SUPERSEDED`

현재 result authority는 `COMPOSITE_RESULT`다.

최소 독립 축:
- 피해자 상태 / 구조 결과
- 확인된 규칙·증거 무결성
- 회수·안정화/통제 상태
- 보호 책임·위험 사례
- 잔향 / 미회수 상태
- 미해결 질문·후속 실행
- 관계·연구·정보 공유 변화

구출 성공 뒤 회수 중단/실패는 피해자 구출을 소급 삭제하지 않는다. 구출 성공만으로 회수 성공을 자동 승격하지 않는다.

## Fresh-main runtime successor

2026-08-22 Reality Gate에서 current main을 다시 확인한 결과 Canon v2 runtime/save migration은 **미구현이 아니다**.

현재 존재하고 재사용할 owner:
- `data/episodes/episode_001_afterlife_station_canon_v2.json`
- `data/episodes/episode_001_afterlife_station_canon_v2_runtime_projection.json`
- `data/migrations/afterlife_station_canon_v2_id_migration.json`
- `scripts/data/afterlife_canon_v2_loader.gd`
- `scripts/core/afterlife_main_save_migrator.gd`
- `scripts/core/afterlife_migrating_game_state.gd`
- `scripts/core/afterlife_migrating_validation_session.gd`
- `scripts/core/recovery_outcome_policy.gd`
- `scripts/ui/canon_v2_result_axes_bridge.gd`

판정:

```text
EXISTING_CANON_V2_RUNTIME_REUSE
COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT
```

따라서 과거의 “migration design부터 새로 시작”하는 next step은 predecessor다.

현재 필요한 정합화는 두 가지다.

1. `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED`
   - Canon v2 sidecar의 `owns_first_s_rank`/`s_rank` current-like authority를 history/mastery compatibility로 내린다.
   - 기존 grade/save history 자체를 삭제하지 않는다.
2. `MONTHLY_STATE_NOT_IMPLEMENTED`
   - top-level optional `monthly_state`를 월간 orchestration owner로 추가한다.
   - case truth를 저장하거나 legacy report에서 완료를 추론하지 않는다.

기존 `mvp-038/039 → mvp-040` Afterlife migration, validation save v2, stable ID, checksum/backup/rollback은 재사용하고 전역 base save version을 임의로 변경하지 않는다.

## 피해자와 아트

- 대표 피해자: 이하린, 28세.
- 감정 앵커: 철거된 옛집에 마지막으로 돌아가지 못한 후회.
- 돌아가고 싶은 장소는 현실 귀환 경로의 정답이 아니다.
- 아트 축: 심야 도시철도 현실감, 개인 기억의 미세한 침입, 공식 교통 정보 문법, 공간 반복 공포, 기록국 현장 문서.
- 메인 treatment: `SOFT_ANIME_NOIR_LOCKED`.
- Dossier = UI/presentation language.
- concrete product-reference image/asset = `PRODUCT_REFERENCE_ASSET_PENDING`.

## 구형 자료 상태

Source Map이 파일별 lifecycle을 소유한다.

- 구형 Episode·CORE-VALIDATION·PoC 의미: current product 의미 `[대체됨]`; 필요한 compatibility 입력은 보존.
- 같은 시각으로 되돌아온다는 규칙: `[폐기]`.
- 검은 승차권 접촉·파괴 중심 해법: `[폐기]`.
- 과거 S/A/B/S-rank: history/mastery compatibility 보존 / current product authority `[대체됨]`.
- 이미 current main에 들어온 Canon v2 migration/runtime은 더 이상 `NOT_STARTED`나 `MERGE_NOT_AUTHORIZED`로 소비하지 않는다.

## 현재 Gate

```yaml
planning: COMPLETE
user_final_planning_declaration: APPROVED
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
implementation_contract: READY
runtime_implementation: NOT_AUTHORIZED
product_reference_asset: PENDING
canonical_root_runtime_receipt: NOT_RUN
human_qa: NOT_RUN
```

## 다음 Gate

1. current implementation design/plan readback.
2. runtime implementation 명시 실행 권한.
3. `COMPOSITE_RESULT` semantic realignment.
4. legacy grade/save compatibility regression.
5. additive `monthly_state`.
6. M01 First Session orchestration + `SERIAL_EXAM_FATIGUE_GUARD`.
7. exact-head automation + actual runtime receipt.
8. M01 First Session Human QA.

실행계획: `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`.

Planning은 완료됐지만 runtime mutation·Human QA·product-reference asset 승격은 각각 별도 Gate다.
