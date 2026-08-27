# 괴이기록국 정본화 · 현행 상태 정합화 기록

> Role: `CANONICALIZATION_AUDIT`
> Date: `2026-08-28`
> Scope: GitHub latest completed main `a8a7e7f80b36f86f7955095acca2ead5713e42a7`, Notion human-facing surfaces, and current implementation/asset evidence.
> Issue: #321
> Boundary: documentation and Notion reconciliation only; no Godot product mutation.

## Current

- 목표: M01 저승역 First Session과 M04 빨간 우산 30–45분 player-experience Vertical Slice.
- 대표 흐름: Main Menu → Dialogue → Preparation → Investigation / Manual → Rescue → Recovery → Composite Result → Preparation 또는 Main Menu.
- 기획: `PLANNING_COMPLETE`; shared runtime: `MERGED_MAIN`; Human/new-player QA: `NOT_RUN`.
- 실제 제품 asset 권위: root `ASSET_MANIFEST.yml`. 현재 6개의 `PROJECT_ASSET_APPROVED` entry가 있으며, 각 entry의 runtime evidence와 전역 Human QA를 혼동하지 않는다.
- 시각 방향: `SOFT_ANIME_NOIR_LOCKED` + `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM`.

## Classification

| item | classification | evidence / disposition |
|---|---|---|
| GitHub origin/main `a8a7e7f` | CURRENT | current repository authority |
| local checkout `8bbcfc6` | HISTORICAL / UNKNOWN_UNVERIFIED | 46 commits behind and 418 uncommitted paths; preserved, not used as current fact |
| Base main `7cfc75d` | CURRENT_BASE | current completed Base main; 11 open Base PRs remain read-only |
| project PR #287, #231 | OPEN_READ_ONLY | not modified by this task |
| M01/M04 shared runtime | CURRENT | planning canon, code/Scene/test lineage and recorded automated evidence |
| M04 Investigation Anchor 01 | CURRENT_CANDIDATE | user-approved visual candidate; not a promoted production asset |
| six manifest asset entries | CURRENT | individual approved/implemented/runtime-evidence scope as declared by manifest/work order |
| M04 D RGBA candidate | CURRENT_CANDIDATE | product promotion/runtime/Human QA pending |
| `VISUAL_ANCHOR_SPEC.md` blanket pending language | SUPERSEDED_IN_PART | retained for historical anchor boundary; now explicitly routes individual status to current owners |
| Notion Direction content for Switchy Express | CONFLICT | must be replaced by urban-legend direction |
| Notion Home/Visual/Production pointers ending at `c5b4f4f` | HISTORICAL | retain dated history but add an explicit current override |

## Incident → solution → lesson

- **Incident:** current human-facing Direction page contained a different project’s content, while multiple current documents collapsed individual asset status into a blanket pending label.
- **Solution:** restore the project-specific Direction page; point individual asset claims to the manifest/work-order/checklist; retain historical statements as dated records.
- **Lesson:** project identity must be checked before interpreting a human-facing page title, and global gates must name their exception/subject rather than hiding separately verified consumers. This is project-specific evidence only; **NO_BASE_PROMOTION** until another independent project reproduces the failure.

## Evidence ceiling

Automated and historical runtime captures are evidence only for their recorded exact scope. No current live runtime was used: the available Godot editor belonged to Switchy Express, not this project. Human usability, player experience, accessibility playtest, and M04 D candidate promotion remain `NOT_RUN` / pending.
