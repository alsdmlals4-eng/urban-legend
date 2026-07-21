# Base Rules Version

이 문서는 urban-legend가 사용하는 Base 버전과 적용 경계의 **단일 사람용 원본**이다. 다른 문서는 커밋 값을 복제하지 않고 이 파일을 참조한다.

## 현재 기준

| 항목 | 값 |
|---|---|
| Base 저장소 | `alsdmlals4-eng/Base` |
| 기준 브랜치 | `main` |
| 기준 커밋 | `41a20584dd2ee51d917e5c9d7cab6838e1ceba7e` |
| Skill Registry blob | `14950c9361b3c939990560ae8cc683a936633e89` |
| 활성 Base Skill | 25개 |
| 확인일 | 2026-07-22 |
| 적용 상태 | PR #46에서 비파괴 동기화·최적화 검토 중 |

기계 원본은 `skills/SKILL_REGISTRY.json`, `skills/BASE_SKILL_INDEX.json`, `skills/PROJECT_PATH_ADAPTER.json`에 같은 값을 둔다.

## 적용 구조

```text
Base Registry 25개
→ skills/BASE_SKILL_INDEX.json에서 trigger·경계 선택
→ 선택한 Base SKILL.md와 명시된 reference만 고정 커밋에서 읽기
→ skills/SKILL_REGISTRY.json의 프로젝트 분야 Skill 최대 1개
→ docs/PROJECT_CORE.md·현행 책임 원본·실제 파일
→ 검증·실행 보고
```

전체 Base Skill 본문을 프로젝트에 복제하거나 기본 로드하지 않는다. 라우팅 정보는 로컬에서 사용할 수 있게 고정하고, 상세 실행 계약은 원격 고정 커밋을 정본으로 사용한다.

## 최신 Base에서 추가·강화된 책임

- 프로젝트 코어 읽기 전용 판정과 사용자 승인 기반 확정.
- 적대적 `attack → validate-critique → 최소 개선 → regression-recheck`.
- 가지치기, Skill 본문 간소화, 행동 보존 리팩토링의 책임 분리.
- 로컬·GitHub 상태 동기화와 긴 작업 checkpoint.
- 게임 사용자 연구 11영역 Coverage, 사용자 학습 노트, 시각 대시보드, 엔진 런타임 진단.
- `skills/BASE_SKILL_COVERAGE.json`으로 18개 공용 기능 책임의 무손실을 검사한다.

## urban-legend 적용 경계

- Base 공용 판단·절차·검증은 선택적으로 사용한다.
- 프로젝트 고유 세계관·수치·저장·경로·실제 구현은 urban-legend가 책임진다.
- 프로젝트 코어는 `docs/PROJECT_CORE.md`의 `IDENTIFIED` 상태이며 명시 승인 전 `CORE_CONFIRMED`로 표시하지 않는다.
- 프로젝트 분야 Skill은 10개를 유지하되 공통 실행 계약을 `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`로 추출한다.
- 기존 GDD 발행은 Markdown 원본→검증된 DOCX 파생본이며 PDF·Manifest v3 이주는 별도 승인 대상이다.

## 구조 개선 순서

```text
기능·소비자·정본 인벤토리
→ PROJECT_CORE·보호 계약 baseline
→ KEEP / MERGE / MOVE_TO_REFERENCE / STUB / ARCHIVE / DELETE / UNVERIFIED
→ 공통 상세 추출·중복 통합
→ 행동 보존 리팩토링
→ 적대적 공격과 비판 검증
→ MUST_FIX·승인 SHOULD_FIX만 최소 반영
→ 정본·참조·패키지·라우팅·CI 회귀
```

파일 수 감소 자체를 목표로 하지 않는다. 기능·검증·호환성·발견성을 잃는 통합은 실패다.

## 검증

```text
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py
python tools/docs/build_game_design_doc.py --check  # GDD 변경 시
```

Godot 런타임·화면 파일을 변경하지 않은 운영 구조 PR에서는 Godot headless와 수동 플레이를 자동 PASS로 바꾸지 않고 `NOT_RUN`으로 기록한다.
