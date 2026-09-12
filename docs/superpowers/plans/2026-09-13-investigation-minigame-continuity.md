# 조사 → 미니게임 매뉴얼 연속성

승인된 개선 루프, FEATURE_SLICE. 현재 source: daily-case-structure-design §10.2/10.3, investigation_scene의 method signal→resolve_investigation_method, minigame_scene drawer와 rain_dodge의 Input polling. 핵심 정답/시계 수치/자산/저장 버전은 바꾸지 않는다.

## 사전 비교와 선택

- Outer Wilds 개발사 https://www.mobiusdigitalgames.com/outer-wilds.html (2026-09-13 원문 확인): 환경 위험을 도구·관측으로 시험하는 패턴을 ADAPT. 시간 루프는 REJECT. M04 현재 12초 회피에는 세 번째 빗소리 timing consumer가 없으므로 규칙 활용 완료라고 하지 않는다.
- 기존 Phasmophobia Chronicle의 기록 재열람 evidence 재사용. 현장 노트의 실제 선택 문장을 전달한다. 답안 채점/자동 진행은 하지 않는다.
- REUSE_FIRST: 기존 AnomalyManualDrawer, GameState.get_authored_manual_draft_lines, scene lock signal을 사용한다. 신규 overlay/새 저장소/신규 시각 자산 없음.
- 대안 1: 입력만 차단하고 시간/빗방울 진행 유지는 안전한 열람을 보장하지 못해 REJECT. 대안 2: 매뉴얼을 아예 잠그는 것은 조사 지식 활용을 끊어 REJECT. 대안 3: 미니게임 노드의 실행 모드를 일시 중단하고 원래 모드를 복구하는 국소 정지 ADAPT. 게임 전체/오디오/다른 UI는 멈추지 않는다.

## 계획 및 수용 기준

1. 실제 조사 방법 선택 신호→확보 출처→작성→CCTV 조건 통과→미니게임 진입 통합 테스트. RNG seed만 통제하고 collect_clue/성공 효과/조건 플래그를 주입하지 않는다. 물리 입력/정상 플레이 완주와는 구분한다.
2. 저장된 실제 작성 문장을 미검증 섹션으로 보여 준다. 고정 조작 안내와 별도 출처로 구분한다.
3. drawer open/close는 idempotent하게 원래 process_mode를 저장/복원한다. Input polling도 중단한다. 완료된 game의 set_process(false)를 되살리지 않는다.
4. 읽는 동안 위치/시간 동일, 닫은 뒤 재개, 중복 open, 완료 뒤 open/close 검증. 기존 회수/매뉴얼/GUT/문서 검사 회귀 실행.
5. 실제 규칙 timing 구현 부재와 이번 열람/입력 수리의 증거 상한을 인계한다. 다음 루프는 기존 사건 진실에 맞는 world-action timing 수용 실험이며 초안 문자열로 세계의 정답을 바꾸지 않는다.

롤백: 이번 변경 commit. 새 save field 없음. 사용자 자산/import/uid와 열린 PR을 보존한다. Base pin 유지, 추가 유료 도구 없음. 실행 스킬은 프로젝트 feature-slice, 테스트 우선, systematic-debugging/verification; AgentMemory session 도구는 미제공이라 repository handoff를 fresh-read했다.

## 실행·재검토 결과

- 실제 조사 방법 선택 신호로 우산/표지판 기록을 확보하고 매뉴얼 열기→슬롯/후보 버튼으로 초안을 작성→CCTV 진입→매뉴얼 열람 중 위치/시간 고정→재개→조사 복귀까지 연결했다. 초안 저장 API 직접 주입도 제거했다. RNG seed는 통제하며 최종 실패는 `_complete(false)`로 주입하는 진단이다. 정상 플레이 전체 완주/Human 증거가 아니다.
- drawer 중복 open의 포커스 덮어쓰기와 process mode 복원, 종료된 게임의 비재시작 검사 통과. 매뉴얼을 닫자마자 Scene이 바뀌면 deferred grab_focus가 트리 밖 opener를 호출하는 실제 오류를 재현했다. workbench가 호출 시점에 opener의 생명주기를 확인하도록 교정했다.
- 조사 화면의 숨겨진 호환 Label 두 개에 Scene 소유권을 부여했다. orphan-node 누적과 Font RID/CanvasItem 경고는 사라졌지만 반복 headless 실행 일부에서 AudioStreamWAV/AudioStreamPlaybackWAV 각 1개 종료 경고가 남는다. 이를 무경고 PASS로 포장하지 않는다.
- M04 추리문 고정 문장이 ‘실제 출구가 아니라’라고 플레이어 선택 전에 답을 배제하던 결함을 RED→교정했다. 8개 text segment만 중립적인 인용 문장으로 변경했다. 키워드/단서/사건 진실/판정/수치/자산은 그대로다.
- 긴 결과 기록 검사는 Control 논리 좌표를 물리 Window.size와 비교하고 있었다. headless window 64×64 / logical 1280×1280을 실제 readback하고 get_visible_rect 기준으로 교정했다. 실제 Vulkan 1280 실행 및 1920×1080 요청 실행 모두 통과. 후자는 OS 창 제약으로 실제 1920×1061, logical 1302×720이므로 정확한 1920×1080 렌더 증거가 아니다.
- 검토 1: 초안/조작 안내의 출처 분리, 노트에 의한 자동 성공 금지, 입력 polling/시간 동시 정지 확인. 검토 2: UI 작성부터 왕복 흐름으로 확대하여 지연 포커스 오류를 추가 발견/교정하고 기존 계약 회귀를 실행했다.
- GUT 27 tests / 144 assertions PASS, Python Base operating/active references 25 PASS. workbench, authored-manual contract, drawer, minigame controls/pipeline/scene smoke 기능 PASS. 새 통합 Vulkan 1280 실행 0 failures/종료 경고 없음. headless 일부 audio 종료 경고는 남음.
- 다음 필수 구현 감사: 현행 rain_dodge는 12초 회피일 뿐 ‘세 번째 빗소리’의 실제 timing 판정이 아니다. 기존 회수 패턴과 미니게임의 세계 규칙을 섞거나 초안 문자열로 정답을 바꾸지 않고 실제 행동 소비처를 추가 검토한다. 전체 CLEAN_REVIEW_EXIT/출시 PASS는 미선언. 프로젝트 교훈만 기록하며 Base 공용 승격 없음.
