# 미니게임 종료 저장 실패 복구

승인된 개선 루프 continuation, FEATURE_SLICE / CAMPAIGN_CORE. 기준 HEAD 5149b02304348b61940321456443b6c1dfdd312e, main c82291101bf0a2bb4d821a12bca9f14070ee2886. 기존 open PR은 read-only. Base pin v9.4.4 유지.

## 현재 문제와 비교

GameState.save_minigame_result는 결과/효과를 메모리에 적용한 뒤 save_game의 실패를 버린다. MinigameScene._return_to_flow도 save_game 성공 여부와 무관하게 퇴장한다. 따라서 완료 UI가 디스크 보존을 보장하지 않는다. 기존 recovery save retry/staged writer를 REUSE/ADAPT한다. Godot FileAccess 공식 문서(2026-09-13 https://docs.godotengine.org/en/stable/classes/class_fileaccess.html)의 저장 오류 반환과 기존 실제 소비자를 확인했다. Phasmophobia Chronicle의 기록 재열람은 기존 조사 evidence REUSED_EVIDENCE이며 새로운 실플레이 벤치마크를 주장하지 않는다.

대안: 무시하고 복귀 REJECT(진행 손실), 결과 전체를 재실행 REJECT(효과 중복), 메모리 결과를 보존하고 기존 복귀 버튼에서 저장만 재시도 ADAPT(기존 UI·상태 재사용, 새 모달/저장 필드 불필요). 플레이어 가치는 실패 후 같은 미니게임과 보상을 반복하지 않는 것이다.

## 구현 순서·수용 기준

1. 실제 stage 파일 경로를 테스트 소유 빈 폴더로 막아 성공/실패 결과 모두에서 디스크 실패를 재현한다. 이전 primary 바이트 보존, 재시도 안내, 실패 중 퇴장 금지, 반복 결과 신호/재시도에서 효과 중복 금지를 먼저 검사한다.
2. save_minigame_result의 bool 반환을 소비자에 연결한다. 기존 payload/버전/효과량/사건 ID는 그대로다. 기존 반환값 무시 caller는 호환된다.
3. 종료 결과는 한 번만 정산하고 실패 시 기존 복귀 버튼으로 저장을 재시도한다. 목적지 저장이 실패하면 현재 Scene 경로를 메모리에 복구한다. 로드/재시도 후 실제 목적지와 원래 결과를 확인한다.
4. 기존 미니게임 pipeline·controls·조사 왕복·GUT·문서 검사를 실행하고 실제 창에서 안내를 확인한다. 두 차례 결과 전체 재검토 및 교정.

제외: 새 중간 저장, 미니게임 판정/사건 진실 변경, M01 migration 교체, 새 이미지·오디오, main 직접 push/다른 PR 변경. 롤백은 이번 commit. user save는 TestSaveGuard로 보존하며 테스트 obstacle만 정확한 경로에서 제거한다. 일반 파일 삭제는 하지 않는다.

## 구현·검증 결과

- 실제 staged writer 실패에서 성공/실패 두 경우 총 12개 실패 RED→교정. bool 반환을 GameState→MinigameScene까지 연결했다. 종료 정산은 기존 `_completed` guard로 한 번만 실행하며 재시도는 `save_game`만 호출한다. 실패 중 현재 Scene 유지, 이전 primary 보존, 장애물 해제 후 조사 복귀/로드와 원래 결과/수치/기록 보존을 검사했다.
- 저장 실패 시 기존 현장 기록에 미저장 안내, 기존 복귀 버튼에 ‘저장 다시 시도 · 현장 복귀’를 표시한다. 별도 팝업/타이머/저장 스키마 없음. 목적지 저장 실패는 메모리의 현재 Scene 경로를 복구한다. 화면 열기 실패 안내도 추가했으나 scene-loader 실패 주입은 NOT_RUN이다.
- 검토 1: 반복 결과 신호와 반복 저장에서 위험/이해/안정/정신력/미니게임 기록이 중복되지 않는지 검사. JSON 수치의 int→float 복원 차이는 의미 비교로 바로잡았으며 필드 존재 검사도 추가했다.
- 검토 2: 실제 Vulkan 1280×720 화면에서 매뉴얼 버튼이 저장 재시도를 가리는 결함 2개 RED→종료 버튼을 같은 VBox 순서로 재배치해 교정. 초기/저장된 결과 모두 동일 배치를 사용하고 진행 중 매뉴얼 우측 하단 배치는 유지한다. 최종 캡처 `.artifacts/daily-case-20260912/minigame-save-retry.png` 확인.
- 새 저장 복구 검사 headless/Vulkan 0 failures. 기존 조사→작성→미니게임 왕복, minigame pipeline/controls PASS. GUT 27/27 tests,144 assertions PASS; Base operating/active references unittest 25 PASS. 종료 신호 주입과 테스트 소유 I/O 실패이며 정상 미니게임 완주/사람 UX/출시 PASS가 아니다. M01 정상 pipeline은 회귀했으나 M01 전용 저장 실패 주입은 미검증이다.
- Phasmophobia Chronicle 원문을 다시 열어 기록 재생/종료 후 debrief 재열람 및 Outer Wilds 원문의 관측 도구/변화하는 환경을 확인했다. 이를 기록 보존·관측/해석/행동 분리 방향에 ADAPT하며 게임을 직접 플레이하거나 비공개 코드를 역공학했다고 주장하지 않는다.
- 새 공용 abstraction/스킬은 만들지 않았다. ‘종료 정산과 디스크 저장 성공을 분리하고 모든 퇴장 consumer에서 오류를 처리’하는 교훈을 프로젝트에 기록한다. Base 승격은 후보이지 완료가 아니다. 기존 사용자 import/uid·다른 PR·자산은 보존. 테스트 소유 빈 stage 장애물만 제거했다.
