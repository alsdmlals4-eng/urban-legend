# 괴이기록국 Visual/UI Planning Closure

Status: `VISUAL_PLANNING_CLOSURE_READY / USER_FINAL_PLANNING_DECLARATION_PENDING / PLAN_LOCK`
Product reference asset: `PRODUCT_REFERENCE_ASSET_PENDING`
Runtime: `RUNTIME_IMPLEMENTATION_NOT_AUTHORIZED`
Human evidence: `HUMAN_QA_NOT_RUN`

## 목적

M01 First Session과 M04 release-near Vertical Slice의 Visual/UI/Flow 기획을 구현자가 추가 제품 방향 결정을 하지 않아도 되는 수준으로 닫되, 실제 이미지·제품 자산·runtime·Human QA를 완료로 과장하지 않는다.

이 문서는 `M01_FIRST_SESSION`과 `M04_RELEASE_NEAR_VERTICAL_SLICE`의 공통 화면 문법, 시각 매체 방향, 정보 위계, pacing guard, 제품-reference asset Gate를 정리한다.

## 비교한 3개 실질 대안

### A. 이미지 승인까지 전체 기획을 OPEN으로 유지

- 장점: 실제 시각 결과를 보고 최종 판단 가능.
- 단점: 이미 잠긴 화면 구조·정보 위계·아트 방향까지 implementation handoff가 무기한 막힌다.
- 판정: `REJECT`.

### B. 현재 Visual 문서만으로 이미지/제품 자산까지 승인

- 장점: 바로 구현 가능.
- 단점: 생성/선택되지 않은 이미지와 권리·가독성·레이어 재사용성을 검증하지 않고 승인하게 된다.
- 판정: `REJECT`.

### C. Visual planning closure와 product reference asset approval 분리

- 화면 구조·정보 위계·아트 treatment·캐릭터 노출·pixel 관측 언어는 기획 Gate에서 닫는다.
- 실제 이미지/레이어/권리/production reference 승격은 `PRODUCT_REFERENCE_ASSET_PENDING`으로 별도 유지한다.
- runtime과 Human QA도 별도 evidence Gate로 유지한다.
- 판정: `ADOPT`.

## 확정 Visual 언어

- `SOFT_ANIME_NOIR_LOCKED`: 메인 캐릭터/주요 서사 일러스트의 treatment는 기존 승인된 소프트 애니 누아르를 따른다.
- `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`: Korean Urban Occult Dossier Hybrid는 화면 구성·UI 은유·정보 위계를 설명하는 presentation language이며, 메인 아트 매체를 다시 여는 경쟁안이 아니다.
- 환경은 현대 한국 생활공간의 기능적 구조·재질을 우선한다.
- 픽셀/도트는 CCTV·센서·로그·지도·괴이 간섭 같은 보조 관측 언어로 제한한다.
- 환경·이상·증거가 일반 조사 화면의 주체이며 캐릭터 대형 일러스트는 상시 점유하지 않는다.

## 공통 화면 문법

1. Investigation: 장면/환경 → 현재 질문 → 2~4 선택 → 관측/기록 획득.
2. Deduction/Manual: provenance → 경쟁 가설 → 지지/반박/미해결 → 규칙 작성.
3. Rescue: 추리에서 만든 규칙을 피해자 분리 행동으로 적용.
4. Recovery: 괴이/보호 대상/다음 전조 → 예상 영향 → 행동 선택.
5. Composite Result: 피해자 / 확인 규칙 / 위험 사례 / 잔향·안정화 / 미해결을 독립 축으로 기록.

색상만으로 의미를 전달하지 않고 아이콘·문구·위치를 중복 사용한다. 현재 질문과 핵심 선택은 긴 로그의 스크롤 아래에 숨기지 않는다.

## M01 First Session

M01은 `M01_FIRST_SESSION`이며 온보딩·회귀 책임을 소유한다.

- Opening Record → 기록국 첫 업무 → 제한 일정 → 저승역 조사 → 첫 추리 → 구출 → 회수 → Composite Result.
- Manual은 5슬롯을 한꺼번에 열지 않고 발생 조건/피해자 연결부터 점진적으로 연다.
- 첫 회수 패턴은 telegraph→response를 안내하고 이후 패턴에서 같은 문법을 스스로 적용하게 한다.
- 기존 `목적지 합창 / 회귀 승강장 / 무정차 환송` 패턴은 서로 다른 정보 처리 능력을 요구한다.

### `SERIAL_EXAM_FATIGUE_GUARD`

조사→추리→구출→회수가 연속 시험처럼 느껴지지 않도록 다음을 지킨다.

- 새 Phase마다 새 정답 규칙을 추가하지 않고 방금 얻은 같은 규칙을 다른 행동 형태로 재사용한다.
- 추리는 틀리면 처음부터 리셋되는 시험이 아니라 현장으로 복귀 가능한 작업면이다.
- 구출은 별도 두뇌 퍼즐을 추가하기보다 추리 결과를 조작으로 적용한다.
- 회수는 첫 패턴 학습 후 전조를 읽는 실행 긴장으로 전환한다.
- 실패 메시지는 `추론 부족 / 규칙 적용 오류 / 입력 지연`을 구분한다.

## M04 release-near Vertical Slice

M04는 `M04_RELEASE_NEAR_VERTICAL_SLICE`이며 약 30~45분 player-experience 검증 책임을 소유한다.

- Schedule → Investigation → Manual Compare → Victim Rescue → Recovery → Composite Result → 남은 주.
- Investigation은 한국 골목·마른 빨간 우산·반사/젖음 불일치가 UI 장식보다 먼저 읽혀야 한다.
- Deduction은 관측 사실과 가설이 구조적으로 구분되어야 한다.
- Rescue는 피해자 호위/반사 차단/우산 격리의 역할 근거를 화면에서 재확인할 수 있어야 한다.
- Recovery는 다음 전조와 보호 대상이 공격 수치보다 먼저 읽혀야 한다.
- Result는 단일 S/A/B 등급 대신 복합 결과를 사용한다.

## 벤치마크 판정

- PARANORMASIGHT: 장소·분위기·현장 조사 원리를 `ADAPT`; 캐릭터 상시 전면 VN 구성은 그대로 복제하지 않는다.
- The Case of the Golden Idol: 관찰과 사고/추리 모드 분리, 자유로운 근거 조립을 `ADAPT`; 단어 채우기 외형은 복제하지 않는다.
- Return of the Obra Dinn: 세계관 내부 기록과 논리 추론을 `ADAPT`; 단색/1bit 미학은 채택하지 않는다.
- Into the Breach: 행동 전 enemy/anomaly telegraph와 예상 결과 판독을 `ADAPT`; grid combat 자체는 복제하지 않는다.

## 제품-reference asset Gate

`PRODUCT_REFERENCE_ASSET_PENDING`은 다음을 뜻한다.

- 실제 M01/M04 이미지 또는 사용자 보유 시안 자체는 아직 product reference로 승인되지 않았다.
- 이미지가 없어도 화면 구조와 시각 규칙의 기획은 닫을 수 있다.
- 이미지 생성/선정 후에는 `Investigation / Deduction / Recovery` P0 승인 조건, 1280×720·1920×1080 가독성, layer/reuse 구조, 권리/출처를 별도 검증한다.
- asset 승인은 runtime 구현 완료나 Human QA PASS를 의미하지 않는다.

## Planning closure Gate

```yaml
non_visual_planning: CLOSURE_READY
visual_planning: CLOSURE_READY
product_reference_asset: PENDING
overall_plan: CLOSURE_READY
user_final_planning_declaration: PENDING
plan_lock: ACTIVE
runtime_implementation: NOT_AUTHORIZED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

따라서 남은 P1 blocker는 **사용자의 최종 `기획 완료` 선언**뿐이다. 선언 뒤에도 바로 runtime을 변경하지 않고 fresh-main Reality Gate → migration/save 계약 → 단일 Codex 구현 계약 순서를 따른다.
