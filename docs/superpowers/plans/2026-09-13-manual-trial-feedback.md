# 대응 당시 매뉴얼과 현장 결과 연결 계획

## 승인 범위와 판단

최신 사용자 승인인 조사→기획 구체화→연결 구현 개선 루프의 bounded continuation. 기존 사건 정답/가설/보상/시계와 이미지 승인은 바꾸지 않는다. FEATURE_SLICE + CAMPAIGN_CORE, 테스트 우선 진행.

실제 consumer 비교에서 M04는 direct response이며 guided context만 보존하는 기존 anomaly_manual_record 경로에 진입하지 않는다. 공통 recovery_pattern_learning은 이미 모든 대응의 성공/실패/사유/시도 횟수를 저장하므로 이를 재사용한다. 사건마다 최신 패턴 시도 하나라는 기존 보존 범위는 유지한다.

## 벤치마킹과 대안

source_and_evidence: https://www.kineticgames.co.uk/news/phasmophobia-chronicle-v013 (2026-09-13 원문 열람). observed_pattern: journal 기록 재열람, 종료 후 debrief 재개, 도구 작동 피드백. project_fit_and_difference: 판단 당시 기록과 실제 결과를 재대조하는 구조로 ADAPT. 금전/XP/멀티플레이 규칙은 REJECT. 이전 manual-observation-loop의 Outer Wilds / Expelled! 연구는 REUSED_EVIDENCE이며 이번 기능은 시간 루프/일정을 도입하지 않는다. benchmark_preflight_state=COMPLETE; 공개 자료 비교이지 비공개 코드 또는 실제 플레이 역공학이 아니다.

1. 현재 초안을 결과에서 실시간 조회: 저장은 단순하지만 수정하면 과거 판단도 바뀌므로 REJECT.
2. 모든 사건을 guided 방식으로 변환: 핵심 입력 변경/정답·가설 새 저작이 필요하므로 DEFER.
3. 기존 공통 대응 기록에 당시 초안 사본을 보존: REUSE/ADAPT. 현장/결과/완료 보고서가 같은 기록을 소비한다. 초안과 행동의 의미 일치 판정은 추가하지 않는다.

## 구현 순서

- [x] 실제 battle 대응→기록→초안 수정/로드→반복 전조→결과 소비 테스트를 먼저 실패시킨다.
- [x] bridge의 초안 문장 조합을 GameState read-only getter로 이동해 현재 열람/기록 snapshot이 같은 필터를 사용한다.
- [x] recovery_pattern_learning 항목에 optional authored_draft_lines, pattern_name, response_label을 추가한다. 기존 필드 의미/버전은 유지한다. absent는 이전 기록, empty는 미작성으로 표시한다. current case report에 학습 기록 사본을 포함한다.
- [x] 공통 formatter로 현장 기록, 결과(성공/실패/M04 순차 화면), 보관 보고서를 연결한다. 미검증 초안임을 명시한다. 긴 M04 기록은 기존 body를 스크롤 가능하게 한다.
- [x] 통합/이전 초안 drawer/GUT 및 저장 호환 검증. 검토 1: 사건 경계·과거 스냅샷·정답 자동승격 금지. 검토 2: 성공/실패/이전 저장/긴 기록 소비.
- [x] exact diff/branch readback, 인계에 검증 범위와 남은 단절을 기록한다. 게시 후 exact HEAD는 작업 완료 보고에서 확인한다.

## 저장·롤백·완료 경계

기존 dictionary 안의 additive optional metadata이며 reader는 absent 기본값을 쓴다. 기존 저장 필드를 제거하지 않는다. 추가 메타데이터가 없어도 기존 판정·보상·로드가 그대로 동작해야 한다. 이전 코드로 롤백하면 metadata를 무시하고 기존 표시로 복귀한다. 모든 시도 영구 로그나 실패 사건 아카이브는 신규 설계로 범위 밖이다. 성공 보고서의 기존 최신 1건 정책 유지.

완료 증거는 실제 씬 handler/저장 round-trip/결과 표시이며 정상 조사부터 미니게임 전체 플레이·Human·출시 승인과 구분한다. 기존 사용자 import/uid, 열린 PR, Base lock, 승인 자산을 보존한다. Base 공용 승격은 NO_NEW_REUSE_LEARNING으로 유지한다.
