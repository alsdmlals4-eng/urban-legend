# 2026-08-29 Player-authored Manual Adversarial Review

> 범위: `D-2026-08-29-PLAYER-AUTHORED-MANUAL-KEYWORD-VERIFICATION`의 planning-canon 교정
> 코드·data·asset 변경: 없음
> automated evidence: 문서 정합성 검증 예정; Human/player evidence `NOT_RUN`

| loop | 실패 가정 | fresh evidence | 교정 또는 판정 | 결과 |
| --- | --- | --- | --- | --- |
| 1 | AI가 키워드 시스템을 가설 목록으로만 이해했다 | M01에는 slot/evidence가 있으나 `candidate_keywords: []`; 조사 Scene 매뉴얼은 읽기 전용 | 플레이어가 빈칸을 채우는 입력·후보·출처 flow를 current decision과 GDD에 명시 | `CORRECTED` |
| 2 | 매뉴얼 UI가 정답을 알려 주거나 정상 클리어가 답안을 공개한다 | M01 `normal_clear.reveal_complete_manual: true`; live composition consumer 없음 | auto-reveal을 successor stale behavior로 표시하고, semantic verdict 금지·현장 검증을 승인 규칙으로 고정 | `CORRECTED / RUNTIME_FOLLOW_UP_REQUIRED` |
| 3 | 변조 후보가 별도 가짜 단서 생산비와 기억 혼란을 만든다 | 2026-08-03 predecessor의 one-variable derivation | 정상 키워드 원본만 출처를 갖고, 변조는 독립 source를 갖지 않는 계약으로 제한 | `CORRECTED` |
| 4 | 과거 문서의 공격/취약 전투를 현행 회수에 되살린다 | `battle_scene.gd`는 telegraph → hypothesis → evidence → response baseline | predecessor combat semantics는 superseded; rescue/minigame과 stabilization recovery로 재표현 | `CORRECTED` |
| 5 | active M01 packet·사용자 첨부 비교 이미지를 current runtime/asset으로 오인한다 | active packet의 stale global runtime-not-authorized wording, local user-provided binary, repository consumer 없음 | packet을 successor keyword-only boundary로 고치고, 이미지는 planning UI reference로만 기록하며 binary를 저장소에 복사하지 않음 | `CORRECTED` |

## 외부 벤치마크 교차검토

- Source: [Game Developer — Pursuing the “Aha!” moment with deductive reasoning game The Case of the Golden Idol](https://www.gamedeveloper.com/design/case-of-the-golden-idol) (developer interview, opened 2026-08-29).
- `ADAPT`: 제한된 문구와 읽을 수 있는 빈칸은 player가 조사 정보를 추론으로 표현하는 데 유용하다. 직접 정답 판정이 복잡한 사건에서 좌절을 키울 수 있다는 제작자 인터뷰의 관찰은, 본 프로젝트가 semantic verdict 대신 현장 검증을 쓰는 근거다.
- `REJECT`: 타 게임의 사건, 표현, 화면, 부분정답 수치, 스타일을 복제하지 않는다.
- Risk retained: 현장 검증만으로도 후보 대입이 가능할 수 있다. 후속 slice Human QA는 조사 기억·원본 출처가 실제 선택 근거가 되는지, 아니라면 후보 수·변조 위치·feedback density를 조정해야 한다.

## Incident / Solution / Lesson

- Incident: current docs named keyword composition but did not make player-authored blank-manual interaction the primary operation; M01 data further contained an answer-reveal flag inconsistent with the clarified user decision.
- Solution: current Decision, GDD, canon, overlay, and handoff now state the non-answer-revealing manual-to-field-verification contract and the exact runtime gap.
- Lesson: `NO_BASE_PROMOTION`. The general lesson is already covered by Base evidence/provenance rules; the actionable contents are project-specific.

## Exit condition

Five full loops completed. No remaining planning-canon conflict is known after the documented corrections. Runtime implementation, save behavior, image asset approval, player usability, and player experience remain outside this review and `NOT_RUN`.
