# 미니게임·회수 페이즈 규칙 범위 적대적 감사

> Decision ID: `DEC-20260805-117-CANON-V2-RESCUE-MINIGAME-AND-RETRIEVAL-RULE-COVERAGE`
> 감사 일시: 2026-08-05 KST
> 범위: GitHub 정본·Episode/Canon v2 데이터·Scene/script·자동 테스트·Google Sheet
> 결론: `APPROVED_WITH_GAPS_CLASSIFIED`
> 구현: `IMPLEMENTATION_NOT_AUTHORIZED`
> 사람 검증: `HUMAN_QA_NOT_RUN`
> UI·접근성 검증: `UI_ACCESSIBILITY_NOT_RUN`
> 병합: `MERGE_NOT_AUTHORIZED`
> Draft PR: #151
> 기반 PR: PR #149

## 1. 감사 질문

1. 피해자 구출 미니게임의 목적이 모든 정본에서 일치하는가.
2. 네 핵심 사건의 사건별 구출 문법이 데이터와 실행에 존재하는가.
3. 구출 위험·재시도·부분 성공·실패 전진 규칙이 실행 가능한 상태로 연결됐는가.
4. 구출 결과가 회수 초기 조건과 보호 의무로 전달되는가.
5. 회수 페이즈가 보호·관찰·대응·공격·장비·봉쇄·후퇴와 다중 결과를 지원하는가.
6. 구출과 회수 결과가 독립 저장·보고되는가.
7. 자동 테스트가 최신 제품 권위를 검증하는가.
8. Google Sheet가 정본·구형 구현·미구현 상태를 구분하는가.

## 2. 판정 등급

- **정본 준비 완료**: 승인된 설계·사건 데이터·계약이 존재한다.
- **부분 연결**: 필요한 데이터나 일부 adapter는 있으나 공용 실행·저장·결과까지 닫히지 않았다.
- **구형 구현 충돌**: 실행은 가능하지만 최신 제품 목적·규칙과 의미가 다르다.
- **미구현 갭**: 승인된 의미를 소비할 runtime·Schema·테스트가 없다.
- **사람 검증 미실행**: 시간·이해·입력·접근성 목표를 실제 사용자에게 검증하지 않았다.

## 3. 정본 문서 감사

| 대상 | 상태 | 판정 |
|---|---|---|
| `docs/decisions/D-2026-08-02-MAIN-CONTENT-INVESTIGATION-RECOVERY-AUTHORITY.md` | 조사→매뉴얼→구출→회수→기록, 회수 행동 어휘, 공격 단독 승리 금지 정의 | 정본 준비 완료 |
| `docs/decisions/D-2026-08-02-YEAR-ONE-QUARTERLY-SIMPLE-MINIGAME-VARIATION.md` | 30초 설명, 1~2 입력, 1~3분, 조사 지식 우선, 네 사건 문법 정의 | 정본 준비 완료 |
| `docs/decisions/D-2026-08-04-INVESTIGATION-PAGE-COMPLETION-GATE-AND-RESCUE-RISK-RETRY.md` | 안정→불안정→위험→임계→비가역 결과, 실질적 변경 재시도, 숨은 난수 금지 | 정본 준비 완료 |
| `docs/decisions/DEC-20260805-115-CANON-V2-RULE-STRIP-CONTINUITY.md` | 조사·구출·회수의 단일 매뉴얼 상태와 규칙 스트립 정의 | 정본 준비 완료 |
| `docs/decisions/DEC-20260805-116-CANON-V2-RESCUE-RETRIEVAL-ROLE-BOUNDARY.md` | 구출=사람 보호, 회수=현상 통제, 결과 독립·승인 철수 정의 | 정본 준비 완료 |
| `docs/MINIGAME_SYSTEM_SPEC.md` | 미니게임을 마지막 조사 행동·마지막 단서 획득으로 정의 | 구형 구현 충돌 |

### 결론

최신 권위는 충분히 구체적이다. 문제는 기획 부재가 아니라 구형 `MINIGAME_SYSTEM_SPEC.md`가 현행 의미와 함께 활성 문서처럼 남아 있다는 점이다. 후속 구현 PR은 이 파일을 호환 스펙 또는 이관 참고로 명시하고 새 구출 시스템 Spec을 별도 권위로 만들어야 한다.

## 4. Canon v2·Episode 데이터 감사

### `data/episodes/episode_001_afterlife_station_canon_v2.json`

**정본 준비 완료**

- 4단계 `rescue_protocol` 존재
- 공식 식별 정보·공식 경로·승차권·동행 하차 요구 존재
- 구출 위험 상태 존재
- 승인 철수·부분 진실 공개 정책 존재
- 세 개 `recovery_encounters` 존재
- 최초 정본·정상 클리어·S랭크·승인 철수·부분 공개·재현 숙련 결과 계약 존재

**미구현 갭**

- 공용 구출 Scene에서 `rescue_protocol`을 실행하는 adapter 없음
- 위험 상태를 공용 구출 상태기계로 변환하는 projection 없음
- 구조화된 구출 결과 패킷을 저장하고 회수에 전달하는 runtime 소비자 없음

### `data/episodes/episode_001_afterlife_station_canon_v2_runtime_projection.json`

**부분 연결**

- 세 정본 회수 패턴을 기존 `recovery_patterns` 형식으로 투영
- 전조·질문·근거 단서·정답/오답 대응·안정도 증가량 제공
- 구형 회수 패턴 대신 정본 ID를 사용

**미구현 갭**

- 구출 프로토콜 projection 없음
- 보호 의무·승인 철수·긴급 봉쇄·다중 결과 상태 projection 없음
- 결과 계약의 부분 진실 공개와 최초 정본/재현 숙련을 기존 결과 화면이 완전 소비하지 않음

### `data/episodes/episode_001_afterlife_station.json`

**부분 연결**

- 피해자 구조 결과 필드와 회수 관련 데이터 존재
- 기존 route minigame과 기존 저장·결과 pipeline 유지

**구형 구현 충돌**

- Canon v2 구출 프로토콜 대신 기존 노선 복원 미니게임 경로가 중심
- 구형 의미와 Canon v2 의미가 호환 layer를 통해 병존함

### `data/episodes/episode_002_red_umbrella_alley.json`

**구형 구현 충돌**

- `rain_dodge` 기반 무작위 회피가 현재 실행 구출 미니게임
- 최신 권위의 반사 차단·우산 격리·피해자/호위 역할 배치가 데이터 행동으로 구조화되지 않음
- 성공/실패 effect delta는 있으나 생존·분리·후유증·보호 의무 결과 패킷 없음

### `data/episodes/episode_003_dead_frequency_station.json`

**구형 구현 충돌**

- `rhythm_timing` 기반 박자 입력이 현재 실행 미니게임
- 최신 권위의 무음 구간·보호 범위·반환 대상 분리가 행동 데이터로 구조화되지 않음
- 성공/실패 effect delta는 있으나 복제 음성·부분 반환·보호 범위 결과 패킷 없음

### 기록되지 않은 병동

**미구현 갭**

- Google Sheet와 연간 기획에 사건 방향 존재
- 실행 Episode JSON, 구출 미니게임 데이터, 회수 패턴 runtime 없음

## 5. 공용 미니게임 실행 감사

### `scripts/scenes/minigame_scene.gd`

**구형 구현 충돌**

- `route_restore`, `rain_dodge`, `rhythm_timing` 세 타입 중심
- 성공/실패 bool과 effect delta를 `GameState.save_minigame_result()`로 전달
- 공통 4단계 구출 문법, 위험 단계, 부분 성공, 보호 의무, 회수 초기 조건이 공용 UI 계약으로 없음
- 저승역 route 성공은 회수 Scene으로 직접 이동하며 구조화된 인계 확인 단계가 없음

### `scripts/minigames/route_restore_game.gd`

**구형 구현 충돌**

- 튜토리얼/최종 타일 노선 연결 퍼즐
- 오답은 카운터·문구를 올리지만 안정→불안정→위험→임계 상태기계가 없음
- 초기화 후 반복 가능하며 부분 성공·구출 실패·비가역 결과를 emit하지 않음
- 최종 성공 하나만 완료 결과로 전달

### `scripts/minigames/rain_dodge_game.gd`

**구형 구현 충돌 — 높은 우선순위**

- 무작위 빗방울 생성과 이동 회피
- 제한 시간 생존과 피격 횟수로 성공/실패 판정
- 조사 지식보다 반사 신경과 난수 패턴이 결과에 큰 영향
- 빨간 우산 사건의 반사·우산·피해자·호위 역할 분리 문법을 소비하지 않음
- 동일 의미 상태는 동일 결과 원칙을 보장하기 어려움

### `scripts/minigames/rhythm_timing_game.gd`

**구형 구현 충돌 — 높은 우선순위**

- 정해진 박자 수와 타이밍 판정 중심
- 폐주파수 사건의 무음 구간·보호 범위·반환 대상 판단을 소비하지 않음
- 입력 완화는 일부 장비 tolerance에 의존하며 등가 접근성 계약이 구조화되지 않음

### `scripts/minigames/minigame_rules.gd`

**미구현 갭**

- 박자 hit, 이동 clamp, 사각 충돌, rain success/failure만 제공
- 공통 구출 위험 상태기계 없음
- 의미 기반 deterministic retry 없음
- 부분 성공·실패 전진·구출 결과 패킷 없음
- 접근성 대체 입력과 시간 압박 완화의 등가 판정 없음

## 6. 회수 실행 감사

### `scripts/scenes/battle_scene.gd`

**부분 연결**

- Canon v2 runtime projection의 전조·질문·응답·근거를 기존 회수 UI에서 소비 가능
- 올바른 대응은 안정도를 올리고 오대응은 요원 피해·정신 피해를 발생시킴
- 규칙 기반 패턴 판단이 기존 일반 공격보다 강화됨

**구형 구현 충돌**

- 안정도 임계치 도달 후 `_recover_anomaly_core()`가 `core_recovered`를 저장하는 단일 성공 경로 중심
- 보호·관찰·대응·공격·장비·봉쇄·후퇴가 명시적 동등 행동 상태기계로 분리되지 않음
- 봉쇄·긴급 봉쇄·승인 철수·부분 회수·실패 결과 enum 없음
- 구출 결과의 보호 의무와 회수 초기 조건을 소비하지 않음
- 전투 화면에서 조사/미니게임으로 돌아가는 경로가 승인 철수 결과로 기록되지 않을 수 있음

### `scripts/core/game_state.gd`

**부분 연결**

- `victim_state` 저장 공간 존재
- `minigame_results`와 `recovery_successful`, `recovery_result_status`, `recovery_result_stability` 존재
- 사건 보고서와 저장 payload에 미니게임·회수 결과를 포함

**미구현 갭**

- `save_minigame_result()`가 기본 성공/실패 bool 중심
- `save_recovery_result(successful, result_status, stability)`가 회수 단일 축 중심
- 구출 결과 패킷의 생존·분리·후유증·위험·보호 의무·초기 조건을 강제하는 계약 없음
- 구출과 회수의 독립 결과 상태기계 및 정본/재현 분리 소비가 불완전

### `scripts/scenes/result_scene.gd`

**부분 연결**

- 피해자 구조 결과와 후일담, 회수 상태, 미니게임 기록, 괴이 매뉴얼을 한 화면에 표시
- 사건 보고서와 판단 근거 패널 존재

**미구현 갭**

- 구출 결과와 회수 결과를 독립 축으로 구조화해 관문·상한·정본 확정하는 UI 없음
- 승인 철수·긴급 봉쇄·부분 진실 공개를 명시적 결과 상태로 완전 표시하지 않음
- 구출 결과 패킷의 후유증·보호 의무·초기 조건 인과를 복기하지 않음

## 7. 자동 테스트 감사

### `tests/minigame_rules_test.gd`

**현재 검증**

- rhythm tolerance
- 이동 clamp
- 빗방울 충돌
- rain 시간/피격 성공·실패

**누락**

- 공통 구출 상태기계
- 동일 의미 상태 deterministic 결과
- 부분 성공·실패 전진
- 접근성 등가 판정

### `tests/minigame_pipeline_test.gd`

**현재 검증**

- bool 성공/실패 저장
- game type·입력 요약·효과 요약 저장
- 사건 보고서 전달
- 완료 미니게임 효과 중복 적용 방지
- 진행 중 route 상태 비저장

**누락**

- 생존·분리·후유증·위험·보호 의무·회수 초기 조건
- 의미 변경 없는 재시도 차단
- 부분 성공과 비가역 결과
- 구출 결과가 회수 시작 상태로 적용되는지

### `tests/afterlife_migration/afterlife_runtime_projection_test.gd`

**현재 검증**

- Canon v2 record projection
- 세 정본 recovery pattern
- 전조·질문·관련 근거
- 정답/오답 대응과 정답 근거
- 구형 pattern 혼입 금지

**누락**

- `rescue_protocol` projection과 실행
- risk state 전이
- 구출 결과 패킷
- 승인 철수·긴급 봉쇄·다중 회수 결과
- 구출·회수 독립 결과 저장

### 이관 테스트 묶음

**정상 검증**

- Canon v2 loader
- ID disposition
- legacy save inspection
- pure memory migration
- transaction·rollback
- runtime projection
- Validation 활성화
- Windows/fixture/local runner preflight

**경계**

이 테스트들은 저장 이관의 안전성과 정본 패턴 투영을 보장한다. 새 구출·회수 제품 UX와 결과 상태기계가 구현됐음을 보장하지 않는다.

## 8. Google Sheet 감사

### 정합한 부분

- `40_핵심시스템_메인콘텐츠`에 저승역 구출·세 회수 패턴·구출/회수 독립 결과·승인 철수 정본 존재
- `50_메인콘텐츠`에 네 사건 차별화와 구출→회수 공통 루프 존재
- `51_미니게임`에 공통 구출 원칙과 여름·가을·겨울 변주 존재
- `60_UX_UI_접근성`에 구출·회수 화면과 접근성 방향 존재

### 누락·혼선

- `51_미니게임`의 초기 `UL-MINI-01/02/03` 클리커·퍼즐·룰렛 행이 현행 구출 권위와 상태 관계가 불명확함
- 저승역 봄 구출의 최신 Canon v2 4단계 절차가 `51_미니게임` 독립 행으로 부족함
- 구출 결과 패킷과 회수 다중 결과 상태가 Sheet에서 Schema 준비 상태로 분리되지 않음
- `80_데모_버티컬슬라이스_플레이테스트`에 공통 4단계 구출 이해·사건별 변주·인계 이해·승인 철수·접근성 등가를 직접 측정하는 테스트가 없음
- 일부 오래된 행은 `IMPLEMENTED` 또는 `PROVISIONAL_BASELINE`로 표시돼 최신 정본 대비 제품 완료 상태를 오해할 수 있음

## 9. 누락 우선순위

### P0 — 구현 전에 반드시 계약화

1. 구출 결과 패킷 Schema 의미와 migration
2. 공통 구출 위험·재시도 상태기계
3. 구출 결과→회수 초기 조건·보호 의무 adapter
4. 회수 다중 결과 상태와 승인 철수
5. 구출·회수 독립 결과 저장·보고

### P1 — 사건별 이관

1. 저승역 Canon v2 `rescue_protocol` 실행 adapter
2. 빨간 우산 `rain_dodge` 대체
3. 폐주파수 `rhythm_timing` 대체
4. 기록되지 않은 병동 Episode·구출·회수 제작
5. `MINIGAME_SYSTEM_SPEC.md` 현행 권위 상태 정리

### P2 — 검증·표현

1. 설명 30초·기본 1~3분 사람 검증
2. 키보드·포인터·게임패드·대체 입력
3. 시간 압박 완화와 랭크 감점 금지
4. 1280×720·1920×1080·텍스트 확대·모션 감소
5. 결과 보고서의 구출/회수 인과 복기

## 10. 적대적 실패 모드

- 공통 구조를 이유로 네 사건을 같은 버튼 순서로 만드는 것
- 사건 고유성을 이유로 매 사건 조작법을 처음부터 새로 학습시키는 것
- 구출을 마지막 단서 획득으로 되돌리는 것
- 빨간 우산을 무작위 회피 실력 시험으로 유지하는 것
- 폐주파수를 박자 성공으로만 해결하는 것
- 노선 퍼즐 성공을 피해자 구조·현상 회수·정답 확인으로 동시에 처리하는 것
- 구출 성공/실패 bool 하나로 모든 후속 결과를 계산하는 것
- `core_recovered` 하나로 봉쇄·회수·철수·실패를 뭉개는 것
- 접근성 완화를 낮은 랭크나 보상 감소로 처리하는 것
- Canon v2 sidecar가 있다는 이유로 제품 구현 완료를 선언하는 것
- 자동 이관 테스트 GREEN을 Human QA 통과로 오인하는 것

## 11. 최종 판정

- 공통 4단계 구출 문법과 네 사건의 변주 방향은 승인 가능하다.
- 저승역 Canon v2 정본 데이터와 회수 projection은 강한 기반이다.
- 현행 공용 미니게임과 회수 Scene은 최신 제품 권위를 완전히 구현하지 않았다.
- 가장 큰 누락은 구출 결과 패킷, 공통 위험/재시도 상태기계, 회수 다중 결과, 독립 결과 저장·보고다.
- 제품 구현·Human QA·접근성 QA·병합은 승인되지 않았다.

최종 상태: `APPROVED_WITH_GAPS_CLASSIFIED / IMPLEMENTATION_NOT_AUTHORIZED / HUMAN_QA_NOT_RUN / UI_ACCESSIBILITY_NOT_RUN / MERGE_NOT_AUTHORIZED`.
