# D-2026-08-28 · Repository-Only Project Canon

> Status: `USER_APPROVED / CURRENT_WORKSPACE_POLICY`
> Decision ID: `D-2026-08-28-REPOSITORY-ONLY-PROJECT-CANON`
> Scope: people-facing planning, structured planning, implementation, evidence, readback
> Owner: `AGENTS.md`, `docs/OPERATING_MODEL.md`, `docs/DOCUMENTATION_MAP.md`, `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`, `docs/CURRENT_DECISION_OVERLAY.md`, `docs/CURRENT_HANDOFF.md`, `skills/PROJECT_BASE_ADAPTER.json`, `skills/SKILL_REGISTRY.json`

## Decision

앞으로 괴이 기록국의 사람용 기획, 구조화 기획, 구현, 테스트, runtime evidence는 **repository**가 단독 소유한다. 사람용 전체 그림은 `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`와 user PDF GDD가 제공한다.

기존 Notion 페이지는 삭제하거나 새로 쓰지 않는다. 현재 유효했던 구조와 작업물은 `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md` 및 해당 repository owner로 이전했으며, Notion은 `HISTORICAL_READ_ONLY_NO_WRITE`로만 보존한다. Notion은 current truth나 병합 후 readback destination이 아니다.

## Consequence

- 신규 planning / Decision / GDD / Issue / PR / evidence는 repository에 기록한다.
- 완료 확인은 GitHub remote와 exact commit readback으로 닫는다.
- Notion의 미동기화나 과거 내용은 현행 문서의 defect가 아니다. repository source가 우선한다.
- Google Sheet도 동일하게 migration-only history다.
- Notion-only로 남아 있던 현재 reference mockup은 `docs/migrations/notion-reference-mockups/`에 hash와 상태를 붙여 reference-only로 보존한다. `ASSET_MANIFEST.yml`의 제품 asset 권한을 바꾸지 않는다.

## Incident / Solution / Lesson

- **Incident:** 사람용 Notion과 repository가 함께 current owner였으므로, 같은 사실의 stale 복제와 동기화 비용이 생겼다.
- **Solution:** repository-only owner로 축소하고 Notion을 안전한 역사 참조로 강등한다.
- **Lesson:** 단일 owner 전환은 기록을 삭제하는 작업이 아니라, 신규 write/readback 경로를 하나로 줄이고 historical evidence의 권한을 명시하는 작업이다. 프로젝트 운영 선택이므로 `NO_BASE_PROMOTION`.
