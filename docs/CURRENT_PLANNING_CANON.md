# 괴이기록국 현재 기획 정본

> 역할: `CURRENT_PLANNING_CANON`
> 상태: `PLANNING_COMPLETE / USER_FINAL_PLANNING_DECLARATION_APPROVED / IMPLEMENTATION_HANDOFF_READY`
> 사람용 정본: Notion 프로젝트 홈과 하위 기획 페이지
> 구조화·구현 정본: 이 저장소와 `docs/current-planning-canon.json`

이 문서는 2026-08-20까지 승인된 Notion 기획, 2026-08-21 Visual/UI closure, 2026-08-22 사용자의 최종 `기획완료` 선언을 GitHub의 활성 진입점에 연결한다. 과거의 `1년 4분기`, `분기 핵심 사건 4개`, `ANNUAL-MVP-*가 다음 기획 트랙`이라는 설명과 충돌하면 이 문서를 우선한다. `ANNUAL-MVP-001/002` 이름은 이미 병합된 runtime·역사 식별자로 보존하며 삭제하거나 이름을 바꾸지 않는다.

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
6. 회수 행동은 보호·관찰·대응·공격·장비·봉쇄·후퇴이며 공격 반복만으로 승리할 수 없다.
7. 실패는 위험 사례·비용·후속 조사·재출동 조건을 남긴다.
8. 사건 결과를 단일 S/A/B 등급 하나로 압축해 위 복합 결과를 덮어쓰지 않는다.

## M01과 M04의 다른 역할

- `M01 저승역`은 첫 세션·온보딩·회귀 사건이다. 기록 조각 → 기록국 첫 업무 → 제한된 주간 일정 → 저승역 → 첫 완전한 인과 체험을 가르친다.
- M01 첫 추리는 4개 후보를 사용한다. 공식 원본 목적지설과 동일 가짜 목적지설을 1차 배제하고, 개인 기억 투영설과 검은 승차권 원인설을 경쟁시킨 뒤 독립 기록으로 후자를 약화한다.
- 저승역 상세 규칙은 `docs/CURRENT_AFTERLIFE_STATION_CANON.md`가 소유한다. 검은 승차권 접촉·파괴를 정답으로 되살리지 않는다.
- M01 회수는 `docs/M01_RECOVERY_SCENE_PACKET.md`가 `목적지 합창 / 회귀 승강장 / 무정차 환송`의 전조·대응·첫 세션 pacing을 소유한다.
- `M04 빨간 우산`은 약 30~45분 release-near player-experience Vertical Slice다. 실제 사용 후보 UI/UX·아트·연출·Audio/VFX·시스템·콘텐츠가 연결된 뒤 Human QA한다.
- M04는 M01의 온보딩 역할을 대신하지 않으며, M01은 M04의 제품 차별화·관계·시각 훅 검증 역할을 대신하지 않는다.

## 화면·재사용 계약

- 조사는 장면 이미지, 짧은 서술, 2~4개 선택지, 기록·키워드 획득을 우선한다.
- 추리는 별도 괴이 매뉴얼 화면에서 출처, 경쟁 가설, 지지·반박·미해결, 추리문을 다룬다.
- 일반 조사에서는 큰 캐릭터를 상시 노출하지 않는다. 환경·사건·증거가 주체이며 캐릭터는 작은 지원 표현과 중요한 순간의 짧은 Cut-in으로 제한한다.
- `SOFT_ANIME_NOIR_LOCKED`: 메인 캐릭터·중요 서사 일러스트 treatment는 승인된 소프트 애니 누아르를 따른다.
- `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`: Korean Urban Occult Dossier Hybrid는 UI·정보 위계·현장/기록 구성 언어이며 메인 아트 매체를 다시 여는 경쟁안이 아니다.
- 픽셀/도트는 CCTV·센서·로그·지도·괴이 간섭을 위한 보조 관측 언어다. 메인 캐릭터와 전체 조사 화면의 기본 화풍을 대체하지 않는다.
- M01~M12는 공용 화면 문법을 재사용하되 질문·반증·피해자 갈등·봉쇄 조건은 사건별로 구분한다.

## Visual planning과 product reference asset 분리

기획 완료 후에도 `PRODUCT_REFERENCE_ASSET_PENDING`은 유지된다.

- 화면 구조·정보 위계·아트 treatment·캐릭터 노출·pixel 관측 언어는 최종 기획에 포함되어 `COMPLETE`다.
- 실제 M01/M04 이미지·레이어·권리·production reference 승격은 아직 승인되지 않았다.
- 이미지 생성/선정 뒤에는 P0 Investigation/Deduction/Recovery 승인 조건, 1280×720·1920×1080 가독성, layer/reuse 구조를 별도로 검증한다.
- product reference asset 승인은 runtime 구현·Human QA·POC PASS를 의미하지 않는다.

## 성장·결과·저장 방향

- 성장의 장기 방향은 0~5 Rank + 내부 숙련 진행도다. threshold와 피로·연구 수치는 provisional이다.
- 성장은 Clarity·Access·Tolerance·Support를 바꾸며 핵심 진실이나 정답을 자동 제공하지 않는다.
- 결과는 `rescue_outcome_snapshot → recovery_handoff_state → recovery_result_packet → monthly envelope` 계보를 재사용한다.
- 새 월간 조율 상태는 top-level `monthly_state`의 additive optional block으로 구현한다. 기존 Episode ID, report, ANNUAL PoC state를 자동 rename·import·월 완료 추론하지 않는다.
- current main의 Canon v2 migration/runtime 구현은 재사용한다. 새로 재구축하지 않는다.

## 최종 기획 승인 후 Reality Gate

2026-08-22 fresh-main 검토 결과:

- `EXISTING_CANON_V2_RUNTIME_REUSE`
- `COMPOSITE_RESULT_RUNTIME_SUCCESSOR_PRESENT`
- `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED`
- `MONTHLY_STATE_NOT_IMPLEMENTED`
- #181: `CURRENT_VALID / IMPLEMENTATION_GATE`

상세 근거는 `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`가 소유한다.

## 현재 Gate

```yaml
PLANNING_COMPLETE: true
USER_FINAL_PLANNING_DECLARATION_APPROVED: true
non_visual_planning: COMPLETE
visual_planning: COMPLETE
product_reference_asset: PENDING
overall_plan: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
implementation_reality_gate: HANDOFF_READY_WITH_KNOWN_REALIGNMENT
implementation_contract: READY
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

`RELEASED_TO_IMPLEMENTATION_GATE`는 더 이상 기획 완료 선언을 기다리지 않는다는 뜻이다. **runtime_implementation: NOT_AUTHORIZED**는 이 선언만으로 제품 파일 변경을 시작하지 않는다는 별도 실행 권한 경계다.

현재 구현 handoff owner:
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

따라서 현재 상태는 **`IMPLEMENTATION_HANDOFF_READY`**다.

## 열린 PR 통합 계보

PR #211, #213, #214, #215, #216, #217, #218의 고유 문서는 PR #219에서 통합됐고 현재 main 정본에 포함되어 있다. M01 Recovery Packet은 기존 저승역 Canon v2의 세 회수 패턴을 현재 월간/First Session 계약에 연결하는 successor 문서다.

## 정본 우선순위

```text
최신 사용자 승인
→ GitHub latest main
→ Notion 프로젝트 홈·현재 하위 기획
→ docs/current-planning-canon.json
→ 이 문서
→ CURRENT_DECISION_OVERLAY
→ 현재 implementation handoff spec/plan
→ 사건별 current canon
→ 실제 code/data/Scene/test
→ 자동·Human 증거
→ 역사 문서·과거 PR·legacy Sheet
```

Notion은 사람이 보는 전체 그림·Flow·비교표의 권위이고, Repository는 구조화된 계약·구현·테스트·runtime evidence의 권위다. Google Sheet는 migration-only 역사 자료이며 새 작업면으로 사용하지 않는다.
