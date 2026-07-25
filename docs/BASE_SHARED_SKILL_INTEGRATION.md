# Base 공용 Skill 연결 기준

`urban-legend`는 Base 공용 Skill 본문을 복제하지 않고 route Registry와 프로젝트 어댑터로 사용한다. 프로젝트 내부에는 urban-legend 고유 Skill만 둔다.

## 고정 기준

- Base 공용 Skill 기준: `alsdmlals4-eng/Base@6a224e450f9420223c00921f3c56e051612f92ad`
- 공용 route: `skills/BASE_SHARED_SKILL_ROUTES.json`
- 프로젝트 어댑터: `skills/PROJECT_BASE_SKILL_ADAPTER.json`
- 레거시 보존 어댑터: `docs/archive/ARCHIVE_RETENTION_ADAPTER.json`
- 프로젝트 고유 Skill Registry: `skills/SKILL_REGISTRY.json`

`docs/BASE_RULES_VERSION.md`의 전체 운영체계 기준과 이 공용 Skill 기준은 책임이 다르다. 공용 Skill pin 갱신으로 다른 Base 정책을 자동 강제하지 않는다.

## 라우팅

```text
작업 요청
→ Base 메인 skills/SKILL_REGISTRY.json 자동 trigger 선택
→ skills/PROJECT_BASE_SKILL_ADAPTER.json으로 프로젝트 경로·정본·검증기 주입
→ 필요한 경우에만 urban-legend 고유 Skill 선택
```

명시적 extension route:

- 레거시·아카이브: `governing-legacy-retention-and-archives`.
- Godot 직접 생성 전 자산 탐색: `evaluating-godot-assets-and-plugins-before-creation`.

## Godot 직접 생성 전 조사

```text
Godot 기본 기능
→ 공식 Godot Asset Store
→ 기존 Asset Library
→ 제작자 GitHub 안정 Release·tag
→ itch.io
→ 제작자 공식 판매처·상용 마켓
→ ADOPT / ADAPT / TRIAL / REJECT / BUILD_CUSTOM
```

대화·분기, 로컬라이제이션, 타임라인, 조사 기록 UI와 오디오 이벤트를 우선 조사한다. 조사·기록·회수 루프, 사건 공정성 규칙과 에피소드 정본 데이터는 외부 플러그인에 맡기지 않는다.

## 기록·검증

- 채택 자산: `docs/technical/ADOPTED_ASSETS.md`
- 라이선스: `docs/technical/THIRD_PARTY_LICENSES.md`
- 아카이브: `docs/archive/README.md`, `docs/archive/MANIFEST.json`
- 정적 검사: `python tests/test_base_shared_skill_adapter.py`
- 기존 아카이브 완전 Manifest 이관은 별도 reconciliation 전까지 `PARTIAL`이다.
- Godot·저장 호환성·사람 플레이는 실행 전까지 `NOT_RUN`이다.
