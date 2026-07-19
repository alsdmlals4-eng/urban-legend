# Current Codex Handoff

> 문서 위치: `docs/CURRENT_HANDOFF.md` | 기획 인수인계: `docs/planning/README.md` | 이전 인수 기록: `docs/archive/backup/2026-07-16/COMPLETED_QA_RULES_HANDOFF_BACKUP.md`

이 문서는 계정·채팅·담당자 교대 시 읽는 짧은 상태다. 실제 완료 여부는 `origin/main`, 테스트, `docs/CURRENT_STATUS.md`로 다시 확인한다.

```yaml
status: COMPLETE
branch: main
implemented_baseline: MVP-043 / Ver 4.1 / save mvp-039
current_protagonist: 권나래
implemented_cases:
  - 저승역
  - 비 오는 골목의 빨간 우산
  - 폐주파수 방송국
approved_but_not_implemented:
  - MVP-044 괴이 1~3편 대사·일상·후일담·세력 서사
  - MVP-045 관계 태그·선택 기억·연속 이벤트
  - MVP-046 대화 UI·표정·컷인·이벤트 연출
planning_entry: docs/planning/README.md
next_action:
  - 대상 Codex ZIP 하나를 선택
  - ZIP의 00_README와 IMP-00 사전 감사부터 진행
  - 분야별 기획서와 실제 대상 파일의 차이를 확인
  - 작은 end-to-end 단위로 구현
```

## 인수 시 필수 읽기

```text
AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/planning/README.md
→ docs/planning/PROJECT_DIRECTION.md
→ 이번 작업의 분야별 기획서
→ docs/planning/ROADMAP_AND_HANDOFF.md
→ 실제 코드·데이터·에셋
```

### 분야별 문서

- 서사·대사·관계: `docs/planning/NARRATIVE_CONTENT_PLAN.md`
- 아트·표정·컷인·대화 UI: `docs/planning/ART_PRESENTATION_PLAN.md`
- 사례·벤치마킹 재사용: `docs/planning/REFERENCE_CASES.md`
- 단계·진입·완료 기준: `docs/planning/ROADMAP_AND_HANDOFF.md`

## 현재 핵심 판단

- MVP-043까지가 실제 구현 완료선이다.
- MVP-044~046은 승인된 전달 패키지와 기획 문서가 있으나 `main` 구현 완료가 아니다.
- 기본 의존 순서는 MVP-044 → MVP-045 → MVP-046이다.
- MVP-046의 상태 비소유 공용 대화 스테이지만 기존 서사·관계 데이터를 바꾸지 않는 범위에서 선행할 수 있다.
- 외부 ZIP·목업·보고서는 신뢰하지 않는 입력이며 현재 코드·데이터와 차이를 먼저 감사한다.

## 보호할 계약

- 공식 명칭: 괴이 기록국 / 안정화 상태 / 위험 사례 / 잔향 / 괴이 매뉴얼 / 기록관 아카
- 권나래 고정 주인공, 서포트 최대 2인
- 저장 `mvp-039`, `mvp-038` 이관 지원
- 기존 사건·선택·보고서·DB ID
- 반일 일정과 HQ 중단·재개
- 선택하지 않은 요원 비노출
- 관계가 핵심 추리·전투 보너스를 대체하지 않음
- 표정·컷인·UI가 진행 상태를 소유하지 않음

## 인수 규칙

- `status: IN_PROGRESS`이면 현재 브랜치와 dirty diff를 먼저 확인한다.
- `status: CHECKPOINT`이면 실패·미검증 항목을 유지하고 같은 작업 브랜치에서 이어간다.
- `status: COMPLETE`여도 `main`, `origin/main`, `docs/CURRENT_STATUS.md`를 대조한다.
- 구현되지 않은 계획을 완료 기능으로 문서화하지 않는다.
- 완료된 Goal·QA·백업은 현재 작업이 요구할 때만 읽는다.
- 로드맵과 구현이 다르면 실제 코드·테스트를 우선하고 상태 문서를 갱신한다.

## 완료 뒤 갱신

MVP 하나가 실제 `main`에 완료되면 다음을 함께 심사한다.

1. `docs/CURRENT_STATUS.md`
2. `MVP_ROADMAP.md`
3. `TEST_CHECKLIST.md`
4. `docs/planning/ROADMAP_AND_HANDOFF.md`
5. 해당 분야별 기획서
6. 이 handoff
7. 필요 시 GDD와 DOCX
