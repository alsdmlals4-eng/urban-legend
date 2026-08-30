# 괴이기록국 현재 기획 정본

> 역할: `CURRENT_PLANNING_CANON`
> 상태: `PLANNING_COMPLETE / USER_FINAL_PLANNING_DECLARATION_APPROVED / RUNTIME_RECONCILIATION_MERGED`
> 사람용 정본: repository `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`와 user PDF GDD
> 구조화·구현 정본: 이 저장소와 `docs/current-planning-canon.json`

이 문서는 승인된 **10일·반일 캠페인 기획**과 2026-08-24 PR #224 runtime reconciliation merge를 현재 진입점에 연결한다. 과거의 `1년 4분기`, `분기 핵심 사건 4개`, `월 1 메인 사건`, `4주 M04 timing`, `ANNUAL-MVP-*가 다음 기획 트랙`, `runtime_implementation: NOT_AUTHORIZED` 설명과 충돌하면 이 문서를 우선한다. `ANNUAL-MVP-001/002` 이름은 병합된 runtime·역사 식별자로 보존한다.

## 제품 약속

플레이어는 권나래로서 관측 가능한 단서로 괴이 규칙을 **조사·추리**하고, 그 가설을 전조 기반 **회수**에서 검증해 잔향을 안정화한다. 피해자 구출과 복합 결과는 이 판단이 사람에게 남긴 결과를 보여 주며, 10일·반일 일정은 이 핵심 경험에 준비와 후일담의 맥락을 더하는 보조 시스템이다. 성공·실패·미확정은 다음 판단에 쓰이는 기록과 매뉴얼로 남는다.

```text
사건 징후·출동
→ 조사
→ 추리·괴이 매뉴얼
→ 피해자 구출
→ 전조 기반 회수
→ 복합 결과
→ 후일담·연구·관계와 10일·반일 일정의 다음 준비
→ 다음 사건의 조사·추리·회수
```

### 핵심 경험 우선순위 — `D-2026-08-29-CORE-LOOP-PRIORITY`

- **1차 핵심 재미:** `조사 → 추리/괴이 매뉴얼 → 회수`. 플레이어는 먼저 무엇을 관찰했는지 설명하고, 경쟁 가설을 비교한 뒤, 전조에 맞는 대응으로 그 판단을 검증한다.
- **핵심을 표현하는 보조:** 키워드·매뉴얼은 추리의 근거를 표현한다. 피해자 구출과 복합 결과는 이 판단의 인간적 결과를 보존한다.
- **캠페인 보조 시스템:** 10일·오전/오후 일정은 준비 기회·후일담·관계의 리듬을 제공한다. 일정은 단서·진실·정답을 주거나 회수의 판정을 대체하지 않으며, 이 시스템만으로 Vertical Slice의 핵심 재미 통과를 주장하지 않는다.

### 플레이어가 완성하는 괴이 매뉴얼 — `D-2026-08-29-PLAYER-AUTHORED-MANUAL-KEYWORD-VERIFICATION`

- 매뉴얼은 읽기 전용 요약이나 정답표가 아니라, **빈 키워드가 놓인 읽을 수 있는 추리문**을 플레이어가 직접 완성하는 추리 도구다.
- 조사 선택으로 정상 키워드를 얻는다. 정상 키워드는 원본 출처·획득 행동·맥락을 보존한다. 한 변수만 달라진 변조 후보에는 독립 가짜 출처를 만들지 않으며, 사실이지만 쓰이지 않는 보조 후보와도 구분한다.
- 플레이어는 조사 기억 + 정상 키워드 원본 + 매뉴얼 문맥으로 후보를 고른다. UI는 중복·미획득·타입 불일치 같은 구조 오류만 막고, semantic correct/wrong, 정답 추천, 변조 표식, 호환 점수는 표시하지 않는다.
- 작성한 규칙은 구출 미니게임의 절차·순서·타이밍과 회수의 `전조 → 가설 → 근거 → 대응`에서 직접 검증한다. 매뉴얼 완성은 구출·회수를 자동 해결하지 않으며, 실패는 위험 사례·다음 조사 필요 기록이 된다.
- M01과 M04는 source-backed `candidate_keywords`와 빈칸 추리문을 실제 scene의 draft-only workbench로 소비한다. M01의 `normal_clear.reveal_complete_manual`은 `false`이며, M04는 같은 3개 기존 단서와 기존 rescue-gate를 사건 데이터 하나에서 소비한다. M05+ 또는 변조 후보의 field-verification 확장은 data·consumer가 없어 아직 구현되지 않았다.
- 사용자가 제공한 두 비교 이미지는 `USER_PROVIDED_PLANNING_UI_REFERENCE`다. 빈칸 추리문·후보·출처 보조라는 정보 구조만 참고하며 `NOT_PROJECT_ASSET / NOT_RUNTIME_ASSET / NOT_COPIED_TO_REPOSITORY`다.

## 10일·반일 cadence와 콘텐츠 예산

- 한 **10일 cycle**에 메인 사건 1개만 해결한다. 하루는 `오전 / 오후` 두 반일 슬롯으로 구성된다.
- Day 1~9의 해결은 **조기 해결**이다. Day 10의 해결은 **정규 해결**이다. Day 10은 지연·강제·벌점의 다른 이름이 아니다.
- 조기 해결은 더 이른 보호를, 정규 해결은 남은 반일 슬롯을 준비·조사·회복·관계에 쓸 수 있는 선택을 뜻한다. 두 선택 모두 정규 제품 경로이며 핵심 진실·정답·등급을 숨겨서 바꾸지 않는다.
- `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`가 전역 timing authority다. 이전 `D-2026-08-28-M04-EARLY-DISPATCH-REGULAR-WEEK4-CADENCE`의 `2/3/4주`, `0/15/30`, `0/+4/+8`은 **SUPERSEDED**이며 Day 값으로 임의 환산하지 않는다.
- `D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES`: M04의 복합 결과는 한 화면의 점수·카드 나열이 아니라 `피해자 → 잔향 → 귀가 기억 → 기록국` 순서의 짧은 이야기 페이지로 전개한다. 귀가 기억 페이지는 `조기/정규`, 해결일, 실제 권나래 지원 사용을 같은 인과로만 연결한다. M01과 기존 결과 의미·보상은 바꾸지 않는다.
- 조기 해결 뒤 같은 cycle의 두 번째 메인 사건을 생성하지 않는다. 남은 반일은 후일담·치료·연구·관계·다음 사건 준비로 환류한다.
- 초기 제작 Slate는 M01~M12이며 `1년차` 완료 Gate로 쓰지 않는다. M13+도 같은 cadence로 이어진다.
- Signature 4개는 M01 저승역, M04 빨간 우산, M07 폐주파수 방송국, M10 기록되지 않은 병동이다.
- Standard 8개도 조사·추리·구출·회수 중 한 단계를 생략하지 않는다.

### Runtime implementation readback · 2026-08-30

위 항목은 승인된 제품 계약이다. `CampaignState`는 이제 첫 실제 `begin_operation()`에서 `cycle_main_case_id`를 고정하고, 같은 cycle의 다른 메인 사건 계획·시작을 거부한다. `dispatch_kind / dispatch_day / dispatch_slot`은 active operation에서 resolution context로 보존되며, Preparation은 조기/정규 출동 문서와 다음 cycle 대기 이유를 보여 준다. M04 결과는 이 실제 context와 실제 `귀가 기억 고정` 지원 사용을 네 개의 native Godot logical page에 연결한다. 이는 focused automated evidence가 있는 구현 상태이며, Day 1~9/Day 10의 **numeric balance**와 Human/accessibility/release QA는 계속 `UNDEFINED / NOT_RUN`이다.

## 사건 공통 Core

모든 사건은 다음 계약을 지킨다.

1. 원시 관찰과 해석을 분리한다.
2. 그럴듯한 오답 가설과 관측 가능한 반증을 둔다.
3. 필수 진실을 단일 RNG 성공에 잠그지 않는다.
4. 괴이 매뉴얼의 의미 슬롯은 발생 조건, 피해자 연결, 금지 행동, 구출 절차, 회수 대응이다.
5. 구출 결과와 회수 결과는 서로 덮어쓰지 않고 복합 결과에 함께 남긴다.
6. 회수는 전조 중심으로 판단한다. 상시 1차 행동은 **공격 / 보호 / 보조** 세 카테고리이며 각각 관련 세부 행동을 2단으로 연다. 현재 전조가 발생하면 이동·환경 조작 같은 `CONTEXTUAL_TELEGRAPH_RESPONSE`를 별도 목록으로 제시한다. 과거의 평면 `보호/관찰/대응/공격/장비/봉쇄/후퇴` 7-command set은 `D-2026-08-25-RECOVERY-CONTEXT-ACTION-HIERARCHY`로 폐기된 predecessor다.
7. 실패는 위험 사례·비용·후속 조사·재출동 조건을 남긴다.
8. 사건 결과를 단일 S/A/B 등급 하나로 압축해 위 복합 결과를 덮어쓰지 않는다.

일정은 위 사건 공통 Core의 바깥에서 **언제 준비하고 언제 출동할지**를 조직하는 지원 구조다. 조사·추리의 관측/가설 연결과 회수의 전조/대응 검증이 약하면, 일정 선택이 존재해도 핵심 경험이 성립한 것으로 보지 않는다.

## M01과 M04의 다른 역할

- `M01 저승역`은 첫 세션·온보딩·회귀 사건이다. 기록 조각 → 기록국 첫 업무 → 제한된 주간 일정 → 저승역 → 첫 완전한 인과 체험을 가르친다.
- M01 첫 추리는 4개 후보를 사용한다. 공식 원본 목적지설과 동일 가짜 목적지설을 1차 배제하고, 개인 기억 투영설과 검은 승차권 원인설을 경쟁시킨 뒤 독립 기록으로 후자를 약화한다.
- 저승역 상세 규칙은 `docs/CURRENT_AFTERLIFE_STATION_CANON.md`가 소유한다. 검은 승차권 접촉·파괴를 정답으로 되살리지 않는다.
- M01 회수는 `docs/M01_RECOVERY_SCENE_PACKET.md`의 `목적지 합창 / 회귀 승강장 / 무정차 환송`을 재사용한다.
- M01 runtime은 10단계 First Session orchestrator와 additive `monthly_state`를 사용하며 별도 hidden truth owner를 만들지 않는다.
- `M04 빨간 우산`은 약 30~45분 release-near player-experience Vertical Slice다.
- M04의 대표 고민은 `Day 1~9에 더 이른 보호를 위해 출동할지, Day 10 정규 해결까지 반일 준비 기회를 사용할지`다. 구체적인 수치 효과는 새 구현 계약의 balance decision 전까지 `UNDEFINED`다. 결과는 Composite Result에서 추리·구출·회수와 분리된 출동 timing 인과로 설명하며, M04에서는 이를 한 화면에 합산하지 않고 순차 후일담으로 읽힌다.
- M04 shared-system validation baseline과 플레이어 작성 매뉴얼은 구현됐지만 최종 제품 시각·Audio/VFX·Human QA는 아직 Gate 밖이다.

## 화면·재사용 계약

- 조사는 장면 이미지, 짧은 서술, 2~4개 선택지, 기록·키워드 획득을 우선한다.
- 추리는 별도 괴이 매뉴얼 화면에서 출처, 경쟁 가설, 지지·반박·미해결, 추리문을 다룬다.
- 일반 조사에서는 환경·사건·증거가 주체이며 캐릭터는 작은 지원 표현과 중요한 순간의 Cut-in으로 제한한다.
- `SOFT_ANIME_NOIR_LOCKED`: 메인 캐릭터·중요 서사 일러스트 treatment.
- `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`: UI·정보 위계·현장/기록 구성 언어.
- `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION`: 현실적 한국 도시 누아르 환경 + 애니풍 인물·괴이 + 손그림 기록물 UI의 3층 문법을 사용자 승인했다. 이 결정은 기존 treatment를 구체화하며 product asset 교체를 뜻하지 않는다.
- 시각 정본의 Keep/Avoid/Do Not Drift와 생성 보드의 권한 경계는 `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`와 `docs/visual/PROJECT_CORE_SCENE_VISUAL_BOARD_2026-08-28.md`가 소유한다.
- M01~M12는 공용 화면 문법을 재사용하되 질문·반증·피해자 갈등·봉쇄 조건은 사건별로 구분한다.
- 메인 메뉴는 중앙 `Ver 4.3` owner와 관제실형 3-rail 구조를 사용하며 Legacy / Validation 영역을 분리한다.

## Visual planning과 product reference asset 분리

`PRODUCT_REFERENCE_ASSET_PENDING`은 계속 유지된다.

- 화면 구조·정보 위계·아트 treatment·캐릭터 노출·pixel 관측 언어는 기획 완료다.
- `PROJECT_CORE_SCENE_VISUAL_BOARD`는 AI 이해 검증·사용자 기획 검토용 단일 `GENERATED_EXPLORATION`이다. 보드의 pseudo-text·장식 map/card/icon·프레임은 시스템, UI, runtime asset, Scene, Human QA를 승인하지 않는다.
- 실제 M01/M04 이미지·레이어·권리·production reference 승격은 아직 승인되지 않았다.
- product reference asset 승인은 runtime 구현이나 Human QA PASS를 의미하지 않는다.

## 성장·결과·저장 방향

- 성장의 장기 방향은 0~5 Rank + 내부 숙련 진행도이며 threshold와 피로·연구 수치는 provisional이다.
- 성장은 Clarity·Access·Tolerance·Support를 바꾸며 핵심 진실이나 정답을 자동 제공하지 않는다.
- current result authority는 `COMPOSITE_RESULT`다.
- M04의 `COMPOSITE_RESULT` 표현은 `VIGNETTE_VICTIM_RESCUE → VIGNETTE_RESONANCE_RECOVERY → VIGNETTE_ROUTE_MEMORY → VIGNETTE_CASE_RECORD` 순차 후일담이다. `result_scene.gd`가 이를 native Godot logical page로 구현했고 M01/legacy direct result는 기존 surface를 유지한다. 이는 새 runtime Scene이나 정적 UI 이미지가 아니며 Human QA PASS를 뜻하지 않는다.
- Legacy grade/S-rank는 history/mastery compatibility만 허용한다.
- `monthly_state`는 top-level additive optional orchestration block으로 남아 있는 historical generic policy다. 새 10일 cadence의 live consumer는 `CampaignState`의 cycle lock/dispatch context, Preparation docket, M04 route-memory result page가 소유하며, 역사적 `dispatch_risk 0/15/30`을 새 날짜 효과로 환산하지 않는다.
- M01과 M04의 page-local keyword composition은 구현됐다. M04는 실제 사건 데이터의 세 기존 단서·두 기존 rule page·기존 rescue-gate를 그대로 사용하며, M01은 Canon V2 input을 유지한다. 이 두 사건의 draft placement는 구조 오류만 막고 semantic verdict를 내지 않는다. M05+ 및 변조 후보의 field-verification 확장은 여전히 별도 구현 계약이다.
- 기존 Episode ID, report, ANNUAL PoC state를 자동 rename·import·월 완료 추론하지 않는다.
- current main의 Canon v2 migration/runtime을 재사용한다.

## 2026-08-24 Runtime successor Reality Gate

PR #224가 squash merge되어 main `8d303f0f9414950273be934fd28c8fb1b3a21e18`에 반영됐다.

- `EXISTING_CANON_V2_RUNTIME_REUSE` → 유지.
- `COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT` → current authority로 정합화 완료.
- `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED` → legacy mastery compatibility로 완료.
- `MONTHLY_STATE_NOT_IMPLEMENTED` → additive optional 구현 완료.
- M01 First Session orchestration → 구현 완료, automated regression GREEN.
- #181 main menu / Ver 4.3 → 구현 완료, merged-main readback 뒤 Issue closed.
- M04 shared-system baseline → 구현 완료, final visual gate는 pending.
- Project Base Adapter protected baseline → PR #226에서 `6b4a9e8080898536139c8e825179b389f8bf9d64`으로 공식 generator reconciliation 완료; merge `9073b4730993149f89970a13fbe32d49f8f473e7`.

## 현재 Gate

```yaml
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
non_visual_planning: COMPLETE
visual_planning: COMPLETE
visual_direction_lock: USER_APPROVED
product_reference_asset: PENDING
overall_plan: COMPLETE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
automated_exact_head: GREEN
ten_day_half_day_cadence: USER_APPROVED / IMPLEMENTED_NON_NUMERIC_CONTEXT / FOCUSED_MACHINE_VERIFIED
one_main_case_runtime_enforcement: IMPLEMENTED / FOCUSED_MACHINE_VERIFIED
keyword_composition: IMPLEMENTED_M01_M04 / DRAFT_ONLY / FOCUSED_MACHINE_VERIFIED / OTHER_CASES_PENDING
player_authored_manual_keyword_verification: USER_APPROVED / IMPLEMENTED_M01_M04 / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
```

## 구현 provenance

완료된 runtime reconciliation의 근거 문서는 다음과 같다.
- `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

이 문서들은 재실행할 next-step owner가 아니라 완료된 구현의 provenance다.

## 정본 우선순위

```text
최신 사용자 승인
→ GitHub latest main
→ repository current GDD / decision / handoff
→ docs/current-planning-canon.json
→ 이 문서
→ CURRENT_DECISION_OVERLAY
→ 실제 code/data/Scene/test
→ 자동·Human 증거
→ 구현 provenance·역사 문서·과거 PR·legacy Sheet
```

Repository는 사람이 보는 전체 그림·Flow·비교표와 구조화 계약·구현·테스트·runtime evidence의 단일 권위다. Notion과 Google Sheet는 migration-only 역사 자료이며 `HISTORICAL_READ_ONLY_NO_WRITE`다. Notion current work의 이전 범위·source·destination·보존 reference는 `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md`가 기록한다.
