# SCREEN-07 보급·조달 화면 목적형 Benchmark — 2026-08-01

> 상태: `BENCHMARK_COMPLETE / GATE_PASSED`
> 대상: SCREEN-07 기록국 보급실과 기존 소문시장의 책임 분리
> 범위: 직접 관련 사례 3개
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`

## 1. 검토 질문

괴이기록국의 정식 준비 루프에서 장비·모듈·현장 소모품을 확보하는 화면과, 세계관상 비공식 외부 거래 접점을 같은 상점으로 합쳐야 하는가?

검토 기준은 다음과 같다.

- 사건·연구 결과가 다음 준비로 자연스럽게 환류하는가
- 내부 기관 조달과 외부 시장의 서사적 책임이 구분되는가
- 반복 구매·판매 노동을 만들지 않는가
- 출동 직전 필요한 비교와 조건을 명확히 보여주는가
- 장비가 핵심 단서·정답을 대신하지 않는가

## 2. 비교 사례

### 사례 A — XCOM 2: 기지 자원과 Black Market의 분리

공식 가이드는 기지에서 Supplies로 인력·병력을 확보하는 경로와, Intel을 사용해 물품·인력을 얻는 Black Market 경로를 별도로 설명한다.

적용할 원칙:

- 기관 내부의 정규 확보 경로와 외부·비공식 거래 경로를 분리한다.
- 두 경로는 같은 자원·같은 목록을 공유하는 단일 상점이 아니어야 한다.
- 외부 시장은 전략적 예외와 관계·정보 접점으로 사용한다.

그대로 따르지 않을 요소:

- 반복 판매와 가격 차익 중심 경제
- 필수 성장 인력을 무작위 외부 시장에 의존시키는 구조

출처:

- XCOM 공식 Rookie's Guide: https://xcom.com/news/en-rookie-s-guide-to-xcom-2/
- 2K Support XCOM 2 FAQ: https://support.2k.com/hc/en-us/articles/216650707-XCOM-2-FAQ

### 사례 B — Darkest Dungeon: 임무 확정 뒤 출동 전 Provisions

Provisions는 임무와 팀을 정한 뒤 출동 전에 필요한 소모품을 준비하는 별도 단계다. 던전 길이와 위험에 따라 필요한 양이 달라진다.

적용할 원칙:

- 보급 화면은 일반 쇼핑보다 `이번 출동에 무엇이 필요한가`를 먼저 보여준다.
- 사건·편성·예상 위험과 조달 목록을 연결한다.
- 구매 후 바로 출동 준비 화면으로 돌아갈 수 있어야 한다.

그대로 따르지 않을 요소:

- 매 임무마다 대량 수량을 반복 계산하는 소모품 노동
- 남은 물품 환불·재판매 최적화를 핵심 재미로 만드는 구조

출처:

- Official Darkest Dungeon Wiki — Provisions: https://darkestdungeon.wiki.gg/wiki/Provisions
- Official Darkest Dungeon Wiki — Inventory: https://darkestdungeon.wiki.gg/wiki/Inventory

### 사례 C — Control: 사건·구역 재료를 사용하는 Astral Constructs

Control은 현장에서 얻은 Source와 구역별 재료를 무기 형태와 모드 제작·강화로 환류한다. 재료의 출처가 장비 성장과 연결된다.

적용할 원칙:

- 괴이 기록·잔향 자료·연구 완료가 조달 조건과 연결돼야 한다.
- 잠김 상태는 부족한 기록·연구·기관 조건을 설명해야 한다.
- 단순 화폐 가격보다 `어떤 사건에서 얻은 무엇이 필요한가`를 보여준다.

그대로 따르지 않을 요소:

- 결과를 예측하기 어려운 무작위 모드 제작
- 반복 재료 파밍과 등급 인플레이션

출처:

- Control 공식 사이트 — Character and Weapon Mods Guide: https://legacy.controlgame.com/a-guide-to-the-best-character-and-weapon-mods-in-control/

## 3. 프로젝트 적용 결론

### 정식 제품 권위

`SCREEN-07 기록국 보급실`을 정식 준비·조달 화면으로 둔다.

- 세계관 명칭: `기록국 보급실`
- 화면 분류명: `보급·조달`
- 주요 자원: 기관 지원도, 잔향 자료, 사건 허가, 연구 완료 조건
- 주요 품목: 장비, 모듈, 제한된 현장 소모품
- 연결: 결과·연구 → 보급실 → 축약 준비 → 사건

### 외부 접점

기존 `소문시장`은 삭제하지 않고 외부 접점의 제한 콘텐츠로 보존한다.

- 관계·정보·특수 거래 이벤트
- 정규 준비 루프의 필수 경로가 아님
- Validation Cut에서는 비노출
- Showcase 이후 별도 검증 전 반복 시장 경제로 확장하지 않음

## 4. 정보 위계 권장안

```text
현재 사건·편성·예상 위험
→ 이번 출동 추천 범주
→ 보유 / 신규 / 잠김 / 지급 가능
→ 현재 장비와 효과 비교
→ 비용·기록·연구·허가 조건
→ 조달 확정
→ 축약 준비로 복귀
```

## 5. 페어플레이 경계

보급품은 다음을 할 수 있다.

- 피해와 위험 완화
- 입력 허용 오차와 기록 가독성 보조
- 검증된 규칙의 현장 적용 보조
- 재시도·후퇴·보호 조건 개선

보급품은 다음을 하지 않는다.

- 신규 핵심 단서 생성
- 정답 가설 표시
- 미관측 패턴 공개
- 오답을 성공으로 변경
- 필수 기록을 외부 시장에 독점 배치

## 6. Benchmark Gate

```yaml
screen_07_procurement_shop: PASSED
sample_size: 3
internal_procurement_authority: APPROVED_RECOMMENDATION
external_market_separation: APPROVED_RECOMMENDATION
validation_visibility: HIDDEN
implementation_authority: NONE
human_validation: NOT_RUN
```
