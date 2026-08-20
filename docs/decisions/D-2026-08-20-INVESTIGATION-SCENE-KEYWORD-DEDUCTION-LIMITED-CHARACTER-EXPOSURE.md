# D-2026-08-20 · Investigation Scene → Keyword → Deduction + Limited Character Exposure

- Status: `USER_APPROVED_DIRECTION / PLAN_ONLY`
- Approval date: `2026-08-20`
- Product code/data/Scene/save authorization: `NOT_GRANTED`
- Planning lock: `ACTIVE`
- Base project ref observed at approval sync: `1e75e5dc871ce1ce4d547b0521f6e9b680c46684`

## Decision

괴이기록국의 일반 조사 화면은 캐릭터 상시 전면 노출형 HUD가 아니라 **장면 이미지 + 서술 + 선택지** 중심으로 구성한다.

조사에서 획득한 `raw observation / record / keyword / risk case`를 별도의 **괴이 매뉴얼·추리 화면**에서 사용해 추리문과 경쟁 가설을 구성한다. 조사와 추리를 한 화면에 과밀하게 섞지 않는다.

캐릭터는 현장 조사 중 상시 주인공처럼 크게 노출하지 않는다. 화면의 주체는 **장소·사건·이상 현상·증거**다. 캐릭터는 필요한 순간에만 노출하고, 회수 페이즈에서는 평소 소형 상태 표현을 사용하며 스킬 발동·결정적 지원 때 짧은 Cut-in을 허용한다.

## Approved presentation contract

### Investigation

```text
scene image
→ short observation/narration
→ 2–4 choices
→ observation / record / keyword / risk / cost
→ next scene or manual
```

- 장면/현장과 본문이 화면의 주 정보다.
- 핵심 키워드의 유일한 획득 경로를 확률 판정에 잠그지 않는다.
- 능력·동료·장비는 추가 맥락, 안전성, 비용, 위험, 재확인 편의를 바꾸되 정답을 대신하지 않는다.
- 실패는 가능하면 `nothing happened`가 아니라 위험 사례·비용·다른 관측을 남기는 실패 전진으로 처리한다.

### Deduction / Anomaly Manual

```text
records + keywords
→ provenance check
→ competing hypotheses
→ support / refute / unresolved
→ inference sentence
→ manual semantic slot promotion
```

- 조사에서 실제 확보한 키워드만 사용한다.
- 키워드마다 출처 기록을 되짚을 수 있어야 한다.
- 경쟁 가설을 최소 2개 동시에 유지할 수 있다.
- 정답 후보를 색·크기·위치로 미리 강조하지 않는다.
- 근거가 부족하면 언제든 현장으로 돌아갈 수 있다.

### Character exposure levels

- `L0 GENERAL_INVESTIGATION`: 큰 캐릭터 일러스트 없음. 배경·증거·본문 우선.
- `L1 SUPPORT_LINE`: 이름 + 짧은 문장 또는 작은 Portrait.
- `L2 IMPORTANT_NARRATIVE`: 피해자 접촉·관계 결정 등에서 제한적인 반신/장면 일러스트.
- `L3 RECOVERY_SKILL_CUTIN`: 회수 스킬·결정적 지원 때 짧은 Cut-in.
- `L4 PROFILE_PREPARATION`: 도감·편성·프로필에서 전신/상세 캐릭터 사용.

상시 전신 배치나 캐릭터 대화 중심 연출로 조사 현장의 판독을 가리는 방향은 승인 target이 아니다.

## Visual style

- Main art: user-selected soft anime noir / restrained urban occult illustration direction.
- Environment: modern Korean lived-in spaces, more grounded than the anomaly layer.
- Pixel/dot: supporting observation language only.
- Preferred pixel use: clean cluster-based UI/markers/log/CCTV/sensor/noise/map/VFX.
- Do not pixelate the main character portraits or convert the whole investigation surface to pixel art by default.

## Rationale

1. 배경·현장보다 캐릭터 얼굴/손/복잡한 의상에서 생성형 이미지의 비일관성이 더 잘 드러날 수 있으므로 상시 노출을 줄인다.
2. 플레이어의 시선을 캐릭터 대화보다 **현장 관찰 → 기록 비교 → 가설 수정**에 둔다.
3. 캐릭터 일러스트 사용량을 줄여 적은 수의 핵심 컷을 더 엄격하게 품질 관리한다.
4. 스킬 Cut-in과 중요 관계 장면의 희소성을 높여 캐릭터 등장 자체가 보상으로 느껴지게 한다.
5. M01~M12 Standard/Signature 사건 모두 같은 화면 문법을 재사용하기 쉽다.

## Current system alignment

이 결정은 다음 제품 코어를 변경하지 않고 표현 계층을 정리한다.

```text
monthly preparation
→ investigation
→ deduction / anomaly manual
→ victim rescue
→ telegraph-based recovery
→ composite result
```

- 피해자 구출과 회수 페이즈는 계속 필수다.
- 회수는 HP 0 처치가 아니라 보호·관찰·대응·공격·장비·봉쇄·후퇴를 사용해 안정화/봉쇄/잔향 회수하는 구조다.
- 캐릭터 노출 감소는 동료 기능 삭제를 뜻하지 않는다.

## Out of scope / still not approved

- Godot Scene/Node/Resource 변경
- runtime UI 구현
- episode JSON 변경
- save/schema 변경
- 생성 이미지의 제품 자산 승격
- Human QA PASS 선언
- 1280×720 / 1920×1080 실제 런타임 시각 검증 PASS 선언

## Next gate

1. Notion/GitHub current work order와 승인 로그 동기화.
2. 환경 중심 `Investigation Anchor` 시안 검토.
3. 같은 브랜드 언어의 `Deduction / Manual Anchor` 시안 검토.
4. `Recovery`에서 anomaly/telegraph 중심 + skill Cut-in 시안 검토.
5. 승인 시 레이어/재사용 자산 계약 작성.
6. 전체 기획 완료 선언 이후에만 latest main 재조회 → Codex/HiGodot 구현 계약으로 전환.
