---
name: urban-legend-art
description: Use for Urban Legend character, background, expression, cut-in, and visual-language decisions grounded in approved art direction and information needs.
---

# Urban Legend Art

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

## Purpose and boundary

아트는 현대 오컬트 분위기와 인물 감정을 강화하되 플레이어 정보와 선택을 가리지 않는다. 승인 자산과 의미 키를 우선한다.

- Use: 캐릭터·배경·표정·컷인·괴이·아카의 시각 방향, 승인 자산 일관성·변형 범위, 감정·정보의 시각 언어 변환.
- Do not use: 모델별 프롬프트 문법만 설계, import·Manifest만 관리, UI 전후 렌더만 감사.

## Modes

`direction → asset-spec → continuity-review`

## Read first

1. `docs/CURRENT_STATUS.md`
2. `docs/PROJECT_CORE.md`
3. `docs/planning/ART_PRESENTATION_PLAN.md`
4. `docs/planning/PROJECT_DIRECTION.md`
5. 관련 서사·UI 원본
6. 실제 `assets/`와 소비 Scene
7. `docs/IMAGE_ASSET_WORKFLOW.md`

## Domain workflow

- 장면 목적·플레이어 정보·감정과 승인 미감·기존 자산을 대조한다.
- 자산 상태·의미 키·변형 범위를 정의하고 실제 화면에서 일관성을 검수한다.

## Done and failure gate

- 프로젝트 미감·캐릭터 식별성이 일관되고 정보 위계를 해치지 않는다.
- 승인·미승인·대체·미검증 상태가 구분된다.
- Failure: 출처 없는 자산, 의미 없는 장식, 식별성 훼손, UI 가독성 침해, 승인 없는 원본 교체면 실패다.

## Selective support

프롬프트는 `designing-art-prompts-and-technique-cards`, UI 렌더는 `auditing-and-refining-ui-art`, 통합 증거는 `reviewing-and-validating-project-changes`.
