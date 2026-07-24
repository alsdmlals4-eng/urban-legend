# urban-legend

> 시작: `START_HERE.md` | 현재 상태: `docs/CURRENT_STATUS.md` | 프로젝트 코어: `docs/PROJECT_CORE.md` | 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`

`괴이 기록국`은 Godot 4.7.1과 GDScript로 제작하는 PC용 **권나래 연도제 육성 시뮬레이션 + 텍스트 노벨 + 규칙 추리 + 조작형 미니게임 + 턴제 회수 전투** 프로젝트다. 플레이어는 권나래의 일정·역량·신념·관계를 육성하고, 관측 가능한 단서로 괴이 규칙 가설을 만든 뒤, 조작형 검증과 전조 기반 회수 전투에서 그 이해를 증명한다.

> 괴이는 완전히 죽지 않는다. 그렇기에 규칙을 기록하고, 다음에 살아남을 방법을 남긴다.

## 현재 기준

| 항목 | 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| 연도제 구현 | `NOT_IMPLEMENTED` |
| 다음 트랙 | `ANNUAL-MVP-001` 계획 승인 대기 |
| POC_PASSED | `NOT_DECLARED` |
| Production gate | `HOLD_UNTIL_PLAYER_EVIDENCE` |
| 제작 확대 | `NOT_APPROVED` |

현재 구현에는 기존 세 사건과 CORE-MVP-001 독립 저승역 PoC가 있다. 연도제 육성 상위 루프는 승인된 설계이며 아직 구현되지 않았다.

UX-PD-001 2B·2C와 기존 MVP-044~046은 폐기하지 않는다. ANNUAL-MVP 수직절편 결과에 맞춰 **재매핑**하며 현재 구현 진입점으로 사용하지 않는다.

## 새 담당자·새 AI 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/OPERATING_MODEL.md
→ docs/WORK_MODE_AND_SKILL_ROUTING.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/GAME_DESIGN_DOCUMENT.md
→ docs/DOCUMENTATION_MAP.md
→ skills/SKILL_REGISTRY.json
→ 선택된 Skill·책임 원본
→ 실제 대상 파일
```

연도제 작업에서는 다음을 추가로 읽는다.

```text
docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md
→ docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design-approval.md
→ MVP_ROADMAP.md
→ docs/superpowers/plans/2026-07-25-annual-design-canonical-migration-plan.md
→ docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md
→ TEST_CHECKLIST.md
```

CORE-MVP-001 사건 코어 수정 시 다음 구현 계약도 읽는다.

```text
docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md
→ docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md
```

Base 공용 Skill은 `skills/BASE_SKILL_INDEX.json`에서 선택하고, 프로젝트 Skill은 `skills/SKILL_REGISTRY.json`이 라우팅한다.

## 제품 구조

```text
주간 일정·육성
→ 관계·기관·연구·장비 준비
→ 사건 징후와 출동 판단
→ 텍스트 노벨형 조사
→ 조작형 규칙 검증 미니게임
→ 턴제 회수 전투
→ 위험 사례·잔향·괴이 매뉴얼
→ 연구·스킬·분기 정산
→ 연도 결산·다음 연도 계승
```

### 보호되는 사건 코어

- 관측 가능한 근거로 4개 선택지 중 2개 배제
- 지지·반박·미해결 질문을 가진 규칙 가설 카드
- 현장 이해도와 전조 정보 우위
- 거짓 전조 금지
- 미관측 패턴의 범용 대응과 비가역 손실 금지
- 괴이 HP 0이 아닌 포획 창 개방
- 성공과 실패의 괴이 매뉴얼 기록

### 승인된 연도제 확장

- 1년 4분기
- 주간 계획 + 중요 반일 선택
- 기초 역량·가치 성향·전문성
- 피로 1개 + 상태 태그
- 기본 장비 + 연구 모듈
- 권나래 + 동료 최대 2명
- 권나래 직접 명령, 동료 고유·공용 스킬 자동 지원
- 기관 교육·괴이 연구
- 실패 전진
- 최종 엔딩이 아닌 연도 결산

## 주요 문서

- 문서·Skill 선택: [`docs/DOCUMENTATION_MAP.md`](docs/DOCUMENTATION_MAP.md)
- 프로젝트 코어: [`docs/PROJECT_CORE.md`](docs/PROJECT_CORE.md)
- 상세 게임 설계: [`docs/GAME_DESIGN_DOCUMENT.md`](docs/GAME_DESIGN_DOCUMENT.md)
- 현재 상태: [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md)
- 구현 로드맵: [`MVP_ROADMAP.md`](MVP_ROADMAP.md)
- 검증 계약: [`TEST_CHECKLIST.md`](TEST_CHECKLIST.md)
- 프로젝트 방향: [`docs/planning/PROJECT_DIRECTION.md`](docs/planning/PROJECT_DIRECTION.md)
- 통합 인수인계: [`docs/planning/ROADMAP_AND_HANDOFF.md`](docs/planning/ROADMAP_AND_HANDOFF.md)
- 서사·관계: [`docs/planning/NARRATIVE_CONTENT_PLAN.md`](docs/planning/NARRATIVE_CONTENT_PLAN.md)
- 아트·연출: [`docs/planning/ART_PRESENTATION_PLAN.md`](docs/planning/ART_PRESENTATION_PLAN.md)
- 점진 공개: [`docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md`](docs/planning/PROGRESSIVE_DISCLOSURE_PLAN.md)

## 프로젝트 열기

1. Godot 4.7.1을 실행한다.
2. `Import`를 누른다.
3. 이 저장소의 `project.godot`을 선택한다.
4. 실행하면 `scenes/main_menu.tscn`에서 시작한다.
5. Debug 빌드에서 F1 개발 패널로 CORE-MVP-001 PoC에 진입한다.

## 주요 구조

```text
assets/                   아트 자산
data/episodes/            기존 구현 사건 JSON
data/poc/                 독립 PoC 데이터
scenes/                   본편 Scene
scenes/poc/               독립 PoC Scene
scripts/core/             기존 저장·캠페인 상태
scripts/poc/              격리 PoC 런타임
docs/planning/            방향·서사·아트·정보 위계·로드맵
docs/superpowers/         승인 설계와 실행 계획
docs/                     상태·코어·GDD·운영·검증
skills/                   Base·프로젝트 Skill
tests/                    계약·회귀 테스트
```

## 검증

```powershell
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py tests/test_active_document_references.py tests/test_core_validation_contract.py
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --import
bash tests/run_core_mvp_001_tests.sh
bash tests/run_godot_regression.sh
git diff --check
```

실행하지 않은 검증은 통과로 보고하지 않는다.

## 다음 작업

1. 연도제 정본 전환 문서 계약 완료
2. ANNUAL-MVP-001 구현 계획 최종 승인
3. 기존 저장과 본편을 건드리지 않는 격리 수직절편 구현
4. 자동 계약·Godot 회귀·사람 눈 UI QA
5. 육성→사건→연구 인과 플레이 검증
6. `KEEP / CHANGE / RETEST / HOLD` 판정
