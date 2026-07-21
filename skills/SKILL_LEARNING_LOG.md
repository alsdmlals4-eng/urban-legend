# Project Skill Learning Log

> Base 기준: `alsdmlals4-eng/Base@ee265576da7f67d3278f8099dd97d4e714ef0651`  
> Registry: `skills/SKILL_REGISTRY.json`

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
- Skill / Skill Mode: `managing-game-project-operating-system: audit/reconcile-legacy/verify`, `reviewing-and-validating-project-changes: contract-check/reference-freshness/static-validation/regression/evidence-report`
- trigger: 기존 프로젝트 Base 전면 동기화, 구형 Skill ID, 대규모 경로 이동 PR
- 입력·범위: Base `ee265576...`, urban-legend `main`, PR #41~#43
- 수행: 현행 책임 원본을 제자리에 유지하는 운영 모델·Registry·검증 경로를 추가하고 스택 PR의 계약 위반을 분리했다.
- 검증 증거: `docs/qa/BASE_SYNC_AUDIT_2026-07-21.md`, `tests/test_base_operating_sync.py`
- 결과: `PARTIAL` — 자동 정적 검증은 PR CI에서 확인하며 Godot 런타임은 게임 파일 미변경으로 `NOT_RUN`
- 재사용 가능한 교훈: 기존 프로젝트에는 신규 설치형 대규모 이동보다 `UPDATE_IN_PLACE`·`COMPATIBILITY_STUB`가 우선이며, 이주 계약과 실제 diff를 PR 단위로 대조해야 한다.
- Registry·Skill 갱신 필요: `no`
