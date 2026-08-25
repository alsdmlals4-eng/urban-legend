# D-2026-08-25-RECOVERY-CONTEXT-ACTION-HIERARCHY

Status: `APPROVED_BY_USER`
Date: `2026-08-25`
Scope: `Recovery Phase interaction hierarchy + visual presentation`
Runtime implementation: `NOT_IMPLEMENTED_BY_THIS_DECISION`
Human evidence: `HUMAN_QA_NOT_RUN`

## Decision

회수 Phase의 상시 기본 행동은 **공격 / 보호 / 보조** 세 카테고리로 압축한다. 이 세 항목을 선택하면 관련 세부 행동 목록이 2단 메뉴로 열린다.

괴이 파훼는 기본 행동 카테고리와 별개의 `CONTEXTUAL_TELEGRAPH_RESPONSE` 층에서 처리한다. 괴이의 **전조**가 발생하면 현재 장소·현상에서 실제로 수행 가능한 구체 행동을 제시한다. 예시는 `위로 이동`, `좌로 이동`, `안내판 조작`, `방송 장치 조작`, `문 닫기` 등이며 사건마다 달라진다.

## Knowledge-reuse rule

회수 화면은 전조의 정답을 새로 가르치지 않는다. 플레이어는 앞선 **조사·기록·추리문·괴이 매뉴얼**에서 확보한 키워드와 규칙을 기억하거나 다시 확인해 상황 행동으로 번역해야 한다.

- 키워드 자체를 다시 고르는 퀴즈가 아니라, 키워드가 의미하는 규칙을 현장 행동으로 실행한다.
- 올바른 행동을 선택해야 전조를 파훼하고 안정화/봉쇄에 진전한다.
- 정답을 색·확률·추천 마크·강제 동료 대사로 미리 노출하지 않는다.
- 괴이 매뉴얼 재열람은 허용하되 `이번에는 N번을 누르라`는 식의 직접 답안은 제공하지 않는다.

## Failure-forward rule

오대응은 단순 HP 손실로 끝내지 않는다.

```text
오대응
→ 괴이 반응
→ 비용/위험 상승 또는 보호 상태 악화
→ 실패 관측 기록 생성
→ 이후 판단 근거로 재사용
```

따라서 실패 관측 기록도 사건 지식 축적 루프에 포함된다.

## Visual hierarchy

Recovery 화면의 정보 우선순위는 다음과 같다.

1. 괴이 현현체
2. 다음 전조
3. 보호 대상
4. 참조 규칙
5. 전조 대응 행동 (`CONTEXTUAL_TELEGRAPH_RESPONSE`)
6. 기본 행동 **공격 / 보호 / 보조**
7. 동료/자원 상태

캐릭터는 평상시 작은 상태 Portrait를 사용하고, 의미 있는 지원/스킬 순간에만 짧은 anime-style Cut-in을 사용한다.

## Rejected predecessor

기존 시안의 `보호 / 관찰 / 대응 / 공격 / 장비 / 봉쇄 / 후퇴`를 모두 동일한 상시 1차 행동으로 노출하는 구조는 폐기한다. 이유는 일반 RPG command soup처럼 보이며, 이 게임의 핵심인 **전조 해석 → 과거 지식 회상 → 현장 행동 실행**을 시각적으로 약화하기 때문이다.

## Visual evidence ceiling

2026-08-25 생성된 CASE-01 저승역 Recovery 시안은 분위기·괴이·전조·보호 대상 배치 참고에는 사용하지만 행동 hierarchy가 predecessor라서:

`REFERENCE_MOCKUP / REVISION_REQUIRED / NOT_PRODUCT_ASSET`

으로 보존한다.

Receipt:
- SHA-256: `606cb6998d4d1d08b44f96fe508b777e631786f05fdbd9a8c0d2b307dbe0e4d2`
- source: `1672x941`
- bytes: `2399097`
- Notion: Home + `04 · Visual · UX · Assets` native attachment/readback

## Next visual gate

다음 Recovery 이미지는 이 결정만 반영한 **수정 전체 시안 정확히 1장**을 먼저 만든다. 사용자 검수 뒤 승인되면 `Recovery Telegraph Badge`, `Recovery Context Action List`, `공격/보호/보조 Category Bar` 등 재사용 구성요소로 분해한다.

이 결정은 Recovery interaction 의미를 승인한 것이며 runtime 구현, product asset 승격, 1280×720/1920×1080 runtime readability 또는 Human QA PASS를 의미하지 않는다.
