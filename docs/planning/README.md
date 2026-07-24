# 괴이 기록국 기획 인수인계 인덱스

> 문서 위치: `docs/planning/README.md` | 시작: `../../START_HERE.md` | 현재 상태: `../CURRENT_STATUS.md` | 코어: `../PROJECT_CORE.md`

이 폴더는 현재 구현, 확정된 최소 코어, 미구현 지원 방향, 검증 게이트를 구분하는 기획 진입점이다. 구현 사실이 충돌하면 현재 코드·데이터·테스트가 우선한다.

## 권장 읽기 순서

```text
START_HERE.md
→ AGENTS.md
→ docs/CURRENT_STATUS.md
→ docs/PROJECT_CORE.md
→ docs/planning/PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md
→ docs/superpowers/specs/2026-07-23-project-core-integrated-spec.md
→ MVP_ROADMAP.md
→ docs/superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md
→ TEST_CHECKLIST.md
→ 대상 코드·데이터·테스트
```

## 문서 책임

| 문서 | 책임 |
|---|---|
| `../PROJECT_CORE.md` | 최소 제품 정체성, 불변·지원·재승인 경계 |
| `PROJECT_CORE_STRESS_TEST_AND_BENCHMARK.md` | PR 검토, 진단 점수, P0/P1/P2, SWOT, VRIO, 벤치마크, PoC 근거 |
| `../superpowers/specs/2026-07-23-project-core-integrated-spec.md` | 확정 코어의 상태 머신·데이터·UI·페어플레이·수용 기준 통합 명세 |
| `PROJECT_DIRECTION.md` | 대상 플레이어, 시장 포지션, 방향 원칙 |
| `../GAME_DESIGN_DOCUMENT.md` | 조사·가설·이해도·전조·포획 상세 계약 |
| `ROADMAP_AND_HANDOFF.md` | 단계 의존성과 진입·종료 게이트 |
| `REFERENCE_CASES.md` | 채택·변형·제외한 벤치마크 원리 |
| `../CURRENT_STATUS.md` | 현재 구현과 미구현 목표 상태 구분 |
| `../../MVP_ROADMAP.md` | 현재 실행 순서 |
| `../superpowers/plans/2026-07-23-core-mvp-001-implementation-plan.md` | CORE-MVP-001의 정확한 파일·인터페이스·TDD·검증 순서 |
| `../../TEST_CHECKLIST.md` | 자동·수동 검증 계약 |

## 현재 프로젝트 위치

- 구현 완료선: MVP-043 + CORE-VALIDATION-001 + UX-PD-001 2A / Ver 4.2 / save `mvp-039`
- 프로젝트 코어: `CORE_RECORDED` / `CORE_STRESS_TESTED`
- 구현·플레이 검증: `POC_PENDING` / `HOLD_UNTIL_PLAYER_EVIDENCE`
- 현재 유일한 활성 구현 트랙: CORE-MVP-001
- CORE-MVP-002~004와 UX-PD-001 2B·2C, MVP-044~046은 게이트 대기 또는 재매핑 상태

## 기획 판단 우선순위

1. 플레이어가 관측 가능한 근거로 규칙을 설명할 수 있는가
2. 가설과 지지·반박·미해결 근거를 직접 연결하는가
3. 조사 이해가 회수 전투의 전조 정보 우위로 바뀌는가
4. 대응 결과가 포획 조건과 매뉴얼 기록에 즉시 반영되는가
5. 실패가 난수 처벌이 아니라 위험 사례와 다음 질문이 되는가
6. 지원 시스템이 코어 질문보다 먼저 노출되지 않는가
7. 기존 저장·ID·보호 경로를 보존하는가

## 작업별 라우팅

| 작업 | 먼저 읽을 문서 | 검증 핵심 |
|---|---|---|
| CORE-MVP-001 조사·전투 PoC | 통합 명세, 구현 계획, 스트레스 보고서 | 규칙 설명, 근거 배제, 전조 인과, 난수 공정성, 저장 비침범 |
| 사건 작성 | 코어, 통합 명세, `urban-legend-investigation-case-authoring` | 전조·가설·지지·반박·미해결·위험 사례·포획 |
| UI 정보 위계 | 통합 명세, GDD, 점진 공개 기획 | 전조·근거·대응 의도·직전 결과 우선 |
| 포획·연구 | CORE-MVP-002 진입 뒤 | 영구 매뉴얼과 현장 이해도 분리 |
| 챕터·의뢰 | CORE-MVP-003 진입 뒤 | 의뢰 비필수, 공통 인지 문법, 일정 압박 |
| 히든 분기·엔딩 | CORE-MVP-004 진입 뒤 | 대안 결과, 상위 정답화 금지 |
| 벤치마킹 | `REFERENCE_CASES.md`와 최신 1차 출처 | ADOPT/ADAPT/AVOID/TEST/IGNORE |

## 업데이트 규칙

- 코어 변경은 `PROJECT_CORE.md`, 통합 명세, 스트레스 보고서, GDD, 로드맵, 테스트를 함께 심사한다.
- 구현 계획은 CORE-MVP 단위로 분리하고 후속 시스템을 선구현하지 않는다.
- 구현 완료와 사용자 승인 설계를 혼합하지 않는다.
- 플레이 증거 없이 `PRODUCTION_READY`를 선언하지 않는다.
- 외부 사례는 표면 기능이 아니라 현재 결정을 바꿀 원리만 기록한다.
- 완료 상세와 과거 버전은 `docs/archive/backup/YYYY-MM-DD/`로 이동한다.
