# Current Codex Handoff

이 문서는 계정·채팅 교대 시 가장 먼저 읽는 짧은 작업 상태다. 실제 완료 여부는 Git과 테스트로 다시 확인한다.

```yaml
status: COMPLETE
goal: MVP-038 기준 살아 있는 통합 게임기획서·상시 최적화 체계 구축
branch: main
completed_work_commit: b7dad0ec1a3293a4c10f0f0aeb67cbfd03129db7
tests: GDD source/hash CURRENT; DOCX 169 paragraphs/20 tables/5 images; section, heading, image, table geometry and accessibility audits PASS; Markdown links 0 missing; workflow, handoff and multi-model contracts PASS; JSON 3 files PASS; Godot 4.7 headless project load PASS; git diff check PASS
changed_files: living Markdown GDD and decorated DOCX generator/output, MVP-038 current docs, documentation map/work rules, compatibility stubs and non-destructive archive
external_artifacts: reference style only C:\Users\user\Downloads\룰렛바운드_게임기획서_v0.7.docx
remaining_work: DOCX page PNG visual QA was unavailable because LibreOffice/Word renderer is not installed; third case, daily episodes, research/equipment content and final 180-220 minute playtime measurement remain later milestones
next_action: open docs/GAME_DESIGN_DOCUMENT.md and docs/URBAN_LEGEND_GAME_DESIGN.docx together; after the next design change rebuild/check DOCX and show both files again
main_integrated: true
origin_pushed: true
```

## 인수 규칙

- `status: IN_PROGRESS`이면 현재 브랜치와 dirty diff를 먼저 확인한다.
- `status: CHECKPOINT`이면 실패·미검증 항목을 유지하고 같은 원격 작업 브랜치에서 이어간다.
- `status: COMPLETE`여도 `main`, `origin/main`, `completed_work_commit`을 대조한다.
- 로드맵과 구현이 다르면 실제 코드·테스트·최근 커밋을 우선하고 차이를 보고한다.
