# 최종 적대적 검토·MVP 마감 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans`; 검증·수정은 `REVIEW → BUILD → REVIEW`로 수행한다.

**Goal:** 사용자 승인 코어와 CORE-MVP-001 계약을 5개 독립 공격 관점으로 검토하고, 검증된 정본·참조·계약 drift만 수정한 뒤 PR·PDF·Manifest 상태를 증거와 일치시킨다.

**Architecture:** 게임 런타임을 변경하지 않는다. `docs/qa/2026-07-24_FINAL_ADVERSARIAL_AUDIT.md`가 이번 작업의 증거 보고서이고, 기존 `PROJECT_CORE`, GDD, `CURRENT_STATUS`, Roadmap은 각자 책임을 유지한다. 자동 계약 테스트로 활성 문서 상태와 구현 계약을 고정하고, PDF는 QA 보고서의 사람용 파생본으로만 발행한다.

**Tech Stack:** Markdown, Python `unittest`, GitHub Actions, DOCX/PDF 결정적 생성·렌더, GitHub PR API.

## Global Constraints

- 최신 사용자 지시와 현재 대화에서 가장 나중에 확정된 결정을 우선한다.
- 프로젝트 코어는 `CORE_RECORDED / CORE_STRESS_TESTED`, 구현은 `POC_PENDING`, Production gate는 `HOLD_UNTIL_PLAYER_EVIDENCE`다.
- 보호 경로 `scripts/core/game_state.gd`, `data/episodes/**`, `scripts/scenes/investigation_scene.gd`, `scripts/scenes/battle_scene.gd`, `project.godot`, `knowledge/base-pack/**`을 수정하지 않는다.
- 저장 `mvp-039`와 `mvp-038` 이관, 기존 ID·세 사건을 변경하지 않는다.
- 전체 원문 대화에 접근하지 못한 항목은 `UNVERIFIED_CONTEXT`로 남기며 완료 선언에 사용하지 않는다.
- 미실행 Godot·사람 검수는 PASS로 쓰지 않는다.

---

### Task 1: 기준선·결정 원장·Red 증거

**Files:**
- Create: `docs/qa/2026-07-24_FINAL_ADVERSARIAL_AUDIT.md`

**Interfaces:**
- Consumes: 현재 사용자 지시, `AGENTS.md`, `START_HERE.md`, `DOCUMENTATION_MAP`, `CURRENT_STATUS`, PR #55 diff.
- Produces: 작업 기준선, 대화 결정 원장, finding ID와 5회 검토 입력.

- [ ] 접근 가능한 대화 범위를 명시하고 `UNVERIFIED_CONTEXT`를 기록한다.
- [ ] 현재 브랜치·PR·Base pin·정본·보호 경로·MVP·검증 환경을 기록한다.
- [ ] 문서 상태 drift와 계약 mismatch를 재현하는 일회성 검사 결과를 Red 증거로 기록한다.
- [ ] 변경 전 rollback은 PR head SHA로 고정한다.

### Task 2: 1차 - 대화·상태·작업 라우팅 감사

**Files:**
- Modify: `docs/BASE_RULES_VERSION.md`
- Modify: `docs/OPERATING_MODEL.md`
- Modify: `README.md`
- Modify: `tests/test_base_operating_sync.py`

**Finding:** 활성 운영 문서의 `IDENTIFIED` 상태와 README의 UX-PD-001 2B·2C 활성 안내가 최신 `CORE_RECORDED / CORE-MVP-001`과 충돌한다.

- [ ] **Red:** 운영 문서와 README가 최신 코어·활성 트랙을 포함하고 stale 표현을 포함하지 않는 계약 검사를 재현한다.
- [ ] **Green:** 두 운영 문서를 `PROJECT_CORE.md` 상태 권한으로 연결하고 README의 현재 계획·남은 작업을 CORE-MVP-001로 갱신한다.
- [ ] **Refactor:** 상태 값을 불필요하게 중복하지 않고 정본 링크를 우선한다.
- [ ] **Regression:** Base pin, Skill 수, 보호 경로, 현재 구현 기준선을 재검증한다.
- [ ] **Rollback:** 변경 전 각 파일 blob SHA로 복원한다.

### Task 3: 2차 - 책임 원본·중복·보류 상태 감사

**Files:**
- Modify: `docs/DOCUMENTATION_MAP.md`
- Modify: `docs/PROJECT_CORE.md`
- Modify: `docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md`
- Modify: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`
- Modify: `tests/test_active_document_references.py`

**Finding:** 통합 명세가 GDD의 프로젝트 전체 상세 설계 책임을 중복 소유하고, PROJECT_CORE는 이전 계획만 링크하며, 점진 공개 2B·2C의 게이트 대기 상태가 문서에 없다.

- [ ] **Red:** 상세 설계 정본·CORE-MVP-001 마일스톤 계약·실행 계획의 책임과 활성 링크가 하나씩 존재하는지 검사한다.
- [ ] **Green:** 통합 명세의 권한을 CORE-MVP-001 마일스톤 계약으로 제한하고 Documentation Map에 조건부 등록한다.
- [ ] **Green:** PROJECT_CORE의 책임 원본 목록에 통합 명세와 상세 구현 계획을 추가하고 과거 전문·재기준화 계획은 이력으로 표시한다.
- [ ] **Green:** UX-PD-001 2B·2C는 CORE-MVP-001 결과 뒤 재매핑되는 `DEFERRED_FOR_REMAP`임을 명시한다.
- [ ] **Regression:** GDD의 상세 설계 권한, CURRENT_STATUS의 구현 사실 권한을 보존한다.

### Task 4: 3차 - 데이터·상태·인터페이스 계약 감사

**Files:**
- Modify: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`
- Modify: `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`
- Modify: `tests/test_active_document_references.py`

**Finding:** 고정 Scene·질문 ID, 장면 클래스명, 상태 단계와 `start()` 반환 형식이 명세와 계획에서 다르다.

- [ ] **Red:** 명세와 계획의 고정 식별자·클래스·공개 상태·함수 시그니처가 일치하지 않는 반례를 기록한다.
- [ ] **Green:** `CoreMvp001Scene`, 계획의 고정 ID 집합, 공통 응답 `Dictionary`를 단일 계약으로 사용한다.
- [ ] **Green:** `INVESTIGATION_SITUATION`, `RESPONSE_RESOLUTION`은 UI/명령 내부 원자 전이인지 공개 enum인지 하나로 고정한다.
- [ ] **Refactor:** 예시 JSON이 고정 ID 목록 밖의 식별자를 만들지 않도록 정리한다.
- [ ] **Regression:** PoC 접두사, 5턴 순서, 미관측 패턴 3·5턴, 포획 표식 3개를 보존한다.

### Task 5: 4차 - 플레이어 경험·UX·접근성 감사

**Files:**
- Modify: `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md`
- Modify: `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md`
- Modify: `TEST_CHECKLIST.md`

**Finding:** 단일 화면 노드 목록만으로는 720p에서 조사·가설·회수 정보가 동시에 노출될 수 있고, 단계 전환 뒤 포커스 복구 계약이 불명확하다.

- [ ] **Red:** 모든 단계 패널이 동시에 표시될 경우 720p 핵심 행동 가시성 계약을 만족하지 못하는 반례를 기록한다.
- [ ] **Green:** 현재 단계의 작업 패널만 표시하고 Footer는 고정하며, 넘침은 단계별 ScrollContainer로 처리한다.
- [ ] **Green:** 단계 진입·뒤로가기 뒤 첫 유효 컨트롤로 포커스를 복구하고 선택 근거를 보존한다.
- [ ] **Regression:** 색·음향 단독 전달 금지, 시간 제한 없음, 마우스·키보드 동등 지원을 유지한다.

### Task 6: 5차 - 구형 참조·GitHub·PR·발행 감사

**Files:**
- Modify: `docs/qa/2026-07-24_FINAL_ADVERSARIAL_AUDIT.md`
- Create: `docs/qa/2026-07-24_FINAL_ADVERSARIAL_AUDIT_PUBLICATION.json`
- Modify: PR #55 title/body if required.

**Interfaces:**
- Consumes: 최신 diff, 활성 문서 테스트, Base workflow, PR checks/review threads.
- Produces: 구형 파일 분류표, 검증 결과, PDF Manifest, 최종 PR gate.

- [ ] `DESIGN_INTENT.md`, `PROJECT_BRIEF.md`, `CONTENT_DIRECTION_V09.md`, `LEGACY_SKILL_ALIASES.md`, `docs/archive/**`, 이전 superpowers 문서를 역할별로 분류한다.
- [ ] 활성 소비자의 오래된 경로·Skill ID·Schema·상태를 재검사한다.
- [ ] QA 보고서 Markdown에서 DOCX/PDF를 생성하고 전 페이지 렌더·preflight를 수행한다.
- [ ] Manifest에 source SHA-256, generator 정보, PDF SHA-256, page count, 자동 렌더, `human_visual_review`를 기록한다.
- [ ] PR 설명을 실제 diff·검사·미검증·rollback과 일치시킨다.
- [ ] Required Check와 review thread를 확인한다.

### Task 7: 전체 검증·최종 판정

**Validation:**

```bash
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py
python -m unittest discover -s tests -p "test_*.py"
python tools/docs/build_game_design_doc.py --build
python tools/docs/build_game_design_doc.py --check
git diff --check
```

- [ ] GitHub Actions에서 저장소가 정의한 Python 계약 테스트를 통과한다.
- [ ] GDD 변경이 있으면 DOCX build/check를 실행하고 결과를 기록한다.
- [ ] Godot 런타임 변경이 없더라도 로컬 실행 환경 부재를 `NOT_RUN`으로 기록한다.
- [ ] `MUST_FIX` 0, 활성 stale 참조 0인지 확인한다.
- [ ] 전체 대화 원문·사람 PDF 검수·로컬 Godot 등 필수 미검증이 남으면 최종 판정을 `UNVERIFIED`로 제한한다.
- [ ] GitHub API 커밋이 원격 PR head에 반영됐는지 확인한다.
