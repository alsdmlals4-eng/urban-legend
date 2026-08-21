# 괴이기록국 M01 저승역 Investigation Scene Packet

Status: PLANNING_COMPLETE / CANON_V2_ALIGNED / IMPLEMENTATION_NOT_AUTHORIZED

Source PR: #216
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Incident canon: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`

## Core rule

Investigation follows:

장면 → 서술 → 현재 가능한 행동 → 기록/키워드/이동 해금

Actions must reflect current location and obtained evidence.

## Scene 01 · 저승역 승강장 진입

Situation:
- Empty platform
- Repeating announcement
- Missing destination information
- Abnormal tunnel signal
- 피해자 이하린의 동선과 현실 교통 기록이 아직 분리되지 않은 상태

Available:
- 전광판 조사
- 승강장 주변 조사
- 방송 방향 확인
- 역사 내부 진입 경로 확인

Locked:
- 방송 기록 확인 (방송실 접근 필요)
- 검은 승차권 확인 (아이템 미획득)

## Scene 02 · 전광판 조사

Obtain:
- 목적지 공백
- 시간 정보 불일치
- 반복 안내 패턴

Unlock:
- 방송 원본 추적
- 기록 비교

## Scene 03 · 승강장 주변 조사

Obtain:
- 현장 흔적
- 검은 승차권 잔향/매개 흔적 후보
- 피해자 관련 단서

Unlock:
- 검은 승차권 확인

## Scene 04 · 검은 승차권 확인

Available:
- 인쇄 상태 확인
- 날짜 비교
- 기록 장치 대조

Obtain:
- 승차권 이상 패턴
- 관련 키워드

## Scene 05 · 방송실 접근

Available:
- 방송 원본 확인
- 로그 비교
- 삭제 구간 분석

Obtain:
- 목적지 공백 출처
- 기록 누락

## Required comparison records

첫 추리 질문을 열기 전에 다음 비교가 가능해야 한다.

- 공식 운행 로그와 원본 방송에는 목적지가 없다.
- 같은 시각 청취자들이 서로 다른 개인 목적지를 기록했다.
- 검은 승차권이 없는 동시 청취자도 개인 목적지를 들었다.
- 피해자의 현실 교통 이용 기록과 공식 노선/역 식별 정보는 개인이 돌아가고 싶은 장소와 다르다.

검은 승차권은 반복 잔향 또는 매개 흔적 후보이며, 목적지 생성·구출·회수의 자동 정답이 아니다. 접촉·파괴 해법을 구형 PoC에서 되살리지 않는다.

## Guardrail

- Core truth cannot be permanently lost by random failure.
- Character exposure remains limited.
- Investigation does not directly reveal final deduction.
- 관측 사실과 해석을 별도 상태로 남긴다.
- 공식 기록과 개인 기억을 도덕적 진실/거짓말로 단순 판정하지 않는다.
- planning은 완료됐지만 `runtime_implementation: NOT_AUTHORIZED` 동안 product code/data/Scene/save mutation은 시작하지 않는다.
