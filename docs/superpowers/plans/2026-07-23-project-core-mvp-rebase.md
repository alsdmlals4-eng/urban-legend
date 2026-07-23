# Project Core MVP Rebase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans. Steps use checkbox syntax.

**Goal:** 스트레스 테스트로 확정된 최소 코어를 단일 사건 PoC로 검증하고, 플레이 증거가 있을 때만 지원 시스템으로 확장한다.

**Architecture:** `docs/PROJECT_CORE.md`는 최소 정체성, GDD는 상세 계약, 스트레스 보고서는 검토 근거, `CURRENT_STATUS`는 구현 사실, `MVP_ROADMAP`은 게이트 순서를 소유한다. CORE-MVP-001은 기존 저장·세 사건을 직접 마이그레이션하지 않는 독립 PoC 경로로 만든다.

**Tech Stack:** Godot 4.7 stable, GDScript, Markdown, Python unittest, headless regression, 플레이테스트 관찰표.

## Global Constraints

- 권나래 고정 주인공, 단일 일정 주체
- 핵심 단서·가설·이해도 승격은 결정론적
- 확률은 중간 이해도의 전조 정보 해석에만 사용
- 거짓 예측과 저장 재추첨 금지
- 회수 승리는 포획 조건, HP 0 처치 금지
- CORE-MVP-001 전 시장·세력·연구·서사·복수 챕터 확대 금지
- 현행 `mvp-039`, 기존 ID와 보호 경로 유지

---

### Task 1: 문서·자동 계약 동기화

**Files:**
- Modify: `docs/PROJECT_CORE.md`
- Create: `docs/planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md`
- Modify: `docs/GAME_DESIGN_DOCUMENT.md`
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `docs/planning/README.md`
- Modify: `docs/planning/ROADMAP_AND_HANDOFF.md`
- Modify: `docs/planning/REFERENCE_CASES.md`
- Modify: `MVP_ROADMAP.md`
- Modify: `TEST_CHECKLIST.md`
- Modify: `tests/test_base_operating_sync.py`

- [ ] `CORE_RECORDED / CORE_STRESS_TESTED / POC_PENDING` 상태를 검증한다.
- [ ] 최소 코어와 CORE_SUPPORT를 분리한다.
- [ ] `Ver 4.2`, `CORE-VALIDATION-001`, `mvp-039` 활성 기준선을 유지한다.
- [ ] Base operating sync와 active reference tests를 실행한다.

### Task 2: CORE-MVP-001 데이터 계약

**Files:** PoC 전용 사건 데이터·Schema·계약 테스트를 현재 저장 책임 원본과 분리해 추가한다.

- [ ] 단서 6개를 지지 3·반박 2·미해결 1로 작성한다.
- [ ] 4개 선택지와 논리적 배제 관계를 작성한다.
- [ ] 가설 카드 2개의 필드를 정의한다.
- [ ] 현장 이해도 승격 조건을 결정론적으로 정의한다.
- [ ] 패턴 3개와 포획 조건을 판정 전에 고정한다.
- [ ] 실패 사례에 반응 단서와 위험 사례가 항상 존재하는 테스트를 작성한다.

### Task 3: 조사 UI 세로 슬라이스

- [ ] 현재 전조·4개 선택지·관련 매뉴얼 2~3개를 우선 표시한다.
- [ ] 기록을 선택지에 연결해 2개를 배제한다.
- [ ] 규칙 가설 카드에 지지·반박·미해결을 연결한다.
- [ ] 배제 실패에는 자원 비용을 주지 않는다.
- [ ] 오답 뒤 기존 1 + 신규 변형 1로 부분 갱신한다.
- [ ] 1280×720·1920×1080, 키보드·마우스·Esc를 검증한다.

### Task 4: 전조 해석과 턴제 회수 PoC

- [ ] 실제 패턴을 해석 판정 전에 고정한다.
- [ ] 실패는 `놈은 무언가 하려 한다.`만 표시한다.
- [ ] 성공은 행동명과 확인한 세부 정보만 표시한다.
- [ ] 이해 단계는 확정 해석한다.
- [ ] 미관측 패턴 첫 발동에 범용 방어를 보장한다.
- [ ] 포획 조건 충족으로 승리한다.
- [ ] 저장 재개 또는 PoC 재진입에서 같은 판정을 재추첨하지 않는다.

### Task 5: 결과·매뉴얼 승격

- [ ] 가설과 회수 관측을 비교한다.
- [ ] 후보·공식 규칙·위험 사례를 분리한다.
- [ ] 실패도 다음 판단에 사용할 기록을 남긴다.
- [ ] 결과 화면은 회수 품질·피해·지식 품질을 구분한다.
- [ ] 매뉴얼이 정답집이 아니라 플레이어 작성 기록으로 보이는지 수동 검증한다.

### Task 6: 플레이테스트와 Production gate

- [ ] 신규 플레이어와 기존 노출 플레이어를 구분한다.
- [ ] 18~25분 과제와 관찰 포인트를 고정한다.
- [ ] 행동·퍼널·인터뷰를 분리 기록한다.
- [ ] 사전 선언한 6개 지표를 계산한다.
- [ ] `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`를 판정한다.
- [ ] 지표 미달이면 CORE-MVP-002를 시작하지 않는다.

### Task 7: 후속 단계 재매핑

- [ ] CORE-MVP-001 통과 뒤에만 CORE-MVP-002 범위를 확정한다.
- [ ] UX-PD-001 2B·2C와 MVP-044~046을 새 코어에 맞게 재매핑한다.
- [ ] 시장·세력·연구·복수 챕터·대규모 엔딩은 별도 승인한다.
