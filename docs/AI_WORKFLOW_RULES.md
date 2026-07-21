# AI Workflow Rules — Compatibility Router

> 수명주기: `COMPATIBILITY_STUB` + 프로젝트 전용 확장  
> 공용 운영 원본: `docs/OPERATING_MODEL.md`  
> Work Mode·Skill 라우팅: `docs/WORK_MODE_AND_SKILL_ROUTING.md`  
> Skill Registry: `skills/SKILL_REGISTRY.json`

이 경로는 기존 ChatGPT·Goal·Codex 링크를 보존한다. 공용 Work Mode·Skill 계약은 위 최신 원본을 따르고, 이 문서는 `urban-legend`의 조건부 외부 위임 경로만 연결한다.

## 기본 실행

```text
Prompt 의도·현재 단계
→ PLAN / BUILD / REVIEW Work Mode
→ Registry trigger 기반 최소 Skill·Skill Mode
→ 범위·보호 대상·완료 기준
→ 승인 범위 실행
→ 계약·정본·정적·런타임·회귀 검증
→ 사용 이유·수행·결과·미검증 보고
```

사용자에게 Skill 선택을 전가하지 않는다. 전체 Base Skill이나 모든 과거 문서를 기본 로드하지 않는다.

## 멀티모델 위임

토큰 효율형 작업 분류, 최소 입력 묶음, 공급자별 산출물, 실패 인수와 측정은 `docs/AI_DELEGATION_WORKFLOW.md`를 따른다.

- 대사: `docs/DIALOGUE_AUTHORING_WORKFLOW.md`
- 이미지: `docs/IMAGE_ASSET_WORKFLOW.md`
- 대량 외부 AI 작업 공간: Base `orchestrating-deepseek-worktrees`
- 외부 결과 검수: Base `reviewing-and-validating-project-changes: external-source-review`

외부 AI 산출물은 신뢰하지 않는 입력이다. 실제 diff·근거·테스트를 확인하기 전 정본이나 구현 완료로 인정하지 않는다. 보호 경로와 실제 적용·검증은 현재 작업의 승인된 구현 주체가 소유한다.

## 대사 작업 전용 경로

대화문, 튜토리얼 안내문, 상황별 반응문 수정은 `docs/DIALOGUE_AUTHORING_WORKFLOW.md`를 따른다. 설정·미확보 정보 누설·기존 ID·저장 영향은 실제 데이터와 함께 검수한다.

## 완료 보고

L1 이상 작업은 실제 사용한 Work Mode·Skill·Skill Mode, 선택 이유, 수행 내용, 결과·증거, 미검증을 남긴다. 외부 도구·모델을 사용하지 않았으면 사용했다고 기록하지 않는다.
