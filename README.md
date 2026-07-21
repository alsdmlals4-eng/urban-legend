# urban-legend

> 시작: `START_HERE.md` | 현재 상태: `docs/CURRENT_STATUS.md` | 프로젝트 코어: `docs/PROJECT_CORE.md` | 운영 모델: `docs/OPERATING_MODEL.md`

**괴이 기록국**은 Godot 4.7 stable과 GDScript로 제작하는 PC용 현대 오컬트 수사 어드벤처다. 플레이어는 권나래와 최대 두 명의 서포트를 운용해 괴이의 규칙을 조사하고 현재 출현을 안정화한 뒤, 잔향·위험 사례·대응 절차를 괴이 매뉴얼로 남긴다.

## 현재 기준

- 구현 기준선: MVP-043 / 화면 Ver 4.1.
- 저장: `mvp-039`, `mvp-038` 이관 지원.
- 사건: 저승역, 비 오는 골목의 빨간 우산, 폐주파수 방송국.
- 플랫폼: PC/Steam, 16:9, 마우스·키보드.
- 다음 승인 계획: MVP-044 서사 → MVP-045 관계 → MVP-046 대화·표정·컷인. 문서 존재는 구현 완료가 아니다.

## 읽기 순서

```text
START_HERE → AGENTS → CURRENT_STATUS → PROJECT_CORE
→ DOCUMENTATION_MAP → SKILL_REGISTRY
→ 선택된 Skill·책임 원본 → 실제 파일
```

Base 공용 25개 Skill은 `skills/BASE_SKILL_INDEX.json`에서 선택하고 고정된 Base 전문만 읽는다. 프로젝트 고유 분야 Skill 10개는 `skills/disciplines/`에 있으며 공통 계약을 공유한다.

## 핵심 플레이 흐름

```text
캠페인·일정
→ 사건 조사·단서 수집
→ 규칙 판단·검증
→ 안정화·잔향 회수
→ 보고서·DB·괴이 매뉴얼
→ 다음 반일
```

괴이는 처치 대상이 아니며 실패는 다음 판단을 위한 위험 사례로 남는다. 기록관 아카와 요원은 정보를 설명하지만 정답을 대신하지 않는다.

## 주요 구조

```text
assets/          승인 아트·오디오
data/            사건·일상·시스템 데이터
scenes/          메뉴·HQ·조사·회수·결과·DB·시장
scripts/         저장·데이터·Scene·UI 로직
docs/            상태·코어·설계·운영·QA
skills/          Base 인덱스·Coverage·프로젝트 Skill
tests/           계약·회귀 테스트
tools/docs/      GDD DOCX 생성기
```

## 검증

```text
python -m unittest tests/test_base_operating_sync.py tests/test_skill_package_integrity.py
python tools/docs/build_game_design_doc.py --check  # GDD 변경 시
```

Godot·플레이어 화면 변경이 있는 작업은 `TEST_CHECKLIST.md`의 headless·해상도·입력·저장·플레이 경로 검증을 추가한다. 실행하지 않은 항목은 통과로 기록하지 않는다.
