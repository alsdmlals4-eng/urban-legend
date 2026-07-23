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
