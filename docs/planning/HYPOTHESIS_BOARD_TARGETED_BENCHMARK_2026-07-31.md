# 저승역 가설 보드 목적형 벤치마크

> 상태: `BENCHMARK_GATE_PASSED_FOR_PLANNING`
> 추적: Issue #121 / Draft PR #122
> 기준 main: `656846865eb88871d00842a0da527ce1b0722b77`
> Work Mode: `PLAN`
> 구현 권한: `NONE`

## 1. 질문과 범위

이번 벤치마크는 대규모 장르 조사를 반복하지 않는다. 기존 프로젝트 조사와 Evidence Pack에서 다음 질문에 직접 필요한 사례만 재선별한다.

> 저승역에서 플레이어가 4개 규칙 가설을 관측 근거로 2개까지 제거하고, 남은 불확실성을 스스로 설명하게 하려면 가설 보드의 책임과 제한은 무엇이어야 하는가?

검토 대상은 다음 네 사례다.

1. The Case of the Golden Idol
2. Return of the Obra Dinn
3. Phoenix Wright: Ace Attorney
4. PARANORMASIGHT 및 적응형 조사 설계 사례

책임 입력:

- `docs/BENCHMARKING_REFERENCE_GUIDE.md`
- `docs/research/2026-07-26-genre-benchmark.md`
- `docs/research/2026-07-29-fair-play-hypothesis-board-evidence-pack.md`
- `data/episodes/episode_001_afterlife_station.json`

## 2. 사례 비교

| 사례 | 직접 관찰할 설계 포인트 | 괴이기록국 적용 | 제외·주의 |
|---|---|---|---|
| The Case of the Golden Idol | 장면에서 얻은 사실을 제한된 관계로 조립해 사건 설명을 완성한다. | `관측 사실`과 `해석`을 분리하고, 가설마다 지지·반박·미해결 근거를 연결한다. | 단어 끼워넣기와 무근거 조합 반복은 복제하지 않는다. |
| Return of the Obra Dinn | 충분한 근거가 모이기 전에는 결론을 보류하고 원 장면을 반복 확인한다. | 제거 조건이 충족되지 않은 후보는 강제로 지우지 않고 `미해결`로 유지한다. 모든 근거 카드에서 원문·관측 위치로 돌아갈 수 있게 한다. | 숨은 확정 임계치와 일괄 정답 확인은 사용하지 않는다. |
| Phoenix Wright: Ace Attorney | 결정적 모순이 있는 순간에 증거를 제시해 주장을 무너뜨린다. | 후보 제거에는 최소 하나의 명시적 반증 체인을 요구하고 제거 이유를 문장으로 남긴다. | 모든 장면을 재판식 증거 제시로 만들거나 오답 페널티를 반복하지 않는다. |
| PARANORMASIGHT·적응형 조사 사례 | 도시괴담 규칙을 여러 순서로 발견해도 진행이 이어지고, 실패 뒤 재검토가 가능하다. | 단서 획득 순서와 무관하게 동일한 관계 판정이 가능해야 하며, 실패는 위험 사례와 다음 질문을 남긴다. | 선택하지 않은 경로에만 필수 사실을 숨기거나 사후 규칙을 추가하지 않는다. |

## 3. 반영 결론

### 반드시 반영

- 가설 보드는 답안지가 아니라 `근거 관계 편집기 + 제거 이유 기록 + 최종 증명 + 실패 복기`다.
- 증거 카드에는 관측 사실, 출처, 원문 복귀, 현재 해석을 구분한다.
- 관계는 `지지 / 반박 / 미해결` 3종만 사용한다.
- 후보 제거에는 플레이어가 확인 가능한 반증 근거가 필요하다.
- 시스템 제안은 후보 강조에 그치며 자동 연결·자동 제거·자동 정답 확정을 하지 않는다.
- 단서 획득 순서가 달라도 같은 사실 관계를 재구성할 수 있어야 한다.
- 정답을 맞혀도 근거가 부족하면 `행동 성공 / 추론 미검증`으로 분리한다.

### 조건부 반영

- 4개 후보 중 2개 제거 구조는 저승역 Validation Cut에서만 우선 검증한다.
- 일반·소형 사건은 후보 2~3개와 단순 반증 1개로 축소할 수 있다.
- 시스템이 가능한 관계를 제안할 수 있으나 선택과 수정은 플레이어가 수행한다.

### 제외

- 자유 문장 입력을 필수 추리 방식으로 사용
- 단어 조합 정답 맞히기
- 모든 단서를 모든 가설에 반복 대입
- 숨은 점수로 후보 자동 제거
- 관계·동료·능력치에 의한 정답 확정
- 실패 후 새 규칙의 소급 공개

## 4. 저승역 적용 판단

현재 저승역 데이터는 다음을 제공한다.

- 방송 원본의 목적지 구간이 비어 있음
- 같은 시각에 서로 다른 목적지가 기억·표시됨
- 막차 이후 추가 운행이 없다는 공식 기록
- 검은 승차권에 개인별 목적지 획이 번짐
- 피해자 기록의 00:00 고정

이 근거는 `숨은 단일 종착역`과 `전광판 단독 오염` 가설을 제거하는 데 충분하다.

그러나 다음 두 후보를 공정하게 최종 구분하기에는 현재 관측 타임라인이 부족하다.

1. 방송의 공백을 청자의 기억이 채운다.
2. 검은 승차권이 접촉자에게 목적지를 지정한다.

현재 데이터는 검은 승차권이 괴이 핵이자 물리 매개체라는 사실과, 방송 공백이 개인 목적지로 채워진다는 현상을 함께 가진다. 어느 현상이 먼저 발생했는지 플레이어가 관측할 증거가 부족하면 두 번째 후보를 정당하게 반박할 수 없다.

따라서 최종 증명 전에 다음 중 하나의 **최소 타임라인 증거**가 필요하다.

- 검은 승차권 접촉 전 이미 개인 목적지를 들은 피해자 기록
- 승차권을 소지하지 않은 관측자가 개인 목적지를 들었다는 통제 기록
- 방송 노출 뒤 승차권의 획이 생겼음을 보여주는 시간순 기록

새 시스템은 필요하지 않다. 기존 문자·CCTV·관제 로그·현장 기록 중 하나로 표현하면 된다.

## 5. Benchmark Gate

```yaml
benchmark_gate: PASSED_FOR_PLANNING
question_scope: AFTERLIFE_STATION_4_TO_2_HYPOTHESIS_BOARD
reused_existing_research: true
new_broad_research: false
cases_reviewed: 4
required_design_change:
  - separate_observation_and_interpretation
  - explicit_counterevidence_for_elimination
  - preserve_unresolved_candidates
  - add_one_minimal_timeline_evidence_before_final_proof
implementation_authority: NONE
human_validation: NOT_RUN
```

## 6. 다음 단계

이 문서를 근거로 `AFTERLIFE_STATION_HYPOTHESIS_DESIGN_DRAFT.md`에서 다음을 작성한다.

1. 후보 가설 4개
2. 각 후보의 지지·반박·미해결 근거
3. 첫 번째·두 번째 제거 체인
4. 최종 두 후보의 구분에 필요한 최소 증거
5. 노선 복원과 회수 encounter로 전달할 정보 경계
6. 사람 검증 과제와 실패 기준
