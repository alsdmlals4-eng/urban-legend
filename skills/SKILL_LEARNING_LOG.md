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

## 2026-07-21 — Base 비파괴 동기화와 2차 Skill Health Review

- Work Mode: `PLAN → BUILD → REVIEW`
- Skill / Skill Mode: `managing-game-project-operating-system: audit/reconcile-legacy/verify`, `evolving-project-discipline-skills: inventory/consolidation/health-review`, `reviewing-and-validating-project-changes: contract-check/reference-freshness/static-validation/regression/evidence-report`, `auditing-canonical-reference-freshness: impact-map/reference-scan/content-drift/propagation-gap/closure-report`
- trigger: 기존 프로젝트 Base 전면 동기화, 구형 Skill ID, 대규모 경로 이동 PR, Skill 패키지 누락, trigger 축약, 책임 중복, Base 예시 경로와 프로젝트 실제 경로 차이
- 입력·범위: Base `ee265576...`의 최상위 운영 정본·Registry blob `2291bce0...`·Legacy Alias·13개 Active Skill 전문·Skill 패키지 무결성 테스트·필요 Schema/Template, urban-legend `main`, PR #41~#43, 대체 PR #46
- 발견: Base Skill ID 13개는 맞았지만 일부 trigger가 축약됐고, 프로젝트 분야 11개는 실제 `SKILL.md`가 없는 라우팅 라벨이었다. `urban-legend-integration-review`는 Base 통합검수·운영체계 `verify`와 고유 책임 없이 중복됐으며, 넓은 프로젝트 trigger와 실제 패키지 CI 누락도 확인했다.
- 수행: Base 13개 라우팅 메타데이터를 source blob과 일치시켰다. 프로젝트 분야는 고유 판단·입력·mode·DoR·DoD·검증·실패 조건을 가진 실행 패키지 10개로 재구성했다. 중복 통합검수 Skill은 Base mode로 흡수하고 Legacy Alias를 추가했다. 대표 routing example, 경로 어댑터, 콜드 스타트, 두 무결성 테스트와 Actions를 연결했다.
- 검증 증거: `docs/qa/BASE_SYNC_AUDIT_2026-07-21.md`, `tests/test_base_operating_sync.py`, `tests/test_skill_package_integrity.py`, `.github/workflows/validate-base-operating-sync.yml`
- 결과: `PASS` — Base 13개 ID·trigger exact-set, 프로젝트 10개 Registry↔패키지 1:1, front matter, 책임 원본·로컬 참조, 프로젝트 trigger 중복 없음, routing example, 통합 Alias, 경로 binding, GDD 발행 호환, 보호 경로 보존을 자동검사했다. Godot 런타임과 수동 화면 QA는 게임 파일 미변경으로 `NOT_RUN`.
- 재사용 가능한 교훈: Registry 항목과 Skill ID 존재만으로 정상 구동을 판정하면 안 된다. 활성 Skill은 실제 `SKILL.md`, 고유 계약, 책임 원본, 검증, 진입점과 CI가 1:1로 이어져야 한다. 기존 Base mode와 고유 책임 없이 겹치는 프로젝트 Skill은 Alias를 남기고 통합하는 편이 더 안전하고 효율적이다.
- Registry·Skill 갱신 필요: `no` — 다음 갱신 trigger는 Base commit·Registry blob 변경, routing 실패, 새 반복 분야 작업 또는 패키지·참조 검사 실패다.
