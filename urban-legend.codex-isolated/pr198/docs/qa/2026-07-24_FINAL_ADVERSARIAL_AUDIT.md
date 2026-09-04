---
title: "도시괴담 기록국 — 최종 적대적 검토 및 MVP 마감 보고서"
author: "OpenAI / 프로젝트 QA 감사"
date: "2026-07-24"
lang: ko-KR
mainfont: "Noto Sans CJK KR"
sansfont: "Noto Sans CJK KR"
monofont: "NanumGothicCoding"
fontsize: 9pt
geometry: margin=17mm
colorlinks: true
linkcolor: blue
urlcolor: blue
toc: true
toc-depth: 2
numbersections: true

---

# 1. 최종 판정

## 판정: `UNVERIFIED`

프로젝트 코어 설계, 책임 원본 정렬, CORE-MVP-001 마일스톤 계약, TDD 구현 계획, GitHub 추적선과 문서 Required Check는 개선·정렬되었다. 그러나 사용자가 지정한 완료 금지 조건 중 다음이 남아 있으므로 **구현 완료·MVP 완료·병합 승인**을 선언하지 않는다.

- 현재 대화의 원문 전체 메시지를 처음부터 끝까지 직접 열람하지 못했다. 접근 가능한 현재 지시, 현재 스레드, 압축된 이전 결정 요약만 검토했다.
- 컨테이너 네트워크 제한으로 PR 브랜치를 로컬 clone/worktree로 만들지 못했다.
- Godot 4.7 headless, 기존 39개 회귀 진입점, 실제 저장·불러오기·장면 렌더를 이번 작업에서 실행하지 못했다.
- CORE-MVP-001 런타임·데이터·Scene·플레이테스트는 아직 구현되지 않았다.
- 신규 플레이어 5~8명의 행동 증거와 사전 선언 지표가 없다.
- PDF는 자동 렌더·preflight를 수행하지만 사용자의 직접 시각 검수는 `NOT_RUN`이다.

따라서 이번 작업의 정확한 의미는 다음과 같다.

> **설계·문서·계약·추적성의 차단 결함은 수정했지만, 프로젝트 구현 및 MVP 완료 여부는 필요한 원문 대화·런타임·플레이 증거가 없어 확정할 수 없다.**

# 2. 작업 목표와 완료 기준

## 목표

1. 최신 사용자 지시와 접근 가능한 대화 결정을 책임 원본에 추적한다.
2. 프로젝트 코어·MVP·구현 사실·미구현 계획을 분리한다.
3. 서로 다른 공격 관점으로 적대적 검토를 5회 수행한다.
4. 검증된 `MUST_FIX`와 현재 범위의 `SHOULD_FIX`만 최소 수정한다.
5. 구형 문서·경로·Skill ID·Schema의 활성 참조를 감사한다.
6. Issue·MVP·PR·문서·검증 결과를 연결한다.
7. 사람용 PDF와 발행 Manifest를 만든다.
8. 필수 미검증이 남으면 완료 선언을 금지한다.

## 완료 기준 판정

| 기준 | 결과 | 비고 |
|---|---|---|
| 프로젝트 코어·지원 시스템 분리 | PASS | `PROJECT_CORE`와 GDD 책임 유지 |
| 활성 운영 문서의 코어 상태 정렬 | PASS | `IDENTIFIED` drift 제거 |
| CORE-MVP-001 정본·계획 책임 분리 | PASS | GDD 전역 정본 / PoC 마일스톤 계약 |
| 고정 ID·상태·인터페이스 일치 | PASS | 자동 계약 추가 |
| UX·접근성 단계 계약 | PASS — 문서 계약 | 실제 렌더는 NOT_RUN |
| Required Check | PASS 필요 | 최종 publication head에서 확인 |
| 전체 원문 대화 검토 | UNVERIFIED | 원문 전체 접근 불가 |
| 로컬 Godot·저장·Scene 회귀 | UNVERIFIED | clone/Godot 환경 미확보 |
| CORE-MVP-001 구현 | NOT IMPLEMENTED | `POC_PENDING` |
| 신규 플레이어 지표 | NOT RUN | `HOLD_UNTIL_PLAYER_EVIDENCE` |
| 사람 PDF 직접 검수 | NOT RUN | 자동 검수와 구분 |

# 3. 검토한 현재 대화 범위

## 접근 가능

- 이번 작업의 상세 지시가 포함된 사용자 첨부 Markdown.
- 현재 스레드의 사용자·어시스턴트 메시지.
- 이전 설계 대화에서 확정된 내용을 보존한 압축 컨텍스트 요약.
- PR #55와 저장소의 실제 활성 파일·diff·workflow 결과.

## 접근 불가 또는 불완전

- 현재 대화가 압축되기 전의 모든 원문 사용자·어시스턴트 메시지.
- 숨겨진 chain-of-thought 또는 외부 계정의 비공개 기록.
- 사용자가 별도로 보유한 로컬 작업 트리와 미푸시 변경.

## 판정

`UNVERIFIED_CONTEXT`: 접근 가능한 결정은 추적했지만 “현재 대화 전체 원문을 처음부터 끝까지 검토했다”고 주장하지 않는다. 이 항목은 사용자가 지정한 완료 선언 금지 조건에 해당한다.

# 4. 대화 결정 원장

| 결정·요구사항 | 대화 상태 | 최신 사용자 의도 | 반영 책임 원본 | 실제 구현·데이터 경로 | 검증 상태 | 필요한 조치 |
|---|---|---|---|---|---|---|
| 권나래 고정 주인공, 교체 없음 | CONFIRMED | 단일 주인공·일정 주체 유지 | `PROJECT_CORE`, GDD | 현행 `game_state.gd`, 요원 데이터 | 현행 구현 보고·테스트 존재 | 보호 |
| 조사 페이즈는 텍스트 노벨형 | LATEST_OVERRIDE | 4개 선택지와 기록 비교 | GDD, CORE-MVP-001 계약 | PoC 신규 경로 예정 | 문서 계약 PASS | PoC 구현 |
| 매뉴얼 기록으로 2개 선택지 논리 배제 | CONFIRMED | 자동 정답이 아닌 직접 연결 | 코어·GDD·PoC 계약 | PoC state 예정 | 계약 테스트 PASS | 구현·행동 검증 |
| 남은 2개는 경쟁 가설 | CONFIRMED | 현장 검증이 필요한 합리적 가설 | GDD·PoC 계약 | PoC JSON 예정 | 계약 PASS | 콘텐츠 작성 |
| 오답은 정답 공개 없이 반응 단서·위험 사례 생성 | CONFIRMED | 실패가 정보가 됨 | 코어·GDD·PoC 계약 | PoC state 예정 | 계약 PASS | 구현 |
| 실패 뒤 기존 1 + 변형 1로 부분 갱신 | CONFIRMED | 같은 4지선다 반복 금지 | GDD·PoC 계약 | PoC state 예정 | 계약 PASS | 구현 |
| 위험 최대에서 긴급 회수 | CONFIRMED | 추가 조사 차단·불리한 폴백 | GDD·PoC 계약 | PoC state 예정 | 계약 PASS | 구현 |
| 회수는 턴제 패턴 대응 전투 | LATEST_OVERRIDE | 비전투 정체성을 대체, 일반 화력전은 금지 | `PROJECT_CORE`, GDD | PoC 예정 | 문서 정렬 PASS | 플레이 검증 |
| 조사 이해가 전조 정보 우위로 변환 | CONFIRMED | 공격력 보너스가 아님 | 코어·GDD·PoC 계약 | PoC state 예정 | 계약 PASS | 구현·지표 측정 |
| 이해도 4단계 | CONFIRMED | 미확인→단서 확보→유력→이해 | GDD·PoC 계약 | PoC state 예정 | 경계 계약 PASS | 구현 |
| 전조 실패는 정보 없음, 거짓 정보 금지 | CONFIRMED | `놈은 무언가 하려 한다.` | 코어·PoC 계약 | PoC state 예정 | 계약 PASS | 구현 |
| 미관측 첫 패턴은 비공개지만 범용 방어 가능 | CONFIRMED | 즉사·강제 중상·영구 실패 금지 | 코어·PoC 계약 | PoC state 예정 | 피해 상한·HP 최저 계약 PASS | 구현·QA |
| 다른 괴이로 지식 자동 전이 | REJECTED | 괴이별 독립 지식 | 코어·GDD | 미구현 | 금지선 PASS | 유지 |
| 영구 매뉴얼과 현재 출현 이해도 분리 | CONFIRMED | 재출현 때 현장 이해 재구축 | GDD·CORE_SUPPORT | CORE-MVP-002 | DEFERRED | 001 통과 뒤 |
| 포획·연구·히든 분기 | DEFERRED | 유효한 지원 시스템, 최소 코어 아님 | `CORE_SUPPORT`, GDD | CORE-MVP-002/004 | NOT IMPLEMENTED | POC 뒤 승인 |
| 히든 결과는 항상 상위 정답이 아님 | CONFIRMED | 희망적일 수 있으나 기관 평가·자원 trade-off | 코어·GDD | CORE-MVP-004 | DEFERRED | 유지 |
| 기간제 챕터·마감 | CONFIRMED / DEFERRED | 시간 압박은 지원 시스템 | GDD·로드맵 | CORE-MVP-003 | NOT IMPLEMENTED | 002 뒤 |
| 결과 등급 3축 | CONFIRMED / DEFERRED | 회수 품질·피해·지식 품질 | GDD | CORE-MVP-002 | NOT IMPLEMENTED | 001 뒤 |
| 핵심 추리 난수화 금지 | CONFIRMED | 확률은 관측 패턴 정보 해석만 | 코어·GDD·PoC 계약 | PoC state 예정 | 계약 PASS | 구현 |
| 플레이어 작성형 가설 카드 | CONFIRMED | 규칙·지지·반박·미해결·검증·상태 | 코어·GDD·PoC 계약 | PoC UI/state 예정 | 계약 PASS | 구현·저작감 측정 |
| UX-PD-001 2B·2C와 MVP-044~046 | DEFERRED | CORE-MVP-001 증거 뒤 재매핑 | 점진 공개 기획·로드맵 | 미구현 | `DEFERRED_FOR_REMAP` | 선구현 금지 |
| 신규 플레이어 행동 증거 전 제작 확대 금지 | CONFIRMED | Production gate 유지 | 코어·상태·로드맵 | N/A | PASS | 유지 |
| 최종 적대적 검토 5회·PDF·PR 마감 | CONFIRMED | 증거 부족 시 완료 선언 금지 | 이번 QA 보고서 | 문서·GitHub | 부분 PASS | 최종 판정 UNVERIFIED |

# 5. 프로젝트 코어와 보호 대상

## 프로젝트 코어

> 권나래가 관측 가능한 단서로 괴이의 규칙 가설을 만들고, 위험을 감수한 검증으로 이해를 갱신한 뒤, 그 이해로 턴제 회수 전투의 전조를 읽어 포획 조건을 열고, 성공과 실패를 다음 출현의 괴이 매뉴얼로 기록한다.

## 보호 대상

- `관측 → 가설 → 위험 검증 → 전조 → 패턴 대응 → 포획 → 매뉴얼` 인과.
- 핵심 정답의 결정론적 근거 계약.
- 실패가 위험 사례와 다음 판단 근거를 남기는 구조.
- 권나래 고정 주인공과 단일 일정 주체.
- 괴이를 HP 0으로 처치하지 않는 회수·안정화·잔향 개념.
- 현행 세 사건, 저장 `mvp-039`, `mvp-038` 이관, 기존 ID.
- 보호 경로: `scripts/core/game_state.gd`, `data/episodes/**`, 기존 조사·회수 장면, `project.godot`, `knowledge/base-pack/**`.

# 6. 확인한 책임 원본과 실제 파일

| 책임 | 확인한 파일 | 판정 |
|---|---|---|
| 강제 규칙 | `AGENTS.md` | CURRENT_CANONICAL |
| 콜드 스타트 | `START_HERE.md` | CURRENT_CANONICAL |
| Base pin | `docs/BASE_RULES_VERSION.md` | CURRENT_CANONICAL / drift 수정 |
| 문서 라우팅 | `docs/DOCUMENTATION_MAP.md` | CURRENT_CANONICAL / 마일스톤 등록 |
| 운영 모델 | `docs/OPERATING_MODEL.md` | CURRENT_CANONICAL / drift 수정 |
| 구현 사실 | `docs/CURRENT_STATUS.md` | CURRENT_CANONICAL |
| 최소 코어 | `docs/PROJECT_CORE.md` | CURRENT_CANONICAL |
| 전체 상세 설계 | `docs/GAME_DESIGN_DOCUMENT.md` | CURRENT_CANONICAL |
| CORE-MVP-001 고정 계약 | `docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md` | ACTIVE_MILESTONE_CONTRACT |
| CORE-MVP-001 TDD 계획 | `docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md` | ACTIVE_MILESTONE_PLAN |
| 구현 순서 | `MVP_ROADMAP.md` | CURRENT_CANONICAL / Issue #56 연결 |
| 검증 | `TEST_CHECKLIST.md` | CURRENT_CANONICAL |
| Skill 라우팅 | `skills/SKILL_REGISTRY.json`, `BASE_SKILL_INDEX.json` | CURRENT_CANONICAL |
| 자동 계약 | `tests/test_base_operating_sync.py`, `test_active_document_references.py` | ACTIVE_TEST |
| Required Check | `.github/workflows/validate-base-operating-sync.yml` | ACTIVE_CI |
| 실행 추적 | GitHub Issue #56 | ACTIVE_TRACKER |
| 설계 PR | Draft PR #55 | ACTIVE_PR |

# 7. 적대적 검토 1차 결과 — 대화·요구사항·책임 범위

## 공격

- 승인한 코어와 운영 문서 상태가 일치하는가.
- README가 최신 활성 작업으로 안내하는가.
- 구현 사실과 미래 계획을 혼합하는가.
- 전체 대화 원문을 실제로 검토할 수 있는가.

## Finding

```yaml
finding_id: F-001
review_round: 1
problem: 전체 대화 원문에 직접 접근할 수 없음
violated_requirement_or_core: 전체 대화 처음부터 끝까지 검토
why_it_matters: 누락된 최신 override를 확정적으로 배제할 수 없음
failure_scenario: 압축 요약에서 생략된 거부·보류 결정을 완료로 오판
severity: HIGH
confidence: 1.0
suggested_direction: UNVERIFIED_CONTEXT로 유지, 완료 선언 금지
판정: UNVERIFIED
```

```yaml
finding_id: F-002
review_round: 1
problem: BASE_RULES_VERSION·OPERATING_MODEL이 코어를 IDENTIFIED로 주장
violated_requirement_or_core: 최신 사용자 승인 CORE_RECORDED
why_it_matters: 새 작업자가 승인 전 단계로 오인
failure_scenario: 재승인 질문 또는 이전 코어 절차로 회귀
severity: HIGH
confidence: 1.0
suggested_direction: PROJECT_CORE를 단일 상태 권한으로 연결
판정: MUST_FIX → FIXED
```

```yaml
finding_id: F-003
review_round: 1
problem: README가 UX-PD-001 2B·2C와 MVP-044~046을 현재 작업으로 안내
violated_requirement_or_core: CORE-MVP-001 단일 활성 트랙
why_it_matters: 코어 증거 전 지원 시스템 확장
failure_scenario: 조사-전투 인과 미검증 상태에서 UI·서사 제작 확대
severity: HIGH
confidence: 1.0
suggested_direction: README를 CORE-MVP-001로 재라우팅
판정: MUST_FIX → FIXED
```

## 수정 결과

- 코어 상태 권한을 `PROJECT_CORE.md`로 단일화.
- README의 현재 계획과 남은 작업을 CORE-MVP-001로 교정.
- UX-PD-001 2B·2C와 MVP-044~046은 재매핑 대기로 표시.

# 8. 적대적 검토 2차 결과 — 논리·모순·판정 가능성

## Finding

```yaml
finding_id: F-004
review_round: 2
problem: 통합 명세가 프로젝트 전체 상세 설계 책임을 주장해 GDD와 중복
violated_requirement_or_core: 하나의 책임은 하나의 정본
why_it_matters: 서로 다른 문서가 같은 규칙을 독립 수정할 수 있음
failure_scenario: GDD와 PoC 명세가 서로 다른 이해도·UI 계약을 소유
severity: HIGH
confidence: 1.0
suggested_direction: GDD는 전역 정본, 통합 명세는 CORE-MVP-001 마일스톤 계약
판정: MUST_FIX → FIXED
```

```yaml
finding_id: F-005
review_round: 2
problem: PROJECT_CORE가 현재 spec·plan 대신 과거 승인·재기준화 문서만 연결
violated_requirement_or_core: 최신 실행 진입점
why_it_matters: 구현자가 오래된 계획으로 이동
severity: HIGH
confidence: 0.98
suggested_direction: 현재 마일스톤 계약·TDD 계획을 연결하고 과거 문서는 이력화
판정: MUST_FIX → FIXED
```

```yaml
finding_id: F-006
review_round: 2
problem: 점진 공개 2B·2C의 게이트 대기 상태가 불명확
violated_requirement_or_core: 플레이 증거 전 지원 시스템 확대 금지
why_it_matters: 유효한 과거 계획이 활성 순서로 오해됨
severity: MEDIUM
confidence: 0.95
suggested_direction: DEFERRED_FOR_REMAP 명시
판정: SHOULD_FIX → FIXED
```

# 9. 적대적 검토 3차 결과 — 경계 조건·데이터·호환성

## Finding

```yaml
finding_id: F-007
review_round: 3
problem: spec과 plan의 Scene 클래스·고정 ID·상태 enum·start 반환형 불일치
violated_requirement_or_core: 구현 가능하고 판정 가능한 단일 데이터 계약
why_it_matters: fixture·state·scene이 서로 다른 API를 구현할 수 있음
failure_scenario: 테스트는 CoreMvp001Controller를 찾고 Scene은 CoreMvp001Scene을 제공
severity: CRITICAL
confidence: 1.0
suggested_direction: exact ID·public state·Dictionary 응답을 하나로 고정
판정: MUST_FIX → FIXED
```

## 반영

- Scene 클래스: `CoreMvp001Scene`.
- 공개 상태 15개 고정.
- `INVESTIGATION_SITUATION`은 UI 도입 단계, `RESPONSE_RESOLUTION`은 명령 내부 원자 전이.
- `start(case_data, run_seed) -> Dictionary`.
- scene/clue/question/manual/choice/hypothesis/pattern/action ID 단일화.
- 고정 5턴 순서, 미관측 패턴 3·5턴, 포획 표식 3개.
- 첫 미관측 피해 상한 18, 체력 최저 1.
- 기존 저장·세 사건 비침범과 롤백 경로 명시.

# 10. 적대적 검토 4차 결과 — 플레이어 경험·UX·접근성

## Finding

```yaml
finding_id: F-008
review_round: 4
problem: 단일 Scene 노드 목록만으로 모든 단계 패널 동시 노출 가능
violated_requirement_or_core: 핵심 질문·근거·대응 우선 정보 위계
why_it_matters: 720p에서 선택과 피드백이 화면 아래로 밀림
failure_scenario: 조사·가설·회수·결과 패널이 동시에 포커스를 점유
severity: MEDIUM
confidence: 0.9
suggested_direction: 현재 단계 패널만 표시, 고정 Footer, 단계별 ScrollContainer, 포커스 복구
판정: SHOULD_FIX → FIXED IN CONTRACT
```

## 반영한 UX 계약

- 현재 단계 패널만 표시.
- Footer 고정.
- 720p 넘침은 현재 단계 내부 ScrollContainer만 사용.
- 단계 진입·뒤로가기 뒤 첫 유효 컨트롤로 포커스 복구.
- Esc 뒤 선택 근거·가설 보존.
- 색상·음향 단독 전달 금지.
- 시간 제한 없음.
- 마우스·키보드 동등 지원.

실제 720p/1080p Scene 렌더는 PoC가 없으므로 `NOT_RUN`이다.

# 11. 적대적 검토 5차 결과 — GitHub 최신성·통합 회귀·PR

## Finding

```yaml
finding_id: F-009
review_round: 5
problem: 실패한 Required Check의 실제 unittest 원문이 기본 로그 응답에서 잘림
violated_requirement_or_core: Red 증거 보존·실패 원인 독립 검증
why_it_matters: 실패를 추측해 잘못된 문서를 수정할 위험
severity: MEDIUM
confidence: 1.0
suggested_direction: unittest 로그와 exit code를 workflow artifact로 보존
판정: SHOULD_FIX → FIXED
```

```yaml
finding_id: F-010
review_round: 5
problem: CORE-MVP-001 전용 Issue·Goal 추적자가 없음
violated_requirement_or_core: Issue·Goal·MVP·PR 연결
why_it_matters: 구현 시작·비목표·게이트의 GitHub 추적성 부족
severity: MEDIUM
confidence: 0.95
suggested_direction: 승인 범위만 담은 추적 Issue 생성
판정: SHOULD_FIX → FIXED — Issue #56
```

```yaml
finding_id: F-011
review_round: 5
problem: 로컬 clone·worktree·Godot 실행 환경 미확보
violated_requirement_or_core: 실제 코드·데이터·씬·저장·런타임 검증
why_it_matters: 문서·Python 계약만으로 런타임 회귀를 확정할 수 없음
severity: HIGH
confidence: 1.0
suggested_direction: 구현 세션에서 공식 Godot 명령과 39개 회귀 실행
판정: UNVERIFIED
```

```yaml
finding_id: F-012
review_round: 5
problem: CORE-MVP-001 및 플레이어 행동 증거 없음
violated_requirement_or_core: Production gate
why_it_matters: 중심 재미와 공정성이 문서 주장에 머무름
severity: CRITICAL
confidence: 1.0
suggested_direction: Issue #56의 TDD 구현·QA·5~8명 테스트 수행
판정: UNVERIFIED / POC_PENDING
```

# 12. MUST_FIX / SHOULD_FIX / DEFER / REJECT / UNVERIFIED

| 판정 | Finding | 현재 상태 |
|---|---|---|
| MUST_FIX | F-002 운영 상태 drift | FIXED |
| MUST_FIX | F-003 README 활성 트랙 drift | FIXED |
| MUST_FIX | F-004 GDD와 마일스톤 명세 책임 중복 | FIXED |
| MUST_FIX | F-005 PROJECT_CORE의 과거 실행 링크 | FIXED |
| MUST_FIX | F-007 고정 ID·상태·API 불일치 | FIXED |
| SHOULD_FIX | F-006 점진 공개 후속 게이트 불명확 | FIXED |
| SHOULD_FIX | F-008 단계별 UX·포커스 계약 | FIXED IN CONTRACT |
| SHOULD_FIX | F-009 CI 실패 증거 보존 | FIXED |
| SHOULD_FIX | F-010 Issue 추적성 | FIXED |
| DEFER | UX-PD-001 2B·2C, MVP-044~046 | CORE-MVP-001 뒤 재매핑 |
| DEFER | Base v3 전역 PDF Registry 이주 | 별도 승인 필요 |
| REJECT | compatibility redirect·legacy alias 즉시 삭제 | 활성 호환 역할이 있어 삭제 근거 없음 |
| REJECT | Documentation Map의 docs-relative 경로를 repo-root 문자열로 강제 | 테스트의 잘못된 전제; 테스트 수정 |
| UNVERIFIED | F-001 원문 전체 대화 | 미해결 |
| UNVERIFIED | F-011 로컬 Godot·저장·Scene 회귀 | 미실행 |
| UNVERIFIED | F-012 PoC·플레이 지표 | 미구현·미실행 |
| UNVERIFIED | 사용자 직접 PDF 시각 검수 | NOT_RUN |

# 13. 실제 반영한 최소 변경

- `BASE_RULES_VERSION`, `OPERATING_MODEL`: 코어 상태 권한을 PROJECT_CORE로 일원화.
- `README`: 활성 트랙을 CORE-MVP-001로 교정.
- `DOCUMENTATION_MAP`: GDD 전역 정본과 CORE-MVP-001 마일스톤 계약의 책임 분리.
- `PROJECT_CORE`: 현재 spec·plan 링크와 과거 이력 분리.
- `PROGRESSIVE_DISCLOSURE_PLAN`: 2B·2C·2D를 `DEFERRED_FOR_REMAP`으로 표시.
- CORE-MVP-001 spec·plan: 고정 ID·상태·함수·회수·UX 계약 단일화.
- `TEST_CHECKLIST`: 단계별 UI·접근성·최신성 게이트 추가.
- 자동 계약 테스트: 운영 상태·활성 트랙·PoC 계약 drift 검출.
- workflow: unittest 로그·exit code artifact 보존, `docs/qa/**` publication head 검증.
- Issue #56 생성, MVP 로드맵·현재 상태 연결.
- 게임 런타임·사건 데이터·Scene·저장 Schema는 수정하지 않음.

# 14. Red → Green → Refactor 증거

| 단계 | 증거 | 결과 |
|---|---|---|
| Red 1 | `tests/test_base_operating_sync.py`에 stale 상태·README route 검사 추가 | Required Check run #121 실패 |
| Green 1 | Base 경계·운영 모델·README 수정 | 상태·활성 트랙 정렬 |
| Red 2/3/4 | `test_active_document_references.py`에 정본·ID·상태·UX 계약 추가 | 실패 artifact로 2개 원인 확보 |
| Validate critique | docs-relative 경로 강제는 잘못된 테스트 전제 | REJECT, 테스트 교정 |
| Green 2/3/4 | Documentation Map·PROJECT_CORE·spec·plan·checklist 정렬 | Required Check run #134 성공 |
| Refactor | 프로젝트 전체 상세 설계를 GDD에 유지하고 PoC 명세를 마일스톤 계약으로 축소 | 중복 책임 제거 |
| Evidence hardening | workflow artifact에 unittest 로그·exit code 저장 | 실패 원인 재현 가능 |
| Regression | latest active docs contract workflow | publication head PASS 필수 |

# 15. GitHub 최신성·구형 참조 감사

| 파일·참조 | 현재 역할 | 최신 정본 | 구형 여부 | 활성 소비자 | 필요한 조치 | 결과 |
|---|---|---|---|---|---|---|
| `docs/PROJECT_CORE.md` | 최소 코어 | 자기 자신 | 아님 | 운영·상태·로드맵 | 유지 | CURRENT_CANONICAL |
| GDD | 전체 상세 설계 | 자기 자신 | 아님 | 기획·UI·콘텐츠 | 유지 | CURRENT_CANONICAL |
| CORE-MVP-001 spec | PoC 고정 계약 | GDD·코어 하위 | 활성 조건부 | Issue·로드맵·계획 | 001 기간만 사용 | ACTIVE_MILESTONE |
| CORE-MVP-001 plan | TDD 실행 순서 | spec 하위 | 활성 조건부 | Issue·로드맵 | 구현 후 이력화 | ACTIVE_MILESTONE |
| `DESIGN_INTENT.md` | 위치 안내 | GDD·PROJECT_CONTEXT | 구형 본문 없음 | 기존 외부 링크 | 삭제 금지 | ACTIVE_COMPATIBILITY |
| `PROJECT_BRIEF.md` | 위치 안내 | CURRENT_STATUS·GDD | 구형 본문 없음 | 기존 외부 링크 | 삭제 금지 | ACTIVE_COMPATIBILITY |
| `CONTENT_DIRECTION_V09.md` | 위치 안내 | GDD·PROJECT_CONTEXT | v0.9 이력 | 기존 링크 | 삭제 금지 | ACTIVE_COMPATIBILITY |
| `LEGACY_SKILL_ALIASES.md` | 폐기 Skill ID 호환 | Registry | alias만 유지 | 운영 검사 | Registry에 넣지 않음 | ACTIVE_COMPATIBILITY |
| `docs/archive/**` | 과거 증거 | archive index | 역사 자료 | 필요 시 하나 선택 | 활성 참조 금지 | HISTORICAL_ARCHIVE |
| 이전 finalization/rebase superpowers 문서 | 승인·재기준화 이력 | 현재 spec·plan | 과거 | PROJECT_CORE 이력 섹션 | 기본 실행 금지 | HISTORICAL_HISTORY |
| UX-PD-001 2B·2C | 후속 설계 후보 | progressive plan | 미구현 | 로드맵 | 001 뒤 재매핑 | DEFERRED |
| `mvp-039` | 현행 저장 Schema | game state·상태 문서 | 아님 | 코드·테스트 | 유지 | CURRENT_CANONICAL |

## 삭제 후보

감사한 범위에서 즉시 삭제할 `REMOVAL_CANDIDATE`는 판정하지 않았다. 리디렉션·alias는 고유한 호환 역할이 있고 archive는 역사 증거다.

# 16. 책임 원본·Registry·Documentation Map 동기화

- GDD: 프로젝트 전체 상세 설계.
- PROJECT_CORE: 최소 정체성과 재승인 경계.
- CURRENT_STATUS: 구현 사실·미구현·검증 상태.
- CORE-MVP-001 spec: PoC 고정 ID·상태·UI·수용 계약.
- CORE-MVP-001 plan: 파일·TDD·QA·커밋 순서.
- MVP_ROADMAP: Issue #56과 단계 게이트.
- Skill Registry: 10개 프로젝트 discipline + 1개 local skill.
- Legacy Skill ID: Registry가 아니라 compatibility alias에만 유지.
- Base pin: 단일 사람용 원본과 기계 Registry/Index가 동일 commit/blob을 사용.

# 17. 정적·런타임·회귀 검증 결과

| 검증 | 결과 | 증거·한계 |
|---|---|---|
| Base/core/routing Python 계약 | PASS on latest publication head required | GitHub Actions Required Check |
| Red 상태 재현 | PASS | run #121 failure |
| 실패 원문 보존 | PASS | workflow artifact log·exit code |
| 활성 문서 경로·구형 QA/Goal 참조 | PASS in CI | `test_active_document_references.py` |
| Base Skill package integrity | PASS in CI | workflow 명령 포함 |
| tracked generated/bootstrap file 금지 | PASS in CI | `git ls-files` 계약 |
| main 대비 diff·보호 경로 | PASS for document-only audit changes | compare API; runtime protected paths 없음 |
| `git diff --check` 로컬 | NOT RUN | 로컬 checkout 없음 |
| 전체 Python discover | NOT RUN | workflow는 공식 3개 계약만 실행 |
| GDD DOCX build/check | NOT APPLICABLE TO AUDIT FIXES | 이번 5회 수정에서 GDD 미변경; PR 전체에는 이전 GDD 변경 존재 |
| Godot 4.7 parse/load | NOT RUN | 로컬 Godot/checkout 없음 |
| 기존 Godot regression 39개 | NOT RUN | 런타임 변경 없음; 그래도 PASS로 간주하지 않음 |
| 저장·불러오기·Scene smoke | NOT RUN | PoC 미구현 |
| 신규 플레이어 5~8명 | NOT RUN | PoC 미구현 |

# 18. PDF·Manifest·전 페이지 렌더 결과

- 책임 원본: 이 Markdown QA 보고서.
- PDF: 사람용 파생본이며 프로젝트 정본을 대체하지 않는다.
- 생성 방식: Pandoc → XeLaTeX, Noto Sans CJK KR, A3 가로형.
- DOCX: Pandoc 파생본.
- 자동 검사: PDF page count, 텍스트 추출, 11페이지 PNG 전면 렌더, 빈 페이지·한글 깨짐·표·문단 clipping 여부 점검. 결과 PASS.
- `human_visual_review`: `NOT_RUN` — 사용자가 직접 열어 확인하지 않음.
- source·PDF SHA-256과 page count는 publication Manifest가 소유한다.

# 19. PR 및 Required Check 결과

- PR: Draft PR #55.
- 목적: 프로젝트 코어 확정 문서와 CORE-MVP-001 계약·계획·최종 감사.
- 실행 추적: Issue #56.
- mergeability: GitHub API로 확인.
- review thread: 최종 조회에서 unresolved 0이어야 한다.
- Required Check: 최종 publication head에서 PASS여야 한다.
- PR은 draft로 유지한다.
- 최종 판정은 `UNVERIFIED`; `ACCEPT_WITH_FOLLOWUP`으로 승격하지 않는다.
- 병합 전 사용자가 확인할 사항은 24절에 기록한다.

# 20. 커밋 목록과 각 커밋 목적

| 커밋 | 목적 |
|---|---|
| `0e0a8cdc` | 5회 최종 감사 구현 계획 |
| `9e932b2b` | stale 코어 상태·활성 트랙 Red 계약 |
| `c9cecb6b` | Base 경계와 최신 코어 상태 정렬 |
| `82f7fd38` | 운영 모델의 코어 권한 정렬 |
| `8024d0ea` | README를 CORE-MVP-001로 재라우팅 |
| `722add16` | 정본·PoC 계약 Red 검사 |
| `80a2567a` | Documentation Map 마일스톤 책임 등록 |
| `cf1d68c8` | PROJECT_CORE의 현재 spec·plan 연결 |
| `7c25165a` | 점진 공개 후속을 재매핑 대기로 전환 |
| `60badf7e` | CORE-MVP-001 고정 마일스톤 계약 정렬 |
| `b27df7b9` | 13개 TDD 구현 계획 정렬 |
| `d6c6f67a` | 단계별 UX·접근성 검증 게이트 |
| `59760ee8` | CI 실패 unittest artifact 보존 |
| `c21c392b` | docs-relative 경로를 존중하는 테스트 수정 |
| `579b7367` | 미래 QA 경로를 활성 링크에서 제거 |
| `ebbb5d05` | 모든 QA publication을 Required Check 대상으로 설정 |
| `2fa6f75d` | MVP 로드맵에 Issue #56·PR #55 연결 |
| `4916632e` | CURRENT_STATUS에 최종 UNVERIFIED 상태 기록 |

각 GitHub contents API 수정은 원격 브랜치에 독립 commit으로 생성되었다. 로컬 push 명령은 네트워크 제한으로 사용하지 않았으며, 원격 head 일치는 GitHub PR API로 확인한다.

# 21. MVP 파일 갱신 결과

- `MVP_ROADMAP.md`에 Issue #56 / Draft PR #55 연결.
- 활성 트랙은 CORE-MVP-001 하나.
- 현 구현 완료선과 PoC 미구현 목표 분리.
- CORE-MVP-002~004 진입 조건 유지.
- UX-PD-001 2B·2C와 MVP-044~046은 재매핑 대기.
- 자동 테스트만으로 `POC_PASSED` 선언 금지.

# 22. 원격 푸시 결과

- 수정은 GitHub contents API를 통해 PR branch에 직접 commit되므로 각 성공 응답이 원격 반영 증거다.
- 로컬 `git push`는 수행하지 않았다.
- 최종 remote PR head SHA와 latest Required Check를 별도로 확인한다.
- 푸시 실패 응답은 발생하지 않았다.

# 23. 남은 위험·미검증·후속 작업

## 차단 미검증

1. 전체 대화 원문.
2. 로컬 Godot 4.7 parse/load.
3. 기존 39개 Godot 회귀.
4. PoC 구현·저장 비침범 실제 증거.
5. 720p/1080p 실제 UI·키보드·Esc 검수.
6. 신규 플레이어 5~8명 행동·인터뷰 지표.
7. 사용자의 직접 PDF 시각 검수.

## 후속 작업

- Issue #56에 따라 CORE-MVP-001을 TDD로 구현.
- 자동 테스트 + 수동 QA 후 `POC_BUILD_READY`까지만 선언.
- 신규 플레이어 지표에 따라 `POC_PASSED / RETEST_REQUIRED / HOLD` 판정.
- 통과 뒤에만 CORE-MVP-002 및 보류 자산 재매핑.

# 24. 사람이 직접 확인할 체크리스트

- [ ] PR #55의 Files changed에서 보호 경로가 변경되지 않았는가.
- [ ] `PROJECT_CORE`, GDD, CORE-MVP-001 spec의 책임 설명이 납득 가능한가.
- [ ] Issue #56의 포함·비목표·지표가 최신 의도와 일치하는가.
- [ ] PDF의 모든 페이지를 직접 열어 한글·표·문단 잘림을 확인했는가.
- [ ] `UNVERIFIED` 판정을 `MVP 완료`로 오해하지 않았는가.
- [ ] 구현 시작 전에 로컬 Godot와 저장 백업 환경을 준비했는가.
- [ ] 신규 플레이어 테스트 전 성공 기준을 변경하지 않았는가.
- [ ] CORE-MVP-001 통과 전 지원 시스템을 선구현하지 않는가.

# 25. Base 공용 규칙 승격 후보

다음은 프로젝트 고유 명칭을 제거하면 다른 프로젝트에도 재사용할 수 있다.

1. **활성 문서 상태 drift 계약**  
   코어 상태를 여러 운영 문서에 복제하지 않고 단일 권한으로 연결하며, stale 상태 문구를 CI에서 검출한다.
2. **마일스톤 계약과 전역 GDD 분리**  
   전역 정본을 유지하면서 구현 직전 exact ID·state·API를 조건부 계약으로 고정한다.
3. **실패 CI 증거 artifact**  
   unittest 로그와 exit code를 항상 보존해 truncated UI 로그에 의존하지 않는다.
4. **미래 QA 경로 비활성화**  
   아직 생성되지 않은 완료 QA 파일을 활성 계획이 링크하지 않고 symbolic output으로 표현한다.
5. **검토 비판 검증**  
   높은 심각도의 지적이라도 잘못된 path 기준처럼 전제가 틀리면 `REJECT`하고 테스트를 수정한다.

승격은 별도 Base proposal 승인 대상이며 이번 프로젝트 PR에 Base 변경을 포함하지 않는다.

# 26. 프로젝트 전용으로 유지할 내용

- 권나래와 괴이 기록국 세계관.
- 안정화 상태·위험 사례·잔향·괴이 매뉴얼·기록관 아카 용어.
- 저승역 PoC의 단서·가설·패턴·고정 ID.
- 미관측 패턴 피해 상한 18, 고정 5턴, 포획 표식 이름.
- 저장 `mvp-039`, 기존 사건·Scene·에셋 경로.
- CORE-MVP-001~004 단계와 사용자 연구 지표.
- Issue #56·PR #55의 실제 프로젝트 상태.

---

## 결론

문서·책임 원본·PoC 계약·GitHub 추적선의 검증된 결함은 최소 수정되었다. 그러나 사용자가 정한 완료 금지 조건을 충족하지 못하는 `UNVERIFIED_CONTEXT`, 런타임 미실행, PoC 미구현, 플레이 증거 부재가 남아 있다.

> **최종 판정은 `UNVERIFIED`다. 프로젝트 코어는 기록·보호되지만, 구현 완료 또는 MVP 완료는 선언하지 않는다.**
