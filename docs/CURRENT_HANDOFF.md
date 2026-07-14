# Current Codex Handoff

이 문서는 계정·채팅 교대 시 가장 먼저 읽는 짧은 작업 상태다. 실제 완료 여부는 Git과 테스트로 다시 확인한다.

```yaml
status: COMPLETE
goal: MVP-038 순차 일정·세력 의뢰·조사 탈출 흐름 개선
branch: main
completed_work_commit: 0ea2918dc51db14560d6e38c3f42d7f6e2483e8b
tests: campaign 52/0; requests 51/0; agent 15/0; recovery 36/0; faction market 52/0; log 54/0; preparation/cinematic/runtime editor/HQ return PASS; full project parse/load PASS; 1280x720 and 1920x1080 visual QA PASS
changed_files: campaign state and save migration, preparation/investigation/result/recovery UI flow, faction request data and tests, MVP-038 docs
external_artifacts: C:\Users\user\Downloads\urban-legend-mvp038-faction-request-gpt-input-2026-07-14.zip
remaining_work: external GPT copy pass is optional and not yet applied; third case, daily episodes, research/equipment content and final 180-220 minute playtime measurement remain later milestones
next_action: run a new campaign through morning result confirmation, afternoon planning, HQ suspend/resume, and one dispatch/recovery request; then send the GPT input ZIP and return its result ZIP for review
main_integrated: true
origin_pushed: true
```

## 인수 규칙

- `status: IN_PROGRESS`이면 현재 브랜치와 dirty diff를 먼저 확인한다.
- `status: CHECKPOINT`이면 실패·미검증 항목을 유지하고 같은 원격 작업 브랜치에서 이어간다.
- `status: COMPLETE`여도 `main`, `origin/main`, `completed_work_commit`을 대조한다.
- 로드맵과 구현이 다르면 실제 코드·테스트·최근 커밋을 우선하고 차이를 보고한다.
