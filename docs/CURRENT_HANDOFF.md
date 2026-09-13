# 괴이기록국 Current Handoff

## 전체 회귀의 headless helper 계약 교정 — 2026-09-13

계획 `docs/superpowers/plans/2026-09-13-headless-helper-parity.md`. 전체 Python 490개 중 기존 실패 1개를 재현했다. 최신 main과 같은 monolithic game_helper가 opt-in 없이 headless에도 capture/logger를 등록하고, 구형 테스트는 wrapper/impl 분리를 강제했다. 최신 구현을 과거 파일로 교체하지 않고 editor의 기존 launch 정책과 동일한 guard를 추가했다. 자동 검사에서는 기본 비활성, GODOT_AI_ALLOW_HEADLESS=true에서는 활성, 실제 창에서는 기존 활성이다. 추가 서비스/권한/설정 변경 없음.

실제 autoload 등록·logger·process RED2→0. false/빈 opt-in/true opt-in/실제 Vulkan 창의 4개 별도 실행 모두 0 failures. headless 인자/display-driver/표시기/명시 opt-in 행렬도 검사. 구형 Python wrapper 강제만 제거하고 현행 registration 계약 검사는 유지했다. 전체 Python 490/490 PASS, GUT 27/27·144 assertions, 새 CCTV 및 조사 왕복 모두 PASS. 보조 기능의 원격 debugger 통신/전체 screenshot 기능은 이번 작은 launch test의 검증 범위가 아니며 최종 릴리스 PASS가 아니다.

검토1: 환경 opt-in false/true와 기본값, 기존 종료 unregister 보존. 검토2: 실제 창 기능 활성/전 코드 보존/490개 회귀 재실행. 오래된 game_helper_impl 파일은 consumer/provenance 정리 범위 밖이므로 삭제하지 않았다. Base 승격은 보류(프로젝트 local helper vendor 업데이트 재발 증거 축적 필요). 나머지 게임 구현·회수 실시간 계약·아트/음향/전체 통합은 여전히 남는다. 이 교정은 전체 완성 선언이 아니다.

## M04 CCTV 규칙 실행 연결 — 2026-09-13

계획 `docs/superpowers/plans/2026-09-13-rain-frame-sync.md`. 기존 CCTV 진입의 rain_dodge 생존 판정이 조사한 세 번째 빗소리와 무관하던 간극을 교정했다. 현재 M04 consumer는 rain_frame_sync: 재생 시작→세 번의 시각 빗소리 관측→소리가 멎은 구간에서 영상 고정. 세 번째 소리 도중은 실패, 직후는 성공이다. 대기만으로 성공하지 않는다. 기존 12초/실패 3회/장비 보호 1회, 사건 ID/정답/효과/저장 schema를 유지한다. 초안은 읽기 전용 참고이며 판정 코드가 초안이나 GameState를 읽지 않는다. 실제 입력 시각·관측·실패 횟수를 기존 result details/input_summary에 기록한다.

FEATURE_SLICE / PLAN→BUILD→REVIEW, 테스트 우선. 신규 consumer 부재 RED1→0, 보고서 payload 누락 RED1→0, 실패 관측 미표시 RED1→0. 첫/셋째/직후/다음 주기 경계, 무입력 제한시간, 세 번 실패, 잠금과 중복 완료를 검사했다. 실제 조사 UI/획득 조건/매뉴얼 초안/재개/영상 고정 버튼/조사 복귀 통합 0 failures. 시간은 진단 fixture에서 전진시키지만 완료 신호를 강제로 성공시키지 않는다. 기존 alternate 초안이 그대로 남은 상태에서 실제 시점 선택이 성공한다. 사람의 전 구간 플레이/키보드 물리 입력 검증은 아니다.

1280×720 Vulkan 화면 확인. 관측 결과가 길어졌을 때 저장 재시도 버튼이 화면 밖으로 밀리는 2개 실패를 재현해 본문을 ScrollContainer로 분리하고 복귀/매뉴얼 버튼을 고정했다. 재실행 0 failures. `.artifacts/daily-case-20260912/rain-frame-sync.png`, `minigame-save-retry.png`. 현재 CCTV는 기능 검증용 텍스트 UI이며 최종 영상/애니메이션/빗소리 오디오는 미구현이다. 연출 완성이나 최종 그림체 승인으로 승격하지 않는다.

기존 minigame pipeline/controls, 조사 왕복 및 저장 재시도 PASS. GUT 27/27·144 assertions, Python 계약 25 PASS. 저장 재시도 첫 headless 실행에서 ObjectDB2 경고가 나왔으나 verbose 재실행/최종 Vulkan에서 재현되지 않았다. 간헐적 경고의 근본 해결을 주장하지 않는다. 검토1은 규칙/판정/기록, 검토2는 실제 host/pause/save/layout 재검증. 전체 게임 CLEAN_REVIEW_EXIT/출시/Human PASS가 아니다.

Base v9.4.4, 기존 승인 자산과 사용자 import/uid 변경, 다른 열린 PR 보존. origin/main c82291101bf0a2bb4d821a12bca9f14070ee2886 재확인. PR 목록은 GitHub connector로 읽었으며 별도 PR 변경/병합 없음. 로컬 gh 로그인 부재를 원격 접근 불가로 확대하지 않았다. Base 신규 승격 없음; 기존 host/저장 contract 재사용. 롤백은 본 작업 커밋 revert이며 이전 결과는 기존 pipeline에서 읽힌다.

REMAINING_WORK_COMPLETION_GATE / IMPLEMENTATION_CORRECTION_RESCAN: 현재 단위의 기능 연결은 확인했지만 전체 사건별 정상 플레이, 회수 활성시간 정책의 모든 소비자, 최종 UI·영상·음향, 밸런스·접근성·전 플랫폼, 전체 변경의 보호된 main 통합이 남는다. 승인된 전체 구현 루프는 계속 유효하며 이 기록은 전체 완성 선언이 아니다.

## 미니게임 종료 저장 재시도 — 2026-09-13

승인된 개선 루프의 다음 보호 단위. 계획: `docs/superpowers/plans/2026-09-13-minigame-save-retry.md`. GameState.save_minigame_result는 bool로 실제 저장 성공을 반환하고 MinigameScene이 소비한다. 종료 정산/효과는 한 번만 적용하며 실패 시 기존 결과 영역에 미저장 안내, 복귀 버튼에 저장 재시도를 제공한다. 복귀 목적지 저장이 실패하면 현재 미니게임에 머무르고 메모리 Scene 경로를 복구한다. 결과/보상 재실행이나 새 저장 schema는 없다.

실제 stage 경로 I/O 실패에서 성공/실패 총 12개 RED→새 통합 0 failures. 이전 primary 바이트 보존, 반복 신호/재시도 효과 불변, 장애물 제거 후 실제 조사 복귀/재로드를 검사했다. 실제 1280×720 창에서 매뉴얼/재시도 버튼 겹침을 추가 재현하고 종료 상태의 두 버튼을 동일 VBox로 배치해 교정했다. 캡처 `.artifacts/daily-case-20260912/minigame-save-retry.png`. 기존 조사 왕복, minigame pipeline/controls, GUT 27/27·144 assertions 및 Python 계약 25 PASS. 정상 전체 플레이/사람 UX/출시는 미검증이고 M01 전용 저장 실패·scene-loader 장애 주입도 미실행이다.

Phasmophobia/Outer Wilds 개발사 원문 재확인과 기존 recovery 저장 실패 패턴 비교를 기록했다. 기존 자산·사용자 import/uid·다른 열린 PR·Base v9.4.4 pin은 보존했다. Base 강제 규칙 승격 없음. 다음 핵심 병목은 기존 CCTV 프레임 관측과 회수의 ‘세 번째 박자 동안 이동하면 되감김 / 끝난 뒤 고정’에 맞는 실제 미니게임 동작이다. 현행 rain_dodge의 12초 생존을 그 규칙의 완료로 오인하지 않는다. 이전 headless AudioStreamWAV/PlaybackWAV 종료 경고, 회수 전체 공통 simulation-time/음향 정지, 최종 그림체와 정상 플레이 전 구간 검증은 계속 남는다.

## 미니게임 명시적 재개·입력 분리 — 2026-09-13 successor

같은 승인 루프에서 상세 설계 §11.6을 재대조하여 바로 아래 단위의 ‘닫기 즉시 재개’를 교정했다. 현재 미니게임은 매뉴얼 열람 또는 Window focus_exited에서 국소 simulation을 정지하고, 닫기/포커스 복귀 이후 ‘현장 재개’ 버튼을 눌러야 진행한다. 방향/확인/마우스 입력 해제를 기다려 재개 입력이 이동으로 새지 않게 한다. M01 route_restore의 입력 잠금도 같이 복구한다. 회수 전체 정지/음향/실시간 위험 시계까지 완료했다는 뜻이 아니다.

기존 계획 `docs/superpowers/plans/2026-09-13-investigation-minigame-continuity.md`에 세 대안·Godot 공식 원문 비교와 결과를 추가했다. 자동 재개/버튼 부재 2개 RED 이후 새 통합 검사 0 failures. 실제 Vulkan 1280×720에서 재개 화면 캡처를 확인하고, 상단 작전 바가 가리던 M04 매뉴얼 버튼은 우측 하단, 저장 제한 안내는 기존 좌측 규칙 패널로 옮겼다. drawer는 실제 field 위에 표시한다. M01/M04 호스트/controls/pipeline 및 GUT 27/27·144 assertions PASS. 포커스 이탈은 Window signal 주입이며 실제 Alt-Tab/모든 기기 검증은 아니다. 기본 도형 미니게임은 아직 prototype이며 그림체/최종 UX 승인 증거가 아니다. 이전 headless audio 종료 경고와 실제 세 번째 빗소리 timing 소비처 공백은 여전히 남는다. 새 자산/유료 도구/삭제/Base 승격/다른 PR 변경 없음.

## 조사 → 작성 → 미니게임 왕복 연속성 — 2026-09-13

승인된 개선 루프 continuation. 계획/비교/검증 owner: `docs/superpowers/plans/2026-09-13-investigation-minigame-continuity.md`. 기존 Outer Wilds 원출처를 현장 관측/행동 연결에 ADAPT, Phasmophobia 기록 재열람 evidence 재사용. Base v9.4.4 pin, main c82291101bf0a2bb4d821a12bca9f14070ee2886, 다른 open PR과 사용자 import/uid 변경은 보존했다.

미니게임 매뉴얼에 실제 작성한 초안(미검증)을 표시하고 조작 안내와 분리한다. 읽는 동안 해당 게임 노드만 process_mode로 정지하여 Input polling, 위치, 경과 시간, 위험 진행을 보존한다. 중복 열기/닫기와 원래 모드/포커스 복귀, 완료 후 게임 비재시작을 교정했다. M04 추리문 8개 text segment의 선결 답변/조사 오류를 중립 문장으로 교정했으며 후보·정답·단서·수치는 바꾸지 않았다. 조사 숨김 Label 2개에 Scene 소유권을 부여했고 매뉴얼 닫기 직후 Scene 전환 시 deferred focus가 퇴장한 opener를 호출하지 않게 했다.

`tests/recovery/investigation_minigame_manual_flow_test.gd`: 실제 조사 방법 선택→기록 확보→매뉴얼 슬롯/키워드 버튼→CCTV 조건 통과→미니게임→정지/재개→조사 복귀를 검사. RNG seed와 최종 실패는 통제된 진단이며 전체 사람 플레이는 아니다. headless 기능 0 failures, Vulkan 1280 실행 0 failures/종료 경고 없음. GUT 27/27·144 assertions 및 Python 계약 25 PASS. 기존 workbench/매뉴얼/drawer/minigame 회귀 기능 PASS. Font/CanvasItem/orphan-node 문제는 교정됐으나 반복 headless 일부에서 AudioStreamWAV/AudioStreamPlaybackWAV 각각 1개 종료 경고를 확인했으며 미해결로 남긴다.

긴 결과 UI 검사도 논리 viewport와 물리 window 좌표 혼용을 교정했다. 실제 1920×1080 요청 창은 OS 제약으로 1920×1061임을 readback했으므로 정확한 1080 렌더 PASS를 주장하지 않는다. 검토 1/2와 추가 발견 교정은 계획 문서 참조. 전체 CLEAN_REVIEW_EXIT/Human/출시 PASS는 아니다. 다음 병목은 단순 12초 rain_dodge와 사건의 세 번째 빗소리 timing 의미 사이의 실제 행동 소비처 공백이다. 무단 새 규칙/노트 기반 효과 보정 없이 기존 사건 진실부터 비교한다. 삭제·자산 교체·Base 승격 없음.

## 당시 초안 → 대응 결과 → 재검토 연결 — 2026-09-13

승인된 개선 루프의 FEATURE_SLICE/CAMPAIGN_CORE continuation. 계획: `docs/superpowers/plans/2026-09-13-manual-trial-feedback.md`. Phasmophobia Chronicle 개발사 원문의 기록 재열람/종료 후 debrief 재개를 ADAPT하고 기존 Outer Wilds/Expelled! 비교 evidence를 재사용했다. M04는 direct response여서 guided 전용 매뉴얼 기록에 진입하지 않는 것을 실제 코드/데이터에서 확인했다. 사건을 guided 방식으로 바꾸거나 새 정답을 만들지 않고 공통 recovery_pattern_learning을 재사용했다.

구현: 당시 보유한 매뉴얼 초안 문장과 실행한 대응/전조 이름을 기존 패턴별 최신 시도 기록에 additive optional metadata로 보존한다. 기존 결과/사유/횟수의 의미는 그대로다. 현장 같은 전조의 기록 서랍, 실패/일반 결과, M04 성공 순차 결과, 완료 보고서 DB에서 재대조한다. 초안을 나중에 수정하거나 다른 사건을 열어도 완료 보고서의 과거 사본이 바뀌지 않는다. 초안 전체의 정답 판정이나 행동 효과 보정이 아님을 명시한다. 현재 초안 조합은 GameState read-only getter로 모아 기존 bridge와 동일 필터를 공유한다. 저장 버전 변경/기존 필드 삭제 없음. 이전 기록에는 당시 초안을 추정 삽입하지 않는다.

새 `tests/recovery/manual_trial_feedback_test.gd`는 실제 battle handler에 M04 대응을 전달해 기록, 초안 수정/로드, 반복 전조 피드백, 실패 결과, 성공 보고서/DB/순차 결과를 검사한다. 최초 기능 6개 실패 RED→교정. 결과 제목의 상단 바 겹침 1개 실패→여백 교정, 재검토 강제 열람 1개 실패→기존 4개 후일담 뒤 즉시 준비실 복귀를 유지하고 추가 검토는 선택으로 교정했다. 이 과정의 지연 포커스가 퇴장한 카드에 접근하는 오류도 실제 재현 후 생명주기 검사로 교정했다. 정상 플레이 입력 전 구간 완주가 아닌 DIAGNOSTIC_FIXTURE다.

검증: 새 통합 Vulkan 실행 0 failures 및 1280×720 캡처 `.artifacts/daily-case-20260912/manual-trial-feedback.png` 확인. GUT 27/27 tests,144 assertions PASS; Base operating/active reference unittest 25 PASS. M04 workbench 기능 PASS이나 종료 Font RID1/CanvasItem2/ObjectDB10 경고, 기존 authored handoff ObjectDB4, guided flow ObjectDB4, direct-lead 12/12 및 ObjectDB2 경고는 별도 남음. 이번 새 통합 최종 렌더 실행은 오류/누수 경고 없음. 과거 일정 기반 sequential test는 바뀐 body 경로만 교정했으며 이 legacy 테스트 전체 PASS를 주장하지 않는다.

검토 1: 새 초안/과거 사본 분리, 기존 정답/보상 불변, 없는 metadata/미작성 구분. 검토 2: 실제 M04 성공/실패/DB 소비, 다른 사건 경계, 상단 겹침과 추가 페이지 선택성 교정. REMAINING_WORK_COMPLETION_GATE와 IMPLEMENTATION_CORRECTION_RESCAN 결과: 이번 기록 연결 외에 **정상 조사 입력→매뉴얼 작성→구출 미니게임→회수의 기계적 의미 연결**, 문장 조합 문법, 활성시간 시계 정책/중단·재개, 테스트 수명주기 경고, 최신 main 통합이 남음. POST_COMPLETION_ADVERSARIAL_REVIEW_REQUIRED는 수행했지만 전체 CLEAN_REVIEW_EXIT/Human/출시 PASS는 아니다. 실패 사건의 영구 아카이브나 모든 시도 연대기는 만들지 않았고 기존 패턴별 최신 시도/성공 보고서 최신 1건 정책을 유지한다.

Base v9.4.4 lock/승인 자산/사용자 import·uid/열린 PR 361·360·359·287·231 보존. 사용자 파일 삭제/이동 없음. 공통 formatter를 프로젝트 내 3개 소비자에 재사용했으며 공용 Base 승격은 NO_NEW_REUSE_LEARNING. 롤백은 이번 커밋 단위이며 이전 reader는 optional metadata를 무시한다. 다음 계획은 정상 조사·구출 입력으로 기존 규칙이 실제 소비되는 경로를 추적/검증하고 누락만 연결하는 것. 과거 기록 보완을 전체 게임 구현 완료로 승격하지 않는다.

## 작성한 매뉴얼의 회수 현장 참조 연결 — 2026-09-13

계획: `docs/superpowers/plans/2026-09-13-manual-recovery-handoff.md`. 조사 draft_slots의 실제 consumer를 추적한 결과 저장/조사 화면에는 연결되어 있었지만 회수 매뉴얼은 페이지 제목만 표시했다. 기존 quick-open drawer와 bridge를 재사용해 현재 사건의 저장된 초안 문장을 읽기 전용으로 전달한다. 기존 candidate ID/page/slot filter와 확보 출처 조건을 적용하고 선택이 없는 칸은 미작성으로 남긴다. 적어도 하나의 유효한 선택이 있는 페이지만 새 섹션에 표시한다. 새 섹션은 '내가 작성한 해석 · 미검증'이며 active_rule_ids 승격, 자동 정답 판정, 시계/피해/보상 변경은 하지 않는다.

비교 근거는 이전 3게임 연구를 재사용하고 Phasmophobia Chronicle 개발사 원문에서 journal의 기록 재열람을 다시 확인했다. 제목만 유지(REJECT), 회수 중 새 편집기를 추가(DEFER), 기존 기록을 현장에서 열람(REUSE/ADAPT) 중 마지막을 선택했다. 새 이미지/저장 필드 없음.

`tests/recovery/authored_manual_handoff_test.gd`: 기존 M04 출처를 fixture로 확보→대체 후보 작성/저장→load→battle→ManualQuickButton 신호→표시문 확인. 선택 문장 부재/미작성/미검증 3개 실패 RED 후 0 failures. 미선택 후보로 치환하지 않음도 검사. GUT 27/27 tests,144 assertions PASS. 새로운 headless 통합 실행은 종료 ObjectDB 4개 경고가 남음. 정상 조사 입력/구출 미니게임 완주/물리 입력/최종 화면 캡처/기계적 규칙 적용의 증거는 아니다.

검토 1: 초안의 현재 사건 경계/알 수 없는 ID 필터/확보 출처 조건 유지. 검토 2: 완성 칸을 검증 완료로 승격하지 않음, 원문 문자열 BBCode 보호, 기존 페이지/현행 규칙과 분리 확인. 전체 CLEAN_REVIEW_EXIT/Human/출시 PASS 아님. 다음 계획은 선택한 초안과 현장 행동·반증 기록 사이의 의미 연결을 현재 authored response 규칙에 맞게 검토하는 것. 기존 테스트 경고도 별도 생명주기 항목으로 남긴다. Base 승격/사용자 파일 삭제·이동/승인 자산 교체 없음.

## 비교 게임 → 기획 구체화 → 연결 구현 루프 — 2026-09-13

최신 사용자 정의: 개선 루프는 단순 버그 수정 반복이 아니라 유사 장르의 공개 개발 자료를 조사하고 우리 기획을 구체화/연결/구현하며 완성도를 높이는 반복이다. 계획 선행은 유지한다. 같은 승인 방향 안의 세부 작업은 재승인을 요구하지 않으며 핵심 규칙/주요 플레이 경험/비용 변경만 사용자 결정으로 분리한다. 루프 순서는 현재 플레이 병목 → 기존 구현/승인 자료 → 관련 게임 비교 → ADOPT/ADAPT/REJECT → 구현 계획 → 테스트 우선 구현 → 실행/퇴행 검수 → 다음 병목이다. 배경 자동 실행/전체 게임 완료를 선언하는 뜻은 아니다.

첫 연결 단위 계획과 benchmark: `docs/superpowers/plans/2026-09-13-manual-observation-loop.md`. Phasmophobia Chronicle의 기록 재열람, Outer Wilds의 환경 관측/위험 시험, Expelled!의 지식/행동 결과 연결을 공개 개발사 자료에서 비교했다. 시간 루프·하루 일정·외부 보상 체계를 복제하지 않는다. 현재 매뉴얼은 후보의 출처 제목만 전달했으므로 확보된 원문 관측과 후보 해석의 비교 마찰을 우선 보완했다.

구현: investigation_scene은 기존 clue description을 확보 후보에만 연결한다. workbench는 현재 페이지의 확보 원문을 출처 ID로 중복 제거해 기존 스크롤 문서 안에 표시한다. 새 단서/정답/저장 필드를 발명하지 않는다. 읽기만으로 초안이 작성되지 않고 작성 후에도 원문이 남는다. M04 활성 매뉴얼의 stale '기록관 아카'는 루메로 교정했다. 역무원 복장 이미지를 M04에 가져오지 않으며 미승인 비옷 그림을 제작/적용하지 않았다.

검증: 원문 부재 및 stale guide 3개 실패 RED → 구현 후 M04 manual integration PASS. 미확보 원문 비노출/출처 중복 방지/초안 자동작성 금지/배치 후 원문 유지/판정 비노출 검사 통과. M04 authored-manual contract PASS; GUT 27/27 tests,144 assertions PASS. 기존 통합 테스트 종료에서 CanvasItem 2/Font RID 오류와 ObjectDB 경고가 남음(정리 대기 후 10→8); 무경고 PASS가 아니다. fixture에서 collect_clue로 관측을 확보했으므로 정상 조사 입력 E2E나 사람 UX 검증으로 승격하지 않는다. 1280/1920 논리 배치 검사는 실제 디스플레이 캡처와 구별한다.

검토 1은 정보 누출/정답 자동 작성/출처 중복에 집중했고 검토 2는 초안 배치 이후 읽기 지속/기존 문서 레이아웃/구출 규칙 불변과 테스트 종료 경고를 확인했다. 다음 우선순위는 M04 실제 조사 입력→키워드 획득→작성한 규칙의 구출/회수 소비 및 반증 피드백 추적이다. 새로운 단위를 계획한 뒤 같은 루프로 진행한다. 전체 CLEAN_REVIEW_EXIT, 정상 플레이 완주, Human/출시 PASS는 미선언. Base 공용 승격 없음; 기존 자산/사용자 import 변경/열린 PR은 보존한다.

## 일반 저장 검증 후 교체 — 2026-09-13 continuation

승인된 개선 루프의 다음 단위. 계획: `docs/superpowers/plans/2026-09-13-verified-main-save.md`. 기존 generic GameState writer는 primary를 직접 WRITE로 열어 검증 전에 이전 내용을 비웠으며 store/flush 실패를 확인하지 않았다. 이제 동일 폴더의 `urban_legend_save.json.pending`에 먼저 기록하고 store 반환값/flush 후 오류/디스크 재읽기 바이트를 확인한 뒤 primary로 rename한다. 실패는 false로 회수 재시도 소비자에 전달한다. 성공한 rename은 staging을 소비하며 실패 시 최대 한 staging 파일만 다음 재시도에 재사용한다. load_game은 staging을 자동 승격하지 않는다.

기존 M01 transaction의 검증 후 교체 패턴을 ADAPT하되 migration identity/journal과 Validation 전용 legacy guard·payload schema를 일반 저장에 이식하지 않았다. M01/Validation 분기, 최종 JSON 형식·세이브 버전·보상·승인 자산은 그대로다. 공식 FileAccess/DirAccess 문서와 실제 프로젝트 세 writer를 비교했다. 원격 main c82291101bf0a2bb4d821a12bca9f14070ee2886, 기존 열린 PR 361/360/359/287/231은 read-only 확인; Base pin 미변경.

RED: `tests/recovery/generic_save_staging_test.gd`에서 staging 경로를 읽기 전용 사용자 디렉터리가 아닌 테스트 소유 빈 디렉터리로 막았을 때 기존 writer가 성공 처리/primary 변경하는 2개 실패를 재현. GREEN: 0 failures. Windows 테스트 primary만 read-only로 설정한 교체 실패에서도 기존 바이트 보존/권한 복구 후 재시도·load 통과. 테스트는 기존 TestSaveGuard와 project 내부 APPDATA/LOCALAPPDATA를 사용하며 외부 사용자 저장이나 권한을 바꾸지 않는다.

검증: recovery_save_retry의 기존 router refusal 및 신규 `--stage-failure` 모두 0 failures. Vulkan 실제 창 1280×720에서 `--stage-failure --capture`도 0 failures. 성공/통제 실패/승인 철수의 원래 결과·구출·보상·의뢰 게시판 보존 확인. `afterlife_migration_integration_test.gd` PASS. GUT 27/27 tests,144 assertions PASS. 변경 diff whitespace 검사 PASS. 이번 실행 출력에 종료 객체 경고 없음(과거 다른 회수 테스트의 경고 해결을 뜻하지 않음).

자체 검토 1: primary 사전 제거/이동 없음, 단일 sibling stage·오류 반환·retry 수렴·기존 로더 호환 확인. 검토 2: 실제 파일 실패부터 UI retry까지 연결해 synthetic router refusal만으로 I/O 검증했다고 주장하는 공백을 보완했다. 정상 게임 플레이 전체, 실제 입력, 1920 화면, disk-full/부분쓰기 fault injection, 전원중단/하드웨어 내구성, 다중 프로세스 동시 쓰기는 여전히 미검증이다. 남은 필수 작업은 M04 정상 플레이 E2E와 중단/재개·시계 정책/UI 검증. 전체 CLEAN_REVIEW_EXIT/Human/출시 PASS는 아니다.

학습: 정산 idempotency와 디스크 persistence 오류는 별도 경계로 검사한다. 프로젝트 교훈으로 보존하며 공용 Base 강제 규칙 승격 없음. 사용자 파일 삭제/이동 없음; 테스트가 생성한 빈 stage 장애물만 테스트 내 제거했고 기존 import/uid 변경은 보존했다. 롤백은 이번 단위 commit만 되돌리며 JSON은 기존 로더 호환이다.

## 회수 종료 저장 실패 재시도 — 2026-09-13

사용자가 계획 선행 방식과 첫 단위(종료 저장 실패 복구)를 승인했다. 계획은 `docs/superpowers/plans/2026-09-13-recovery-save-retry.md`. `save_recovery_result`는 기존 save_game의 bool을 반환한다. battle_scene은 종료 정산을 한 번만 수행하고, 실패하면 현장 처리/입력을 멈춘 상태에서 재시도 창을 유지한다. 재시도는 결과/보상을 재적용하지 않고 save_game만 호출하며 성공 시 결과 화면으로 이동한다. Escape로 유일한 재시도 경로가 사라지지 않는다. 미저장 상태에서 게임을 종료하면 진행 손실 가능성을 명시한다. 세이브 버전·보상량·사건 규칙·자산은 변경하지 않았다.

검증: 새 `tests/recovery/recovery_save_retry_test.gd`에서 성공/통제 실패/승인 철수 각각 저장 거부 후 무조건 결과 화면으로 이동하던 6개 실패를 재현하고 교정했다. 후속 headless 및 Vulkan 실제 창 1280×720 실행은 0 failures. 실제 GameState/ValidationSession의 저장 거부를 이용하며 반복 실패, 재시도 후 로드, 원래 판정/구출 유지, 보상/의뢰 중복 방지를 검사한다. 캡처 `.artifacts/daily-case-20260912/recovery-save-retry.png`는 embedded subwindow 진단 화면이다. 버튼 신호 실행이며 사람/물리 입력 증거는 아니다. 기존 GUT 27 tests/144 assertions PASS. 별도 실패 복귀 및 철수 복귀 0 failures이나 각 headless 종료에 ObjectDB 2개 경고가 남는다.

검토 1: 정산을 반복 호출하지 않고 저장만 재시도하도록 분리, 저장 전 결과 화면 이동 차단, 필드 정지와 재시도 처리 활성 상태 확인. 검토 2: 저장 로더의 optional first_terminal_outcome 추가 및 성공 resolved 복원은 정상 호환 동작이므로 테스트를 보상/게시판/원래 판정의 의미 불변으로 교정. 오류 메시지 상태도 재표시 시 갱신한다.

증거 상한/다음 계획: 이는 기존 저장 함수가 false를 반환했을 때의 소비자 복구다. M04의 일반 writer가 쓰기 중 오류·디스크 가득 참·전원 중단에서도 이전 파일을 보존하는지는 보장하지 않는다(직접 WRITE 경로는 별도 저장 내구성 작업 필요). M01 전용 transaction, Validation 저장 격리 및 기존 저장 버전은 유지했다. 정상 플레이 전체 경로, 실제 1920×1080, native dialog 물리 입력, 프로세스 종료 후 미저장 복구, 결과 Scene 로딩 오류 주입은 미검증이다. 전체 CLEAN_REVIEW_EXIT/Human/출시 PASS가 아니다. 다음 단위 착수 전 정상 플레이 계획에 저장 내구성 잔여 위험을 우선 반영한다.

원격 preflight main은 c82291101bf0a2bb4d821a12bca9f14070ee2886, 작업 기반은 8ffc4690f0e6e5a0b2a3d9e3f3dde7017f358270. 열린 PR 361/360/359/287/231은 변경하지 않았다. Base v9.4.4 pin 및 사용자의 import/uid 변경을 보존했다. 삭제/이동 없음. 공용 신규 도구나 Base 승격 없이 기존 오류 반환/정산 구조를 재사용했다.

## 구현 재개 — 2026-09-12

### 직접 철수 검토 연결 — 2026-09-12 continuation

승인된 일상/사건 구현을 계속한다. 실행 영수증은 `docs/qa/RECOVERY_CONTINUATION_20260912.json`이며 Base start/resume validator가 통과했다. Base local `68792fc38340a19945ba6b15eedef39f55d50705`와 fetched remote `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`를 구분해 읽었고 프로젝트 v9.4.4 pin은 변경하지 않았다. Base 재사용 profile의 옛 schedule 문구는 최신 일상/사건 사용자 결정을 덮지 않는다.

작업 전 문제: `approved_withdrawal`이 일상 사건 정산에서는 failure로 저장되었고 직접 철수 버튼이 없었다. 현재는 기존 정산 adapter가 legacy `retreated`와 canonical `approved_withdrawal`을 모두 retreat로 보존한다. 회수 화면 우측 하단의 **철수 검토** → 기존 보호 의무 확인창 → 취소/확정 → 결과 화면 → 일상 복귀를 연결했다. 안전 경로는 실제 `recovery_handoff_state.safe_withdrawal_route`만 읽는다. 미충족 조건은 통제 실패로 명시하며 안전 경로·보호 책임을 자동 완료하지 않는다. 취소는 종료/정산/보호 의무를 바꾸지 않으며 확정 직전 조건이 달라지면 다시 확인한다. 확정된 철수 사유는 기존 termination_preview 내부에 함께 저장한다. 기존 성공 목표를 이미 달성한 경우 성공을 철수로 덮지 않는다. 보상량·일정·핵심 시계 의미·세이브 버전·승인 자산은 그대로다.

실무 비교: Phasmophobia 개발사 Tempest 글의 목표/생환 조건 분리와 보상 반복 악용 문제를 ADAPT(https://www.kineticgames.co.uk/news/phasmophobia-tempest). SOMA Safe Mode 개발자 글의 경험 전체를 고려한 위협 조정은 참고하되 무적 모드 도입은 REJECT(https://frictionalgames.com/2017-11-what-is-somas-safe-mode/). 프로젝트에서는 기존 정책/확인창/결과 adapter 재사용을 채택했고 무조건 즉시 종료 또는 새 철수 미니게임·비용 시스템은 기각했다. 이는 공개된 설계/운영 사례 비교이지 외부 게임 비공개 코드 역공학이나 실제 플레이 검증이 아니다.

검증/교정: 정산 결과 오분류 1개 assertion 실패 → 교정. 직접 철수 버튼 부재 2개 실패 → 입력 연결. 취소·안전/비안전 경로·확인 도중 경로 변경·저장/로드·결과/일상 복귀의 실제 씬 fixture 통과. 사유 저장 누락 3개 실패 → 저장 교정 → 통과. 캡처에서 폐기된 ‘아카’ 안내문이 발견되어 활성 `log_guide`/환영 튜토리얼을 ‘루메 · 괴이기록국 기록 보조’로 교정했고 관련 실제 안내창 3개 assertion 실패 후 통과했다. 신규 그림이나 기각 자산은 사용하지 않았다.

Godot4.7.2/GUT9.7.1 최종 27/27 tests,144 assertions PASS. 별도 회수 실패 복귀 0 failures, direct-lead12/12, clock17/17, overlay8/8 PASS. headless 종료에서 ObjectDB2개 경고가 남으며, 렌더러를 켠 철수 fixture 최종 실행은 0 failures/종료 경고 없음이었다. 두 환경을 혼동하지 않는다. 새 테스트는 `tests/recovery/recovery_withdrawal_return_test.gd`; `--capture`는 실제 프레임을 `.artifacts/daily-case-20260912/withdrawal-visual/`에 저장한다. 1280×720 확인창의 텍스트/버튼을 실제 캡처에서 확인했다. 1920×1080 실행 요청은 실제 뷰포트가 동일 크기가 아니어서 1920 검증으로 인정하지 않는다. 이 테스트는 안전 경로 fixture를 주입한 **DIAGNOSTIC_ONLY**이며 일상부터 조사·구출을 정상 입력으로 완주한 E3/E5/Human 증거가 아니다.

저작은 exact urban-legend HiGodot session/editor PID39148에서 수행했다. 별도 외부 실행은 project 내부 APPDATA/LOCALAPPDATA로 격리했다. Hera는 해당 editor identity/guidance까지 확인했으나 외부 실행 game discovery가 비어 있어 Hera 실제 입력 PASS를 주장하지 않는다. 기존 editor/다른 프로젝트는 종료하지 않았다. HiGodot hot reload의 error43 메시지는 독립 새 프로세스에서 parse/GUT/render 실행이 통과했음과 별도로 기록하며 editor 재시작 검증은 하지 않았다.

독립 읽기 검토의 P2: Tab으로 배경 행동에 접근해 공유 확인창을 교체하면 철수 취소 callback이 사라지고 입력 잠금이 남을 수 있었다. 중첩 확인 요청/다음 포커스/취소 복원을 검사해 fixture3개에서 총9개 실패를 확인했다. 공유 overlay가 열린 동안 추가 확인 요청을 무시하고 다음/이전/방향 포커스를 확인·취소 안에서 순환하도록 교정한 뒤 렌더 실행 0 failures를 확인했다. 비활성 확인 버튼의 포커스는 취소로 간다. 이는 새 독립 확인창 구현 대신 기존 owner를 보강한 것이다.

남은 필수 작업: 정상 플레이 경로로 철수 책임 인계/입력 전체 검증, 1920 실제 뷰포트 검증, 긴 보호 의무 목록의 확인창 수용성, headless 음원 수명주기 경고, 종료 저장 실패의 사용자 복구 경로. 활성시간 시계·중단/재개·전체 Blueprint/UI 정본 동기화도 이전 목록대로 남아 있다. 이 변경을 전체 구현 완료·CLEAN_REVIEW_EXIT·Human/출시 PASS로 승격하지 않는다. 삭제나 삭제검토 이동은 이번 범위에서 하지 않았다. Base 환류는 프로젝트 검증 교훈으로 보존하고 공용 규칙 승격은 하지 않는다.

### 회수 실패 화면 연결 — 2026-09-12 후속

현재 승인 continuation의 bounded BUILD/REVIEW. `battle_scene`의 전원 행동 불능은 조사 화면으로 무기록 복귀하던 경로에서 `control_failure` 저장 → 결과 화면으로 연결했다. 중복 갱신은 하나의 deferred 종료로 모으고, 동일 step에 안정화 목표도 달성하면 기존 성공을 보존한다. 피해자 구조 결과·확보 기록·보상 수치는 바꾸지 않는다. 새 저장 필드/자산은 없다.

실패 M04는 성공 후일담 대신 현장 종료 기록을 표시한다. ‘회수 기록 없음’과 통제 실패/철수/승인 철수를 구분하며 실패에 완료 보고서·성공 보상·성공 후일담을 노출하지 않는다. 빠른 전환에서 RuntimeUiEditor의 두 프레임 지연 작업이 이미 나간 scene tree를 참조하던 오류도 생명주기 검사로 차단했다.

비교 근거: 기존 성공 자동종료/결과 씬/일상 결과확인 경로와 RecoveryOutcomePolicy를 재사용(ADAPT); 실패마다 별도 신규 씬은 중복 상태 증가로 DEFER; 위험 시계 6칸을 즉시 게임오버로 바꾸는 안은 기존 악화/책임 판정 의미 변경으로 REJECT. Godot 공식 SceneTree 문서(https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html)의 씬 입장/퇴장과 전환 수명주기를 확인했다. Base v9.4.4 pin은 변경하지 않았다. remote main `c82291101bf0a2bb4d821a12bca9f14070ee2886`, 열린 PR 361/360/359/287/231은 읽기 전용으로 확인했다.

검증: 추가 GUT 2개가 실패함을 먼저 확인 → 교정 → 26/26,116 assertions PASS. 별도 `tests/recovery/recovery_failure_return_test.gd`는 최초 3개 실패 및 중복전환/지연레이아웃 오류 재현 → 교정 → 0 failures, 최종 출력 오류/누수 경고 없음. 실제 SceneTree에서 회수 실패→결과→저장/로드→복귀 버튼→준비실 결과확인 버튼→planning까지 실행한다. `recovery_direct_lead_flow_test.gd`는 동시 목표달성/행동불능 fixture로 12/12 PASS, 종료 시 AudioStreamWAV/Playback 관련 ObjectDB 2개 경고는 남는다. 전조음 stop/stream 해제 시험은 이 경고를 해결하지 못해 제품 수정으로 남기지 않았다.

자체 검토 1차: 실패 정산과 성공 보상 분리, 중복 전환/목표 동시달성 확인. 2차: 실패에 ‘완료 보고서가 DB에 저장됨’ 표시 발견→회귀 테스트 실패 확인→비성공 표시 분리→전체 GUT 재실행. 이 범위의 기능 검사는 통과했지만 전체 CLEAN/Human/출시 PASS는 아니다. 학습은 기존 인계와 회귀 검사에 남기며 공용 Base 승격은 하지 않는다.

남은 범위: **직접 철수 선택→책임 조건 미리보기/확인→approved_withdrawal 또는 control_failure** 입력 연결, 중단/재개의 전체 경로, 활성시간 시계 정책 동기화, 1280×720/1920×1080 시각·포커스·사람 검증. 기존 시계 가득 참 자체는 즉시 실패가 아니라 기존 악화 규칙이며 바꾸지 않았다. main 병합/전체 정본의 일정·루메 legacy 문구 교정은 미완료. 실패 API/표시 준비를 철수 UI 완료로 오인하지 않는다. 롤백은 이 후속 커밋만 되돌리며 기존 사용자 import/uid 변경은 보존한다.

### 실패·철수 정산 후속 — 2026-09-12

검증 증거: Godot 4.7.2 / GUT 9.7.1, `tests/gut` 5개 스크립트의 24개 테스트·111개 assertion 통과. 프로젝트 내부 격리 저장 경로를 사용했다. 이는 자동 엔진 검증이며 실제 화면 조작·Human UX·출시 검증은 포함하지 않는다.

`save_recovery_result`의 성공/실패/retreated 종료 결과를 `CampaignState.settle_case_outcome`으로 연결했다. 사건별 선택 필드 `first_terminal_outcome`이 첫 success/failure/retreat를 보존하고 게시판을 한 번만 갱신한다. 실패·철수는 resolution_state를 resolved로 바꾸거나 성공 보고서/성공 보상을 만들지 않는다. 실패 후 재도전 성공은 성공 기록을 만들 수 있지만 같은 사건 게시판은 다시 갱신하지 않는다. 수락 의뢰는 계속 유지한다.

저장 호환: 기존 cases 객체에 선택 필드만 추가, 최상위 save version은 변경하지 않는다. 필드 없는 과거 resolved 사건은 이미 정산한 success로 읽어 재갱신을 막는다. 필드 없는 unresolved 저장의 과거 실패는 증거 없이 추정하지 않는다. 따라서 이 필드 도입 전 실패를 이미 본 세이브는 다음 실제 종료 호출에서 한 번 갱신될 수 있다. 구형 실행본으로 돌아가 저장하면 선택 필드가 탈락할 수 있으므로 다운그레이드 저장 왕복은 보장하지 않는다.

검증은 실패/철수→저장/로드→동일 종료→재도전 성공의 순서를 실제 GameState에 실행하며 성공 보고서 미생성, unresolved 유지, 게시판 불변을 검사했다. 첫 추가 검사에서 누락·재갱신을 재현 후 교정했다. 별도로 미완료/알 수 없는 사건 입력은 정산하지 않도록 검사한다. 결과 화면의 남은 ‘현재 반일 결과 확인’ 문구를 일상 복귀로 교정했다.

중요 잔여: 현재 battle_scene에서 save_recovery_result 호출은 core_recovered 성공뿐이다. **실패/철수 정산 API가 구현됐다는 사실은 위험 시계 종료/철수 버튼→실패 결과 화면 경로 구현 완료가 아니다.** 그 화면 경로와 중단(일시정지/출동취소) 구분, 저장 재개·가시적 결과·UI 검증을 다음 작업으로 진행한다. 이전 절의 ‘실패 정산 미구현’은 이 API 후속 이전 상태다.

### 외부 의뢰 후속 구현 — 2026-09-12

일상 준비실의 수락한 dispatch 의뢰에 편성 요원 선택/의뢰 수행을 연결했다. perform_daily_faction_request는 planning/활성 사건 없음/accepted dispatch/유효 요원을 확인하고 기존 assign_request→resolve_faction_request를 재사용한다. 기존 능력·장비 판정, 보상량, 취소 관계 비용, 회수 행동 의뢰 소비자는 유지한다. 완료/실패 결과 문장을 카드에 표시하고 저장 실패를 숨기지 않는다. 메인 메뉴와 준비실의 활성 반일 안내도 교정했다.

게시판은 기존 case resolution_state를 사용해 최초 성공 확정에서만 갱신하며 accepted 의뢰를 유지한다. 이미 resolved인 사건 재확정/저장 복원은 재갱신하지 않는다. 기존 record_current_case_report가 회수 성공만 기록하므로 **실패/철수 결과 최초 확정까지 포함하는 게시판 정산은 아직 미구현**이다. 새로운 실패 완료 의미나 저장 ledger를 임의로 성공 기록에 합치지 않았다. 따라서 의뢰 정산 전체 완료가 아니다.

근거/대안: 일상·사건 설계 §11(기존 의뢰 유지, 최초 사건 결과 갱신)을 채택하고 기존 판정/보상 재사용(ADAPT); 무제한 수동 새로고침은 파밍 위험으로 REJECT; 의뢰 삭제는 콘텐츠 손실로 REJECT. 신규 자산/보상/일상 행동력/날짜/세이브 버전을 추가하지 않았다.

테스트 우선 실행: 최초 추가3검사 실패 → 서비스/최초 성공 갱신 교정 후20/20 → UI 버튼 검사 실패 → 실제 버튼 연결 후21/21,89 asserts PASS. 저장 경로는 프로젝트 .artifacts/daily-case-20260912 내부로 격리했다. 검사는 재수행·재로드 차단, accepted 유지, 회수 의뢰의 일상 수행 차단, 활성 사건 중 파견 차단, 실제 준비실 버튼 신호→판정 결과를 포함한다. 이는 headless 씬 검증이며 화면 캡처/해상도/Human/경제 밸런스/출시 증거가 아니다. 기존 회수 종료 leak 경고는 이번에 수정하지 않았다.

최신 사용자 ‘프로젝트에서 남은 구현 업무 확인하고 진행해’로 확정된 일상/사건 구조의 구현을 재개한다. 아래의 이미지/기획 전용 보류는 이 범위에서 해제한다. 미승인 피해자 이미지, 외형 불합격 루메 모션, M07 후보 규칙의 최종 승인으로 확대하지 않는다.

첫 범위: 이미 보존 중이던 campaign_state/game_state/preparation/daily_episode/result 5개 로컬 변경을 검토하고 기존 일상/사건 테스트를 실행했다. 새로운 저장 복구 검사에서 (1) 실제 사건 없는 in_progress 저장이 출동을 막음, (2) 알 수 없는 operation status가 재개를 막음을 재현한 뒤 수정했다. 전자는 사건 기록을 유지하고 planning으로 복구하며 후자는 같은 사건을 suspended로 복구한다. completed 결과는 유지하고 확인을 한 번만 처리한다.

검증: Godot4.7.2 / GUT9.7.1, 새 테스트 전 14/14 통과 → 새 저장검사 포함17개 중2개 실패 → 교정 후17/17(67 asserts) 통과. 프로젝트 내부 .artifacts/daily-case-20260912로 APPDATA/LOCALAPPDATA를 격리한 재실행 및 Windows isolation PASS. 최초 baseline은 기존 TestSaveGuard 복구 성공을 확인했으나 live user data 경로에서 실행됐으므로 이후 격리 실행을 기준으로 삼는다. 회수 clock17/direct-lead12/overlay8/scene12 assertions 통과. direct-lead/scene 종료 시 ObjectDB2개 leak 경고가 각각 남아 무경고/전체 CLEAN은 아니다. 실제 화면 조작·1280/1920·Human/출시 검증 NOT_RUN.

남은 구현 순서(이번 검사 범위에서 확인, 전 프로젝트 전수 완료 목록 아님):
1. 외부 의뢰의 일상 파견/결과 표시와 최초 성공 확정 갱신은 위 후속 구현 완료. 실패/철수 최초 결과 정산과 게시판 갱신은 남음. legacy 일정 API는 호환성 표면으로 남겨 실제 참조 검토 없이 삭제하지 않는다.
2. 일상→조사→매뉴얼→회수→결과→일상의 실제 UI 입력 및 저장 재개 end-to-end 검증. 두 회수 테스트 종료 leak 원인 확인.
3. 승인된 능동시간 이중시계/열람 정지 상세안과 실제 소비자 차이, M01/M04 키워드 현장 적용·미니게임 반환을 사건별 회귀로 연결.
4. 메인 메뉴 6상태 버튼/문서형 매뉴얼 시각 통합 및 해상도/포커스 검증. 미승인 자산은 사용하지 않음.
5. Blueprint 후속 상태 통합, planning canon/JSON/overlay의 구형 일정 표현과 실행 증거를 함께 동기화. 현재 문서의 과거 PLANNING_COMPLETE는 전체 새 구현 완료 의미가 아님.

Base pin은 유지하며 신규 공용 도구/모듈은 추가하지 않는다. 이번 작업은 기존 CampaignState loader와 GUT 재사용이다. rollback은 해당 작업 commit을 검토하여 되돌리되 기존 저장/자산/무관 import 및 다른 작업 PR은 보호한다. main/PR 통합은 별도 exact-head 검증 전 보류한다.

## 파일 정리 방식 — 2026-09-12 사용자 지시

앞으로 삭제 가능 파일도 직접 삭제하지 않는다. 실제 참조·생성 관계·고유 변경을 확인한 항목만 outer project `../삭제검토/YYYY-MM-DD/`로 이동하고 사용자에게 폴더 링크를 제공한다. 원래 경로·이동 경로·크기·SHA-256·판정 이유를 MANIFEST에 남기고 이동 후 해시를 확인한다. 미확인 worktree/승인 원본/검증 입력/사용자 dirty 파일은 보존한다. 이 폴더는 정본·구현 입력이 아니며 사용자가 직접 삭제한다.

2026-09-12: Blueprint의 review/reference-revision/case-preparation-review/optimized-review 아래 페이지 렌더 PNG 286개, 48,583,758 bytes를 `../삭제검토/2026-09-12/`에 모았다. 모든 이동 전후 SHA-256 일치와 원본 위치 부재를 확인했다. PDF·PROMPTS·참고 이미지·21개 자산 원본·모션 시험·영수증은 보존했다. 예전 중간 렌더 레이아웃을 완전히 재현할 수 있다고 주장하지 않는다. 남아 있는 옛 작업 사본의 고유 변경은 미확인으로 KEEP_UNRESOLVED이며 전체 저장소 정리 완료가 아니다. 이전 턴에서 이미 삭제한 실패 합성6개는 이번 폴더에 포함되지 않는다.

## 최신 실행 범위 — 2026-09-11 블루프린트 제작

후속 상태 준비: [버튼 분리·루메 모션 시험 기록](design/BLUEPRINT_20260911_STATE_PREPARATION.md)을 읽는다. 6개 버튼 상태를 Aseprite 파생본으로 분리했고 루메 3프레임 시험은 눈 이외 색 변화로 적용 보류했다. 이 후속 기록은 현재69쪽 PDF에 아직 통합되지 않았으며 runtime 구현은 하지 않았다. 모션 외형 실패를 구조 검사 PASS로 덮지 않는다.

최신 시각 선택/최적화: 현재 전달물은 `output/pdf/URBAN_LEGEND_HUMAN_BLUEPRINT_20260911_OPTIMIZED.pdf`, 영수증은 `BLUEPRINT_20260911_OPTIMIZED_RECEIPT.json`이다. 첨부 사진풍 피해자3인 초상은 `USER_REJECTED_STYLE`로 현재 PDF/회수 합성에서 제외했다. 나머지 기존 활성17개 이미지의 시각 선택 승인은 `docs/design/BLUEPRINT_20260911_IMAGE_DECISIONS.json`의 exact hash 목록에 고정했다. 기각 후 생성한 애니풍 교체 초상은 신규 후보로 별도 승인 전이다. 이는 전체 기획/제품 자산 승격/runtime 승인이 아니다. 아래 CASE_PREPARATION/52쪽/46쪽은 이전 판 보존 이력이며 최신 실행 근거로 단독 사용하지 않는다.

후속 준비판: `output/pdf/URBAN_LEGEND_HUMAN_BLUEPRINT_20260911_CASE_PREPARATION.pdf`. 루메 SD 교정, M04/M07 괴이, 보호 대상3초상 atlas,6상태 버튼, 워드마크, M07 회수 부스 후보를 추가했다. 부록4B/4C는 M07 제안3장/9슬롯/15후보와 실제 구간·입력·반환·실패 계약을 소유한다. 런타임 파일은 수정하지 않았다. 최종 외형 승인·모션/전조 상태·실행 검증은 남아 있으며 이전52쪽/46쪽 PDF는 보존한다. 최신 receipt의 실제 검증 상태를 읽고 전체 완료로 추론하지 않는다.

최신 참고 이미지 교정 승인: M04 루메는 빨간 비옷+빨간 우산, 회수는 중앙 괴이/상단 관측 전조/우측 보호·대응, 기록·지도·매뉴얼은 문서형 구성이다. `BLUEPRINT_20260911.md` §14B/14C/15/17/25와 제작 계약의 참고 교정 항목을 적용한다. 최신 파생본은 `output/pdf/URBAN_LEGEND_HUMAN_BLUEPRINT_20260911_VISUAL_REVISION.pdf`; 이전46쪽 검토판은 역사 snapshot이다. 새로운 외형 후보 최종 LOCK과 게임 적용은 아직 아니다.

최신 사용자 요청으로 **블루프린트에 필요한 신규 실사용 이미지 후보 제작은 허용**됐다. 아래 2026-09-10의 이미지 보류만 이 범위에서 해제한다. 게임 구현은 여전히 최종 블루프린트 승인 이후다. [이번 제작 계약](design/BLUEPRINT_20260911_WORK_CONTRACT.md), [통합 검토 본문](design/BLUEPRINT_20260911.md), [사건·데이터 부록](design/blueprint-20260911-case-appendix.md)을 읽는다. 이 문서들은 승인 후보이며 기존 runtime 사실이나 승인 자산을 덮어쓰지 않는다.

예시 십보강호 PDF는 구조 참고 전용이다. 신규 PDF·source·후보는 프로젝트 내부에 유지한다. 후보 전체의 production readiness와 모션/전조/사건별 의상·인물 데이터 정합성은 실제 검증 전 완료로 선언하지 않는다. 기존 dirty 코드·세이브·승인 PDF·자산과 unrelated Draft PR을 보존한다. 전체 Planning Canon/JSON 동기화는 최종 선택 및 migration 검증 후 별도 implementation 계약에서 수행한다.

## 최신 실행 순서 예외 — 2026-09-10

현재 사용자 지시는 **기획·검토 먼저 / 이미지 제작·추가 구현 보류**다. 일정 폐기, 일상파트와 사건파트(조사·회수) 유지, M04 기존 귀가 기억 보조의 기본 사용 가능 방향은 승인됐다. 상세 범위·현행 충돌·보류 항목은 [일상/사건 구조 설계](superpowers/specs/2026-09-10-daily-case-structure-design.md) §9를 먼저 읽는다.

동일 설계 §10에 일상 상태 전이·실제 키워드 소비자·시계 진행 차이·텍스트 와이어프레임을 기록했다. 이후 사용자가 현장 실시간/매뉴얼 열람 정지 권장 방향을 승인하고 상세 규칙·재미·독창성 판단을 조사에 근거해 위임했다. **§11이 이번 상세 기획의 최신 변경안**이다. 시간 정책을 다시 승인 질문으로 올리지 않는다. 현행 턴 기반 시계를 실시간 구현 완료로 보고하지 않는다. 선택 기억 저장과 후속 대사 반응, 작성 노트와 authored 규칙 결과 텍스트를 구분한다.

아래 10일·반일 cadence/휴식 해금/완료 Gate는 이전 merged-main 구현의 기록이며 새 작업의 기획 승인 근거가 아니다. 현행 Planning Canon/JSON의 전면 동기화와 영향 검토는 아직 남아 있다. 일부 상태·UI 코드와 GUT 테스트는 로컬 검증 중으로 보존했으며 main 반영이나 전체 플레이 검증 완료로 해석하지 않는다. 이번 재개는 추가 코드·이미지 제작 또는 기존 Draft PR 병합 권한이 아니다.

> 상태: `PLANNING_COMPLETE / USER_APPROVED_VISUAL_DIRECTION_LOCK / RUNTIME_RECONCILIATION_MERGED / HUMAN_QA_PENDING`
> latest-main reconciliation: PR #322 merge `9fa32d32e8a5a2ad7d34a388695986b4ab81c6a7` (runtime implementation: `8d303f0f9414950273be934fd28c8fb1b3a21e18` · PR #224)
> M04 current-main continuation: PR #356 merge `a62b5341f3c4742192f7bfc0d11e1fb4897c1308` — recovery clocks/menu and main-menu identity surface are `M04_RECOVERY_AND_MENU_MAIN_MERGED`; Human QA remains `NOT_RUN`.
> 사람용 정본: repository `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`와 user PDF GDD
> 구조화 정본: `docs/CURRENT_PLANNING_CANON.md`, `docs/current-planning-canon.json`
> Notion 이전 영수증: `docs/migrations/NOTION_CURRENT_WORK_MIGRATION_2026-08-28.md` (Notion은 `HISTORICAL_READ_ONLY_NO_WRITE`)

이 문서는 다음 GPT/Codex가 구현 전 handoff나 과거 annual next-step을 현재 권한으로 오인하지 않도록 하는 continuation router다. 실제 구현 사실은 latest `main`의 code/data/Scene/test를 우선한다.

```yaml
status: RUNTIME_RECONCILIATION_MERGED
planning: COMPLETE
user_final_planning_declaration: APPROVED
plan_lock: RELEASED_TO_IMPLEMENTATION_GATE
runtime_implementation: MERGED_MAIN
runtime_merge_commit: 8d303f0f9414950273be934fd28c8fb1b3a21e18
product_reference_asset: PENDING
visual_direction_lock: USER_APPROVED
human_qa: NOT_RUN
poc_passed: NOT_DECLARED
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
ten_day_half_day_cadence: USER_APPROVED / IMPLEMENTED_NON_NUMERIC_CONTEXT / FOCUSED_MACHINE_VERIFIED
one_main_case_runtime_enforcement: IMPLEMENTED / FOCUSED_MACHINE_VERIFIED
keyword_composition: IMPLEMENTED_M01_M04 / DRAFT_ONLY / FOCUSED_MACHINE_VERIFIED / OTHER_CASES_PENDING
player_authored_manual_keyword_verification: USER_APPROVED / IMPLEMENTED_M01_M04 / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN
m04_bounded_preparation_capacity: USER_APPROVED / IMPLEMENTED_M04_ONLY / FOCUSED_MACHINE_VERIFIED / HUMAN_QA_NOT_RUN
m04_recovery_and_menu_surface: IMPLEMENTED_MAIN / FOCUSED_MACHINE_RUNTIME_CAPTURED / HUMAN_QA_NOT_RUN
primary_playable_core: INVESTIGATION_DEDUCTION_AND_RECOVERY
calendar_role: SUPPORTING_CAMPAIGN_CONTEXT_NOT_PRIMARY_FUN
```

`PLAN_LOCK`은 predecessor 기획 잠금 식별자이며 현재 값은 `RELEASED_TO_IMPLEMENTATION_GATE`다. 이를 runtime 미승인 상태로 되돌려 해석하지 않는다.

현재 시각 방향은 `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION`의 **현실적 한국 도시 누아르 환경 + 애니풍 인물·괴이 + 손그림 기록물 UI**다. 이 방향은 `docs/visual/VISUAL_DIRECTION_LOCK_PACKET_2026-08-28.md`가 소유하며, 첨부 Core Scene Board는 기획 검증용 `GENERATED_EXPLORATION`일 뿐 runtime asset/Scene/UI/Human QA가 아니다.

현재 accepted frontier는 `D-2026-08-29-PLAYER-AUTHORED-MANUAL-KEYWORD-VERIFICATION`, `D-2026-08-29-CORE-LOOP-PRIORITY`, `D-2026-08-28-TEN-DAY-HALF-DAY-CASE-CADENCE`, `D-2026-08-28-M04-SEQUENTIAL-NARRATIVE-RESULT-VIGNETTES`, `D-2026-08-30-M04-BOUNDED-PREPARATION-CAPACITY`, `D-2026-08-28-VISUAL-CANDIDATE-GENERATION-LOCK-ONLY-APPROVAL`다. **1차 플레이 경험은 조사·추리와 회수**이며, M01과 M04는 원본 출처가 남은 정상 키워드를 만들고 플레이어가 빈칸 추리문을 직접 채운다. 매뉴얼은 정답·변조·호환 점수를 알려 주지 않으며, 구출 미니게임과 `전조 → 가설 → 근거 → 대응` 회수 결과에서만 후보 규칙을 검증한다. M04는 세 기존 clue ID와 두 기존 rule page를 사건 데이터 하나에서 소비하며, 기록관 아카는 텍스트 안내만 제공한다. 10일·반일 일정은 준비·후일담·관계의 리듬을 주는 보조 캠페인 시스템이다. 현재 `CampaignState`는 첫 operation을 cycle main case로 고정하고 다른 사건의 same-cycle 계획/시작을 거부하며, 실제 완료한 대기·회복 반일을 `현장 준비 1/1` dispatch record로 보존해 M04의 기존 권나래 귀가 지원 가용 여부와 귀가 기억 후일담으로 연결한다. 이 게이트는 stats/정답/추가 지원/자동 발동을 만들지 않는다. 예전 M04 주차 수치와 tier bonus는 `SUPERSEDED`; day-based 새 숫자는 여전히 `UNDEFINED`다. M05+ keyword/manual 확장, M01/M04 entrance candidate의 최종 user `LOCK`, Human/new-player/accessibility/release QA는 여전히 별도 Gate다.

## 1. 재개 순서

```text
최신 사용자 지시
→ GitHub latest main + open PR/Issue + exact-head CI
→ repository current GDD / decision / handoff
→ docs/CURRENT_PLANNING_CANON.md
→ docs/current-planning-canon.json
→ docs/CURRENT_DECISION_OVERLAY.md
→ 실제 current code/data/Scene/test
→ 필요 시 2026-08-22 design/implementation plan과 역사 Ledger
```

## 2. 현재 구현된 제품 계약

- primary playable core: `INVESTIGATION → DEDUCTION / MANUAL → RECOVERY`; the calendar is supporting campaign context, not primary fun.
- approved cadence: `ONE_MAIN_CASE_PER_TEN_DAY_CYCLE / TWO_HALF_DAY_SLOTS_PER_DAY`; runtime implements the first-operation cycle lock, persisted non-numeric dispatch context, and Preparation docket; M04 alone also records one completed rest as a visible `0/1` or `1/1` gate for the existing Kwon support; numeric balance remains undefined.
- result authority: `COMPOSITE_RESULT`.
- legacy S/A/B/S grade는 history/mastery compatibility이며 current incident result를 덮어쓰지 않는다.
- additive optional `monthly_state`는 historical generic orchestration이며 case truth를 저장하지 않는다. 새 10일 timing consumer를 아직 소유하지 않는다.
- M01 저승역은 `M01_FIRST_SESSION` 10단계 causal orchestration과 `SERIAL_EXAM_FATIGUE_GUARD`를 사용한다.
- M01은 기존 Canon v2 loader/save migration/result runtime을 재사용한다.
- 메인 메뉴 제품 버전은 `scripts/core/product_version.gd`의 `Ver 4.3`이 중앙 owner다.
- 메인 메뉴는 관제실형 3-rail 구조를 사용하고 Legacy / Validation save·route 분리를 유지한다.
- M04 빨간 우산은 shared Investigation/Manual/Rescue/Recovery/Composite Result validation baseline까지 구현됐다.
- PR #356은 M04의 안정도 8칸·위험도 6칸 회수 시계, 우측 하단 `괴이 매뉴얼 열기`, 안정도 조건의 자동 회수 전환, legacy `대표 교체`·`회수 실행` 제거와 메인 메뉴의 archive/워드마크/분리 action plate를 current main에 통합했다.
- current keyword/manual state is split by coverage: CASE-01 and M04 page-local keyword composition are `IMPLEMENTED / MACHINE_VERIFIED`, while M05+ rollout and any mutated-candidate field-verification extension remain outside this slice.
- clarified manual contract: the player must fill readable blank sentences from investigation memory and provenance; the UI cannot reveal semantic correctness. Rescue/minigame and recovery are the field verification, not an automatic answer checker. CASE-01 and M04 candidate arrays/input consumers are implemented, CASE-01 complete-manual auto-reveal is disabled, and every player draft remains separate from Canon migration slots.

## 3. PR #224 postmerge Reality Gate

완료:
- `LEGACY_S_RANK_CONTRACT_REALIGNMENT_REQUIRED` → `REALIGNED_TO_LEGACY_MASTERY_COMPATIBILITY`.
- `MONTHLY_STATE_NOT_IMPLEMENTED` → `IMPLEMENTED_ADDITIVE_OPTIONAL`.
- M01 First Session orchestration → `IMPLEMENTED`.
- #181 main menu / Ver 4.3 → `IMPLEMENTED`; Issue #181 closed after merged-main readback.
- M04 shared-system validation baseline → `IMPLEMENTED`.

보존:
- 기존 Episode/victim/report/ANNUAL IDs rename 금지.
- legacy report만으로 month completion 추론 금지.
- 필수 진실을 성장·동료·장비·자동행동이 제공하지 않음.
- Human PASS를 자동화로 생성하지 않음.

## 4. 자동 검증 증거

PR #224 exact head에서 다음 계열이 GREEN이었다.
- core and documentation baseline
- full matrix
- Afterlife Station Canon v2 migration
- Canon v2 Runtime UX
- ANNUAL-MVP-001 / CORE-MVP-001
- Windows platform preflight
- documentation contracts
- visual capture automation

`Project Base Adapter`의 fail-closed 신호는 PR #226에서 공식 Base generator로 reconciliation했다. protected baseline은 `6b4a9e8080898536139c8e825179b389f8bf9d64`으로 갱신됐고, adapter/generated views 검증과 core full Godot regression이 GREEN인 exact head를 `9073b4730993149f89970a13fbe32d49f8f473e7`로 병합했다.

PR #356 integration exact head에서는 recovery clock 17건, direct-lead 12건, overlay 8건, dual-clock scene 12건의 focused Godot checks가 GREEN이었고, `docs/qa/captures/m04-current-main-integration/`에 메인·회수·매뉴얼-open capture가 남아 있다. 이 증거는 machine/runtime capture이며 Human/new-player/accessibility/device/release PASS가 아니다.

## 5. Product reference / Human gate

### 2026-08-28 visual-status clarification

`PRODUCT_REFERENCE_ASSET_PENDING`은 모든 자산이 미승격이라는 뜻이 아니다. 개별 제품 승인·runtime 상태는 `ASSET_MANIFEST.yml`과 `CURRENT_VISUAL_WORK_ORDER.md`가 소유한다. 현재 root manifest의 9개 entry 중 M01 Investigation/Recovery background, M01 B/C·D cutout, CASE-01 루메 매뉴얼 보조 초상, M04 Investigation/Recovery background, M04 B/C·D cutout은 각각의 승인·구현·runtime evidence를 가진다. 반면 M01 Entrance, M04 Entrance와 Human/new-player/accessibility/release QA는 별도 Gate에 남는다.


`PRODUCT_REFERENCE_ASSET_PENDING` 유지:
- concrete M01/M04 이미지·레이어
- rights/source approval
- 최종 1280×720 / 1920×1080 가독성
- release-near M04 visual/audio/VFX polish

Exception recorded: M01 D-risk `afterlife_d_cutout.png` is `PROJECT_ASSET_APPROVED / IMPLEMENTED / 1280_RUNTIME_VERIFIED` under Issue #246. Its 1920×1080 capture and Human QA remain pending; this exception does not promote other M01/M04 assets.

Human QA는 계속 `NOT_RUN`:
- M01 첫 세션 이해도
- serial-exam fatigue 체감
- M04 재미/첫인상/차별화
- 접근성·실제 입력 체감

## 6. Base governance reconciliation 완료

- PR #226에서 project-pinned Base generator를 사용해 adapter + generated views를 갱신했다.
- protected baseline: `6b4a9e8080898536139c8e825179b389f8bf9d64`.
- reconciliation merge: `9073b4730993149f89970a13fbe32d49f8f473e7`.
- 제품 `data/`, `scripts/`, `scenes/`, `assets/`, `addons/`, `project.godot` 재변경 없이 Project Base Adapter 및 Base 9.4.x 검증을 GREEN으로 닫았다.
- 남은 제품 Gate는 실제 Human QA와 product-reference asset 승인/후속 release-near 구현이다.

## 7. 이전 구현 계약의 역할

다음 문서는 완료된 구현의 설계·계획 provenance로 보존한다.
- `docs/audits/2026-08-22-final-planning-implementation-reality-gate.md`
- `docs/superpowers/specs/2026-08-22-post-planning-runtime-reconciliation-design.md`
- `docs/superpowers/plans/2026-08-22-post-planning-runtime-reconciliation-implementation-plan.md`

이 문서들을 다시 Task 1부터 실행하지 않는다. 새 작업은 latest main의 실제 상태에서 successor를 판정한다.

## 8. 완료 판정 경계

현재 **runtime reconciliation implementation은 main 병합 완료**다. 그러나 프로젝트 전체 제품 완료를 의미하지 않는다.

```yaml
runtime_reconciliation: COMPLETE_MERGED
human_qa: NOT_RUN
product_reference_asset: PENDING
production_expansion: NOT_APPROVED
base_adapter_baseline_reconciliation: COMPLETE
```
