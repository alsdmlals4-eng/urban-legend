# Bureau Brand, M04 Human QA, and Base Proposal Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans when applying this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep the approved native title `괴이기록국: 잔향 보고서` exact, prepare a real-person M04 validation package, and submit one reusable checkout-diagnosis lesson to Base without promoting an unapproved visual candidate or mutating an active Base contract.

**Architecture:** The display title remains Godot-native text so Korean copy stays exact and localizable. A generated *text-free* bureau crest is retained only as a review candidate outside the project asset manifest until the user explicitly locks it. M04 receives a versioned human-QA packet that records behaviour separately from machine proof. The Base contribution is proposal-only and cannot change any active Base skill until its independent governance approval is present.

**Tech Stack:** Godot 4.7, GDScript runtime already implemented on this branch, Markdown, Python JSON validation, Git/GitHub.

**Spec:** `docs/CURRENT_DECISION_OVERLAY.md`, `docs/VALIDATION_TARGET_CANON.md`, `docs/CURRENT_VISUAL_WORK_ORDER.md`, `docs/IMAGE_ASSET_WORKFLOW.md`, and Base `[수정제안서]/PROPOSAL_REGISTRY.json`.

## Global Constraints

- Product display title is exactly `괴이기록국: 잔향 보고서`; the official in-world institution remains `괴이 기록국`.
- Generated visual text is prohibited; the title remains native Godot text.
- A generated candidate is `GENERATED_CANDIDATE`, not a project asset, manifest entry, runtime consumer, Human QA, or release-rights proof.
- M04 Human QA may be prepared but must remain `NOT_RUN` until an actual participant finishes the route.
- Do not alter save IDs, episode IDs, project application identity, content answers, or M04 resolution semantics.
- Base proposal and Base implementation remain separate: no active Base skill/template/test changes without `APPROVED_FOR_IMPLEMENTATION` and an approval reference.
- Preserve unrelated worktrees and do not direct-push, force-push, or bypass main protections.

---

### Task 1: Prepare a text-free bureau-crest review candidate

**Files:**
- Create outside the repository: Codex generated-image candidate owned by the image generation workspace.
- Modify: no runtime, manifest, Godot scene, or project asset file.

**Interfaces:**
- Consumes: the approved main-menu background, native `WorldTitle` / `WorldTitleSuffix`, and visual lock in `docs/CURRENT_DECISION_OVERLAY.md`.
- Produces: one `GENERATED_CANDIDATE` marked for `LOCK / REVISE / REJECT` review.

- [x] **Step 1: Compare title-lockup alternatives against the visual lock.**

  Compare (a) native title only, (b) native title plus a text-free bureau crest, and (c) rasterized Korean wordmark. Select (b) only if it preserves exact Korean copy and does not displace the approved archive-lab main-menu background.

- [x] **Step 2: Generate one candidate, with one corrective retry only if review rejects it.**

  Request a horizontal-compatible, transparent-background bureau crest with no letters, words, character, monster, weapon, alley, train, or umbrella. Use the locked realistic Korean urban-noir / soft-anime / dossier-hybrid language, with aged brass line work and a restrained cyan echo accent. If the first review finds text artifacts, nontransparent backdrop, unrequested hue leakage, or a mark too dense for menu scale, make one corrective retry that addresses only those findings.

- [x] **Step 3: Review and classify it without integrating it.**

  Check for text artifacts, third-party resemblance, low-contrast loss, scenario-specific motifs, and any visual drift from the project lock. Keep the candidate outside `assets/` and state `LOCK / REVISE / REJECT` in the completion report.

### Task 2: Add an M04 human-session packet and correct current navigation

**Files:**
- Create: `docs/qa/M04_RELEASE_NEAR_HUMAN_QA_PACKET.md`
- Modify: `docs/VALIDATION_TARGET_CANON.md`
- Test: `tests/test_active_document_references.py`

**Interfaces:**
- Consumes: M04 current route, manual/recovery clocks, M04 truth boundary, and existing M01 packet structure.
- Produces: a ready-to-run but unexecuted human-observation record whose status is `READY_TO_RUN / HUMAN_QA_NOT_RUN`.

- [x] **Step 1: Write the packet with one route and one observation form.**

  Include the runnable order `main menu → M04 dispatch → investigation → player-authored manual → rescue → recovery clocks → composite result`; what the facilitator may say; what they must not reveal; a minimum observation record; stop conditions; and resolution/input/version fields. Require observations and player quotes to be recorded separately.

- [x] **Step 2: Link the packet from the validation router.**

  Add a single M04 `READY_TO_RUN / HUMAN_QA_NOT_RUN` pointer without changing `product_reference_asset: PENDING`, `human_qa: NOT_RUN`, or any release claim.

- [x] **Step 3: Validate documentation references.**

  Run:

  ```powershell
  py -m unittest tests.test_active_document_references
  ```

  Expected result: PASS. A missing packet link or broken current-document reference must fail the test or be caught in the review scan before commit.

### Task 3: Submit, but do not implement, the reusable Base sparse-checkout guard

**Files:**
- Create in a dedicated clean Base worktree/branch: `[수정제안서]/BCP-2026-047-sparse-checkout-canonical-presence-guard/PROPOSAL.md`
- Modify in that same Base worktree: `[수정제안서]/PROPOSAL_REGISTRY.json`
- Test: JSON parse and `git diff --check` in the proposal branch.

**Interfaces:**
- Consumes: the observed project checkout condition where tracked current documents were sparse-omitted, not absent from `HEAD`.
- Produces: `SUBMITTED` Base change proposal with no mutation to a live Base skill, registry of active skills, template, validator, or product repository contract.

- [x] **Step 1: Establish a clean isolated Base proposal branch.**

  Inspect Base working-tree ownership first. If the root has unrelated work, create a separate worktree under Base ownership rather than touching it. Use a `codex/` branch and never modify an open PR branch.

- [x] **Step 2: Write the proposal as a guard, not a recovery recipe.**

  The required diagnosis order is: verify the tracked blob at `HEAD:<path>`; inspect `git ls-files -v -- <path>` for sparse omission; verify the appropriate remote baseline only when that comparison is necessary; restore only a missing clean worktree path from exact `HEAD`. Explicitly prohibit overwriting a present dirty path, treating sparse omission as deletion, or using the guard as a reason to reset user work.

- [x] **Step 3: Register and validate the proposal.**

  Set status to `SUBMITTED`, include the source project exact commit and the user authorization reference, parse the JSON, run `git diff --check`, commit the proposal-only change, push the proposal branch, and read back its remote SHA.

### Task 4: Reconcile, verify, and report without claiming a human pass

**Files:**
- Modify: the Task 2 document/link only.
- Test: focused project documentation test, relevant M04/static checks when available, Git remote readback.

**Interfaces:**
- Consumes: Tasks 1–3 output.
- Produces: pushed project documentation commit, pushed Base proposal branch, a status report in `현재 상태 / 권장 조치 / 요청 이유 / 기대효과` form, and a clear `HUMAN_QA_NOT_RUN` ceiling.

- [ ] **Step 1: Perform five whole-scope adversarial passes.**

  Check: native title exactness; candidate is outside project assets; candidate has no raster text; M04 packet does not teach answers; packet route matches actual M04 systems; validation link does not overclaim human proof; Base proposal is not an active Base implementation; repository worktrees remain isolated; project and Base remotes match their respective local branch heads.

- [ ] **Step 2: Run the scoped verification commands.**

  ```powershell
  py -m unittest tests.test_active_document_references
  git diff --check
  git status --short
  git rev-parse HEAD
  git ls-remote origin refs/heads/codex/m04-playable-vertical-slice-20260831
  ```

- [ ] **Step 3: Commit and publish project changes after exact-head validation.**

  Use a documentation-only commit. Fetch before push, push only `codex/m04-playable-vertical-slice-20260831`, and verify its remote SHA equals local `HEAD`.

- [ ] **Step 4: Report exact boundaries.**

  State that the crest remains a candidate pending user `LOCK / REVISE / REJECT`; M04 machine/runtime evidence does not equal a human result; and the Base item is `SUBMITTED`, not promoted into an active reusable skill.
