# 이미지 자산 제작·기획 시각화·검수 워크플로

이 문서는 `urban-legend`의 이미지 후보 제작, 사용자 final lock, repository asset promotion, Godot 적용과 runtime evidence를 분리하는 current workflow owner다.

```text
REPOSITORY_PRIMARY_CANON
NOTION_LEGACY_MIGRATION_ONLY
GOOGLE_SHEETS_MIGRATION_ONLY
CANDIDATE_FIRST_VISUAL_PRODUCTION
```

- 제품 자산 승인·의미·권리 owner: 루트 `ASSET_MANIFEST.yml`
- Legacy inventory: `assets/ASSET_MANIFEST.json` = `LEGACY_MIGRATION_PENDING_NON_AUTHORITY`
- current Base owner는 작업 시작 시 project `AGENTS.md`가 채택한 계약과 Base completed main에서 fresh-read한다. 이 파일에 오래된 Base SHA를 latest pointer로 고정하지 않는다.

## 역할

- GPT Work는 current project/visual canon, 기존 승인 이미지·시안, 실제/planned consumer를 확인하고 bounded exploration·production candidate를 이미지 모델로 제작·객관 QA한다.
- 사용자는 후보를 본 뒤 `LOCK / REVISE / REJECT / RETAIN_AS_REFERENCE`를 결정한다.
- Codex는 exact approved repository source와 manifest를 읽고 파일 규격, Godot import, Scene/UI consumer 연결과 runtime 검증을 수행한다.
- DeepSeek 등 다른 도구는 사용자가 명시한 보조 범위에서만 사용하며 current visual owner나 image-generation default를 대신하지 않는다.

## Candidate-first preflight

이미지가 실제 화면, Scene, UI slot, 인물·괴이·장소 상태, Steam/release surface 또는 기획 검수 deliverable에 필요하면 다음을 적용한다.

```text
VISUAL_NEED_CONFIRMED
→ CURRENT_PROJECT_AND_VISUAL_CANON_READBACK
→ ACTUAL_OR_EXPLICITLY_PLANNED_CONSUMER_REQUIRED
→ EXISTING_APPROVED_ASSET_AND_CANDIDATE_REUSE_CHECK
→ BOUNDED_BRIEF_READY
→ IMAGE_MODEL_GENERATES_ONE_CANDIDATE
→ OBJECTIVE_QA_AND_BOUNDED_CORRECTION
→ PRESENT_FOR_USER_FINAL_LOCK
```

```yaml
VISUAL_CANDIDATE_PREFLIGHT:
  project_source_sha:
  requirement_or_decision:
  actual_or_planned_consumer:
  screen_scene_slot_state:
  current_visual_owner:
  approved_anchor:
  existing_approved_asset_reuse:
  existing_candidate_reuse:
  dimensions_format_alpha:
  keep: []
  avoid: []
  do_not_drift: []
  rights_and_similarity_constraints:
  bounded_deliverable:
  result: READY | REUSE | TEXT_NATIVE | BLOCKED_UNVERIFIED | DO_NOT_GENERATE
```

preflight가 완료되면 같은 내용을 다시 승인받기 위해 제작 전에 멈추지 않는다. 후보 한 건을 먼저 만들고 사용자가 결과를 보고 final lock 여부를 결정한다.

다음이면 생성하지 않는다.

- exact project/consumer가 없다.
- current visual owner·approved anchor·기존 시안을 읽지 못했다.
- current anchors가 충돌한다.
- 기존 승인 asset·candidate로 충족되는지 확인하지 않았다.
- rights·유사성·규격·scope가 제품 결과를 바꿀 정도로 불명확하다.

## 이미지 제작 방법

실제 이미지 deliverable은 host image generation/editing model로 제작한다.

```text
IMAGE_MODEL_REQUIRED_FOR_IMAGE_CREATION_OR_EDITING
DIRECT_VECTOR_IMAGE_AUTHORING_PROHIBITED
NO_VECTOR_OR_CODE_DRAWN_FALLBACK
```

SVG/vector, HTML/Canvas, Python drawing, Godot primitive로 artwork를 대신 만들지 않는다. 시스템 구조, 세계관 규칙, 관계도, Flow, checklist는 Markdown·표·JSON·Mermaid 같은 수정 가능한 text-native artifact를 우선한다.

한 candidate 뒤 다른 인물·괴이·화면·상태군·release asset으로 자동 연쇄 생성하지 않는다.

```text
NO_AUTOMATIC_IMAGE_CHAIN
NO_AUTOMATIC_SCOPE_EXPANSION
```

명백한 crop·artifact·규격·brief 불일치만 같은 deliverable 안에서 한정 교정한다. 새 방향·구도·캐릭터·화면은 새 scope다.

## 기획 중 우선 이미지

실제 consumer가 확인된 경우 다음 순서로 검토한다.

1. 연간 일정·일상·조사·회수·복귀 핵심루프의 플레이어-facing 화면 또는 Blueprint 검수 candidate.
2. 권나래와 동료·요원·기관·세력의 실제 대화·관계·상태 consumer.
3. 조사 VN, 규칙 가설 카드, 단서·위험·기록물 UI.
4. 에피소드별 미니게임과 회수·회복 전투의 연결 화면.
5. 현대 한국 도시괴담의 장소·조명·괴이 징후 anchor.

구조 설명만 필요하면 text-native artifact를 사용하고 이미지 gap 자체를 생성 권한으로 해석하지 않는다.

## 제품·출시 후보

실제 목표와 규격이 current Decision에 있을 때만 제작한다.

1. Annual Demo·Steam 키아트·캡슐·스크린샷.
2. 주요 인물 초상·표정·컷인 state family.
3. 괴이 기록 매뉴얼·규칙 카드·장비·기관 시각 체계.
4. 조사·분기·미니게임·회복 전투의 실제 16:9 UI.

출시 규격·권리·store 정책은 current official source에서 다시 확인한다.

## 상태와 evidence ceiling

```text
NEEDED
→ BRIEF_READY
→ GENERATED_CANDIDATE
→ OBJECTIVE_QA_PASSED | REVISION_REQUIRED | REJECTED
→ USER_FINAL_LOCKED
→ CANON_REGISTERED
→ PROJECT_ASSET_APPROVED
→ IMPLEMENTED
→ RUNTIME_VERIFIED
```

```text
GENERATED_CANDIDATE != USER_FINAL_LOCKED
USER_FINAL_LOCKED != PROJECT_ASSET_APPROVED
CANDIDATE_PRODUCTION_IS_NOT_IMPLEMENTATION_AUTHORITY
```

- 생성 후보는 자동 최종 자산이 아니다.
- user final lock은 시각 방향 확정이며 제품 경로 승격·Scene 연결·runtime PASS가 아니다.
- `PROJECT_ASSET_APPROVED`는 루트 manifest와 repository receipt가 책임진다.
- `IMPLEMENTED`는 actual Godot consumer가 해당 자산을 사용함을 뜻한다.
- `RUNTIME_VERIFIED`는 실제 16:9 화면, 상태, 입력, 접근성과 필요한 플랫폼 증거가 있어야 한다.

## 객관 QA

후보를 제시하기 전에 확인한다.

- 기획·세계관·인물·괴이 규칙
- current approved visual anchor와 Keep/Avoid/Do Not Drift
- 실제 16:9 가독성과 UI 의미
- 손·표정·한글·간판·원근·광원·투명도·seam·crop 오류
- 특정 IP·작가 style imitation·상표·실존 인물·권리 위험
- 원출처·모델·prompt/brief·generation date·file hash provenance
- Godot import/format/alpha/size feasibility

정적 inspection은 runtime 또는 Human QA PASS가 아니다.

## 루트 `ASSET_MANIFEST.yml`

루트 `ASSET_MANIFEST.yml`은 tracked 제품 자산의 승인·의미·권리 원장이다.

```yaml
ASSET_PROMOTION_RECEIPT:
  asset_id:
  decision_id:
  source_candidate:
  repository_path:
  sha256:
  provenance:
  rights_license:
  actual_consumer:
  state_family:
  supersedes:
  user_final_lock:
  project_asset_status:
  implementation_status:
  runtime_evidence:
```

- `PROJECT_ASSET_APPROVED` 전 후보는 제품 자산이 아니다.
- 승인 전 후보는 tracked product path와 actual Scene/Resource에 자동 승격하지 않는다.
- source·SHA-256·provenance·rights·consumer·state family·supersession을 repository에서 readback한다.
- 실제 Godot import·16:9 적용·접근성·시각 QA를 실행하지 않았다면 검증 상태를 PASS로 쓰지 않는다.
- 승인·교체·폐기는 repository Decision과 manifest receipt로 추적한다. Sheet row는 current approval 조건이 아니다.

원격 작업 환경에서 프로젝트 로컬 `.asset-vault/`를 읽지 못하면 `VAULT_LOCAL_STATE_UNVERIFIED`를 유지한다. 과거 대화·legacy manifest·파일명만으로 로컬 후보 존재를 추정하지 않는다.

## 사용자 승인 원본 보관

사용자가 candidate를 final lock하면 원본과 receipt를 repository current owner에 보관한다.

기본 위치:

```text
docs/visual/candidates/
```

receipt에는 파일명, 픽셀 크기, bytes, SHA-256, approval scope, actual/planned consumer, rights boundary, source model/brief와 superseded reference를 기록한다.

Notion native attachment나 Sheet 승인 로그의 이중 보관은 current completion gate가 아니다. unique legacy attachment를 repository로 이관하는 명시 migration scope에서만 원본 회수 후 destination readback receipt를 남긴다.

## Legacy `assets/ASSET_MANIFEST.json`

`assets/ASSET_MANIFEST.json`은 과거 제작 재고와 생성 기록을 보존하는 `LEGACY_MIGRATION_PENDING_NON_AUTHORITY` 자료다. 그 안의 `stage: final`, 파일명 또는 QA 문구는 current `PROJECT_ASSET_APPROVED`나 runtime 승인을 부여하지 않는다.

Legacy 항목은 다음 조건을 모두 만족한 경우에만 개별 승격할 수 있다.

1. 실제 file, current Godot reference와 origin을 재확인한다.
2. rights·similarity·format·readability·accessibility·runtime evidence를 current 기준으로 다시 판정한다.
3. 사용자가 결과를 보고 final lock한다.
4. 루트 `ASSET_MANIFEST.yml`에 repository path·SHA-256·provenance·rights·consumer·verification evidence를 기록한다.
5. 실제 consumer 적용과 runtime evidence 뒤에만 `RUNTIME_VERIFIED`를 판정한다.

과거 제작 방식은 historical evidence로 보존하며 새 제작·교체 방식은 current Base/project policy와 자산별 evidence에서 다시 정한다.

## 구현 가능성 조사

새 asset format, animation/state family, UI composition, import, atlas, shader/VFX integration 또는 release surface를 확정하기 전에 실제 구현 가능성을 확인한다.

```text
IMPLEMENTATION_FEASIBILITY_BEFORE_COMMITMENT
CURRENT_OFFICIAL_PRIMARY_RESEARCH_REQUIRED
DIRECTLY_RELEVANT_FIELD_EVIDENCE_REQUIRED
ACTUAL_PROJECT_STRUCTURE_FEASIBILITY_REQUIRED
FEASIBLE | PARTIAL | BLOCKED_UNVERIFIED
```

- current Godot/import/platform/store official docs
- directly relevant successful, failed or mixed field cases
- actual Scene/Resource/script/UI consumer and import settings
- texture size, compression, memory/VRAM, batching, atlas, animation and platform constraints
- automated checks, runtime capture, rollback/migration
- rights, cost and security

외부 사실이 결론을 바꿀 수 없는 순수 기계 작업만 `MECHANICAL_NO_EXTERNAL_DEPENDENCY` 사유를 남긴다.

## 장기 품질·자동화·학습

```text
LONG_TERM_QUALITY_OVER_LOCAL_SPEED
ROOT_CAUSE_AND_REUSE_BEFORE_REPEATED_MANUAL_PATCH
MINIMUM_SUFFICIENT_COMPLEXITY
SPECULATIVE_OVERENGINEERING_REJECTED
PLAYABLE_OR_OPERATIONAL_VALUE_OVER_DOCUMENT_VOLUME
MINIMIZE_USER_INTERVENTION_WITH_SAFE_FINAL_CONTROL
INCIDENT_SOLUTION_LESSON_AUTOMATION_LOOP
```

사용자는 핵심 게임 의미, Art Direction, visual final lock, 큰 범위·비용, release/external exposure, 권리·보안과 비가역 변경에 집중한다. AI는 fresh-read, reuse search, research, bounded candidate, objective QA, safe document/manifest/test correction, readback, regression check와 남은 작업 재계산을 연속 수행한다.

```text
problem → reproducible evidence → root cause → correction → regression prevention → project owner/readback → reusable lesson → Base BCP when cross-project evidence exists
```

대화 기억 대신 repository owner, validator, test, template, checklist와 approved proposal에 학습을 남긴다.

## 실제 적대적 검토와 교정

material한 policy·asset workflow·candidate package 변경 뒤 actual review evidence가 필요하다.

```text
ACTUAL_POST_COMPLETION_ADVERSARIAL_REVIEW_REQUIRED
FULL_LOOP_COUNT_MINIMUM: 5
EXECUTION_EVIDENCE_REQUIRED
CORRECT_VALIDATED_FINDINGS
NO_REVIEW_COMPLETION_CLAIM_WITHOUT_EVIDENCE
CLEAN_REVIEW_EXIT
```

각 whole-state loop에서 authority, consumer, project consistency, rights, implementation feasibility, state/evidence ceiling, scope, cost, rollback, stale reference를 다시 공격한다. finding을 검증하고 실제 owner를 교정한 뒤 exact-head test/readback을 수행한다. 최소 5회 뒤에도 valid blocker가 남으면 계속한다.
