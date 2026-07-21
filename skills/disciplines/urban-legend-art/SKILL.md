---
name: urban-legend-art
description: Use for Urban Legend character, background, expression, cut-in, and visual-language decisions grounded in approved art direction and player-facing information needs.
---

# Urban Legend Art

## Core principle

아트는 괴이 기록국의 현대 오컬트 분위기와 인물 감정을 강화하되, 플레이어가 알아야 할 정보와 선택을 가리지 않는다. 승인 자산과 의미 키를 우선한다.

## Use when

- 캐릭터·배경·표정·컷인·괴이·아카의 시각 방향을 설계한다.
- 승인 자산의 일관성·상태·변형 범위를 판단한다.
- 서사·UI에서 필요한 감정·정보를 시각 언어로 변환한다.

## Do not use when

- 이미지 생성 프롬프트의 모델별 문법만 설계한다.
- Godot import·Manifest·파일 경로만 관리한다.
- 구현된 UI 결과의 전후 렌더만 감사한다.

## Skill modes

- `direction`: 미감·형태·광원·색·밀도·금지 방향을 정의한다.
- `asset-spec`: 캐릭터·배경·표정·컷인의 용도와 상태·변형 계약을 작성한다.
- `continuity-review`: 승인 자산·의미 키·장면 톤의 일관성을 검수한다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `docs/planning/ART_PRESENTATION_PLAN.md`
3. `docs/planning/PROJECT_DIRECTION.md`
4. 관련 서사·UI 책임 원본
5. 실제 `assets/`와 소비 Scene
6. `docs/IMAGE_ASSET_WORKFLOW.md`

## Workflow

```text
장면 목적·플레이어 정보·감정 확인
→ 승인 미감·기존 자산·금지 방향 대조
→ 필요한 자산·상태·의미 키 정의
→ 프롬프트 또는 제작 사양으로 전달
→ 실제 자산·UI 배치와 continuity-review
→ 파이프라인·렌더·접근성 검증 연결
```

## Definition of Ready

- 자산 용도, 화면 크기, 상태, 감정과 정보 역할이 명확하다.
- 재사용 가능한 기존 승인 자산을 확인했다.
- 생성·편집·후처리·import 책임이 구분됐다.

## Definition of Done

- 프로젝트 미감과 캐릭터 정체성이 일관된다.
- 표정·컷인·연출이 상태를 표현하지만 게임 상태를 소유하지 않는다.
- 실제 화면 크기에서 정보 위계를 해치지 않는다.
- 승인·미승인·대체·미검증 상태를 구분한다.

## Validation and failure conditions

- 승인 원본·의미 키·소비 화면과 대조하고 필요 시 전후 렌더를 검수한다.
- 출처 없는 자산, 의미 없는 장식, 캐릭터 식별성 훼손, UI 가독성 침해, 승인 없이 원본 교체하면 실패다.

## Related skills

- 프롬프트·기술 카드: `designing-art-prompts-and-technique-cards`
- 파이프라인: `urban-legend-technical-art-pipeline`
- UI 결과 감사: `auditing-and-refining-ui-art`
- 서사 의미: `urban-legend-narrative`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
