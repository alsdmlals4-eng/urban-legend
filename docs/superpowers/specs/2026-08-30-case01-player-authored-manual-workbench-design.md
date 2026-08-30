# CASE-01 Player-Authored Manual Workbench Design

> 상태: `USER_APPROVED / IMPLEMENTATION_AUTHORIZED / NOT_IMPLEMENTED`
> 승인 근거: 2026-08-30 사용자 지시 — “권장안 승인,진행해”
> 범위: M01 저승역의 출처 기반 빈칸 매뉴얼 작성, 저장, 구출·회수 검증 연결
> 시각 기준: `docs/VISUAL_ANCHOR_SPEC.md` 및 `HGB-UI-09`/`HGB-AUX-09`

## 1. 목표와 완료 경계

플레이어가 저승역 조사에서 얻은 기록의 출처와 맥락을 비교해 읽을 수 있는 추리문
빈칸에 후보 키워드를 배치하고, 그 작성 내용을 구출과 회수의 현장 결과로 검증할 수
있게 한다. 화면은 승인된 기록철형 참고 화면의 정보 위계를 재사용하지만, 전체 PNG를
런타임 화면에 붙이지 않고 Godot `Control` UI로 구현한다.

완료는 다음까지다.

1. M01에서 전체 화면 기록철 작업대를 열고 닫을 수 있다.
2. 조사로 획득한 출처 기록에 맞춰 후보 풀이 열린다.
3. 후보를 빈칸에 배치·교체·해제할 수 있고, 해당 초안은 저장/불러오기 뒤 유지된다.
4. UI는 정답/오답/변조/추천/호환성 점수를 표시하지 않는다.
5. 기존 M01 구출·회수의 관찰 결과가 candidate/verified/danger-case 기록으로 남는다.
6. 1280×720과 1920×1080에서 한국어, 포커스, Esc 복귀, 루메 보조 패널을 확인한다.

다음은 명시적으로 제외한다.

- M04 및 다른 사건의 후보 데이터·화면·저장 확장.
- 새 괴이 규칙, 사건 결말, 단서 ID, 회수 답안, 자동 해결 로직.
- 전역 아카 표기 변경. CASE-01 현장/매뉴얼 보조만 루메다.
- `afterlife_canon_v2.manual.filled_slots`의 사용 또는 기존 저장 version의 변경.

## 2. 현재 구조와 채택 이유

현재 `scripts/ui/anomaly_manual_drawer.gd`는 읽기 전용 우측 서랍이며,
`data/episodes/episode_001_afterlife_station_canon_v2.json`의
`candidate_keywords` 및 `semantic_relations`는 비어 있다. Canon V2 이관 검증은
`afterlife_canon_v2.manual.filled_slots`가 비어 있음을 보장한다.

반면 `GameState.anomaly_manual_records`는 모든 저장본에 이미 직렬화되는
플레이어 작성 매뉴얼 원장이다. 따라서 후보 데이터는 사건 Canon에 두고, 플레이어의
초안은 `anomaly_manual_records[episode_id].draft_slots`에만 둔다. 이 방식은
Canonical migration state와 player-authored state를 분리하며 새 save version이나
이관 패치를 만들지 않는다.

## 3. 데이터·상태 계약

### 3.1 M01 Canon 후보 데이터

`canonical_v2.investigation_manual`에 다음 필드만 추가한다.

```json
{
  "candidate_keywords": [
    {
      "id": "kw_afterlife_p01_broadcast_gap",
      "page_id": "manual_afterlife_page_01_destination_projection",
      "display_label": "목적지 구간의 무음 공백",
      "source_record_id": "record_afterlife_r1_broadcast_original"
    },
    {
      "id": "kw_afterlife_p01_announcement_start_gap",
      "page_id": "manual_afterlife_page_01_destination_projection",
      "display_label": "방송 시작 구간의 무음 공백",
      "derived_from_candidate_id": "kw_afterlife_p01_broadcast_gap",
      "source_record_id": "record_afterlife_r1_broadcast_original"
    }
  ],
  "semantic_relations": []
}
```

`source_record_id`는 기존 Canon evidence record ID여야 한다. 변조 후보도 별도 가짜
기록을 만들지 않고, 이미 획득한 정상 기록의 `source_record_id`를 상속한다. 화면에는
`derived_from_candidate_id`와 같은 내부 계보를 노출하지 않는다. 후보는 현재 페이지의
작은 풀로만 제시하고, 색·정렬·크기·badge에 정상/변조/정답 정보를 싣지 않는다.

각 manual page에는 사람이 읽는 `deduction_text`와 slot ID를 순서대로 참조하는
`deduction_segments`를 추가한다. 빈칸은 사건의 새 진실이 아니라 기존 evidence record와
기존 page slot ID를 플레이어가 작성할 수 있는 문장 형태로 표현한다.

`normal_clear.reveal_complete_manual`은 `false`로 바꾼다. 정상 종료가 플레이어가
쓰지 않은 완성 답안을 자동으로 공개해서는 안 된다.

### 3.2 플레이어 초안

```json
{
  "episode_id": "episode_001_afterlife_station",
  "draft_slots": {
    "slot_afterlife_p01_broadcast_blank": "kw_afterlife_p01_broadcast_gap"
  },
  "draft_updated_at_label": "2026-08-30T00:00:00"
}
```

`draft_slots`는 `anomaly_manual_records`의 기존 `verified_rules`, `candidate_rules`,
`danger_cases`와 동등한 플레이어 작성 상태다. 저장된 candidate ID나 slot ID가 현재
Canon에 없으면 읽을 때 조용히 제외하고 원본 저장을 손상시키지 않는다.

`ManualKeywordCompositionPolicy`는 다음의 구조상 불가능한 경우만 거절한다.

- 존재하지 않는 page/slot/candidate ID.
- 현재 page가 아닌 후보.
- 아직 획득하지 않은 `source_record_id`를 근거로 하는 후보.
- 같은 페이지에서 이미 쓰인 candidate ID의 중복 배치.

문장의 의미가 맞는지, 변조인지, 회수 대응이 정답인지 판정하지 않는다.

## 4. UI와 입력 계약

`ManualDeductionWorkbench`는 state를 쓰지 않는 presentation component다. 입력은
`draft_slot_requested(slot_id, candidate_id)`와 `dismiss_requested()` signal로만 scene
owner에 전달한다.

전체 화면은 16:9 safe frame 안에서 네 개의 고정된 정보 구역을 가진다.

1. 좌측 INDEX: 페이지 해금/선택. 정답 상태 대신 작성 여부와 출처 확보 여부만 보여 준다.
2. 중앙 추리문: `RichTextLabel`이 아닌 `VBoxContainer` 기반 문장 segment와 Button
   빈칸으로 만든다. 따라서 빈칸은 포커스·교체·해제를 지원한다.
3. 우측 후보: 동일 visual treatment의 2열 `GridContainer`. 후보는 출처 기록과
   획득 맥락을 읽을 수 있다.
4. 우하단 루메: CASE-01 저승역 복장의 소형 치비 초상과 절차 문구. 루메는
   “출처와 문장을 함께 비교”만 안내하고 답안을 말하지 않는다.

열 때 첫 가용 빈칸, 없으면 첫 후보가 `call_deferred(...grab_focus)`로 포커스를 얻는다.
`Esc` 또는 닫기 버튼은 작업대를 숨기고 정확히 이전 현장 Control로 포커스를 돌린다.
후보 버튼은 `FOCUS_ALL`이며 `ScrollContainer.follow_focus`로 화면 밖 포커스를
자동 노출한다. 다른 모달이 열리면 작업대를 닫고 입력을 소비한다.

## 5. 자산 계약

`HGB-AUX-09`를 아래 제품 자산으로 한 번만 승격한다.

```yaml
asset_id: M01-LUME-GUIDE-001
canonical_path: assets/ui/guides/lume_afterlife_station.png
source_path: docs/visual/blueprint-reference-pack/2026-08-30/09-lume-afterlife-station-guide-candidate.png
runtime_path: scenes/ui/manual_deduction_workbench.tscn -> LumeGuidePanel/LumePortrait
approval_scope: CASE-01 manual workbench only
```

전체 `HGB-UI-09` 이미지는 reference-only로 남는다. Manifest에는 source/provenance,
SHA-256, 검정 배경 비투명 PNG, 1024×1536 규격, 1280×720/1920×1080 검수 조건을
기록한다. 이 asset은 다른 사건의 전역 루메 복장으로 사용하지 않는다.

## 6. 검증과 롤백

자동화는 최소한 다음을 검증한다.

1. Canon candidate data가 기존 evidence record에만 연결되고 숨은 truth 필드를 갖지 않는다.
2. source record 미획득/중복/잘못된 page 배치는 거절되고, 의미상 오답은 허용된다.
3. `draft_slots` 저장/불러오기와 구 저장 fallback이 기존 M01 migration state를 바꾸지 않는다.
4. visible candidate와 루메 문구에 정답, 변조, 추천, correct/wrong 표식이 없다.
5. 열기/닫기/Esc/포커스 복귀 및 1280×720/1920×1080 scene capture가 동작한다.
6. M01 구출/회수 결과가 기존 candidate/verified/danger-case 기록을 계속 작성한다.

테스트 실패나 실제 화면 결함이 생기면 `assets/ui/guides/lume_afterlife_station.png`의
manifest entry와 `ManualDeductionWorkbench` integration을 되돌리면 된다. Canon V2의
`filled_slots`, save version, M04 data는 이 작업에서 수정하지 않아 rollback 범위 밖으로
보호된다.
