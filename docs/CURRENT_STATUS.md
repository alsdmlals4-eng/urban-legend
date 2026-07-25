# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 승인 설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`  
> 구현 계획: `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`

이 문서는 구현, 자동 검증, 사람 눈 QA, 플레이 검증을 분리한다. `BUILD_READY`는 자동 계약과 회귀를 통과한 격리 수직절편을 뜻하며 `POC_PASSED`, 연간 루프 통과, 제작 확대 승인을 뜻하지 않는다.

## 현재 기준

| 항목 | 현재 값 |
|---|---|
| 구현 기준선 | MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A |
| 화면 버전 | Ver 4.2 |
| 저장 Schema | `mvp-039` (`mvp-038` 이관 지원) |
| 엔진 | Godot 4.7.1 / GDScript |
| 플랫폼 | PC / Steam, 16:9, 마우스·키보드 |
| 주인공 | 권나래 고정 |
| 사건 코어 | CORE-MVP-001 `POC_BUILD_READY` |
| 사건 코어 main 통합 | PR #55 / commit `8d0bf91a2e31538d3c0f142c800a84e8e3693889` |
| 연도제 설계 | `APPROVED_DESIGN_BASELINE` |
| 정본 전환 | `COMPLETE` — PR #61 |
| ANNUAL-MVP-001 구현 | `BUILD_READY` — PR #62 merged |
| ANNUAL-MVP-001 main 통합 | commit `88522ce08f261bce6d61a8043c64caa3b982bd47` |
| 자동 검증 | `PASSED` — PR #62 ANNUAL run #63, CORE run #131 |
| 사람 눈 UI·텍스트 QA | `NOT_RUN` |
| 플레이 검증 | `NOT_RUN` |
| POC_PASSED | `NOT_DECLARED` |
| annual loop passed | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

## 정본 충돌 해결 순서

기획·문서·구현이 충돌할 때 다음 순서를 적용한다.

1. 최신 사용자 지시
2. 사용자 승인 연도제 설계 `APPROVED_DESIGN_BASELINE`
3. 승인된 ANNUAL 구현 계획과 활성 `CURRENT_STATUS`·`PROJECT_CORE`·GDD
4. 현재 `main`의 검증된 구현 계약
5. 기존 PoC·레거시 문서·과거 구현

최신 기획을 우선하되, 기존 저장·보호 경로·하위 호환 계약은 명시적인 설계 변경과 별도 검증 없이 파괴하지 않는다. 레거시 구현이 최신 기획과 충돌하면 레거시 동작을 정본으로 승격하지 않고 adapter, compatibility layer, migration 또는 격리 경로로 처리한다.

## ANNUAL-MVP-001 구현 범위

```text
3주 × 주당 3개 일정 슬롯
→ 권나래 역량 4종·피로·기관 지원·오현 신뢰
→ 2주차 자율 출동 / 3주차 위험 증가·강제 출동
→ 오현 고유 스킬 + 기관·연구 공용 보조 스킬
→ 조건·확률·지원 준비도·남은 횟수 공개
→ 기본 장비 1개 + 연구 모듈 1개
→ 기존 CORE-MVP-001 embedded 실행
→ 사건 결과·괴이 매뉴얼 delta·잔향 자료
→ 사후 연구·공용 스킬 해금
→ 최종 엔딩이 아닌 분기 결산 모형
```

### 구현된 시스템

- 고정 JSON 데이터 계약과 Godot 런타임 검증기
- 주간 계획·주간 결과·출동 결정·준비·사건·연구·결산 상태 머신
- 조기 출동, 3주차 자율 출동, 긴급 강제 출동 실패 전진 경로
- 결정론적 동료 지원 resolver
  - 적합 조건에서만 판정
  - 신뢰·대인 역량·지원 준비도 기반 확률
  - 연속 불발 준비도 누적과 확정 발동
  - 관계 기반 대표 고유 스킬 전투당 보장
  - 동일 event key 캐시와 seed 재현
- CORE-MVP-001 선택적 확장점
  - 외부 지원은 체력 회복·위험 완화만 허용
  - 이해도·가설·관측 패턴·포획 표식 변경 금지
  - 기존 독립 실행과 F1 CORE 버튼 유지
- 육성 snapshot→사건 override adapter
  - 피로→시작 체력
  - 지연→시작 위험
  - 관찰→전조 판독 보조
  - 분석→중립 비교 정보
  - 현장 대응→피해 완화
  - 모듈→미관측 첫 피해 상한
- PoC 전용 저장 `user://annual_mvp_001_poc.json`
  - 기존 `GameState`, `mvp-039`, `mvp-038` 이관 비침범
  - 사건 진행 중 저장 금지
  - 저장 seed 기반 동료 판정 재현
- ANNUAL 전용 Scene과 F1 개발 진입
- 1280×720·1920×1080 기계적 레이아웃 계약

## 자동 검증 증거

PR #62 병합 전 최종 검증에서 다음이 모두 통과했다.

- Python 데이터·정적·활성 문서 계약: PASS
- Godot 4.7.1 import: PASS
- CORE-MVP-001 focused suite: 4/4 PASS
- ANNUAL-MVP-001 focused suite: 6/6 PASS
- 전체 Godot 회귀: 49/49 PASS
- 기존 CORE-MVP-001 기본 진입: PASS
- 기존 저장·보호 경로 비침범 정적 계약: PASS

이 자동 결과는 `BUILD_READY` 근거다. 한국어 장문 밀도, 키보드·마우스 실제 조작감, 육성 선택과 사건 결과의 체감 인과는 아직 사람 증거가 없다.

## 보호 경계

변경하지 않는다.

- `scripts/core/game_state.gd`
- 기존 `data/episodes/**`
- `scripts/scenes/investigation_scene.gd`
- `scripts/scenes/battle_scene.gd`
- `project.godot`
- `knowledge/base-pack/**`
- 저장 `mvp-039`와 `mvp-038` 이관

## 아직 구현하지 않은 범위

- 본편 1년 4분기 전체
- 동료 2명 동시 편성
- 관계·로맨스 연간 진행
- 중형·소형 일반 사건
- 신규 대표 조작형 규칙 검증 미니게임
- 본편 `GameState` 통합과 기존 save migration
- 연도 결산 계승 payload의 실제 다음 연도 소비
- ANNUAL-MVP-002~004

## 다음 게이트

1. 1280×720·1920×1080 사람 눈 UI·텍스트 QA
2. 조기 출동·지연 출동·긴급 출동 세 경로 플레이
3. 육성→사건→연구 인과와 동료 자동 지원 공정성 설명 수집
4. `KEEP / AMPLIFY / CHANGE / RETEST / HOLD` 판정
5. 통과 시 ANNUAL-MVP-002 진입 결정
