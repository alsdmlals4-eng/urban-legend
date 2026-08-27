# 괴이기록국 현재 기획 정본

> 역할: `CURRENT_PLANNING_CANON`
> 상태: `PLANNING_COMPLETE / USER_FINAL_PLANNING_DECLARATION_APPROVED / RUNTIME_RECONCILIATION_MERGED`
> 사람용 정본: Notion 프로젝트 홈과 하위 기획 페이지
> 구조화·구현 정본: 이 저장소와 `docs/current-planning-canon.json`

이 문서는 승인된 월간 기획과 2026-08-24 PR #224 runtime reconciliation merge를 현재 진입점에 연결한다. 과거의 `1년 4분기`, `분기 핵심 사건 4개`, `ANNUAL-MVP-*가 다음 기획 트랙`, `runtime_implementation: NOT_AUTHORIZED` 설명과 충돌하면 이 문서를 우선한다. `ANNUAL-MVP-001/002` 이름은 병합된 runtime·역사 식별자로 보존한다.

## 제품 약속

플레이어는 권나래의 일정과 역량을 준비하고, 관측 가능한 단서로 괴이 규칙을 추리한 뒤 피해자를 구출하고 괴이를 안정화·회수한다. 성공·실패·미확정은 다음 판단에 쓰이는 기록과 매뉴얼로 남는다.

```text
주간 일정·육성
→ 월간 사건 징후·출동
→ 조사
→ 추리·괴이 매뉴얼
→ 피해자 구출
→ 전조 기반 회수
→ 복합 결과
→ 후일담·연구·관계
→ 다음 달 사건
```

## 월간 cadence와 콘텐츠 예산

- 1개월에 메인 사건 1개만 연다.
- 월은 `1주 준비 → 2주 조기 출동(+0) → 3주 지연(+15) → 4주 강제(+30)` 구조를 사용한다. 수치는 Human QA 전 provisional이다.
- 조기 해결 뒤 같은 달 두 번째 메인 사건을 생성하지 않는다. 남은 주는 후일담·치료·연구·관계·다음 달 준비로 환류한다.
- 초기 제작 Slate는 M01~M12이며 `1년차` 완료 Gate로 쓰지 않는다. M13+도 같은 cadence로 이어진다.
- Signature 4개는 M01 저승역, M04 빨간 우산, M07 폐주파수 방송국, M10 기록되지 않은 병동이다.
- Standard 8개도 조사·추리·구출·회수 중 한 단계를 생략하지 않는다.

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

## M01과 M04의 다른 역할

- `M01 저승역`은 첫 세션·온보딩·회귀 사건이다. 기록 조각 → 기록국 첫 업무 → 제한된 주간 일정 → 저승역 → 첫 완전한 인과 체험을 가르친다.
- M01 첫 추리는 4개 후보를 사용한다. 공식 원본 목적지설과 동일 가짜 목적지설을 1차 배제하고, 개인 기억 투영설과 검은 승차권 원인설을 경쟁시킨 뒤 독립 기록으로 후자를 약화한다.
- 저승역 상세 규칙은 `docs/CURRENT_AFTERLIFE_STATION_CANON.md`가 소유한다. 검은 승차권 접촉·파괴를 정답으로 되살리지 않는다.
- M01 회수는 `docs/M01_RECOVERY_SCENE_PACKET.md`의 `목적지 합창 / 회귀 승강장 / 무정차 환송`을 재사용한다.
- M01 runtime은 10단계 First Session orchestrator와 additive `monthly_state`를 사용하며 별도 hidden truth owner를 만들지 않는다.
- `M04 빨간 우산`은 약 30~45분 release-near player-experience Vertical Slice다.
- M04 shared-system validation baseline은 구현됐지만 최종 제품 시각·Audio/VFX·Human QA는 아직 Gate 밖이다.

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
- Legacy grade/S-rank는 history/mastery compatibility만 허용한다.
- `monthly_state`는 top-level additive optional orchestration block으로 구현됐다.
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
→ Notion 프로젝트 홈·현재 하위 기획
→ docs/current-planning-canon.json
→ 이 문서
→ CURRENT_DECISION_OVERLAY
→ 실제 code/data/Scene/test
→ 자동·Human 증거
→ 구현 provenance·역사 문서·과거 PR·legacy Sheet
```

Notion은 사람이 보는 전체 그림·Flow·비교표의 권위이고, Repository는 구조화된 계약·구현·테스트·runtime evidence의 권위다. Google Sheet는 migration-only 역사 자료다.
