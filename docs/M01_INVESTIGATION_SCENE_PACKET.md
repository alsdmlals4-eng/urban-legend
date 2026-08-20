# 괴이기록국 M01 저승역 Investigation Scene Packet

Status: PLAN_LOCK / VISUAL_DIRECTION_APPROVED / IMPLEMENTATION_NOT_AUTHORIZED

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
- 검은 승차권 후보
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

## Guardrail

- Core truth cannot be permanently lost by random failure.
- Character exposure remains limited.
- Investigation does not directly reveal final deduction.
