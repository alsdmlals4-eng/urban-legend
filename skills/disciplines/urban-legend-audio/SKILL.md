---
name: urban-legend-audio
description: Use for Urban Legend BGM, SFX, voice-event, mixing, silence, and audio-accessibility design grounded in scene purpose and equivalent non-audio cues.
---

# Urban Legend Audio

## Core principle

사운드는 긴장·규칙·상태 변화를 강화하지만 정답이나 필수 정보를 소리만으로 전달하지 않는다. 음소거·청각 접근성에서도 동등한 단서를 제공한다.

## Use when

- BGM·환경음·SFX·음성 이벤트와 침묵의 역할을 설계한다.
- 사건·대화·UI의 오디오 상태와 믹싱 우선순위를 정의한다.
- 오디오 신호와 자막·아이콘·문구 폴백을 함께 검토한다.

## Do not use when

- 오디오 파일 import·압축·Manifest만 관리한다.
- 대사 문장 자체를 작성한다.
- 전체 게임 규칙을 변경한다.

## Skill modes

- `direction`: 장면별 음향 목표·모티프·밀도·금지 방향을 정의한다.
- `event-spec`: 트리거·조건·재생·중단·반복·폴백 계약을 작성한다.
- `mix-review`: 실제 장면에서 음량·우선순위·피로도·가독성을 검수한다.

## Required inputs and read first

1. `docs/CURRENT_STATUS.md`
2. `docs/GAME_DESIGN_DOCUMENT.md`
3. `docs/planning/PROJECT_DIRECTION.md`
4. 관련 서사·UI·Scene 파일
5. 실제 오디오 자산과 이벤트 연결
6. `TEST_CHECKLIST.md`

## Workflow

```text
장면 목적·상태 변화·플레이어 정보 확인
→ BGM·환경·SFX·음성·침묵 역할 분리
→ 트리거·우선순위·반복·중단·폴백 정의
→ 실제 Scene·UI 이벤트와 연결
→ 음소거·동시 재생·장시간 피로도 검수
→ 미실행 청취 QA와 장치 범위 보고
```

## Definition of Ready

- 대상 장면과 상태 변화, 필수 정보·감정 정보가 구분됐다.
- 재사용 가능한 기존 자산과 라이선스·형식을 확인했다.
- 음소거·자막·시각 폴백 기준이 있다.

## Definition of Done

- 필수 정보는 소리 외 동등한 방식으로도 전달된다.
- BGM·SFX·음성이 서로 핵심 대사와 선택을 가리지 않는다.
- 반복·중단·장면 전환에서 중첩과 누수가 없다.
- 실제 청취하지 않은 환경은 `NOT_RUN`으로 기록한다.

## Validation and failure conditions

- 장면 전환, 동시 재생, 음소거, 볼륨 단계, 폴백 노출을 검증한다.
- 소리만으로 규칙·정답 전달, 과도한 놀람 자극, 대사 마스킹, 루프 누수, 라이선스 불명 자산 사용이면 실패다.

## Related skills

- 서사·대사: `urban-legend-narrative`
- UX·접근성: `urban-legend-ux-ui-accessibility`
- 파이프라인: `urban-legend-technical-art-pipeline`
- 변경 검증: `reviewing-and-validating-project-changes`
- 학습 기록: `skills/SKILL_LEARNING_LOG.md`
