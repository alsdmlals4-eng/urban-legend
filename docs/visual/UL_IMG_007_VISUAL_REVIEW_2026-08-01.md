# UL-IMG-007 SCREEN·SIT 보드 시각 검수 — 2026-08-01

> Review ID: `R-2026-08-01-UL-IMG-007-VISUAL-REVIEW`
> Image ID: `UL-IMG-007`
> 연결 Decision: `D-2026-08-01-VALIDATION-SCREEN-SIT-PACKAGE`
> 상태: `APPROVED_PLANNING_VISUALIZATION_WITH_OPEN_P2 / NOT_PRODUCT_ASSET`
> 버전: `precision-layout-v1`
> 제품 구현 권한: `NONE`
> 실제 제품 에셋 승인: `NOT_GRANTED`
> Runtime / Human QA: `NOT_RUN`

## 1. 산출물

정밀 레이아웃 렌더러로 다음 6개 16:9 보드를 생성했다.

1. `UL_IMG_007_A_SCREEN_01_04.png`
2. `UL_IMG_007_B_SCREEN_05_07.png`
3. `UL_IMG_007_C1_SIT_001_002.png`
4. `UL_IMG_007_C2_SIT_003_004.png`
5. `UL_IMG_007_C3_SIT_005_006.png`
6. `UL_IMG_007_C4_SIT_007_008.png`

대화 세션 제공 묶음:

- `UL_IMG_007_visual_boards_A_B_C1_C4.zip`

이 바이너리는 현재 GitHub connector의 텍스트 파일 쓰기 경계 때문에 저장소에 직접 업로드하지 않았다. 이 문서는 이미지 내용·판정·파일명을 정본화하며, 제품 자산 경로 편입은 별도 Asset Gate에서 수행한다.

## 2. 생성 실패 기록

이미지 생성 모델은 동일 브리프를 두 차례 감사·진행률 대시보드로 잘못 해석했다.

판정:

```text
artifact_type: PROJECT_AUDIT_DASHBOARD
required_type: IN_GAME_SCREEN_AND_SITUATION_BOARD
status: REJECTED_WRONG_ARTIFACT_TYPE
product_use: PROHIBITED
```

두 오생성 이미지는 다음 이유로 폐기한다.

- 실제 인게임 화면이 중심이 아님
- Base·GitHub·진행률 정보가 플레이 화면을 대체
- 직전 사용자가 금지한 과밀 단일 대시보드 형태
- 프로젝트명과 시스템 정보가 부정확하게 변형됨

재발 방지:

- 화면·상황 보드는 정밀 레이아웃 방식으로 생성
- 감사 보고서와 인게임 화면 브리프를 같은 이미지 요청에 혼합하지 않음
- Image ID와 artifact type을 생성 전 명시

## 3. 공통 검수

| 항목 | 판정 | 근거 |
|---|---|---|
| 화면 우선성 | PASS | 보고서가 아니라 인게임 프레임이 면적 대부분을 차지 |
| 보드 분리 | PASS | A·B·C1~C4를 별도 파일로 생성 |
| CURRENT/Target 혼합 방지 | PASS_WITH_LIMIT | 화면별 `APPROVED TARGET`, Legacy 요소만 별도 태그 |
| 다크 현대 오컬트 | PASS_FOR_WIREFRAME | 남색·먹색·청록·제한 포인트색·문서형 UI |
| 텍스트 노벨 표현 | PASS | 장소·반신 Placeholder·대사·2~4 선택지 구조 |
| 전문 화면 책임 | PASS | 준비·결과·일정·연구·보급·가설·노선·회수 분리 |
| 한글 가독성 | PASS_AT_1920 / TEST_REQUIRED_AT_1280 | 원본 1920×1080 판독 가능; 1280×720 실제 축소 검증 필요 |
| 캐릭터 최종 그림체 | NOT_APPLICABLE | 계획 Wireframe이며 초상은 명시적 Placeholder |
| 권리·유사성 | PASS_FOR_PLANNING | 외부 이미지·특정 IP·사용자 레퍼런스 원본 미사용 |
| 제품 자산 승인 | NOT_GRANTED | 계획 시각화이며 런타임·권리·실제 에셋 검수 전 |

## 4. 보드별 판정

### 보드 A — SCREEN-01~04

판정: `PASS_WITH_OPEN_P2`

확인:

- SCREEN-01에 캐릭터를 전면 표시하지 않음
- 새 기록·이어하기·DB·설정 위계가 명확함
- SCREEN-02가 텍스트 노벨 화면으로 읽힘
- SCREEN-03이 일정·시장·일상을 제거한 축약 준비로 보임
- SCREEN-04가 결과 4축을 첫 시선에 배치
- 결과 상세를 접힌 영역으로 후순위화

열린 위험:

- 메인 이어하기가 Legacy/Validation 저장을 충분히 구분하지 않음
- SCREEN-02 상단 최소 HUD의 `기록` 발견성은 실제 입력 검증 필요

### 보드 B — SCREEN-05~07

판정: `PASS`

확인:

- 하루 주요 활동 1개와 자동 기본 휴식이 분리됨
- 다일 활동 1/3→3/3이 연속 블록으로 보임
- 강제 출동 중단이 `2/3 완료·1일 재배치`로 명시됨
- 연구가 정답이 아니라 기록 정리·위험 완화임을 명시
- 기록국 보급실과 소문시장 Legacy를 구분
- 조달 품목의 보유·지급·잠김·자원 부족 상태가 색 외 문구로 표시됨

### 보드 C1 — SIT-001~002

판정: `PASS`

확인:

- 새 기록 시작과 기존 저장 덮어쓰기 확인을 분리
- 콜드 오픈에서 서로 다른 목적지 청취만 보여주고 원인을 확정하지 않음
- 브리핑은 확인 과제만 제시
- 금지 문구를 별도 위험 영역으로 표시

### 보드 C2 — SIT-003~004

판정: `PASS`

확인:

- 추천 편성을 그대로 사용해도 진행 가능하게 보임
- 준비 영향은 피해·기록 비교·복구 보조만 제시
- 텍스트 조사에서 선택 결과와 기록 획득 시각이 연결됨
- 숨긴 기능 무부작용을 별도 계약으로 표시

### 보드 C3 — SIT-005~006

판정: `PASS_WITH_OPEN_P2`

확인:

- 가설 4개 중 2개 제거와 남은 2개를 분리
- `23:57:42 < 23:59:08` 시간순 증거가 첫 원인 판단에 연결됨
- 가설 화면과 노선 복원 화면의 조작 책임이 구분됨
- 노선 실패 시 재시도·미해결 철수·전체 초기화 금지를 표시

열린 위험:

- 최초 원인과 현장 매개 역할의 차이를 초회 플레이어가 문구만으로 설명하는지 사람 검증 필요

### 보드 C4 — SIT-007~008

판정: `PASS_WITH_HUMAN_RISK_OPEN`

확인:

- 전조→분류→기록→행동→현장 결과→추론 검증 순서가 보임
- 두 패턴을 서로 다른 분류·행동 카드로 구분
- 능력치·성공률·동료 예측 비노출을 명시
- 결과 4축과 요약 등급을 분리
- 첫 결과 화면과 상세·환류의 위계를 분리

열린 위험:

- `스피커 전원을 내린다`, `투명 격리 용기에 넣는다`가 기록을 읽지 않아도 가장 안전해 보일 수 있음
- 행동 라벨 단독 선택률과 기록 확인 뒤 선택률을 분리 측정해야 함

## 5. P2 Finding

### V-007-01 — Legacy/Validation 이어하기 구분

- 심각도: P2
- 현재: 사건명·조사 단계만 표시
- 권장: `기존 진행` / `Validation 기록` 텍스트 Badge 추가
- 검증: 첫 시선에서 저장 유형과 복귀 예상 지점을 설명 가능한가

### V-007-02 — 최소 HUD 발견성

- 심각도: P2
- 현재: 사건명·장소·기록·설정
- 위험: 기록 Drawer가 장식처럼 보일 수 있음
- 권장: 신규 기록 발생 시 제한적 Badge·한 줄 피드백
- 금지: 상시 수집률·자동 예측률

### V-007-03 — 회수 행동의 정답 모양

- 심각도: P2 / Human Gate
- 권장: 행동 문구의 안전함을 동일 수준으로 유지하고 기록 연결을 보지 않으면 확신할 수 없게 함
- 검증: 라벨만 본 선택률 / 기록 확인 뒤 선택률 / 이유 설명

### V-007-04 — 1280×720 한국어 축소

- 심각도: P2
- 권장: 실제 제품 구현에서 본문·선택지·상태 문구 최소 크기 검증
- 현재 보드는 1920×1080 계획 시각화이므로 제품 폰트 수치를 확정하지 않음

### V-007-05 — 최종 아트 부재

- 심각도: P2 / Expected
- 현재: 캐릭터·배경은 Wireframe Placeholder
- 권장: 정보 구조 승인 뒤 별도 고유 캐릭터·배경 브리프
- 금지: 이 Wireframe을 최종 캐릭터/배경 에셋으로 간주

## 6. 적대적 검토

공격 질문:

- 예쁜 대시보드가 인게임 화면을 대체했는가? → `NO`
- 한 보드에 모든 화면을 과밀하게 몰았는가? → `NO`, A·B·C1~C4 분리
- CURRENT와 Target이 한 화면처럼 섞였는가? → `NO`, Legacy는 별도 Badge
- 결과 4축이 보고서 상세에 묻혔는가? → `NO`
- 준비·연구·보급이 정답을 제공하는가? → `NO`
- 회수 행동이 버튼 모양만으로 정답을 누설할 가능성이 있는가? → `YES / HUMAN_TEST_REQUIRED`
- 실제 그림체와 에셋이 승인됐는가? → `NO / NOT_PRODUCT_ASSET`

## 7. 최종 판정

```yaml
planning_visualization: APPROVED
information_architecture: PASS_WITH_OPEN_P2
visual_direction_fit: PASS_FOR_WIREFRAME
actual_product_asset: NOT_APPROVED
runtime_readability: NOT_RUN
human_understanding: NOT_RUN
implementation_authority: NONE
next_gate: PLAYTEST_PACKAGE_AND_P2_TASKS
```

이 판정은 화면 책임과 정보 위계의 기획 시각화를 승인한다. 실제 제품 UI·캐릭터·배경·에셋·폰트·좌표·Godot 구현을 승인하지 않는다.

## 8. 다음 Gate

```text
UL-IMG-007 Sheet 검수 로그 동기화
→ Validation 플레이테스트 패키지 통합
→ V-007-01~04 과제·중단 기준 반영
→ 최종 기획 적대적 검토
→ 사용자 기획 최종 승인 상태 기록
→ 상위 정본 Canon Pass
```
