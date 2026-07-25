# ANNUAL-MVP-001 렌더링·입력 QA 기록

> 날짜: 2026-07-25  
> 대상: ANNUAL-MVP-001 격리 수직절편  
> 기준 main: `b23d7556f0c0f07dadd2d3993caf95f4e1948e19`  
> QA 브랜치: `agent/annual-mvp-001-human-qa-20260725`  
> PR: #65  
> 상태: `RENDERED_QA_PASSED / MANUAL_PLAYER_VALIDATION_PENDING`

## 목적

ANNUAL-MVP-001의 기계적 레이아웃 계약을 넘어 실제 글리프·색상·줄바꿈·embedded 사건 화면·키보드 입력·세 출동 경로를 검토한다. 자동 통과와 신규 플레이어의 체감 인과 설명은 분리한다.

## 실행 환경

- Ubuntu 24.04 GitHub Actions
- Godot 4.7.1
- OpenGL3 / Xvfb / llvmpipe
- Noto CJK 시스템 글꼴
- 1280×720
- 1920×1080

## 검증 경로

### 조기 출동

```text
2주차 자율 출동
→ 시작 위험 0
→ 정상 회수
→ 검증 완료 매뉴얼
→ 분기 결산
```

### 지연 출동

```text
3주차 자율 출동
→ 시작 위험 15
→ 대가를 치른 회수
→ 검증 완료 매뉴얼
→ 분기 결산
```

### 긴급 출동

```text
3주차 재지연
→ 긴급 출동
→ 시작 위험 30
→ 긴급 회수
→ 후보 기록·위험 사례
→ 분기 결산
```

세 경로 manifest는 각각 `week 2 / risk 0`, `week 3 / risk 15`, `week 3 forced / risk 30`을 기록했다.

## 발견·수정

### 1. 한글 글리프와 공용 Theme 누락

초기 렌더링에서 ANNUAL Scene이 공용 Theme을 사용하지 않아 기본 회색 UI로 표시됐고, Linux 기본 글꼴 환경에서는 한글이 대체 글리프로 출력됐다.

수정:

- ANNUAL Scene 전용 themed wrapper 적용
- 공용 `UiThemeFactory` 사용
- `Noto Sans CJK KR`, `Noto Sans KR`, `Malgun Gothic`, `Apple SD Gothic Neo` 시스템 글꼴 후보 지정
- 현대 오컬트용 어두운 배경 적용

### 2. embedded CORE 조사 패널 축소

CORE-MVP-001 Scene을 `VBoxContainer`에 삽입할 때 루트 Control이 확장 크기를 받지 못해 조사 선택지와 매뉴얼 영역이 사실상 보이지 않았다.

수정:

- IncidentHost와 embedded Core root에 가로·세로 `SIZE_EXPAND_FILL` 적용
- InvestigationPanel 확장 계약 적용
- 1280×720과 1920×1080에서 조사 선택지·매뉴얼·스크롤 영역 노출 확인

### 3. 내부 ID 노출

단계·분기 결산에 `WEEK_PLANNING`, `normal_capture`, `verified`, `observation` 같은 내부 ID가 노출됐다.

수정:

- 주간 계획·출동 결정·출동 준비·사건 조사·분기 결산 단계명 현지화
- 활동명 현지화
- 역량명 현지화
- 정상 회수·대가를 치른 회수·긴급 회수 현지화
- 검증 완료·후보 기록 현지화
- embedded CORE 단계와 이해도 현지화

### 4. 키보드 초기 포커스와 Esc 취소

ANNUAL Scene에는 초기 포커스 복구와 Esc 입력 계약이 없었다.

수정:

- 현재 패널의 첫 활성 버튼에 초기 포커스 부여
- `ui_accept`로 주간 활동 선택 확인
- `ui_cancel`로 마지막 주간 선택 제거
- 사건 진행 중에는 embedded CORE의 입력 처리를 침범하지 않음

## 최종 검증 증거

### 렌더링·입력 workflow

- workflow: `Capture ANNUAL-MVP-001 Visual QA`
- run: #15
- result: PASS
- artifact: `annual-mvp-001-visual-qa`
- artifact id: `8617041311`
- artifact digest: `sha256:bb623881ef31a6e4f33cfd6884acbca29735187a1986beaaddd14c64f8353ca4`

통과 항목:

- Godot import
- 실제 그래픽 Window 생성
- 초기 키보드 포커스
- `ui_accept` 활동 선택
- Esc 선택 취소
- 22개 PNG 화면 생성
- 세 경로 manifest 생성
- 캡처 실패 0건

### 전체 회귀

- workflow: `Validate ANNUAL-MVP-001`
- run: #80
- result: PASS

통과 항목:

- Python 데이터·정적·활성 문서 계약
- Godot 4.7.1 import
- CORE-MVP-001 focused 4/4
- ANNUAL-MVP-001 focused 6/6
- 전체 Godot 회귀 49/49

## 시각 판정

### KEEP

- 한글 글리프와 기본 정보 계층은 읽을 수 있다.
- 조기·지연·긴급 출동의 주차·위험·결산 차이가 화면에 명시된다.
- 출동 준비에서 동료·공용 스킬·모듈·예상 체력·시작 위험이 한 화면에 보인다.
- embedded 조사 선택지와 매뉴얼 영역이 1280×720에서도 사용 가능하다.
- 분기 결산이 최종 엔딩이 아니라는 문구가 명확하다.

### AMPLIFY 후보

- 화면 중앙과 하단의 여백이 커서 최종 제품에서는 일러스트·텍스트 노벨 장면·상태 카드로 정보 밀도를 재구성할 필요가 있다.
- PoC 저장·불러오기·확인 버튼은 개발 도구 느낌이 강하므로 본편 HUD와 분리해야 한다.
- 상태 갱신 피드백은 구체적인 증가·감소 사유를 더 보여줄 수 있다.
- 실제 신규 플레이어가 육성 선택과 사건 차이를 설명하는지는 아직 확인하지 않았다.

## 현재 판정

```text
annual_mvp_001: BUILD_READY
rendered_visual_review: PASSED
keyboard_input_qa: PASSED
three_route_scripted_qa: PASSED
manual_mouse_qa: NOT_RUN
new_player_validation: NOT_RUN
annual_loop_passed: NOT_DECLARED
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
visual_direction: KEEP / AMPLIFY
```

`RENDERED_QA_PASSED`는 실제 렌더링과 입력 이벤트 검증을 뜻한다. 신규 플레이어의 체감 인과, 자동 지원 공정성 설명, 주간 반복 피로도는 별도 플레이 검증 전까지 통과로 선언하지 않는다.
