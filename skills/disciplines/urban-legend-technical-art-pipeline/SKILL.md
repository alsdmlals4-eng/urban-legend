---
name: urban-legend-technical-art-pipeline
description: Use for Urban Legend asset import, Godot resource settings, manifests, naming, derivative generation, and content-pipeline integrity without changing approved art direction.
---

# Urban Legend Technical Art·Content Pipeline

## Core principle

에셋 파이프라인은 승인된 원본을 추적 가능하게 가져오고 재현 가능한 경로·설정·Manifest로 연결한다. 파이프라인 편의로 승인 아트나 게임 상태를 바꾸지 않는다.

## Use when

- 이미지·오디오·폰트 등 에셋을 Godot에 가져오고 import 설정을 관리한다.
- 에셋 ID·파일명·Manifest·파생본·생성 절차를 설계하거나 감사한다.
- 누락·중복·고아 에셋과 깨진 Scene·Resource 참조를 해결한다.

## Do not use when

- 아트 방향·표정·컷인 자체를 새로 결정한다.
- 구현된 UI의 시각 품질만 평가한다.
- 일반 게임 로직 구현이다.

## Skill modes

- `import`: 승인 원본을 규칙에 맞게 배치하고 Godot import를 검증한다.
- `manifest`: 원본·파생본·ID·경로·상태를 Registry 또는 Manifest에 연결한다.
- `pipeline-review`: 고아·중복·stale 참조와 재생성 가능성을 감사한다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `docs/IMAGE_ASSET_WORKFLOW.md`
3. `docs/planning/ART_PRESENTATION_PLAN.md`
4. 실제 `assets/`·관련 Scene·Resource·Manifest
5. `skills/PROJECT_PATH_ADAPTER.json`
6. `TEST_CHECKLIST.md`

## Workflow

```text
승인 원본·용도·소유자·라이선스 확인
→ ID·경로·파일명·import 설정 확정
→ 최소 파생본 생성·배치
→ Scene·Resource·Manifest 참조 갱신
→ 고아·중복·stale 참조 검사
→ Godot import·렌더·재생성 경로 검증
```

## Definition of Ready

- 원본 파일, 승인 상태, 대상 화면·용도와 변형 범위가 명확하다.
- 기존 에셋 ID·경로·Scene 참조를 확인했다.
- 재생성 또는 롤백 경로가 있다.

## Definition of Done

- 승인 원본과 파생본 관계를 추적할 수 있다.
- Godot가 에셋을 오류 없이 import하고 실제 소비자가 현재 경로를 사용한다.
- 중복·고아·stale Manifest 항목이 없다.
- 미실행 렌더·사람 시각 QA를 `NOT_RUN`으로 기록한다.

## Validation and failure conditions

- 파일 존재, 중복 ID·경로, Scene·Resource 참조, Godot import와 필요 렌더를 검사한다.
- 승인 원본 덮어쓰기, `.godot/` 직접 수정, 출처·상태 없는 에셋 추가, 파생본을 정본으로 오인하면 실패다.

## Related skills

- 아트 방향: `urban-legend-art`
- 프롬프트·기술 카드: `designing-art-prompts-and-technique-cards`
- UI 결과 감사: `auditing-and-refining-ui-art`
- 참조 최신성: `auditing-canonical-reference-freshness`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
