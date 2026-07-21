# Project Skill Learning Log

> Base 기준: `alsdmlals4-eng/Base@ee265576da7f67d3278f8099dd97d4e714ef0651`  
> Registry: `skills/SKILL_REGISTRY.json` | 프로젝트 경로 어댑터: `skills/PROJECT_PATH_ADAPTER.json`

반복 가능한 실패·결정·검증 결과가 있을 때만 기록한다. 단순 호출, 추측, 실행하지 않은 검사, 일회성 문장 수정은 학습으로 남기지 않는다.

## 기록 형식

```md
## YYYY-MM-DD — 제목
- Work Mode:
- Skill / Skill Mode:
- trigger:
- 입력·범위:
- 수행:
- 검증 증거:
- 결과: PASS | PARTIAL | FAIL | UNVERIFIED
- 재사용 가능한 교훈:
- Registry·Skill 갱신 필요: yes | no
```

## 2026-07-21 — Base 비파괴 동기화와 PR 감사

- Work Mode: `PLAN → BUILD → REVIEW`
- Skill / Skill Mode: `managing-game-project-operating-system: audit/reconcile-legacy/verify`, `evolving-project-discipline-skills: inventory/consolidation/health-review`, `reviewing-and-validating-project-changes: contract-check/reference-freshness/static-validation/regression/evidence-report`, `auditing-canonical-reference-freshness: impact-map/reference-scan/content-drift/propagation-gap/closure-report`
- trigger: 기존 프로젝트 Base 전면 동기화, 구형 Skill ID, 대규모 경로 이동 PR, Base 예시 경로와 프로젝트 실제 경로 차이
- 입력·범위: Base `ee265576...`의 최상위 운영 정본·Registry·Legacy Alias·13개 Active Skill 전문·필요 Schema/Template, urban-legend `main`, PR #41~#43
- 수행: 현행 책임 원본을 제자리에 유지하는 운영 모델·Registry·경로 어댑터·검증 경로를 추가하고 스택 PR의 계약 위반을 분리했다. Base의 `[기획서]/...` 예시를 프로젝트 실제 경로로 고정하고, 기존 Markdown GDD→검증된 DOCX 발행 계약을 별도 승인 없이 PDF·Manifest 체계로 교체하지 않았다.
- 검증 증거: `docs/qa/BASE_SYNC_AUDIT_2026-07-21.md`, `tests/test_base_operating_sync.py`, `.github/workflows/validate-base-operating-sync.yml`
- 결과: `PASS` — Base commit·13개 Skill·legacy alias·프로젝트 경로 binding·GDD 발행 호환·보호 경로·책임 원본 보존·changed-file 범위 검증 통과. Godot 런타임과 수동 화면 QA는 게임 파일 미변경으로 `NOT_RUN`.
- 재사용 가능한 교훈: 기존 프로젝트에는 신규 설치형 대규모 이동보다 `UPDATE_IN_PLACE`·원문 보존형 `COMPATIBILITY_STUB`·명시적 경로 어댑터가 우선이며, Base 템플릿의 파생본 요구는 현행 발행 계약과 별도 승인 여부를 대조해야 한다.
- Registry·Skill 갱신 필요: `no`
