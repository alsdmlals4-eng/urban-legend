# D-2026-07-31-MAIN-DAILY-SCHEDULE-PRESENTATION — 메인 무인 화면·일일 일정 편성

> 상태: `APPROVED_PLANNING_BASELINE`
> 승인일: 2026-07-31
> 사용자 지시: “메인화면엔 캐릭 안 보이게 해. 일정은 하루씩 짜는거야.”
> 추적: Issue #121 / Draft PR #122
> 구현 권한: `NONE`
> Runtime / Human QA: `NOT_RUN`

## 1. 결정 목적

직전 비주얼 화면 보드에서 잘못 표현된 두 항목을 수정하고, 후속 SCREEN 명세와 이미지 제작의 우선 규칙으로 고정한다.

이 결정은 `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY`와 `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS`의 화면 책임은 유지하되, SCREEN-01과 SCREEN-05의 표현·입력 규칙을 보정한다.

## 2. SCREEN-01 메인 화면 — 캐릭터 비노출

메인 화면에는 캐릭터를 표시하지 않는다.

### 허용 요소

- 괴이기록국 건물·관제실·도시 야경·비 내리는 역 등 프로젝트 고유 장소
- 게임 로고와 메뉴
- 현재 사건·저장 상태·업데이트 공지의 짧은 정보
- 빈 복도, 꺼진 관제 장비, 비정상 신호 등 간접적인 괴이 흔적
- 기록국 문서·단말기형 UI

### 금지 요소

- 주인공 또는 동료의 전신·반신·초상
- 캐릭터 단체 포즈
- 캐릭터 실루엣을 전면 키비주얼처럼 배치
- 메인 메뉴에서 인물 선택이나 파티 편성을 암시하는 구성

### 첫인상 목표

캐릭터가 아니라 다음 요소로 장르를 전달한다.

```text
현대 서울의 익숙한 장소
+ 비어 있는 기관·역 공간
+ 기록·관제 UI
+ 설명되지 않은 괴이 흔적
```

메인 화면은 인물 소개 화면이 아니라, 플레이어가 괴이기록국의 세계로 들어가는 조용하고 불길한 진입점이다.

## 3. SCREEN-05 일정 화면 — 하루 단위 편성

일정은 주간 활동 묶음을 한 번에 고르는 방식이 아니라 **하루씩 직접 편성**한다.

### 기본 조작 흐름

```text
날짜 선택
→ 해당 날짜의 활동 선택
→ 비용·피로·예상 변화 확인
→ 하루 일정 확정
→ 다음 날짜 선택
```

### 화면 구조

- 4주 × 7일 달력은 전체 기간과 마감을 보여주는 개요로 사용한다.
- 실제 입력과 확인의 기본 단위는 `1일`이다.
- 선택한 날짜의 상세 패널에서 활동·동료·연구·휴식·출동 여부를 결정한다.
- 주간 자동 편성이나 주간 활동 묶음 선택을 기본값으로 두지 않는다.
- 복사·템플릿 기능을 사용하더라도 플레이어가 날짜별 결과를 확인하고 수정할 수 있어야 한다.

### 현재 미확정 세부사항

다음 항목은 후속 일정 화면 설계에서 사용자 확인 후 확정한다.

- 2~3일 활동이 연속 날짜를 자동 점유하는지
- 하루에 한 활동만 가능한지, 오전·오후 분할이 존재하는지
- 이미 확정한 다음 날짜를 언제까지 수정할 수 있는지

## 4. 직전 이미지 판정

직전 생성한 7종 화면 보드는 다음 두 항목 때문에 `SUPERSEDED_PLACEHOLDER`로 처리한다.

1. 메인 화면에 캐릭터가 노출됨
2. 일정 화면이 주간 묶음 편성처럼 표현됨

나머지 그림체·UI 방향과 7종 화면 구분은 참고할 수 있으나, SCREEN-01과 SCREEN-05의 레이아웃 근거로 사용하지 않는다.

## 5. Benchmark Gate

```yaml
main_no_character:
  gate: NOT_APPLICABLE
  reason: user-approved project visual rule
schedule_daily_input:
  gate: REUSED_WITH_DETAIL_REVIEW
  basis: existing 4x7 schedule benchmark and user-approved interaction correction
implementation_authority: NONE
```

## 6. 연결 Decision

- `D-2026-07-31-VALIDATION-SCREEN-AUTHORITY`
- `D-2026-07-31-EXTENDED-MANAGEMENT-SCREENS`
- `D-2026-07-31-VISUAL-ART-DIRECTION`
- `ANNUAL-MVP-002`

## 7. 다음 Gate

```text
일일 일정의 시간 해상도 확정
→ SCREEN-01 무인 메인 화면 상세 명세
→ SCREEN-05 하루 단위 일정 화면 상세 명세
→ SCREEN-01~07 목적형 Benchmark·와이어프레임
→ 보드 A·B 재생성
```
