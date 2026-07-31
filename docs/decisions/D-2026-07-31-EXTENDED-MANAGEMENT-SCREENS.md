# D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS — 일정·연구·상점 화면 추가

> 상태: `APPROVED_PLANNING_BASELINE`
> 승인일: 2026-07-31
> 사용자 지시: “일정, 연구파트, 상점 화면도 만들어야해”
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`

## 1. 승인 결정

괴이기록국의 `상황별 인게임 화면 명세 보드`와 후속 SCREEN 정본은 기존 필수 기준 화면 4종에 다음 세 화면을 추가한다.

- `SCREEN-05 일정·운영 화면`
- `SCREEN-06 연구 화면`
- `SCREEN-07 상점·보급 조달 화면`

따라서 프로젝트 기준 화면은 총 7종이다.

1. SCREEN-01 메인 화면
2. SCREEN-02 텍스트 노벨 조사·핵심 플레이 화면
3. SCREEN-03 준비·자원 관리 화면
4. SCREEN-04 결과 화면
5. SCREEN-05 일정·운영 화면
6. SCREEN-06 연구 화면
7. SCREEN-07 상점·보급 조달 화면

이 승인은 화면의 존재와 책임을 정하는 기획 기준선이며 실제 Scene·Script·데이터·에셋 구현을 승인하지 않는다.

## 2. SCREEN-05 일정·운영 화면

### 목적

플레이어가 제한된 기간 안에서 훈련·기관 업무·괴이 연구·장비 정비·휴식·동료 교류를 배치하고, 사건의 징후와 출동 시점을 판단하게 한다.

### 책임

- 4주 × 7일 시간 구조
- 일정별 1~3일 소비
- 현재 주차·남은 일수
- 사건 징후와 출동 마감
- 일정 선택 전 결과 범주 미리보기
- 피로·동료·연구·기관 지원 변화
- 지난주 복사·템플릿·취소 등 반복 조작 완화

### Validation 경계

Validation Cut에서는 전체 연간 운영을 강제하지 않는다. SCREEN-03의 축약 준비가 사건 진입을 담당하고, SCREEN-05는 전체 제품의 장기 운영 기준 화면과 Showcase Cut 후보로 설계한다.

## 3. SCREEN-06 연구 화면

### 목적

사건에서 획득한 관측 기록·잔향 자료·위험 사례가 다음 사건의 질문·장비·모듈·지원 수단으로 환류되는 과정을 보여준다.

### 책임

- 연구 분야와 노드
- `LOCKED / AVAILABLE / IN_PROGRESS / COMPLETED`
- 선행 조건과 필요한 사건 기록
- 자원 비용과 진행 기간
- 동시 진행 프로젝트 최대 2개
- 완료 시 해금되는 질문·장비 모듈·지원 기능
- 관련 괴이 매뉴얼·사건 기록 바로가기
- 연구가 정답을 직접 제공하지 않는다는 경계

### 제품 경계

연구는 핵심 단서의 진위나 정답 가설을 자동 판정하지 않는다. 관측 정리, 피해 완화, 질문 확장, 장비·지원 해금만 담당한다.

## 4. SCREEN-07 상점·보급 조달 화면

### 명칭

플레이어가 이해하기 쉬운 화면 분류명은 `상점`으로 유지할 수 있으나, 세계관 내부 명칭은 `기록국 보급실`, `조달 창구`, `현장 장비과` 중 하나를 후속 화면 정본에서 결정한다.

### 목적

반복적인 일반 상점 경제가 아니라, 기관 승인과 사건 자료를 사용해 출동 장비·모듈·소모성 지원을 확보하고 비교하게 한다.

### 사용 자원

- 기관 지원도
- 잔향 자료
- 필요 시 사건별 허가·연구 완료 조건

개인 돈·생활비·무한 구매 판매를 핵심 루프로 만들지 않는다.

### 책임

- 장비·모듈·현장 소모품 분류
- 보유·신규·잠김·구매 가능 상태
- 현재 장비와 비교
- 비용과 해금 조건
- 사건·연구·기관 등급 연계
- 구매 또는 지급 후 SCREEN-03 준비 화면으로 연결
- 환불·매각·내구도 경제는 별도 승인 전 제외

### 페어플레이 경계

조달품은 다음을 할 수 있다.

- 입력·관측 허용 오차 조정
- 피해·위험 완화
- 기록 가독성 개선
- 포획 창·재시도 조건 보조
- 연구 자원 보정

조달품은 다음을 하지 않는다.

- 신규 핵심 단서 생성
- 정답 가설 표시
- 미관측 패턴명 공개
- 잘못된 규칙 적용을 성공으로 변경

## 5. 화면 보드 구성 원칙

한 장에 7개 화면을 모두 지나치게 작게 넣지 않는다.

권장 출력은 다음 두 장이다.

### 보드 A — 핵심 플레이 4종

- SCREEN-01 메인
- SCREEN-02 텍스트 노벨 조사
- SCREEN-03 준비
- SCREEN-04 결과
- 핵심 상황 시퀀스 일부

### 보드 B — 운영·성장 3종

- SCREEN-05 일정
- SCREEN-06 연구
- SCREEN-07 상점·보급 조달
- 일정 → 연구 → 조달 → 준비 → 사건의 환류 예시

요약용 한 장에서는 7종 미리보기를 사용할 수 있으나, 최종 판독용 보드는 화면을 충분히 크게 유지한다.

## 6. 근거 수준

- SCREEN-05: `CURRENT / PROPOSED_REFINEMENT`
  - ANNUAL-MVP-002 일정 화면과 4주×7일 계약 존재
- SCREEN-06: `CURRENT / PROPOSED_SEPARATION`
  - 연구 데이터·진행·해금 구현과 설계 존재, 독립 기준 화면 정본은 추가 필요
- SCREEN-07: `INFERRED / PROPOSED`
  - 기관 지원도·잔향 자료·장비·모듈 계약은 존재하나 독립 상점 Scene은 확인되지 않음

CURRENT와 PROPOSED는 보드와 문서에서 분리한다.

## 7. Benchmark Gate

```yaml
screen_05_schedule:
  gate: REUSED
  basis: annual genre benchmark and ANNUAL-MVP-002 validation artifacts
screen_06_research:
  gate: REUSED_WITH_TARGETED_LAYOUT_REVIEW
  basis: ANNUAL-MVP-002 companion/equipment/research design
screen_07_procurement_shop:
  gate: TARGETED_BENCHMARK_REQUIRED
  basis: existing resource/equipment contracts but no approved independent shop UX
implementation_authority: NONE
```

SCREEN-07의 정확한 정보 구조와 명칭은 목적형 Benchmark를 통과한 뒤 승인한다.

## 8. 연결 Decision

- `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY`
- `D-2026-07-31-TEXT-NOVEL-CORE-PRESENTATION`
- `D-2026-07-31-VISUAL-ART-DIRECTION`
- `ANNUAL-MVP-002`

## 9. 다음 Gate

```text
SCREEN-01~07 목적형 Benchmark
→ 실제 Scene·Script·데이터 인벤토리
→ 각 화면 CURRENT / INFERRED / PROPOSED 구분
→ 상세 와이어프레임과 상태 변형
→ 보드 A·B 비주얼 콘셉트 제작
→ 사용자 화면 검수
→ 회수·결과 세부 기획 재개
```
