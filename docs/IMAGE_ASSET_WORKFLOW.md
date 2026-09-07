# 이미지 자산 제작·GPT 기획 시각화·검수 워크플로

- Base: 대상 작업에서 프로젝트가 채택한 최신 Base image/asset contract를 fresh-read한다.
- Mode: `planning-visualization`, `final-visual-candidate`, `visual-qa-and-approval`.
- 제품 자산 승인·의미 권위: 루트 `ASSET_MANIFEST.yml`.
- Legacy inventory: `assets/ASSET_MANIFEST.json` = `LEGACY_MIGRATION_PENDING_NON_AUTHORITY`.
- Workspace: `REPOSITORY_FIRST_CURRENT_CANON`.

```text
NEED_DRIVEN_GENERATE_THEN_LOCK
CURRENT_APPROVED_VISUAL_ANCHOR_READBACK_REQUIRED
EXISTING_APPROVED_ASSET_REUSE_FIRST
GENERATE_ONE_CANDIDATE_BEFORE_LOCK
USER_LOCK_REVISE_REJECT_AFTER_GENERATION
NO_AUTOMATIC_IMAGE_CHAIN
CURRENT_RESEARCH_AND_IMPLEMENTATION_FEASIBILITY_REQUIRED
CLAIM_ONLY_ADVERSARIAL_REVIEW_INVALID
MINIMUM_FULL_LOOPS_BEFORE_CLEAN_EXIT: 5
```

## 역할

GPT는 프로젝트 최신 정본, 실제 또는 계획된 소비처, 기존 승인 이미지와 시안을 읽고 기획 탐색 이미지·목업 또는 실사용 후보를 제작·검수한다. Codex는 최종 승인된 후보의 파일 규격·manifest·Godot import·Scene/Resource 연결·실제 화면 적용을 담당한다. DeepSeek는 사용자가 명시적으로 대량 초안 조사를 위임한 경우에만 보조하며 이미지 생성의 기본 owner가 아니다.

현재 제품 자산 승격은 fail-closed다. 후보 생성과 사용자 최종 확정, repository asset 승인, Godot 구현, runtime 검증을 구분한다.

```text
GENERATED_CANDIDATE
!= USER_LOCKED
!= PROJECT_ASSET_APPROVED
!= IMPLEMENTED
!= RUNTIME_VERIFIED
```

승인 원장과 repository 정본에서 같은 자산이 `PROJECT_ASSET_APPROVED`로 확인되고, 루트 `ASSET_MANIFEST.yml`에 승인·의미·권리·용도·SHA-256·provenance가 기록된 뒤에만 tracked 제품 자산으로 승격한다. 현재 root manifest의 실제 승인 entry는 매 작업에서 fresh-read한다. 과거 문서에 적힌 개수나 목록을 current truth로 가정하지 않는다.

원격 작업 환경에서 프로젝트 로컬 `.asset-vault/`를 읽지 못하면 `VAULT_LOCAL_STATE_UNVERIFIED`를 유지한다. 로컬 후보 존재를 과거 대화·이전 manifest·repository 상태만으로 추정하지 않는다.

## 후보 선제작 조건

구체적인 이미지 필요성이 확인되면 반복적인 생성 전 승인 질문으로 멈추지 않고 후보 1건을 먼저 제작할 수 있다.

```text
exact consumer or current Blueprint planning-board purpose
→ project canon / approved decision / visual anchor readback
→ existing approved asset reuse or bounded edit check
→ keep / avoid / do-not-drift / size / state / rights brief
→ host image model generates one candidate
→ STOP
→ user LOCK / REVISE / REJECT
```

다음 조건을 모두 만족해야 한다.

1. 실제 runtime Scene·Node·UI slot, 구현 예정 player-facing 화면, 출시 소비처 또는 현재 Blueprint 결정을 위한 구체적인 planning-board 목적이 있다.
2. 최신 프로젝트 기획·세계관·인물·괴이 규칙·Visual 방향과 관련 승인 이미지·시안을 실제로 읽었다.
3. 기존 승인 자산 재사용 또는 identity-preserving edit로 해결 가능한지 먼저 확인했다.
4. 필요한 상태군, 16:9 또는 대상 규격, alpha/crop/anchor, rights/provenance 경계를 brief로 고정했다.
5. 이미지 모델로 후보 1건만 만들고 다음 인물·괴이·화면·독립 variant로 자동 연쇄하지 않는다.

coverage gap, 막연한 장식 필요, consumer 없는 설명용 이미지, 다른 프로젝트 스타일 복제는 생성 권한이 아니다. 시스템·세계관 관계·상태 전이·체크리스트처럼 정확한 구조 정보는 Markdown·표·Mermaid·JSON을 우선한다.

## 기획 중 우선 이미지

아래 목록은 자동 생성 queue가 아니라 구체적 consumer와 current package에서 필요성을 판정할 때 사용하는 후보군이다.

1. 연간 일정·일상·조사·회수·복귀 핵심루프를 비교·검수하는 planning-board.
2. 권나래와 동료·요원·기관·세력 관계·표정·대화 장면의 실제 화면 후보.
3. 조사 VN, 규칙 가설 카드, 단서·위험·기록물 UI 목업.
4. 에피소드별 미니게임과 회수·회복 전투의 연결 화면.
5. 현대 한국 도시괴담의 장소·조명·괴이 징후 tone anchor.

## 기획 종료 우선 후보

1. Annual Demo·Steam key art·capsule·screenshot.
2. 주요 인물 초상·표정·cut-in state family.
3. 괴이 기록 매뉴얼·규칙 카드·장비·기관 시각 체계.
4. 조사·분기·미니게임·회복 전투의 실제 16:9 UI 고도화 목업.

각 항목은 실제 consumer, required state family, size, implementation owner와 acceptance가 있을 때만 제작한다.

## 실제 구현 가능성 조사

이미지 또는 UI 구조를 확정하기 전에 프로젝트의 실제 화면·Scene·Resource·data owner를 읽고, 결과가 구현 가능한지 검증한다.

```text
CURRENT_RESEARCH_AND_IMPLEMENTATION_FEASIBILITY_REQUIRED
MINIMUM_MATERIALLY_DISTINCT_ALTERNATIVES: 3
ADOPT / ADAPT / TEST / REJECT
ACTUAL_PROJECT_BOUNDARY_MAPPING_REQUIRED
FEASIBLE | PARTIAL | BLOCKED_UNVERIFIED
RESEARCH_SUMMARY_IS_NOT_IMPLEMENTATION_PROOF
```

중요한 UI·시각 pipeline·import·atlas·shader·animation·platform 결정은 최신 Godot 공식 문서와 직접 관련된 실무 성공·실패 사례를 조사하고 최소 세 개의 실질 대안을 비교한다. 다음을 actual path에 연결한다.

- Scene·Node·Resource·script consumer.
- data schema와 save/load 영향.
- UI state·input·focus·accessibility.
- texture size, alpha, crop, anchor, filter, compression, atlas.
- animation/VFX/audio/text dependency.
- desktop·Android 성능과 memory 위험.
- rights·reference similarity·commercial release 경계.
- test seam, debug signal, rollback, Codex bounded package.

검색 링크, 설명 문서, 정적 mockup 또는 manifest 문구만으로 `IMPLEMENTED`나 `RUNTIME_VERIFIED`를 주장하지 않는다.

## 장기 품질과 자동화

```text
LONG_TERM_EFFICIENCY_AND_COMPLETENESS_FIRST
QUALITY_OVER_RESPONSE_SPEED
TOTAL_LIFECYCLE_COST
NO_UNSUPPORTED_OVERENGINEERING
MINIMUM_NECESSARY_COMPLEXITY
LOW_INTERVENTION_AUTOMATION_AND_LEARNING_LOOP
```

빠른 임시 이미지나 수동 복사보다 재사용 가능한 state family, 명확한 asset owner, 자동 검증, 안전한 promotion/rollback과 장기 일관성을 우선한다. 다만 current consumer·acceptance·test가 없는 범용 framework, paid dependency, 과도한 asset variant 또는 미래 전용 schema는 만들지 않는다.

승인된 범위의 fresh-read, 조사, 후보 brief, 후보 1건 제작, QA, manifest draft, static checks, readback, finding 교정, 남은 작업 재계산은 가능한 범위에서 연속 진행한다. 핵심 제품 의미, final visual `LOCK`, 큰 비용·범위, rights 불명확, 파괴적 삭제·migration·배포·권한은 사용자에게 올린다.

작업 중 발견한 문제는 `문제 → 원인 → 교정 → 검증 → 회귀 방지`로 repository owner·test·checker·template 또는 Base 승격 후보에 남긴다.

## 상태와 검수

```text
NEEDED
→ BRIEF_READY
→ GENERATED_CANDIDATE
→ IN_REVIEW
→ USER_LOCKED | REVISION_REQUIRED | REJECTED
→ PROJECT_ASSET_APPROVED
→ IMPLEMENTED
→ RUNTIME_VERIFIED
```

기획·세계관·인물·괴이 규칙 일치, 실제 16:9 가독성, 구현 가능성, 손·표정·한글·간판·원근·광원 오류, 특정 IP·작가 스타일 유사성, 원출처·라이선스·모델·brief·provenance를 검수한다.

`LOCK`은 어떤 이미지·상태·consumer를 확정하는지 범위를 기록한다. `LOCK` 전 후보를 tracked production path, Scene/Resource 또는 final manifest entry로 자동 승격하지 않는다.

## 루트 `ASSET_MANIFEST.yml`

루트 `ASSET_MANIFEST.yml`은 최신 Base `docs/PROJECT_LOCAL_ASSET_VAULT_POLICY.md`와 `templates/project-operations/ASSET_MANIFEST.yml` 계약을 따르는 tracked 승인·의미·권리 원장이다.

- `PROJECT_ASSET_APPROVED` 전 후보는 제품 자산이 아니다.
- 승인 전 로컬 후보는 `.asset-vault/`와 `assets/_vault_local/` 경계를 벗어나 tracked 제품 경로로 자동 승격하지 않는다.
- 명시적 사용자 `LOCK`, rights/provenance/consumer readback와 promote receipt 없이 Scene/Resource가 local-only 경로를 장기 참조하지 않는다.
- 실제 Godot import·16:9 적용·접근성·시각 QA를 실행하지 않았다면 manifest 검증 상태를 PASS로 쓰지 않는다.
- 승인·교체·폐기는 repository Decision ID와 exact asset receipt에 기록한다.

## Repository 보관

사용자가 이미지 방향 또는 후보 결과를 `LOCK`하면 원본과 receipt를 프로젝트 저장소의 승인된 visual candidate 또는 asset source 경로에 보관한다. 최소 기록은 다음과 같다.

```yaml
asset_id:
source_path:
pixel_size:
bytes:
sha256:
approval_scope:
actual_or_planned_consumer:
rights_and_reference_boundary:
provenance:
status: USER_LOCKED | PROJECT_ASSET_APPROVED | IMPLEMENTED | RUNTIME_VERIFIED
```

Notion과 Google Sheets는 2026-08-28 repository-only 전환 이후 historical/migration input일 뿐 신규 이미지 보관, 승인 sync, 완료 readback 또는 destination이 아니다. 사용자가 별도 일회성 migration 감사를 명시한 경우에만 read-only로 대조하고 repository receipt로 닫는다.

## Legacy `assets/ASSET_MANIFEST.json`

`assets/ASSET_MANIFEST.json`은 과거 제작 재고와 생성 기록을 보존하는 `LEGACY_MIGRATION_PENDING_NON_AUTHORITY` 자료다. 그 안의 `stage: final`, 파일명 또는 QA 문구는 현재 `PROJECT_ASSET_APPROVED`나 runtime 승인을 부여하지 않는다.

Legacy 항목은 다음 조건을 모두 만족한 경우에만 새 루트 manifest의 제품 자산 항목으로 개별 승격한다.

1. 실제 파일·현재 Godot 참조와 원출처를 재확인한다.
2. 권리·유사성·규격·가독성·접근성·runtime 상태를 현재 증거로 다시 판정한다.
3. 사용자 `LOCK` 또는 current Decision이 동일 자산과 범위를 가리킨다.
4. 루트 `ASSET_MANIFEST.yml`에 canonical path·SHA-256·provenance·권리·용도·검증 증거를 기록한다.
5. 명시적 promotion 이후에만 `IMPLEMENTED`, 실제 실행 뒤에만 `RUNTIME_VERIFIED`를 판정한다.

투명 cutout을 포함한 기존 제작 방식은 역사 기록으로 보존한다. 새 제작·교체 방식은 current Base 정책과 자산별 consumer·approval에 따라 다시 판정한다.

## 증거 기반 적대적 검토

중요 retained change는 최소 5회의 실제 full-scope loop 뒤 clean exit까지 진행한다.

```text
CLAIM_ONLY_ADVERSARIAL_REVIEW_INVALID
EXACT_HEAD_OR_STATE_REQUIRED
ACTUAL_READS_AND_CHECK_RESULTS_REQUIRED
VALIDATED_FINDING_REQUIRES_CORRECTION_OR_EXPLICIT_BLOCKER
MINIMUM_FULL_LOOPS_BEFORE_CLEAN_EXIT: 5
```

각 loop는 전체 승인 범위를 다시 읽고 actual path·diff·consumer·manifest·관련 check를 공격한다. finding을 검증한 뒤 교정 또는 명시 blocker를 남기고 exact head/state에서 회귀·readback을 수행한다. `검토 완료`, `5회 확인`, `문제 없음` 같은 문장만으로는 계수하지 않는다.

## 완료 기준

- need, consumer, visual anchor와 existing asset reuse 결과가 기록됨.
- 후보 1건과 QA 결과가 존재하거나 image model unavailable blocker가 명확함.
- 사용자의 `LOCK / REVISE / REJECT` 상태가 분리됨.
- repository path·SHA-256·provenance·rights·manifest가 같은 결과를 가리킴.
- implemented/runtime evidence ceiling이 과장되지 않음.
- 최소 5회 증거 기반 적대적 검토와 validated finding 교정이 완료됨.
- `NOT_RUN`, `BLOCKED_UNVERIFIED`, 남은 위험이 숨겨지지 않음.
