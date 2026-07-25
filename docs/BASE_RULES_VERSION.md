# Base Rules Version

이 문서는 urban-legend가 사용하는 Base 버전과 적용 경계의 **단일 사람용 원본**이다. 다른 문서는 커밋 값을 복제하지 않고 이 파일을 참조한다.

## 현재 기준

| 항목 | 값 |
|---|---|
| Base 저장소 | `alsdmlals4-eng/Base` |
| 기준 브랜치 | `main` |
| 코어 Skill Registry 기준 커밋 | `41a20584dd2ee51d917e5c9d7cab6838e1ceba7e` |
| 코어 Skill Registry blob | `14950c9361b3c939990560ae8cc683a936633e89` |
| 코어 활성 Base Skill | 25개 |
| Base 기능 Coverage | 18개 책임 |
| Base shared extension 기준 커밋 | `6a224e450f9420223c00921f3c56e051612f92ad` |
| 채택 shared extension | `governing-legacy-retention-and-archives` |
| 프로젝트 분야 Skill | 10개 |
| 프로젝트 로컬 Skill | 1개 — `urban-legend-investigation-case-authoring` |
| 확인일 | 2026-07-25 |
| 적용 상태 | 고정 Base 코어 인덱스와 archive shared extension을 분리 채택; 프로젝트 코어 상태는 `docs/PROJECT_CORE.md`가 소유 |

기계 원본은 다음과 같이 책임을 분리한다.

- 코어 Base pin: `skills/SKILL_REGISTRY.json`, `skills/BASE_SKILL_INDEX.json`, `skills/BASE_SKILL_COVERAGE.json`, `skills/PROJECT_PATH_ADAPTER.json`
- shared extension pin: `skills/BASE_SHARED_SKILL_ROUTES.json`, `skills/PROJECT_BASE_SKILL_ADAPTER.json`
- archive project adapter: `docs/archive/ARCHIVE_RETENTION_ADAPTER.json`
- archive manifest: `docs/archive/MANIFEST.json`

## 적용 구조

```text
Base Registry 25개 @ 41a20584...
→ skills/BASE_SKILL_INDEX.json에서 코어 trigger·경계 선택
→ 선택한 Base SKILL.md와 reference만 코어 고정 커밋에서 읽기
→ Base shared extension @ 6a224e45...
→ skills/BASE_SHARED_SKILL_ROUTES.json에서 archive governance 선택
→ docs/archive/ARCHIVE_RETENTION_ADAPTER.json으로 프로젝트 경로 적용
→ skills/SKILL_REGISTRY.json의 프로젝트 분야 Skill 0~1개
→ 필요 시 프로젝트 로컬 전문 Skill 0~1개
→ docs/PROJECT_CORE.md·현행 책임 원본·실제 파일
→ 검증·실행 보고
```

전체 Base Skill 본문을 프로젝트에 복제하거나 기본 로드하지 않는다. 라우팅 정보는 로컬에서 사용할 수 있게 고정하고, 상세 실행 계약은 각 정확한 Base 커밋을 정본으로 사용한다.

## 최신 Base에서 적용한 책임

- 프로젝트 코어 읽기 전용 판정과 사용자 승인 기반 확정.
- 적대적 `attack → validate-critique → 최소 개선 → regression-recheck`.
- 가지치기, Skill 본문 간소화, 행동 보존 리팩토링의 책임 분리.
- 로컬·GitHub 상태 동기화와 긴 작업 checkpoint.
- 게임 사용자 연구 11영역 Coverage, 사용자 학습 노트, 시각 대시보드, 엔진 런타임 진단.
- `skills/BASE_SKILL_COVERAGE.json`으로 18개 공용 기능 책임의 무손실 검사.
- 구형 문서·Skill·증거·파생본을 원문과 복구 근거를 보존한 채 현재 정본·구현 권한에서 격리하는 archive governance.

## Archive governance 채택

- 공용 Skill: `governing-legacy-retention-and-archives`
- shared route: `skills/BASE_SHARED_SKILL_ROUTES.json`
- project adapter: `docs/archive/ARCHIVE_RETENTION_ADAPTER.json`
- Manifest: `docs/archive/MANIFEST.json`
- 기존 `backup/`, `history/`, `reports/` 자료 이동·삭제·본문 재작성: `NOT_IN_THIS_ADOPTION`
- branch/tag 삭제: `NOT_RUN`
- 공용 SKILL.md 로컬 복제: 금지

## urban-legend 적용 경계

- Base 공용 판단·절차·검증은 선택적으로 사용한다.
- 프로젝트 고유 세계관·수치·저장·경로·실제 구현은 urban-legend가 책임진다.
- 프로젝트 코어 상태와 승인일은 `docs/PROJECT_CORE.md`가 단독 소유한다.
- 프로젝트 분야 Skill 10개는 공통 실행 계약을 `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`로 공유한다.
- 괴이 사건 작성 로컬 Skill은 전조·가설·근거·대응·매뉴얼 상태의 페어플레이 콘텐츠 계약만 담당한다.
- GDD는 Markdown 원본이 정본이며 `docs/URBAN_LEGEND_GAME_DESIGN.docx`는 필요 시 결정적으로 재생성하는 비추적 파생본이다.
- 전역 PDF·Manifest v3 이주는 별도 승인 대상이다. 이번 archive Manifest는 구형 자료 보존 인덱스이며 기획 문서 발행 Registry를 대체하지 않는다.

## 구조 개선 순서

```text
기능·소비자·정본 인벤토리
→ PROJECT_CORE·보호 계약 baseline
→ lifecycle과 retention classification 분리
→ 공통 상세 추출·중복 통합
→ 행동 보존 리팩토링
→ 적대적 공격과 비판 검증
→ MUST_FIX·승인 SHOULD_FIX만 최소 반영
→ 정본·참조·패키지·라우팅·CI 회귀
```

파일 수 감소 자체를 목표로 하지 않는다. 기능·검증·호환성·발견성을 잃는 통합은 실패다.

## 검증

```text
python tools/check_archive_governance.py
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py tests/test_archive_retention_governance.py
python tools/docs/build_game_design_doc.py --build  # GDD 변경 시
python tools/docs/build_game_design_doc.py --check  # GDD 변경 시
```

Godot 런타임·화면 파일을 변경하지 않은 운영 구조 변경에서는 Godot headless와 수동 플레이를 자동 PASS로 바꾸지 않고 `NOT_RUN`으로 기록한다.
