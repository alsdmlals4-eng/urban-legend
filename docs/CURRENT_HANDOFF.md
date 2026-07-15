# Current Codex Handoff

> 문서 위치: `docs/CURRENT_HANDOFF.md` | 이전 인수 기록: `docs/archive/backup/2026-07-16/COMPLETED_QA_RULES_HANDOFF_BACKUP.md`

이 문서는 계정·채팅 교대 시 읽는 짧은 상태다. 실제 완료 여부는 `origin/main`, 테스트, `docs/CURRENT_STATUS.md`로 다시 확인한다.

```yaml
status: COMPLETE
branch: main
implemented_baseline: MVP-043 / Ver 4.1 / save mvp-039
baseline_commit_before_document_cleanup: 130466e66d3115876a85ba06f47b7661fae3f304
current_protagonist: 권나래
implemented_cases:
  - 저승역
  - 비 오는 골목의 빨간 우산
  - 폐주파수 방송국
approved_but_not_implemented:
  - MVP-044 괴이 1~3편 대사·일상·후일담·세력 서사
  - MVP-045 관계 태그·선택 기억·연속 이벤트
  - MVP-046 대화 UI·표정·컷인·이벤트 연출
repository_document_state:
  - docs/CURRENT_STATUS.md가 현재 상태 단일 원본
  - 완료·중복·저사용 정보는 docs/archive/backup/2026-07-16/에 보관
  - DESIGN_INTENT, PROJECT_BRIEF, CONTENT_DIRECTION_V09는 리디렉션 문서
next_action:
  - 대상 Codex ZIP 하나를 선택
  - ZIP의 00_README와 IMP-00 사전 감사부터 진행
  - 구현 완료 전에는 계획을 구현 확인으로 표시하지 않음
```

## 인수 규칙

- `status: IN_PROGRESS`이면 현재 브랜치와 dirty diff를 먼저 확인한다.
- `status: CHECKPOINT`이면 실패·미검증 항목을 유지하고 같은 작업 브랜치에서 이어간다.
- `status: COMPLETE`여도 `main`, `origin/main`, `docs/CURRENT_STATUS.md`를 대조한다.
- 기본 읽기는 `AGENTS.md → docs/CURRENT_STATUS.md → docs/DOCUMENTATION_MAP.md → 대상 파일`이다.
- 완료된 Goal·QA·백업은 현재 작업이 요구할 때만 읽는다.
- 로드맵과 구현이 다르면 실제 코드·테스트를 우선하고 문서를 갱신한다.
