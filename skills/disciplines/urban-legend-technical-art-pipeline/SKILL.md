---
name: urban-legend-technical-art-pipeline
description: Use for Urban Legend asset import, Godot resource settings, manifests, naming, derivatives, and pipeline integrity without changing approved art direction.
---

# Urban Legend Technical Art·Content Pipeline

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

## Purpose and boundary

승인 원본을 추적 가능하게 가져오고 재현 가능한 경로·설정·Manifest로 연결한다. 파이프라인 편의로 승인 아트나 게임 상태를 바꾸지 않는다.

- Use: 에셋 import, Godot 설정, ID·파일명·Manifest·파생본·생성 절차, 고아·중복·깨진 참조 감사.
- Do not use: 아트 방향 결정, UI 미감 감사, 일반 게임 로직 구현.

## Modes

`import → manifest → pipeline-review`

## Read first

1. `docs/CURRENT_STATUS.md`
2. `docs/PROJECT_CORE.md`
3. `docs/IMAGE_ASSET_WORKFLOW.md`
4. `docs/planning/ART_PRESENTATION_PLAN.md`
5. 실제 `assets/`·Scene·Resource·Manifest
6. `skills/PROJECT_PATH_ADAPTER.json`
7. TEST_CHECKLIST.md

## Domain workflow

- 원본·승인·용도·라이선스·기존 소비자를 확인하고 최소 파생본만 만든다.
- Scene·Resource·Manifest와 재생성·롤백 경로를 함께 검증한다.

## Done and failure gate

- 원본↔파생본을 추적할 수 있고 Godot 소비자가 현재 경로를 사용한다.
- 중복·고아·stale 항목이 없으며 미실행 렌더는 `NOT_RUN`이다.
- Failure: 승인 원본 덮어쓰기, `.godot/` 직접 수정, 출처·상태 없는 에셋, 파생본의 정본 오인이면 실패다.

## Selective support

죽은 자료는 `pruning-stale-and-nonfunctional-material`, 전파는 `auditing-canonical-reference-freshness`, 변경 증거는 `reviewing-and-validating-project-changes`.
