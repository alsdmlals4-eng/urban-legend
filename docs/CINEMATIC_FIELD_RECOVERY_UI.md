# 장면 중심 현장·회수 UI

> 문서 위치: `docs/CINEMATIC_FIELD_RECOVERY_UI.md` | 현재 상태: `docs/CURRENT_STATUS.md` | 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`
> 승인된 다음 presentation target: `D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`
> 구현 상태: `APPROVED_SPEC / IMPLEMENTATION_PLAN_READY / RUNTIME_NOT_CHANGED`

## 현재 기준

| 항목 | 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 |
| 화면 버전 | Ver 4.2 |
| 저장 스키마 | `mvp-039` (`mvp-038` 이관 지원) |
| 엔진·화면 | Godot 4.7 stable / PC 16:9 / 마우스·키보드 |

## 목적

조사와 안정화·잔향 회수 화면에서 배경·요원·괴이가 먼저 읽히게 하면서, 플레이어가 **전조 → 가설 → 근거 → 대응 → 현장 결과 → 기록 승격**을 한 흐름으로 이해하게 한다. UI는 상태를 표현하며 저장·판정은 `GameState`와 사건 데이터가 소유한다.

## 승인된 다음 presentation hierarchy

`D-2026-08-08-INVESTIGATION-RECOVERY-UI-HIERARCHY-REFINEMENT`는 기존 규칙·저장·ID를 바꾸지 않고 화면 우선순위만 구체화한다. 2026-08-08 20:31 KST에 written spec까지 사용자 승인됐으며 구현은 아직 시작하지 않았다.

### 조사 target

```text
현장·괴이 공간
→ 짧은 상황 서술/현재 화자
→ 지금 가능한 조사 행동
→ 획득 context·가설 진행
→ 요청 시 괴이 매뉴얼/기록 상세
```

- 저승역 `ManualPanel`의 상시 대형 점유는 승인 target이 아니다. 세부 매뉴얼은 기존 drawer 계열로 progressive disclosure한다.
- Canon v2 investigation presentation은 compact rule continuity만 상시 허용하며 protection obligation·termination·follow-up 전문은 조사 화면에서 상시 펼치지 않는다.
- 첫 활성 행동의 pointer/keyboard 발견성과 drawer 종료 뒤 의미 있는 focus 복귀를 명시적 계약으로 둔다.
- 1280×720에서는 보조 context부터 collapse하고 핵심 행동·잠금 이유·복귀 경로는 유지한다.

### 회수 target

```text
얇은 Recovery HUD
→ 중앙 anomaly/telegraph
→ 하단 ally status + action strip
→ 필요 시 rules/log/objective 상세
→ contextual ally cut-in
```

- 괴이 현상이 persistent 전장 시각 주체다.
- `RepresentativeVisual`은 stable node/호환성을 보존하되 상시 전신이 아니라 필요한 순간의 contextual cut-in으로 재해석한다.
- `TeamStrip`, `ActionDock`, `ResponseGrid`, Canon v2 confirmation/termination API는 재사용한다.
- 보호 의무·위험·대안·종결 자격은 기존 도메인 계산을 읽어 필요한 결정 시점에 표시한다.

상세 구조와 TDD 실행 순서는 다음 문서가 책임진다.

- `docs/superpowers/specs/2026-08-08-investigation-recovery-ui-hierarchy-design.md`
- `docs/superpowers/plans/2026-08-08-investigation-recovery-ui-hierarchy-implementation-plan.md`

실제 1280×720·1920×1080 렌더, keyboard/gamepad, 접근성, actual-save Human QA는 계속 `NOT_RUN`이다.

## 현장 화면

현재 구현 기준은 다음과 같다. 위 승인 target이 구현되기 전까지 실제 main 동작의 설명으로 사용한다.

- 상단 큰 배경과 하단 상황 설명·선택 도크를 사용한다.
- 조사 지점 선택 시 하단을 지점 34%, 조사 방식 66%의 두 열로 전환한다.
- 팀 상태는 좌상단 칩, 단서 수집과 안정화 진입은 우상단 HUD, 상세 단서·힌트·학습 기록은 닫을 수 있는 기록 서랍에 둔다.
- `FIELD_DIALOGUE`, `FIELD_CHOICES`, `POINT_PICKER`, `METHOD_PICKER`, `RESULT`는 저장 필드가 아니라 현재 대화·선택 상태에서 계산하는 UI 모드다.
- 조사 중 실패와 미니게임 위험 사례는 다음 판단 근거로 남지만 공식 매뉴얼 규칙으로 자동 승격하지 않는다.

## 안정화·잔향 회수 화면

현재 구현 기준은 다음과 같다. 승인 target은 이 흐름의 의미를 변경하지 않고 presentation만 재구성한다.

- 얇은 상단 HUD, 중앙 대치 스테이지, 하단 판단 도크의 세 계층으로 구성한다.
- 저승역의 CORE-VALIDATION 대상 패턴은 다음 단계형 흐름을 사용한다.

```text
전조와 중립 질문
→ 가설 선택
→ 확보한 근거 선택
→ 대응 선택
→ 현장 안정화 판정
→ 괴이 매뉴얼 기록 판정
```

- `Esc`와 이전 버튼으로 가설·근거 단계로 돌아갈 수 있으며 선택 근거는 유지한다.
- 미수집 근거는 비활성화하고, 단계 진입 시 첫 활성 카드에 키보드 포커스를 둔다.
- 대응 카드는 최고 요원·능력 수치·가설 일치 여부·정답 추론을 미리 표시하지 않는다.
- 저승역 외 사건처럼 가설 계약이 없는 패턴은 기존 직접 대응 카드 흐름을 유지한다.
- 현장 대응 성공과 공식 매뉴얼 승격은 별개다. 올바른 대응이라도 가설이나 지지 근거가 부족하면 `검증 대기 후보`로 남는다.

## 괴이 매뉴얼 기록 상태

| 상태 | 조건 | 저장 결과 |
|---|---|---|
| 공식 규칙 | 올바른 대응 + 선택 가설 일치 + 작성된 지지 근거 전부 선택 + 반증 근거 없음 | `verified_rules`에 승격하고 같은 패턴의 후보 제거 |
| 검증 대기 후보 | 현장 대응은 맞지만 가설 또는 근거가 부족함 | `candidate_rules`에 최신 후보 보존 |
| 위험 사례 | 잘못된 대응 | `danger_cases`에 누적, 같은 사례는 횟수 증가 |

공식 규칙으로 승격된 뒤에도 이전 위험 사례는 삭제하지 않는다. 결과 화면과 기록국 DB는 플레이어가 실제로 만든 공식 규칙·후보·위험 사례를 표시하며, 저승역 조사 화면의 `AfterlifeManualCatalog`는 선행 기록·사례 비교 자료로만 사용한다.

## 공통 컴포넌트와 자산

- `ActionChoiceCard`는 행동 ID를 신호로만 전달하고 상태를 수정하지 않는다.
- `TeamStatusChip`은 체력·정신력·행동 가능·대표 여부만 표시한다.
- 요원과 괴이 원본 이미지는 보존한다. 현재 구현에서 기존 파생 컷아웃 경로를 추적할 때 `assets/ASSET_MANIFEST.json`을 legacy runtime inventory로 참고할 수 있으며 누락 시 기존 합성 이미지로 폴백한다.
- `assets/ASSET_MANIFEST.json`은 `LEGACY_MIGRATION_PENDING_NON_AUTHORITY`다. 해당 inventory의 `stage: final`은 제품 승인 의미가 아니며, tracked 제품 자산 승인·의미·권리 권위는 루트 `ASSET_MANIFEST.yml`이다.
- 기존 파생 컷아웃을 새 승인 자산으로 승격·교체하려면 현재 파일/참조·권리·실제 화면·런타임을 재검증하고 `PROJECT_ASSET_APPROVED`를 거쳐 루트 manifest에 기록한다.
- F2 편집기는 `cinematic_*` 안정 노드만 편집하고 동적 카드는 개별 등록하지 않는다.

## 저장·호환성

- 내부 `battle_scene` 경로와 기존 사건·패턴·대응 ID를 유지한다.
- 저장 버전은 `mvp-039`를 유지하고 선택 필드 `anomaly_manual_records`가 없는 기존 저장은 빈 기록으로 불러온다.
- 저승역 원본 JSON은 유지하고 `_core_validation.json` 오버레이가 가설·근거 계약만 제공한다.
- 장비·소비품·자동 보조·피해·안정도 수치는 기존 판정을 유지하며 플레이어의 핵심 판단을 대신하지 않는다.

## 검증 계약

- Python 데이터 계약과 활성 문서 참조 감사
- Godot 프로젝트 import와 변경 씬 로드
- 가설·근거·대응·역행 입력·직접 대응 폴백
- 후보 → 공식 승격, 위험 사례 누적·중복 횟수, 저장 왕복
- 결과 화면·기록국 DB의 동적 매뉴얼 표시
- 1280×720과 1920×1080 한국어 줄바꿈·포커스·버튼 충돌
- 승인 hierarchy 구현 뒤에는 persistent manual 제거·첫 행동 focus·Canon overlay pointer-safe·anomaly-centered recovery를 자동 계약으로 추가 검증
- 실제 렌더/입력/Human 결과는 실행 전 `NOT_RUN` 유지
