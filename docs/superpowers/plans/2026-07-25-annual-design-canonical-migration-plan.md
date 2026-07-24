# 연도제 육성 설계 정본 전환 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 승인된 연도제 육성·텍스트 노벨 통합 설계를 프로젝트 코어, 상세 GDD, 현재 상태, 로드맵, 인수인계, 테스트 계약의 단일 정본으로 전환한다.

**Architecture:** 이 작업은 게임 런타임을 변경하지 않는 문서·거버넌스 마이그레이션이다. `PROJECT_CORE → GAME_DESIGN_DOCUMENT → CURRENT_STATUS/CURRENT_HANDOFF → MVP_ROADMAP → TEST_CHECKLIST/DOCUMENTATION_MAP → 자동 문서 계약` 순으로 갱신해 하위 문서가 상위 권한을 먼저 참조하도록 한다. 기존 CORE-MVP-001 PoC는 폐기하지 않고 승인된 연도제 상위 루프의 사건 코어 검증 자산으로 재분류한다.

**Tech Stack:** Markdown, Python 3.12 `unittest`, Git/GitHub Actions, Godot 4.7.1 프로젝트 문서 계약

## Global Constraints

- 공식 프로젝트명은 `도시괴담`, 공식 기관명은 `괴이 기록국`으로 기록한다.
- 승인 기준 설계는 `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`다.
- 승인 증거는 `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design-approval.md`다.
- 통합 설계 PR #58의 squash merge는 `62e4acd87f4f3b043c978710147ddb332fd626e5`다.
- 승인 기록 PR #59의 squash merge는 `4798c2ab88aa2937d15437268f5c328d4ca1199c`다.
- CORE-MVP-001 구현은 PR #57이 PR #55의 head 브랜치에 병합된 뒤 PR #55로 `main`에 통합됐다.
- 현재 구현 기준은 `MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039`다.
- CORE-MVP-001 상태는 `POC_BUILD_READY`이며, 플레이 증거가 없으므로 `POC_PASSED`를 선언하지 않는다.
- 새 설계 상태는 `APPROVED_DESIGN_BASELINE / NOT_IMPLEMENTED`다.
- 코드, 데이터, Scene, `project.godot`, 저장 Schema를 변경하지 않는다.
- 기존 `scripts/core/game_state.gd`, `data/episodes/**`, `knowledge/base-pack/**`를 변경하지 않는다.
- 기존 PoC의 자동 검증 통과 사실과 신규 연도제 설계의 미구현 상태를 혼합하지 않는다.
- 연말 결과는 최종 엔딩이 아니라 다음 연도로 이어지는 `연도 결산`이다.
- 텍스트 노벨 표현 문법, 조작형 규칙 검증 미니게임, 턴제 회수 전투를 동시에 보존한다.

---

## 1. 문서 권한 전환 표

| 문서 | 전환 뒤 책임 | 변경 성격 |
|---|---|---|
| `docs/PROJECT_CORE.md` | 바뀌면 다른 게임이 되는 최소 제품 정체성 | 기존 사건 코어를 연도제 이중 코어의 하위 계약으로 재배치 |
| `docs/GAME_DESIGN_DOCUMENT.md` | 승인된 전체 시스템 상세 설계 | v3.0으로 재구성 |
| `docs/CURRENT_STATUS.md` | `main`의 구현·검증·미구현 사실 | 오래된 PR 대기 상태 제거 |
| `docs/CURRENT_HANDOFF.md` | 다음 작업자가 읽는 짧은 운영 상태 | 승인 설계와 다음 게이트 반영 |
| `MVP_ROADMAP.md` | 구현 순서와 진입 게이트 | CORE-MVP-002~004를 연도제 트랙으로 재매핑 |
| `TEST_CHECKLIST.md` | 자동·수동·플레이 검증 분리 | 기존 PoC 보존 + ANNUAL-MVP-001 신규 섹션 |
| `docs/DOCUMENTATION_MAP.md` | 책임 원본과 읽기 순서 | 승인 설계·승인 기록·신규 계획 등록 |
| `README.md` | 외부 프로젝트 소개 | 장르 한 문장만 정렬, 구현 완료로 오인할 표현 금지 |
| `docs/PROJECT_CONTEXT.md` | 프로젝트 개요와 기술 기준 | 새 장르·상태·현재 우선 작업 반영 |
| `docs/planning/PROJECT_DIRECTION.md` | 장기 방향 | 연도 확장과 이중 코어 방향 반영 |
| `docs/planning/ROADMAP_AND_HANDOFF.md` | 계획 인덱스 | 새 로드맵과 계획 링크 정렬 |
| `tests/test_active_document_references.py` | 활성 문서 경로·상태·권한 계약 | 새 기준 문서와 금지된 오래된 상태 검사 |

## 2. 상태 어휘

문서 전체에서 다음 상태를 구분한다.

```text
CORE-MVP-001
- implementation: POC_BUILD_READY
- automated_verification: PASSED
- player_validation: NOT_RUN
- poc_passed: NOT_DECLARED

연도제 통합 설계
- design: APPROVED_DESIGN_BASELINE
- canonical_migration: PLANNED 또는 IN_PROGRESS
- annual_vertical_slice: NOT_IMPLEMENTED
- production_expansion: NOT_APPROVED
```

금지되는 축약은 다음과 같다.

- `POC_BUILD_READY`를 연도제 육성 시스템 구현 완료로 표현
- 설계 승인만으로 `CORE_RECORDED` 전체가 자동 교체됐다고 표현
- 문서 병합만으로 `ANNUAL-MVP-001` 구현을 시작했다고 표현
- 플레이 증거 없이 `POC_PASSED` 또는 제작 확대 승인 표현

---

### Task 1: 문서 계약 Red 테스트 작성

**Files:**
- Modify: `tests/test_active_document_references.py`
- Test: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: 현재 `ACTIVE_DOCS`, `OPERATING_DOCS`, CORE-MVP-001 경로 상수
- Produces: 연도제 승인 설계와 정본 상태를 검사하는 문서 계약

- [ ] **Step 1: 승인 설계 경로 상수를 추가한다**

```python
ANNUAL_DESIGN_SPEC = ROOT / "docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md"
ANNUAL_DESIGN_APPROVAL = ROOT / "docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design-approval.md"
ANNUAL_CANONICAL_PLAN = ROOT / "docs/superpowers/plans/2026-07-25-annual-design-canonical-migration-plan.md"
ANNUAL_VERTICAL_SLICE_PLAN = ROOT / "docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md"
```

- [ ] **Step 2: 새 경로가 존재해야 하는 실패 테스트를 작성한다**

```python
def test_annual_design_authority_documents_exist(self) -> None:
    for path in (
        ANNUAL_DESIGN_SPEC,
        ANNUAL_DESIGN_APPROVAL,
        ANNUAL_CANONICAL_PLAN,
        ANNUAL_VERTICAL_SLICE_PLAN,
    ):
        self.assertTrue(path.is_file(), path.relative_to(ROOT))
```

- [ ] **Step 3: 활성 정본이 새 상태를 소유해야 하는 실패 테스트를 작성한다**

```python
def test_annual_design_baseline_is_canonicalized(self) -> None:
    core = (ROOT / "docs/PROJECT_CORE.md").read_text(encoding="utf-8")
    gdd = (ROOT / "docs/GAME_DESIGN_DOCUMENT.md").read_text(encoding="utf-8")
    status = (ROOT / "docs/CURRENT_STATUS.md").read_text(encoding="utf-8")
    handoff = (ROOT / "docs/CURRENT_HANDOFF.md").read_text(encoding="utf-8")
    roadmap = (ROOT / "MVP_ROADMAP.md").read_text(encoding="utf-8")

    for text in (core, gdd, status, handoff, roadmap):
        self.assertIn("APPROVED_DESIGN_BASELINE", text)
        self.assertIn("ANNUAL-MVP-001", text)

    self.assertIn("주인공 육성 시뮬레이션 + 텍스트 노벨", core)
    self.assertIn("연도 결산", gdd)
    self.assertIn("POC_BUILD_READY", status)
    self.assertIn("POC_PASSED: NOT_DECLARED", handoff)
```

- [ ] **Step 4: 오래된 상태를 금지하는 실패 테스트를 작성한다**

```python
def test_active_status_docs_do_not_claim_old_merge_wait(self) -> None:
    current_docs = (
        ROOT / "docs/CURRENT_STATUS.md",
        ROOT / "docs/CURRENT_HANDOFF.md",
        ROOT / "MVP_ROADMAP.md",
        ROOT / "TEST_CHECKLIST.md",
    )
    forbidden = (
        "PR #57 리뷰·병합 결정 대기",
        "병합 상태 | 리뷰·병합 결정 대기",
        "implementation_pr:\n  number: 57\n  state: review_ready",
        "CORE-MVP-002는 PR #57 병합과 별도 사용자 승인 전 시작하지 않는다.",
    )
    failures: list[str] = []
    for path in current_docs:
        text = path.read_text(encoding="utf-8")
        for value in forbidden:
            if value in text:
                failures.append(f"{path.relative_to(ROOT)} -> {value}")
    self.assertEqual([], failures)
```

- [ ] **Step 5: 테스트가 현재 문서에서 실패하는지 확인한다**

Run:

```bash
python -m unittest tests/test_active_document_references.py -v
```

Expected: `test_annual_design_baseline_is_canonicalized`와 `test_active_status_docs_do_not_claim_old_merge_wait` 실패.

- [ ] **Step 6: Red 테스트만 커밋한다**

```bash
git add tests/test_active_document_references.py
git commit -m "test: define annual design canonical contract"
```

---

### Task 2: `PROJECT_CORE`를 연도제 이중 코어로 전환

**Files:**
- Modify: `docs/PROJECT_CORE.md`
- Test: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: 승인 설계와 기존 조사·회수 최소 코어
- Produces: 모든 하위 설계가 참조할 최소 제품 정체성

- [ ] **Step 1: 문서 머리말을 다음 상태로 교체한다**

```markdown
> 상태: `CORE_RECORDED / ANNUAL_DESIGN_BASELINE_APPROVED`  
> 설계 승인: 2026-07-25 - 연도제 육성·텍스트 노벨 통합 설계 승인  
> 기존 사건 코어 구현: CORE-MVP-001 `POC_BUILD_READY`  
> 연도제 상위 루프 구현: `NOT_IMPLEMENTED`  
> 플레이 검증: `NOT_RUN / POC_PASSED_NOT_DECLARED`  
> Production gate: `HOLD_UNTIL_ANNUAL_VERTICAL_SLICE_EVIDENCE`
```

- [ ] **Step 2: 프로젝트 정체성 한 문장을 교체한다**

```markdown
플레이어는 고정 주인공 **권나래**의 1년 일정·역량·신념·관계를 육성하고, 텍스트 노벨형 조사에서 관측 가능한 단서로 괴이 규칙 가설을 만든 뒤, 조작형 검증과 턴제 회수 전투에서 그 이해를 증명하고, 성공과 실패를 연구·장비·동료 협업·다음 연도의 **괴이 매뉴얼**로 축적한다.
```

- [ ] **Step 3: 최소 정체성 계약을 11개 항목으로 정리한다**

정확히 다음 항목을 포함한다.

```text
1. 권나래 고정 기반 성장형 주인공
2. 1년 4분기와 주간 계획 + 중요 반일 선택
3. 육성·준비와 사건·회수의 이중 코어 순환
4. 관측 가능한 페어플레이 정보
5. 플레이어 작성형 규칙 가설
6. 합리적 확신 뒤 조작형 위험 검증
7. 조사 지식의 전투 정보 우위 변환
8. 패턴 대응형 회수와 잔향 회수
9. 성공·실패의 영구 기록과 실패 전진
10. 연구·기본 장비·모듈·동료 자동 지원
11. 최종 엔딩이 아닌 연도 결산과 다음 연도 계승
```

- [ ] **Step 4: 기존 코어 보존 규칙을 명시한다**

```markdown
- 기존 `관측 → 가설 → 위험 검증 → 전조 → 대응 → 포획 → 매뉴얼` 인과는 사건 코어의 최소 계약으로 유지한다.
- 텍스트 노벨은 표현 문법이며 조작형 미니게임과 턴제 회수 전투를 제거하지 않는다.
- 육성 수치는 핵심 정답을 공개하거나 오답을 정답으로 바꾸지 않는다.
- 동료는 권나래의 선택을 보강하지만 정답·필수 단서·최적 행동을 대신 선택하지 않는다.
```

- [ ] **Step 5: 기존 CORE_SUPPORT를 승인 설계에 맞게 재분류한다**

`기간제 챕터`, `부상`, `포획 연구`, `가치관 엔딩`을 다음으로 교체한다.

```text
- 연도제 캠페인과 분기 핵심 사건
- 피로 1개 + 상태 태그
- 기본 장비 + 연구 모듈
- 동료 고유 스킬 + 기관·연구 공용 보조 스킬
- 관계의 업무 신뢰 + 개인적 유대 + 선택적 로맨스
- 연도 결산의 현재 진로·신념·관계·세계 상태
```

- [ ] **Step 6: 기존 MVP 재기준화 절을 제거하고 새 로드맵 책임만 남긴다**

```markdown
## 구현 트랙

- 완료 자산: CORE-MVP-001 사건 코어 독립 PoC `POC_BUILD_READY`
- 현재 계획: ANNUAL-MVP-001 육성→준비→기존 사건→연구→분기 결산 수직절편
- 후속 계획은 `MVP_ROADMAP.md`가 소유한다.
```

- [ ] **Step 7: 책임 원본에 승인 설계와 두 계획을 추가한다**

```markdown
- 승인된 연도제 통합 설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`
- 설계 승인 기록: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design-approval.md`
- 정본 전환 계획: `docs/superpowers/plans/2026-07-25-annual-design-canonical-migration-plan.md`
- ANNUAL-MVP-001 구현 계획: `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`
```

- [ ] **Step 8: 문서 계약을 실행한다**

Run:

```bash
python -m unittest tests/test_active_document_references.py -v
```

Expected: `PROJECT_CORE` 관련 assertion 통과, 나머지 정본 문서 관련 assertion은 계속 실패.

- [ ] **Step 9: 커밋한다**

```bash
git add docs/PROJECT_CORE.md tests/test_active_document_references.py
git commit -m "docs: adopt annual dual-core project identity"
```

---

### Task 3: GDD v3.0 재구성

**Files:**
- Modify: `docs/GAME_DESIGN_DOCUMENT.md`
- Test: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: `docs/PROJECT_CORE.md`의 11개 최소 계약
- Produces: 구현 계획이 참조할 상세 시스템 책임 원본

- [ ] **Step 1: 문서 버전과 상태 표를 갱신한다**

```markdown
| 항목 | 현재 값 |
|---|---|
| 문서 버전 | v3.0 |
| 문서 역할 | 연도제 육성·텍스트 노벨·사건 코어 상세 시스템 설계 |
| 설계 상태 | `APPROVED_DESIGN_BASELINE` |
| 기존 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 연도제 구현 | `NOT_IMPLEMENTED` |
| POC_PASSED | `NOT_DECLARED` |
| 엔진 | Godot 4.7.1 / GDScript |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
```

- [ ] **Step 2: 문서 상위 목차를 다음 순서로 재구성한다**

```text
1. 제품 약속과 대상 플레이어
2. 장르와 이중 코어
3. 권나래 성장 모델
4. 1년 4분기 캠페인
5. 주간 일정과 중요 반일 선택
6. 피로·상태·기관 지원·잔향 자료
7. 사건 등급과 핵심 사건 흐름
8. 텍스트 노벨형 조사
9. 조작형 규칙 검증 미니게임
10. 턴제 회수 전투
11. 동료·고유 스킬·공용 보조 스킬
12. 괴이 연구와 기본 장비·모듈
13. 기관·관계·선택적 로맨스
14. 실패 전진
15. 분기 정산과 연도 결산
16. 다음 연도 계승과 성장 인플레이션 방지
17. UI·접근성
18. 저장·호환·난수 재현성
19. 콘텐츠 제작 등급
20. 검증 게이트와 구현 트랙
```

- [ ] **Step 3: 기존 조사·회수 절은 내용 손실 없이 7~10절로 이동한다**

다음 계약은 문장 의미를 유지한다.

```text
- 4개 선택지 중 관측 가능한 근거로 2개 배제
- 지지·반박·미해결 근거를 가진 가설 카드
- 현장 이해도 unknown → clue → likely → understood
- 거짓 전조 금지
- 미관측 패턴 첫 발동의 범용 대응과 비가역 손실 금지
- HP 0이 아닌 포획 창 개방
- 성공·실패의 매뉴얼 기록
```

- [ ] **Step 4: 육성 수치의 영향 경계를 표로 고정한다**

```markdown
| 성장 요소 | 허용 영향 | 금지 영향 |
|---|---|---|
| 관찰 | 추가 조사 지점·전조 정보·미니게임 보조 | 정답 표시 |
| 분석 | 근거 비교·가설 폭·연구 효율 | 자동 가설 확정 |
| 현장 대응 | 허용 오차·피해 완화·재시도 안전성 | 오답 성공 처리 |
| 대인 대응 | 증언·협력·기관 선택지 | 필수 단서 독점 |
| 가치 성향 | 대사·해결 방식·결산 | 선악 점수 단일화 |
| 전문성 | 질문·행동·모듈·스킬 해금 | 신규 괴이 자동 분류 |
```

- [ ] **Step 5: 동료 자동 지원 계약을 상세히 기록한다**

정확히 다음을 포함한다.

```text
- 출동은 권나래 + 동료 최대 2명
- 플레이어는 권나래만 직접 명령
- 동료별 고유 스킬 1개
- 기본 공용 슬롯 1개, 협업 성장 뒤 공용 슬롯 1개 추가
- 기관 교육과 괴이 연구로 공용 스킬 획득
- 조건 충족 시 확률 판정
- 연속 불발 시 지원 준비도 누적
- 최대 준비도에서 다음 적합 조건 확정 발동
- 조건·현재 확률·준비도를 UI에 공개
- 같은 저장 상태의 재불러오기로 재추첨 금지
```

- [ ] **Step 6: 엔딩 절을 연도 결산으로 교체한다**

```markdown
한 해의 종료는 최종 엔딩이 아니라 해당 연도의 주요 갈등, 현재 진로 방향, 현재 신념, 관계·기관·괴이 상태를 짧게 정리하는 **연도 결산**이다. 후속 연도가 추가되면 계승 데이터로 다음 해 도입부와 사건 조건을 변경한다.
```

- [ ] **Step 7: 첫 출시 범위와 후속 연도 확장 경계를 기록한다**

```text
첫 완성 캠페인
- 4분기
- 분기별 핵심 사건 1개
- 핵심 사건별 대표 미니게임과 회수 전투
- 제한된 중형·소형 사건
- 육성·연구·장비·동료·관계·연도 결산

후속 연도
- 신규 연도 메인 서사
- 기존 결산 데이터 계승
- 새 현상·괴이·동료 관계 단계
- 숫자 상한보다 전문화·책임·복합 조건 확장
```

- [ ] **Step 8: 문서 계약을 실행한다**

Run:

```bash
python -m unittest tests/test_active_document_references.py -v
```

Expected: GDD 관련 assertion 통과.

- [ ] **Step 9: 커밋한다**

```bash
git add docs/GAME_DESIGN_DOCUMENT.md tests/test_active_document_references.py
git commit -m "docs: rewrite gdd for annual raising campaign"
```

---

### Task 4: 현재 상태와 인수인계 교정

**Files:**
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Test: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: 실제 `main` 병합 이력과 승인 설계 상태
- Produces: 구현 사실과 다음 작업의 단일 운영 상태

- [ ] **Step 1: `CURRENT_STATUS`의 현재 기준 표를 교체한다**

```markdown
| 항목 | 현재 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 사건 코어 main 통합 | PR #55 / commit `8d0bf91a2e31538d3c0f142c800a84e8e3693889` |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| 설계 PR | #58, #59 merged |
| 연도제 구현 | `NOT_IMPLEMENTED` |
| POC_PASSED | `NOT_DECLARED` |
| 현재 작업 | 정본 전환과 ANNUAL-MVP-001 계획 |
```

- [ ] **Step 2: 오래된 PR #57 대기 문구를 제거한다**

다음 사실로 교체한다.

```text
PR #57은 PR #55의 head에 병합됐고 PR #55가 main에 squash merge됐다.
Issue #56은 완료 상태다.
CORE-MVP-001은 main에서 실행 가능하지만 플레이 증거가 없어 POC_PASSED가 아니다.
```

- [ ] **Step 3: 다음 우선순위를 재작성한다**

```text
1. 연도제 정본 전환
2. ANNUAL-MVP-001 계획 승인
3. 격리 수직절편 구현
4. 자동·사람 눈 QA
5. 육성→사건→연구 인과 플레이 검증
6. 결과에 따라 KEEP / CHANGE / RETEST / HOLD
```

- [ ] **Step 4: `CURRENT_HANDOFF` YAML을 교체한다**

```yaml
status: ANNUAL_DESIGN_BASELINE_APPROVED
implemented_baseline: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save mvp-039
core_mvp_001:
  implementation: POC_BUILD_READY
  automated_verification: PASSED
  poc_passed: NOT_DECLARED
annual_design:
  status: APPROVED_DESIGN_BASELINE
  implementation: NOT_IMPLEMENTED
  design_pr: 58
  approval_pr: 59
active_track:
  - canonical document migration
  - ANNUAL-MVP-001 plan review
next_gate:
  - approve canonical migration diff
  - approve isolated vertical slice implementation plan
production_expansion: NOT_APPROVED
```

- [ ] **Step 5: 필수 읽기 순서를 교체한다**

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/GAME_DESIGN_DOCUMENT.md
→ 승인된 연도제 통합 설계
→ 연도제 설계 승인 기록
→ 정본 전환 계획
→ ANNUAL-MVP-001 구현 계획
→ 기존 CORE-MVP-001 코드·데이터·테스트
```

- [ ] **Step 6: 테스트를 실행한다**

Run:

```bash
python -m unittest tests/test_active_document_references.py -v
```

Expected: 오래된 병합 대기 문구 검사 통과.

- [ ] **Step 7: 커밋한다**

```bash
git add docs/CURRENT_STATUS.md docs/CURRENT_HANDOFF.md tests/test_active_document_references.py
git commit -m "docs: align current status with merged annual design"
```

---

### Task 5: 로드맵을 ANNUAL-MVP 트랙으로 재기준화

**Files:**
- Modify: `MVP_ROADMAP.md`
- Test: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: 기존 CORE-MVP-001 완료 자산과 승인된 전체 설계
- Produces: 독립적으로 검증 가능한 연도제 구현 순서

- [ ] **Step 1: 기존 목표 트랙을 교체한다**

```text
완료·보존
- CORE-MVP-001: 사건 조사→회수 인과 PoC / POC_BUILD_READY

신규 트랙
- ANNUAL-MVP-001: 3주 육성→출동 준비→CORE-MVP-001→연구→분기 결산
- ANNUAL-MVP-002: 동료 2명, 고유·공용 자동 지원, 장비·연구 조합 확장
- ANNUAL-MVP-003: 1분기 전체, 핵심 사건 마감, 중형·소형 사건, 실패 전진
- ANNUAL-MVP-004: 4분기 연도 캠페인, 관계·기관·연도 결산·계승
```

- [ ] **Step 2: ANNUAL-MVP-001 진입 조건을 기록한다**

```text
- 연도제 설계 APPROVED_DESIGN_BASELINE
- 정본 문서 전환 완료
- 별도 격리 경로 사용
- 기존 save mvp-039 비침범
- 기존 CORE-MVP-001 회귀 4/4와 전체 43/43 보호
```

- [ ] **Step 3: ANNUAL-MVP-001 수용 질문을 기록한다**

```text
육성·준비에서 내린 선택이 사건의 정보·위험·피해 관리에 체감 가능한 차이를 만들고, 사건 결과가 연구·스킬·분기 결산으로 되돌아오는가?
```

- [ ] **Step 4: 기존 CORE-MVP-002~004를 폐기하지 않고 매핑 이력으로 이동한다**

```markdown
## 이전 트랙 매핑

- 기존 CORE-MVP-002의 부상·포획·연구는 ANNUAL-MVP-001~002로 분산한다.
- 기존 CORE-MVP-003의 기간제 챕터·의뢰는 ANNUAL-MVP-003으로 이동한다.
- 기존 CORE-MVP-004의 가치관 결말은 ANNUAL-MVP-004의 연도 결산·계승으로 재해석한다.
- 과거 ID는 승인 이력이며 신규 구현 진입점으로 사용하지 않는다.
```

- [ ] **Step 5: 테스트를 실행한다**

Run:

```bash
python -m unittest tests/test_active_document_references.py -v
```

Expected: 로드맵 관련 assertion 통과.

- [ ] **Step 6: 커밋한다**

```bash
git add MVP_ROADMAP.md tests/test_active_document_references.py
git commit -m "docs: rebase roadmap onto annual mvp track"
```

---

### Task 6: 테스트 체크리스트와 문서 지도 정렬

**Files:**
- Modify: `TEST_CHECKLIST.md`
- Modify: `docs/DOCUMENTATION_MAP.md`
- Modify: `README.md`
- Modify: `docs/PROJECT_CONTEXT.md`
- Modify: `docs/planning/PROJECT_DIRECTION.md`
- Modify: `docs/planning/ROADMAP_AND_HANDOFF.md`
- Test: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: 새 코어·GDD·상태·로드맵
- Produces: 활성 문서 전체의 동일한 기준선과 링크

- [ ] **Step 1: `TEST_CHECKLIST` 머리말을 갱신한다**

```markdown
현행 사건 코어 CORE-MVP-001 `POC_BUILD_READY`를 회귀 기준으로 보호하면서, 승인된 연도제 설계의 정본 전환과 ANNUAL-MVP-001 격리 수직절편을 검증한다. 사건 PoC 자동 통과, 연도제 구현 완료, 플레이 통과를 혼합하지 않는다.
```

- [ ] **Step 2: 기존 완료 항목은 `CORE-MVP-001 보존 회귀` 절로 이동한다**

다음 수치를 유지한다.

```text
- 집중 CORE-MVP-001 4/4
- 전체 Godot 회귀 43/43
- 기존 저장 mvp-039 비침범
- 1280×720·1920×1080 기계적 UI 계약
- 플레이 증거 없음 / POC_PASSED 미선언
```

- [ ] **Step 3: ANNUAL-MVP-001 사전 체크리스트를 추가한다**

```text
[ ] 3주·주당 3슬롯 PoC 데이터 계약
[ ] 권나래 역량·피로·동료 신뢰의 결정론적 성장
[ ] 주차별 자율 출동·지연 위험·긴급 출동
[ ] 기본 장비 + 연구 모듈
[ ] 동료 고유 + 공용 자동 보조, 확률·준비도 공개
[ ] 저장 재불러오기 재추첨 금지
[ ] CORE-MVP-001 입력 데이터 override와 결과 반환
[ ] 사건 결과 → 잔향 자료·연구 해금
[ ] 분기 결산과 다음 사이클 플래그
[ ] 기존 save·사건·GameState 비침범
```

- [ ] **Step 4: `DOCUMENTATION_MAP`에 권한 순서를 추가한다**

```text
PROJECT_CORE
→ GAME_DESIGN_DOCUMENT
→ annual approved design spec + approval record
→ CURRENT_STATUS / CURRENT_HANDOFF
→ MVP_ROADMAP
→ annual canonical migration plan
→ annual vertical slice implementation plan
→ TEST_CHECKLIST
```

- [ ] **Step 5: 외부·계획 문서의 장르 한 문장을 정렬한다**

모든 대상 문서에 다음 의미를 사용한다.

```text
권나래 연도제 육성 시뮬레이션 + 텍스트 노벨 + 규칙 추리 + 조작형 미니게임 + 턴제 회수 전투
```

`연도제 구현 완료`, `1년차 콘텐츠 완료`처럼 구현 사실을 앞서가는 문구는 작성하지 않는다.

- [ ] **Step 6: 전체 문서 계약을 실행한다**

Run:

```bash
python -m unittest \
  tests/test_base_operating_sync.py \
  tests/test_skill_package_integrity.py \
  tests/test_active_document_references.py \
  tests/test_core_validation_contract.py -v
```

Expected: `OK`.

- [ ] **Step 7: Markdown 링크와 공백 오류를 검사한다**

Run:

```bash
git diff --check
```

Expected: 출력 없음, exit 0.

- [ ] **Step 8: 커밋한다**

```bash
git add \
  TEST_CHECKLIST.md \
  docs/DOCUMENTATION_MAP.md \
  README.md \
  docs/PROJECT_CONTEXT.md \
  docs/planning/PROJECT_DIRECTION.md \
  docs/planning/ROADMAP_AND_HANDOFF.md \
  tests/test_active_document_references.py
git commit -m "docs: align active documentation with annual baseline"
```

---

### Task 7: 정본 전환 최종 검증과 상태 판정

**Files:**
- Modify: `docs/CURRENT_STATUS.md`
- Modify: `docs/CURRENT_HANDOFF.md`
- Modify: `TEST_CHECKLIST.md`

**Interfaces:**
- Consumes: Task 1~6의 모든 문서 변경
- Produces: `CANONICAL_MIGRATION_COMPLETE / ANNUAL_MVP_001_PLAN_PENDING` 상태

- [ ] **Step 1: 오래된 표현을 검색한다**

Run:

```bash
rg -n \
  "PR #57 리뷰·병합|병합 결정 대기|CORE-MVP-002는 PR #57|WRITTEN_SPEC_REVIEW_PENDING|캠페인 결말 2종" \
  README.md MVP_ROADMAP.md TEST_CHECKLIST.md docs \
  --glob '!docs/archive/**'
```

Expected: 승인 이력을 설명하는 인용을 제외하고 활성 상태 문서에서 결과 없음.

- [ ] **Step 2: 새 권한 어휘를 검색한다**

Run:

```bash
rg -n \
  "APPROVED_DESIGN_BASELINE|ANNUAL-MVP-001|연도 결산|POC_PASSED.*NOT_DECLARED" \
  README.md MVP_ROADMAP.md TEST_CHECKLIST.md docs/PROJECT_CORE.md docs/GAME_DESIGN_DOCUMENT.md docs/CURRENT_STATUS.md docs/CURRENT_HANDOFF.md
```

Expected: 모든 책임 문서에서 최소 1회 확인.

- [ ] **Step 3: 전체 문서 테스트를 다시 실행한다**

Run:

```bash
python -m unittest \
  tests/test_base_operating_sync.py \
  tests/test_skill_package_integrity.py \
  tests/test_active_document_references.py \
  tests/test_core_validation_contract.py -v
```

Expected: `OK`, failures 0, errors 0.

- [ ] **Step 4: 변경 범위를 확인한다**

Run:

```bash
git diff --name-only origin/main...HEAD
```

Expected: 이 계획에 명시된 Markdown 파일과 `tests/test_active_document_references.py`만 표시. GDScript, JSON, Scene, `project.godot` 없음.

- [ ] **Step 5: 최종 상태를 기록한다**

`CURRENT_STATUS`, `CURRENT_HANDOFF`, `TEST_CHECKLIST`에 다음 상태를 동일하게 기록한다.

```text
canonical_migration: COMPLETE
automated_document_validation: PASSED
annual_mvp_001: PLAN_PENDING_APPROVAL
runtime_changes: NONE
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
```

- [ ] **Step 6: 최종 문서 커밋을 작성한다**

```bash
git add docs/CURRENT_STATUS.md docs/CURRENT_HANDOFF.md TEST_CHECKLIST.md
git commit -m "docs: complete annual design canonical migration"
```

- [ ] **Step 7: Draft PR을 연다**

PR 제목:

```text
docs: canonicalize annual raising design
```

PR 본문 필수 항목:

```text
- 승인된 연도제 설계를 PROJECT_CORE·GDD·상태·로드맵 정본으로 전환
- CORE-MVP-001 POC_BUILD_READY와 POC_PASSED 미선언을 분리
- 기존 코드·저장·Scene 변경 없음
- 문서 계약 실행 결과
- 다음 게이트: ANNUAL-MVP-001 구현 계획 승인
```

## Self-Review Checklist

- [ ] 승인 설계의 1년 4분기, 주간 계획, 텍스트 노벨, 미니게임, 회수 전투가 모두 정본에 존재한다.
- [ ] 동료 최대 2명, 권나래만 직접 명령, 고유+공용 자동 보조 스킬이 GDD에 존재한다.
- [ ] 연말이 최종 엔딩이 아니라 연도 결산으로 기록돼 있다.
- [ ] 기존 CORE-MVP-001의 관측·가설·전조·회수·매뉴얼 코어가 제거되지 않았다.
- [ ] `POC_BUILD_READY`, `POC_PASSED NOT_DECLARED`, `APPROVED_DESIGN_BASELINE`, `NOT_IMPLEMENTED`가 혼합되지 않았다.
- [ ] 기존 PR #57 대기 문구가 활성 상태 문서에서 제거됐다.
- [ ] 모든 새 경로와 Markdown 링크가 실제 파일로 해소된다.
- [ ] 코드·데이터·Scene·저장 Schema 변경이 없다.
- [ ] `TBD`, `TODO`, `implement later`, `similar to`가 없다.

## Execution Handoff

이 계획은 정본 문서 전환만 수행한다. 완료 뒤 `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`를 별도 실행한다.
