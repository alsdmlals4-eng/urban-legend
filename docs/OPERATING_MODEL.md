# Urban Legend 운영 모델

Base 공용 운영체계를 urban-legend의 기존 구조와 프로젝트 코어에 비파괴적으로 적용하는 단일 실행 모델이다. Base 버전은 `docs/BASE_RULES_VERSION.md` 한 곳에서 확인한다.

## 우선순위

1. 최신 사용자 지시.
2. `AGENTS.md`, `docs/PROJECT_CORE.md`, 보호·저장·엔진 계약.
3. `docs/CURRENT_STATUS.md`와 승인 작업 계약.
4. 프로젝트 책임 원본과 실제 코드·데이터·자산·테스트.
5. 프로젝트에 고정된 Base 라우팅·Coverage.
6. Base 원격 전문과 외부 근거.

외부 사례·Base 예시는 프로젝트 구현 사실이나 승인 결정을 대체하지 않는다.

## 생명주기

```text
의도·현재 단계·위험
→ Work Mode
→ 프로젝트 분야 Skill 0~1개
→ 프로젝트 로컬 전문 Skill 0~1개
→ 필요한 Base 지원 Skill 0~3개
→ 요구·DoR·코어·보호 baseline
→ Benchmark Gate
→ 결과 단위·의존성·승인
→ 설계·구현·작성
→ 적대적 검토·비판 검증·최소 개선
→ 정본·참조·정적·런타임·회귀
→ 상태·문서·PR·Handoff·Learning Log
```

한 시점의 주 Work Mode는 하나다. 복합 작업은 `PLAN → BUILD → REVIEW`, 검증된 수정은 `REVIEW → BUILD → REVIEW`로 전환한다.

## 책임 원본

```text
현재 상태 → docs/CURRENT_STATUS.md
프로젝트 코어·승인 상태 → docs/PROJECT_CORE.md
문서 위치·조건 → docs/DOCUMENTATION_MAP.md
프로젝트 Skill → skills/SKILL_REGISTRY.json
Base Skill 라우팅 → skills/BASE_SKILL_INDEX.json
공용 기능 무손실 → skills/BASE_SKILL_COVERAGE.json
경로 변환 → skills/PROJECT_PATH_ADAPTER.json
상세 설계 → docs/GAME_DESIGN_DOCUMENT.md
로드맵 → MVP_ROADMAP.md
검증 → TEST_CHECKLIST.md
```

같은 사실을 여러 현행 원본으로 복제하지 않는다.

## Skill 운영

- 사용자는 Skill 이름을 선언할 필요가 없다.
- 전체 Skill 폴더를 기본 로드하지 않는다.
- 주 프로젝트 분야 Skill은 최대 하나, 프로젝트 로컬 전문 Skill은 최대 하나, 지원 Base Skill은 최대 3개다.
- `support_skills`는 가능한 조합이지 상시 호출 목록이 아니다.
- Base 상세는 고정 커밋의 선택된 패키지만 읽는다.
- 프로젝트 분야 Skill 10개의 공통 DoR·DoD·보고는 `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`가 책임진다.
- 괴이 사건의 전조·가설·근거·대응·매뉴얼 상태를 작성·개정할 때는 `skills/urban-legend-investigation-case-authoring/SKILL.md`를 추가로 읽는다.

## Benchmark-first 기획 Gate

새 시스템, 핵심 규칙, 콘텐츠 구조, UX 흐름을 설계할 때는 설계안 작성 전에 벤치마킹을 수행한다. 상세 방법과 사례 형식은 `docs/BENCHMARKING_REFERENCE_GUIDE.md`가 책임진다.

### 필수 적용 대상

- 새로운 플레이 시스템 또는 기존 시스템의 책임 변경
- 프로젝트 코어에 영향을 주는 규칙·보상·실패 구조
- 사건·에피소드·관계·연간 캠페인의 콘텐츠 구조
- 주요 화면의 정보 위계·입력·복구·온보딩 흐름
- 장기 제작 비용이나 플레이어 행동을 크게 바꾸는 설계

### 수행 원칙

- 같은 질문에 유효한 기존 벤치마크가 있으면 먼저 재사용하고 현재 설계에 맞는지 확인한다.
- 기본은 직접 관련된 사례 3~5개를 제한된 시간 안에 비교한다.
- 장르 정체성, 시장성, 플랫폼 전환, 대규모 방향 변경처럼 표본이 필요한 경우에만 범위를 확장한다.
- 조사량보다 `채택 / 조건부 채택 / 제외 / 위험` 결론과 프로젝트식 재해석을 우선한다.
- 외부 사례의 고유 UI·규칙·서사·아트를 복제하지 않는다.
- Benchmark Gate를 통과하지 않은 신규 설계는 구현 승인 상태로 올리지 않는다.

### 반복 조사가 필요 없는 경우

- 오탈자·문구 정정·경로와 상태 문서 동기화
- 승인된 설계의 범위 내 구현과 명백한 버그 수정
- 기존 동작을 보존하는 기술 리팩토링·회귀 보정
- 이미 같은 질문을 다룬 최신 벤치마크를 그대로 재사용할 수 있는 작업

단, 버그 수정이나 리팩토링이 플레이어 규칙·콘텐츠 구조·UX 흐름을 실질적으로 바꾸면 Benchmark Gate를 다시 적용한다.

### Gate 상태

- `PASSED`: 이번 질문을 위한 목적형 비교와 적용·제외 결론을 작성함
- `REUSED`: 기존 근거가 같은 질문과 현재 범위에 유효함을 확인함
- `NOT_APPLICABLE`: 신규 설계가 아닌 정정·실행·회귀 작업임
- `BLOCKED`: 필요한 근거가 없어 설계를 확정할 수 없음

## 프로젝트 코어와 변경 권한

`docs/PROJECT_CORE.md`가 프로젝트 코어의 승인 상태와 재승인 경계를 단독 소유한다. 현재 상태는 `CORE_RECORDED / CORE_STRESS_TESTED`, 구현은 `POC_PENDING`, Production gate는 `HOLD_UNTIL_PLAYER_EVIDENCE`다. 일반 리팩토링으로 코어를 바꾸거나 플레이 증거 없이 구현 완료·제작 확대를 선언하지 않는다.

## 가지치기·간소화·리팩토링

- 가지치기: 죽은·중복·stale 자료를 `KEEP / MERGE / MOVE_TO_REFERENCE / STUB / ARCHIVE / DELETE / UNVERIFIED`로 판정.
- 간소화: 항상 필요한 계약만 본문에 두고 조건부 상세를 한 단계 reference로 이동.
- 리팩토링: baseline 동작·인터페이스·Schema·호환성을 고정하고 작은 구조 변경마다 회귀.
- Skill 통합: 기존 mode/reference로 해결 가능한지 먼저 확인하고 독립 책임 경계가 있을 때만 유지.

## 적대적 검토

```text
attack
→ validate-critique
→ MUST_FIX / SHOULD_FIX / DEFER / REJECT / UNVERIFIED
→ 승인된 최소 변경
→ regression-recheck
→ decision-report
```

레드팀 지적은 자동 요구가 아니다. 취향·범위 밖·잘못된 전제는 기각하며 코어·장점·호환성을 보호한다.

## 검증과 보고

변경 영향에 맞춰 benchmark gate, contract, reference freshness, static, runtime, accessibility, performance, regression, evidence를 선택한다. Skill·Registry·운영 문서 변경은 세 Python 계약 테스트를 실행한다. L1 이상 보고에는 실제 Work Mode·분야/로컬/Base Skill·Mode·이유·Benchmark Gate·변경·증거·미검증·롤백을 포함한다.
