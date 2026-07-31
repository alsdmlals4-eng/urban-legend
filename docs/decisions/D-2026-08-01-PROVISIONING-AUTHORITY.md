# D-2026-08-01-PROVISIONING-AUTHORITY — 기록국 보급실과 소문시장 책임 분리

> 상태: `APPROVED_PLANNING_BASELINE`
> 승인일: 2026-08-01
> 사용자 승인: “권장안대로 진행”
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`

## 1. 결정

정식 제품의 SCREEN-07 권위는 `기록국 보급실`이 소유한다.

기존 `소문시장`은 삭제하지 않고 외부 접점의 제한 콘텐츠로 보존한다.

```text
기록국 보급실
= 정규 준비·조달·지급·비교

소문시장
= 비공식 외부 접점·관계·특수 거래 이벤트
```

두 경로를 하나의 상점이나 동일 경제 화면으로 합치지 않는다.

## 2. SCREEN-07 기록국 보급실

### 명칭

- 세계관 명칭: `기록국 보급실`
- 화면 분류명: `보급·조달`

### 주요 자원

- 기관 지원도
- 잔향 자료
- 사건별 허가
- 연구 완료 조건

개인 돈·생활비·무한 구매 판매는 핵심 자원으로 사용하지 않는다.

### 주요 품목

- 정식 장비
- 연구·현상 계열 모듈
- 제한된 현장 소모품
- 기관 지급품과 사건 허가품

### 정보 위계

```text
현재 사건·편성·예상 위험
→ 이번 출동에 관련된 품목 범주
→ 보유 / 신규 / 잠김 / 지급 가능
→ 현재 장비와 효과 비교
→ 비용·기록·연구·허가 조건
→ 조달 확정
→ SCREEN-03 축약 준비로 복귀
```

### 상태

- `OWNED`
- `AVAILABLE`
- `LOCKED_RESEARCH`
- `LOCKED_RECORD`
- `LOCKED_AUTHORIZATION`
- `INSUFFICIENT_RESOURCE`
- `REQUISITIONED_FOR_MISSION`

잠김 상태는 부족한 조건을 텍스트로 설명한다.

## 3. 소문시장

소문시장은 정규 장비 성장의 필수 경로가 아니다.

허용 책임:

- 외부 세력·정보 중개자와의 관계 장면
- 제한된 특수 거래
- 세계관 정보와 선택적 위험·대가
- Showcase 이후 별도 검증된 사건성 콘텐츠

금지 책임:

- 필수 단서·필수 장비·정답 가설 독점
- 반복 판매·가격 차익을 중심으로 한 경제
- 정규 보급실과 동일한 전 품목 목록
- Validation Cut의 필수 진행 경로

Validation Cut에서는 소문시장 진입과 관련 단축 버튼을 숨긴다.

## 4. 사건·연구 환류

```text
사건 결과
→ 기록·잔향·연구 질문 획득
→ SCREEN-06 연구
→ 장비·모듈·지급 조건 해금
→ SCREEN-07 기록국 보급실
→ SCREEN-03 축약 준비
→ 다음 사건
```

조달품은 조사 결과를 소비 가능한 준비 수단으로 바꾸지만, 새로운 사건의 정답을 제공하지 않는다.

## 5. 페어플레이 경계

보급품이 허용하는 효과:

- 피해·위험 완화
- 기록 가독성 보조
- 입력 허용 오차 보정
- 검증된 규칙의 현장 적용 보조
- 재시도·후퇴·보호 조건 개선

보급품이 금지되는 효과:

- 신규 핵심 단서 생성
- 정답 가설 표시
- 미관측 패턴 공개
- 잘못된 규칙 적용을 성공으로 변경
- 관계·시장 난수에 필수 진행 조건 배치

## 6. Benchmark Gate

```yaml
screen_07_procurement_shop: PASSED
benchmark: docs/benchmarks/SCREEN_07_PROCUREMENT_TARGETED_BENCHMARK_2026-08-01.md
sample_size: 3
internal_procurement_authority: APPROVED
external_market_separation: APPROVED
implementation_authority: NONE
human_validation: NOT_RUN
```

## 7. 대체 관계

이 결정은 `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS`의 SCREEN-07 명칭·책임 Gate를 확정한다.

현재 `scripts/scenes/market_scene.gd`와 소문시장 데이터는 `CURRENT_IMPLEMENTATION_LEGACY / OPTIONAL_EXTERNAL_CONTACT`로 보존하며, 제품 권위 화면으로 승격하지 않는다.
