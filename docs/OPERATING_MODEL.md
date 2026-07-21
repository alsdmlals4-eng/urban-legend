# Urban Legend 운영 모델

> Base 기준: `alsdmlals4-eng/Base@ee265576da7f67d3278f8099dd97d4e714ef0651`  
> 시작 지점: `START_HERE.md` | 라우팅: `docs/WORK_MODE_AND_SKILL_ROUTING.md` | Skill Registry: `skills/SKILL_REGISTRY.json`

이 문서는 Base의 공용 운영 계약을 `urban-legend`의 기존 구조에 비파괴적으로 적용한 프로젝트 운영 원본이다. 프로젝트 고유 책임 원본은 현재 경로를 유지하며 Base 전문을 복제하지 않는다.

## 1. 우선순위

1. 사용자의 최신 지시
2. 프로젝트 `AGENTS.md`와 보호·저장·엔진 규칙
3. `docs/CURRENT_STATUS.md`와 승인된 작업 계약
4. 프로젝트 책임 원본과 실제 코드·데이터·자산·테스트
5. 이 저장소에 동기화된 Base 기준
6. Base 원격 원본
7. 외부 사례·리뷰·과거 대화·초안·추정

정상 동작 중인 사용자 변경을 임의로 되돌리지 않는다. 외부 자료와 Base 공용 예시는 프로젝트 구현 사실이나 사용자 승인 결정을 대체하지 않는다.

## 2. 운영 생명주기

```text
Prompt 의도·현재 단계·위험 파악
→ Work Mode 자동 선택
→ 최소 Skill·Skill Mode 자동 라우팅
→ 요구·범위·보호 대상·완료 기준 확정
→ 필요 시 검증 가능한 결과 단위와 의존성 계획
→ 승인 범위 구현·제작·갱신
→ 계약·정본·참조·정적·런타임·회귀 검증
→ 상태·책임 원본·발행본 동기화 심사
→ 사용 이유·수행 내용·결과·미검증 보고
→ 인수인계·재사용 가능한 학습 기록
```

복합 작업은 `PLAN → BUILD → REVIEW`로 전환한다. 한 시점에는 주 Work Mode 하나만 둔다.

## 3. 책임 원본

```text
현재 구현·승인 계획 → docs/CURRENT_STATUS.md
문서 위치·읽기 조건 → docs/DOCUMENTATION_MAP.md
프로젝트 방향 → docs/planning/PROJECT_DIRECTION.md
서사·관계 → docs/planning/NARRATIVE_CONTENT_PLAN.md
아트·연출 → docs/planning/ART_PRESENTATION_PLAN.md
상세 게임 설계 → docs/GAME_DESIGN_DOCUMENT.md
구현 순서 → MVP_ROADMAP.md
검증 계약 → TEST_CHECKLIST.md
공용 작업 계약 → docs/OPERATING_MODEL.md
Work Mode·Skill 라우팅 → docs/WORK_MODE_AND_SKILL_ROUTING.md
Skill 선택·상태 → skills/SKILL_REGISTRY.json
과거 상태 → Git 이력과 docs/archive/
```

한 질문에는 현행 책임 원본 하나를 둔다. PDF·DOCX·캡처·Manifest는 원본과 검증 상태를 대체하지 않는다.

## 4. 기존 프로젝트 안전 계약

`urban-legend`는 신규 빈 프로젝트가 아니다. Base의 `install` 구조를 강제로 덮지 않고 `audit → 필요 시 reconcile-legacy → 승인된 migrate → verify`를 사용한다.

구형·중복 파일은 다음 중 하나로 판정한다.

```text
CURRENT
UPDATE_IN_PLACE
MERGE_TO_CANONICAL
COMPATIBILITY_STUB
ARCHIVE_HISTORY
DELETE_APPROVED
KEEP_UNRESOLVED
```

사용자 승인 전 금지:

- 현행 책임 원본의 대량 이동·삭제·통합
- Base 폴더 구조에 맞춘 강제 개명
- 파일명에 `old`, `v2`, `final`, 날짜가 있다는 이유만으로 삭제
- 프로젝트 용어·수치·저장 구조·기존 ID 변경
- 승인 이미지·실제 QA 결과 제거
- 불확실한 파일을 현행에서 제외했다고 단정

기존 경로를 바꾸어야 한다면 고유 정보 승계, 활성 참조 갱신 또는 호환 stub, 파생본·Manifest 검증, 복구 경로와 사용자 승인이 모두 필요하다.

## 5. 프로젝트 보호 계약

다음은 관련 기능 요청과 회귀 계약 없이 변경하지 않는다.

- `scripts/core/game_state.gd`
- `data/episodes/**`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 스키마와 기존 저장 키
- 캠페인·경제·엔딩·에피소드 규칙과 기존 ID
- 승인된 아트와 실제 QA 증거

프로젝트 불변 용어와 플레이 약속은 `AGENTS.md`가 책임진다.

## 6. Skill 운영

- 사용자는 Skill이나 Skill Mode를 직접 선택할 필요가 없다.
- `skills/SKILL_REGISTRY.json`의 trigger와 비사용 조건으로 최소 집합을 자동 선택한다.
- Base Skill은 고정 커밋의 원격 원본을 참조하며 저장소에 전부 복제하지 않는다.
- 프로젝트 분야 Skill은 기존 프로젝트 책임 원본과 실제 파일을 입력으로 사용한다.
- `load_by_default=false`는 자동 선택 금지가 아니라 trigger가 없을 때 읽지 않는다는 뜻이다.
- 통합 전 Skill ID는 `skills/LEGACY_SKILL_ALIASES.md`로만 변환하며 활성 Registry에 두지 않는다.

## 7. 검증과 보고

변경 영향에 맞춰 다음을 선택한다.

```text
contract-check
→ 정본·경로·ID·Schema 변경 시 reference-freshness
→ static-validation
→ 적용 가능한 runtime-validation
→ 접근성·성능 영향 시 해당 검수
→ regression
→ evidence-report
```

L1 이상 완료 보고에는 실제 사용한 `Work Mode / Skill / Skill Mode / 선택 이유 / 수행 내용 / 결과·증거 / 미검증`을 포함한다. 실행하지 않은 테스트·렌더·권한·사람 검수는 `NOT_RUN` 또는 `UNVERIFIED`로 기록한다.
