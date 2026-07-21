# Urban Legend 프로젝트 분야 Skill 공통 계약

이 문서는 `skills/disciplines/*/SKILL.md` 10개에 공통인 실행 계약의 단일 원본이다. 각 분야 Skill은 고유 판단·mode·책임 원본·실패 조건만 유지하며, 이 문서를 복제하지 않는다.

## 선택과 읽기

1. `skills/SKILL_REGISTRY.json` trigger로 주 프로젝트 Skill을 최대 하나 선택한다.
2. `docs/PROJECT_CORE.md`에서 보호할 코어와 변경 가능한 외피를 확인한다.
3. 선택한 Skill 본문과 그 Skill의 `Read first`만 읽는다.
4. `support_skills`는 목록 전체가 아니라 현재 trigger와 단계에 맞는 것만 최대 3개 선택한다.
5. 실제 대상 코드·데이터·Scene·자산·문서·테스트를 확인한다.

Registry 행이나 이 공통 계약만 읽고 해당 Skill을 실행했다고 보고하지 않는다.

## 공통 실행 흐름

```text
현재 구현·승인 범위·플레이어 가치 확인
→ 프로젝트 코어·보호 경로·기존 ID·저장 위험 확인
→ 분야별 입력·출력·상태 소유자·실패 조건 확정
→ 가장 작은 승인 단위로 작성·설계·구현·검수
→ 정본·참조·정적·런타임·회귀 중 적용 가능한 검증
→ 변경 문서·증거·미검증·다음 진입점 보고
```

## Definition of Ready

- 현재 구현과 승인 계획이 구분돼 있다.
- 목표·포함·제외·완료 기준·영향 파일이 명확하다.
- `PROJECT_CORE / CORE_SUPPORT / MVP_SUPPORT / TECHNICAL_FOUNDATION / PRESENTATION_SHELL` 영향이 판정됐다.
- 저장·ID·Schema·보호 경로·사용자 변경 위험이 확인됐다.
- 자동·수동 검증과 롤백 또는 복구 경로가 있다.

## Definition of Done

- 분야 Skill의 고유 완료 조건을 만족한다.
- 프로젝트 코어와 기존 정상 기능·데이터 호환성을 보존한다.
- 책임 원본·실제 파일·파생본·참조가 같은 상태를 가리킨다.
- 실행한 검사만 증거로 기록하고 미실행 항목은 `NOT_RUN` 또는 `UNVERIFIED`다.
- 사용한 Work Mode·Skill·Skill Mode, 선택 이유, 결과와 남은 위험을 보고한다.

## 구조 개선·적대적 검토

- 가지치기: `pruning-stale-and-nonfunctional-material`
- 조건부 상세 분리: `simplifying-skill-bodies`
- 행동 보존 리팩토링: `refactoring-with-contract-preservation`
- 실패 가정 공격·비판 검증·최소 개선·회귀: `running-adversarial-review-and-refinement`
- 실제 diff·정적·런타임·호환 증거: `reviewing-and-validating-project-changes`

`MUST_FIX`와 승인된 `SHOULD_FIX`만 반영한다. `DEFER / REJECT / UNVERIFIED`를 몰래 구현하거나, 구조 개선 명목으로 기능·정책·Schema를 바꾸지 않는다.

## 공통 실패 조건

전체 Skill 폴더 기본 로드, 여러 주 분야 Skill 동시 선택, 계획을 구현 완료로 표시, 보호 경로 무승인 변경, 미실행 검사 PASS, 기능 손실을 숨기는 삭제·통합, 코어를 암묵 변경하면 실패다.
