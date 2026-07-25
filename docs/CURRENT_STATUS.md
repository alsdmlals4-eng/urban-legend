# Current Project Status

> 문서 위치: `docs/CURRENT_STATUS.md`  
> 프로젝트 코어: `docs/PROJECT_CORE.md`  
> 상세 설계: `docs/GAME_DESIGN_DOCUMENT.md`  
> 승인 설계: `docs/superpowers/specs/2026-07-25-annual-raising-visual-novel-design.md`  
> 구현 계획: `docs/superpowers/plans/2026-07-25-annual-raising-vertical-slice-implementation-plan.md`

이 문서는 구현, 자동 검증, 렌더링·입력 QA, 신규 플레이어 검증을 분리한다. `BUILD_READY`와 `RENDERED_QA_PASSED`는 `POC_PASSED`, 연간 루프 통과, 제작 확대 승인을 뜻하지 않는다.

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
| ANNUAL-MVP-001 구현 | `BUILD_READY` — PR #62 / commit `88522ce08f261bce6d61a8043c64caa3b982bd47` |
| 렌더링·입력 QA 통합 | `RENDERED_QA_PASSED` — PR #65 / commit `b4f2e224bf7a2a6ee511c83bbbd45cd9e0b8570a` |
| 최종 자동 검증 | `PASSED` — visual run #24, ANNUAL run #89, 문서 run #245 |
| 렌더링·텍스트 검토 | `PASSED` |
| 키보드 포커스·확인·Esc | `PASSED` |
| 세 출동 경로 scripted QA | `PASSED` |
| 수동 마우스 QA | `NOT_RUN` |
| 신규 플레이어 검증 | `NOT_RUN` |
| POC_PASSED | `NOT_DECLARED` |
| annual loop passed | `NOT_DECLARED` |
| 제작 확대 | `NOT_APPROVED` |

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

## 렌더링·입력 QA 결과

PR #65에서 실제 그래픽 Window와 Noto CJK 글꼴을 사용해 1280×720·1920×1080 화면을 생성하고 발견된 결함을 수정했다.

- ANNUAL Scene에 공용 현대 오컬트 Theme과 어두운 배경 적용
- Linux·Windows·macOS용 한글 시스템 글꼴 후보 지정
- embedded CORE 조사 패널의 가로·세로 확장 복구
- 단계·활동·역량·회수 품질·지식 품질 내부 ID 현지화
- embedded CORE 단계·이해도 현지화
- 초기 키보드 포커스 적용
- `ui_accept` 활동 선택과 Esc 선택 취소 확인
- 조기 출동: week 2 / risk 0 / 정상 회수 / 검증 완료
- 지연 출동: week 3 / risk 15 / 대가를 치른 회수 / 검증 완료
- 긴급 출동: week 3 forced / risk 30 / 긴급 회수 / 후보 기록
- 분기 결산이 최종 엔딩이 아님을 한국어로 표시

최종 QA 증거:

- Visual workflow run #24: PASS
- ANNUAL workflow run #89: PASS
- 문서 계약 run #245: PASS
- 대표 visual artifact id `8617041311`
- CORE focused 4/4
- ANNUAL focused 6/6
- 전체 Godot 회귀 49/49

시각 방향 판정은 `KEEP / AMPLIFY`다. 읽기·경로 구분·결산 의미는 유지하고, 최종 제품에서는 넓은 여백을 일러스트·텍스트 노벨 장면·상태 카드로 재구성한다.

## 충돌 해석 우선순위

구현·문서·기존 코드가 충돌할 때는 다음 순서로 해석한다.

1. 사용자가 승인한 최신 연도제 설계
2. 승인된 ANNUAL-MVP 구현 계획
3. `CURRENT_STATUS`·`PROJECT_CORE`·GDD 활성 정본
4. 기존 PoC와 레거시 구현

최신 기획을 우선하되 보호 경로, 저장 비침범, 기존 CORE 하위 호환 계약은 유지한다.

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

1. 실제 포인터를 사용한 수동 마우스 QA
2. 신규 플레이어의 조기·지연·긴급 출동 경로 플레이
3. 육성→사건→연구 인과와 동료 자동 지원 공정성 설명 수집
4. 전체 루프를 `KEEP / AMPLIFY / CHANGE / RETEST / HOLD`로 판정
5. 별도 사용자 승인 전 ANNUAL-MVP-002와 제작 확대 시작 금지
