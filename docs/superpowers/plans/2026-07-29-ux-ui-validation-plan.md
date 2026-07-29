# Urban Legend UX/UI Validation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 현재 구현된 CORE-MVP-001 조사 흐름을 대상으로 신규 플레이어가 사실·증언·가설·모순을 구분하고 위험 검증과 회수 판단까지 완주하는지 실제 사람 증거로 판정한다.

**Architecture:** 기존 `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn`과 자동 검증을 기준선으로 고정한다. 제품 규칙을 변경하기 전에 수동 QA fixture, 화면·입력 확인, 신규 플레이어 6명 테스트를 순서대로 실행하고, 결과는 자동·렌더·사람·접근성 증거로 분리한다.

**Tech Stack:** Godot 4.7.1, GDScript, PC 16:9, 키보드·마우스, GitHub Issues/Artifacts, 기존 CORE-MVP-001 테스트.

## Global Constraints

- 사건·괴이 규칙·분기·단서·플래그·호감도·JSON을 UX 검증 중 변경하지 않는다.
- UI는 단서 획득·가설 정답·회수 결과를 재계산하거나 직접 저장하지 않는다.
- 기준 Scene은 `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn`이다.
- 기준 데이터는 `data/poc/core_mvp_001/afterlife_station_poc.json`이다.
- 자동 검증 통과를 사람 이해도 통과로 대체하지 않는다.
- 신규 플레이어와 장시간 사용성 QA가 끝나기 전 `POC_PASSED`를 선언하지 않는다.
- HTML 기획 대시보드는 범위에서 제외한다.

---

### Task 1: 실행 기준선과 테스트 빌드 고정

**Files:**
- Read: `AGENTS.md`
- Read: `docs/CURRENT_STATUS.md`
- Read: `docs/PROJECT_CORE.md`
- Read: `docs/UX_UI_SYSTEM.md`
- Read: `docs/BASE_UX_UI_ADOPTION.md`
- Read: `scenes/poc/core_mvp_001/core_mvp_001_scene.tscn`
- Read: `scripts/poc/core_mvp_001/core_mvp_001_scene.gd`

**Interfaces:**
- Consumes: 최신 main, CORE-MVP-001 구현, UX/UI 계약.
- Produces: commit·scene·해상도·입력이 고정된 테스트 빌드 기록.

- [ ] **Step 1:** 테스트 시작 시 최신 main commit SHA를 Issue에 기록한다.
- [ ] **Step 2:** Godot 4.7.1로 프로젝트 import·parse를 실행한다.
- [ ] **Step 3:** CORE-MVP-001 Scene을 1280×720과 1920×1080에서 실행한다.
- [ ] **Step 4:** 키보드·마우스 입력 경로와 Esc·모달 복귀 동작을 기록한다.
- [ ] **Step 5:** 자동 검사·렌더 캡처·사람 테스트가 같은 commit을 사용하도록 한다.

### Task 2: 자동·정적 회귀 재검증

**Files:**
- Test: `tests/test_core_mvp_001_data_contract.py`
- Test: `tests/test_core_mvp_001_static_contract.py`
- Test: `tests/core_mvp_001_scene_test.gd`
- Test: `tests/test_mvp039_manual_ux_validation.gd`
- Test: `tests/ui_visual_capture.gd`

**Interfaces:**
- Consumes: Task 1 기준선.
- Produces: 사람 테스트 전 기능·데이터·Scene 회귀 증거.

- [ ] **Step 1:** Python 데이터·정적 계약 테스트를 실행한다.
- [ ] **Step 2:** Godot CORE-MVP-001 Scene 테스트를 실행한다.
- [ ] **Step 3:** 기존 수동 UX 검증 스크립트를 실행하고 실패 로그를 보존한다.
- [ ] **Step 4:** 1280×720·1920×1080 핵심 화면 캡처를 생성한다.
- [ ] **Step 5:** 글리프 누락, 겹침, 잘림, 포커스 단절, 입력 불가를 체크한다.

### Task 3: 사람 테스트 fixture와 과제 고정

**Files:**
- Create during execution: `docs/validation/URBAN_LEGEND_UX_UI_VALIDATION_PACKET.md`
- Read: `data/poc/core_mvp_001/afterlife_station_poc.json`
- Read: `docs/UX_UI_SYSTEM.md`

**Interfaces:**
- Consumes: 실제 CORE-MVP-001 사건과 정보 상태.
- Produces: 신규 플레이어 6명에게 동일하게 제공되는 과제와 질문.

- [ ] **Step 1:** 현장 조사에서 조사 가능 요소와 현재 위험을 찾는 과제를 작성한다.
- [ ] **Step 2:** 기록에서 확인 사실·단일 증언·미확인을 구분하는 과제를 작성한다.
- [ ] **Step 3:** 두 정보의 모순을 찾고 추가 조사 행동을 선택하는 과제를 작성한다.
- [ ] **Step 4:** 가설의 근거·반례·미확인 정보를 설명하는 과제를 작성한다.
- [ ] **Step 5:** 위험 검증 전에 잃을 것·확인할 것·불확실성을 설명하는 과제를 작성한다.
- [ ] **Step 6:** 회수·추가 조사·철수 중 하나를 선택하고 이유를 설명하는 과제를 작성한다.
- [ ] **Step 7:** 복귀 화면에서 최근 사건·확인 규칙·현재 목표·미해결 모순을 설명하는 과제를 작성한다.

### Task 4: 신규 플레이어 6명 테스트 실행

**Files:**
- Create during execution: `docs/validation/URBAN_LEGEND_UX_UI_VALIDATION_RESULTS.md`
- Update after execution: `docs/UX_UI_SYSTEM.md`

**Interfaces:**
- Consumes: Task 1 빌드와 Task 3 과제.
- Produces: 행동·설명·오류·중단 증거.

- [ ] **Step 1:** 프로젝트와 사건을 모르는 신규 플레이어 6명을 모집한다.
- [ ] **Step 2:** 진행 설명은 조작 안내로 제한하고 정보의 정답·가설·회수 판단을 유도하지 않는다.
- [ ] **Step 3:** 각 과제의 첫 행동 시간, 잘못 연 화면, 되돌리기, 멈춤, 질문을 기록한다.
- [ ] **Step 4:** 테스트 종료 직후 사실·증언·가설·모순의 차이를 말로 설명하게 한다.
- [ ] **Step 5:** 다음 검증 행동과 회수 선택의 근거를 설명하게 한다.
- [ ] **Step 6:** 6명 중 5명 이상이 정보 상태와 다음 검증 행동을 구분해야 핵심 이해도를 통과로 판정한다.
- [ ] **Step 7:** 6명 중 5명 이상이 행동→괴이 규칙→위험/회수→기록 변화의 인과를 설명해야 복기를 통과로 판정한다.

### Task 5: 장시간 사용성·접근성 폴백 확인

**Files:**
- Create during execution: `docs/validation/URBAN_LEGEND_UX_UI_VALIDATION_RESULTS.md`
- Update after execution: `docs/CURRENT_STATUS.md`

**Interfaces:**
- Consumes: Task 1 기준선.
- Produces: 읽기·음향·모션·입력 피로와 폴백 증거.

- [ ] **Step 1:** 최소 1명은 45분 연속 사용해 긴 대사·기록 재열람·포커스 피로를 기록한다.
- [ ] **Step 2:** 음향을 끄고 이상 현상·위험 규칙·대사 정보가 자막·아이콘·로그로 남는지 확인한다.
- [ ] **Step 3:** 모션 감소 또는 연출 건너뛰기 상태에서 위협과 결과 인과가 남는지 확인한다.
- [ ] **Step 4:** 키보드 전용과 마우스 전용으로 조사→기록→가설→회수를 각각 완주한다.
- [ ] **Step 5:** 긴 한국어 기록과 최대 정보량에서 읽기 폭·줄바꿈·재열람 위치를 확인한다.
- [ ] **Step 6:** 실제 장애 사용자 검증이 없으면 접근성 상태를 `HUMAN_NOT_RUN`으로 유지한다.

### Task 6: 판정·수정 패키지 분리

**Files:**
- Update: `docs/UX_UI_SYSTEM.md`
- Update: `docs/CURRENT_STATUS.md`
- Create when needed: 후속 UX 수정 Issue

**Interfaces:**
- Consumes: 자동·렌더·사람·장시간·접근성 증거.
- Produces: `KEEP / AMPLIFY / CHANGE / REMOVE / RETEST` 판정과 최소 수정 범위.

- [ ] **Step 1:** 기능 오류와 이해도 문제를 분리한다.
- [ ] **Step 2:** 사람 2명 이상이 같은 지점에서 막히면 재현 가능한 UX finding으로 등록한다.
- [ ] **Step 3:** 규칙·분기·단서 변경 없이 정보 계층·문구·상태·포커스로 해결 가능한 finding을 우선한다.
- [ ] **Step 4:** 수정은 별도 Issue·branch·PR로 분리하고 수정 전후 같은 과제를 재실행한다.
- [ ] **Step 5:** 신규 플레이어·장시간 사용성 기준이 충족되기 전 `POC_PASSED` 또는 제작 확대를 승인하지 않는다.

## Verification Commands

```bash
python -m unittest \
  tests.test_core_mvp_001_data_contract \
  tests.test_core_mvp_001_static_contract \
  -v

godot --headless --path . --editor --quit
godot --headless --path . -s tests/core_mvp_001_scene_test.gd
godot --headless --path . -s tests/test_mvp039_manual_ux_validation.gd
godot --headless --path . -s tests/ui_visual_capture.gd
```

명령 이름이나 CLI 인자가 저장소 Workflow와 다르면 `.github/workflows/`의 현행 실행 명령을 그대로 사용하고 결과 run URL과 artifact ID를 Issue에 기록한다.
