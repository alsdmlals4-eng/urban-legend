# M04 Work Production Input Packet — 2026-08-27

```yaml
project_identity: urban-legend / 괴이기록국
repository: alsdmlals4-eng/urban-legend
slice_id: M04_RED_UMBRELLA_RELEASE_NEAR_AUDIO_CUE
exact_project_baseline: 583797b2fe0da884d8f872e6b4ffab1e44583f49
player_promise: "세 번째 빗소리와 골목의 되감기 전조를 듣고, 앞서 조사한 근거로 안전한 대응을 판단한다."
player_action_or_choice: "Recovery에서 가설 → 근거 → 대응을 선택한다."
meaningful_tradeoff: "빠른 강행이 아니라 전조와 확보 기록을 확인해 안전한 대응을 택한다."
expected_result: "전조가 나타날 때 짧은 절차음이 즉시 들리고, 기존 화면의 전조·근거·대응 정보와 일치한다."
failure_and_learning: "오대응은 기존 위험 사례·근거 UI에 남으며, 소리만으로 정답이 드러나지 않는다."
reward_and_feedback: "올바른 판단의 안정화 진행과 기존 결과 기록을 유지한다."
approved_scope:
  - "M04 Recovery 전조 발생 시 procedural audio cue"
  - "M04 rain-rewind 전조는 warning, 그 외 전조는 focus 음색"
  - "결정적 Godot 테스트와 headless/runtime 검증"
explicit_non_scope:
  - "새 괴이·단서·가설·저장 필드·대사·경제 변경"
  - "외부 음원·유료 서비스·새 플러그인"
  - "M04 배경/현현 candidate의 제품 승격"
protected_scope:
  - "data/episodes/episode_002_red_umbrella_alley.json"
  - "기존 Recovery 가설→근거→대응 판단 순서"
  - "COMPOSITE_RESULT와 legacy save compatibility"
visual_requirements:
  - "M04 Investigation product background is already canonical; M04 Recovery candidate remains non-product pending overlay comparison."
audio_requirements:
  - cue_id: M04_RECOVERY_TELEGRAPH_CUE
    actual_consumer: scenes/battle_scene.tscn Recovery turn start
    trigger_and_stop_condition: "each loaded Recovery telegraph; one short one-shot stream"
    source_or_generation_route: "existing LogGuide procedural AudioStreamWAV generator"
    file_or_procedural_spec: "warning for pattern_red_rain_rewind, focus for other patterns, normal fallback"
    format_sample_rate_channels: "22,050 Hz / mono / 16-bit PCM from existing generator"
    protected_audio_direction: "brief informational ritual cue, never a melody or answer reveal"
deterministic_test_requirements:
  - "pattern-to-mode mapping"
  - "generated stream has PCM data and expected format"
runtime_qa_scenarios:
  - "M04 Recovery scene starts without errors"
  - "red rain rewind cue uses warning mode; another M04 pattern uses focus mode"
build_or_export_checks:
  - "Godot headless import"
  - "focused M04 and new cue tests"
  - "existing Python contract suite"
rollback: "remove the new cue helper and its one battle-scene call; no save/data migration required"
unresolved_nonblocking:
  - "M04 Recovery background candidate remains PRODUCT_ASSET_PROMOTION_PENDING"
blocking_missing_inputs: []
evidence_ceiling: "machine evidence only; HUMAN_QA and PLAYER_EXPERIENCE remain NOT_RUN"
readiness: READY_FOR_SINGLE_CODEX_WINDOW
```

## Alternatives

| Option | Decision | Reason |
|---|---|---|
| Keep Recovery silent | REJECT | The release-near M04 telegraph has no audio-layer recognition despite a sound-defined rule. |
| Add externally sourced rain/SFX files | REJECT | Adds rights/provenance and delivery risk without improving the actual decision contract. |
| Reuse the existing procedural LogGuide generator through a M04-specific mode mapper | ADOPT | Zero extra cost, no binary provenance gap, reversible, and bounded to actual Recovery telegraph timing. |

## Codex implementation contract

- Add a small Korean-header GDScript helper that maps a pattern id to the existing `LogGuide.make_signature_stream` procedure.
- Add one `AudioStreamPlayer` owned by `BattleScene` and play the generated cue after a non-empty Recovery pattern is selected.
- Do not alter Episode JSON, response correctness, state transitions, save data, screens, assets, or the guided decision flow.
