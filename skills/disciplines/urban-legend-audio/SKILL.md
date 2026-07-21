---
name: urban-legend-audio
description: Use for Urban Legend BGM, SFX, voice-event, mixing, silence, and audio-accessibility grounded in scene purpose and equivalent non-audio cues.
---

# Urban Legend Audio

> 공통 실행·DoR·DoD·보고·구조 개선 계약: `skills/disciplines/PROJECT_DISCIPLINE_CONTRACT.md`

## Purpose and boundary

사운드는 긴장·규칙·상태를 강화하지만 정답이나 필수 정보를 소리만으로 전달하지 않는다. 음소거·청각 접근성에서도 동등한 단서를 제공한다.

- Use: BGM·환경음·SFX·음성 이벤트·침묵, 오디오 상태·믹싱 우선순위와 자막·아이콘·문구 폴백 설계.
- Do not use: 오디오 import·Manifest만 관리, 대사 문장 작성, 전체 게임 규칙 변경.

## Modes

`direction → event-spec → mix-review`

## Read first

1. `docs/CURRENT_STATUS.md`
2. `docs/PROJECT_CORE.md`
3. `docs/GAME_DESIGN_DOCUMENT.md`
4. `docs/planning/PROJECT_DIRECTION.md`
5. 관련 서사·UI·Scene
6. 실제 오디오 자산·이벤트
7. TEST_CHECKLIST.md

## Domain workflow

- 장면 상태 변화와 필수·감정 정보를 구분해 BGM·환경·SFX·음성·침묵 역할을 나눈다.
- 트리거·우선순위·반복·중단·폴백과 음소거·동시 재생·피로도를 검수한다.

## Done and failure gate

- 필수 정보가 비음향 방식으로도 전달되고 BGM·SFX·음성이 대사와 선택을 가리지 않는다.
- 장면 전환에서 중첩·누수가 없고 미실행 청취 환경은 `NOT_RUN`이다.
- Failure: 소리만으로 규칙·정답 전달, 과도한 놀람 자극, 대사 마스킹, 루프 누수, 라이선스 불명 자산이면 실패다.

## Selective support

접근성 계약은 `urban-legend-ux-ui-accessibility`, 변경·회귀 증거는 `reviewing-and-validating-project-changes`.
