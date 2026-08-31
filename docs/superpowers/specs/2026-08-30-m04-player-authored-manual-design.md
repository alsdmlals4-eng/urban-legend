# M04 플레이어 작성 괴이 매뉴얼 설계

> 상태: `USER_APPROVED / IMPLEMENTED / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN`
> 승인 근거: 사용자의 “권장안대로 진행해” 및 “godot에 기획안들 전부 다 구현될 때까지 멈추지마” 지시
> 범위: `episode_002_red_umbrella_alley`만

## 목표

M04 빨간 우산의 플레이어가 조사에서 얻은 세 단서를 출처와 함께 읽고, 빈칸이 있는 두 개의 추리문에 후보 키워드를 직접 배치한 뒤, 확보 기록 `2`개와 출처가 유효한 완성 규칙 `1`개를 충족하여 기존 구출·회수 흐름으로 들어가 자신의 판단을 검증할 수 있게 한다.

## 채택 구조

`ManualDeductionWorkbench`와 `ManualKeywordCompositionPolicy`, 기존 `GameState`의 `anomaly_manual_records[episode_id].draft_slots`를 그대로 재사용한다. M04의 실제 사건 데이터가 매뉴얼의 유일한 정본이 되고, 이전 validation map에 있던 M04 rule-page와 rescue-gate 계약은 그 데이터로 이동한다. validation map은 검증 연결만 보유하며 별도의 매뉴얼 사실을 소유하지 않는다.

M04 가이드는 `루메`다. CASE-04에는 사용자 승인 범위의 빨간 우산 골목 전용 현장 복장 초상을 표시하고, CASE-01의 저승역 초상은 재사용하지 않는다. 동일 workbench의 기술적 호환 노드 이름은 CASE-01 회귀를 위해 유지하며, M04에서는 시나리오별 초상을 명시적으로 전환한다.

## 사실·판단 경계

- 정본 단서 ID는 `clue_red_umbrella_fabric`, `clue_repeating_alley_sign`, `clue_reverse_rain_flow`뿐이다.
- 두 추리문은 이미 존재하던 `rule_m04_rain_rewind`, `rule_m04_victim_tether`를 읽기 가능한 빈칸 문장으로 표현한다.
- 각 변조 후보는 같은 출처의 한 변수만 바꾼다. 독립 가짜 출처, 정답 ID, correct/wrong, 추천, 점수, 자동 완성은 만들지 않는다.
- 후보 선택은 draft-only다. 구조 오류만 policy가 막고 semantic verdict는 표시하지 않는다.
- 기존 `minigame_rain_sync`, rescue gate, recovery pattern, 결과·보상·저장 버전의 의미는 바꾸지 않는다. 다만 episode data에 이미 있던 rescue gate는 자발 회수 진입에서 실제로 시행하며, 강제 위험 전환은 기존처럼 막지 않는다.

## 비목표

- M05~M12 사건, 새 괴이·단서·플래그·미니게임·밸런스·save schema를 만들지 않는다.
- 승인된 `M04-LUME-GUIDE-001` 외의 새 가이드 일러스트나 이미지를 생성·승격하지 않는다.
- Human QA, 접근성 QA, 출시 QA, product-reference asset 승격을 주장하지 않는다.

## 검증 기준

1. M04 실제 episode data의 manual이 generic composition policy와 기존 shared rescue-manual policy를 모두 통과한다.
2. M04 화면은 획득 기록에서만 후보를 보이고, 슬롯 placement/clear를 기존 `GameState` draft API로 전달한다.
3. M04는 CASE-04 현장 복장의 루메를, M01은 저승역 복장의 루메를 보존하며 서로의 초상을 재사용하지 않는다.
4. M04 실제 메인 메뉴 진입→준비→조사→루메 매뉴얼→회수 전환, M04 baseline, M01 manual regression, 1280×720 및 1920×1080 scene test, package and full Godot regression, Python suite가 통과한다.
5. 실행 전후 실제 사용자 save SHA-256은 `21EF268BC46D348B94BC34408DBB62936C1151AF78FBF14CFC7CE7403563C849`로 동일하다.
