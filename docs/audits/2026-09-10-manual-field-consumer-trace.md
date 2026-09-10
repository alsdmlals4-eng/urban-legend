# 매뉴얼 → 현장 판정 소비 추적과 연결 와이어프레임

상태: `SOURCE_VERIFIED_GAP / DESIGN_PROPOSAL / RUNTIME_NOT_RUN`.
조사 baseline: `c82291101bf0a2bb4d821a12bca9f14070ee2886`.
승인 범위: 기존 사건의 실제 연결 감사, 개선 대안·wireframe·동작 요구 작성.
새 게임 의미/사건 정답/수치/저장 변경/이미지 최종 확정은 하지 않았다.
최초 감사는 PR #360으로 분리했다. 이후 사용자가 #359/#360 수정·통합을 명시 승인하여
현재는 #359 통합 작업본에 이력을 보존한 채 흡수했다. main 병합은 별도다.
이 문서는 감사 증거/제안이지 별도 게임 기획 정본이 아니다.

## 결론

**M04의 플레이어 작성 초안은 저장·매뉴얼 표시까지 연결됐지만,
회수 판정과 결과 기록은 그 초안의 의미를 소비하지 않는다.**
`draft_slots`와 회수 결과의 `manual_draft`는 같은 데이터가 아니다.
이는 작성 내용과 시도 기록의 연결 격차다. 그러나 getter 부재만으로 플레이어가
기억한 규칙을 행동에 활용하지 못한다고 결론 낼 수는 없다.
이는 플레이 세션을 실행한 결론이 아니라 아래 코드·데이터의 source-level trace다.

## 1. 실제 사례: 세 번째 빗소리 뒤의 경로

데이터 owner: `data/episodes/episode_002_red_umbrella_alley.json`.

| 단계 | 실제 값·소비자 | 판정 |
|---|---|---|
| 관측 출처 | `clue_reverse_rain_flow` | 같은 기록이 두 후보의 출처 |
| 선택 후보 | `kw_m04_rain_flow_third_sound`: 세 번째 빗소리 뒤의 역류 / `kw_m04_rain_flow_first_sound`: 첫 번째 빗소리 뒤의 역류 | 서로 다른 해석 후보 |
| 입력 슬롯 | `slot_m04_rain_rewind_flow`, page `rule_m04_rain_rewind` | 페이지·출처·중복만 구조 검증 |
| 저장 | `GameState.set_manual_draft_slot()` → `anomaly_manual_records[episode].draft_slots` | 저장 실패 시 이전 레코드 복구 |
| 화면 재표시 | `InvestigationScene._build_player_authored_workbench_model()` → `get_manual_draft_slots()` | 획득한 출처의 후보만 표시 |
| 구출 policy | `SharedInvestigationManualPolicy.evaluate_context(contract, earned, completed)` | 초안 입력 인자가 없다. 전체 scripts 검색에서 외부 호출 연결도 발견 못 함 |
| 회수 성공 | `BattleScene._select_pattern_response()` → response ID와 `correct_response_id` 비교 | 초안 변경과 독립 |
| 회수 검증 | `_evaluate_guided_decision()` → 선택 가설/대응 ID 일치, 지지 근거 충족, 반증 없음 | 별도 현장 선택에 대한 검증 |
| 기록 문구 | `_make_manual_decision_context()` → `_current_pattern.manual_draft` | 플레이어 초안이 아닌 authored pattern 문구 |
| 결과 | GameState에 context 기록 → `ResultScene._make_manual_entry_lines()` | 위 pattern 문구와 현장 가설/근거/대응을 출력 |

추가 문제: 대응 ID가 맞으면 안정도 gain이 적용된다. `verified`는 별도 가설/근거 검증이며
안정도 증가 자체의 조건은 아니다. 이 둘을 한 의미의 '매뉴얼 정답'으로 설명하지 않는다.

```text
현재 실제 연결
출처 획득 → 후보 표시 → 슬롯 배치 → draft_slots 저장 → 매뉴얼 재표시
                                             ╳ 판정으로의 직접 연결 미발견
현장 전조 → 별도 가설·근거·대응 선택 → 대응 성공/근거 검증 → authored 문구 기록
```

## 2. 코드 근거와 증거 한계

- `scripts/core/manual_keyword_composition_policy.gd`: validate_draft_slot은 출처·페이지·중복을 검증하며 의미 정답을 판정하지 않는다.
- `scripts/core/game_state.gd`: get/set/clear_manual_draft_slot, manual record 보존과 save rollback.
- `scripts/scenes/investigation_scene.gd`: 입력 signal → setter, draft view model.
- `scripts/core/shared_investigation_manual_policy.gd`: rescue_context_ready 계산은 기록/완료 규칙 개수다.
- `scripts/scenes/battle_scene.gd`: response correctness, guided evidence evaluation, static manual_draft context.
- `scripts/scenes/result_scene.gd`: manual_draft + 가설·근거·대응 출력.
- `tests/m04/m04_player_authored_manual_contract_test.gd`: 8후보와 기존 rescue gate 계약을 검사한다.
  이 테스트가 존재한다는 사실은 draft가 rescue에서 사용된다는 증거가 아니다.

실행 검증 과제: 같은 출처·같은 현장 행동에서 두 후보만 바꾸는 결과 불변성 대조 실험,
그리고 규칙 이해에 따라 실제 방법·대상·시점을 바꾸는 행동 비교 실험,
구출 진입부터 결과까지 동적 call path, 저장/불러오기, M01 회귀.
그 전까지 모든 minigame에서의 효과 부재를 일반화하지 않는다.

## 3. 재사용·벤치마크 판정

- `REUSE`: source-gated 후보, draft 저장 rollback, 기존 rule/clue/response ID, 결과의 다축 구분.
- `ADAPT`: 기존 현장 가설/근거 평가가 플레이어 초안의 선택과 직접 연결되도록 설계.
- `REJECT`: 별도 정답 사전, AI 의미 채점, 후보 목록에 정답 플래그, 스탯으로 추리 대체.
- [GDC Jon Ingold 공개 개요](https://www.gdcvault.com/play/1027723/The-Burden-of-Proof-Narrative):
  증거와 추론을 표현하며 창의성을 제거하지 않는 피드백이 문제임을 확인. 영상 전체 검토는 아님.
- [Heaven's Vault 공식 설명](https://www.inklestudios.com/heavensvault/): 해석 오류도 이후 진행에 영향을 준다.
  `ADAPT`: 틀린 초안을 즉시 지우는 대신 관측 결과와 재검토로 연결. 해당 게임의 규칙을 복제하지 않는다.

## 4. 세 가지 실질 연결 대안

| 대안 | 가치 | 비용/위험 | 판단 |
|---|---|---|---|
| A. 초안은 메모, 현장 추리는 별도 유지 | 기존 구현·저장을 거의 그대로 사용 | 같은 추리를 다시 입력, 핵심 약속을 축소해야 함 | 유지보수는 쉽지만 제품 적합성이 낮음 |
| B. 작성 규칙을 현장에 가져오고 방법은 직접 선택 | 같은 가설의 작성→적용→반증이 이어짐 | rule/slot→현장 조건 매핑과 시도 당시 값 보존 필요 | 우선 권장, 아직 의미 확정 전 |
| C. 자유 문장으로 절차·협업 계획을 작성하는 시뮬레이션 | 표현 자유와 창발성이 큼 | 해석 모호성·조합 폭증·검증/현지화 비용, 새 시스템 필요 | 현재 규모에서는 보류 |

B의 세부 경계: 후보가 정답인지 색으로 표시하지 않는다. 작성한 규칙을 적용 대상으로
선택하고 행동은 직접 고른다. 부족한 기록은 '미획득', 빈칸은 '미작성'으로만 안내한다.
미작성 상태를 강제로 출동 불가로 만들지 여부는 별도 설계 결정이다.
기존 정답과 비용을 무단 변경하지 않고, 어떤 행동을 허용/강조/예측하는지는 명시 매핑으로 설계한다.

## 5. 텍스트 네이티브 와이어프레임 — 구현안이 아닌 정보/입력 비교용

### WF-01 작성: 문장·후보·출처

```text
┌ 괴이 매뉴얼 / 세 번째 빗소리 뒤의 경로 ──────────────┐
│ 장 목록 │ 내가 작성한 문장           │ 후보 / 출처     │
│         │ 물웅덩이의 변화는          │ 세 번째 …       │
│         │ [선택한 키워드]에서 관찰된다│ 첫 번째 …       │
│         │                           │ [원본 기록 열기]│
│         │ 상태: 작성 중 / 현장 미확인│                 │
│         │ 관측 사실 / 나의 해석 구분 │                 │
└─────────────────────── [현장으로 돌아가기] ────────┘
```

검수: 빈칸 선택→후보 선택→원문 돌아가기→슬롯 수정의 키보드 focus 유지.
정답 점수·추천색 없음. 필수 한글 문장은 native text로 구현하고 배경에 굽지 않는다.

### WF-02 적용: 같은 규칙과 현재 현장

```text
┌ 현재 전조 / 현장에서 관측된 변화 ───────────────────┐
│                    실제 현장                       │
│ 지시 역할          억제 역할          보호 역할     │
│                    피해자/괴이 상태                 │
├ 가져온 규칙: [내가 작성한 문장 그대로] ──────────────┤
│ 연결 출처 [기록]       적용 방법 [기존 행동 목록]    │
│ 변화 이유/상태        [행동 선택]    [매뉴얼 열기]   │
└────────────────────────────────────────────────────┘
```

우측 하단 매뉴얼 접근과 현장 가림 최소화를 후보로 유지한다.
시계가 독해 중 흐르는지는 이 wireframe으로 확정하지 않는다.
색 외에도 이름·칸수·상태 문구로 변화 전달. 새 스킬/인물/수치를 이 도식에서 생성하지 않는다.

### WF-03 관측 결과와 수정

```text
사용한 규칙 / 적용 시점의 선택
내 행동 / 실제 관측 / 보호 결과 / 회수 결과
[관련 기록 다시 보기] [매뉴얼 수정]
```

초안을 나중에 수정해도 과거 시도 내용이 바뀌어 보이면 안 된다.
따라서 실제 적용 순간의 선택을 결과에 보존할 방법을 저장 호환 검토에서 결정한다.
전면 새 save schema를 미리 도입하지 않는다.

## 6. 동작·이미지 제작 계약 후보

| 역할 | 필요한 상태 | 입력/판정 관계 | 시각 검수 |
|---|---|---|---|
| 지시 | 확인→지시 시작→지시 전달→복귀 | 플레이어의 규칙/행동 선택 뒤 재생 | 매뉴얼 확인과 손짓 구별, 정답 자동 생성 연출 금지 |
| 억제 | 준비→접촉/발동→유지→해제→복귀 | 판정 event는 한 번만, 중단/실패 별도 | 소품·손 위치·방향·실루엣 연속성 |
| 보호 | 접근/가림→보호 유지→안전 확인→복귀 | 피해자 보호 결과와 동기화 | 피해자와 공간 관계, 배경·UI 가림 |

같은 크기·발/손 기준점·alpha 여백·duration·loop·cancel 규칙을 먼저 정한다.
이미지 모델은 새 원화/의미 있는 key pose를 제작하고 Aseprite는 필요 시 프레임/레이어를 정리한다.
현재는 새 시각 방향·규칙 적용 mapping이 확정되지 않아 pose 양산은 하지 않는다.
이 도식은 수정 가능한 구조 설명이며 생성 일러스트나 실제 인게임 캡처가 아니다.

## 7. 다음 구현 전에 닫을 것

1. 기존 M04 두 후보만 바꾸면 결과는 유지되는지 대조하고, 실제 행동을 바꾸는 별도 비교를 실행.
2. B의 rule→행동 연결 의미를 확정하고 동일 사건 truth owner를 사용.
3. 빈칸/미획득/오답/재수정/실패/저장복구의 수용 기준 작성.
4. 한 페이지 한 현장 판정부터 연결한 뒤 M01 및 기존 결과를 회귀.
5. 새 artwork는 확정된 화면/상태만 제작. Aseprite export와 Godot 적용/Human은 별도 검증.

### 검토 기록

- 1차: '매뉴얼 검증 완료'라는 UI 문구가 draft 검증 증거인가 공격 → 별도 현장 평가임을 확인.
- 2차: rescue policy 테스트 존재가 live 연결을 뜻하는가 공격 → 외부 caller 미발견, source-level ceiling 명시.
- 전체 동적 검증·최종 설계·CLEAN_REVIEW_EXIT는 아직 완료하지 않았다.

## 승인 후 교정: 숨겨진 규칙을 활용하는 생존

현재 결정은 `docs/CURRENT_DECISION_OVERLAY.md`의 `D-2026-09-10-HIDDEN-RULE-SURVIVAL-CORE`다.
위 대안 B는 방향 승인으로 진전했으나 구체적인 mapping·수치·출동 제한은 미확정이다.
매뉴얼은 플레이어의 믿음/참조이며 세계의 진실이 아니다. 메모 정답 보너스나 오답 벌점을
덧붙이는 대신 실제 현장 상태와 행동이 결과를 결정한다. 과거 '초안을 판정이 직접 소비해야
연결 완료'라는 해석은 이 기준으로 대체한다. 시도 기록에는 당시 믿음과 행동을 구별한다.

추가 source 확인: `scripts/minigames/route_restore_game.gd`는 고정 보드·도달 가능성으로
판정하고 안전 방향 안내와 safe/false 시각 구분을 가진다. 조사 지식의 필요성을 약화할
가능성이 있으므로 튜토리얼과 현장 검증의 답안 노출을 구분해 runtime에서 검토한다.
이 관찰로 기존 퍼즐을 즉시 삭제하거나 답안을 바꾸지는 않는다.

재사용 교훈: draft 연결 검사는 지식 기반 플레이 검증을 대신하지 못한다.
현재 프로젝트 한정 교훈이며 Base 강제 규칙 승격은 하지 않았다.

## 한 규칙의 실행 전 비교 명세: M04 되감기

기존 사건 데이터에서 읽은 값이며 새 사건 정답/수치는 아니다.

| 연결 | 실제 owner 값 | 실행에서 확인할 것 |
|---|---|---|
| 관측 | clue_reverse_rain_flow: 세 번째 빗소리 뒤 역방향 빗물 | 해당 관측을 획득하고 다시 열 수 있는가 |
| 추론 | rule_m04_rain_rewind / 첫 번째·세 번째 후보 | 후보를 정답 표시 없이 비교할 수 있는가 |
| 전조 | pattern_red_rain_rewind: 두 번 멀어진 뒤 귓가에서 세 번째 소리 | 조사 정보와 현장 징후를 연결할 수 있는가 |
| 대응 | wait / run_on_third / silence_rain | 동일 조건에서 wait와 run_on_third의 관측 결과 비교 |
| 현재 truth | correct_response_id=wait, stability_gain=18 | 기존 truth를 별도 사전으로 복제하지 않고 소비하는가 |
| 미니게임 | minigame_rain_sync / rain_dodge / 12초 / max_hits=3 | 조사 규칙 활용과 단순 회피 실력을 구분할 수 있는가 |

**SOURCE_VERIFIED_MISMATCH:** rain_dodge_game의 `_process`와 MinigameRules는 생존 시간과
충돌 수를 판정한다. 세 번째 빗소리 phase 판정은 이 경로에 없다. 그러나 사건의
success_result_text는 '세 번째 빗소리 뒤의 빈 프레임을 맞췄습니다'라고 주장한다.
이는 결과 문구와 실제 판정의 불일치다. 미니게임 구현에서 타이밍 지식의 활용을 증명하지
못한 상태이며, 자동으로 성공 문구를 runtime evidence로 사용할 수 없다.

실행 비교 절차(아직 NOT_RUN):
1. 같은 출처 획득 상태·전조·장비·시계·팀 상태·난수 조건을 고정한다.
2. 메모 후보만 교체하고 같은 wait 행동을 실행한다. 물리적 결과는 같아야 한다.
3. 같은 상태에서 wait와 run_on_third를 실행한다. 행동 차이와 관측 결과를 기록한다.
4. 미니게임은 같은 입력/난수 조건에서 메모만 교체하는 대조군을 둔다.
   현행 판정의 12초 경계, 2회/3회 충돌 경계도 별도로 검사한다.
5. 실제 빗소리 phase를 활용하는 실험은 phase/입력 연결이 명세·구현된 뒤 수행한다.
   기존 generic 회피 성공을 그 실험의 PASS로 대체하지 않는다.

2026-09-10 실행 환경 확인: `hera status`는 no live editor,
Godot AI session list도 count=0이었다. 로컬 Godot 실행 파일의 실제 버전은
4.7.2.stable.official.ed1daf0bf다. 편집기/플러그인 연결을 사용자에게 요청했다.
프로젝트 설정 파일의 plugin enabled는 live 연결 증거가 아니다. 실행 장면/입력/결과
비교와 GUT 행동 검증은 NOT_RUN이며 이 문서는 소스 조사와 실행 준비까지만 증명한다.

### 후속 실제 실행: 편집기 연결 복구 / 정상 진입 실패

사용자가 직접 열어 진행하도록 지시하여 Godot 4.7.2 편집기를 실행했다.
프로젝트 경로를 live status/session에서 확인했고, 메인 화면 1280×720 실행 트리를 읽었다.
검증 editor/game은 `.artifacts/m04-rule-probe/appdata`로 APPDATA를 격리해 재실행했다.
기존 사용자 저장 대신 프로젝트 내부 검증 저장을 사용했다.

실제 실행 로그에 main_menu.gd:1163의 `_start_red_umbrella_campaign`에서
`begin_campaign_case_selection` 없는 함수 호출이 발생했다. GameState 상속 경로에서 해당
메서드가 없음을 소스 검색으로 재확인했다. 정상 M04 진입은 FAIL이며 수리가 남았다.
직접 테스트 경로로 M04 load_episode=true와 minigame_rain_sync 설정, minigame_scene 전환은
확인했지만 이를 정상 플레이 진행이나 행동 비교 PASS로 간주하지 않는다.

별도 도구 문제: 설치된 Hera CLI/addon은 문서의 game --pid 옵션을 지원하지 않고,
scene 전환 후 editor playing_scene과 live scene 불일치로 runtime 조회가 실패했다.
또 전환 메서드 호출 뒤 제거된 노드의 get_path를 조회하는 inspector 오류가 기록됐다.
이는 게임 규칙 오류와 분리하며 플러그인 교체/보안 경계 변경은 하지 않았다.
마지막에는 게임을 중지하고 격리 편집기는 열어 두었다. 자동 import/UID 생성물은 제품
수정에 포함하지 않았다. 화면 캡처, 규칙별 동적 대조, GUT/Human PASS는 여전히 미완료다.
