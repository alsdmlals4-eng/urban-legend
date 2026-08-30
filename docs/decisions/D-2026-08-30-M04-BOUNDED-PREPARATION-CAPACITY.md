# D-2026-08-30 — M04 제한된 준비 용량

> 역할: `CURRENT_IMPLEMENTATION_DECISION`
>
> 상태: `USER_APPROVED / IMPLEMENTATION_AUTHORIZED / MACHINE_VERIFICATION_PENDING`
>
> 사용자 승인 근거: 권장안 B를 진행하라는 연속 승인과, Godot에서 구현을 계속 진행하라는 최신 지시.
>
> 구현 추적: [Issue #351](https://github.com/alsdmlals4-eng/urban-legend/issues/351)
>
> 벤치마킹 근거: `docs/benchmarks/M04_BOUNDED_PREPARATION_CAPACITY_2026-08-30.md`

## 결정

M04 빨간 우산에서만, 실제로 끝난 `대기·회복` 반일 하나를 `현장 준비 1/1`로 저장한다. 해당 준비가 있으면 기존 권나래의 `귀가 기억 고정` 회수 지원을 한 번 선택할 수 있다. 준비가 없으면 같은 지원은 비활성화되고, 이유가 회수 화면에 표시된다.

## 이유

이 결정은 조기 출동의 피해자 보호와 한 반일 준비의 의미 있는 교환을 만들되, 달력이 핵심 추리보다 앞서지 않게 한다. 준비는 이미 존재하는 보호 지원의 사용 조건일 뿐, 단서·정답·가설·전조·구출·회수 기준을 제공하거나 변화시키지 않는다.

## 데이터와 저장 경계

- `CampaignState`가 완료된 `schedule` 결과 중 `rest`만 기록한다.
- dispatch context에는 `m04_preparation_capacity: 0 | 1`과 최대 한 건의 완료 준비 반일 provenance를 넣는다.
- active operation과 resolved M04 case의 context가 이 값을 그대로 보존한다.
- 이전 save에 이 기록이 없으면 용량은 `0`으로 복원한다. top-level save version을 올리지 않는다.

## UI와 플레이 흐름

```text
준비실: 대기·회복 반일 완료 여부와 현장 준비 0/1 표시
→ 출동 기록: 조기/정규 + 실제 준비 상태를 확인
→ M04 회수: `작전 상태 → 요원 지원`에서 준비가 있을 때만 기존 귀가 기억 고정 지원 선택; 잠김 이유/사용 완료 상태를 같은 위치에 표시
→ 결과 귀가 기억: 준비/지원 사용 여부를 사건 인과로 기록
```

## 제외와 롤백

- M01, 다른 사건, 사건 JSON의 진실/단서, 새 캐릭터·이미지·음향은 범위 밖이다.
- 준비를 여러 번 써도 더 큰 효과·추가 사용·자동 대응을 만들지 않는다.
- 문제가 생기면 이 decision의 diff만 되돌리면 기존 non-numeric dispatch context와 기존 회수 지원으로 복귀한다. 기존 save는 새 필드가 additive이므로 롤백 후에도 읽힌다.

## 검증 계약

1. 완료되지 않은 배정은 준비 용량을 만들지 않는다.
2. 완료된 `rest` 한 번은 M04 dispatch context와 resolved case context에서 `1/1`로 남는다.
3. 구 save의 누락 필드는 `0`으로 안전하게 복원된다.
4. M04만 지원을 gate하며 M01의 기존 지원 목록은 바뀌지 않는다.
5. 1280×720/1920×1080에서 준비·회수·결과의 한국어 안내와 mouse/keyboard 흐름을 실제 Godot runtime으로 확인한다.
