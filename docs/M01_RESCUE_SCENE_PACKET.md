# M01 저승역 Rescue Scene Packet

Status: PLANNING_COMPLETE / CANON_V2_ALIGNED / IMPLEMENTATION_NOT_AUTHORIZED

Source PR: #218
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Incident canon: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`

## Purpose

피해자 구출은 전투 승리가 아니라 조사에서 확정한 괴이 규칙을 적용해 안전하게 분리하는 단계다.

## Flow

Investigation → Deduction / Anomaly Manual → Victim Rescue → Recovery

## Rescue Goal

- 피해자의 현재 상태 확인
- 괴이 연결 약화
- 안전 경로 확보
- 회수 조건 준비

## Action Types

### 기억 확인
피해자의 실제 목적과 괴이가 만든 기억을 비교한다.

### 안전 경로 확보
괴이 영향이 약한 이동 경로를 만든다.

### 연결 차단
매개체 또는 규칙 조건을 끊는다.

### 보호 유지
피해자가 다시 괴이 조건에 노출되지 않도록 한다.

## M01 application sequence

1. 안내 종료 전 개인 목적지를 향해 승차선·계단·출구 경계를 넘지 않는다.
2. 위치가 초기화되어도 시간·녹음·배터리·기록은 유지된다는 관측을 사용한다.
3. 이하린이 돌아가고 싶은 장소와 사건 직전의 현실 교통 이용 기록을 구분한다.
4. 현실 귀환 경로와 일치하는 **공식 승차권**을 회수한다.
5. 지정 역에서 피해자와 함께 하차해 괴이 연결을 분리한다.

검은 승차권 접촉·파괴는 구출 정답이 아니다. `대기 / 이동` 입력은 조사에서 만든 규칙을 플레이어가 적용하는 수단이며 매뉴얼이 자동 실행하지 않는다.

## Rescue-to-recovery handoff

- 구출 결과는 피해자 상태·연결 강도·안전 경로·확보 기록을 snapshot으로 남긴다.
- 회수는 별도 Phase이며 구출 성공이 회수 승리를 자동 보장하지 않는다.
- 회수 실패나 승인 철수는 이미 구출한 피해자를 소급 삭제하지 않는다.

## Guardrails

- 체력 소모형 구조 금지.
- 정답 규칙 없이 강제 해결 금지.
- 실패 시 새로운 기록을 남긴다.
- 핵심 정보는 확률 실패로 영구 손실하지 않는다.
- 구출 조작 실패와 추리 실패의 이유를 구분한다.
- planning은 완료됐지만 `runtime_implementation: NOT_AUTHORIZED` 동안 runtime mutation은 하지 않는다.

## Next

`docs/M01_RECOVERY_SCENE_PACKET.md`의 세 Canon v2 패턴으로 이어진다: 목적지 합창, 회귀 승강장, 무정차 환송.
