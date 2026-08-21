# M01 저승역 Deduction Scene Packet

Status: PLANNING_COMPLETE / CANON_V2_ALIGNED / IMPLEMENTATION_NOT_AUTHORIZED

Source PR: #217
Parent canon: `docs/CURRENT_PLANNING_CANON.md`
Incident canon: `docs/CURRENT_AFTERLIFE_STATION_CANON.md`

## Purpose

조사에서 확보한 기록과 키워드를 괴이 매뉴얼로 연결하는 추리 단계 정의.

## Core Loop

Investigation
→ Keyword / Record collection
→ Evidence provenance check
→ Hypothesis comparison
→ Rule writing
→ Return to field if evidence is insufficient

## Manual Structure

1. 발생 조건
2. 피해자 연결
3. 금지 행동
4. 구출 절차
5. 회수 대응

저승역 Canon v2의 3장 매뉴얼은 이 5개 의미 슬롯을 단계적으로 학습시키는 사건별 chapter 구조다. M01 첫 튜토리얼에서 5개를 동시에 정답 처리하지 않고, 발생 조건·피해자 연결부터 열어 이후 조사로 금지 행동·구출 절차·회수 대응을 해금한다.

## M01 Initial Keywords

- 목적지 공백
  - Source: 안내방송 원본
  - Meaning: 객관적 목적지 정보 결손
- 서로 다른 목적지
  - Source: 피해자 진술 비교
  - Meaning: 개인 인식 차이 가능성
- 검은 승차권
  - Source: 현장 조사 물품
  - Meaning: 괴이 연결 매개 후보

## First question and four candidates

첫 질문: **저승역의 목적지는 어디에서 생기는가?**

### H1 공식 원본 목적지설

Claim:
- 공식 안내방송 원본에 실제 목적지가 들어 있다.

Refute:
- 공식 운행 로그와 원본 방송에 목적지가 없다.

### H2 단일 가짜 목적지설

Claim:
- 모든 청자가 동일한 하나의 가짜 목적지를 듣는다.

Refute:
- 같은 시각 청취자들이 서로 다른 목적지를 기록한다.

### H3 개인 기억 투영설

Support:
- 방송 원본의 목적지 공백
- 동시 청취자의 서로 다른 목적지
- 각 기록과 개인의 귀환 기억 사이의 대응

Unresolved at first:
- 승차권과 반복 잔향이 어떤 역할을 하는지 추가 확인 필요

### H4 검은 승차권 원인설

Support:
- 이상 승차권 발견

Weakness:
- 승차권 없는 동시 청취자도 개인 목적지를 들음
- 승차권은 목적지 생성의 필수 조건이 아니라 잔향·매개 흔적일 가능성

## Expected reasoning path

1. H1·H2를 공식 원본과 동시 청취자 기록으로 배제한다.
2. H3·H4를 경쟁 가설로 유지한다.
3. 승차권 없는 청취자의 기록으로 H4를 약화한다.
4. H3를 근거 확보 상태로 올리되, 구출·회수 행동을 자동 선택하지 않는다.

## Rules

- 조사 단계에서 정답 확정 금지.
- 근거 부족 시 현장 복귀 가능.
- 키워드는 반드시 출처 기록 유지.
- 추리는 규칙 작성이며 단순 정답 선택이 아님.
- 정답 후보를 색·위치·크기로 미리 강조하지 않음.
- 공식 승차권 구출 규칙과 검은 승차권 원인설을 혼동하지 않음.
- planning은 완료됐지만 `runtime_implementation: NOT_AUTHORIZED` 동안 runtime mutation은 하지 않는다.

## Next Gate

Victim Rescue application, then Recovery. Deduction completion alone does not resolve the incident.
