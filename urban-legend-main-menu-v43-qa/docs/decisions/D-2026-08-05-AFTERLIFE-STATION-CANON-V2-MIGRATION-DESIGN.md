# D-2026-08-05-AFTERLIFE-STATION-CANON-V2-MIGRATION-DESIGN

- 제목: 저승역 Canon v2 콘텐츠·ID·저장 이관 아키텍처
- 상태: `APPROVED_SPEC / IMPLEMENTATION_AUTHORIZED / IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN / AUTOMATED_FIXTURE_PREFLIGHT_GREEN / AUTOMATED_WINDOWS_PLATFORM_PREFLIGHT_GREEN / HUMAN_QA_NOT_RUN / MERGE_NOT_AUTHORIZED`
- 설계 방향 승인: `2026-08-05 00:04 KST`
- 문서 승인: `2026-08-05 00:28 KST`
- 구현 승인: `2026-08-05 KST / 사용자 명시 승인`
- Human QA 계획 진행 승인: `2026-08-05 13:01 KST / 사용자 진행 지시`
- Windows 플랫폼 사전검증 승인: `2026-08-05 20:51 KST / 사용자 명시 승인`
- 기준 main: `55721e905bf24fc3deb0de061a529ecb992aee80`
- Design·Plan Draft PR: `#145`
- Implementation Draft PR: `#146`
- Human QA Fixture Draft PR: `#147`
- Windows Platform QA Draft PR: `#148`
- PR: `#148`
- 검증된 구현 HEAD: `e8d48024de0c335d5856dbaf9b2a0ac892d1a3b4`
- 검증된 fixture preflight HEAD: `510ed6151e2d6e91ea247fd568a0b87e53262626`
- 검증된 Windows platform preflight HEAD: `55fec577ed43573087c23e6eab0df04e0ee9346e`
- 실제 사용자 저장: `ACTUAL_USER_SAVE_NOT_AVAILABLE`
- Human QA: `HUMAN_QA_NOT_RUN`
- UI·접근성: `UI_ACCESSIBILITY_NOT_RUN`
- Runtime implementation: `IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN`
- Fixture preflight: `AUTOMATED_FIXTURE_PREFLIGHT_GREEN`
- Windows platform preflight: `AUTOMATED_WINDOWS_PLATFORM_PREFLIGHT_GREEN`
- Merge: `MERGE_NOT_AUTHORIZED`

## 승인 전이

사용자는 Design Spec·ID Migration Matrix에 `문서승인`을 부여한 뒤, 9개 Task 구현 계획과 적대적 Addendum에도 별도 `승인`을 부여했다. 구현 완료 보고 후에는 Human QA 계획과 대표 저장 fixture 사전검증 진행을 지시했고, 이후 Windows 플랫폼 사전검증 실행을 명시 승인했다.

이전 상태는 다음과 같이 역사화한다.

```text
REVIEW_READY / DESIGN_ONLY
→ APPROVED_SPEC / IMPLEMENTATION_PLAN_READY / IMPLEMENTATION_NOT_AUTHORIZED
→ IMPLEMENTATION_AUTHORIZED
→ IMPLEMENTATION_COMPLETE / AUTOMATED_QA_GREEN
→ AUTOMATED_FIXTURE_PREFLIGHT_GREEN / HUMAN_QA_NOT_RUN
→ AUTOMATED_WINDOWS_PLATFORM_PREFLIGHT_GREEN / HUMAN_QA_NOT_RUN
```

현재 권위 상태는 다음과 같다.

```text
APPROVED_SPEC
/ IMPLEMENTATION_AUTHORIZED
/ IMPLEMENTATION_COMPLETE
/ AUTOMATED_QA_GREEN
/ AUTOMATED_FIXTURE_PREFLIGHT_GREEN
/ AUTOMATED_WINDOWS_PLATFORM_PREFLIGHT_GREEN
/ ACTUAL_USER_SAVE_NOT_AVAILABLE
/ HUMAN_QA_NOT_RUN
/ UI_ACCESSIBILITY_NOT_RUN
/ MERGE_NOT_AUTHORIZED
```

구현 승인은 제품 코드·JSON·저장 이관 작업을 TDD로 수행하도록 허가했다. 자동 검증, 대표 fixture 통과와 Windows 플랫폼 사전검증은 실제 사용자 저장, Windows 10/11 실제 PC, UI·접근성 Human QA나 PR 병합 승인으로 해석하지 않는다.

## 결정

저승역 Batch 4 정본을 구현으로 이관할 때 기존 사건을 즉시 덮어쓰거나 새 사건 ID로 복제하지 않는다.

```text
동일 episode·victim stable ID 유지
+ afterlife-station-canon-v2 sidecar
+ 명시적 layer allowlist
+ ID Migration Registry
+ mvp-040 / validation-save-v2
+ backup-first·fail-closed transaction
= 구형 저장·회귀와 새 정본 동시 보호
```

### 유지하는 정체성

- Episode ID: `episode_001_afterlife_station`
- victim stable ID: `victim_afterlife_station_001`
- victim 표시 정본: `이하린`

새 사건 ID를 만들지 않는다.

### 새 콘텐츠 계약

- `content_contract_id: afterlife-station-canon-v2`
- `content_schema: 2`
- 권위 sidecar: `data/episodes/episode_001_afterlife_station_canon_v2.json`
- 활성화는 명시적 loader 요청으로만 수행
- 권위 Canon v2 구조: `investigation_manual`, `rescue_protocol`, `recovery_encounters`, `result_contract`
- 기존 전투 UI용 `clues`·`recovery_patterns`는 Canon v2 ID에서만 생성한 `canonical_v2_projection`
- projected IDs: `record_afterlife_*`, `pattern_afterlife_*`, `response_afterlife_*`
- 구형 `pattern_station_*`·`clue_*` 실행 혼합 금지
- 구형 Core Validation 내용은 `legacy_content_snapshot`에만 보존

### ID 이관

구형 ID는 다음 분류 중 하나를 가진다.

- `KEEP_ID`
- `ALIAS`
- `SPLIT`
- `MERGE`
- `HISTORICAL_ONLY`
- `DISCARD_SEMANTICS`

미매핑 ID는 `orphan_legacy_ids`에 보존하되 런타임에는 적용하지 않는다. 검은 승차권 접촉·파괴 해법과 `같은 시각` 초기화 의미는 자동 정답으로 변환하지 않는다.

### 저장 이관

- 본편 readable: `mvp-038`, `mvp-039`
- 본편 new write: `mvp-040`
- Validation readable: `validation-save-v1`
- Validation new write: `validation-save-v2`
- 원본 bytes backup-first
- inspect·commit 직전 `source_checksum` 비교
- temp write·readback·validator·backup·promote 분리
- 파일 교체 후 runtime apply가 성공해야 `FINALIZED`
- 실패 시 파일과 메모리 모두 rollback
- Legacy 저장 fallback 금지
- 동일 migration·effect 재적용 시 중복 효과 금지

진행 중 구형 구출·회수 전투는 직접 의미 변환하지 않고 `LEGACY_CASE_RESTART_REQUIRED`로 안전 조사 checkpoint에서 무페널티 재시작한다.

## 현업 비교 반영

- Godot: 프로젝트별 저장과 단계적 복원
- Unreal Engine: 책임별 SaveGame·slot 분리
- Unity Cloud Save: write lock과 충돌 감지
- Flyway: versioned migration·checksum·history·apply-once
- GitHub Actions: `windows-latest` 격리 runner
- PowerShell: SHA-256와 명시적 프로세스 ExitCode
- Windows: `FileShare.None` 독점 잠금과 ACL 쓰기 거부

프로젝트 채택안은 `effect_id / backup-first / source_checksum / migration_history / two-phase atomic replace / Windows forced-termination preflight`다.

## 구현·검증 증거

- Implementation evidence: `docs/implementation/2026-08-05-afterlife-station-canon-v2-migration-implementation-evidence.md`
- Design Spec: `docs/superpowers/specs/2026-08-05-afterlife-station-canon-v2-migration-design.md`
- ID Matrix: `docs/planning/2026-08-05-afterlife-station-id-migration-matrix.md`
- Implementation Plan: `docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-implementation-plan.md`
- Adversarial Addendum: `docs/superpowers/plans/2026-08-05-afterlife-station-canon-v2-migration-plan-adversarial-review-addendum.md`
- Human QA fixture package: Draft PR `#147`
- Windows platform package: Draft PR `#148`
- 운영 정책: `docs/decisions/D-2026-08-05-WORKFLOW-BENCHMARK-TDD-AND-CHECKPOINT-POLICY.md`

검증된 구현 HEAD `e8d48024de0c335d5856dbaf9b2a0ac892d1a3b4`:

- Documentation `30973449735`: SUCCESS
- Canon v2 Migration `30973449470`: SUCCESS
- CORE-MVP-001 `30973449472`: SUCCESS
- ANNUAL-MVP-001 `30973449460`: SUCCESS
- Canon v2 focused `8/8`: PASS
- full Godot regression: PASS

검증된 fixture preflight HEAD `510ed6151e2d6e91ea247fd568a0b87e53262626`:

- Documentation `30974953130`: SUCCESS
- Canon v2 Migration `30974953124`: SUCCESS
- ANNUAL-MVP-001 `30974953128`: SUCCESS
- Canon v2 representative fixture focused `9/9`: PASS
- full Godot regression: PASS

검증된 Windows platform preflight HEAD `55fec577ed43573087c23e6eab0df04e0ee9346e`:

- 독립 Windows workflow `31004882572`: SUCCESS
- Migration Ubuntu+Windows workflow `31004882698`: SUCCESS
- ANNUAL-MVP-001 `31004882551`: SUCCESS
- Documentation `31004882625`: SUCCESS
- Windows Server 2025·Godot 4.7.1 import: PASS
- `FileShare.None` 독점 잠금: PASS
- `PREPARED` 강제 종료 후 `ABORTED`: PASS
- `COMMITTED_PENDING_RUNTIME_APPLY` 강제 종료 후 `ROLLBACK_RESTORED`: PASS
- source race `SOURCE_CHANGED`: PASS
- injected·ACL 쓰기 실패 `WRITE_FAILED`: PASS
- 각 복구 경로 원본 SHA-256 불변: PASS

## 대표 fixture 범위

다음 정적 JSON을 실제 파일로 복사해 wrapper load 경로를 검증한다.

- `main_mvp038_investigation.json`
- `main_mvp039_recovery.json`
- `main_mvp039_completed.json`
- `validation_v1_active_recovery.json`

검증 속성은 버전 전환, 정답 비공개, orphan 보존, 안전 재시작, 완료 보고서·보상 불변, 재실행 멱등, Validation 격리다.

이 fixture는 승인된 schema를 기반으로 만든 합성 데이터다. 실제 장기간 사용자 저장의 예상 밖 조합이나 실제 플레이를 대체하지 않는다.

## Windows 플랫폼 사전검증 범위

GitHub-hosted Windows Server 2025 runner의 격리 APPDATA에서 다음을 자동 재현했다.

- 실제 파일 독점 잠금
- transaction journal의 `PREPARED` 상태에서 프로세스 강제 종료
- `COMMITTED_PENDING_RUNTIME_APPLY` 상태에서 프로세스 강제 종료
- 별도 프로세스 복구와 SHA-256 원복 확인
- 외부 source 변경 감지
- deterministic write failure
- 실제 Windows ACL 쓰기 거부

이는 실제 사용자 PC의 Windows 10/11, OneDrive·백신 경쟁 조건, 실제 저장 장기 이력, UI·접근성을 검증하지 않는다.

## TDD Gate

Task 1~9는 각각 RED → 최소 구현 → GREEN → focused 검증 → 전체 회귀 순서로 진행했다. Human QA 준비는 QA 계획·fixture 부재를 RED로 확인한 뒤 대표 fixture 4종과 9번째 focused entrypoint를 추가했다. Windows 플랫폼 검증도 workflow·harness·장애 주입 테스트 부재를 RED로 확인하고, Windows GREEN 후 결과 상태 부재를 다시 RED로 고정해 정본 상태를 전환했다.

## 다음 Gate

1. 실제 사용자 저장 복사본 확보와 SHA-256 기록
2. Windows 10 실제 PC 격리 이관
3. Windows 11 실제 PC 격리 이관
4. OneDrive·백신·동기화 경쟁 조건
5. 실제 디스크 용량·권한 오류
6. UI·접근성 Human QA
7. Human QA 결과 승인
8. PR #145·#146·#147·#148 통합 순서 확정
9. 별도 merge approval

`AUTOMATED_QA_GREEN`, `AUTOMATED_FIXTURE_PREFLIGHT_GREEN`, `AUTOMATED_WINDOWS_PLATFORM_PREFLIGHT_GREEN`은 출시·실제 Human QA·병합 완료를 의미하지 않는다. 별도 병합 승인 전 Draft 해제·auto-merge·merge를 수행하지 않는다.

## 변경하지 않은 범위

- Scene 구조
- 이미지·게임 자산
- 기존 Episode·PoC·Core Validation 파일 삭제
- 실제 사용자 저장 원본
- Windows 10/11 실제 PC Human QA 판정
- UI·접근성 Human QA 판정
- PR 병합
