# 괴이 기록국 Game Release Compliance Evidence Pack

> Steam·STOVE 제출 전 작성한다. 현재 문서는 실제 제출·등급·법률 검토가 아니다.

```yaml
release_pack_id:
project: URBAN_LEGEND
repository: alsdmlals4-eng/urban-legend
baseline_commit:
target_build:
status: DRAFT | IN_PROGRESS | READY_FOR_SUBMISSION | SUBMITTED | APPROVED | RETURNED | RELEASE_BLOCKED_UNVERIFIED
rating_strategy: LOWEST_VIABLE_RATING
adult_only_avoidance: AVOID_ADULTS_ONLY
content_rating_target: UNASSIGNED_PENDING_REPRESENTATIVE_BUILD
target_audience: TEEN_AND_ADULT_MYSTERY_STRATEGY_PLAYERS_PENDING_VALIDATION
```

```yaml
Steam:
  questionnaire_version_or_checked_at:
  build_evidence:
  store_evidence:
  trailer_screenshot_evidence:
  mature_content_disclosure:
  ai_disclosure:
  status: NOT_STARTED | IN_PROGRESS | READY_FOR_SUBMISSION | SUBMITTED | APPROVED | RETURNED | RELEASE_BLOCKED_UNVERIFIED
STOVE:
  self_rating_scope: ALL_AGES | AGE_12 | AGE_15 | ADULT_ONLY_GRAC_REQUIRED | UNDECIDED
  questionnaire_version_or_checked_at:
  game_manual_evidence:
  gameplay_video_evidence:
  risk_scene_evidence:
  illustration_evidence:
  language_file_evidence:
  status: NOT_STARTED | IN_PROGRESS | READY_FOR_SUBMISSION | SUBMITTED | APPROVED | RETURNED | RELEASE_BLOCKED_UNVERIFIED
```

## Risk matrix

| Risk | Present | Context/evidence | Platform answer | Mitigation | Status |
|---|---|---|---|---|---|
| violence |  |  |  |  |  |
| sexual content |  |  |  |  |  |
| horror |  |  |  |  |  |
| language |  |  |  |  |  |
| drugs/alcohol/tobacco |  |  |  |  |  |
| crime |  |  |  |  |  |
| gambling/simulated gambling |  |  |  |  |  |
| ads/IAP |  |  |  |  |  |
| UGC/online interaction |  |  |  |  |  |
| AI-generated/live-generated content |  |  |  |  |  |

```yaml
build_store_questionnaire_consistency:
  target_build_matches_review_build:
  store_description_matches_features:
  capsule_and_screenshots_match_build:
  trailer_matches_representative_play:
  inaccessible_uploaded_content_disclosed:
  ai_content_disclosed:
  result: PASS | REVISION_REQUIRED | RELEASE_BLOCKED_UNVERIFIED

asset_rights_coverage:
  MUSIC_SFX:
  FONT:
  CHARACTER_ILLUSTRATION:
  MODEL_3D_ANIMATION:
  PLUGIN_ASSET:
  OPEN_SOURCE_LIBRARY:
  AI_OUTPUT_MODEL_TERMS:
  OUTSOURCING_CONTRACT:
  VOICE_COMPOSER_TRANSLATOR_CONTRACT:
```

필요 권리 `UNKNOWN/PROHIBITED`, 조건 이행·OSS 고지·AI 입력 권리·계약 범위 누락, reference-only 원본 포함, build/store/trailer/questionnaire 불일치, 청소년이용불가 위험 경로 미결정, 민감 원본 공개는 `RELEASE_BLOCKED_UNVERIFIED`다.

```yaml
release_decision: READY_FOR_SUBMISSION | RELEASE_BLOCKED_UNVERIFIED | RETURN_TO_PRODUCTION
runtime_asset_use_status: NOT_RUN
build_store_consistency_status: NOT_RUN
platform_submission_status: PLATFORM_SUBMISSION_NOT_RUN
legal_review_status: LEGAL_REVIEW_NOT_PERFORMED
```
