# Urban Legend 시작 지점

새 채팅·새 GPT·새 Codex·새 작업자가 괴이기록국을 **현재 정본과 실제 main**에서 안전하게 시작하는 최상위 라우터다.

## 기본 읽기

```text
최신 사용자 지시
→ START_HERE.md
→ AGENTS.md
→ GitHub latest main ref + open PR/Issue 상태
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ Notion 괴이기록국 프로젝트 홈
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 실제 main 코드·데이터·Scene·테스트
→ 작업에 필요한 조건부 원본만 추가
```

Validation·저승역·과거 구현 Ledger·승인 역사처럼 작업 주제가 요구할 때만 다음을 추가한다.

- Validation: `docs/VALIDATION_TARGET_CANON.md`
- 저승역 상세 규칙: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`
- 장기 구현·검증 이력/evidence ceiling: `docs/CURRENT_STATUS.md`
- 상세 승인·대체 역사: `docs/CURRENT_CONFIRMED_DECISIONS.md`
- 과거 Validation 인수인계: `docs/CURRENT_HANDOFF_VALIDATION.md`

`전부 확인`은 모든 과거 문서를 기본 로드한다는 뜻이 아니다. 현재 정본·실제 변경 경로·Registry로 범위를 좁힌 뒤 필요한 전문만 읽는다.

## 현재 권위 구분

```text
GitHub latest main ref
= 현재 정확한 commit과 실제 구현 기준

Notion 프로젝트 홈
= 사람이 보는 전체 그림·Flow·비교표·현재 승인 방향

docs/CURRENT_PLANNING_CANON.md + docs/current-planning-canon.json
= 월 1사건 제품 구조·M01/M04 역할·현재 Planning Gate의 정본

docs/CURRENT_DECISION_OVERLAY.md
= 다음 작업자가 바로 소비하는 current mutable decision·verified successor state

docs/CURRENT_STATUS.md
= 장기 구현·검증·ANNUAL/CORE 계보를 보존하는 조건부 Ledger; 현재 Planning Gate를 단독 소유하지 않음

docs/CURRENT_CONFIRMED_DECISIONS.md
= 승인·대체·병합·과거 CI의 상세 역사 원장; current state를 단독 소유하지 않음

실제 main 코드·테스트
= 구현 사실

ASSET_MANIFEST.yml
= tracked 제품 자산 승인·의미·권리 권위
```

현재 상태가 충돌하면 `latest user → latest main → Notion current → CURRENT_PLANNING_CANON / machine canon → CURRENT_DECISION_OVERLAY → 실제 구현/evidence → 조건부 역사 Ledger` 순서로 판정한다.

## 현재 핵심 제품 구조

- 제품 cadence: `1개월 = 메인 사건 1개`, M01~M12 뒤 M13+ 연속.
- M01 저승역: First Session / onboarding / regression.
- M04 빨간 우산: 약 30~45분 release-near player-experience Vertical Slice.
- 공통 core: `조사 → 추리/괴이 매뉴얼 → 피해자 구출 → 회수 → 복합 결과`.
- Visual treatment: `SOFT_ANIME_NOIR_LOCKED`.
- UI/presentation language: `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`.
- Visual planning: `CLOSURE_READY`.
- Concrete product-reference asset: `PENDING`.
- 전체 기획: `CLOSURE_READY / USER_FINAL_PLANNING_DECLARATION_PENDING`.
- `PLAN_LOCK`: ACTIVE.
- runtime implementation: NOT_AUTHORIZED.
- Human QA: NOT_RUN.
- POC_PASSED: NOT_DECLARED.

## 작업 시작 Gate

1. 현재 요청이 기획/검토인지 구현인지 구분한다.
2. 같은 Goal의 open/draft/ready PR은 read-only로 확인한다.
3. 현재 Planning Canon과 실제 구현을 대조한다.
4. 구현 요청이라도 `PLAN_LOCK`·runtime authorization·migration/save 보호 조건을 먼저 확인한다.
5. 실행하지 않은 Human/runtime/device 검증을 PASS로 승격하지 않는다.
6. 병합 후에는 GitHub/Notion destination readback, Issue successor freshness, 진행도 재계산을 닫는다.
