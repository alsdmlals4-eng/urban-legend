# D-2026-08-02-VALIDATION-PERSISTENCE-BOUNDARY

> 상태: `APPROVED`
> 승인 시각: 2026-08-02 11:10 KST
> 승인 출처: 사용자 `권장안 대로 진행`
> 상위 Decision: `D-2026-08-02-PACKAGE-1-PLANNING-APPROVAL`
> 관련 Proposal: `P-2026-08-02-VALIDATION-CHANGE-PROPOSAL`
> 구현 권한: `NOT_AUTHORIZED`

## 1. 결정

Validation 진행·완료 결과는 본편·Legacy 진행과 **완전히 독립된 기록**으로 유지한다.

```text
Validation save
≠ Legacy save
≠ 본편 campaign/economy/relationship state
```

Validation에서 생성되는 다음 정보는 Validation 저장소에만 남는다.

- 현재 flow stage와 checkpoint
- 준비 Snapshot
- 사건 가설·시간순 증거 상태
- 안전 노선 결과
- 회수 패턴별 분류·기록·중립 행동·복구 사용
- 결과 원시 4축과 표시 요약
- Validation 사건 보고서·매뉴얼 후보
- 연구 질문·보급 후보
- apply-once effect ledger
- 완료 상태와 완료 시각

Validation 완료만으로 다음 본편 상태를 생성·수정하지 않는다.

- 캠페인 사건 해결
- 일정·날짜·operation 진행
- 잔향·재화·시장·소모품
- 장비·연구·관계 해금
- 세력·의뢰·일상 에피소드
- Legacy 사건 보고서·매뉴얼
- 본편 저장 버전·migration 상태

## 2. 플레이어 약속

- Validation은 저승역 대표 경험을 검증하는 독립 실행 기록이다.
- Validation 완료는 본편 진행 완료나 보상 획득을 뜻하지 않는다.
- 메인 메뉴에서는 `기존 진행`과 `Validation 기록`을 서로 다른 저장 종류로 표시한다.
- Validation 기록을 삭제·초기화해도 Legacy 저장은 변하지 않는다.
- Legacy 기록을 삭제·초기화해도 Validation 저장은 변하지 않는다.
- 향후 본편 가져오기가 필요하면 별도 Decision과 별도 Package로 설계한다.

## 3. 채택한 대안

### A — 완전 독립 Validation 기록

판정: `APPROVED / RECOMMENDED`

선정 이유:

1. 현재 목표는 본편 통합이 아니라 버티컬 슬라이스 경험과 저장·복구 안전성의 검증이다.
2. 기존 `GameState`는 캠페인·경제·관계·보고서를 함께 저장하므로 즉시 공유는 오염 면적이 크다.
3. 독립 구조는 Legacy byte와 메모리 무변경을 명확한 수용 기준으로 만들 수 있다.
4. 향후 가져오기는 독립된 명시적 transaction으로 추가할 수 있어 가역성이 높다.

## 4. 기각·보류한 대안

### B — 완료 후 명시적 1회 가져오기

상태: `DEFERRED_WITH_BOUNDARY`

- Package 1 범위에서 제외한다.
- migration·중복 적용·버전 호환·취소 UX가 필요하다.
- 실제 플레이테스트에서 본편 연동 요구가 확인될 때 재검토한다.

### C — 공용 프로필에 일부 즉시 공유

상태: `REJECTED_FOR_CURRENT_SCOPE`

- 별도 저장 외에 세 번째 권위 원본이 생긴다.
- 격리 원칙과 Legacy 무부작용 증명이 약해진다.
- 공용 프로필의 수명·버전·삭제 책임이 현재 기획에 없다.

## 5. Package 1 설계 영향

### 저장 Namespace

```yaml
legacy_path: user://urban_legend_save.json
validation_path: user://urban_legend_validation_save.json
shared_profile_path: NOT_CREATED
validation_slot_count: 1  # RECOMMENDED_DEFAULT
```

### 활성화

- Validation은 명시적 Session 활성화로만 시작한다.
- Session token·save version·episode ID가 일치하지 않으면 fail-closed한다.
- 암묵적 Scene 경로나 Legacy flag로 모드를 추정하지 않는다.

### 저장 라우팅

```text
Validation active
→ Validation runtime whitelist capture
→ Validation repository write
→ Legacy file write 금지
→ 숨은 Legacy memory mutation 금지

Validation inactive
→ 기존 Legacy save/load/clear 의미 유지
```

### 완료 처리

- 완료 transaction은 Validation 저장에 결과와 ledger만 기록한다.
- Legacy `resolve_campaign_case()`, 보상, 해금, 보고서 upsert를 호출하지 않는다.
- 완료 후 메인 메뉴로 복귀하되 두 저장은 독립 상태를 유지한다.

## 6. 수용 기준

1. Validation start/save/load/delete/complete/corrupt recovery 전후 Legacy 파일 bytes가 동일하다.
2. 동일 과정 전후 campaign·economy·relationship·faction·market 메모리 Snapshot이 동일하다.
3. Legacy start/save/load/clear 전후 Validation 파일 bytes가 동일하다.
4. Validation 완료를 반복 호출해도 Validation ledger 효과가 한 번만 기록된다.
5. Validation 완료 뒤 Legacy 보고서·재화·해금·일정에 diff가 없다.
6. 두 저장이 모두 있을 때 각각 독립적으로 inspect·continue·delete할 수 있다.
7. corrupt/incompatible Validation 저장은 Legacy를 읽거나 쓰거나 삭제하지 않는다.
8. 공용 프로필 파일이나 암묵적 공유 상태가 생성되지 않는다.

## 7. 재검토 조건

다음 중 하나가 실제 증거로 확인될 때 B 대안을 별도 Decision으로 재검토한다.

- 신규 플레이어 다수가 Validation 완료 기록의 본편 이전을 기대함
- 본편 첫 사건과 Validation이 동일 정본 사건으로 통합됨
- 안정적인 import transaction·preview·cancel·idempotency 설계가 준비됨
- 공유할 기록의 단일 권위와 버전·삭제 정책이 승인됨

## 8. 반영 위치

- `docs/CURRENT_CONFIRMED_DECISIONS.md`
- `docs/CURRENT_HANDOFF_VALIDATION.md`
- `docs/superpowers/specs/2026-08-02-validation-session-save-isolation-design.md`
- Draft PR #125
- Google Sheet `00_프로젝트_허브`, `01_작업순서`, `02_현재_확정결정`, `04_누락_충돌_감사`, `99_변경이력`

## 9. 검증 상태

```yaml
planning_consistency: PASS
canonical_sync: PENDING_READBACK
product_diff: 0
runtime: NOT_RUN
human_qa: NOT_RUN
implementation: NOT_STARTED
merge: NOT_REQUESTED
```
