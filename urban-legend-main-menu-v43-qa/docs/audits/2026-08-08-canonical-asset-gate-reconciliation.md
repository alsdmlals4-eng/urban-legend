# 2026-08-08 정본·Asset Gate 정합화 감사

## 기준선

- Base main: `fa69a77a14f923a756064f6ae151d34cadb374f7`
- project main baseline: `305d9b5bbf21ea13ce23053e43afd98fabc21654`
- 승인 Godot 권위 Decision: `UL-DEC-AUTHORITY-001`
- 권위 교정 병합: PR #172 / main `305d9b5bbf21ea13ce23053e43afd98fabc21654`
- post-merge 자동 검증: Live Editor `31225687879` PASS · Full Matrix `31225687571` PASS · Core+Docs `31225687675` PASS

## 감사 범위

1. `docs/CURRENT_CONFIRMED_DECISIONS.md`에 `UL-DEC-AUTHORITY-001`이 전파됐는가.
2. 최신 Base의 tracked 제품 자산 권위 `ASSET_MANIFEST.yml`이 프로젝트에 존재하는가.
3. 기존 `assets/ASSET_MANIFEST.json`과 현재 Sheet 이미지 승인 상태가 충돌하는가.
4. 제품 자산 승인·로컬 vault·Human/UI/Android 상태를 실행하지 않은 채 PASS로 올리고 있지 않은가.

## Finding 1 — 승인 Decision 정본 전파 누락

판정: `FIX_NOW / MISSING_PROPAGATION`

`UL-DEC-AUTHORITY-001`은 `docs/operations/GODOT_TOOL_AUTHORITY_LEDGER.json`, GUT 검증 문서, PR #172와 Google Sheet `02_현재_확정결정`에 존재하며 main에서 구현·자동 검증이 완료됐다. 그러나 프로젝트 전체 승인 결정 책임 원본인 `docs/CURRENT_CONFIRMED_DECISIONS.md`에는 해당 Decision이 누락돼 있었다.

정합화 원칙:

- Decision ID를 새로 만들지 않는다.
- `UL-DEC-AUTHORITY-001`의 현재 상태를 같은 ID로 `CURRENT_CONFIRMED_DECISIONS.md`에 전파한다.
- HiGodot sole persistent authoring, GUT non-authoring testing, Hera source inactive/adoption deferred 경계를 유지한다.
- local Windows/Human/UI/Android 검증을 자동 CI 성공으로 대체하지 않는다.

## Finding 2 — 제품 자산 manifest 권위 경로 누락

판정: `FIX_NOW / ORPHANED_CANONICAL_AUTHORITY`

최신 Base `docs/PROJECT_LOCAL_ASSET_VAULT_POLICY.md`와 `templates/project-operations/ASSET_MANIFEST.yml`은 프로젝트 루트 `ASSET_MANIFEST.yml`을 tracked 제품 자산의 승인·의미·권리 원장으로 정의한다. 기준선 프로젝트에는 이 파일이 없었다.

정합화:

- 최신 Base schema v1을 바탕으로 루트 `ASSET_MANIFEST.yml`을 설치한다.
- 현재 Sheet에는 `PROJECT_ASSET_APPROVED` 증거가 없으므로 `assets: []`로 시작한다.
- 이 환경에서 로컬 Windows `.asset-vault/`를 읽지 못하므로 `VAULT_LOCAL_STATE_UNVERIFIED`를 유지한다.
- 프로젝트 vault 도구/계약의 설치·동작을 검증하지 않았으므로 `asset_vault.enabled: false`로 둔다.

이 조치는 자산 생성·삭제·제품 승격을 수행하지 않는다.

## Finding 3 — Legacy JSON의 `final` 표현과 현재 승인 상태 충돌

판정: `FIX_NOW / CONFLICTING_SOURCE`

기존 `assets/ASSET_MANIFEST.json`에는 여러 항목이 `stage: final`로 기록돼 있다. 반면 현재 Google Sheet `71_이미지기획_생성목록`·`72_이미지검수_승인로그`는 이미지 생성 미완료, `OPEN_P2`, `NOT_PRODUCT_ASSET`, `PRODUCT_ASSET_NOT_APPROVED`, runtime `NOT_RUN`을 유지한다.

따라서 기존 JSON의 `final`은 현재 제품 승인 의미로 사용할 수 없다.

정합화:

- 파일과 역사 기록은 삭제하지 않는다.
- top-level 상태를 `LEGACY_MIGRATION_PENDING_NON_AUTHORITY`로 명시한다.
- current authority를 루트 `ASSET_MANIFEST.yml`로 연결한다.
- legacy 항목은 개별 재검수와 `PROJECT_ASSET_APPROVED` 전에는 root manifest로 승격하지 않는다.

## 이미지 Gate 현재 판정

```yaml
root_asset_manifest: INSTALLED_FAIL_CLOSED
project_asset_approved_count: 0
legacy_asset_inventory: PRESERVED_NON_AUTHORITY
vault_local_state: VAULT_LOCAL_STATE_UNVERIFIED
asset_vault_runtime_contract: NOT_VERIFIED
image_product_promotion: BLOCKED
image_runtime_validation: NOT_RUN
human_visual_validation: NOT_RUN
android_validation: NOT_RUN
```

`UL-IMG-007`의 planning wireframe 검토는 제품 자산 승인과 다르다. `OPEN_P2 / PRODUCT_ASSET_NOT_APPROVED`를 유지한다.

## 변경 전파 대상

- `docs/CURRENT_CONFIRMED_DECISIONS.md` — 같은 Decision ID와 현재 차단 경계 반영
- `ASSET_MANIFEST.yml` — tracked 승인 권위 설치, 승인 자산 0건
- `docs/IMAGE_ASSET_WORKFLOW.md` — root YAML authority와 legacy JSON 비권위 경계 반영
- `assets/ASSET_MANIFEST.json` — 역사 재고 보존 + non-authority 명시
- Google Sheet — GitHub exact head/merge 상태에 맞춰 허브·Decision·감사·변경이력 동기화

## 미검증·후속

- 로컬 Windows checkout/worktree: `BLOCKED_UNVERIFIED`
- `.asset-vault/library/` 현재 상태: `VAULT_LOCAL_STATE_UNVERIFIED`
- local vault init/sync/check/promote 도구: `NOT_VERIFIED`
- Human QA / 1280×720 / 실제 UI 가독성: `NOT_RUN`
- Android device/export: `NOT_RUN`
- Legacy JSON 각 파일의 현재 권리·Godot 참조·runtime 상태: `MIGRATION_PENDING / NOT_REVERIFIED`

## 완료 조건

- `CURRENT_CONFIRMED_DECISIONS.md`가 `UL-DEC-AUTHORITY-001`과 asset gate 경계를 포함한다.
- root `ASSET_MANIFEST.yml`은 승인 자산을 발명하지 않는다.
- Legacy JSON은 current approval authority로 읽힐 수 없게 명시된다.
- GitHub diff와 자동 검증이 통과한다.
- 같은 Decision ID와 감사 결과가 Sheet에 재동기화된다.
- 실행하지 않은 local/Human/UI/Android 검증은 PASS로 표시하지 않는다.
