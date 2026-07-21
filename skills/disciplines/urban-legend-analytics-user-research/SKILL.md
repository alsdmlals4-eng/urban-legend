---
name: urban-legend-analytics-user-research
description: Use for Urban Legend benchmark analysis, player-response research, playtest evidence, telemetry planning, and evidence synthesis tied to a concrete product or design decision.
---

# Urban Legend Analytics·User Research

## Core principle

외부 사례·리뷰·행동 데이터는 프로젝트 결정을 지원하는 근거이지 정답이 아니다. 표본·출처·관찰과 해석을 분리하고, 실제 적용·제외·검증 결론으로 끝낸다.

## Use when

- 비교 게임·시장·사용자 반응·플레이테스트를 조사한다.
- 텔레메트리 이벤트·퍼널·실험·연구 질문을 설계한다.
- 정성·정량 근거를 기획·UX·우선순위 결정으로 변환한다.

## Do not use when

- 출처 없는 인기 목록만 수집한다.
- 이미 확정된 단일 기능을 구현한다.
- 프로젝트 고유 서사·수치를 외부 평균으로 덮어쓴다.

## Skill modes

- `research`: 질문·표본·출처·관찰 기준을 정하고 근거를 수집한다.
- `telemetry`: 결정에 필요한 이벤트·속성·퍼널·보호 지표를 설계한다.
- `playtest-analysis`: 대표·변형·실패 경로의 행동과 피드백을 분석한다.
- `synthesis`: 관찰·해석·불확실성·적용·제외·검증을 결정안으로 압축한다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `docs/BENCHMARKING_REFERENCE_GUIDE.md`
3. `docs/planning/REFERENCE_CASES.md`
4. 관련 기획·UX 책임 원본
5. 실제 플레이테스트·리뷰·텔레메트리 자료
6. 결정할 질문과 완료 기준

## Workflow

```text
결정 질문·가설·사용 가능한 근거 확인
→ 공식·개발자·사용자·행동 자료 분리
→ 표본·기간·편향·비교 가능성 평가
→ 관찰과 해석 분리
→ 적용·제외·위험·검증 계획 작성
→ 책임 원본·PoC·플레이테스트에 연결
```

## Definition of Ready

- 조사 결과로 내릴 결정과 성공·실패 신호가 명확하다.
- 필요한 최신성·표본·출처 수준과 시간 제한이 있다.
- 프로젝트에서 변경 가능한 범위가 정해졌다.

## Definition of Done

- 출처·날짜·표본·한계와 사실·추론을 구분한다.
- 기능 복사가 아니라 프로젝트 적용 이유와 제외 이유를 남긴다.
- 텔레메트리·플레이테스트가 실제 의사결정에 연결된다.
- 불충분한 근거는 가설 또는 `UNVERIFIED`로 표시한다.

## Validation and failure conditions

- 상충 근거·대표성·최신성·측정 가능성과 프로젝트 적용 후 검증 계획을 확인한다.
- 리뷰 표본 편향 은폐, 자기보고와 행동 혼동, 여러 변수 동시 실험, 출처 없는 수치, 조사만 하고 결정·검증이 없으면 실패다.

## Related skills

- 컨셉·PoC 통합: `analyzing-and-refining-game-concepts`
- Vertical Slice·외부 플레이테스트: `designing-vertical-slices`
- 게임 설계: `urban-legend-game-design`
- 변경 검증: `reviewing-and-validating-project-changes`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
