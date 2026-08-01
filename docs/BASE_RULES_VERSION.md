# Base Rules Version

```yaml
base: alsdmlals4-eng/Base
base_version: 9.4.0
base_payload_commit: a728712cb776ec98f4875914a580fcf7d0156593
base_trusted_evidence_commit: ef1fba11167e4da0b298123b0c85ebd268191a42
base_pin_finalization_commit: 87a0b54c2847ce4b685879209205957c170cc1cd
legacy_core_skill_index_commit: c987647d01ad2baa028a16e03d85ddfc1572a727
base_registry_sha256: 693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59
release_state: BASE_RELEASED
project: alsdmlals4-eng/urban-legend
adoption_scope: OPERATING_CONTRACT_ONLY
product_paths_changed: false
```

`skills/PROJECT_BASE_ADAPTER.json`이 Base route와 프로젝트 분야 Skill 10개를 결합한다. Base v9.4는 모델·추론·Prompt caching·비용 측정, 지시 권위, Interface-first Prompt, Context 큐레이션, Artifact 주장 상한, Godot UI 모션 계약을 제공한다.

## 프로젝트 보호 경계

- 괴이 기록국의 조사→기록→가설→검증→안정화·잔향 회수 루프를 변경하지 않는다.
- 새 괴이·분기·단서·플래그·대사·설정·호감도·미니게임 결과를 발명하지 않는다.
- `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot`, 특히 `data/episodes/*`와 `scripts/core/game_state.gd`를 수정하지 않는다.
- 복선·반대 근거·위험 사례·실패 경로·기존 ID·저장 호환성을 보존한다.
- Sheet는 `SHEET_GITHUB_CONFLICT / NO_AUTOMATIC_OVERWRITE`를 유지한다.
- Godot·입력·사람·provider 비용 검증은 `NOT_RUN` 또는 `HUMAN_NOT_RUN`이다.
