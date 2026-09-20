# Project Skill Learning Log

> Registry: `skills/SKILL_REGISTRY.json` | Base 버전: `docs/BASE_RULES_VERSION.md`

실패·중요 결정·재사용 가능한 교훈·실제 검증 결과만 기록한다. 단순 호출과 미실행 검사는 학습으로 남기지 않는다.

## 2026-07-21 — Base 비파괴 동기화

- 결과: 기존 책임 원본·게임 파일을 유지하면서 Work Mode·자동 라우팅·프로젝트 실행 Skill 10개·경로 어댑터·CI를 연결했다.
- 교훈: 기존 프로젝트에는 신규 설치형 대규모 이동보다 UPDATE_IN_PLACE·호환 Stub·명시적 경로 어댑터가 우선이다.
- 상태: `PATTERN`.

## 2026-07-22 — 최신 Base 25개 동기화·기능 보존 최적화

- Work Mode: `PLAN → BUILD → REVIEW`.
- 사용 Skill: `identifying-project-core`, `evolving-project-discipline-skills`, `pruning-stale-and-nonfunctional-material`, `simplifying-skill-bodies`, `refactoring-with-contract-preservation`, `running-adversarial-review-and-refinement`, `reviewing-and-validating-project-changes`, `auditing-canonical-reference-freshness`.
- 입력: 최신 Base, PR #46, 프로젝트 Skill 10개, 진입 문서·테스트·PR 스택.
- 발견: Base pin 13→25 drift, 커밋 값 다중 복제, Base metadata와 프로젝트 계약의 Registry 혼합, 분야 Skill 10개의 공통 계약 반복, 프로젝트 코어 부재.
- 수행: Base 라우팅 인덱스·18책임 Coverage 분리, 단일 버전 원본, `PROJECT_CORE` IDENTIFIED, 분야 공통 계약 추출, 10개 본문 compact router화, no-loss·routing·reference·CI 검증 강화.
- 보호: 10개 분야 고유 mode·책임 원본·완료·실패 조건, 기존 저장·ID·게임 파일, GDD→DOCX 계약.
- 적대적 판정: 기능을 줄이는 Skill 합병은 `REJECT`; 공통 구조 추출과 stale pin 제거는 `MUST_FIX`; PDF·Manifest 이주는 `DEFER`.
- 지식 상태: 새 Base Skill의 프로젝트 반복 사용 전까지 `HYPOTHESIS`; 구조·테스트 통과는 이번 적용의 `OBSERVATION`.

## 2026-09-20 — 경량 read order와 재미 검증의 선택 적용

- 승인: 기존 운영 개선 승인 + Base #885 재미 검증 추가 요청. `PLAN → BUILD → REVIEW`, intake/operating-system/simplifying-skill-bodies를 사용하고 skill-creator·writing-skills의 고유 기능 보존·행동 시나리오 검사를 적용했다. 새 Skill/서버·게임 변경·설치 설정 변경은 없다.
- source_and_evidence: 프로젝트 main `c82291101bf0a2bb4d821a12bca9f14070ee2886`의 AGENTS/시작 문서/10개 분야 Skill/실제 consumer 및 Base #883·#885 원문. exact 원문과 hash는 정본 adapter에 기록했다. `benchmark_preflight_state: VERIFIED`.
- observed_pattern / project_fit_and_difference: 중복 read order·과거 ledger의 필수 읽기·최소 5회 검토·분량 상한이 current 결정과 충돌했다. 게임 규칙이 아닌 실행 방법만 `ADAPT`; 기존 released package·Registry·고유 domain mode는 `ADOPT/REUSE`.
- 대안 비교: 현상 유지는 drift와 반복 비용이 남아 `REJECT`; Base 전체 최신으로 교체는 release/검증·게임 호환 영향이 커 `REJECT`; 승인된 #883/#885 방법만 기존 owner에 연결하는 선택 적용은 rollback이 작고 장기 유지에 적합해 `ADAPT`. 다음 policy 갱신이나 실제 라우팅 실패 때 재검토한다.
- 검토 1: 전체 diff 자체 검토에서 동결 index 수정, 상세 책임 경로 누락, 중복 Gate 값, 신규 블록의 잘못된 위치를 교정했다. 길이 상한 대신 의미·mode·참조 보존을 검사한다.
- 검토 2 + 독립 검토: read-only reviewer가 전체 diff/보호 경로/5개 source hash와 4개 압박 시나리오를 확인했다. 신규 blocking finding 0, 집중 41개와 운영 13개 PASS. 이는 에이전트의 모든 미래 행동이나 사람의 재미를 보증하지 않는다.
- 회귀: Python 509개 중 508 PASS / 기존 main headless helper 1 FAIL. Windows read-order 검사 PASS, 운영 계약 및 생성물 검사 PASS. CI와 동일한 과거 validator도 직접 실행했다. Windows CRLF 때문에 생성 router 1건이 처음 실패해 해당 경로만 LF로 고정한 뒤 PASS.
- 환경 한계: skill-creator의 보조 quick_validate는 기존 Python 환경에 PyYAML이 없어 실행 실패했다. 설치·전역 변경은 하지 않았다. 프로젝트 자체의 Skill frontmatter/mode/reference/보존 검사와 독립 문서 검토는 통과했으며 보조 검사 통과로 바꾸어 기록하지 않는다.
- reuse handoff: `reuse_mode: ADAPT`; selected modules는 #883 경량 intake/execution, #885 experience/presentation/UI adapter. 변경 경로는 Git diff와 현재 Handoff에 남긴다. evidence ceiling은 문서·MACHINE이며 RUNTIME/HUMAN/최종 이미지/RELEASE는 `NOT_RUN`.
- rollback: 이번 PR의 운영·Skill·검사 변경만 Git revert한다. 게임 브랜치·승인 자산·legacy 입력은 그대로다. 공용 환류는 `NO_NEW_REUSE_LEARNING`: 이미 Base가 소유한 패턴의 프로젝트 적용 사례이며 Base에 새 규칙을 승격하지 않는다.
