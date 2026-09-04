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

변경 영향에 맞춰 contract, reference freshness, static, runtime, accessibility, performance, regression, evidence를 선택한다. Skill·Registry·운영 문서 변경은 세 Python 계약 테스트를 실행한다. L1 이상 보고에는 실제 Work Mode·분야/로컬/Base Skill·Mode·이유·변경·증거·미검증·롤백을 포함한다.
