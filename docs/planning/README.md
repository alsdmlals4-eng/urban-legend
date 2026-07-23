# 괴이 기록국 기획 인수인계 인덱스

> 문서 위치: `docs/planning/README.md` | 시작 지점: `../../START_HERE.md` | 현재 구현 상태: `../CURRENT_STATUS.md` | 상세 설계 원본: `../GAME_DESIGN_DOCUMENT.md` | Skill Registry: `../../skills/SKILL_REGISTRY.json`

이 폴더는 새 기획자·ChatGPT·Codex가 **현재 구현과 다음 작업의 의도를 빠르게 이해하고**, 필요한 실제 코드·데이터·에셋으로 이동할 수 있게 하는 기획 전용 진입점이다.

기획 문서는 코드와 데이터의 대체물이 아니다. 구현 사실이 충돌하면 현재 `main`의 코드·데이터·테스트가 우선하며, 기획 문서에는 차이를 기록하고 상태를 갱신한다.

## 1. 권장 읽기 순서

### 새 작업 인수

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/planning/README.md
→ docs/planning/PROJECT_DIRECTION.md
→ 이번 작업의 분야별 기획서 1개
→ skills/SKILL_REGISTRY.json
→ 선택된 프로젝트 분야/로컬 Skill과 필요한 Base Skill
→ docs/planning/ROADMAP_AND_HANDOFF.md
→ 대상 코드·데이터·에셋
```

### 분야별 추가 문서와 Skill

| 작업 | 먼저 읽을 기획서 | 프로젝트 Skill | 추가 확인 |
|---|---|---|---|
| 새 괴이 사건의 전조·가설·근거·대응·매뉴얼 상태 | `PROJECT_DIRECTION.md`, `../GAME_DESIGN_DOCUMENT.md` | `urban-legend-investigation-case-authoring` + 필요 시 `urban-legend-game-design` | `../MINIGAME_SYSTEM_SPEC.md`, 대상 `data/episodes/`, 관련 테스트 |
| 괴이 사건 대사·일상·후일담 | `NARRATIVE_CONTENT_PLAN.md` | `urban-legend-narrative` | `../PROJECT_CONTEXT.md`, `data/episodes/`, `data/daily_episodes.json` |
| 관계·선택 기억·연속 이벤트 | `NARRATIVE_CONTENT_PLAN.md` | `urban-legend-narrative` | 현재 저장 상태, 이벤트 ID, 완료 기록 |
| 캐릭터 아트·표정·컷인 | `ART_PRESENTATION_PLAN.md` | `urban-legend-art` | `assets/characters/`, manifest, 실제 화면 캡처 |
| 대화 UI·이벤트 연출 | `ART_PRESENTATION_PLAN.md` | `urban-legend-ux-ui-accessibility` | 공용 UI 스크립트·씬, 입력·접근성 계약 |
| 준비·조사·결과 정보 위계 | `PROGRESSIVE_DISCLOSURE_PLAN.md` | `urban-legend-ux-ui-accessibility` | 실제 준비·조사·결과 코드와 720p/1080p 검증 |
| 안정화·매뉴얼 기록 UI | `PROJECT_DIRECTION.md` | `urban-legend-game-design`, `urban-legend-ux-ui-accessibility` 중 주 책임 하나 | `../CINEMATIC_FIELD_RECOVERY_UI.md`, 실제 회수·결과·DB 코드 |
| MVP 범위·순서·완료 판단 | `ROADMAP_AND_HANDOFF.md` | `urban-legend-production-pm` | `../../MVP_ROADMAP.md`, `../../TEST_CHECKLIST.md` |
| 벤치마킹 근거 재사용 | `REFERENCE_CASES.md` | `urban-legend-analytics-user-research` | 해당 사례의 원문·최신 1차 출처 |

새 괴이 사건 작성 시 `skills/urban-legend-investigation-case-authoring/SKILL.md`의 `Read first`, 사건 계약, 공정성 검토를 실제 데이터·테스트와 함께 적용한다. Skill은 기획서나 구현 사실을 대신하지 않는다.

## 2. 문서 책임

| 문서 | 책임 | 책임지지 않는 것 |
|---|---|---|
| `PROJECT_DIRECTION.md` | 프로젝트의 약속, 핵심 경험, 불변 조건, 현재와 다음 방향 | 세부 대사·파일별 구현 명세 |
| `NARRATIVE_CONTENT_PLAN.md` | 사건 대사, 일상, 관계, 캐릭터 목소리, 서사 데이터 경계 | 표정 리소스·UI 노드 배치 |
| `ART_PRESENTATION_PLAN.md` | 아트 방향, 화면 위계, 표정·컷인·연출·접근성 | 사건 규칙과 저장 상태 소유 |
| `PROGRESSIVE_DISCLOSURE_PLAN.md` | 준비·조사·결과 정보 우선순위와 기능 비잠금 계약 | 상태·경제·기록 데이터 소유 |
| `ROADMAP_AND_HANDOFF.md` | 단계 의존성, 진입·완료 기준, 인수인계 절차 | 개별 코드 구현 방법 |
| `REFERENCE_CASES.md` | 이미 사용한 사례의 관찰·적용·제외 이유 | 다른 작품의 외형·문구 복제 |
| `GAME_DESIGN_DOCUMENT.md` | 현재 구현 기준의 상세 게임 설계 | 최신 미구현 패키지의 전체 대본 |
| `CURRENT_STATUS.md` | 구현 완료와 승인 계획의 상태 구분 | 장기 설계 상세 |

같은 내용을 여러 문서에 복사하지 않는다. 상위 기획서는 판단 원칙을, 하위 데이터와 구현 문서는 실제 값과 ID를 담당한다.

## 3. 현재 프로젝트 위치

- **구현 완료선:** MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save `mvp-039`
- **현재 승인 계획:** UX-PD-001 2B 조사 → 2C 결과 → MVP-044 → MVP-045 → MVP-046
- **기본 의존 순서:** 정보 위계 → 서사 데이터 → 관계 기억 → 공용 연출
- **예외:** MVP-046의 상태 비소유 공용 대화 스테이지는 기존 서사 데이터를 바꾸지 않는 범위에서 선행 가능

승인 계획과 전달 패키지는 `main` 구현 완료를 의미하지 않는다.

## 4. 기획 판단 우선순위

1. 플레이어가 현재 무엇을 보고 어떤 판단을 하는가
2. 판단 결과가 즉시 어떻게 보이고 무엇이 기록되는가
3. 캐릭터와 세계관의 매력이 행동과 대화로 드러나는가
4. 실패가 다음 판단 근거와 위험 사례를 남기는가
5. 현장 안정화와 공식 매뉴얼 규칙 승격이 구분되는가
6. 기존 저장·진행·사건 ID를 보존하는가
7. 아트·연출이 정보와 감정을 강화하되 상태를 대신 소유하지 않는가
8. 콘텐츠 양보다 한 장면의 목적과 차이를 먼저 검증했는가

## 5. 작업 전 확인 질문

- 이 작업은 현재 구현 수정인가, 승인 계획 구체화인가?
- 플레이어에게 새로 보이는 경험은 무엇인가?
- 기존 사건·저장·DB·입력에 어떤 영향이 있는가?
- 필요한 정보가 어느 책임 원본과 Skill에 있는가?
- 정답은 사건 안의 관찰 가능한 근거로 추론 가능한가?
- 기존 사례를 재사용할 수 있는가, 최신 외부 조사가 필요한가?
- 구현 후 어떤 화면과 기록으로 성공을 확인하는가?

## 6. 업데이트 규칙

- 큰 MVP가 완료되면 `../CURRENT_STATUS.md`, `../../MVP_ROADMAP.md`, `ROADMAP_AND_HANDOFF.md`, `../../TEST_CHECKLIST.md`를 함께 심사한다.
- 캐릭터·세계관·표현 원칙이 바뀌면 `PROJECT_DIRECTION.md`와 `../PROJECT_CONTEXT.md`를 갱신한다.
- 대사·관계 규칙이 바뀌면 `NARRATIVE_CONTENT_PLAN.md`를 갱신한다.
- 아트·표정·컷인·화면 위계가 바뀌면 `ART_PRESENTATION_PLAN.md` 또는 `PROGRESSIVE_DISCLOSURE_PLAN.md`를 갱신한다.
- 사건 규칙·가설·근거·대응·매뉴얼 상태가 바뀌면 GDD, 대상 에피소드 데이터, 관련 계약 테스트를 함께 심사한다.
- 완료된 상세 계획과 과거 버전은 `docs/archive/backup/YYYY-MM-DD/`로 보낸다.
- 사례에서 얻은 재사용 가능한 원칙은 프로젝트 전용 사실을 제거한 뒤 Base 저장소의 canonical knowledge library 승격 후보로 정리한다.

## 점진적 공개·정보 위계

준비·조사·결과 화면의 정보 우선순위와 기능 비잠금 계약은 `PROGRESSIVE_DISCLOSURE_PLAN.md`를 따른다. 현재 완료선은 2A 준비 화면이며, 후속은 2B 조사 → 2C 결과 순서다.
